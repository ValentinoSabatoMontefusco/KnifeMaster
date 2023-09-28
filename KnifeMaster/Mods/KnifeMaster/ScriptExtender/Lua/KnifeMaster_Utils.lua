Ext.Utils.Print("KnifeMaster_Utils.lua loaded...")


local function KM_printAllParams()
    
    local info = debug.getinfo(2, "uS")
    local func = info.func
    local params = {}

    for i = 1, math.huge do
        local name, value = debug.getlocal(func, i) 
        if not name then break end
        params[name] = value
    end

    Ext.Utils.Print("KnifeMaster_DEBUG: Recap from function: " .. func)
    for key, value in pairs(params) do
        Ext.Utils.Print("***** " .. key .. " = " .. value .. " *****")
    end

end

local function KM_getName(object) 

    return Osi.ResolveTranslatedString(Osi.GetDisplayName(object));
end


local function KM_getProficiencyBonus(character) 
    local level = Osi.GetLevel(character)

    if level <= 4 then
        return 2
    end
    if level <= 8 then
        return 3
    end
    return 4
    
end

return {

    getProficiencyBonus = KM_getProficiencyBonus,
    getName = KM_getName,
    printAllParams = KM_printAllParams
}

