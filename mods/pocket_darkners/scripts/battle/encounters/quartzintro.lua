local QuartzIntroBattle, super = Class(Encounter)

function QuartzIntroBattle:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Seems like you should check your pockets."

    -- Battle music ("battle" is rude buster)
    self.music = "pokedaa_mus_battle"
    -- Enables the purple grid battle background
    self.background = true

    -- Add the dummy enemy to the encounter
    self:addEnemy("quartzintrobattle")

    self.no_end_message = true

    Game:setFlag("quartzEncountered",true)

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end

function QuartzIntroBattle:onStateChange(old, new) -- change Encounter to your encounter name
    if old == "INTRO" and new == "ACTIONSELECT" then
        Game.battle.battle_ui:clearEncounterText()
        Game.battle.seen_encounter_text = false
        Game.battle.current_selecting = 0
        Game.battle:startCutscene("quaintonbattle", "quartz_battle")
    end
end

function QuartzIntroBattle:onReturnToWorld(events)
    
    return super.onReturnToWorld(self, events)
end

return QuartzIntroBattle