local entityMeta = FindMetaTable("Entity")

local chairs = {}
for k, v in pairs(list.Get("Vehicles")) do
    if k:find("Chair") then
        chairs[ v.Model ] = true
    end
end

function entityMeta:IsChair()
    local hookResult = hook.Run("EntityIsChair", self)
    if hookResult ~= nil then
        return hookResult
    end

    local model = self:GetModel()
    if chairs[ model ] then
        return true
    end

    return false
end

function entityMeta:InheritBodygroups( eInheritFrom )
    for k, v in ipairs( self:GetBodyGroups() ) do
        local iBodygroup = eInheritFrom:FindBodygroupByName( v.name )
        if iBodygroup ~= -1 then
            self:SetBodygroup( k - 1, eInheritFrom:GetBodygroup( iBodygroup ) )
        end
    end
end

function entityMeta:InheritSkin( eInheritFrom )
    self:SetSkin( eInheritFrom:GetSkin() )
end

function entityMeta:InheritMaterial( eInheritFrom )
    local material = eInheritFrom:GetMaterial()
    if material and material ~= "" then
        self:SetMaterial( material )
    end

    for i = 0, #eInheritFrom:GetMaterials() do
        local subMaterial = eInheritFrom:GetSubMaterial( i )
        if subMaterial and subMaterial ~= "" then
            self:SetSubMaterial( i, subMaterial )
        end
    end
end

lia.print("InheritBodygroups and other")