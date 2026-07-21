return {
    starting_room_susie_1 = function(cutscene, event)
        Game.world.music:pause("pokedaa_starting_chambers")
        local susie = cutscene:getCharacter("susie")
        local kris = cutscene:getCharacter("kris")
        cutscene:setSpeaker(susie)
        cutscene:text("* Hey,[wait:5] um...[wait:5] Kris?", "nervous_side")
        kris:setFacing("left")
        susie:setAnimation({ "away_scratch", 0.25, true })
        cutscene:text("* Where...[wait:10] [face:nervous_smile]are we right now?", "nervous_smile_side")
        local kris = cutscene:getCharacter("kris")
        cutscene:setSpeaker(kris)
        cutscene:text("* (You are instantly reminded of the memes.)", "snicker")
        cutscene:setSpeaker(susie)
        Assets.playSound("wing")
        susie:setAnimation({ "exasperated_right"})
        cutscene:text("* I can hear you laughing under your breath!", "teeth")
        cutscene:text("* What else was I supposed to say?", "teeth")
        susie:resetSprite()
        Game.world.music:resume("pokedaa_starting_chambers")
        
        
    end,

    entrance_chamber_4_susie = function(cutscene, event)
        local susie = cutscene:getCharacter("susie")
        local kris = cutscene:getCharacter("kris")
        cutscene:text("* This Dark World...[wait:10] [face:neutral_side]I think this is a Dark World,[wait:5] anyway...", "nervous_side", "susie")
        kris:setFacing("left")
        cutscene:text("* This...[wait:5] place,[wait:5] something really bad happened to it...", "sus_nervous", "susie")
        
        local choice = cutscene:choicer({"Now that you\nmention it...", "I don't\ndisagree", "You don't say"})
        if choice == 1 then
        cutscene:text("* Now that you mention it...","sort_of_surprised_eyes", "kris")
        Assets.playSound("wing")
        susie:setAnimation({ "exasperated_right"})
        cutscene:text("* What,[wait:5] you're telling me you JUST noticed?","nervous", "susie")
        elseif choice == 2 then
        cutscene:text("* I don't...[wait:5] disagree.","intimidated", "kris")
        cutscene:text("* So you noticed it too...","sus_nervous", "susie")
        elseif choice == 3 then
        cutscene:text("* You don't say.","sarcastic_enthusiasm_eyes", "kris")
        Assets.playSound("wing")
        susie:setAnimation({ "exasperated_right"})
        cutscene:text("* Hey,[wait:5] cut the sarcasm.","annoyed", "susie")
        end
        susie:resetSprite()
        susie:setAnimation({ "away_scratch", 0.25, true })
        cutscene:text("* Something serious must've happened here...","annoyed_down", "susie")
        susie:resetSprite()
        --
        --cutscene:wait(2)
        --Assets.playSound("alert")
        --susie:alert()
        --susie:setAnimation({"shock_right"})
        --cutscene:text("* Wait hold on Kris?!","shock")
        --cutscene:setSpeaker(kris)
        --cutscene:text("* Hmm?","sort_of_surprised_eyes")
        --cutscene:setSpeaker(susie)
        --
        --cutscene:text("* You seem...[wait:5] [face:surprise_smile]more conversation-y than usual?","suspicious")
        --cutscene:setSpeaker(kris)
        --cutscene:text("* Huh.","sort_of_surprised_eyes")
        --cutscene:text("* Neat.","curious_eyes")
        --cutscene:setSpeaker(susie)
        --cutscene:text("* ...", "nervous_smile")
        --cutscene:setSpeaker(susie)
        --cutscene:text("* (They seem...[wait:5] different.)","suspicious")
    end,


    quartz_test = function(cutscene, event)
        local quartz = cutscene:getCharacter("quartz")
        cutscene:text("* It's a test NPC that will be removed eventually.")
        cutscene:setSpeaker(quartz)
        cutscene:text("* I'm a test NPC that will be removed eventually.", "neutral")
        cutscene:text("* This is a test dialogue to test Quartz's original seven portrait.", "neutral")
        cutscene:text("* This is the neutral portrait.", "neutral")
        cutscene:text("* This is the happy portrait.", "happy")
        cutscene:text("* This is the shocked portrait.", "shocked")
        cutscene:text("* This is the sad portrait.", "sad")
        cutscene:text("* This is the angry portrait.", "angry")
        cutscene:text("* This is the confused portrait.", "confused")
        cutscene:text("* This is the bruh portrait.", "bruh")
        cutscene:text("* This concludes this portrait test.", "neutral")
        cutscene:text("* (If you can see this NPC, the dev has been lazy.)", "neutral")
        
    end,




}