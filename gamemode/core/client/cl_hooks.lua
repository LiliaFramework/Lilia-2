function GM:ForceDermaSkin()
    return "lilia"
end

-- Disable default target ID (we'll implement a custom one later)
function GM:HUDDrawTargetID()
    return false
end

-- Disable pickup history UI (not relevant to our gameplay)
function GM:HUDDrawPickupHistory()
    return false
end

-- Disable ammo pickup notification (sandbox feature, unused)
function GM:HUDAmmoPickedUp()
    return false
end

-- Disable kill feed (sandbox feature, not suitable for RP)
function GM:DrawDeathNotice()
    return false
end

function GM:HUDPaint()
    local client = LocalPlayer()
    local hookResult = hook.Run("ShouldDrawHUD", client)
    if hookResult == false then return end

    lia.util.DrawBlur2D(0, 0)
end