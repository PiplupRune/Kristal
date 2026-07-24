---@class DarkInventory : Object
---@overload fun(...) : DarkMenu
local DarkInventory, super = Class("DarkInventory", true)

function DarkInventory:init()
    super.init(self)
    self.storage_for_type["berries"] = "berries"
end

return DarkInventory