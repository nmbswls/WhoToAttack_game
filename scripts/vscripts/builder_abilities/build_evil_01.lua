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
    
    
    -- if not GameRules:GetGameModeEntity().WhoToAttack.stage then
        -- return UF_FAIL_CUSTOM
    -- end
    
    return UF_SUCCESS
end

function build_evil_01:GetCustomCastErrorTarget( hTarget )
	if not GameRules:GetGameModeEntity().WhoToAttack.stage then
        return "nmsl"
    end

	return ""
end