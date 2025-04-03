-- TODO, Character library
lia.character = lia.character or {}
lia.character.loaded = lia.character.loaded or {}
lia.character.vars = lia.character.vars or {}
lia.meta.character = lia.meta.character or {}

function lia.character.RegisterVariable( sName, tVarData )
	if not sName or not tVarData then return end

	tVarData.field = tVarData.field or sName
	tVarData.fieldType = tVarData.fieldType or "string"
	tVarData.default = tVarData.default or ""
	tVarData.noNetwork = tVarData.noNetwork or false

	lia.character.vars[ sName ] = tVarData

	local characterMeta = lia.meta.character
	local funcName = "Set" .. string.sub( sName, 1, 1 ):upper() .. string.sub( sName, 2 )

	characterMeta[funcName] = function(self, value, receivers)
		if tVarData.OnSet then
			tVarData:OnSet( self, value )
		end

		self.vars[sName] = value

		if not tVarData.noNetwork then
			local recipientFilter = RecipientFilter()
			if receivers == nil then
				recipientFilter:AddAllPlayers()
			elseif istable( receivers ) then
				for _, receiver in ipairs( receivers ) do
					if IsValid(receiver) then
						recipientFilter:AddPlayer( receiver )
					end
				end
			elseif IsValid( receivers ) then
				recipientFilter:AddPlayer(receivers)
			end

			net.Start( "lia.character.UpdateVar" )
				net.WriteUInt( self.id, 32 )
				net.WriteString( sName )
				net.WriteType( value )
			net.Send( receivers )
		end
	end

	funcName = "Get" .. string.sub( sName, 1, 1 ):upper() .. string.sub( sName, 2 )
	characterMeta[ funcName ] = function(self)
		if tVarData.OnGet then
			return tVarData:OnGet( self, self.vars[ sName ] )
		end

		return self.vars[ sName ]
	end
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
	fieldType = "string",
	default = "John Doe",
	noNetwork = false,
})

lia.character.RegisterVariable("description", {
	field = "model",
	fieldType = "string",
	default = "",
	noNetwork = false,
})

lia.character.RegisterVariable("model", {
	field = "model",
	fieldType = "string",
	default = "",
	noNetwork = false,
})

lia.character.RegisterVariable("faction", {
	field = "model",
	fieldType = "string",
	default = "",
	noNetwork = false,
})