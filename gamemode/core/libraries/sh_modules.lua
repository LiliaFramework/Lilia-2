lia.module = lia.module or {}

function lia.module.Load()
	local modulePath = engine.ActiveGamemode() .. "/gamemode/modules/"
	local files, dirs = file.Find(modulePath .. "*", "LUA")
	for k, v in ipairs( dirs ) do
		if file.Exists(modulePath .. v .. "/sh_init.lua", "LUA" ) then
			lia.Include( modulePath .. v .. "/sh_init.lua" )
		end
	end

	for k, v in ipairs( files ) do
		lia.Include(modulePath .. v)
	end
end

lia.module.Load()