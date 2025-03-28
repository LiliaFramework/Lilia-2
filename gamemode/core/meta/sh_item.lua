local itemMeta = lia.meta.item or {}
itemMeta.__index = itemMeta
itemMeta.id = itemMeta.id or 0

function itemMeta:GetID()
	return self.id
end

function itemMeta:__tostring()
	return "Inventory #" .. self.id
end

function itemMeta:GetName()
	return self.name or "Unknown Item"
end

function itemMeta:GetWeight()
	return self.weight or 0
end

function itemMeta:GetDescription()
	return self.description or "No description available."
end

lia.meta.item = itemMeta