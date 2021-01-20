--modifier_hero_waitting 出门等待
--技能释放信息
----ability = hSpell 技能实例
----type = "unit_target" 目标类型
----target = hTarget
require 'utils'

local MIN_TIME_CAST = 1
if UnitAI == nil then UnitAI = class({}) end
UNIT_CMD_LIST = {"ATTACK_TARGET", "USE_ABILITY"}
UNIT_FILTER = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS

function UnitAI:OnUnitThink(unit)

    if IsClient() or GameRules:GetGameModeEntity().WhoToAttack.is_game_ended then return nil end
    
    if not GameRules:GetGameModeEntity().WhoToAttack.stage or GameRules:GetGameModeEntity().WhoToAttack.stage == 1 then
        return 1
    end
    
	if GameRules:GetGameModeEntity().WhoToAttack.stage == 4 then
		return nil
	end
    
    local highestScoreCommand = 1
    local highestScore = 0
    local highestData = nil
    
    if(unit == nil or not IsValidEntity(unit) or unit:IsAlive() == false) then
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
        return 0.4
    end
	
	if not unit.in_battle_id or unit.in_battle_id == 0 then 
        return 1
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
        return 0.4
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
        if unit:HasAbility('siegeattack')  and unit.in_battle_id ~= unit:GetTeam() then
			--print("siegeattack has ability " .. unit:GetHealth() .. " " .. unit:GetMaxHealth())
            if unit:GetHealth() < unit:GetMaxHealth() * 0.8 then
                local base = self:GetCertainBase(unit.in_battle_id)
                if base then
                    unit:Stop();
                    print("qiangzhi gongji laalal " .. base:GetUnitName())
                    return 30, base
                end
                
            end
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
        
        if attackTarget == nil or attackTarget:IsAlive() == false 
            or attackTarget:IsInvulnerable()
            or attackTarget:HasModifier("modifier_player_jidi") then
            
            local nearestEnemy = nil
            local enemies, base = UnitAI:ClosestEnemyAll(unit, 2000)
            
            if #enemies > 0 then
                nearestEnemy = enemies[1]
            else
                nearestEnemy = base
            end
            
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
        if(unit:IsSilenced() or unit:IsStunned()) then
            return 0, nil
        end
        
        if(unit:IsChanneling()) then
            return 0, nil
        end
        
        
        local unitName = unit:GetUnitName()
        
        if(GameRules:GetGameTime() - GameRules:GetGameModeEntity().WhoToAttack.stage_start_time < MIN_TIME_CAST) then
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
            -- elseif(bitContains(ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_AUTOCAST)) then
                -- canCast = false
            end
            
            if canCast then
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
            
            return 4, spellData
        end
        
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
        -- if(unit:GetAttackDamage() > 1) then
            -- unit:MoveToPositionAggressive(targetPosition)
        -- end

        if unit:GetAttackTarget() == nil then
            local newOrder = {
                UnitIndex = unit:entindex(), 
                OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
                TargetIndex = cmdData:entindex(), 
                Queue = 0 
            }
            ExecuteOrderFromTable(newOrder)
        end


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



function UnitAI:CastSpell(spellData)
    local hSpell = spellData.ability
    
    if hSpell == nil or hSpell:IsFullyCastable() == false or hSpell:IsActivated() == false then
        return 0.1
    end
    
    if(hSpell:GetCaster():HasModifier("modifier_hero_waitting")) then
        return 0.1
    end
    
    if(spellData.type == "toggle") then
        if hSpell:GetToggleState() == false then
            hSpell:ToggleAbility()
            table.insert(hSpell:GetCaster().toggleOffList, hSpell)
        end
        return 0.1
    end
    
    if(spellData.type == "unit_target") then
        return UnitAI:CastSpellUnitTarget(hSpell, spellData.target)
    end
    
    if(spellData.type == "point_target") then
        return UnitAI:CastSpellPointTarget(hSpell, spellData.target)
    end
    
    if(spellData.type == "no_target") then
        return UnitAI:CastSpellNoTarget(hSpell)
    end
    
    -- if(spellData.type == "tree_target") then
        -- return UnitAI:CastSpellTreeTarget(hSpell, spellData.target)
    -- end
    
    return 0.1
end


function UnitAI:GetUnitsWithHpLowerThan(unit, radius, teamFlag, hpThreshold, excludeBuff)
    
    if radius == nil then
        radius = 1000
    end
    
    local ret = {}
    local base = nil
    
    local candidates = FindUnitsInRadius(unit:GetTeam(), unit:GetAbsOrigin(), nil, radius, teamFlag, DOTA_UNIT_TARGET_CREEP,
        UNIT_FILTER, FIND_CLOSEST, true)
    
    --print('GetUnitsWithHpLowerThan len ' .. #candidates)
    
    if #candidates == 0 then
        return ret
    end
    
    filterFunc = function(unit, hpThreshold, excludeBuff) 
    
        if unit:HasModifier("modifier_player_jidi") then
            return false
        end
        
        if hpThreshold and unit:GetHealth() >= unit:GetMaxHealth() * hpThreshold then
            return false
        end
        
        if excludeBuff and unit:HasModifier(excludeBuff) then
            return false
        end
            
        return true
    end
    
    
    for index = 1, #candidates do
        local candidate = candidates[index]
        if not candidate:IsHero() and candidate.in_battle_id and candidate.in_battle_id == unit.in_battle_id then
            
            local isValid = filterFunc(candidate, hpThreshold,excludeBuff);
            if isValid then
                table.insert(ret, candidate)
            end
            
        end
    end
    return ret
end



--返回敌人集合 及 基地本身
function UnitAI:ClosestEnemyAll(unit, radius)
    
    if radius == nil then
        radius = FIND_UNITS_EVERYWHERE
    end
    
    local ret = {}
    local base = nil
    
    local candidates = FindUnitsInRadius(unit:GetTeam(), unit:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP,
        UNIT_FILTER, FIND_CLOSEST, true)
    if #candidates == 0 then
        return ret, base
    end
	
    for index = 1, #candidates do
		
        local candidate = candidates[index]
		
        if not candidate:IsHero() and candidate.in_battle_id ~= nil and candidate.in_battle_id == unit.in_battle_id then
            if not candidate:HasModifier("modifier_player_jidi") then
                table.insert(ret, candidate)
            else
                base = candidate
            end
        end
    end
    
    return ret, base
end

function UnitAI:GetSpellData(hSpell)
    if hSpell == nil or hSpell:IsActivated() == false then
        return nil
    end
    
    local nBehavior = hSpell:GetBehavior()
    local nTargetTeam = hSpell:GetAbilityTargetTeam()
    local nTargetType = hSpell:GetAbilityTargetType()
    local nTargetFlags = hSpell:GetAbilityTargetFlags()

    local abilityName = hSpell:GetName()
    local caster = hSpell:GetCaster()
    if(caster == nil or caster:IsNull()) then
        return nil
    end

    --handle special skills
    -- if(abilityName == "item_blink") then
        -- return {ability = hSpell, type = "point_target", target = castPos}
    -- end
    
    if bitContains(nTargetTeam, DOTA_UNIT_TARGET_TEAM_ENEMY) then
    
        --如果是无目标 则只判断是否满足周围单位条件
        if bitContains(nBehavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) then
            if UnitAI:IsNoTargetSpellCastValid(hSpell, DOTA_UNIT_TARGET_TEAM_ENEMY) then
                print("can cast")
                return {ability = hSpell, type = "no_target", target = nil}
            end
            
        --点目标 获取最佳释放位置
        elseif bitContains(nBehavior, DOTA_ABILITY_BEHAVIOR_POINT) then
            local vTargetLoc = UnitAI:GetBestAOEPointTarget(hSpell, DOTA_UNIT_TARGET_TEAM_ENEMY)
            if vTargetLoc ~= nil then
                return {ability = hSpell, type = "point_target", target = vTargetLoc}
            end
        elseif bitContains(nBehavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) then
            
            local hTarget = UnitAI:GetBestOneTarget(hSpell)
            
            --特殊处理淘汰之刃
            if abilityName == 'axe_culling_blade' then
                local hpMin = 0
                if hSpell:GetLevel() == 1 then
                    hpMin = 100
                elseif hSpell:GetLevel() == 2 then
                    hpMin = 200
                end
                
                if hTarget ~= nil and hTarget:IsAlive() and hTarget:GetHealth() > hpMin then
                    hTarget = nil
                end
            end
            
            if hTarget ~= nil and hTarget:IsAlive() then
                return {ability = hSpell, type = "unit_target", target = hTarget}
            end
            
        end
    elseif bitContains(nTargetTeam, DOTA_UNIT_TARGET_TEAM_FRIENDLY) then
        
        local candis = {}
		if abilityName == 'abaddon_aphotic_shield' then
        
			candis = self:GetUnitsWithHpLowerThan(caster, UnitAI:GetSpellRange(hSpell), DOTA_UNIT_TARGET_TEAM_FRIENDLY, 0.9)
            
		elseif abilityName == 'treant_living_armor' then
        
            candis = self:GetUnitsWithHpLowerThan(caster, UnitAI:GetSpellRange(hSpell), DOTA_UNIT_TARGET_TEAM_FRIENDLY, 0.8, "modifier_treant_living_armor")
        elseif abilityName == 'ogre_magi_bloodlust' then
        
            candis = self:GetUnitsWithHpLowerThan(caster, UnitAI:GetSpellRange(hSpell), DOTA_UNIT_TARGET_TEAM_FRIENDLY, 0.8, "modifier_ogre_magi_bloodlust")
        elseif abilityName == 'dazzle_shallow_grave' then
        
            candis = self:GetUnitsWithHpLowerThan(caster, UnitAI:GetSpellRange(hSpell), DOTA_UNIT_TARGET_TEAM_FRIENDLY, 0.35)
            
        elseif abilityName == 'dazzle_shadow_wave' then
        
            candis = self:GetUnitsWithHpLowerThan(caster, UnitAI:GetSpellRange(hSpell), DOTA_UNIT_TARGET_TEAM_FRIENDLY, 0.8)
        elseif abilityName == 'warlock_shadow_word' then
            candis = self:GetUnitsWithHpLowerThan(caster, UnitAI:GetSpellRange(hSpell), DOTA_UNIT_TARGET_TEAM_FRIENDLY, 0.9, 'modifier_warlock_shadow_word')
            
        end
        
        if #candis > 0 then
            return {ability = hSpell, type = "unit_target", target = candis[1]}
        end
	end
    
    return nil
end


function UnitAI:GetBestOneTarget(hSpell)
    --可能会丢魔免 会打隐身 要搞掉
    local enemies = UnitAI:ClosestEnemyAll(hSpell:GetCaster(),UnitAI:GetSpellRange(hSpell))
    
    if #enemies == 0 then
        return nil
    end
    
    for i = 1, #enemies do
        if enemies[i]:IsAlive() then
            return enemies[i]
        end
    end
    
    return nil
end


function UnitAI:IsNoTargetSpellCastValid(hSpell, targetTeamType)
    local nUnitsRequired = 1
    
    --大招要三个老逼释放
    if hSpell:GetAbilityType() == ABILITY_TYPE_ULTIMATE then
        nUnitsRequired = 3
    end
    
    local nAbilityRadius = 0

    if hSpell.GetAOERadius ~= nil then
        nAbilityRadius = hSpell:GetAOERadius()
    end

    if nAbilityRadius == nil or nAbilityRadius == 0 then
        nAbilityRadius = 600
    end

    local units = UnitAI:ClosestEnemyAll(hSpell:GetCaster(), nAbilityRadius)

    if #units < nUnitsRequired then
        return false
    end
    
    return true
end

function UnitAI:GetBestAOEPointTarget(hSpell, targetTeamType)
    
    local nUnitsRequired = 1
    if hSpell:GetAbilityType() == ABILITY_TYPE_ULTIMATE then
        nUnitsRequired = 2
    end
    
    local nAbilityRadius = 0

    if hSpell.GetAOERadius ~= nil then
        nAbilityRadius = hSpell:GetAOERadius()
    end
    
    if nAbilityRadius == nil or nAbilityRadius == 0 then
        nAbilityRadius = 250
    end
    
    local vLocation = GetTargetAOELocation(hSpell:GetCaster():GetTeamNumber(),
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
        targetTeamType,
        hSpell:GetCaster():GetAbsOrigin(),
        UnitAI:GetSpellRange(hSpell),
        nAbilityRadius,
    nUnitsRequired)
    if vLocation == vec3_invalid then
        return nil
    end
    
    return vLocation
end

function UnitAI:GetBestTargetInRange(hSpell)
    local abilityKeyValues = hSpell:GetAbilityKeyValues()
    local castMagicImmuneTarget = false
    if(abilityKeyValues ~= nil and abilityKeyValues.SpellImmunityType == "SPELL_IMMUNITY_ENEMIES_YES") then
        castMagicImmuneTarget = true
    end
    
    local unit = hSpell:GetCaster()
    local teamId = unit:GetTeamNumber()
    local radius = UnitAI:GetSpellRange(hSpell)


    
    local enemies = FindUnitsInRadius(teamId, unit:GetAbsOrigin(), unit, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,
    UNIT_FILTER, FIND_CLOSEST, true)
    
    if #enemies == 0 then
        return nil
    end
    
    local firstEnemy = nil
    
    for index = 1, #enemies do
        if(enemies[index]:GetAbsOrigin().y > MAX_BATTLE_Y and enemies[index]:IsAlive() and enemies[index]:IsInvulnerable() == false) then
            if(enemies[index]:IsMagicImmune() == false or castMagicImmuneTarget) then
                if(enemies[index]:IsInvisible() == false or UnitAI:HasTargetTrueSight(unit, enemies[index])) then
                    firstEnemy = enemies[index]
                    break
                end
            end
        end
    end
    
    return firstEnemy
end


function UnitAI:CastSpellUnitTarget(hSpell, hTarget)
    local caster = hSpell:GetCaster()
    if(caster == nil or caster:IsNull() or caster:IsAlive() == false) then
        return 0.1
    end
    
    if(hTarget == nil or hTarget:IsNull() or hTarget:IsAlive() == false) then
        return 0.1
    end
    
    caster:CastAbilityOnTarget(hTarget, hSpell, UnitAI:GetPlayerId(caster))
    
    return UnitAI:GetSpellCastTime(hSpell)
end


function UnitAI:CastSpellPointTarget(hSpell, vLocation)
    local caster = hSpell:GetCaster()
    if(caster == nil or caster:IsNull() or caster:IsAlive() == false) then
        return 0.1
    end
    

    caster:CastAbilityOnPosition(vLocation, hSpell, UnitAI:GetPlayerId(caster))
    
    
    return UnitAI:GetSpellCastTime(hSpell)
end


function UnitAI:CastSpellNoTarget(hSpell)
    local caster = hSpell:GetCaster()
    if(caster == nil or caster:IsNull() or caster:IsAlive() == false) then
        return 0.1
    end
    
    caster:CastAbilityNoTarget(hSpell, UnitAI:GetPlayerId(caster))
    
    return UnitAI:GetSpellCastTime(hSpell)
end



function UnitAI:GetSpellRange(hSpell)
    if(hSpell == nil) then
        return 250
    end
    
    local baseCastRange = hSpell:GetCastRange(vec3_invalid, nil)
    if(baseCastRange == nil or baseCastRange < 250) then
        baseCastRange = 250
    end
    
    local abilityName = hSpell:GetName()
    if(abilityName == "item_blink") then
        return 1200
    end
    
    if(abilityName == "item_hurricane_pike") then
        return 400
    end
    
    return baseCastRange + 100
end

function UnitAI:GetPlayerId(unit)

    local team = unit:GetTeam()
    
    local pid = GameRules:GetGameModeEntity().team2playerid[team]
    if pid == nil then
        pid = -1
    end
    

    return pid
end


function UnitAI:GetSpellCastTime(hSpell)
    
    if hSpell == nil or hSpell:IsNull() then
        return 0.4
    end
    local flCastPoint = math.max(0.25, hSpell:GetCastPoint() + hSpell:GetChannelTime() + hSpell:GetBackswingTime())
    if(flCastPoint < 0.2) then
        flCastPoint = 0.2
    end
    
    return flCastPoint
    
end

function UnitAI:GetCertainBase(battle_idx)
    if not battle_idx then
        return nil;
    end
    return GameRules:GetGameModeEntity().WhoToAttack.field_base[battle_idx];
end
