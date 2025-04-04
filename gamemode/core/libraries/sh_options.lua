lia.option = lia.option or {}
lia.option.stored = {}

function lia.option.Register( sName, tData )
	if not sName or not tData then return end

	lia.option.stored[ sName ] = tData
end

function lia.option.GetAll()
	return lia.option.stored
end

if SERVER then
	lia.option.client = lia.option.client or {}

	function lia.option.Set( pClient, sName, sValue )
		if not IsValid(pClient) or not sName or not sValue then return end

		local option = lia.option.Get(sName)
		if not option then
			return lia.error("Option " .. sName .. " does not exist!")
		end

		lia.option.client[ pClient ] = lia.option.client[ pClient ] or {}
		lia.option.client[ pClient ][ sName ] = sValue

		net.Start( "lia.option.Set" )
			net.WriteString( sName )
			net.WriteType( sValue )
		net.Send( pClient )
	end

	function lia.option.Get( pClient, sName, fallback )
		if not IsValid(pClient) or not sName then return end

		local option = lia.option.stored[ sName ]
		if not option then
			return lia.error("Option " .. sName .. " does not exist!")
		end

		local clientData = lia.option.client[ pClient ]

		clientData = clientData or {}
		return clientData[ sName ] or fallback or option.default
	end
else
	lia.option.localOption = lia.option.localOption or {}

	function lia.option.Set( sName, sValue )
		if sName == nil or sValue == nil then return end

		local option = lia.option.stored[ sName ]
		if option == nil then return end

		if not file.Exists("lilia/options.txt", "DATA" ) then
			file.Write( "lilia/options.txt", "" )
		end

		lia.option.localOption[ sName ] = sValue

		if option.OnSet then
			option:OnSet( sValue )
		end

		if not option.bNoNetworking then
			net.Start( "lia.option.Set" )
				net.WriteString( sName )
				net.WriteType( sValue )
			net.SendToServer()
		end

		file.Write( "lilia/options.txt", util.TableToJSON( lia.option.localOption, true ) )
	end

	function lia.option.Get( sName, fallback )
		if not sName then return end

		local option = lia.option.stored[ sName ]
		if option == nil then
			return lia.error("Option " .. sName .. " does not exist!")
		end

		return lia.option.localOption[ sName ] or fallback or option.default
	end

	function lia.option.Load()
		if file.Exists( "lilia/options.txt", "DATA" ) then
			lia.option.localOption = util.JSONToTable( file.Read( "lilia/options.txt", "DATA" ) )
		end

		if lia.option.localOption == nil then
			lia.option.localOption = {}
		end

		for k, v in pairs( lia.option.stored ) do
			if lia.option.localOption[ k ] == nil then
				lia.option.localOption[ k ] = v.default
			end
		end

		net.Start( "lia.option.Load" )
			net.WriteTable( lia.option.localOption )
		net.SendToServer()
	end
end

hook.Run("OnOptionsLoaded")