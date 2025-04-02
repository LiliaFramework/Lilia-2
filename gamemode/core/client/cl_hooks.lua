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

function GM:ShouldDrawDebugHUD()
    return GetConVar("developer"):GetInt() > 0
end

function GM:HUDShouldDraw( sElement )
    -- TODO: When we implement our own HUD, we can return true here to allow drawing of the custom HUD elements

    if elementsToHide[ sElement ] then
    end

    return true
end

local vignetteMaterial = lia.utility.GetMaterial( "lilia/vignette.png" )
function GM:HUDPaint()
    local client = LocalPlayer()

    local vignette = hook.Run( "ShouldDrawVignette" )
    if vignette != false then
        surface.SetDrawColor( lia.color.white )
        surface.SetMaterial( vignetteMaterial )
        surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
    end

    local debugHUD = hook.Run( "ShouldDrawDebugHUD" )
    if debugHUD != false then
        local rows = {}
        rows[1] = "Lilia Framework 2.0 | " .. GetHostName() .. " (" .. game.GetMap() .. ")"
        local vector = client:GetPos()
        rows[2] = "Client: " .. client:Nick() .. " (" .. client:SteamID64() .. ")" .. " | " .. os.date( "%d/%m/%Y" ) .. " (" ..  os.date( "%H:%M:%S" ) .. ")"
        rows[3] = "Vector " .. math.Round( vector.x, 2 ) .. ", " .. math.Round( vector.y, 2 ) .. ", " .. math.Round( vector.z, 2 )

        local angles = client:GetAngles()
        rows[3] = rows[3] .. " | Angle " .. math.Round( angles.p, 2 ) .. ", " .. math.Round( angles.y, 2 ) .. ", " .. math.Round( angles.r, 2 )
        rows[4] = "FPS " .. math.Round( 1 / FrameTime() ) .. " | Latency: " .. math.Round( client:Ping() ) .. "ms"

        for k, v in ipairs(rows) do
            draw.SimpleText( v, "DebugOverlay", ScrW() - 20, 5 + ( k - 1 ) * 15, k == 1 and lia.color.springgreen or lia.color.white, TEXT_ALIGN_RIGHT )
        end
    end

    local hookResult = hook.Run( "ShouldDrawHUD" )
    if hookResult != false then
        -- Draw the HUD here
    end
end