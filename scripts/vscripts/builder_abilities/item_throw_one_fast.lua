item_throw_one_fast = class({})

function item_throw_one_fast:GetAOERadius()
    return 300
end


function item_throw_one_fast:OnSpellStart()
    local caster = self:GetCaster()
    local casterPos = caster:GetAbsOrigin()
    local team = caster:GetTeam()
    
    if not GameRules:GetGameModeEntity().WhoToAttack:CanThrow() then
        local pid = GameRules:GetGameModeEntity().team2playerid[team]
        msg.bottom('时机未到(Not yet)',pid)
        return;
    end
    
    local pos = self:GetCursorPosition()
    --print("touzhi target " .. pos.x .. " " .. pos.y)
    
    local minDist = 0
    local minIdx = -1
    
    local target_battle = minIdx
    
    
    --FIND_UNITS_EVERYWHERE
    local aroundUnits = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL,
    UNIT_FILTER, FIND_CLOSEST, true)
    
    --local pos = keys.
    
    local target = nil
    if #aroundUnits > 0 then
        
        for i = 1, #aroundUnits do
            if aroundUnits[i]:GetEntityIndex() ~= caster:GetEntityIndex() and not aroundUnits[i]:HasModifier("modifier_base") then
                target = aroundUnits[i]
                break
            end
        end
        
        --target = aroundUnits[1]
    end
    --寻找范围内单位
    if target ~= nil then
    
        print("name " .. target:GetUnitName());
        
        local idx = GameRules:GetGameModeEntity().WhoToAttack:CheckThrowTarget(target, pos);
        
        if idx == -1 then
            local pid = GameRules:GetGameModeEntity().team2playerid[team]
            msg.bottom('只能选择基地投掷(Base Only)',pid)
            return;
        end
        GameRules:GetGameModeEntity().WhoToAttack:ChangeBattleField(target, idx)
        GameRules:GetGameModeEntity().WhoToAttack:MoveUnit(caster, target, pos, true)
        
		target:SetBaseManaRegen(target.originManaRegen or 0)
    end
end


function item_throw_one_fast:CastFilterResultLocation(vLocation)
    if not IsServer() then
        return;
    end
    local target = GameRules:GetGameModeEntity().WhoToAttack:GetPosBattleField(vLocation);
    
    if not target then
        return UF_FAIL_CUSTOM;
    end
    
    if not target.is_open then
        return UF_FAIL_CUSTOM;
    end
    --DeepPrintTable(self:GetCaster())
    -- if not self:getcaster().can_toss then
        -- --print("not yet")
        -- return uf_fail_custom
    -- end
    
    return UF_SUCCESS
end

function item_throw_one_fast:GetCustomCastErrorLocation(vLocation)
	
	return "只能选择开门的地方(Ping Area Only)"
end