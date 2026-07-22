local item, super = Class("darkburger", true)

function item:onBattleUse(user, target)
    if Game.battle.encounter.id == "quartzintro" then
        Game.battle:startCutscene("quaintonbattle", "quartz_fed")
    end
end

return item