lia.option.localOption = lia.option.localOption or {}

function lia.option.Set( sName, sValue )
	if not sName or not sValue then return end

	local option = lia.option.stored[ sName ]
	if option == nil then return end

	if not file.Exists("lilia/options.txt", "DATA" ) then
		file.Write( "lilia/options.txt", "" )
	end

	lia.option.localOption[ sName ] = sValue

	if option.OnSet then
		option:OnSet( sValue )
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

	print("[lia.option] Loaded " .. table.Count( lia.option.localOption ) .. " options.")

	timer.Simple(1, function()
		if not IsValid( LocalPlayer() ) then return end

		net.Start( "lia.option.Load" )
			net.WriteTable( lia.option.localOption )
		net.SendToServer()
	end)
end