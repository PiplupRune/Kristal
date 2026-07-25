local item, super = Class(HealItem, "oran_berry")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Oran Berry"
    -- Name displayed when used in battle (optional)
    self.use_name = nil
    -- Makes it so that it is a berry.
    self.berry_type = true  

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Heals\n20HP"
    -- Shop description
    self.shop = "Peculiar\nfruit\nheals 20HP"
    -- Menu description
    self.description = "A fruit that isn't particularly sweet.\nTastes vaguely like an orange. +20HP"

    -- Amount healed (HealItem variable)
    self.heal_amount = 20
    -- Amount this item heals for specific characters in the overworld (optional)
    self.world_heal_amounts = {
    -- NATURES
    -- Kris: Serious - Neutral effects from all berries
    -- Susie: Rash - Prefers dry, dislikes bitter
    -- Quartz: Timid - Prefers sweet, dislikes sour
        ["quartz"] = 15
    }

    -- Default shop price (sell price is halved)
    self.price = 2
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions (key = party member id)
    self.reactions = {
        kris = "Weirdly smooth?", 
        susie = "Woah, juicy!",
        quartz = "Could be sweeter...",
    }
end

return item