local wave, super = Class(Wave)

function wave:init()
    super.init(self)

    self.time = 7.5
end

function wave:onStart()
    self.timer:every(0.5, function()
        local x = TableUtils.pick({Game.battle.arena.left - 60, Game.battle.arena.right + 60})
        local y = MathUtils.random(Game.battle.arena.top + 20, Game.battle.arena.bottom - 20)

        local bullet = self:spawnBullet("razor_leaf", x, y)
        if x < Game.battle.arena.left then
            bullet.graphics.spin = 0.5
            bullet:slideTo(Game.battle.arena.right + 60, bullet.y, 2)
        else
            bullet.graphics.spin = -0.5
            bullet:slideTo(Game.battle.arena.left - 60, bullet.y, 2)
        end

        bullet.alpha = 0
        bullet:fadeTo(1, 0.5)
        self.timer:after(1.5, function()
            bullet:fadeOutAndRemove(0.5)
        end)
    end, 10)
end

return wave