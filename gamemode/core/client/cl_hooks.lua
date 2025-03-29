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


local elementsToHide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudSuitPower"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudDamageIndicator"] = true,
    ["CHudWeaponSelection"] = true,
}

function GM:ShouldDrawVignette()
    return true
end

function GM:ShouldDrawHUD()
    return true
end

function GM:HUDShouldDraw( sElement )
    -- TODO: When we implement our own HUD, we can return true here to allow drawing of the custom HUD elements

    if elementsToHide[ sElement ] then
    end

    return true
end

local vignetteMaterial = lia.util.GetMaterial( "lilia/vignette.png" )
function GM:HUDPaint()
    local client = LocalPlayer()

    local hookResult = hook.Run( "ShouldDrawHUD" )
    if hookResult == false then return end

    local vignette = hook.Run( "ShouldDrawVignette" )
    if vignette != false then
        surface.SetDrawColor( lia.color.white )
        surface.SetMaterial( vignetteMaterial )
        surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
    end
end