lia.character = lia.character or {}

function lia.character.New( data, id, steamID )
	local character = setmetatable( { vars = {} }, lia.meta.character )

	for k, v in pairs( lia.character.vars ) do
		if v.field and data[ v.field ] ~= nil then
			character.vars[ k ] = data[ v.field ]
		end
	end

	character.id = id or 0
	character.steamID = steamID

	// create it in the database

	return character
end

function lia.character.Save( charID, data )
	if not charID or not data then return end

	local character = lia.character.loaded[ charID ]
	if not character then return end

	for k, v in pairs( lia.character.vars ) do
		if v.field and data[ v.field ] ~= nil then
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