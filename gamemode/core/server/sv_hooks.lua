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

    lia.print(lia.color.green, "Database Connected. (\"" .. lia.database.config.adapter .. "\")")

    timer.Create("ixDatabaseThink", 0.5, 0, function()
        mysql:Think()
    end)

end

function GM:DatabaseConnectionFailed()
    lia.print(lia.color.red, "Database Connection Failed. (\"" .. lia.database.config.adapter .. "\")")
end

function GM:PreCleanupMap()
    lia.shuttingDown = true
    hook.Run("SaveData")
    hook.Run("PersistenceSave")
end

function GM:PostCleanupMap()
    lia.shuttingDown = false
    hook.Run("LoadData")
    hook.Run("PostLoadData")
end

function GM:ShutDown()
    if hook.Run("ShouldDataBeSaved") == false then return end
    lia.shuttingDown = true
    hook.Run("SaveData")
    for _, v in player.Iterator() do
        v:saveLiliaData()
        if v:getChar() then v:getChar():save() end
    end
end
