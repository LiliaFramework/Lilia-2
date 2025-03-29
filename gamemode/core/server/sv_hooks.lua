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

function GM:DatabaseConnected()
    -- Create the SQL tables if they do not exist.
    lia.database.LoadTables()

    lia.print(lia.color.green, "Database Connected. (\"" .. ix.db.config.adapter .. "\")")

    timer.Create("ixDatabaseThink", 0.5, 0, function()
        mysql:Think()
    end)

end

function GM:DatabaseConnectionFailed()
    lia.print(lia.color.red, "Database Connection Failed. (\"" .. ix.db.config.adapter .. "\")")
end