local materialsCache = {}
function lia.utility.GetMaterial(sMaterialPath, sParams)
    if not sMaterialPath then return end

    if materialsCache[sMaterialPath] then
        return materialsCache[sMaterialPath]
    end

    local material = Material(sMaterialPath, sParams or "")
    materialsCache[sMaterialPath] = material

    return material
end

function lia.utility.FindPlayer(identifier)
    for k, v in player.Iterator() do
        if identifier == v:SteamID() or identifier == v:SteamID64() or identifier:find(v:Name()) then
            return v
        end
    end

    return nil
end