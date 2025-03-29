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

function GM:OnMySQLOOConnected()
    hook.Run("RegisterPreparedStatements")
    MYSQLOO_PREPARED = true
end

local ignore = function() end
function GM:LiliaTablesLoaded()
    lia.database.query("ALTER TABLE IF EXISTS lia_players ADD COLUMN _firstJoin DATETIME"):catch(ignore)
    lia.database.query("ALTER TABLE IF EXISTS lia_players ADD COLUMN _lastJoin DATETIME"):catch(ignore)
    lia.database.query("ALTER TABLE IF EXISTS lia_items ADD COLUMN _quantity INTEGER"):catch(ignore)
end