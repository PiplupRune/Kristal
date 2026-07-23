return {
    quartz_battle = function(cutscene, event)
            
            love.window.setTitle("THIS ESCALATED RATHER QUICKLY")
            cutscene:battlerText("quartzintrobattle","Woah,[wait:5] wait,[wait:5] what's going on?!")
            cutscene:battlerText("susie","This...[wait:5] is a battle?", {right = true, x = 150, y = 220})
            cutscene:battlerText("quartzintrobattle","W-[wait:5] What?!")
            cutscene:battlerText("susie","You literally ran headfirst into Kris.", {right = true, x = 150, y = 220})
            cutscene:battlerText("quartzintrobattle","I-[wait:5] I...")
            cutscene:battlerText("quartzintrobattle","I didn't mean to!")
            cutscene:battlerText("quartzintrobattle","L-[wait:5]let's start over...")
            cutscene:battlerText("quartzintrobattle","My name is Quartz,")
            cutscene:battlerText("quartzintrobattle","Your friend...[wait:5] Kris,[wait:5] was it?")
            cutscene:battlerText("quartzintrobattle","[speed:3][voice:quartz_alt_7_fast]They smell really good and I\nhaven't eaten in like four day[voice:quartz_alt_7]s.")
            cutscene:battlerText("susie","Heh,[wait:5] they do smell delicious.", {right = true, x = 150, y = 220})
            cutscene:battlerText("susie","I'm Susie,[wait:5], a-[next]", {right = true, x = 150, y = 220})
            cutscene:battlerText("susie","Wait,[wait:5] you said you haven't\neaten in HOW long?!", {right = true, x = 150, y = 220})
            cutscene:battlerText("quartzintrobattle","Well,[wait:5] nothing grows here anymore.[wait:5]\nAll of the bushes are dead.")
            cutscene:battlerText("susie","Uhhhhhhhhh Kris,[wait:5] do we have\nanything we could give them?", {right = true, x = 150, y = 220})
            Game.battle.battle_ui.action_boxes[1].buttons[1].disabled=true
            Game.battle.battle_ui.action_boxes[1].buttons[2].disabled=true
            Game.battle.battle_ui.action_boxes[1].buttons[4].disabled=true
            Game.battle.battle_ui.action_boxes[1].buttons[5].disabled=true
            Game.battle.battle_ui.action_boxes[2].buttons[1].disabled=true
            Game.battle.battle_ui.action_boxes[2].buttons[2].disabled=true
            Game.battle.battle_ui.action_boxes[2].buttons[3].disabled=true
            Game.battle.battle_ui.action_boxes[2].buttons[5].disabled=true
           cutscene:after(function()
            Game.battle:nextTurn()
            local battler = Game.battle:getActiveParty()[2]
                Kristal.Console:warn(battler)
            Game.battle:pushForcedAction(battler, "SKIP", Game.battle:getActiveEnemies()[1], nil, {})
            end)
        end,

    quartz_fed = function(cutscene, event)
            cutscene:battlerText("quartzintrobattle","Oh my goodness\nthank you so much!!")
            local quartz = cutscene:getCharacter("quartzintrobattle")
            quartz:addMercy(100)
            
            love.window.setTitle("THIS DE-ESCALATED RATHER QUICKLY")
        cutscene:after(function()
            Game.battle:setState("TRANSITIONOUT")
            return
        end)
        end,

}
