
-- Supporting file containing a DCTable associating integer value to DC GUIDs
local KMDC = Ext.Require("KnifeMaster_DifficultyClasses.lua")
-- Supporting file containing several utility functions
local KMUtils = Ext.Require("KnifeMaster_Utils.lua")
-- Supporting file containing coating related utilities
local KMCoatings = Ext.Require("KnifeMaster_Coatings.lua")



Ext.Utils.Print("KnifeMaster_Main.lua loaded...")

--[[************************************************************************
                    LISTENER FOR OFFENSIVE COATING APPLICATION
****************************************************************************]]
Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)

    --KM_printAllParams()


    if Osi.IsWeapon(object) ~= 1 then
        Ext.Utils.Print("Checking for offensive coatings: status applied to non-weapon, ignored")
        return
    end

    _P("////////////////// STATUS APPLIED-SERINO ///////////////")
    Ext.Utils.PrintWarning("object = " .. object)
    Ext.Utils.PrintWarning("status = " .. status)
    Ext.Utils.PrintWarning("causee = " .. causee)
    Ext.Utils.PrintWarning("storyActionID = " .. storyActionID)
    _P("/////////////////////////////////////////////////////////")

    local coating = KMCoatings.getWeaponCoatingByStatusDipped(object)
    if coating == nil then
        Ext.Utils.Print("Weapon lacking offensive coatings, hard pass lmao")
        return
    end

    Ext.Utils.Print("Weapon coated with " .. coating.name .. "!")
    local weaponOwner = Osi.GetInventoryOwner(object);
    Ext.Utils.PrintWarning("weaponOwner (InventoryOwner) = " .. KMUtils.getName(weaponOwner))

    if Osi.HasPassive(weaponOwner, 'Cutthroat_Poison_Expert') == 0 then
        Ext.Utils.PrintWarning(KMUtils.getName(weaponOwner) .. " ain't got no poison expertise. Applying normal passive to weapon")
        Osi.AddPassive(object, coating.passive)
    else
        _P(KMUtils.getName(weaponOwner) .. " has poison expertise! Applying empowered passive!")
        Osi.AddPassive(object, coating.passive .. "_" .. KMUtils.getProficiencyBonus(weaponOwner))
    end

end)

--[[************************************************************************
                    LISTENER FOR OFFENSIVE COATING REMOVAL
****************************************************************************]]

Ext.Osiris.RegisterListener("StatusRemoved", 4, "before", function(object, status, causee, applyStoryActionID)


    if Osi.IsWeapon(object) ~= 1 then
        Ext.Utils.Print("Checking for coatings: status removed from non-weapon, ignored")
        return
    end

    _P("////////////////// STATUS REMOVED-SERINO ///////////////")
    Ext.Utils.PrintWarning("object = " .. object)
    Ext.Utils.PrintWarning("status = " .. status)
    Ext.Utils.PrintWarning("causee = " .. causee)
    Ext.Utils.PrintWarning("applyStoryActionID = " .. applyStoryActionID)
    _P("/////////////////////////////////////////////////////////")

    local passive = KMCoatings.getWeaponPassive(object)
    if passive == nil then
        Ext.Utils.Print("Weapon lacking passive of interest, hard pass lmao")
        return
    end

    Ext.Utils.Print("Weapon having " .. passive .. "!")
    local weaponOwner = Osi.GetInventoryOwner(object);
    Ext.Utils.PrintWarning("weaponOwner (InventoryOwner) = " .. KMUtils.getName(weaponOwner))

    _P("Removing " .. passive .. " from " .. KMUtils.getName(object))
    Osi.RemovePassive(object, passive)

end)

--[[************************************************************************
                    LISTENER FOR COATING ATTACK
****************************************************************************]]

--[[
Ext.Osiris.RegisterListener("AttackedBy", 7, "after", function (defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID)

   --KM_printAllParams()
   
   

    Ext.Utils.Print("Attack Event listened to: " .. KMUtils.getName(attackerOwner) .. " attacked " .. KMUtils.getName(defender))
    _P(storyActionID)

    if damageAmount <= 0 then
        Ext.Utils.Print("No damage done, cya")
        return
    end
    if damageCause ~= 'Attack' then
        Ext.Utils.Print("Coating applieth only on attacks")
        return
    end
    local attackWeapon = Osi.GetEquippedWeapon(attackerOwner)
    local coating = KMCoatings.getWeaponCoating(attackWeapon)

    if coating == nil then
        Ext.Utils.Print("Weapon not coated, hard pass lmao")
        return
    end
    Ext.Utils.Print("Weapon coated with " .. coating.name .. "!")
    if Osi.HasPassive(attackerOwner, 'Cutthroat_Poison_Expert') == 1 then
        Ext.Utils.Print("Attacker has Cutthroat Poison Expert!")
        --Osi.RequestPassiveRoll(defender, attackerOwner, 'SavingThrow', 'Constitution', KMDC.getDCString(coating.DC + KMUtils.getProficiencyBonus(attackerOwner)), 0, coating.passive .. "_Attack")
        Osi.AddBoosts(attackWeapon, "IF not SavingThrow(Ability.Constitution," .. coating.DC+KMUtils.getProficiencyBonus(attackerOwner) .. "):ApplyStatus(" .. coating.condition .. ",100,-1)", coating.passive, "")
    else
        Ext.Utils.Print("Stupid motherfucker lacks Cutthroat Poison Expert!")
        --Osi.RequestPassiveRoll(defender, attackerOwner, 'SavingThrow', 'Constitution', KMDC.getDCString(coating.DC), 0, coating.passive .. "_Attack")
        Osi.AddBoosts(attackWeapon, "IF(not SavingThrow(Ability.Constitution," .. coating.DC .. ")):ApplyStatus(" .. coating.condition .. ",100,-1)", coating.passive, "")
    end

    
end)
]]

--[[************************************************************************
                    LISTENER FOR COATING SAVING THROW
****************************************************************************]]
--[[
Ext.Osiris.RegisterListener("RollResult", 6, "after", function(eventName, roller, rollSubject, resultType, isActiveRoll, criticality)

    --KM_printAllParams()
    local attackCoating = nil
    for _, coating in pairs(KMCoatings.coatings) do
        if eventName == (coating.passive .. "_Attack") then
            _P("Roll Result Listener found coating on weapon: " .. coating.name)
            attackCoating = coating
        end
    end

    if attackCoating ~= nil and resultType == 0 then
        _P("ROLL RESULT LISTENER: L'attacante pare avere Catthrott e il tirosalvezza avere fallito!")
        Osi.ApplyStatus(roller, attackCoating.condition, 6)
    end
    
end)
]]




--[[
     _P("////////////////// ATTACKED BY PRINTZ ///////////////////")
    Ext.Utils.PrintWarning("defender = " .. defender  )
    Ext.Utils.PrintWarning("attackerOwner = " .. attackerOwner)
    Ext.Utils.PrintWarning(" attacker2 = " .. attacker2)
    Ext.Utils.PrintWarning("damageType = " .. damageType)
    Ext.Utils.PrintWarning("damageAmount = " .. damageAmount)
    Ext.Utils.PrintWarning("damageCause = " .. damageCause)
    Ext.Utils.PrintWarning("storyActionID = " .. storyActionID)
    _P("/////////////////////////////////////////////////////////")
]]
--[[
        _P("////////////////// ROLLRESULT PRINTZ ///////////////////")
    Ext.Utils.PrintWarning("eventName = " .. eventName)
    Ext.Utils.PrintWarning("roller = " .. roller)
    Ext.Utils.PrintWarning("rollSubject = " .. rollSubject)
    Ext.Utils.PrintWarning("resultType = " .. resultType)
    Ext.Utils.PrintWarning("isActiveRoll = " .. isActiveRoll)
    Ext.Utils.PrintWarning("criticality = " .. criticality)
    _P("/////////////////////////////////////////////////////////")
]]
--[[
    _P("////////////////// STATUS APPLIED-SERINO ///////////////")
    Ext.Utils.PrintWarning("object = " .. object)
    Ext.Utils.PrintWarning("status = " .. status)
    Ext.Utils.PrintWarning("causee = " .. causee)
    Ext.Utils.PrintWarning("storyActionID = " .. storyActionID)
    _P("/////////////////////////////////////////////////////////")
]]

--[[
    if Osi.HasPassive(attackerOwner, 'Poison_Drow_Passive') == 0 then
        Ext.Utils.Print("Attacker lacks the Poison Drow passive")
        return
    end
    Ext.Utils.Print("Attacker has Poison_Drow_Passive! Poggies!")
    if Osi.HasPassive(attackerOwner, 'Cutthroat_Poison_Expert') == 1 then
            Ext.Utils.Print("Here's time to try RequestPassiveRoll")
            if damageAmount > 0 then
                _P("Damage done! Time for the Saving Throw! O________O")
                Osi.RequestPassiveRoll(defender, attackerOwner, 'SavingThrow', 'Constitution', KM_getDCString(13+KM_getProficiencyBonus(attackerOwner)), 0, "Cutthroat")
            end
            
            --[[if damageType ~= "Poison"  then
                Osi.ApplyDamage(defender, 3, "Poison", attackerOwner)
                _P("Perhaps this is replicating the poison applikescion ")
            end
            
        end
]]


--[[
        if Osi.HasPassive(weaponOwner, 'Cutthroat_Poison_Expert') == 1 then
        Ext.Utils.Print("Attacker has Cutthroat Poison Expert!")
        --Osi.RequestPassiveRoll(defender, attackerOwner, 'SavingThrow', 'Constitution', KMDC.getDCString(coating.DC + KMUtils.getProficiencyBonus(attackerOwner)), 0, coating.passive .. "_Attack")
        Osi.AddBoosts(object, "IF(not SavingThrow(Ability.Constitution," .. coating.DC+KMUtils.getProficiencyBonus(weaponOwner) .. ")):ApplyStatus(" .. coating.condition .. ",100,-1)", coating.passive, "")
        _P("Boosts hopefully applied: IF(not SavingThrow(Ability.Constitution," .. coating.DC+KMUtils.getProficiencyBonus(weaponOwner) .. ")):ApplyStatus(" .. coating.condition .. ",100,-1)")
    else
        Ext.Utils.Print("Stupid motherfucker lacks Cutthroat Poison Expert!")
        --Osi.RequestPassiveRoll(defender, attackerOwner, 'SavingThrow', 'Constitution', KMDC.getDCString(coating.DC), 0, coating.passive .. "_Attack")
        Osi.AddBoosts(object, "IF(not SavingThrow(Ability.Constitution," .. coating.DC .. ")):ApplyStatus(" .. coating.condition .. ",100,-1)", coating.passive, "")
        _P("Boosts hopefully applied: IF(not SavingThrow(Ability.Constitution," .. coating.DC .. ")):ApplyStatus(" .. coating.condition .. ",100,-1)")
    end
]]






















--Ext.Events.GameStateChanged:Subscribe(function(e) _P(e.fromState, e.toState) end)


--[[Ext.Utils.Print("Attack Event listened to: " .. getName(attackerOwner) .. " attacked " .. getName(defender))
   Ext.Events.AttackedBy:Subscribe(function(e)

        Ext.Utils.Print("Attack Event listened to: " .. getName(e.attackerOwner) .. " attacked " .. getName(e.defender))
        Ext.Utils.Print("Boh, RegisterListener dovrebbe aver fatto ma chi lo sa")
        if not Osi.HasPassive(e.attackerOwner, 'Poison_Drow_Passive') then
            Ext.Utils.Print("Attacker lacks the Poison Drow passive")
            return
        end
        Ext.Utils.Print("Attacker has Poison_Drow_Passive! Poggies!")
        if Osi.HasPassive(e.attackerOwner, 'Cutthroat_Poison_Expert') then
                Ext.Utils.Print("Here's time to try RequestPassiveRoll")
                Osi.ApplyDamage(e.defender, 3, "Poison", e.attackerOwner)
        end
    
    end)
    ]]