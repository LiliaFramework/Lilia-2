lia.item = lia.item or {}
lia.item.stored = {}
lia.item.indices = {}

local itemDataDefaults = {
    name = "Unknown Item",
    description = "No description available.",
    weight = 0,
    model = "models/props_c17/oildrum001.mdl",
}

function lia.item.Register( tItemData )
    for k, v in pairs(itemDataDefaults) do
        if tItemData[k] == nil then
            tItemData[k] = v
        end
    end

    lia.item.stored[tItemData.uniqueID] = tItemData

    return tItemData
end