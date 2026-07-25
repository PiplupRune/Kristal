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


--- Removes a status condition from the enemy battler.
---@param status string # The name ID of the status to cure (e.g., "poison").
function EnemyBattler:cure(status) 
    self:statusMessage("msg", "cured")
    if status == "poison" then 
        self.poison = false 
    elseif status == "paralysis" then 
        self.paralyzed = false 
    end 
end

--- Called internally, short helper function. 
function EnemyBattler:cureAll() 
    self.poison = false 
    self.affect_waves = false 
    self.paralyzed = false 
end

--- A callback event caled whenever a status effect attempt is processed.
---@param status string # The name ID of the status that was processed.
---@param worked boolean # Whether the status was successfully applied to the enemy.
function EnemyBattler:onStatused(status, worked) return end  
 
--- Attempts to apply a specific status condition to the enemy battler.
---@param status string # The status ID to apply. Current options: `flinch`, `poison`, and `paralysis`.
---@param msg string? # Optional custom text message string to pass to the statusMessage method.
function EnemyBattler:giveStatus(status, msg)
    self:onStatused(status, self.can_give_status)
    if self.can_give_status then 
        if status == "flinch" then 
            if love.math.random(1, 10) <= 3 then 
                self:statusMessage("msg", msg or "flinched")
                self:debuffEffect(ColorUtils.hexToRGB("EFC55B"))
                self.affect_waves = true 
            end 
        elseif status == "poison" then  
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
        elseif status == "paralysis" then 
            self:statusMessage("msg", msg or "paralyzed")
            Assets.playSound("paralyze")
            self.paralyzed = true 
            self:flash(nil, nil, nil, 100, ColorUtils.hexToRGB("FFF0B2"))
            self:expandRipple(ColorUtils.hexToRGB("FFF0B2"), 2, {70, 50}, 3)
        end
    end 
end


---@param color table # The RGB table color for the rings (e.g. ColorUtils.hexToRGB("...") )
---@param amount number # How many ripple rings should expand out
---@param radius number|table # Max radius limit. Can be a flat number or a table mapping limits per ring index
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

--- A function that is called when the enemy should take their poison damage. 
---@param toxic # Whether the damage should increase (bad poison), and will return the value, and the value for the next call. 
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
    self.hit_count = 0
    self:hurt(MathUtils.roundFromZero(self.max_health / 8), nil, nil, ColorUtils.hexToRGB("B868A0"))
    else 
    local dmg = MathUtils.roundFromZero(self.max_health / 16)
    return dmg, dmg + self.max_health / 16
    end 
end

--- Spawns a colored overlay and scrolling white lines. 
---@param color table # The RGB table configuration defining the tint vector of the overlay shader lines.
---@param full_intensity number? # The maximum opacity intensity target peak the shader should approach. Defaults to 0.7.
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