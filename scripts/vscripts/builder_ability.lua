

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
    
    local pos = keys.target_points[1]
    print("touzhi target " .. p.x .. " " .. p.y)
    
    local minDist = 0
    local minIdx = -1
    
    for team_i = 6, 13 do 
        local p2 = GameRules.Definitions.TeamCenterPos[team_i]
        local distance = (p2 - pos):Length2D()
        if minIdx == -1 or distance < minDist then
            minDist = distance
            minIdx = team_i;
        end
    end
    
    print("touzhi target battle " .. minIdx)
    local target_battle = minIdx
    
    
    
    --FIND_UNITS_EVERYWHERE
    local aroundUnits = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL,
    UNIT_FILTER, FIND_CLOSEST, true)
    
    --local pos = keys.
   
    
    local target = nil
    if #aroundUnits > 0 then
        target = aroundUnits[1]
    end
    --寻找范围内单位
    if target ~= nil then
        GameRules:GetGameModeEntity():ChangeBattleField(target, pos)
        
    end
    
    GameRules:GetGameModeEntity():MoveUnit(target, pos)
    --check range
    --ChangeBattleField
end