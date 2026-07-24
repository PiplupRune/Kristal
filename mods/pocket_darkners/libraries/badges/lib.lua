BadgesLib = {}
local lib = BadgesLib

function lib:init()
    self.badge_points = 3
end

function lib:load(data, is_new_file, index)
    if data.badge_points then
        self.badge_points = data.badge_points
    end
end

function lib:save(data)
    data.badge_points = self.badge_points
end

function lib:preUpdate()
end

function lib:getStorage()
    return Game.inventory:getStorage("badges")
end

function lib:postUpdate()
    local storage = self:getStorage()

    if (not storage) then
        return
    end

    for _, badge in ipairs(storage) do
        badge:update(badge.equipped)
    end
end

function lib:createDarkInventory(inventory)
    inventory.storages["badges"] = {id = "badges", max = 48, sorted = true, name = "BADGEs", fallback = nil}
end

function lib:getTotalBadgePoints()
    return self.badge_points
end

function lib:getUsedBadgePoints()
    local total_bp = 0
    local storage = self:getStorage()

    if (not storage) then
        return 0
    end

    for _, badge in ipairs(storage) do
        if badge.equipped then
            total_bp = total_bp + badge:getBadgePoints()
        end
    end
    return total_bp
end

function lib:getBadgeEquipped(badge)
    local total_count = 0
    local storage = self:getStorage()

    if (not storage) then
        return 0
    end

    for _, b in ipairs(storage) do
        if b.equipped and b.id == badge then
            total_count = total_count + 1
        end
    end
    return total_count
end

return lib