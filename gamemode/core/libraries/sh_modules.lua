lia.module = lia.module or {}
lia.module.stored = {}

local modulePath = "lilia/gamemode/modules/"

function lia.module.Load()
	local files, dirs = file.Find( modulePath .. "*", "LUA" )
	for k, v in ipairs( dirs ) do
		if hook.Run( "ModuleShouldLoad", v ) == false then continue end

		if file.Exists( modulePath .. v .. "/sh_init.lua", "LUA" ) then
			MODULE = {}
				MODULE.uniqueID = v
				MODULE.name = MODULE.name or "Unknown Name"
				MODULE.desc = MODULE.desc or "Unknown Description"
				MODULE.author = MODULE.author or "Unknown Author"

				lia.Include( modulePath .. v .. "/sh_init.lua" )

				for k2, v2 in pairs(MODULE) do
					if isfunction(v2) then
						HOOKS_CACHE[k2] = HOOKS_CACHE[k2] or {}
						HOOKS_CACHE[k2][MODULE] = v
					end
				end

				if MODULE.OnLoad then
					MODULE:OnLoad()
				end

				lia.module.stored[v] = MODULE
			MODULE = nil
		end
	end

	for k, v in ipairs( files ) do
		local uniqueID = v
		if string.StartsWith( uniqueID, "sh_" ) or string.StartsWith( uniqueID, "cl_" ) or string.StartsWith( uniqueID, "sv_" ) then
			uniqueID = string.sub( uniqueID, 4 )
		end

		uniqueID = string.StripExtension( uniqueID )

		if hook.Run( "ModuleShouldLoad", uniqueID ) == false then continue end

		MODULE = { uniqueID = uniqueID }
			lia.Include( modulePath .. v )

			for k2, v2 in pairs(MODULE) do
				if (isfunction(v2)) then
					HOOKS_CACHE[k2] = HOOKS_CACHE[k2] or {}
					HOOKS_CACHE[k2][MODULE] = v
				end
			end

			if MODULE.OnLoad then
				MODULE:OnLoad()
			end

			lia.module.stored[v] = MODULE
		MODULE = nil
	end
end

lia.module.Load()