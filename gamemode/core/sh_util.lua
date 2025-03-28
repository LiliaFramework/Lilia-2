local materialsCache = {}
function lia.util.GetMaterial(sMaterialPath, sParams)
    if not sMaterialPath then return end

    if materialsCache[sMaterialPath] then
        return materialsCache[sMaterialPath]
    end

    local material = Material(sMaterialPath, sParams or "")
    materialsCache[sMaterialPath] = material

    return material
end