local EnemyBattler, super = HookSystem.hookScript(EnemyBattler)

function EnemyBattler:init(...)
    super.init(self, ...)
    self.affect_waves = false
    self.can_give_status = true 
end 

function EnemyBattler:hurt(amount, ...)
    if (self.health - amount) <= 0 then 
        self.can_give_status = false 
    end 
    super.hurt(self, amount, ...)
end 

function EnemyBattler:getNextWaves()
    if self.affect_waves then
        self.affect_waves = false  
       return {"hidden"}
    else 
        return super.getNextWaves(self)
    end 
end 

function EnemyBattler:cure(status) 

return end 


---@ param sYeah
function EnemyBattler:onStatused(status, worked) return end  

function EnemyBattler:giveStatus(status, msg)
    self:onStatused(status, self.can_give_status)
    if self.can_give_status then 
    if status == "flinch" then 
    if love.math.random(1, 10) <= 3 then 
        self:statusMessage("msg", "flinched")
        self:debuffEffect(ColorUtils.hexToRGB("EFC55B"))
        self.affect_waves = true 
    end 
    elseif status == "poison" then  
        self.poison = true 
        local mask = ColorMaskFX(ColorUtils.hexToRGB("B868A0"))
        mask.amount = 0 
        self:addFX(mask)
        local snd = Assets.playSound("poison", 2)
        local tween = snd:getDuration() / 2
        Game.battle.timer:tween(tween, mask, {amount = 1}, "linear", function()
        Game.battle.timer:tween(tween, mask, {amount = 0})
        end)
    end
end 
end 

function EnemyBattler:takePoisonDamage()
    local mask = ColorMaskFX(ColorUtils.hexToRGB("B868A0"))
    mask.amount = 0 
    self:addFX(mask)
    local snd = Assets.playSound("poison", 2)
    local tween = snd:getDuration() / 2
    Game.battle.timer:tween(tween, mask, {amount = 1}, "linear", function()
    Game.battle.timer:tween(tween, mask, {amount = 0})
    end)
    self.hit_count = 0
    self:hurt(MathUtils.roundFromZero(self.max_health / 8), nil, nil, ColorUtils.hexToRGB("B868A0"))
end


function EnemyBattler:debuffEffect(color, full_intensity)
    local snd = Assets.playSound("stat_fell", 0.8)
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