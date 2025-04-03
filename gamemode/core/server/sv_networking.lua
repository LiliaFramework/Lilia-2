util.AddNetworkString( "lia.character.Create" )
net.Receive( "lia.character.Create", function( length, pClient )
	local hookRun = hook.Run( "CanPlayerCreateCharacter", pClient )
	if hookRun == false then return end


end )

util.AddNetworkString( "lia.character.Delete" )
util.AddNetworkString( "lia.character.Load" )
util.AddNetworkString( "lia.character.UpdateVar" )

util.AddNetworkString( "lia.option.Set" )
util.AddNetworkString( "lia.option.Load" )
net.Receive( "lia.option.Load", function( length, pClient )
	local clientOptions = net.ReadTable()
	if not clientOptions then lia.error("NO TABLE") return end

	local clientTable = lia.option.client[ pClient ]
	clientTable = clientTable or {}

	for k, v in pairs( clientOptions ) do
		if lia.option.stored[ k ] then
			clientTable[ k ] = v
		end
	end
end )

util.AddNetworkString( "lia.config.Set" )
net.Receive( "lia.config.Set", function( length, pClient )
	local hookRun = hook.Run( "CanPlayerManageConfig", pClient )
	if hookRun == false then return end

	local sName = net.ReadString()
	local sValue = net.ReadType()

	if not sName or not sValue then return end

	local config = lia.config.stored[ sName ]
	if not config then
		return lia.error( "Config " .. sName .. " does not exist!" )
	end

	lia.config.values[ sName ] = sValue
end )