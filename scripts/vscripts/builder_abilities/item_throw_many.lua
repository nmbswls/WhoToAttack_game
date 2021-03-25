item_throw_many = class({})

function item_throw_many:GetAOERadius()
    return 300
end


function item_throw_many:OnSpellStart()
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
    
	local battle_idx = GameRules:GetGameModeEntity().WhoToAttack:CheckThrowTarget(target, pos);
				
	if battle_idx == -1 then
		local pid = GameRules:GetGameModeEntity().team2playerid[team]
		msg.bottom('只能选择基地投掷(Base Only)',pid)
		return;
	end
	
    local target = nil
    if #aroundUnits > 0 then
        
        for i = 1, #aroundUnits do
            if aroundUnits[i]:GetEntityIndex() ~= caster:GetEntityIndex() and not aroundUnits[i]:HasModifier("modifier_base") then
			
				local target = aroundUnits[i];
				local tmpPos = pos + Vector(RandomInt(-50,50),RandomInt(-50,50),0);
				
				GameRules:GetGameModeEntity().WhoToAttack:ChangeBattleField(target, battle_idx)
				GameRules:GetGameModeEntity().WhoToAttack:MoveUnit(caster, target, tmpPos)
				
				target:SetBaseManaRegen(target.originManaRegen or 0)
				
            end
        end
        
        --target = aroundUnits[1]
    end
	

end


function item_throw_many:CastFilterResultLocation(vLocation)
    if not IsServer() then
        return;
    end
    local target = GameRules:GetGameModeEntity().WhoToAttack:GetPosBattleField(vLocation);
    
    if not target then
        return UF_FAIL_CUSTOM;
    end
    
    if not target.is_open then
        --return UF_FAIL_CUSTOM;
    end
    --DeepPrintTable(self:GetCaster())
    -- if not self:getcaster().can_toss then
        -- --print("not yet")
        -- return uf_fail_custom
    -- end
    
    return UF_SUCCESS
end

function item_throw_many:GetCustomCastErrorLocation(vLocation)
	
	return "只能选择开门的地方(Ping Area Only)"
end