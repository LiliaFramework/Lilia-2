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
	if (self.isBot) then return end

	local shouldSave = hook.Run("CharacterPreSave", self)

	if (shouldSave != false) then
		-- Run a query to save the character to the database.
		local query = mysql:Update("lia_characters")
			-- update all character vars
			for k, v in pairs(lia.character.vars) do
				if (v.field && self.vars[k] != nil && !v.bSaveLoadInitialOnly) then
					local value = self.vars[k]

					query:Update(v.field, istable(value) && util.TableToJSON(value) or tostring(value))
				end
			end

			query:Where("id", self:GetID())
			query:Callback(function()
				if (callback) then
					callback()
				end

				hook.Run("CharacterPostSave", self)
			end)
		query:Execute()
	end
end

lia.meta.character = characterMeta