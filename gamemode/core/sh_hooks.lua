function GM:GetGameDescription()
    -- TODO, Schema Name Support
    return "Lilia"
end

-- Disable vehicle driving (not needed for RP)
function GM:CanDrive()
    return false
end