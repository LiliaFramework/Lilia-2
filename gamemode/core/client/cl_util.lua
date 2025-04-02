local blurMaterial = lia.utility.GetMaterial( "pp/blurscreen" )

function lia.utility.DrawBlur( panel, amount )
    local scrW, scrH = panel:GetSize()
    local x, y = panel:GetPos()

    x, y = x or 0, y or 0
    amount = amount or 5

    surface.SetDrawColor( lia.color.white )
    surface.SetMaterial( blurMaterial )

    for i = 1, amount do
        blurMaterial:SetFloat( "$blur", ( i / amount ) * 5 )
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( x * -1, y * -1, scrW + ( x * 2 ), scrH + ( y * 2 ) )
    end

    surface.SetDrawColor( lia.color.white )
    surface.SetMaterial( blurMaterial )

    blurMaterial:SetFloat( "$blur", 0 )
    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect( x, y, scrW, scrH )
end

function lia.utility.DrawBlur2D( x, y, width, height, amount )
    local scrW, scrH = ScrW(), ScrH()
    x, y = x or 0, y or 0
    width, height = width or scrW, height or scrH
    amount = amount or 5

    surface.SetDrawColor( lia.color.white )
    surface.SetMaterial( blurMaterial )

    for i = 1, amount do
        blurMaterial:SetFloat( "$blur", ( i / amount ) * 5 )
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( x * -1, y * -1, scrW, scrH )
    end

    surface.SetDrawColor( lia.color.white )
    surface.SetMaterial( blurMaterial )

    blurMaterial:SetFloat( "$blur", 0 )
    render.UpdateScreenEffectTexture()
    surface.DrawTexturedRect( x, y, width, height )
end