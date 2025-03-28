local inventoryMeta = lia.meta.inventory or {}
inventoryMeta.__index = inventoryMeta
inventoryMeta.id = inventoryMeta.id or 0
inventoryMeta.vars = inventoryMeta.items or {}

function inventoryMeta:GetID()
	return self.id
end

function inventoryMeta:__tostring()
	return "Inventory #" .. self.id
end

function inventoryMeta:GetOwner()
	return self.owner
end

function inventoryMeta:GetItems()
	return self.items
end

function inventoryMeta:GetItemByID(id)
	return self.items[id]
end

function inventoryMeta:CalculateWeight()
	local weight = 0

	for _, item in pairs(self.items) do
		if item and item:GetWeight() then
			weight = weight + item:GetWeight()
		end
	end

	return weight
end

lia.meta.inventory = inventoryMeta