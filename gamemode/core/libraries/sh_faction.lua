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