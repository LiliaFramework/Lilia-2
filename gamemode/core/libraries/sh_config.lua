lia.config = lia.config or {}
lia.config.stored = lia.config.stored or {}
lia.config.values = lia.config.values or {}

function lia.config.Register( sName, tData )
	if not sName or not tData then return end

	lia.config.stored[ sName ] = tData
end

function lia.config.GetAll()
	return lia.config.stored
end

function lia.config.Get( sName, fallback )
	if not sName then return end

	local config = lia.config.stored[ sName ]
	if not config then
		return lia.error("Config " .. sName .. " does not exist!")
	end

	return lia.config.values[sName] or fallback or config.default
end

if SERVER then

	function lia.config.Set( sName, sValue )
		if not sName or not sValue then return end

		local config = lia.config.stored[ sName ]
		if not config then
			return lia.error( "Config " .. sName .. " does not exist!" )
		end

		if not file.Exists( "lilia/config.txt", "DATA" ) then
			file.Write( "lilia/config.txt", "" )
		end

		lia.config.values[ sName ] = sValue

		if config.OnSet then
			config:OnSet( sValue )
		end

		net.Start( "lia.config.Set" )
			net.WriteString( sName )
			net.WriteType( sValue )
		net.Broadcast()

		file.Write( "lilia/config.txt", util.TableToJSON( lia.config.values, true ) )
	end

	function lia.config.Load()
		if file.Exists( "lilia/config.txt", "DATA" ) then
			lia.config.values = util.JSONToTable( file.Read( "lilia/config.txt", "DATA" ) )
		end

		if lia.config.values == nil then
			lia.config.values = {}
		end

		for k, v in pairs( lia.config.stored ) do
			if lia.config.values[ k ] == nil then
				lia.config.values[ k ] = v.default
			end

			net.Start( "lia.config.Set" )
				net.WriteString( k )
				net.WriteType( lia.config.stored[k] )
			net.Broadcast()
		end
	end

	lia.config.Load()
end

CAMI.RegisterPrivilege({
	Name = "Lilia - Manage Config",
	Description = "Allows the user to manage the server config.",
	MinAccess = "superadmin"
})

hook.Run( "OnConfigLoaded" )