local Game, super = HookSystem.hookScript(Game)

function Game:clear()
    super.clear(self)

    self.borders = {
        --[[{
            "id",     - The id of the border
            "Name",   - The Name of the border
            equipped, - If the border is equipped(true), not equipped (false) or unobtained(nil)
        }]]
        
        {"off",     "OFF",     false},
        {"dynamic", "Dynamic", false},
        {"simple",  "Simple",  false},

        --Will unlock if a map has them set as border and the "autoAdd" config is true
            {"castle",  "Castle",  nil  },
            {"city",    "City",    nil  },
            {"cyber",   "Cyber",   nil  },
            {"leaves",  "Leaves",  nil  },
            {"mansion", "Mansion", nil  },
        
        
        {"none",    "None",    false},
    }
end

function Game:setBorder(border, time)
    if not Kristal.bordersEnabled() then
        border = "off"
    end

    local new_border_id = border
    if type(border) ~= "string" then
        new_border_id = border.id
    end

    if not self:isKristalBorder(new_border_id) then
        Kristal.Config["borders"] = "dynamic"
    end

    super.setBorder(self, new_border_id, time)
end

function Game:loadBorder()
    local full_path = "saves/" .. (Mod.info.id) .. "/borders.json"
    if love.filesystem.getInfo(full_path) then
        local saved_borders = JSON.decode(love.filesystem.read(full_path))
        for _, saved_border in pairs(saved_borders) do

            for _, border in pairs(self.borders) do
                if border[1] == saved_border[1] then
                    border[3] = saved_border[3]
                end
            end

            if saved_border[3] == true then
                local old_border = Kristal.Config["borders"]
                self:setBorder(saved_border[1])
                Kristal.Config["borders"] = saved_border[1]
                if not self:isKristalBorder(saved_border[1]) then
                    Kristal.Config["borders"] = "dynamic"
                end
                if (saved_border[1] == "off" or old_border == "off") and not (saved_border[1] == "off" and old_border == "off") then
                    Kristal.resetWindow()
                end
            end
        end
    else
        for _, border in pairs(self.borders) do
            if border[1] == Kristal.Config["borders"] then
                border[3] = true
            end
        end
    end
end

function Game:saveBorder(borders)
    love.filesystem.write("saves/" .. (Mod.info.id) .. "/borders.json", JSON.encode(borders))
end

function Game:addBorder(id)
    for _, border in pairs(self.borders) do
        if id == border[1] and border[3] == nil then
            border[3] = false
            self:saveBorder(self.borders)
        end
    end
end

function Game:getBorderFromId(border_id)
    for _, border in pairs(self.borders) do
        if border[1] == border_id then return border end
    end
end

function Game:getEquippedBorder()
    for _, border in pairs(self.borders) do
        if border[3] == true then return border end
    end
end

function Game:isKristalBorder(border_id)
    for _, border in pairs(Kristal.getBorderTypes()) do
        if border_id == border[1] then
            return true
        end
    end
end

return Game