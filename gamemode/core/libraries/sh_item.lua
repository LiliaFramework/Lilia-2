lia.item = lia.item or {}
lia.item.stored = {}
lia.item.indices = {}
lia.item.bases = {}

local itemDataDefaults = {
    name = "Unknown Item",
    description = "No description available.",
    weight = 0,
    model = "models/props_c17/oildrum001.mdl",
}

function lia.item.Register( tItemData, baseID, bIsBaseItem )
    if tItemData.base and lia.item.bases[tItemData.base] then
        tItemData = table.Copy(lia.item.bases[tItemData.base]) -- TODO: not sure if this is correct
    end

    for k, v in pairs(itemDataDefaults) do
        if tItemData[k] == nil then
            tItemData[k] = v
        end
    end

    if tItemData.uniqueID == nil or not isstring(tItemData.uniqueID) then
        lia.error("Item must have a uniqueID string.")
        return
    end

    if lia.item.stored[tItemData.uniqueID] then
        lia.error("Item with uniqueID '" .. tItemData.uniqueID .. "' already exists.")
        return
    end

    (bIsBaseItem and lia.item.bases or lia.item.stored)[tItemData.uniqueID] = tItemData

    hook.Run("OnItemRegistered", tItemData)
    return tItemData
end