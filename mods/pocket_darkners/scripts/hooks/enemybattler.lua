local EnemyBattler, super = HookSystem.hookScript(EnemyBattler)

function EnemyBattler:init(...)
    super.init(self, ...)
    self.affect_waves = false
    
    -- Status Trackers
    self.poison = false
    self.toxic = false
    self.paralyzed = false
    self.toxic_count = 0 -- Keeps track of how many turns Toxic has been active (itll never go away :3)
end 

function EnemyBattler:hurt(amount, ...)
    super.hurt(self, amount, ...)
end 

function EnemyBattler:getNextWaves()
    if self.affect_waves then
        self.affect_waves = false  
        return {"hidden"}
    elseif self.paralyzed then 
        if love.math.random(1, 4) == 1 then 
            return {"paralysis"}
        else
            return super.getNextWaves(self)
        end 
    else 
        return super.getNextWaves(self)
    end 
end

function EnemyBattler:hasNonVolatileStatus()
    return self.poison or self.toxic or self.paralyzed
end

function EnemyBattler:giveStatus(status, msg)

    if status == "flinch" then 
    if love.math.random(1, 10) <= 3 then 
            self:statusMessage("msg", msg or "flinched")
            self:debuffEffect(ColorUtils.hexToRGB("EFC55B"))
            self.affect_waves = true 
            return true
    end
        return false
    end

    -- KEEP THIS BLOCK OF CODE **AFTER** EVERY VOLATILE STATUS - REMINDER FOR FLUFFY (...when i say volatile i mean thingies that can be stacked)
    if self:hasNonVolatileStatus() then 
        return true, "* It had no effect."
    end

    if status == "poison" then  
        self:statusMessage("msg", msg or "poisoned")
        self.poison = true 
        local mask = ColorMaskFX(ColorUtils.hexToRGB("B868A0"))
        mask.amount = 0 
        self:addFX(mask)
        local snd = Assets.playSound("poison", 2)
        local tween = snd:getDuration() / 2
        Game.battle.timer:tween(tween, mask, {amount = 1}, "linear", function()
            Game.battle.timer:tween(tween, mask, {amount = 0})
        end)
        return true
        
    elseif status == "paralysis" then 
        self:statusMessage("msg", msg or "paralyzed")
        Assets.playSound("paralyze")
        self.paralyzed = true 
        self:flash(nil, nil, nil, 100, ColorUtils.hexToRGB("FFF0B2"))
        self:expandRipple(ColorUtils.hexToRGB("FFF0B2"), 2, {70, 50}, 3)
        return true
        
    elseif status == "toxic" then 
        self:statusMessage("msg", msg or "poisonedbadly")
        self.toxic = true  
        self.toxic_count = 1 -- Start the dynamic scaling counter
        local mask = ColorMaskFX(ColorUtils.hexToRGB("B868A0"))
        mask.amount = 0 
        self:addFX(mask)
        local snd = Assets.playSound("poison", 2)
        local tween = snd:getDuration() / 2
        Game.battle.timer:tween(tween, mask, {amount = 1}, "linear", function()
            Game.battle.timer:tween(tween, mask, {amount = 0})
        end)
        return true
    end 
end

function EnemyBattler:cure(status) 
    self:statusMessage("msg", "cured")
    if status == "poison" then 
        self.poison = false 
    elseif status == "paralysis" then 
        self.paralyzed = false 
    elseif status == "toxic" then
        self.toxic = false
        self.toxic_count = 0
    end 
end

-- this function is near useless but it helps sometimes ig. ..
function EnemyBattler:cureAll() 
    self.poison = false 
    self.toxic = false
    self.paralyzed = false 
    self.toxic_count = 0
    self.affect_waves = false 
end

function EnemyBattler:onStatused(status, worked) return end  

function EnemyBattler:expandRipple(color, amount, radius, speed)
    amount = amount or 1
    local center_x, center_y = self:getRelativePos(self.sprite.width / 2, self.sprite.height / 2, Game.battle)
    for i = 1, amount do
        local delay = (i - 1) * 0.25     
        Game.battle.timer:after(delay, function()
            local max_r = type(radius) == "table" and (radius[i] or 80) or (radius or 80)
            local ripple = RippleEffect(center_x, center_y, color, 0, max_r, speed or 2.5)
            Game.battle:addChild(ripple)
        end)
    end
end

function EnemyBattler:takePoisonDamage(toxic)
    local mask = ColorMaskFX(ColorUtils.hexToRGB("B868A0"))
    mask.amount = 0 
    self:addFX(mask)
    local snd = Assets.playSound("poison", 2)
    local tween = snd:getDuration() / 2
    Game.battle.timer:tween(tween, mask, {amount = 1}, "linear", function()
        Game.battle.timer:tween(tween, mask, {amount = 0})
    end)
    
    if not toxic then 
        local dmg = MathUtils.roundFromZero(self.max_health / 8)
        self.hit_count = 0 
        self:hurt(dmg, nil, nil, ColorUtils.hexToRGB("B868A0"))
    else 
        local dmg = MathUtils.roundFromZero(self.max_health * (self.toxic_count / 16))
        self:hurt(dmg, nil, nil, ColorUtils.hexToRGB("B868A0"))
        self.hit_count = 0 
        self.toxic_count = self.toxic_count + 1
    end 
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
