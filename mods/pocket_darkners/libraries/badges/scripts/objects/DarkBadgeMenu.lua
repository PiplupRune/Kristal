---@class DarkBadgeMenu : Object
---@overload fun(...) : DarkBadgeMenu
local DarkBadgeMenu, super = Class(Object)

function DarkBadgeMenu:init()
    super.init(self, 82, 112, 477, 277)

    self.draw_children_below = 0

    self.bg = UIBox(0, 0, self.width, self.height)
    self.bg.layer = -1
    self.bg.debug_select = false
    self:addChild(self.bg)

    -- SELECT, ALL, EQUIPPED
    self.state = "SELECT"
    self.selected_option = 1
    self.badge_list_offset = 0

    -- Naive keyrepeat -- it's only two keys (up and down) so this should be fine
    self.holding_timer = 0
    self.held_timer = 0
end

function DarkBadgeMenu:getCurrentBadgeState()
    local state = "ALL"
    if self.state == "EQUIPPED" or (self.state == "SELECT" and self.selected_option == 2) then
        state = "EQUIPPED"
    end
    return state
end

function DarkBadgeMenu:getStorage()
    return BadgesLib:getStorage()
end

function DarkBadgeMenu:getBadges(state)
    local badge_state = state or self:getCurrentBadgeState()
    if badge_state == "ALL" then
        return self:getStorage()
    end

    local items = {}
    for _, badge in ipairs(self:getStorage()) do
        if badge.equipped then
            table.insert(items, badge)
        end
    end
    return items
end

function DarkBadgeMenu:getSelectedBadge()
    return self:getBadges()[self.selected_option]
end

function DarkBadgeMenu:updateSelectedItem()
    local badge = self:getSelectedBadge()
    if badge then
        Game.world.menu:setDescription(badge:getDescription(), true)
    end
end

function DarkBadgeMenu:handleMenuScroll()
    local pressed_up = Input.pressed("up")
    local pressed_down = Input.pressed("down")
    local held_up = Input.down("up")
    local held_down = Input.down("down")
    local repeat_up = (held_up and self.holding_timer > 1 and self.held_timer > 6)
    local repeat_down = (held_down and self.holding_timer > 1 and self.held_timer > 6)

    if pressed_up or repeat_up then
        self.holding_timer = 0

        if (self.selected_option == 1 and repeat_up) then
            -- short circuit -- we don't want to wrap around if we're holding down the key!
            return
        end

        Assets.stopAndPlaySound("ui_move")
        self.selected_option = (self.selected_option == 1) and #self:getBadges() or self.selected_option - 1
        self:updateSelectedItem()
    elseif pressed_down or repeat_down then
        self.holding_timer = 0

        if (self.selected_option == #self:getBadges() and repeat_down) then
            -- short circuit -- we don't want to wrap around if we're holding down the key!
            return
        end

        Assets.stopAndPlaySound("ui_move")
        self.selected_option = (self.selected_option == #self:getBadges()) and 1 or self.selected_option + 1
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

function DarkBadgeMenu:update()
    if self.state == "SELECT" then
        if Input.pressed("cancel") then
            Assets.stopAndPlaySound("ui_cancel_small")
            Game.world.menu:closeBox()
            Game.world.menu:setDescription("", false)
            return
        end
        if Input.pressed("up") or Input.pressed("down") then
            Assets.stopAndPlaySound("ui_move")
            self.selected_option = (self.selected_option == 2) and 1 or 2
        end

        if Input.pressed("confirm") then
            self.state = (self.selected_option == 1) and "ALL" or "EQUIPPED"
            if (#self:getBadges() == 0) then
                self.state = "SELECT"
                Assets.stopAndPlaySound("ui_cant_select")
                return
            end
            Assets.stopAndPlaySound("ui_select")
            self.selected_option = 1
            self:updateSelectedItem()
        end
    elseif self.state == "ALL" or self.state == "EQUIPPED" then
        if Input.pressed("cancel") then
            Assets.stopAndPlaySound("ui_cancel_small")
            self.selected_option = (self.state == "ALL") and 1 or 2
            self.state = "SELECT"
            Game.world.menu:setDescription("", false)
        else
            -- We didn't cancel this frame, so we're still in the menu -- handle scrolling and potentially a confirm press

            self:handleMenuScroll()

            if Input.pressed("confirm") then
                local item = self:getSelectedBadge()
                if item then
                    if item:isEquipped() then
                        item:setEquipped(false)
                        Assets.stopAndPlaySound("equip")
                        if self.state == "EQUIPPED" then
                            if (#self:getBadges() == 0) then
                                self.state = "SELECT"
                                Game.world.menu:setDescription("", false)
                                self.selected_option = 2
                            elseif self.selected_option > #self:getBadges() then
                                self.selected_option = #self:getBadges()
                            end
                        end
                    elseif (BadgesLib:getTotalBadgePoints() - BadgesLib:getUsedBadgePoints()) >= item:getBadgePoints() then
                        item:setEquipped(true)
                        Assets.stopAndPlaySound("equip")

                        for index, chara in ipairs(Game.party) do
                            local reaction = chara:getReaction(item, chara)
                            if reaction then
                                Game.world.healthbar.action_boxes[index].reaction_alpha = 50
                                Game.world.healthbar.action_boxes[index].reaction_text = reaction
                            end
                        end
                    else
                        Assets.stopAndPlaySound("ui_cant_select")
                    end
                end
            end
        end
    end

    super.update(self)
end

function DarkBadgeMenu:draw()
    love.graphics.setFont(Assets.getFont("main"))

    Draw.setColor(PALETTE["world_border"])
    love.graphics.rectangle("fill", 188, -24,  6,  322)
    love.graphics.rectangle("fill", -24, 120, 218,  6)

    Draw.setColor(Game:getSoulColor())
    if self.state == "SELECT" then
        Draw.draw(Assets.getTexture("player/heart"), 0, 16 + ((self.selected_option - 1) * 32))
    elseif self.state == "ALL" or self.state == "EQUIPPED" then
        if self.selected_option < self.badge_list_offset + 1 then
            self.badge_list_offset = self.selected_option - 1
        end

        if self.selected_option > self.badge_list_offset + 9 then
            self.badge_list_offset = self.selected_option - 9
        end

        Draw.draw(Assets.getTexture("player/heart"), 180 + 54 - 26 - 8, 16 + ((self.selected_option - self.badge_list_offset - 1) * 30))
    end

    Draw.setColor(PALETTE["world_header"])
    if self.state == "ALL" then Draw.setColor(PALETTE["world_header_selected"]) end
    if (#self:getBadges("ALL") == 0) then Draw.setColor(PALETTE["world_gray"]) end
    love.graphics.print("All Badges", 26, 6)
    Draw.setColor(PALETTE["world_header"])
    if self.state == "EQUIPPED" then Draw.setColor(PALETTE["world_header_selected"]) end
    if (#self:getBadges("EQUIPPED") == 0) then Draw.setColor(PALETTE["world_gray"]) end
    love.graphics.print("Equip Only", 26, 38)

    local state = self:getCurrentBadgeState()

    local current_badges = self:getBadges(state)

    if (#current_badges == 0) then
        Draw.setColor(PALETTE["world_gray"])
        love.graphics.print("No badges!", 280, 8)
    end

    local item_x = 0
    local item_y = 0
    for i = self.badge_list_offset + 1, self.badge_list_offset + 9 do
        local badge = current_badges[i]
        if badge then
            Draw.setColor(PALETTE["world_text_shadow"])
            local name = badge:getWorldMenuName() .. " - " .. badge:getBadgePoints() .. " BP"
            love.graphics.print(name, 180 + 54 + (item_x * 210) + 2 - 8, 6 + (item_y * 30) + 2)
            Draw.setColor(1, 1, 1, 1)
            if (BadgesLib:getTotalBadgePoints() - BadgesLib:getUsedBadgePoints()) < badge:getBadgePoints() then Draw.setColor(PALETTE["world_gray"]) end
            if (badge.equipped) then Draw.setColor(PALETTE["world_header_selected"]) end
            love.graphics.print(name, 180 + 54 + (item_x * 210) - 8, 6 + (item_y * 30))
            item_y = item_y + 1
        end
    end

    Draw.setColor(1, 1, 1, 1)

    local sine_off = math.sin((Kristal.getTime()*30)/6) * 3
    if self.badge_list_offset + 9 < #current_badges then
        Draw.draw(Assets.getTexture("ui/page_arrow_down"), 476, 149 + sine_off + 105)
    end
    if self.badge_list_offset > 0 then
        Draw.draw(Assets.getTexture("ui/page_arrow_down"), 476, 8 - sine_off + 16, 0, 1, -1)
    end

    local x = 0
    local y = 0
    for i = 1, BadgesLib:getTotalBadgePoints() do
        Draw.setColor(1, 1, 1, 1)
        Draw.draw(
            Assets.getTexture(
                "ui/menu/badge_point_" .. ((i <= BadgesLib:getUsedBadgePoints()) and "filled" or "empty")
            ),
            0 + x * 18,
            120 + 16 + y * 18
        )

        x = x + 1
        if x > 8 then
            x = 0
            y = y + 1
        end
    end

    super.draw(self)
end

return DarkBadgeMenu