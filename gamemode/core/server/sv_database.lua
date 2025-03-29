lia.database = lia.database or {
    schema = {},
    schemaQueue = {},
    type = {
        -- TODO: more specific types, lengths, and defaults
        -- i.e INT(11) UNSIGNED, SMALLINT(4), LONGTEXT, VARCHAR(350), NOT NULL, DEFAULT NULL, etc
        [lia.type.string] = "VARCHAR(255)",
        [lia.type.text] = "TEXT",
        [lia.type.number] = "INT(11)",
        [lia.type.steamid] = "VARCHAR(20)",
        [lia.type.bool] = "TINYINT(1)"
    }
}

lia.database.config = {}

function lia.database.Connect()
    lia.database.config.adapter = lia.database.config.adapter or "sqlite"

    local dbmodule = lia.database.config.adapter
    local hostname = lia.database.config.hostname
    local username = lia.database.config.username
    local password = lia.database.config.password
    local database = lia.database.config.database
    local port = lia.database.config.port

    mysql:SetModule(dbmodule)
    mysql:Connect(hostname, username, password, database, port)
end

function lia.database.AddToSchema(schemaType, field, fieldType)
    if ( !lia.database.type[fieldType] ) then
        error(string.format("attempted to add field in schema with invalid type '%s'", fieldType))
        return
    end

    if ( !mysql:IsConnected() or !lia.database.schema[schemaType] ) then
        lia.database.schemaQueue[#lia.database.schemaQueue + 1] = {schemaType, field, fieldType}
        return
    end

    lia.database.InsertSchema(schemaType, field, fieldType)
end

-- this is only ever used internally
function lia.database.InsertSchema(schemaType, field, fieldType)
    local schema = lia.database.schema[schemaType]
    if ( !schema ) then
        error(string.format("attempted to insert into schema with invalid schema type '%s'", schemaType))
        return
    end

    if ( !schema[field] ) then
        schema[field] = true

        local query = mysql:Update("lia_schema")
            query:Update("columns", util.TableToJSON(schema))
            query:Where("table", schemaType)
        query:Execute()

        query = mysql:Alter(schemaType)
            query:Add(field, lia.database.type[fieldType])
        query:Execute()
    end
end

function lia.database.LoadTables()
    local query

    query = mysql:Create("lia_schema")
        query:Create("table", "VARCHAR(64) NOT NULL")
        query:Create("columns", "TEXT NOT NULL")
        query:PrimaryKey("table")
    query:Execute()

    -- table structure will be populated with more fields when vars
    -- are registered using lia.char.RegisterVar
    query = mysql:Create("lia_characters")
        query:Create("id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
        query:PrimaryKey("id")
    query:Execute()

    query = mysql:Create("lia_inventories")
        query:Create("inventory_id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
        query:Create("character_id", "INT(11) UNSIGNED NOT NULL")
        query:Create("inventory_type", "VARCHAR(150) DEFAULT NULL")
        query:PrimaryKey("inventory_id")
    query:Execute()

    query = mysql:Create("lia_items")
        query:Create("item_id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
        query:Create("inventory_id", "INT(11) UNSIGNED NOT NULL")
        query:Create("unique_id", "VARCHAR(60) NOT NULL")
        query:Create("character_id", "INT(11) UNSIGNED DEFAULT NULL")
        query:Create("player_id", "VARCHAR(20) DEFAULT NULL")
        query:Create("data", "TEXT DEFAULT NULL")
        query:PrimaryKey("item_id")
    query:Execute()

    query = mysql:Create("lia_players")
        query:Create("steamid", "VARCHAR(20) NOT NULL")
        query:Create("steam_name", "VARCHAR(32) NOT NULL")
        query:Create("play_time", "INT(11) UNSIGNED DEFAULT NULL")
        query:Create("address", "VARCHAR(15) DEFAULT NULL")
        query:Create("last_join_time", "INT(11) UNSIGNED DEFAULT NULL")
        query:Create("data", "TEXT")
        query:PrimaryKey("steamid")
    query:Execute()

    -- populate schema table if rows don't exist
    query = mysql:InsertIgnore("lia_schema")
        query:Insert("table", "lia_characters")
        query:Insert("columns", util.TableToJSON({}))
    query:Execute()

    -- load schema from database
    query = mysql:Select("lia_schema")
        query:Callback(function(result)
            if ( !istable(result) ) then return end

            for _, v in pairs(result) do
                lia.database.schema[v.table] = util.JSONToTable(v.columns)
            end

            -- update schema if needed
            for i = 1, #lia.database.schemaQueue do
                local entry = lia.database.schemaQueue[i]
                lia.database.InsertSchema(entry[1], entry[2], entry[3])
            end
        end)
    query:Execute()
end

function lia.database.WipeTables(callback)
    local query

    query = mysql:Drop("lia_schema")
    query:Execute()

    query = mysql:Drop("lia_characters")
    query:Execute()

    query = mysql:Drop("lia_inventories")
    query:Execute()

    query = mysql:Drop("lia_items")
    query:Execute()

    query = mysql:Drop("lia_players")
        query:Callback(callback)
    query:Execute()
end

hook.Add("InitPostEntity", "ixDatabaseConnect", function()
    -- Connect to the database using SQLite, mysqoo, or tmysql4.
    lia.database.Connect()
end)

local resetCalled = 0

concommand.Add("lia_wipedb", function(client, cmd, arguments)
    -- can only be ran through the server's console
    if ( !IsValid(client) ) then
        if ( resetCalled < RealTime() ) then
            resetCalled = RealTime() + 3

            lia.print(lia.color.red, "DATABASE WIPE IN PROGRESS...")
            lia.print(lia.color.red, "THE SERVER WILL RESTART TO APPLY THESE CHANGES WHEN COMPLETED.")
            lia.print(lia.color.red, "TO CONFIRM DATABASE RESET, RUN 'lia_wipedb' AGAIN WITHIN 3 SECONDS.")

        else
            resetCalled = 0
            lia.print(lia.color.red, "DATABASE WIPE IN PROGRESS...")

            hook.Run("OnWipeTables")

            lia.database.WipeTables(function()
                lia.print(lia.color.yellow, "DATABASE WIPE COMPLETED!.")
                RunConsoleCommand("changelevel", game.GetMap())
            end)
        end
    end
end)