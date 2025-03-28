lia.font = lia.font or {
    stored = {}
}

function lia.font.Register(sName, tFontData)
    if not sName or not tFontData then
        return lia.print(lia.color.consoleClientErr, "[Font] Invalid font name or data provided.")
    end

    surface.CreateFont(sName, tFontData)
    lia.font.stored[sName] = tFontData
end

lia.font.Register("liaSmallFont", {
    font = "Segoe UI",
    size = math.max(ScreenScale(6), 17) * 2, -- used 'scale', but it was nil, TODO
    extended = true,
    weight = 500
})

concommand.Add("lia_debug_fonts", function()
    for k, v in pairs(lia.font.stored) do
        lia.print("[\"" .. k .. "\"]")

        for key, value in pairs(v) do
            MsgC("[\"" .. key .. "\"]", ": " .. tostring(value) .. "\n")
        end
    end
end)

hook.Run("OnFontsLoaded")