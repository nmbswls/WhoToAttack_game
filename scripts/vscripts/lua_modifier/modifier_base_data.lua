

function CheckOneAttack(keys)
    
    local caster = keys.caster;
    local attacker = keys.attacker;
    
    local attackerIdx = attacker:GetEntityIndex()
    if caster.turn_attacker[attackerIdx] ~= nil then
        return
    end
    caster.turn_attacker[attackerIdx] = 1
    local team_id = attacker:GetTeam();
    local bonus = GameRules.Definitions.Uname2Cost[attacker:GetUnitName()] * 2;
    
    local hero1 = PlayerManager:getHeroByTeam(team_id);
    if hero1 then
        hero1:ModifyGold(bonus, true, 0);
    end
    
    GameRules:GetGameModeEntity().WhoToAttack:ModifyBaseHP(caster.hero, -1);
	
    if attacker:IsAlive() then
        --print("try to kill " .. attacker:GetEntityIndex())
        attacker:Kill(nil, nil)
    end
    
    -- local hero2 = GameRules:GetGameModeEntity().teamid2hero[caster:GetTeam()];
    -- if hero2 then
        -- hero2:ModifyGold(2, true, 0);
    -- end
end
