file.CreateDir("lilia")
lia.data = lia.data or {}
lia.data.stored = lia.data.stored or {}

local function GetDataPath(bIgnoreMap)
    return "lilia/" .. SCHEMA.folder .. "/" .. (bIgnoreMap and "" or game.GetMap() .. "/")
end

function lia.data.Set(sKey, value, bIgnoreMap)
    local path = GetDataPath(bIgnoreMap)

    file.CreateDir(path)

    file.Write(path .. sKey .. ".txt", util.TableToJSON({value}))

    lia.data.stored[sKey] = value

    return path
end

function lia.data.Get(sKey, default, bIgnoreMap, bRefresh)
    if not bRefresh then
        local stored = lia.data.stored[sKey]

        if stored != nil then
            return stored
        end
    end

    local path = GetDataPath( bIgnoreMap)

    local contents = file.Read(path .. sKey .. ".txt", "DATA")

    if contents and contents != "" then
        local stat, decoded = pcall(util.JSONToTable, contents)

        if stat and decoded then
            local value = decoded[1]

            if value != nil then
                return value
            end
        end
    end

    return default
end

function lia.data.Remove(sKey, bIgnoreMap)
    local path = GetDataPath(bIgnoreMap)

    local contents = file.Read(path .. sKey .. ".txt", "DATA")

    if contents and contents != "" then
        file.Delete(path .. sKey .. ".txt")
        lia.data.stored[sKey] = nil

        return true
    end

    return false
end

if SERVER then
    timer.Create("liaSaveData", 600, 0, function()
        hook.Run("SaveData")
    end)
end