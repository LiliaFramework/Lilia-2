lia.character = lia.character or {}

function lia.character.Create( data, id )
	data.schema = SCHEMA and SCHEMA.folder or "lilia"
	data.createTime = math.floor( os.time() )
	data.money = data.money or lia.config.Get( "startMoney", 10 )

	// create it in the database
	local mysql = mysql:Insert("lia_characters")
		mysql:Insert( "name", data.name or "" )
		mysql:Insert( "description", data.description or "" )
		mysql:Insert( "model", data.model or "" )
		mysql:Insert( "faction", data.faction or "" )
		mysql:Insert( "data", util.TableToJSON( data.data or {} ) )
		mysql:Insert( "steamID", data.steamID )
		mysql:Insert( "schema", data.schema )
		mysql:Insert( "createTime", data.createTime )
		mysql:Insert( "money", data.money )

		mysql:Callback(function(result, status, lastID)
			local invQuery = mysql:Insert("lia_inventories")
				invQuery:Insert( "character_id", id )
				invQuery:Insert( "inventory_id", 1 )
				invQuery:Insert( "inventory_type", "main" )

				invQuery:Callback(function(iresult, istatus, invLastID)
					local character = lia.character.New(data, lastID, player.GetBySteamID64(data.steamID), data.steamID)

					if result and result > 0 then
						character.vars.invID = lastID
					end

					for k, v in pairs( lia.character.vars ) do
						if v.field and data[ v.field ] ~= nil then
							character.vars[ k ] = data[ v.field ]
						end
					end

					character.vars.id = lastID
					lia.character.loaded[lastID] = character

					hook.Run("OnCharacterCreated", character, data)
				end)
			invQuery:Execute()
		end)
	mysql:Execute()

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