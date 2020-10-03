build_evil_01 = class({})


function build_evil_01:OnSpellStart()
    local caster = self:GetCaster()
    local casterPos = caster:GetAbsOrigin()
    local team = caster:GetTeam()
    
    local unitName = "test_monster"
    
	--print("spawn unit for " .. unitName .. " team " .. team)
    
    GameRules:GetGameModeEntity().WhoToAttack:CreateUnit(team, casterPos,unitName,1);
end


function build_evil_01:CastFilterResult()
    if not IsServer() then
        return;
    end
    DeepPrintTable(self:GetCaster())
    if not self:GetCaster().can_toss then
        --print("not yet")
        return UF_FAIL_CUSTOM
    end
    
    return UF_SUCCESS
end

function build_evil_01:GetCustomCastError()
	if not self:GetCaster().can_toss then
        return "nmsl 时机未到"
    end
	return ""
end