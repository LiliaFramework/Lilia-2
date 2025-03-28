-- Disable vehicle driving (not needed for RP)
function GM:CanDrive()
    return false
end

-- Prevent players from suiciding (immersion/RP reasons)
function GM:CanPlayerSuicide()
    return false
end

-- Disallow picking up objects with +use (typically unnecessary)
function GM:AllowPlayerPickup()
    return false
end