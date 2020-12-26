

function CheckOneAttack(keys)
    
    local caster = keys.caster;
    local attacker = keys.attacker;
    
    if not attacker then
        return
    end
    
    local attackerIdx = attacker:GetEntityIndex()
    if caster.turn_attacker[attackerIdx] ~= nil then
        print("重复attaker")
        return
    end
    
    local team_id = attacker:GetTeam();
    
    local level = attacker:GetLevel() --GameRules.Definitions.Uname2Cost[attacker:GetUnitName()];
    
    --print("attacker name " .. attacker:GetUnitName() .. " level " .. level)
    local bonus = level * 2;
    local hero1 = PlayerManager:getHeroByTeam(team_id);
    if hero1 then
        hero1:ModifyGold(bonus, true, 0);
    end
    
    
    GameRules:GetGameModeEntity().WhoToAttack:ModifyBaseHP(caster.hero, -1);
	
    if attacker:IsAlive() then
        --print("try to kill " .. attacker:GetEntityIndex())
        attacker:Kill(nil, nil)
    end
    
    caster.turn_attacker[attackerIdx] = 1
    -- local hero2 = GameRules:GetGameModeEntity().teamid2hero[caster:GetTeam()];
    -- if hero2 then
        -- hero2:ModifyGold(2, true, 0);
    -- end
end
