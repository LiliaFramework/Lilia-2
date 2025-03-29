function GM:GetGameDescription()
    -- TODO, Schema Name Support
    return "Lilia"
end

-- Disable vehicle driving (not needed for RP)
function GM:CanDrive()
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
            for _, v in pairs(lia.character.vars) do
                if v.field and not existing[v.field] and typeMap[v.fieldType] then
                    local colDef = typeMap[v.fieldType](v)
                    if v.default ~= nil then colDef = colDef .. " DEFAULT '" .. tostring(v.default) .. "'" end

                    local alter = ("ALTER TABLE lia_characters ADD COLUMN %s"):format(colDef)
                    lia.database.query(alter, function() lia.print("[Database] ", lia.color.green, string.format("Added missing column `%s`.\n", v.field)) end)
                end
            end
        end)

        DatabaseQueryRan = true
    end
end

function GM:InitPostEntity()
    if CLIENT then
        lia.localClient = LocalPlayer()
    else
        DatabaseQuery()
    end
end