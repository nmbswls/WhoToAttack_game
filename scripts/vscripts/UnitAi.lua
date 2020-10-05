--modifier_hero_waitting 出门等待
if UnitAI == nil then UnitAI = class({}) end
UNIT_CMD_LIST = {"ATTACK_TARGET", "USE_ABILITY"}
UNIT_FILTER = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

function UnitAI:OnUnitThink(unit)

    if IsClient() or GameRules:GetGameModeEntity().WhoToAttack.is_game_ended then return nil end
    
    if GameRules:GetGameModeEntity().WhoToAttack.stage ~= 3 then
        return 1
    end
    
    
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
        
        local attackTarget = unit:GetAttackTarget()
        
        if(attackTarget == nil or attackTarget:IsAlive() == false) then
        
            nearestEnemy = UnitAI:ClosestEnemyAll(unit, teamId)
            if(nearestEnemy == nil or nearestEnemy:IsAlive() == false) then
                return 0, nil
            end
            
            return 30, nearestEnemy
        else
            print("has attack target")
        end
        
        return 0, nil
    end
    
    
    
    if(cmdName == "USE_ABILITY") then
        -- if(unit:IsSilenced() or unit:IsStunned()) then
            -- return 0, nil
        -- end
        
        -- if(unit:IsChanneling()) then
            -- return 0, nil
        -- end
        
        
        -- local unitName = unit:GetUnitName()
        
        -- if(GameRules:GetGameTime() - GameRules:GetGameModeEntity().stage_start_time < 6) then
            -- return 0, nil
        -- end
        
        -- local canCastAbilities = {}
        
        -- for i = 0, unit:GetAbilityCount() - 1 do
            -- local ability = unit:GetAbilityByIndex(i)
            -- local canCast = true
            
            -- if(ability == nil or ability:GetLevel() <= 0) then
                -- canCast = false
            -- elseif(ability:IsHidden() or ability:IsPassive() or ability:IsActivated() == false) then
                -- canCast = false
            -- elseif(string.find(ability:GetName(), "_bonus") ~= nil) then
                -- canCast = false
            -- elseif(ability:IsFullyCastable() == false or ability:IsCooldownReady() == false) then
                -- canCast = false
            -- elseif(ability:IsInAbilityPhase()) then
                -- canCast = false
            -- elseif(bitContains(ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_AUTOCAST)) then
                -- canCast = false
            -- end
            
            -- if canCast and ability:GetName() ~= "lone_druid_spirit_bear_return" then
                -- table.insert(canCastAbilities, ability)
            -- end
        -- end
        
        -- local selectedAbility = nil
        
        -- if(#canCastAbilities > 0) then
            -- selectedAbility = canCastAbilities[RandomInt(1, #canCastAbilities)]
        -- end
        
        -- if(selectedAbility ~= nil) then
            -- local spellData = UnitAI:GetSpellData(selectedAbility)
            -- if(spellData == nil) then
                -- return 0, nil
            -- end

            -- if(selectedAbility:GetName() == "templar_assassin_self_trap") then
                -- if(unit.SpawnTime ~= nil and GameRules:GetGameTime() - unit.SpawnTime < 0.5) then
                    -- return 0, nil
                -- end
            -- end
            
            -- return 4, spellData
        -- end
        
        return 0, nil
    end
end

function UnitAI:ExecuteCommand(unit, cmdName, cmdData)
    if(cmdName == "ATTACK_TARGET") then
        if(cmdData == nil) then
            print("ability no cmd data")
            --unit:MoveToPositionAggressive(GameRules.DW.BattleFightPosition)
            return 1
        end
        
        local targetPosition = cmdData:GetAbsOrigin()
        if(GameRules:GetGameTime() - GameRules:GetGameModeEntity().WhoToAttack.game_start_time < 10) then
            local unitPosition = unit:GetAbsOrigin()
            if(unitPosition.x < -1000 or unitPosition.x > 1000) then
                targetPosition.y = unitPosition.y
            end
        end

        local unitName = unit:GetUnitName()
        if(unit:GetAttackDamage() > 1) then
            unit:MoveToPositionAggressive(targetPosition)
        end

        -- if u:GetAttackTarget() == nil then
				-- local newOrder = {
			 		-- UnitIndex = u:entindex(), 
			 		-- OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			 		-- TargetIndex = u.attack_target:entindex(), 
			 		-- Queue = 0 
			 	-- }
				-- ExecuteOrderFromTable(newOrder)


        local delay = 0.5
        if(unit.GetDisplayAttackSpeed ~= nil and unit:GetDisplayAttackSpeed() > 0) then
            delay = 170 / unit:GetDisplayAttackSpeed()
        end
        
        return delay
    end
    
    
    if(cmdName == "USE_ABILITY") then
        if(cmdData == nil) then
            print("ability no cmd data")
            --unit:MoveToPositionAggressive(GameRules.DW.BattleFightPosition)
            return 1
        end
        
        local loopTime = UnitAI:CastSpell(cmdData)
        
        return loopTime
    end
    
    return 1
end

function UnitAI:ClosestEnemyAll(unit, teamId)
    local enemies = FindUnitsInRadius(teamId, unit:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,
    UNIT_FILTER, FIND_CLOSEST, true)
    
    if #enemies == 0 then
        return nil
    end
    
    local firstEnemy = nil
    
    if #enemies > 1 then
        for index = 1, #enemies do
            
            print("try search get enemy in battle " .. enemies[index].in_battle_id );
            if enemies[index].in_battle_id ~= nil and enemies[index].in_battle_id == unit.in_battle_id 
                and not unit:HasModifier("modifier_base_fantan") 
                then
                
                firstEnemy = enemies[index]
                break
            end
            -- if(enemies[index]:GetAbsOrigin().y > MAX_BATTLE_Y and enemies[index]:IsAlive() and enemies[index]:IsInvulnerable() == false and enemies[index]:IsAttackImmune() == false) then
                -- if(enemies[index]:IsInvisible() == false or UnitAI:HasTargetTrueSight(unit, enemies[index])) then
                    -- firstEnemy = enemies[index]
                    -- break
                -- end
            -- end
            --firstEnemy = enemies[index]
            --break
        end
    
        
    else
        
        if enemies[1].in_battle_id ~= nil and enemies[1].in_battle_id == unit.in_battle_id then
            firstEnemy = enemies[1]
        end
    end
    
    
    
    return firstEnemy
end


-- function UnitAI:CastSpellNoTarget(hSpell)
    -- local caster = hSpell:GetCaster()
    -- if(caster == nil or caster:IsNull() or caster:IsAlive() == false) then
        -- return 0.1
    -- end
    
    -- caster:CastAbilityNoTarget(hSpell, UnitAI:GetPlayerId(caster))
    
    -- return UnitAI:GetSpellCastTime(hSpell)
-- end