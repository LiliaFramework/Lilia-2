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

		if not tVarData.bNotModifiable then
			if tVarData.OnSet then
				CHAR["Set" .. upperName] = function(self, value)
					self.vars[sName] = value
					tVarData.OnSet(value)
				end
			elseif tVarData.bNoNetworking then
				CHAR["Set" .. upperName] = function(self, value)
					self.vars[sName] = value
				end
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

	if (tVarData.OnGet) then
		CHAR["Get" .. upperName] = tVarData.OnGet
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
			if v != nil then
				character.vars[k] = v
			end
		end

		character.id = id or 0
		character.player = client

		character.steamID = SERVER and IsValid(client) and client:SteamID64() or steamID

	return character
end

if SERVER then
	function lia.character.Create( data, id )
		data.schema = SCHEMA and SCHEMA.folder or "lilia"
		data.createTime = math.floor( os.time() )
		data.money = data.money or lia.config.Get( "startMoney", 10 )

		local mysql = mysql:Insert("lia_characters")
			mysql:Insert( "name", data.name or "" )
			mysql:Insert( "description", data.description or "" )
			mysql:Insert( "model", data.model or "" )
			mysql:Insert( "faction", data.faction or "" )
			mysql:Insert( "data", util.TableToJSON( data.data or {} ) )
			mysql:Insert( "steamID", data.steamID )
			mysql:Insert( "schema", data.schema )
			mysql:Insert( "create_time", data.createTime )
			mysql:Insert( "money", data.money )

			mysql:Callback(function(result, status, lastID)
				if not result or result == 0 then return end -- this prevents the error LOL

				local invQuery = mysql:Insert("lia_inventories") -- TODO: this line causes error
					invQuery:Insert( "character_id", id )
					invQuery:Insert( "inventory_id", 1 )
					invQuery:Insert( "inventory_type", 0 )

					invQuery:Callback(function(iresult, istatus, invLastID)
						local character = lia.character.New(data, lastID, player.GetBySteamID64(data.steamID), data.steamID)

						if result and result > 0 then
							character.vars.invID = lastID
						end

						for k, v in pairs( lia.character.vars ) do
							if v.field and data[ v.field ] != nil then
								character.vars[ k ] = data[ v.field ]
							end
						end

						character.vars.id = lastID
						lia.character.loaded[lastID] = character

						hook.Run("OnCharacterCreated", character, data)

						return character
					end)
				invQuery:Execute()
			end)
		mysql:Execute()
	end

	function lia.character.Save( charID, data )
		if not charID or not data then return end

		local character = lia.character.loaded[ charID ]
		if not character then return end

		for k, v in pairs( lia.character.vars ) do
			if v.field and data[ v.field ] != nil then
				character.vars[ k ] = data[ v.field ]
			end
		end

		hook.Run( "CharacterSaved", character, data )
	end

	function lia.character.Remove( charID )
		if not charID then return end

		local character = lia.character.loaded[ charID ]
		if not character then return end

		hook.Run( "CharacterRemoved", character )

		lia.character.loaded[charID] = nil
		lia.database.query( "DELETE FROM lia_characters WHERE id = " .. charID .. ";", function() end )
	end

	function lia.character.Load( charID, data )
		if not charID or not data then return end

		local character = lia.character.loaded[ charID ]
		if character then return end

		character = lia.character.New( data, charID, data.steamID )

		lia.character.loaded[ charID ] = character
		hook.Run( "CharacterLoaded", character, data )
	end
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

lia.character.RegisterVariable("money", {
	field = "money",
	fieldType = lia.type.number,
	default = 0,
	noNetwork = false,
})

lia.character.RegisterVariable("data", {
	field = "data",
	fieldType = lia.type.string,
	default = "",
	noNetwork = false,
	OnGet = function(self, default)
		if (self.vars.data) then
			return util.JSONToTable(self.vars.data) or {}
		end

		return default or {}
	end,
	OnSet = function(self, value)
		if (value) then
			self.vars.data = util.TableToJSON(value)
		end
	end,
})

lia.character.RegisterVariable("schema", {
	field = "schema",
	fieldType = lia.type.string,
	bNoDisplay = true,
	bNoNetworking = true,
	bNotModifiable = true,
	bSaveLoadInitialOnly = true
})

lia.character.RegisterVariable("steamID", {
	field = "steamid",
	fieldType = lia.type.steamid,
	bNoDisplay = true,
	bNoNetworking = true,
	bNotModifiable = true,
	bSaveLoadInitialOnly = true
})

lia.character.RegisterVariable("createTime", {
	field = "create_time",
	fieldType = lia.type.number,
	bNoDisplay = true,
	bNoNetworking = true,
	bNotModifiable = true
})

--- Returns the Unix timestamp of when this character was last used by its owning player.
-- @realm server
-- @treturn number Unix timestamp of when this character was last used
-- @function GetLastJoinTime
lia.character.RegisterVariable("lastJoinTime", {
	field = "last_join_time",
	fieldType = lia.type.number,
	bNoDisplay = true,
	bNoNetworking = true,
	bNotModifiable = true,
	bSaveLoadInitialOnly = true
})