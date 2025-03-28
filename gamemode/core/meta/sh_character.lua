local characterMeta = lia.meta.character or {}
characterMeta.__index = characterMeta
characterMeta.id = characterMeta.id or 0
characterMeta.vars = characterMeta.vars or {}

function characterMeta:GetID()
	return self.id
end

function characterMeta:__tostring()
	return "Character #" .. self.id
end

function characterMeta:GetPlayer()
end

lia.meta.character = characterMeta