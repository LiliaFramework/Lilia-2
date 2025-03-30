local lastSysTime = SysTime()
DeriveGamemode("sandbox")

GM.Name = "Lilia"
GM.Author = "Samael"
GM.Website = "https://discord.gg/esCRH5ckbQ"

widgets.PlayerTick = nil
hook.Remove( "PlayerTick", "TickWidgets" )

file.CreateDir("lilia")

lia = lia or {
	util = util or {},
	meta = meta or {},
	color = color or {},
}

lia.type = lia.type or {
	[2] = "string",
	[4] = "text",
	[8] = "number",
	[16] = "player",
	[32] = "steamid",
	[64] = "character",
	[128] = "bool",
	[1024] = "color",
	[2048] = "vector",

	string = 2,
	text = 4,
	number = 8,
	player = 16,
	steamid = 32,
	character = 64,
	bool = 128,
	color = 1024,
	vector = 2048,

	optional = 256,
	array = 512
}

lia.color.consolePrefix = Color( 83, 143, 239 )

lia.color.consoleServerMsg = Color( 156, 241, 255, 200 )
lia.color.consoleServerErr = Color( 136, 221, 255, 255 )

lia.color.consoleClientMsg = Color( 255, 241, 122, 200 )
lia.color.consoleClientErr = Color( 255, 221, 102, 255 )

lia.color.red = Color( 255, 0, 0 )
lia.color.green = Color( 0, 255, 0 )
lia.color.blue = Color( 0, 0, 255 )
lia.color.yellow = Color( 255, 255, 0 )
lia.color.cyan = Color( 0, 255, 255 )
lia.color.springgreen = Color( 0, 255, 127 )
lia.color.orange = Color( 255, 127, 0 )
lia.color.purple = Color( 127, 0, 255 )
lia.color.white = color_white
lia.color.black = color_black
lia.color.transparent = color_transparent
lia.color.gray = Color( 128, 128, 128 )
lia.color.lightgray = Color( 211, 211, 211 )
lia.color.darkgray = Color( 169, 169, 169 )
lia.color.brown = Color( 165, 42, 42 )
lia.color.pink = Color( 255, 192, 203 )
lia.color.gold = Color( 255, 215, 0 )
lia.color.silver = Color( 192, 192, 192 )
lia.color.lime = Color( 0, 255, 0 )
lia.color.teal = Color( 0, 128, 128 )
lia.color.navy = Color( 0, 0, 128 )
lia.color.maroon = Color( 128, 0, 0 )
lia.color.olive = Color( 128, 128, 0 )
lia.color.darkpurple = Color( 128, 0, 128 )

function lia.color.Get( sColorName )
	local copy = lia.color[ sColorName ]
	if copy then
		return table.Copy( copy )
	end

	return table.Copy( color_white )
end

function lia.print( ... )
	local packed = { ... }
	packed[ #packed + 1 ] = "\n"

	MsgC(lia.color.consolePrefix, "[Lilia] ", SERVER and lia.color.consoleServerMsg or lia.color.consoleClientMsg, unpack( packed ) )
end

function lia.error( ... )
	local packed = { ... }
	packed[ #packed + 1 ] = "\n"

	MsgC( SERVER and lia.color.consoleServerErr or lia.color.consoleClientErr, "[Lilia] [ERROR] ", unpack( packed ) )
end

function lia.Include(sName, sRealm)
	if sName == nil then return lia.print( "[Include] ", lia.color.Get( "red" ), "File name is missing" ) end

	if ( realm == "server" or sName:find( "sv_" ) ) and SERVER then
		return include(sName)
	elseif realm == "shared" or sName:find( "shared.lua" ) or sName:find( "sh_" ) then
		if SERVER then
			AddCSLuaFile(sName)
		end

		return include(sName)
	elseif realm == "client" or sName:find("cl_") then
		if SERVER then
			AddCSLuaFile(sName)
		else
			return include(sName)
		end
	end
end

local function IncludeSubDirectories(sDir)
	local directories = select(2, file.Find(sDir .. "*", "LUA"))

	while #directories > 0 do
		local directory = table.remove(directories, 1)
		lia.IncludeDir(sDir .. directory, true, true)
	end
end

function lia.IncludeDir(sDir, bIgnoreBase, bIncludeSubDirs)
	local sBase = "lilia"
	sBase = sBase .. "/gamemode/"

	-- TODO: Schema Support

	if bIgnoreBase then sBase = "" end

	local files = select(1, file.Find(sBase .. sDir .. "/*.lua", "LUA"))
	for _, v in ipairs(files) do
		lia.Include(sBase .. sDir .. "/" .. v)
	end

	if bIncludeSubDirs then
		IncludeSubDirectories(sBase .. sDir .. "/")
	end
end

lia.IncludeDir("core", false, true)

function GM:Initialize()
	-- TODO

	-- Initiate Settings, Config
	-- Initiate Database
	-- Include files
end

function GM:OnReloaded()
	lia.IncludeDir("core", true)

	local currentSysTime = SysTime()
	local deltaTime = currentSysTime - lastSysTime

	lia.print("Reloaded gamemode in " .. string.format("%.2f", deltaTime) .. " seconds")
end