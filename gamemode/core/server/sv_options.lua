lia.option = lia.option or {}
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

	lia.option.client[ client ] = lia.option.client[ client ] or {}
	return lia.option.client[ client ][ sName ] or fallback or option.default
end