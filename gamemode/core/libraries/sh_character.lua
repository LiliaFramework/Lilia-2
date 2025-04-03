-- TODO, Character library
lia.character = lia.character or {}
lia.character.loaded = lia.character.loaded or {}
lia.character.vars = lia.character.vars or {}

function lia.character.RegisterVariable( sName, tVarData )
	local CHAR = lia.meta.character
	lia.character.vars[ sName ] = tVarData
	tVarData.index = tVarData.index or table.Count(lia.character.vars)

	local upperName = sName:sub(1, 1):upper() .. sName:sub(2)

	if SERVER then
		if (tVarData.field) then
			lia.database.AddToSchema("lia_characters", tVarData.field, tVarData.fieldType or lia.type.string)
		end

		if (!tVarData.bNotModifiable) then
			if (tVarData.OnSet) then
				CHAR["Set" .. upperName] = function(self, value)
					self.vars[sName] = value
					tVarData.OnSet(value)
				end
			-- Have the set function only set on the server if no networking.
			elseif (tVarData.bNoNetworking) then
				CHAR["Set" .. upperName] = function(self, value)
					self.vars[sName] = value
				end
			-- If the variable is a local one, only send the variable to the local player.
			else
				CHAR["Set" .. upperName] = function(self, value)
					local oldVar = self.vars[sName]
					self.vars[sName] = value

					net.Start("lia.character.UpdateVar")
						net.WriteUInt(self:GetID(), 32)
						net.WriteString(sName)
						net.WriteType(value)
					if tVarData.isLocal then net.Send(self.player) else net.Broadcast() end

					hook.Run("CharacterVarChanged", self, sName, oldVar, value)
				end
			end
		end
	end

	-- The get functions are shared.
	-- Overwrite the get function if desired.
	if (tVarData.OnGet) then
		CHAR["Get" .. upperName] = tVarData.OnGet
	-- Otherwise return the character variable || default if it does not exist.
	else
		CHAR["Get" .. upperName] = function(self, default)
			local value = self.vars[sName]

			if (value != nil) then
				return value
			end

			if (default == nil) then
				return lia.character.vars[sName] and (istable(lia.character.vars[sName].default) and table.Copy(lia.character.vars[sName].default)
					or lia.character.vars[sName].default)
			end

			return default
		end
	end

	local alias = tVarData.alias

	if (alias) then
		if (istable(alias)) then
			for _, v in ipairs(alias) do
				local aliasName = v:sub(1, 1):upper() .. v:sub(2)

				CHAR["Get" .. aliasName] = CHAR["Get" .. upperName]
				CHAR["Set" .. aliasName] = CHAR["Set" .. upperName]
			end
		elseif (isstring(alias)) then
			local aliasName = alias:sub(1, 1):upper() .. alias:sub(2)

			CHAR["Get" .. aliasName] = CHAR["Get" .. upperName]
			CHAR["Set" .. aliasName] = CHAR["Set" .. upperName]
		end
	end

	CHAR.vars[sName] = tVarData.default
end

function lia.character.New(data, id, client, steamID)
	if (data.name) then
		data.name = data.name:gsub("#", "#​")
	end

	if (data.description) then
		data.description = data.description:gsub("#", "#​")
	end

	local character = setmetatable({vars = {}}, lia.meta.character)
		for k, v in pairs(data) do
			if (v != nil) then
				character.vars[k] = v
			end
		end

		character.id = id or 0
		character.player = client

		character.steamID = SERVER and IsValid(client) and client:SteamID64() or steamID

	return character
end

lia.character.RegisterVariable("name", {
	field = "name",
	fieldType = lia.type.string,
	default = "John Doe",
	noNetwork = false,
})

lia.character.RegisterVariable("description", {
	field = "description",
	fieldType = lia.type.string,
	default = "",
	noNetwork = false,
})

lia.character.RegisterVariable("model", {
	field = "model",
	fieldType = lia.type.string,
	default = "",
	noNetwork = false,
})

lia.character.RegisterVariable("faction", {
	field = "faction",
	fieldType = lia.type.number,
	default = 0,
	noNetwork = false,
})