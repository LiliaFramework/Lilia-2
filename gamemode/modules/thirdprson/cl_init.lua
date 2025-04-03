local MODULE = MODULE

function MODULE:CanOverrideView( pClient )
    if IsValid( pClient:GetVehicle() ) then return false end
    if pClient:GetMoveType() == MOVETYPE_NOCLIP then return false end

    return true
end

function MODULE:CalcView( pClient, vOrigin, aAngles, fFov) -- TODO, hooks ain't called, someone fix this shit
    if not lia.option.Get( "thirdperson", false ) or not self:CanOverrideView(pClient) then return end

    local view = {}
    view.drawviewer = true

    local trace
    trace = util.TraceHull({
        start = vOrigin,
        endpos = vOrigin + aAngles:Forward() * lia.option.Get("thirdperson_offset_x", 0) - aAngles:Right() * lia.option.Get("thirdperson_offset_y", 0) - aAngles:Up() * lia.option.Get("thirdperson_offset_z", 0) + ( pClient:Crouching() and pClient:GetViewOffsetDucked() or vector_origin ),
        filter = ply,
        mins = Vector(-4, -4, -4),
        maxs = Vector(4, 4, 4)
    })

    view.origin = trace.HitPos
    view.angles = aAngles
    view.fov = fFov

    return view
end

concommand.Add("lia_thirdperson_toggle", function()
    lia.option.Set( "thirdperson", not lia.option.Get( "thirdperson" ) )
end)