file.CreateDir("lilia")
lia.data = lia.data or {}
lia.data.stored = lia.data.stored or {}

local function GetDataPath( bIgnoreMap )
    return "lilia/"
end

function lia.data.Set(sKey, sValue, bIgnoreMap)
    local path = GetDataPath( bIgnoreMap )

    file.CreateDir( path )

    if not bIgnoreMap then
        lia.data.stored[ game.GetMap() ] = table.Copy(lia.data.stored[ game.GetMap() ]) or {}
        lia.data.stored[ game.GetMap() ][ sKey ] = sValue

        if sValue == nil and table.Count( lia.data.stored[ game.GetMap() ] ) == 0 then
            lia.data.stored[ game.GetMap() ] = nil
        end
    else
        lia.data.stored[ sKey ] = sValue
    end

    file.Write( path .. "data.txt", util.TableToJSON( lia.data.stored, true ) )

    return path
end

function lia.data.Get(sKey, default, bIgnoreMap)
    local stored = bIgnoreMap and lia.data.stored[sKey] or lia.data.stored[game.GetMap()] and lia.data.stored[game.GetMap()][sKey]
    if stored != nil then
        return stored
    end

    return default
end

function lia.data.Load()
    local path = GetDataPath()

    if file.Exists( path .. "data.txt", "DATA" ) then
        lia.data.stored = util.JSONToTable( file.Read( path .. "data.txt", "DATA" ) )
    end

    if lia.data.stored == nil then
        lia.data.stored = {}
    end
end

lia.data.Load()

if SERVER then
    timer.Create("liaSaveData", 600, 0, function()
        hook.Run("SaveData")
    end)
end