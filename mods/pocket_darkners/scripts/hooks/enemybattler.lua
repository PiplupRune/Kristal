local EnemyBattler, super = HookSystem.hookScript(EnemyBattler)

function EnemyBattler:init(...)
    super.init(self, ...)
    self.affect_waves = false
    self.can_give_status = true 
end 

function EnemyBattler:hurt(amount, ...)
    if (self.health - amount) <= 0 then 
        Kristal.Console:warn("iudfhgkjddfhg")
        self.can_give_status = false 
    end 
    super.hurt(self, amount, ...)
end 

---@ param sYeah
function EnemyBattler:onStatused(status, worked) return end  

function EnemyBattler:giveStatus(status, msg, debuff_options)
    self:onStatused(status, self.can_give_status)
    if self.can_give_status then 
    if status == "flinch" then 
    if love.math.random(1, 10) <= 3 then 
      --  Kristal.Console:warn("raagh...")
        self:statusMessage("msg", "flinched")
        self:debuffEffect(debuff_options)
        self.affect_waves = true 
    end 
    end 
end 
end 

function EnemyBattler:debuffEffect(options)
    options = options or {}
    options.color = options.color or COLORS.red
    local snd = Assets.playSound("stat_fell", 0.8)
    local my_fx = ShaderFX("debuff") 
    local peak = options.full_intensity or 0.7 
    my_fx.shader:send("tint_color", options.color)
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