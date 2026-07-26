local item, super = Class(Item, "oran_seed")

function item:init()
    super.init(self)

    self.name = "Oran Seed"
    self.use_name = nil
    self.backpack_type = "seeds"
    self.type = "item"
    self.icon = nil

    self.effect = ""
    self.shop = ""
    self.description = "A seed that when planted, will grow into a beautiful Oran Berry bush!"

    self.heal_amount = 30
    self.world_heal_amounts = {}

    self.price = 15
    self.can_sell = true
    self.target = "none" 
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {}
    self.bonus_name = nil
    self.bonus_icon = nil
    self.can_equip = {}

    self.reactions = {
        kris = "sample text",
        susie = "sample text",
        quartz = "sample text",
    }
end

function item:onWorldMenuSelect(menu)
    Game.world:closeMenu()
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* Would you like to use the\n[color:yellow]"..self:getName().."[color:reset] and plant it?")
        local choice = cutscene:choicer({"Yes", "No"})
        if choice == 1 then 
            Assets.playSound("grab")
            cutscene:wait(0.5)
            cutscene:text("* The [color:yellow]"..self:getName().."[color:reset] was planted successfully!")
            Game.inventory:removeItem(self)
            menu:updateSelectedItem()
        end 
    end)
end 

return item
