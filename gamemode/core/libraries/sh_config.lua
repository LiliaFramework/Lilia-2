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

	return config.default or fallback or config.default
end

CAMI.RegisterPrivilege({
	Name = "Lilia - Manage Config",
	Description = "Allows the user to manage the server config.",
	MinAccess = "superadmin"
})

hook.Run( "OnConfigLoaded" )