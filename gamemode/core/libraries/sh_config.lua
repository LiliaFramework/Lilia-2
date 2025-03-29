lia.config = lia.config or {}
lia.config.stored = lia.config.stored or {}
lia.config.values = lia.config.values or {}

function lia.config.Register( sName, tData )
	if not sName or not tData then return end

	if lia.config.stored[ sName ] then
		lia.error("Config " .. sName .. " already exists!\n")
		return
	end

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

	return config.default or fallback or config.default
end

hook.Run( "OnConfigLoaded" )