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
    
    print("gailv is " .. speGailv)
    local spe = false;
    if rand <= speGailv then
        unitName = unitName .. "_special"
        spe = true
    end
    
    
    local team = caster:GetTeam()
    local newyUnit = GameRules:GetGameModeEntity().WhoToAttack:CreateUnit(team, caster:GetAbsOrigin(),unitName,1);
    
    if newyUnit then
        local firstSkill = newyUnit:GetAbilityByIndex(0)
        if spe then
            firstSkill:SetLevel(2);
        end
        
        local level = newyUnit:GetLevel();
        if string.find(unitName, "nature") then
            WtaThrones:AddScore(1,team, level)
        elseif string.find(unitName, "evil") then
            WtaThrones:AddScore(2,team, level)
        elseif string.find(unitName, "hidden") then
            WtaThrones:AddScore(3,team, level)
        elseif string.find(unitName, "vibrant") then
            WtaThrones:AddScore(4,team, level)
        elseif string.find(unitName, "wizard") then
            WtaThrones:AddScore(5,team, level)
        elseif string.find(unitName, "brawn") then
            WtaThrones:AddScore(6,team, level)
    end
    
    
    end
end

