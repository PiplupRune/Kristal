local item, super = Class(HealItem, "darkburger_spec")

function item:init()
    super.init(self)
    
    function item:onBattleUse(user, target)
        Game.battle:startCutscene("quaintonbattle.quartz_fed")
    return super.onBattleUse(self, user, target)
    end

    -- Display name
    self.name = "Darkburger"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Heals\n70HP"
    -- Shop description
    self.shop = "Mysterious\nhamburger\nheals 70HP"
    -- Menu description
    self.description = "A mysterious black burger made of...\nHey, this is just burnt! +70HP"

    -- Amount healed (HealItem variable)
    self.heal_amount = 0
    -- Amount this item heals for specific characters in the overworld (optional)
    --self.world_heal_amounts = {
        --["noelle"] = 20
    --}

    -- Default shop price (sell price is halved)
    self.price = 70
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "battle"
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
        susie = "Cooked to perfection!",
        quartz = "A bit well done...?",
    }


    



end



return item