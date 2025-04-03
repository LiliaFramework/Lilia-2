lia.module = lia.module or {}
lia.module.stored = lia.module.stored or {}

function lia.module.Load()
	local modulePath = engine.ActiveGamemode() .. "/gamemode/modules/"
	local files, dirs = file.Find( modulePath .. "*", "LUA" )
	for k, v in ipairs( dirs ) do
		if file.Exists( modulePath .. v .. "/sh_init.lua", "LUA" ) then
			MODULE = { uniqueID = v }
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