local EnemyBattler, super = HookSystem.hookScript(EnemyBattler)

function EnemyBattler:init(...)
    super.init(self, ...)
    self.affect_waves = false 
end 

---@ param sYeah
function EnemyBattler:onStatused(status) return end  

function EnemyBattler:giveStatus(status, msg)
    self:onStatused(status)
    self:debuffEffect()
    if status == "flinch" then 
        self:flinch()
    end 
end 

function EnemyBattler:flinch()
    self:statusMessage("msg", "flinched")
    self.affect_waves = true 
end 

function EnemyBattler:debuffEffect(color, full_intensity)
    local snd = Assets.playSound("stat_fell")
    local my_fx = ShaderFX("debuff") 
    local peak = full_intensity or 0.7
    my_fx.shader:send("tint_color", color or COLORS.red)
    my_fx.shader:send("intensity", 0.0)
    my_fx.shader:send("scroll_y", 0.0)
    self:addFX(my_fx) 
    local current_scroll = 0
    local duration = snd:getDuration()
    local q_duration = duration / 4
    local h_duration = duration / 2
    Game.battle.timer:approach(q_duration, 0.0, peak, function(v)
        current_scroll = (current_scroll + (0.02 * DTMULT)) % 1.0
        my_fx.shader:send("scroll_y", current_scroll)
        my_fx.shader:send("intensity", v)
    end, "linear", function()
        Game.battle.timer:during(h_duration, function()
            current_scroll = (current_scroll + (0.02 * DTMULT)) % 1.0
            my_fx.shader:send("scroll_y", current_scroll)
            my_fx.shader:send("intensity", peak) 
        end, function()
            Game.battle.timer:approach(q_duration, peak, 0.0, function(v)
                current_scroll = (current_scroll + (0.02 * DTMULT)) % 1.0
                my_fx.shader:send("scroll_y", current_scroll)
                my_fx.shader:send("intensity", v)
            end, "linear", function()
                self:removeFX(my_fx)
            end)
        end)
    end)
end 





return EnemyBattler