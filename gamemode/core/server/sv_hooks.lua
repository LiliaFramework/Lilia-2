-- Prevent players from suiciding (immersion/RP reasons)
function GM:CanPlayerSuicide()
    return false
end

-- Disallow picking up objects with +use (typically unnecessary)
function GM:AllowPlayerPickup()
    return false
end

-- Disallow players of placing their own sprays
function GM:PlayerSpray()
    return false
end

local typeMap = {
    ["string"] = function(d) return ("%s VARCHAR(%d)"):format(d.field, d.length or 255) end,
    integer = function(d) return ("%s INT"):format(d.field) end,
    float = function(d) return ("%s FLOAT"):format(d.field) end,
    boolean = function(d) return ("%s TINYINT(1)"):format(d.field) end,
    datetime = function(d) return ("%s DATETIME"):format(d.field) end,
    text = function(d) return ("%s TEXT"):format(d.field) end
}

local function DatabaseQuery()
    if not DatabaseQueryRan then
        local dbModule = lia.database.module or "sqlite"
        local getColumnsQuery = dbModule == "sqlite" and "SELECT sql FROM sqlite_master WHERE type='table' AND name='lia_characters'" or "DESCRIBE lia_characters"
        lia.database.query(getColumnsQuery, function(results)
            local existing = {}
            if results and #results > 0 then
                if dbModule == "sqlite" then
                    local createSQL = results[1].sql or ""
                    for def in createSQL:match("%((.+)%)"):gmatch("([^,]+)") do
                        local col = def:match("^%s*`?(%w+)`?")
                        if col then existing[col] = true end
                    end
                else
                    for _, row in ipairs(results) do
                        existing[row.Field] = true
                    end
                end
            end

            -- TODO: Character Var support
            --[[
            for _, v in pairs(lia.char.vars) do
                if v.field and not existing[v.field] and typeMap[v.fieldType] then
                    local colDef = typeMap[v.fieldType](v)
                    if v.default ~= nil then colDef = colDef .. " DEFAULT '" .. tostring(v.default) .. "'" end
                    local alter = ("ALTER TABLE lia_characters ADD COLUMN %s"):format(colDef)
                    lia.database.query(alter, function() MsgC(Color(83, 143, 239), "[Lilia] ", Color(0, 255, 0), "[Database] ", Color(255, 255, 255), string.format("Added missing column `%s`.\n", v.field)) end)
                end
            end
            ]]
        end)

        DatabaseQueryRan = true
    end
end

hook.Add("InitPostEntity", "DatabaseQuery", DatabaseQuery)

function GM:OnMySQLOOConnected()
    hook.Run("RegisterPreparedStatements")
    MYSQLOO_PREPARED = true
end

function GM:LiliaTablesLoaded()
    local ignore = function() end
    lia.database.query("ALTER TABLE IF EXISTS lia_players ADD COLUMN _firstJoin DATETIME"):catch(ignore)
    lia.database.query("ALTER TABLE IF EXISTS lia_players ADD COLUMN _lastJoin DATETIME"):catch(ignore)
    lia.database.query("ALTER TABLE IF EXISTS lia_items ADD COLUMN _quantity INTEGER"):catch(ignore)
end