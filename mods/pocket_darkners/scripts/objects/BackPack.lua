local BackPack, super = Class(Object)

function BackPack:init()
    super.init(self, 82, 112, 477, 277)
    self.draw_children_below = 0
    self.bg = UIBox(0, 0, self.width, self.height)
    self.bg.layer = -1
    self.bg.debug_select = false
    self:addChild(self.bg)
    
    self.state = "POCKET_SELECT"
    self.selected_option = 1
    self.current_pocket_index = 1
    
    self.list_offset = 0
    self.holding_timer = 0
    self.held_timer = 0
    self.pockets = {
        { id = "MEDICINE",  name = "Medicine" },
        { id = "ITEMS",     name = "Items" },
        { id = "TMS",       name = "TMs" },
        { id = "BERRIES",   name = "Berries" },
        { id = "SEEDS",     name = "Seeds" },
        { id = "KEY_ITEMS", name = "Key Items" }
    }

    table.sort(self.pockets, function(a, b)
        return string.lower(a.name) < string.lower(b.name)
    end)
end
-- UNIVERSAL HARVESTER: Sweeps all storage pools and processes multi-type elements
function BackPack:getItemsInPocket(pocket_id)
    local filtered_items = {}
    local storage_pools = {"items", "key", "light"}
    
    for _, pool in ipairs(storage_pools) do
        local raw_storage = Game.inventory:getStorage(pool) or {}
        for _, item in ipairs(raw_storage) do
            if item then
                local target_id = string.lower(pocket_id)
                local match = false
                
                if type(item.backpack_type) == "table" then
                    for _, t in ipairs(item.backpack_type) do
                        if string.lower(t) == target_id then match = true break end
                    end
                elseif type(item.backpack_type) == "string" then
                    if string.lower(item.backpack_type) == target_id then match = true end
                end
                
                if match then
                    table.insert(filtered_items, item)
                end
            end
        end
    end
    
    table.sort(filtered_items, function(a, b)
        return string.lower(a:getName()) < string.lower(b:getName())
    end)
    
    return filtered_items
end

function BackPack:getCurrentDisplayList()
    local active_pocket = self.pockets[self.current_pocket_index]
    if not active_pocket then return {} end
    return self:getItemsInPocket(active_pocket.id)
end

function BackPack:getSelectedItem()
    return self:getCurrentDisplayList()[self.selected_option]
end

function BackPack:updateSelectedItem()
    local item = self:getSelectedItem()
    if item and Game.world.menu then
        Game.world.menu:setDescription(item:getDescription(), true)
    -- else
    --     Game.world.menu:setDescription(self:getEmptyMessage(), true)
    end
end

function BackPack:getEmptyMessage()
    local target_index = (self.state == "POCKET_SELECT") and self.selected_option or self.current_pocket_index
    local active_pocket = self.pockets[target_index]
    return "No " .. (active_pocket and active_pocket.name or "Items") .. "!"
end

-- CORE GAME MECHANIC: Using the item with healthbar status adjustments intact
function BackPack:useItem(item, party)
    local result = item:onWorldUse(party)
    if isClass(party) then
        party = {party}
    end
    for _, char in ipairs(party) do
        for index, chara in ipairs(Game.party) do
            local reaction = chara:getReaction(item, char)
            if reaction then
                Game.world.healthbar.action_boxes[index].reaction_alpha = 50
                Game.world.healthbar.action_boxes[index].reaction_text = reaction
            end
        end
    end
    if (item.type == "item" and (result == nil or result)) or (item.type ~= "item" and result) then
        if item:hasResultItem() then
            Game.inventory:replaceItem(item, item:createResultItem())
        else
            Game.inventory:removeItem(item)
        end
    end
    self:updateSelectedItem()
end

function BackPack:handleMenuScroll(total_items)
    local pressed_up = Input.pressed("up")
    local pressed_down = Input.pressed("down")
    local held_up = Input.down("up")
    local held_down = Input.down("down")
    local repeat_up = (held_up and self.holding_timer > 1 and self.held_timer > 6)
    local repeat_down = (held_down and self.holding_timer > 1 and self.held_timer > 6)

    if total_items == 0 then return end

    if pressed_up or repeat_up then
        self.holding_timer = 0
        if (self.selected_option == 1 and repeat_up) then return end

        Assets.stopAndPlaySound("ui_move")
        self.selected_option = (self.selected_option == 1) and total_items or self.selected_option - 1
        self:updateSelectedItem()
    elseif pressed_down or repeat_down then
        self.holding_timer = 0
        if (self.selected_option == total_items and repeat_down) then return end

        Assets.stopAndPlaySound("ui_move")
        self.selected_option = (self.selected_option == total_items) and 1 or self.selected_option + 1
        self:updateSelectedItem()
    end

    if (held_up or held_down) then
        self.holding_timer = self.holding_timer + DTMULT
        self.held_timer = self.held_timer + DTMULT
    else
        self.held_timer = 0
        self.holding_timer = 0
    end
end

function BackPack:update()
    if self.state == "POCKET_SELECT" then
        if Input.pressed("confirm") then
            local targeted_pocket = self.pockets[self.selected_option]
            local item_count = #self:getItemsInPocket(targeted_pocket.id)
            if item_count == 0 then
                Assets.stopAndPlaySound("ui_cant_select")
                return
            end
            Assets.stopAndPlaySound("ui_select")
            self.current_pocket_index = self.selected_option
            self.state = "ITEM_SELECT" 
            self.selected_option = 1
            self.list_offset = 0
            self:updateSelectedItem()
        end
        if Input.pressed("cancel") then
            Assets.stopAndPlaySound("ui_cancel_small")   
            if self.parent and self.parent.state == "BERRYMENU" then
                self.parent.state = "MAIN"
            end
            Game.world.menu:closeBox()
            Game.world.menu:setDescription("", false)
            self:remove()
            return
        end
        
        local total_pockets = #self.pockets
        if Input.pressed("up") then
            Assets.stopAndPlaySound("ui_move")
            self.selected_option = (self.selected_option == 1) and total_pockets or self.selected_option - 1
        elseif Input.pressed("down") then
            Assets.stopAndPlaySound("ui_move")
            self.selected_option = (self.selected_option == total_pockets) and 1 or self.selected_option + 1
        end
        
        if Input.pressed("confirm") then
            Assets.stopAndPlaySound("ui_select")
            self.current_pocket_index = self.selected_option
            self.state = "ITEM_SELECT" 
            self.selected_option = 1
            self.list_offset = 0
            self:updateSelectedItem()
        end

    elseif self.state == "ITEM_SELECT" then
        if Input.pressed("cancel") then
            Assets.stopAndPlaySound("ui_cancel_small")
            self.selected_option = self.current_pocket_index
            self.state = "POCKET_SELECT"
            Game.world.menu:setDescription("", false)
        else
            local current_items = self:getCurrentDisplayList()
            self:handleMenuScroll(#current_items)

            if Input.pressed("confirm") then
                local selected_item = self:getSelectedItem()
                if selected_item then
                    local is_usable = selected_item.usable_in == "world" or selected_item.usable_in == "all"
                    local has_effect = selected_item.onWorldUse ~= nil
                    
                    if is_usable and has_effect then
                        Assets.stopAndPlaySound("ui_select")
                        self.state = "PARTY_SELECT" 
                        Game.world.menu:partySelect("SINGLE", function(success, party)
                            self.state = "ITEM_SELECT"
                            if success and party then
                                self:useItem(selected_item, party)
                            end
                        end)
                    else
                        Assets.stopAndPlaySound("ui_cant_select")
                    end
                end
            end
        end
    end
    super.update(self)
end

function BackPack:drawSidebarHeaders()
    for i, pocket_data in ipairs(self.pockets) do 
        if self.state == "POCKET_SELECT" and self.selected_option == i then
            Draw.setColor(PALETTE["world_header_selected"])
        else
            if self.state == "ITEM_SELECT" and self.current_pocket_index == i then
                Draw.setColor(PALETTE["world_header_selected"])
            else
                Draw.setColor(PALETTE["world_header"])
            end
        end
        love.graphics.print(pocket_data.name, 26, 6 + ((i - 1) * 32))
    end
end

function BackPack:draw()
    love.graphics.setFont(Assets.getFont("main"))
    Draw.setColor(PALETTE["world_border"])
    love.graphics.rectangle("fill", 188, -24,  6,  322)
    local dynamic_divider_y = 6 + (#self.pockets * 32) + 12
    love.graphics.rectangle("fill", -24, dynamic_divider_y, 218, 6)
    
    Draw.setColor(Game:getSoulColor())
    if self.state == "POCKET_SELECT" then
        Draw.draw(Assets.getTexture("player/heart"), 0, 16 + ((self.selected_option - 1) * 32))
    elseif self.state == "ITEM_SELECT" then
        if self.selected_option < self.list_offset + 1 then
            self.list_offset = self.selected_option - 1
        end
        if self.selected_option > self.list_offset + 9 then
            self.list_offset = self.selected_option - 9
        end
        Draw.draw(Assets.getTexture("player/heart"), 180 + 54 - 26 - 8, 16 + ((self.selected_option - self.list_offset - 1) * 30))
    end
    
    self:drawSidebarHeaders()
    
    local current_items = {}
    local empty_msg = ""
    if self.state == "POCKET_SELECT" then
        local preview_pocket = self.pockets[self.selected_option]
        current_items = preview_pocket and self:getItemsInPocket(preview_pocket.id) or {}
        empty_msg = preview_pocket and ("No " .. preview_pocket.name .. "!") or "Empty!"
    else
        current_items = self:getCurrentDisplayList()
        empty_msg = self:getEmptyMessage()
    end
    
    if (#current_items == 0) then
        Draw.setColor(PALETTE["world_gray"])
        love.graphics.print(empty_msg, 280, 8)
    end
    
    local item_y = 0
    for i = self.list_offset + 1, self.list_offset + 9 do
        local item = current_items[i]
        if item then
            Draw.setColor(PALETTE["world_text_shadow"])
            local name = item:getName()
            love.graphics.print(name, 180 + 54 + 2 - 8, 6 + (item_y * 30) + 2)
            Draw.setColor(1, 1, 1, 1)
            
            if i == self.selected_option and self.state == "ITEM_SELECT" then 
                Draw.setColor(PALETTE["world_header_selected"]) 
            end
            love.graphics.print(name, 180 + 54 - 8, 6 + (item_y * 30))
            item_y = item_y + 1
        end
    end
    
    Draw.setColor(1, 1, 1, 1)
    local sine_off = math.sin((Kristal.getTime()*30)/6) * 3
    if self.list_offset + 9 < #current_items then
        Draw.draw(Assets.getTexture("ui/page_arrow_down"), 476, 149 + sine_off + 105)
    end
    if self.list_offset > 0 then
        Draw.draw(Assets.getTexture("ui/page_arrow_down"), 476, 8 - sine_off + 16, 0, 1, -1)
    end

    super.draw(self)
end

return BackPack
