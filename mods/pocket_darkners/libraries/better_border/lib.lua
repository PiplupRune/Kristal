local Lib = {}

function Lib:load()
    Game:loadBorder()
end

function Lib:onMapBorder(map, border)
    if border and Kristal.getLibConfig("better_border", "autoUnlock") then
        Game:addBorder(border)
    end

    if not Game:isKristalBorder(Game:getEquippedBorder()[3]) then
        return Game:getBorder()
    end
end

return Lib