local DarkConfigMenu, super = HookSystem.hookScript(DarkConfigMenu)

if not Kristal.getLibConfig("better_border", "borderConfig") then
    return DarkConfigMenu
end

function DarkConfigMenu:update()
    if self.state == "MAIN" then
        if Input.pressed("confirm") then
            Assets.stopAndPlaySound("ui_select")

            if self.currently_selected == 1 then
                self.state = "VOLUME"
                self.noise_timer = 0
            elseif self.currently_selected == 2 then
                self.state = "CONTROLS"
                self.offset = 0
                self.currently_selected = 1
            elseif self.currently_selected == 3 then
                Kristal.Config["simplifyVFX"] = not Kristal.Config["simplifyVFX"]
            elseif self.currently_selected == 4 then
                Kristal.Config["fullscreen"] = not Kristal.Config["fullscreen"]
                love.window.setFullscreen(Kristal.Config["fullscreen"])
            elseif self.currently_selected == 5 then
                Kristal.Config["autoRun"] = not Kristal.Config["autoRun"]
            elseif self.currently_selected == 6 then
                self.state = "BORDER"
            elseif self.currently_selected == 7 then
                Game:returnToMenu()
            elseif self.currently_selected == 8 then
                Game.world.menu:closeBox()
            end

            return
        end

        if Input.pressed("cancel") then
            Assets.stopAndPlaySound("ui_cancel_small")
            Game.world.menu:closeBox()
            return
        end

        local old_selected = self.currently_selected
        if Input.pressed("up") then
            self.currently_selected = self.currently_selected - 1
        end
        if Input.pressed("down") then
            self.currently_selected = self.currently_selected + 1
        end

        self.currently_selected = MathUtils.clamp(self.currently_selected, 1, 8)
        
        if old_selected ~= self.currently_selected then
            Assets.stopAndPlaySound("ui_move")
        end
        super.super.update(self)
        return
    elseif self.state == "BORDER" then
        if Input.pressed("cancel") or Input.pressed("confirm") then
            self.state = "MAIN"
            self.currently_selected = 6
                Input.clear("cancel", true)
        end

        local border_index = 1
        local border_max = #Game.borders

        for index, border in pairs(Game.borders) do
            if border[3] == true then
                border_index = index
            end
        end

        local old_index = border_index

        if Input.pressed("left") then
            local old_index = border_index
            border_index = border_index - 1
            while Game.borders[border_index] and Game.borders[border_index][3] == nil do
                border_index = border_index - 1
            end
            if not Game.borders[border_index] then border_index = old_index end
        end
        if Input.pressed("right") then
            local old_index = border_index
            border_index = border_index + 1
            while Game.borders[border_index] and Game.borders[border_index][3] == nil do
                border_index = border_index + 1
            end
            if not Game.borders[border_index] then border_index = old_index end
        end

        border_index = MathUtils.clamp(border_index, 1, border_max)

        if old_index ~= border_index then
            Game.borders[old_index][3] = false
            Game.borders[border_index][3] = true
            Kristal.Config["borders"] = Game.borders[border_index][1]
            if Game.borders[border_index][1] == "dynamic" and Game.world.map:getBorder() then
                Game:setBorder(Game.world.map:getBorder(), 0)
            else
                Game:setBorder(Game.borders[border_index][1], 0)
            end

            if Game.borders[border_index][1] == "off" or Game.borders[old_index][1] == "off" then
                Kristal.resetWindow()
            end
            Game:saveBorder(Game.borders)
        end
        super.super.update(self)
        return
    end

    super.update(self)
end

function DarkConfigMenu:draw()
    if Game.state == "EXIT" then
        super.draw(self)
        return
    end
    love.graphics.setFont(self.font)
    Draw.setColor(PALETTE["world_text"])

    if self.state ~= "CONTROLS" then
        love.graphics.print("CONFIG", 188, -12)

        if self.state == "VOLUME" then
            Draw.setColor(PALETTE["world_text_selected"])
        end
        love.graphics.print("Master Volume", 88, 30 + (0 * 32))
        Draw.setColor(PALETTE["world_text"])
        love.graphics.print("Controls", 88, 30 + (1 * 32))
        love.graphics.print("Simplify VFX", 88, 30 + (2 * 32))
        love.graphics.print("Fullscreen", 88, 30 + (3 * 32))
        love.graphics.print("Auto-Run", 88, 30 + (4 * 32))

        -- Border's Config Graphics in work
        if self.state == "BORDER" then
            Draw.setColor(PALETTE["world_text_selected"])
        end
        love.graphics.print("Border", 88, 30 + (5 * 32))
        Draw.setColor(PALETTE["world_text"])

        love.graphics.print("Return to Title", 88, 30 + (6 * 32))
        love.graphics.print("Back", 88, 30 + (7 * 32))

        if self.state == "VOLUME" then
            Draw.setColor(PALETTE["world_text_selected"])
        end
        love.graphics.print(MathUtils.round(Kristal.getVolume() * 100) .. "%", 348, 30 + (0 * 32))
        Draw.setColor(PALETTE["world_text"])
        love.graphics.print(Kristal.Config["simplifyVFX"] and "ON" or "OFF", 348, 30 + (2 * 32))
        love.graphics.print(Kristal.Config["fullscreen"] and "ON" or "OFF", 348, 30 + (3 * 32))
        love.graphics.print(Kristal.Config["autoRun"] and "ON" or "OFF", 348, 30 + (4 * 32))

        -- Border's Config Graphics in work
        if self.state == "BORDER" then
            Draw.setColor(PALETTE["world_text_selected"])
        end
        local border_name = "OFF"
        for _, border in pairs(Game.borders) do
            if border[3] == true then
                border_name = border[2]
            end
        end
        love.graphics.print(border_name, 348, 30 + (5 * 32))
        Draw.setColor(PALETTE["world_text"])

        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, 63, 40 + ((self.currently_selected - 1) * 32))
    
        super.super.update(self)
    else
        super.draw(self)
    end

end

return DarkConfigMenu