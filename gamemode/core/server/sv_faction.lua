function lia.faction.Set( pClient, iTeamIndex )
    if not pClient:IsPlayer() then return end
    if not iTeamIndex or iTeamIndex < 1 or not lia.faction.indices[iTeamIndex] then return end

    local oldTeam = pClient:Team()

    local hookResult = hook.Run("CanPlayerJoinFaction", pClient, iTeamIndex, oldTeam)
    if hookResult == false then return end

    pClient:SetTeam(iTeamIndex)

    hook.Run("PlayerJoinedFaction", pClient, iTeamIndex, oldTeam)
end