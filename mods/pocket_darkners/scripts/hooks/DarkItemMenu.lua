local DarkItemMenu, super = HookSystem.hookScript(DarkItemMenu)


function DarkItemMenu:getCurrentStorage()
    local base_storage = super.getCurrentStorage(self)
    local filtered_storage = {}

    for _, item in ipairs(base_storage) do
        if item and not item.berry_type and not item.seed_type then
            table.insert(filtered_storage, item)
        end
    end
    if base_storage.max then
        filtered_storage.max = base_storage.max
    end

    return filtered_storage
end

return DarkItemMenu
