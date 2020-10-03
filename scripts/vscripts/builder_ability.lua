

function SpawnUnit(keys)
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	
	local ability = keys.ability
	local unitName = ability.unit_name
	
    local team = caster:GetTeam()
	print("spawn unit for " .. unitName .. " team " .. team)
    
    GameRules:GetGameModeEntity().WhoToAttack:CreateUnit(team, casterPos,unitName,1);
    --给投掷
end 

function Touzhi(keys)
    local caster = keys.caster
    
    local pos = keys.target_points[1]
    print("touzhi target " .. pos.x .. " " .. pos.y)
    
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
    local aroundUnits = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL,
    UNIT_FILTER, FIND_CLOSEST, true)
    
    --local pos = keys.
   
    
    local target = nil
    if #aroundUnits > 0 then
        for i = 1, #aroundUnits do
            if aroundUnits[i]:GetEntityIndex() ~= caster:GetEntityIndex() then
                target = aroundUnits[i]
            end
        end
        
        --target = aroundUnits[1]
    end
    --寻找范围内单位
    if target ~= nil then
    
        print("name " .. target:GetUnitName());
    
        GameRules:GetGameModeEntity().WhoToAttack:ChangeBattleField(target, pos)
        GameRules:GetGameModeEntity().WhoToAttack:MoveUnit(target, pos)
        
    end
    
    
    --check range
    --ChangeBattleField
end