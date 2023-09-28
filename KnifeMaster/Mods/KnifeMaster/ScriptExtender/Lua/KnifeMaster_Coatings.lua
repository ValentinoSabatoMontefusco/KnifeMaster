Ext.Utils.Print("KnifeMaster_Coatings.lua loaded")
local KMUtils = Ext.Require("KnifeMaster_Utils.lua")

KM_Coatings = {

    -- DEBUFF APPLYING COATINGS 

    Basic_Poison = {

        name = "POISON_BASIC",
        dipped = "POISON_SIMPLE_DIPPED",
        passive = "Poison_Simple_Passive",
        condition = "POISON_SIMPLE_CONDITION",
        DC = 11
    },

    Poison_Drow = {

        name = "POISON_DROW",
        dipped = "POISON_DROW_DIPPED",
        passive = "Poison_Drow_Passive",
        condition = "POISON_DROW_CONDITION",
        DC = 13

    },

    Oil_Of_Diminution = {

        name = "ALCH_OIL_REDUCE",
        dipped = "ALCH_OIL_REDUCE_DIPPED",
        passive = "ALCH_Oil_Reduce_Passive",
        condition = "REDUCE",
        DC = 11
    },

    Crawler_Mucus = {

        name = "POISON_CRAWLER_MUCUS",
        dipped = "POISON_CRAWLER_MUCUS_DIPPED",
        passive = "Poison_CrawlerMucus_Passive",
        condition = "POISON_CRAWLER_MUCUS_CONDITION",
        DC = 13
    },

    Malice = {

        name = "POISON_MALICE",
        dipped = "POISON_MALICE_DIPPED",
        passive = "Poison_Malice_Passive",
        condition = "POISON_MALICE_CONDITION",
        DC = 15
    },

    Oil_Of_Bane = {

        name = "ALCH_OIL_BANE",
        dipped = "ALCH_OIL_BANE_DIPPED",
        passive = "ALCH_Oil_Bane_Passive",
        condition = "ALCH_OIL_BANE_CONDITION",
        DC = 11
    },


    -- POISON DAMAGE COATINGS

    Simple_Toxin = {

        name = "TOXIN_BASIC",
        dipped = "ALCH_TOXIN_BASIC_DIPPED",
        passive = "Toxin_Basic_Passive",
        condition = "ALCH_TOXIN_BASIC_CONDITION",
        DC = 11
    },

    Serpent_Fang_Toxin = {

        name = "TOXIN_SERPENTVENOM",
        dipped = "TOXIN_SERPENTVENOM_DIPPED",
        passive = "Toxin_SerpentVenom_Passive",
        condition = "ALCH_TOXIN_SERPENTVENOM_CONDITION",
        DC = 13
    },

    Wyvern_Toxin = {

        name = "TOXIN_WYVERN",
        dipped = "TOXIN_WYVERN_DIPPED",
        passive = "Toxin_Wyvern_Passive",
        condition = "ALCH_TOXIN_WYVERN_CONDITION",
        DC = 15
    },

    Thisobald_Bellyglummer = {

        name = "UNI_POISON_BREWER",
        dipped = "UNI_POISON_BREWER_DIPPED",
        passive = "UNI_Poison_Brewer_Passive",
        condition = "UNI_POISON_BREWER_CONDITION",
        DC = 17
    },

    Purple_Worm_Toxin = {

        name = "TOXIN_PURPLEWORM",
        dipped = "TOXIN_PURPLEWORM_DIPPED",
        passive = "Toxin_PurpleWorm_Passive",
        condition = "ALCH_TOXIN_PURPLEWORM_CONDITION",
        DC = 19
    }



}

local metatable = {}
setmetatable(KM_Coatings, metatable)
metatable.__index = function(table, key) 

    if key == "contains" then
        return function(value)
            for _, coating in pairs(table) do
                for _, entry in pairs(coating) do
                    if (entry == value) then
                    return coating
                    end

                end


            end
        end

    end
    return nil
end

local function getPassivesList(passive) 

    local passivesList = {passive}
    for i = 2, 4 do
        
        table.insert(passivesList, passive .. "_" .. i)
    end

    return passivesList
end


function KM_getWeaponCoatingByPassive(weapon) 

    for _, coating in pairs(KM_Coatings) do
        
        Ext.Utils.PrintWarning("Checking " .. coating.passive .. " on weapon " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(weapon)) .. "...")
        for _, subpassive in pairs(getPassivesList(coating.passive)) do
            if Osi.HasPassive(weapon, subpassive) == 1 then
                Ext.Utils.PrintWarning(subpassive ..  " found")
                return coating
            else 
                Ext.Utils.PrintWarning(subpassive .. " not found")
            end
        end
    
        --[[
        if Osi.HasPassive(weapon, "'" .. coating.passive .. "'") == 1 then
            Ext.Utils.Print("lolwut, with the single quote it's working now...")
            return coating
        else
            Ext.Utils.Print("Single digit attempt failed")
        end
        ]]
    end
    
    return nil
end

function KM_getWeaponPassive(weapon) 

    for _, coating in pairs(KM_Coatings) do
        Ext.Utils.PrintWarning("Checking " .. coating.passive .. " on weapon " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(weapon)) .. "...")
        for _, subpassive in pairs(getPassivesList(coating.passive)) do
            if Osi.HasPassive(weapon, subpassive) == 1 then
                Ext.Utils.PrintWarning(subpassive ..  " found")
                return subpassive
            else 
                Ext.Utils.PrintWarning(subpassive .. " not found")
            end
        end
        return nil
    end
end

function KM_getWeaponCoatingByStatusDipped(weapon) 

    for _, coating in pairs(KM_Coatings) do
        Ext.Utils.PrintWarning("Checking " .. coating.dipped .. " on weapon " .. Osi.ResolveTranslatedString(Osi.GetDisplayName(weapon)) .. "...")
        if Osi.HasAppliedStatus(weapon, coating.dipped) == 1 then
            _P(coating.dipped .. " found")
            return coating
        else
            Ext.Utils.PrintWarning(coating.dipped .. " not found")
        end
    end
    return nil
end


return {

    coatings = KM_Coatings,
    getWeaponCoatingByPassive = KM_getWeaponCoatingByPassive,
    getWeaponPassive = KM_getWeaponPassive,
    getWeaponCoatingByStatusDipped = KM_getWeaponCoatingByStatusDipped
}

