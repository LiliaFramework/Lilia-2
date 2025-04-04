lia.faction = lia.faction or {}
lia.faction.stored = lia.faction.stored or {}
lia.faction.indices = lia.faction.indices or {}

function lia.faction.Setup( tFactionData )
	local FACTION = {}

	FACTION.name = tFactionData.name or "Faction Name"
	FACTION.description = tFactionData.description or "Faction Description"
	FACTION.color = tFactionData.color or lia.color.white
	FACTION.isDefault = tFactionData.isDefault or true

	FACTION.index = #lia.faction.indices + 1

	team.SetUp(FACTION.index, FACTION.name, FACTION.color, true)

	lia.faction.stored[tFactionData.uniqueID] = FACTION
	lia.faction.indices[FACTION.index] = FACTION

	return FACTION.index
end

if SERVER then
	function lia.faction.Set( pClient, iTeamIndex )
		if not pClient:IsPlayer() then return end
		if not iTeamIndex or iTeamIndex < 1 or not lia.faction.indices[iTeamIndex] then return end

		local oldTeam = pClient:Team()

		local hookResult = hook.Run("CanPlayerJoinFaction", pClient, iTeamIndex, oldTeam)
		if hookResult == false then return end

		pClient:SetTeam(iTeamIndex)

		hook.Run("PlayerJoinedFaction", pClient, iTeamIndex, oldTeam)
	end
end