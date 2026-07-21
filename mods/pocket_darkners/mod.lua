function Mod:init()
    Game:registerEvent("squeak", function(data)
        return Squeak(data.x, data.y, {data.width, data.height, data.polygon})
    end)
    print("Loaded " .. self.info.name .. "!")
end
function Mod:onTextSound(sound, node)
    if sound == "type" then
        -- play sound at random pitch
        local snd = Assets.stopAndPlaySound("voice/type")
        snd:setPitch(0.9 + MathUtils.random(0.15))
        return true -- true to indicate we handled it
    end
end