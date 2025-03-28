include( "shared.lua" )
include( "core/sh_util.lua" )

lia = lia or {
	gui = {},
}

local oldLocalPlayer = LocalPlayer
function LocalPlayer()
	if !IsValid(lia.localClient) then
		lia.localClient = oldLocalPlayer()
	end

	return lia.localClient
end