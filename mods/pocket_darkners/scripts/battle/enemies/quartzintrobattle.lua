local QuartzIntroBattle, super = Class(EnemyBattler)

function QuartzIntroBattle:init()
    super.init(self)

    -- Enemy name
    self.name = "Quartz"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("quartz")

    -- Enemy health
    self.max_health = 12
    self.health = 12
    -- Enemy attack (determines bullet damage)
    self.attack = 5
    -- Enemy defense (usually 0)
    self.defense = 6
    -- Enemy reward
    self.money = 5

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 20

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 5 DF 6\n* You shouldn't be able to see this text."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Seems like you should check your pockets.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* If you see this message, I question your choices."
end

return QuartzIntroBattle