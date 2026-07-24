local DarkBerryMenu, super = Class(Object)

function DarkBerryMenu:init()
    super.init(self, 82, 112, 477, 277)
    self.draw_children_below = 0
    self.bg = UIBox(0, 0, self.width, self.height)
    self.bg.layer = -1
    self.bg.debug_select = false
    self:addChild(self.bg)
    self.state = "SELECT"
    self.selected_option = 1
    self.berry_list_offset = 0
    self.holding_timer = 0
    self.held_timer = 0
    self.current_pocket = "BERRIES"
end

function DarkBerryMenu:getBerries()
    local raw_storage = Game.inventory:getStorage("items") or {}
    local berries = {}
    for _, item in ipairs(raw_storage) do
        if item and item.berry_type then
            table.insert(berries, item)
        end
    end
    return berries
end

function DarkBerryMenu:getSeeds()
    local raw_storage = Game.inventory:getStorage("items") or {}
    local seeds = {}
    for _, item in ipairs(raw_storage) do
        if item and item.seed_type then
            table.insert(seeds, item)
        end
    end
    return seeds
end

function DarkBerryMenu:getCurrentDisplayList()
    if self.current_pocket == "SEEDS" then
        return self:getSeeds()
    end
    return self:getBerries()
end

function DarkBerryMenu:getSelectedBerry()
    return self:getCurrentDisplayList()[self.selected_option]
end

function DarkBerryMenu:updateSelectedItem()
    local berry = self:getSelectedBerry()
    if berry and Game.world.menu then
        Game.world.menu:setDescription(berry:getDescription(), true)
    end
end

function DarkBerryMenu:getEmptyMessage()
    if self.current_pocket == "SEEDS" then
        return "No Seeds!"
    end
    return "No Berries!"
end

function DarkBerryMenu:handleMenuScroll()
    local pressed_up = Input.pressed("up")
    local pressed_down = Input.pressed("down")
    local held_up = Input.down("up")
    local held_down = Input.down("down")
    local repeat_up = (held_up and self.holding_timer > 1 and self.held_timer > 6)
    local repeat_down = (held_down and self.holding_timer > 1 and self.held_timer > 6)

    local current_items = self:getCurrentDisplayList()
    local total_items = #current_items
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

function DarkBerryMenu:update()
    local active_count = (self.selected_option == 2) and #self:getSeeds() or #self:getBerries()

    if self.state == "SELECT" then
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
        if Input.pressed("up") or Input.pressed("down") then
            Assets.stopAndPlaySound("ui_move")
            self.selected_option = (self.selected_option == 2) and 1 or 2
        end
        if Input.pressed("confirm") then
            if active_count == 0 then
                Assets.stopAndPlaySound("ui_cant_select")
                return
            end
            
            Assets.stopAndPlaySound("ui_select")
            if self.selected_option == 1 then
                self.current_pocket = "BERRIES"
            else
                self.current_pocket = "SEEDS"
            end
            self.state = "VIEW_BAG" 
            self.selected_option = 1
            self:updateSelectedItem()
        end
    elseif self.state == "VIEW_BAG" then
        if Input.pressed("cancel") then
            Assets.stopAndPlaySound("ui_cancel_small")
            self.selected_option = (self.current_pocket == "SEEDS") and 2 or 1
            self.state = "SELECT"
            Game.world.menu:setDescription("", false)
        else
            self:handleMenuScroll()

            if Input.pressed("confirm") then
                local selected_berry = self:getSelectedBerry()
                if selected_berry then
                    Assets.stopAndPlaySound("ui_select")
                    
                    if selected_berry.usable_in == "world" or selected_berry.usable_in == "all" then
                        self.state = "PARTY_SELECT" 
                        Game.world.menu:partySelect("SINGLE", function(success, party)
                            self.state = "VIEW_BAG"
                            if success and party then
                                selected_berry:onWorldUse(party)
                                Game.inventory:removeItem(selected_berry)
                            end
                            self:updateSelectedItem()
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


function DarkBerryMenu:drawSidebarHeaders(name_options)
    name_options = name_options or {"Berry Bag", "Seeds"}
    for i, option_name in ipairs(name_options) do 
        if self.state == "SELECT" and self.selected_option == i then
            Draw.setColor(PALETTE["world_header_selected"])
        else
            if self.state == "VIEW_BAG" and ((self.current_pocket == "BERRIES" and i == 1) or (self.current_pocket == "SEEDS" and i == 2)) then
                Draw.setColor(PALETTE["world_header_selected"])
            else
                Draw.setColor(PALETTE["world_header"])
            end
        end
        love.graphics.print(option_name, 26, 6 + ((i - 1) * 32))
    end
end

function DarkBerryMenu:draw()
    love.graphics.setFont(Assets.getFont("main"))
    Draw.setColor(PALETTE["world_border"])
    love.graphics.rectangle("fill", 188, -24,  6,  322)
    love.graphics.rectangle("fill", -24, 120, 218,  6)
    Draw.setColor(Game:getSoulColor())
    if self.state == "SELECT" then
        Draw.draw(Assets.getTexture("player/heart"), 0, 16 + ((self.selected_option - 1) * 32))
    elseif self.state == "VIEW_BAG" then
        if self.selected_option < self.berry_list_offset + 1 then
            self.berry_list_offset = self.selected_option - 1
        end
        if self.selected_option > self.berry_list_offset + 9 then
            self.berry_list_offset = self.selected_option - 9
        end

        Draw.draw(Assets.getTexture("player/heart"), 180 + 54 - 26 - 8, 16 + ((self.selected_option - self.berry_list_offset - 1) * 30))
    end
    
    self:drawSidebarHeaders()
    local current_items = {}
    local empty_msg = ""
    
    if self.state == "SELECT" then
        if self.selected_option == 2 then
            current_items = self:getSeeds()
            empty_msg = "No Seeds!"
        else
            current_items = self:getBerries()
            empty_msg = "No Berries!"
        end
    else
        current_items = self:getCurrentDisplayList()
        empty_msg = self:getEmptyMessage()
    end
    
    if (#current_items == 0) then
        Draw.setColor(PALETTE["world_gray"])
        love.graphics.print(empty_msg, 280, 8)
    end
    
    local item_y = 0
    for i = self.berry_list_offset + 1, self.berry_list_offset + 9 do
        local item = current_items[i]
        if item then
            Draw.setColor(PALETTE["world_text_shadow"])
            local name = item:getName()
            love.graphics.print(name, 180 + 54 + 2 - 8, 6 + (item_y * 30) + 2)
            Draw.setColor(1, 1, 1, 1)
            if i == self.selected_option and self.state == "VIEW_BAG" then 
                Draw.setColor(PALETTE["world_header_selected"]) 
            end
            love.graphics.print(name, 180 + 54 - 8, 6 + (item_y * 30))
            item_y = item_y + 1
        end
    end
    Draw.setColor(1, 1, 1, 1)
    local sine_off = math.sin((Kristal.getTime()*30)/6) * 3
    if self.berry_list_offset + 9 < #current_items then
        Draw.draw(Assets.getTexture("ui/page_arrow_down"), 476, 149 + sine_off + 105)
    end
    if self.berry_list_offset > 0 then
        Draw.draw(Assets.getTexture("ui/page_arrow_down"), 476, 8 - sine_off + 16, 0, 1, -1)
    end

    super.draw(self)
end


return DarkBerryMenu
