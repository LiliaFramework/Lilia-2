DeriveGamemode("sandbox")
GM.Name = "Lilia"
GM.Author = "Samael"
GM.Website = "https://discord.gg/esCRH5ckbQ"

lia = lia or {
	util = {},
	meta = {},
	colors = {},
}

lia.colors.consolePrefix = Color(83, 143, 239)

function lia.print(...)
	local packed = {...}
	packed[#packed + 1] = "\n"

	MsgC(lia.colors.consolePrefix, "[Lilia] ", color_white, unpack(packed))
end

function GM:Initialize()
	-- TODO
	-- Initiate Settings, Config
	-- Initiate Database
	-- Include files
end