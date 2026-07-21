---@class DarkItemMenu
local DarkItemMenu, super = HookSystem.hookScript(DarkItemMenu)

function DarkItemMenu:init(...)
    super.init(self, ...)

    self.arrow = Assets.getTexture("ui/flat_arrow_left")

    self.page = 1
end

function DarkItemMenu:getLastPage()
    if not Kristal.getLibConfig("better_inventory", "storageMode") then
        return math.ceil(#self:getCurrentStorage() / 12)
    else
        return math.ceil(self:getCurrentStorage()["max"] / 12)
    end
end

function DarkItemMenu:updateSelectedItem()
    if not Game.world.menu or (Game.world.menu ~= self.parent) then -- will be true if an item creates a new menu
        return
    end

    local items = self:getCurrentStorage()

    if not Kristal.getLibConfig("better_inventory", "storageMode") then
        super.updateSelectedItem(self)
    elseif Kristal.getLibConfig("better_inventory", "storageMode") then
        if items.max == 0 then
            self.state = "MENU"
            Game.world.menu:setDescription("", false)
        else
            if self.selected_item > items.max then
                self.item_selected_x = (items.max - 1) % 2 + 1
                self.item_selected_y = math.floor((items.max - 1) / 2) + 1
                self.selected_item = (2 * (self.item_selected_y - 1) + self.item_selected_x)
            elseif self.selected_item < 1 then
                self.item_selected_x = 1
                self.item_selected_y = 1
                self.selected_item = 1
            end
        end
    end

    if (Kristal.getLibConfig("better_inventory", "storageMode") and items.max ~= 0) or (#items ~= 0) then
        if self.selected_item <= (12 * (self.page - 1)) then
            self.item_selected_y = (6 * (self.page - 1)) + 1
            self.selected_item = (2 * (self.item_selected_y - 1) + self.item_selected_x)
        elseif self.selected_item > (12 * self.page) then
            self.item_selected_y = (6 * (self.page))
            self.selected_item = (2 * (self.item_selected_y - 1) + self.item_selected_x)
        end
    end

    if items[self.selected_item] then
        Game.world.menu:setDescription(items[self.selected_item]:getDescription(), true)
    else
        Game.world.menu:setDescription("", true)
    end
end

function DarkItemMenu:update()
    if self.state == "MENU" then
        self.page = 1
    elseif self.state == "SELECT" then
        local old_page = self.page

        local input, edge
        if Input.pressed("left") and self.item_selected_x == 1 then
            input = "left"
            if self.page == 1 and self:getLastPage() < math.huge then
                edge = true
                self.page = self:getLastPage()
            else
                self.page = self.page - 1
            end
        end
        local max = (Kristal.getLibConfig("better_inventory", "storageMode") and self:getCurrentStorage()["max"]) or #self:getCurrentStorage()
        if Input.pressed("right") and (self.item_selected_x == 2 or self.selected_item == max) then
            input = "right"
            if self.page == self:getLastPage() then
                edge = true
                self.page = 1
            else
                self.page = self.page + 1
            end
        end

        self.page = MathUtils.clamp(self.page, 1, self:getLastPage())

        if old_page ~= self.page then
            if not edge then
                if input == "left" then
                    self.item_selected_y = self.item_selected_y - 6
                elseif input == "right" then
                    self.item_selected_y = self.item_selected_y + 6
                end
            elseif edge then
                if input == "left" then
                    self.item_selected_y = self.item_selected_y + ((self:getLastPage() - 1) * 6)
                    -- Very specific edge case of "ui_move" sound not playing for some reason.
                    if not self:getCurrentStorage()[(2 * (self.item_selected_y - 1) + 2)] then
                        Assets.stopAndPlaySound("ui_move")
                    end
                elseif input == "right" then
                    if self.selected_item == max and self.item_selected_x ~= 2 then
                        self.item_selected_x = 2
                    end
                    self.item_selected_y = MathUtils.wrap(self.item_selected_y % 6, 1, 7)
                end
            end
        end

        if Input.pressed("cancel") then
            self.ui_cancel_small:stop()
            self.ui_cancel_small:play()
            self.state = "MENU"

            Game.world.menu:setDescription("", false)
            return
        end
        local old_x, old_y = self.item_selected_x, self.item_selected_y
        if Input.pressed("left") or Input.pressed("right") then
            if self.item_selected_x == 1 and not (Input.pressed("left") and self:getLastPage() >= math.huge and self.page == 1) then
                self.item_selected_x = 2
            else
                self.item_selected_x = 1
            end
        end
        if Input.pressed("up") then
            self.item_selected_y = self.item_selected_y - 1
        end
        if Input.pressed("down") then
            self.item_selected_y = self.item_selected_y + 1
        end
        local items = self:getCurrentStorage()
        if self.item_selected_y < 1 then self.item_selected_y = 1 end
        if (2 * (self.item_selected_y - 1) + self.item_selected_x) > max then
            if (max % 2) ~= 0 then
                self.item_selected_x = ((max - 1) % 2) + 1
            end
            self.item_selected_y = math.floor((max - 1) / 2) + 1
        end
        self.selected_item = (2 * (self.item_selected_y - 1) + self.item_selected_x)
        
        if self.item_selected_y ~= old_y or self.item_selected_x ~= old_x then
            self:updateSelectedItem()
            if self.item_selected_y ~= old_y or self.item_selected_x ~= old_x then
                Assets.stopAndPlaySound("ui_move")
            end
            
        end
        if Input.pressed("confirm") then
            local item = items[self.selected_item]
            if not item then
                Assets.stopAndPlaySound("ui_cant_select")
                return super.super.update(self)
            end
            if self.item_header_selected == 2 then
                self.state = "USE"

                Assets.stopAndPlaySound("ui_select")

                Game.world.menu:setDescription("Really throw away the\n" .. item:getName() .. "?")
                Game.world.menu:partySelect("ALL", function(success, party)
                    self.state = "SELECT"
                    if success then
                        Assets.stopAndPlaySound("ui_cancel_small")

                        local result = item:onToss()

                        if result ~= false then
                            Game.inventory:removeItem(item)
                        end
                    end
                    self:updateSelectedItem()
                end)
            elseif item.usable_in == "world" or item.usable_in == "all" then
                if item:getTarget() == "ally" or item:getTarget() == "party" then
                    self.state = "USE"

                    local target_type = item:getTarget() == "ally" and "SINGLE" or "ALL"

                    if target_type == "SINGLE" then -- yep, deltarune bug
                        Assets.stopAndPlaySound("ui_select")
                    end

                    Game.world.menu:partySelect(target_type, function(success, party)
                        self.state = "SELECT"
                        if success then
                            self:useItem(item, party)
                        end
                        self:updateSelectedItem()
                    end)
                else
                    self:useItem(item, Game.party)
                end
            else
                Assets.stopAndPlaySound("ui_cant_select")
            end
            super.super.update(self)
        end
    end

    if self.state ~= "SELECT" then
        super.update(self)
    end
end

function DarkItemMenu:getPointSpacing()
    if self:getLastPage() <= 8 then
        return 25
    else
        return 55 - (self:getLastPage() * 2)
    end
end

function DarkItemMenu:draw()
    love.graphics.setFont(self.font)

    local headers = {"USE", "TOSS", "KEY"}

    for i,name in ipairs(headers) do
        if self.state == "MENU" then
            Draw.setColor(PALETTE["world_header"])
        elseif self.item_header_selected == i then
            Draw.setColor(PALETTE["world_header_selected"])
        else
            Draw.setColor(PALETTE["world_gray"])
        end
        local x = 88 + ((i - 1) * 120)
        love.graphics.print(name, x, -2)
    end

    local heart_x = 20
    local heart_y = 20

    if self.state == "MENU" then
        heart_x = 88 + ((self.item_header_selected - 1) * 120) - 25
        heart_y = 8
    elseif self.state == "SELECT" then
        heart_x = 28 + (self.item_selected_x - 1) * 210
        heart_y = 50 + ((self.item_selected_y - 1) - (6 * (self.page - 1))) * 30
    end
    if self.state ~= "USE" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, heart_x, heart_y)
    end

    local item_x = 0
    local item_y = 0
    local inventory = self:getCurrentStorage()
    local max_index = MathUtils.clamp((12 * self.page), 0, (Kristal.getLibConfig("better_inventory", "storageMode") and inventory["max"]) or #inventory)
    for index = 1 + (12 * (self.page - 1)), max_index do
        local item = inventory[index]
        -- Draw the item shadow
        Draw.setColor(PALETTE["world_text_shadow"])
        local name = item and item:getWorldMenuName() or "------"
        love.graphics.print(name, 54 + (item_x * 210) + 2, 40 + (item_y * 30) + 2)

        if self.state == "MENU" or not item then
            Draw.setColor(PALETTE["world_gray"])
        else
            if item.usable_in == "world" or item.usable_in == "all" then
                Draw.setColor(PALETTE["world_text"])
            else
                Draw.setColor(PALETTE["world_text_unusable"])
            end
        end
        love.graphics.print(name, 54 + (item_x * 210), 40 + (item_y * 30))
        item_x = item_x + 1
        if item_x >= 2 then
            item_x = 0
            item_y = item_y + 1
        end
    end

    for index = 1 + (12 * (self.page - 1)), max_index do
        local item = inventory[index]
        if not item then
            break
        end
        Draw.setColor(1,1,1)
        item:onMenuDraw(self.parent)
    end

    Draw.setColor(1,1,1)
    -- Code for the arrows and dots.    
    if self:getLastPage() > 1 or Kristal.getLibConfig("better_inventory", "alwaysShowIndicator") then

        if Kristal.getLibConfig("better_inventory", "showArrows") then
            -- The arrows
            if self.state == "MENU" then
                Draw.setColor(0.5, 0.5, 0.5)
            else
                Draw.setColor(1, 1, 1)
            end
            local offset = MathUtils.round(math.sin(Kristal.getTime() * 5)) * 2

            if self:getLastPage() < math.huge or self.page ~= 1 then
                Draw.draw(self.arrow, 0 - offset,          MathUtils.round((self.height - self.arrow:getHeight()) / 2),       0,       2, 2)
            end
            Draw.draw(self.arrow, self.width + offset, MathUtils.round((self.height / 2) + self.arrow:getHeight() * 1.5), math.pi, 2, 2)
        end

        local mult_color = 1
        if self.state == "MENU" then
            mult_color = 0.5
        end
        if self:getLastPage() < math.huge and not Kristal.getLibConfig("better_inventory", "pageNumber") then
            -- The dots
            -- Thanks Simbel for the spacing
            local total_width = 0
            for i = 1, self:getLastPage() do
                total_width = total_width + 3
                if i < self:getLastPage() then
                    total_width = total_width + self:getPointSpacing()
                end
            end
            local center = self.width / 2
            local x = center - total_width / 2

            for index = 1, self:getLastPage() do
                if self.page == index then
                    Draw.setColor(0.2 * mult_color, 0.1 * mult_color, 0.2 * mult_color)
                    Draw.rectangle("fill", x - 1 + 2, 230 - 3 + 2, 6, 6)
                    Draw.setColor(1 * mult_color, 1 * mult_color, 1 * mult_color)
                    Draw.rectangle("fill", x - 1, 230 - 3, 6, 6)
                else
                    Draw.setColor(0.2 * mult_color, 0.1 * mult_color, 0.2 * mult_color)
                    Draw.rectangle("fill", x + 1, 230 - 1.5 + 1, 3, 3)
                    Draw.setColor(0.5 * mult_color, 0.5 * mult_color, 0.5 * mult_color)
                    Draw.rectangle("fill", x, 230 - 1.5, 3, 3)
                end
                
                x = x + self:getPointSpacing() + 3
            end
        else
            local font = Kristal.getLibConfig("better_inventory", "smallFontIndicator") and Assets.getFont("small") or self.font
            local offset_y = Kristal.getLibConfig("better_inventory", "smallFontIndicator") and 0 or -12
            love.graphics.setFont(font)

            local icon
            local text = "PAGE: " .. self.page .. "/"
            local offset_x = 0

            if self:getLastPage() < math.huge then
                text = text .. self:getLastPage()
            else
                icon = Assets.getTexture("kristal/menu_infinity")
                offset_x = icon:getWidth()
            end
            Draw.setColor(0.2 * mult_color, 0.1 * mult_color, 0.2 * mult_color)
            Draw.printAlign(text, self.width/2 - offset_x + 2, 226 + offset_y + 2, "center")
            Draw.setColor(1 * mult_color, 1 * mult_color, 1 * mult_color)
            Draw.printAlign(text, self.width/2 - offset_x, 226 + offset_y, "center")

            if icon then
                local diff = MathUtils.round((icon:getHeight() - font:getHeight(text)) / 2)
                Draw.setColor(0.2 * mult_color, 0.1 * mult_color, 0.2 * mult_color)
                Draw.draw(icon, math.ceil(self.width/2 + font:getWidth(text)/2 - icon:getWidth()) + 2, 226 + diff + offset_y + 2)
                Draw.setColor(1 * mult_color, 1 * mult_color, 1 * mult_color)
                Draw.draw(icon, math.ceil(self.width/2 + font:getWidth(text)/2 - icon:getWidth()), 226 + diff + offset_y)
            end
        end
    end

    Draw.setColor(1, 1, 1, 1)

    super.super.draw(self)
end

return DarkItemMenu