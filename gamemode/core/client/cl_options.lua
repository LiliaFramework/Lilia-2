lia.option = lia.option or {}
lia.option.localOption = lia.option.localOption or {}

function lia.option.Set( sName, sValue )
	if not sName or not sValue then return end

	local option = lia.option.Get( sName )
	if not option then
		return lia.error("Option " .. sName .. " does not exist!")
	end

	lia.option.localOption[ sName ] = sValue

	if option.OnSet then
		option:OnSet( sValue )
	end
end

function lia.option.Get( sName, fallback )
	if not sName then return end

	local option = lia.option.stored[ sName ]
	if not option then
		return lia.error("Option " .. sName .. " does not exist!")
	end

	return lia.option.localOption[ sName ] or fallback or option.default
end