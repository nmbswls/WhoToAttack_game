require 'utils.msg'


function AddBuildAbility(keys)
	local caster = keys.caster
	if not caster:IsRealHero() then return end
	local playerID = caster:GetPlayerID()
	local ability = keys.ability
	local unitName = string.sub(ability:GetAbilityName(), 7)
    
    print("try use skill " .. unitName)
    
    
    
    if not GameRules:GetGameModeEntity().WhoToAttack:CanBuildUnits() then
        msg.bottom("尚不能建造单位",playerID,1)
        ability:RefundManaCost()
        return 
    end
    
    local rand = RandomInt(1,100)
    local speGailv = ability:GetSpecialValueFor("gailv")
    
    --print("gailv is " .. speGailv)
    local spe = false;
    if rand <= speGailv then
        spe = true
		caster:EmitSoundParams("DOTA_Item.Daedelus.Crit",0,4,0)
    end
    
    
    local team = caster:GetTeam()
    local newyUnit = GameRules:GetGameModeEntity().WhoToAttack:CreateUnit(team, caster:GetAbsOrigin(),unitName,spe);
    
    if newyUnit then
		
		
    end

end

