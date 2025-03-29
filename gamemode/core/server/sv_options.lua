lia.option = lia.option or {}
lia.option.client = lia.option.client or {}

function lia.option.Set( client, sName, sValue )
	if not sName or not sValue then return end

	local option = lia.option.Get(sName)
	if not option then
		return lia.error("Option " .. sName .. " does not exist!")
	end

	lia.option.client[client] = lia.option.client[client] or {}
	lia.option.client[client][sName] = sValue

	if option.OnSet then
		option:OnSet(client, sValue)
	end
end

function lia.option.Get( client, sName, fallback )
	if not client or not sName then return end

	local option = lia.option.stored[ sName ]
	if not option then
		return lia.error("Option " .. sName .. " does not exist!")
	end

	lia.option.client[ client ] = lia.option.client[ client ] or {}
	return lia.option.client[ client ][ sName ] or fallback or option.default
end