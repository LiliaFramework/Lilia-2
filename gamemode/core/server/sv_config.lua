lia.config = lia.config or {}
lia.config.stored = lia.config.stored or {}
lia.config.values = lia.config.values or {}

function lia.config.Set( sName, sValue )
	if not sName or not sValue then return end

	local config = lia.config.stored[ sName ]
	if not config then
		return lia.error( "Config " .. sName .. " does not exist!" )
	end

	lia.config.values[ sName ] = sValue

	if config.OnSet then
		config:OnSet( sValue )
	end

	net.Start( "lia.config.Set" )
		net.WriteString( sName )
		net.WriteType( sValue )
	net.Broadcast()
end