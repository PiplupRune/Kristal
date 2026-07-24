local DarkMenu, super = HookSystem.hookScript(DarkMenu)

function DarkMenu:init()
    super.init(self)
    
    self:addButton({
        ["state"]          = "BERRYMENU", 
        ["sprite"]         = Assets.getTexture("ui/menu/btn/berry"),       
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/berry_h"),     
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/berry"),      
        ["callback"]       = function()
            self.box = DarkBerryMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    }, 2)
end

return DarkMenu
