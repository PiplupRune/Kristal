---@class DarkConfigMenu
local DarkConfigMenu, super = HookSystem.hookScript(DarkConfigMenu)

function DarkConfigMenu:init()
    super.init(self)

--  Setup variables
    self.keybinds = {}
    
    self:registerKeybind()

    self.offset = 0
end

function DarkConfigMenu:registerKeybind()
    local keys = {"down", "right", "up", "left", "confirm", "cancel", "menu"}
          keys = TableUtils.merge(keys, Input.mod_keybinds[Mod.info.id] or {})
          keys = TableUtils.removeDuplicates(keys)

    for _, key in pairs(Kristal.getLibConfig("better_control", "bannedKeys") or {}) do
        TableUtils.removeValue(keys, key)
    end

    for _, keybind in ipairs(keys) do
        table.insert(self.keybinds, {keybind = keybind, name = (Input.getBindName(keybind) or keybind:gsub("_", " ")):upper()})
    end
end

function DarkConfigMenu:onKeyPressed(key)
    if self.state == "CONTROLS" then
        if self.rebinding then
            local gamepad = StringUtils.startsWith(key, "gamepad:")
            local key_rebind = self.keybinds[self.currently_selected]["keybind"]

            local worked = key ~= "escape" and
                Input.setBind(key_rebind, 1, key, gamepad)

            self.rebinding = false

            if worked then
                Assets.stopAndPlaySound("ui_select")
                if Kristal.getLibConfig("better_control", "saveAfterModification") then Input.saveBinds() end
            else
                Assets.stopAndPlaySound("ui_cant_select")
            end

            return
        end
        if Input.pressed("confirm") then
            if self.currently_selected <= #self.keybinds then
                Assets.stopAndPlaySound("ui_select")
                self.rebinding = true
                return
            end

            if self.currently_selected == #self.keybinds + 1 then
                Assets.playSound("levelup")

                if Kristal.isConsole() then
                    Input.resetBinds(true)  -- Console, no keyboard, only reset gamepad binds
                elseif Input.hasGamepad() then
                    Input.resetBinds()      -- PC, keyboard and gamepad, reset all binds
                else
                    Input.resetBinds(false) -- PC, no gamepad, only reset keyboard binds
                end
                Input.saveBinds()
                self.reset_flash_timer = 10
            end

            if self.currently_selected == #self.keybinds + 2 then
                self.reset_flash_timer = 0
                self.state = "MAIN"
                self.currently_selected = 2
                Assets.stopAndPlaySound("ui_select")
                Input.saveBinds()
                Input.clear("confirm", true)
            end
            return
        end

        local old_selected = self.currently_selected
        if Input.pressed("up") then
            self.currently_selected = self.currently_selected - 1
            if self.currently_selected < 1 then
                self.currently_selected = 1
            end
        end
        if Input.pressed("down") then
            self.currently_selected = self.currently_selected + 1
            if self.currently_selected > #self.keybinds + 2 then
                self.currently_selected = #self.keybinds + 2
            end
        end

        if self.currently_selected > 7 + self.offset and self.currently_selected < #self.keybinds + 1 then
            self.offset = self.offset + 1
        elseif self.currently_selected <= self.offset then
            self.offset = self.offset - 1
        end
        if Input.pressed("left") then
            self.offset = 0
            self.currently_selected = 1
        end
        if Input.pressed("right") then
            self.offset = #self.keybinds - 7
            self.currently_selected = #self.keybinds
        end

        self.currently_selected = MathUtils.clamp(self.currently_selected, 1, #self.keybinds + 2)

        if old_selected ~= self.currently_selected then
            Assets.stopAndPlaySound("ui_move")
        end
    else
        super.onKeyPressed(key)
    end
end

function DarkConfigMenu:update()
    if self.state == "CONTROLS" then
        if Input.pressed("cancel") and not self.rebinding and Kristal.getLibConfig("better_control", "cancelToExit") then
            self.reset_flash_timer = 0
            self.state = "MAIN"
            self.currently_selected = 2
            Input.saveBinds()
            Input.clear("cancel", true)
        end
        return
    else
        super.update(self)
    end
end

function DarkConfigMenu:getPointSpacing()
    if #self.keybinds <= 9 then
        return 25
    else
        return 45 - (#self.keybinds * 2)
    end
end

function DarkConfigMenu:draw()
    if Game.state == "EXIT" then
        super.draw(self)
        return
    end

    if self.state == "CONTROLS" then
        love.graphics.setFont(self.font)
        Draw.setColor(PALETTE["world_text"])

        -- NOTE: This is forced to true if using a PlayStation in DELTARUNE... Kristal doesn't have a PlayStation port though.
        local dualshock = Input.getControllerType() == "ps4"

        love.graphics.print("Function", 23, -12)
        -- Console accuracy for the Heck of it
        if not Kristal.isConsole() then
            love.graphics.print("Key", 243, -12)
        end
        if Input.hasGamepad() then
            love.graphics.print(Kristal.isConsole() and "Button" or "Gamepad", 353, -12)
        end

        Draw.pushScissor()
        Draw.scissor(15, 30, 440, 200)
        for index, key_info in ipairs(self.keybinds) do
            if ((index > self.offset) and index <= (7 + self.offset)) then
                Draw.setColor(PALETTE["world_text"])
                if self.currently_selected == index then
                    if self.rebinding then
                        Draw.setColor(PALETTE["world_text_rebind"])
                    else
                        Draw.setColor(PALETTE["world_text_hover"])
                    end
                end

                local squish = Kristal.getLibConfig("better_control", "squishLongAssName")
                local text, scale = StringUtils.squishAndTrunc(key_info.name:gsub("_", " "), self.font, 210, nil, not squish and 1 or nil)
                if dualshock then
                    love.graphics.print(text, 23, -4 + (29 * (index - self.offset)), 0, scale, 1)
                else
                    love.graphics.print(text, 23, -4 + (28 * (index - self.offset)) + 4, 0, scale, 1)
                end
                
                if not Kristal.isConsole() then
                    local alias = Input.getBoundKeys(key_info.keybind, false)[1]
                    if type(alias) == "table" then
                        local title_cased = {}
                        for _, word in ipairs(alias) do
                            table.insert(title_cased, StringUtils.titleCase(word))
                        end
                        love.graphics.print(table.concat(title_cased, "+"), 243, 0 + (28 * (index - self.offset)))
                    elseif alias ~= nil then
                        love.graphics.print(StringUtils.titleCase(alias), 243, 0 + (28 * (index - self.offset)))
                    end
                end

                Draw.setColor(1, 1, 1)

                if Input.hasGamepad() then
                    local alias = Input.getBoundKeys(key_info.keybind, true)[1]
                    if alias then
                        local btn_tex = Input.getButtonTexture(alias)
                        if dualshock then
                            Draw.draw(btn_tex, 353 + 42, -2 + (29 * (index - self.offset)), 0, 2, 2, btn_tex:getWidth() / 2, 0)
                        else
                            Draw.draw(btn_tex, 353 + 42 + 16 - 6, -2 + (28 * (index - self.offset)) + 11 - 6 + 1, 0, 2, 2,
                                    btn_tex:getWidth() / 2, 0)
                        end
                    end
                end
            end
        end
        Draw.popScissor()

        Draw.setColor(PALETTE["world_text"])
        if self.currently_selected == #self.keybinds + 1 then
            Draw.setColor(PALETTE["world_text_hover"])
        end

        if (self.reset_flash_timer > 0) then
            Draw.setColor(ColorUtils.mergeColor(PALETTE["world_text_hover"], PALETTE["world_text_selected"],
                                        ((self.reset_flash_timer / 10) - 0.1)))
        end

        if dualshock then
            love.graphics.print("Reset to default", 23, -4 + (29 * 8))
        else
            love.graphics.print("Reset to default", 23, -4 + (28 * 8) + 4)
        end

        Draw.setColor(PALETTE["world_text"])
        if self.currently_selected == #self.keybinds + 2 then
            Draw.setColor(PALETTE["world_text_hover"])
        end

        if dualshock then
            love.graphics.print("Finish", 23, -4 + (29 * 9))
        else
            love.graphics.print("Finish", 23, -4 + (28 * 9) + 4)
        end

        Draw.setColor(Game:getSoulColor())

        if dualshock then
            Draw.draw(self.heart_sprite, -2, 34 + ((self.currently_selected - 1 - self.offset) * 29))
        else
            Draw.draw(self.heart_sprite, -2, 34 + ((self.currently_selected - 1 - self.offset) * 28) + 2)
        end

       

        if #self.keybinds > 7 or Kristal.getLibConfig("better_control", "alwaysShowIndicator") then
             local mult_color = 1
            if self.currently_selected > #self.keybinds then
                mult_color = 0.5
            end

            if not Kristal.getLibConfig("better_control", "keyIndex") then
                -- Thanks Simbel for the spacing
                local total_height = 0
                for i = 1, #self.keybinds do
                    total_height = total_height + 3
                    if i < #self.keybinds then
                        total_height = total_height + self:getPointSpacing()
                    end
                end
                local center = self.height / 2
                local y = center - total_height / 2

                for id = 1, #self.keybinds do
                    if self.currently_selected == id then
                        Draw.setColor(1 * mult_color, 1 * mult_color, 1 * mult_color)
                        Draw.rectangle("fill", -3 + 472, y - 3, 6, 6)
                    else
                        Draw.setColor(0.5 * mult_color, 0.5 * mult_color, 0.5 * mult_color)
                        Draw.rectangle("fill", -1 + 472, y - 1, 3, 3)
                    end

                    
                    y = y + self:getPointSpacing() + 3
                end
            else
                local font = Kristal.getLibConfig("better_control", "smallFontIndicator") and Assets.getFont("small") or self.font
                local offset = Kristal.getLibConfig("better_control", "smallFontIndicator") and 8 or -8
                love.graphics.setFont(font)

                Draw.setColor(1 * mult_color, 1 * mult_color, 1 * mult_color)
                local selected = MathUtils.clamp(self.currently_selected, 1, #self.keybinds)
                local text = "KEY " .. selected .. "/" .. #self.keybinds

                -- Thanks Simbel (again) for the spacing formula
                local total_height = 0
                for i = 1, StringUtils.len(text) do
                    local letter = StringUtils.sub(text, i, i)
                    total_height = total_height + font:getHeight(letter)
                    if i < StringUtils.len(text) then
                        total_height = total_height + offset
                    end
                end
                local center = self.height / 2
                local y = center - total_height / 2

                for i = 1, StringUtils.len(text) do
                    local letter = StringUtils.sub(text, i, i)
                    Draw.printAlign(letter, 468, y)
                    y = y + font:getHeight(letter) + offset
                    if letter == " " then
                        if self.currently_selected <= #self.keybinds then
                            local r, g, b = unpack(PALETTE["world_text_hover"])
                            Draw.setColor(r * mult_color, g * mult_color, b * mult_color)
                        end
                    elseif StringUtils.sub(text, i + 1, i + 1) == "/" then
                        local r, g, b = unpack(PALETTE["world_text"])
                        Draw.setColor(r * mult_color, g * mult_color, b * mult_color)
                    end
                end
            end
        end

        Draw.setColor(1, 1, 1, 1)

        super.super.draw(self)
    else
        super.draw(self)
    end
end

return DarkConfigMenu