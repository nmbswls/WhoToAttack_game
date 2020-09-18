--modifier_hero_waitting 出门等待


function UnitAI:OnUnitThink(unit)
    if IsClient() or GameRules:GetGameModeEntity().IsGameOver then return nil end

    local highestScoreCommand = 1
    local highestScore = 0
    local highestData = nil
    
    if(unit == nil or unit:IsNull() or unit:IsAlive() == false) then
        return nil
    end
    
    if(unit:HasModifier("modifier_hero_waitting")) then
        return nil
    end
    
    --zhiyou state == battle shi

    if(GameRules:IsGamePaused()) then
        return 0.2
    end
    
    if(unit.SpawnTime == nil) then
        unit.SpawnTime = GameRules:GetGameTime()
    end

    if(unit.IsCommandRestricted ~= nil and unit:IsCommandRestricted()) then 
        return 0.25
    end
    
    for i, v in pairs(UNIT_CMD_LIST) do
        local score, cmdData = UnitAI:EvaluateCommand(unit, v)
        if(score > highestScore or (score == highestScore and RollPercentage(50))) then
            highestScore = score
            highestScoreCommand = i
            highestData = cmdData
        end
    end
    
    if(highestData ~= nil) then
        return UnitAI:ExecuteCommand(unit, UNIT_CMD_LIST[highestScoreCommand], highestData)
    else
        return 0.25
    end
end


function UnitAI:EvaluateCommand(unit, cmdName)
    local location = unit:GetAbsOrigin()
    local teamId = unit:GetTeamNumber()
    local score = 0
    
    if(cmdName == "ATTACK_TARGET") then
        if(unit:IsChanneling() or unit:IsStunned()) then
            return 0, nil
        end
        
        if(unit:IsIdle() == false) then
            if(unit:AttackReady() == false or unit:IsAttacking()) then
                return 0, nil
            end
        end

        if(unit:IsAttackImmune() or unit:IsRooted()) then
            return 0, nil
        end

        local unitName = unit:GetUnitName()
        if(unitName == "npc_dota_juggernaut_healing_ward") then
            local hTarget = UnitAI:GetNearestWeekestFriendlyTarget(unit)
            if(hTarget ~= nil) then
                return 4, hTarget
            end
        end

        if(unitName == "npc_dota_techies_stasis_trap" or unitName == "npc_dota_techies_land_mine" or unitName == "npc_dota_techies_remote_mine" or unitName == "npc_dota_grimstroke_ink_creature") then
            local hTarget = UnitAI:ClosestHeroEnemy(unit, teamId)
            if(hTarget ~= nil) then
                return 3, hTarget
            end
        end

        if(unitName == "npc_dota_broodmother_spiderling" or unitName == "npc_dota_broodmother_spiderite") then
            local hTarget = UnitAI:GetRangedEnemyTarget(unit)
            if(hTarget ~= nil) then
                return 3, hTarget
            end
        end
        
        local attackTarget = unit:GetAttackTarget()
        
        if(attackTarget == nil or attackTarget:IsAlive() == false) then

            local nearestEnemy = UnitAI:GetAssassinTarget(unit, FIND_UNITS_EVERYWHERE, false, true)

            if nearestEnemy == nil then
                nearestEnemy = UnitAI:ClosestEnemyAll(unit, teamId)
            end

            if(nearestEnemy == nil or nearestEnemy:IsAlive() == false) then
                return 0, nil
            end
            return 3, nearestEnemy
        end
        
        return 0, nil
    end
    
    if(cmdName == "USE_ITEM") then
        if(unit.IsIllusion ~= nil and unit:IsIllusion()) then
            return 0, nil
        end

        if(UnitAI:IsInBattleFightArea(unit) == false) then
            return 0, nil
        end
        
        if(unit:IsChanneling() or unit:IsStunned()) then
            return 0, nil
        end

        if(unit:IsMuted()) then
            return 0, nil
        end
        
        if(GameRules:GetGameTime() - GameRules.DW.StageStartTime < 7) then
            return 0, nil
        end
        
        if(unit:HasInventory() == false) then
            return 0, nil
        end

        local canCastItems = {}
        
        for slotIndex = 0, 16 do
            if(slotIndex <= 5 or slotIndex == 16) then
                local item = unit:GetItemInSlot(slotIndex)
                if(item ~= nil) then
                    local itemName = item:GetName()
                    local canCast = true
                    
                    if(itemName == "item_armlet") then
                        if item:GetToggleState() == false then
                            item:ToggleAbility()
                        end
                    end
                    
                    if(item:IsMuted() or item:IsPassive() or item:IsToggle()) then
                        canCast = false
                    elseif(item:RequiresCharges() and item:GetCurrentCharges() <= 0) then
                        canCast = false
                    elseif(item:IsFullyCastable() == false or item:IsCooldownReady() == false) then
                        canCast = false
                    elseif(item:IsInAbilityPhase()) then
                        canCast = false
                    elseif((itemName == "item_mekansm" or itemName == "item_guardian_greaves") and unit:GetHealth() == unit:GetMaxHealth()) then
                        canCast = false
                    elseif(itemName == "item_mekansm" and unit:GetHealth() == unit:GetMaxHealth()) then
                        canCast = false
                    elseif(itemName == "item_blade_mail" and unit:GetHealth() > unit:GetMaxHealth() * 0.6) then
                        canCast = false
                    elseif(table.contains(UnitDontCastItems, itemName)) then
                        canCast = false
                    end
                    
                    if canCast then
                        table.insert(canCastItems, item)
                    end
                end
            end
        end
        
        local selectedItem = nil
        
        if(#canCastItems > 0) then
            selectedItem = canCastItems[RandomInt(1, #canCastItems)]
        end
        
        if(selectedItem ~= nil) then
            local spellData = UnitAI:GetSpellData(selectedItem)
            if(spellData == nil) then
                return 0, nil
            end
            
            return 4, spellData
        end
        
        return 0, nil
    end
    
    if(cmdName == "USE_ABILITY") then
        if(unit:IsSilenced() or unit:IsStunned()) then
            return 0, nil
        end
        
        if(unit:IsChanneling()) then
            return 0, nil
        end

        if(unit:GetName() == "npc_dota_hero_vengefulspirit" and unit:IsIllusion()) then
            if unit:HasModifier("modifier_vengefulspirit_hybrid_special") == false then
                return 0, nil
            end
        end
        
        if(GameRules:GetGameTime() - GameRules.DW.StageStartTime < 6) then
            return 0, nil
        end
        
        local canCastAbilities = {}
        
        for i = 0, unit:GetAbilityCount() - 1 do
            local ability = unit:GetAbilityByIndex(i)
            local canCast = true
            
            if(ability == nil or ability:GetLevel() <= 0) then
                canCast = false
            elseif(ability:IsHidden() or ability:IsPassive() or ability:IsActivated() == false) then
                canCast = false
            elseif(string.find(ability:GetName(), "_bonus") ~= nil) then
                canCast = false
            elseif(ability:IsFullyCastable() == false or ability:IsCooldownReady() == false) then
                canCast = false
            elseif(ability:IsInAbilityPhase()) then
                canCast = false
            elseif(bitContains(ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_AUTOCAST)) then
                canCast = false
            end
            
            if canCast and ability:GetName() ~= "lone_druid_spirit_bear_return" then
                table.insert(canCastAbilities, ability)
            end
        end
        
        local selectedAbility = nil
        
        if(#canCastAbilities > 0) then
            selectedAbility = canCastAbilities[RandomInt(1, #canCastAbilities)]
        end
        
        if(selectedAbility ~= nil) then
            local spellData = UnitAI:GetSpellData(selectedAbility)
            if(spellData == nil) then
                return 0, nil
            end

            if(selectedAbility:GetName() == "templar_assassin_self_trap") then
                if(unit.SpawnTime ~= nil and GameRules:GetGameTime() - unit.SpawnTime < 0.5) then
                    return 0, nil
                end
            end
            
            return 4, spellData
        end
        
        return 0, nil
    end
end

