

function SpawnUnit(keys)
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	
	local ability = keys.ability
	local unitName = ability:GetSpecialValueFor("unit_name")
	
    local team = caster:GetTeam()
	print("spawn unit for " .. unitName .. " team " .. team)
    --给投掷
end 

function Touzhi(keys)
    local caster = keys.caster
    
    local target_battle = 6
    --FIND_UNITS_EVERYWHERE
    local enemies = FindUnitsInRadius(6, caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL,
    UNIT_FILTER, FIND_CLOSEST, true)
    
    --local pos = keys.
   
    
    local target = nil
    if #enemies > 0 then
        target = enemies[1]
    end
    --寻找范围内单位
    if target ~= nil then
        GameRules:GetGameModeEntity():ChangeBattleField(target, pos)
        
    end
    
    --check range
    --ChangeBattleField
end