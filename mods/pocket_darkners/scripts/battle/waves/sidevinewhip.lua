local wave, super = Class(Wave)

function wave:init()
    super.init(self)

    self.time = 300 / 30
end

function wave:onStart()
    self.timer:everyInstant(25 / 30, function()
        local x = TableUtils.pick({-200, Game.battle.arena.width + 200})
        local y = MathUtils.random(10, Game.battle.arena.height - 10)

        local bullet = self:spawnBulletTo(Game.battle.arena.mask, "vinewhipbullet", x, y)

        Assets.playSound("bombfall")
        self.timer:after(8 / 30, function()
            bullet.telegraph = false

            if x == Game.battle.arena.width + 200 then
                bullet.scale_x = -2
                bullet:slideTo(200, bullet.y, 10 / 30, "out-sine")
            else
                bullet:slideTo(-58, bullet.y, 10 / 30, "out-sine")
            end

            Assets.playSound("spearrise", 0.5)

            self.timer:after(20 / 30, function()
                Assets.playSound("grab", 0.5)
                bullet:slideTo(bullet.init_x, bullet.y, 8 / 30, "out-sine", function()
                    bullet:remove()
                end)
            end)
        end)
    end)
end

return wave