---@class DarkMenu : Object
---@overload fun(...) : DarkMenu
local DarkMenu, super = Class("DarkMenu", true)

function DarkMenu:init()
    super.init(self)

    self:addButton({
        ["state"]          = "BADGEMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/badge"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/badge_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/badge"),
        ["callback"]       = function()
            self.box = DarkBadgeMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    }, Kristal.getLibConfig("badges", "menu_button_position"))
end

return DarkMenu