hook.liaCall = hook.liaCall or hook.Call

local default = {
	["SCHEMA"] = true
}

function hook.Call(name, gm, ...)
	for k, v in pairs(default) do
		local tab = _G[k]
		if not tab then continue end

		local fn = tab[name]
		if not fn then continue end

		local a, b, c, d, e, f = fn(tab, ...)

		if a != nil then
			return a, b, c, d, e, f
		end
	end

	for k, v in pairs(lia.module.stored) do
		for k2, v2 in pairs(v) do
			if type(v2) == "function" and k2 == name then
				local a, b, c, d, e, f = v2(v, ...)

				if a != nil then
					return a, b, c, d, e, f
				end
			end
		end
	end

	return hook.liaCall(name, gm, ...)
end

function GM:GetGameDescription()
	-- TODO, Schema Name Support
	return "Lilia"
end

-- Disable vehicle driving (not needed for RP)
function GM:CanDrive()
	return false
end

function GM:InitPostEntity()
	if CLIENT then
		lia.localClient = LocalPlayer()
		lia.option.Load()
	end
end

function GM:CanPlayerManageConfig( pClient )
	return CAMI.PlayerHasAccess( pClient, "Lilia - Manage Config", nil )
end

function GM:CanPlayerCreateCharacter( pClient )
	return true
end

function GM:ModuleShouldLoad( sModuleID )
	return true
end

function GM:CanPlayerJoinFaction( pClient, iTeamIndex, iOldTeamIndex )
	return true
end