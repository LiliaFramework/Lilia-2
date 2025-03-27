local file = file
local SERVER = SERVER
local ipairs = ipairs
local include = include
local AddCSLuaFile = AddCSLuaFile

function lia.util.Include(sName, sRealm)
    if not sName then return lia.print("Include: No file name specified.") end

    if (sRealm == "server" or sName:find("sv_")) and SERVER then
            return include(sName)
    elseif sRealm == "shared" or sName:find("sh_") then
        if SERVER then
            AddCSLuaFile(sName)
        end
        return include(sName)
    elseif sRealm == "client" or sName:find("cl_") then
        if SERVER then
            AddCSLuaFile(sName)
        else
            return include(sName)
        end
    end
end

function lia.util.IncludeDir(sDir)
    local sBase = "lilia"

    -- We'll do the schema check later

    sBase = sBase .. "/gamemode/"

    for _, v in ipairs(file.Find(sBase .. sDir .. "/*.lua", "LUA")) do
        lia.util.Include(sBase .. sDir .. "/" .. v)
    end
end