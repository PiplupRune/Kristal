local item, super = Class(HealItem, "pokepotion_max")

function item:init()
    super.init(self)

    -- Display name
    self.name = "MaxPotion"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Heals\nMAX HP"
    -- Shop description
    self.shop = "Sprayable\nmedicine\nheals MAX HP"
    -- Menu description
    self.description = "Rather costly sprayable medicine in a blue bottle.\nHeals and sterilizes wounds fully. +MAX HP"

    -- Amount healed (HealItem variable)
    self.heal_amount = 1000
    -- Amount this item heals for specific characters in the overworld (optional)
    --self.world_heal_amounts = {
    -- NATURES
    -- Susie: Potions sting because they sterilise wounds, and Susie isn't particularly expecting that I guess?
    --    ["susie"] = 50
    --}

    -- Default shop price (sell price is halved)
    self.price = 250
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
        kris = "Tastes... blue.",
        susie = "sample text",  -- give dialogue
        quartz = "sample text", -- give dialogue
    }
end

return item