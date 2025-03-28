AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "core/sh_util.lua" )

include( "shared.lua" )
include( "core/sh_util.lua" )

local function SetupDatabase()
    hook.Run("SetupDatabase")
    lia.database.connect(function()
        lia.database.loadTables()
        hook.Run("DatabaseConnected")
    end)
end

timer.Simple(0, function()
    SetupDatabase()
end)