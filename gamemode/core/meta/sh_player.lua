local playerMeta = FindMetaTable("Player")

local oldName = playerMeta.Name
function playerMeta:SteamName()
    return oldName(self)
end

function playerMeta:Name()
    if self:GetCharacter() then
        return self:GetCharacter():GetName()
    end

    return self:SteamName()
end

function playerMeta:GetCharacter()
    local selfTable = self:GetTable()

    if selfTable.characterID and selfTable.characterID > 0 then
        return lia.character.loaded[selfTable.characterID]
    end

    return nil
end