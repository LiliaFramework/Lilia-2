local characterMeta = lia.meta.character or {}
characterMeta.__index = characterMeta
characterMeta.id = characterMeta.id or 0
characterMeta.vars = characterMeta.vars or {}
characterMeta.data = characterMeta.data or {}

function characterMeta:GetID()
	return self.id
end

function characterMeta:__tostring()
	return "Character #" .. self.id
end

function characterMeta:GetPlayer()
	return self.player
end

function characterMeta:Save()
	if not self.id or self.id <= 0 then return end

	local query = mysql:Update("lia_characters")
		query:Update("name", self.vars.name)
		query:Update("description", self.vars.description)
		query:Update("model", self.vars.model)
		query:Update("faction", self.vars.faction)
		query:Update("data", util.TableToJSON(self.vars.data))
		query:Update("money", self.vars.money)
		query:Where("id", self.id)
		query:Callback(function(result, status, lastID)
			hook.Run("OnCharacterSaved", self, self.vars)
		end)
	query:Execute()
end

lia.meta.character = characterMeta