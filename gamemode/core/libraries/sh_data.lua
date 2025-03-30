file.CreateDir("lilia")
lia.data = lia.data or {}
lia.data.stored = lia.data.stored or {}

local function GetDataPath(bIgnoreMap)
    return "lilia/" .. (bIgnoreMap and "data" or game.GetMap() .. "/")
end

function lia.data.Set(sKey, value, bIgnoreMap)
    local path = GetDataPath(bIgnoreMap)

    file.CreateDir(path)

    file.Write(path .. ".txt", util.TableToJSON({value}))

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

    local contents = file.Read(path .. ".txt", "DATA")

    if contents and contents != "" then
        local success, data = pcall(util.JSONToTable, contents)
        if success and istable(data) then
           value = data

           if value != nil then
                return value
           end
        end
    end

    return default
end

function lia.data.Remove(sKey, bIgnoreMap)
    local path = GetDataPath(bIgnoreMap)

    local contents = file.Read(path .. ".txt", "DATA")

    if contents and contents != "" then
        file.Delete(path .. ".txt")
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