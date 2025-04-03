lia.module = lia.module or {}
lia.module.stored = lia.module.stored or {}

function lia.module.Load()
	local modulePath = engine.ActiveGamemode() .. "/gamemode/modules/"
	local files, dirs = file.Find(modulePath .. "*", "LUA")
	for k, v in ipairs( dirs ) do
		if file.Exists(modulePath .. v .. "/sh_init.lua", "LUA" ) then
			MODULE = { folder = v }
				lia.Include( modulePath .. v .. "/sh_init.lua" )

				for k2, v2 in pairs(MODULE) do
					if (isfunction(v2)) then
						HOOKS_CACHE[k2] = HOOKS_CACHE[k2] or {}
						HOOKS_CACHE[k2][MODULE] = v
					end
				end

				if MODULE.OnLoad then
					MODULE:OnLoad()
				end
			MODULE = nil
		end
	end

	for k, v in ipairs( files ) do
		MODULE = { folder = string.StripExtension( v ) }
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
		MODULE = nil
	end
end

lia.module.Load()