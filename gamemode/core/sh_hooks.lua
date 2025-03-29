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
    end
end

function GM:CanPlayerManageConfig( pClient )
    return CAMI.PlayerHasAccess( pClient, "Lilia - Manage Config", nil )
end

function GM:CanPlayerCreateCharacter( pClient )
    return true
end