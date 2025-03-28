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