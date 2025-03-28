local playerMeta = FindMetaTable("Player")

local oldName = playerMeta.GetName
function playerMeta:GetName()
    if self.GetCharacter and self:GetCharacter() then
        return self:GetCharacter():GetName()
    end

    return oldName(self)
end