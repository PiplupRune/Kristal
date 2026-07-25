local Battle, super = HookSystem.hookScript(Battle)

function Battle:onDefendingBeginState()
    local poisoned = {}
    for _, enemy in ipairs(self.enemies) do
        if enemy.active and enemy.poison then
            table.insert(poisoned, enemy)
        end
    end
    
    if #poisoned == 0 then
        super.onDefendingBeginState(self)
        return
    end
    
    self:darken()
    self:hideTargets()
    self.current_selecting = 0
    self.battle_ui:clearEncounterText()
    
    local text_lines = {}
    for i = 1, #poisoned do
        poisoned[i]:takePoisonDamage() 
        table.insert(text_lines, "* " .. poisoned[i].name .. " took poison damage!")
    end
    local full_message = "[noskip]" .. table.concat(text_lines, "\n")
    self:battleText(full_message, function()
        local active_enemies = self:getActiveEnemies() 
        if #active_enemies == 0 then
            self:onVictory()
            return true
        end
        super.onDefendingBeginState(self)
        self:setState("DEFENDING")   
        return true
    end)
end

return Battle
