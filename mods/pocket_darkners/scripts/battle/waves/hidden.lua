local Basic, super = Class(Wave)


function Basic:init()
    super.init(self)
    self.time = 0.4
    self.spawn_soul = false
    self.has_arena = false
    local enemy_name = self:getAttackers()[1].name
    Game.battle:infoText("[noskip]* "..enemy_name.." flinched and couldn't move!")
end 

function Basic:onStart()
    Game.battle:undarken()
end

return Basic
