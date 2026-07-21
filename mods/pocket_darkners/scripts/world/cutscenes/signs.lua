return {
    starting_room = function(cutscene, event)
        cutscene:text("* The sign's text is faded.\n* All you can make out is...")
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* \"puzzles\"")
        cutscene:text("* (You think about how Rouxls would probably love this place,", "skeptical_eyes", "kris")
        cutscene:text("* based entirely off of this sign alone.)", "skeptical_eyes", "kris")
    end,

    entrance_chamber_1_1 = function(cutscene, event)
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* Our ancestors were brilliant at finding their[sound:beep][wait:5] way.[wait:5] They could solve any puzzle-[sound:beep][wait:5] \nthey could best any obstacle.")
        cutscene:text("* Heh,[wait:5] sounds like you...", "smirk", "susie")
        cutscene:text("* Nerd!", "smile", "susie")
    end,

    entrance_chamber_1_2 = function(cutscene, event)
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* However, as time went on, they began to grow[sound:beep][wait:5] concerned.[wait:5] Concerned that their progeny would[sound:beep][wait:5] not have the neccessary experience-[wait:5]\nThat they would not be masters of wayfinding[sound:beep][wait:5] like those which came before.")
            
    end,

    entrance_chamber_1_3 = function(cutscene, event)
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* To ensure that their descendents would[sound:beep][wait:5]\ninherit their navigatory skill,[wait:5] the elders[sound:beep][wait:5] converted their roads into challenges and[sound:beep][wait:5] puzzles,[wait:5] designed to keep sharp the minds of[sound:beep][wait:5] the youth.")
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* At least,[wait:5] that is the story which has been[sound:beep][wait:5] passed down,[wait:5] to us from our ancestors,[wait:5] to them[sound:beep][wait:5] from theirs,[wait:5] as far back as records go.")
        cutscene:text("* Arright,[wait:5] hold up.", "neutral", "susie")
        cutscene:text("* Why are all of these signs so close to the damn ground???", "teeth_b", "susie")
        cutscene:text("* Whoever built this place must've been,[wait:5] like,", "suspicious", "susie")
        cutscene:text("* Really short or something.", "smile", "susie")
    end,

    entrance_chamber_2_1 = function(cutscene, event)
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* Our ancestors had no issues navigating the[sound:beep][wait:5] new,[wait:5] purpose-built obstacles.[wait:5] Their children[sound:beep][wait:5] soon learnt what they needed.[wait:5] Eventually,[sound:beep][wait:5] negotiating puzzles in order to travel became[sound:beep][wait:5] the norm.")
    end,

    entrance_chamber_2_2 = function(cutscene, event)
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* Until one day...[wait:5]")
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* ...[wait:5]")
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* The brilliant light that once filled our sky...[sound:beep][wait:5]\nIt vanished.")
        end,

    entrance_chamber_3_1 = function(cutscene, event)
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* Our world soon plunged into eternal night.[sound:beep][wait:5] \nA night so bleak and unwavering,[wait:5] not even the [sound:beep][wait:5]nocturnal of us could cope.")
    end,

    entrance_chamber_3_2 = function(cutscene, event)
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* An oracle muttered something about[sound:beep][wait:5] abandonment from a supposed \"[speed:0.25][color:#00FFFF]creator[color:reset][speed:0.5]\"...[wait:10]Not[sound:beep][wait:5] even the oracle understood,[wait:5] but the people grew [sound:beep][wait:5]bitter nevertheless.")
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* Our world...[wait:5] began to decay.")
        
    end,

    entrance_chamber_3_3 = function(cutscene, event)
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* Desperate for a sign from a \"[speed:0.25][color:#00FFFF]creator[color:reset][speed:0.5]\" nobody[sound:beep][wait:5] knew, let alone even heard of before then,[sound:beep][wait:5][wait:5] many of our people isolated themselves.")
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* The puzzles that once served as teaching tools[sound:beep][wait:5] and mental stimulation,[wait:5] would now be used to[sound:beep][wait:5] keep anybody and everybody away.")
    end,

    entrance_chamber_3_4 = function(cutscene, event)
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* The so-called oracle's final words were:")
        cutscene:text("[font:timesnewroman, 1][voice:type][speed:0.5]* \"Someday,[wait:5] two [color:yellow]HEROES[color:reset] will arrive.[wait:5] They will[sound:beep][wait:5] return the light to our darkened world.[wait:5] Until[sound:beep][wait:5] then,[wait:5] all we can do is wait.[wait:5].[wait:5].[wait:10] and hope.\"")
       cutscene:text("* Man,[wait:5] this got depressing fast...", "sad", "susie")
        cutscene:text("* (You silently nod in agreement.)", "unnerved", "kris")
    end,

    entrance_chamber_4_drawing = function(cutscene, event)
        cutscene:text("* A cute drawing is painted onto the cliff face.")
        cutscene:text("* The paint is still wet.")
        cutscene:text("* (That even in such a dismal place,[wait:5] a trace of happiness lingers...)", "concerned", "kris")
        cutscene:text("* (One could say you're...", "empathetic", "kris")
        cutscene:text("* Filled with determination,[wait:5] perhaps?)", "grateful", "kris")
        cutscene:text("* (They're snickering to theirself again...?)", "nervous_smile", "susie")
    end,

    quainton_main = function(cutscene, event)
        cutscene:text("[font:pipq, 2][voice:pipq]* QUAINTON")
        cutscene:text("[font:pipq, 2][voice:pipq]* \"The town where journeys begin\"")
    end,

    quainton_rowlet_house = function(cutscene, event)
        cutscene:text("* This sign is overgrown by dead vines,[wait:5] but you can still make out the text.")
        cutscene:text("[font:pipq, 2][voice:pipq]* Silvarro Residence")
    end,

    quainton_cyndaquil_house = function(cutscene, event)
        cutscene:text("* This sign is heavily singed around the edges,[wait:5] but you can still make out the text.")
        cutscene:text("[font:pipq, 2][voice:pipq]* Tornupto Residence")
    end,

    quainton_piplup_house = function(cutscene, event)
        cutscene:text("* This sign is...[wait:5] strangely intact compared to the others in this town.")
        cutscene:text("[font:pipq, 2][voice:pipq]* Emperte Residence")
        cutscene:text("* Hey Quartz,[wait:5] why does this house look so much less...", "neutral_side", "susie")
        cutscene:text("* ...completely obliterated than the others?", "neutral", "susie")
        cutscene:text("* I dunno,[wait:5] I've never actually gone inside any of the abandoned houses.", "confused", "quartz")
        cutscene:text("* (There's something unsettling about this one...)", "unnerved", "kris")
    end,

    quainton_eevee_house = function(cutscene, event)
        cutscene:text("* The sign looks to have been restored multiple times in the past.")
        cutscene:text("* This is because the letters have been restored in various colors of paint.")
        cutscene:text("[font:pipq, 2][voice:pipq]* [color:#FF8400]E[color:blue]v[color:reset]ol[color:pink]i[color:reset] Re[color:green]s[color:red]i[color:lime]d[color:purple]e[color:reset]nc[color:#00FFFF]e")
        cutscene:text("* I couldn't find any black paint,[wait:5] so I had to improvize...", "happy_sweat", "quartz")
    end,

}