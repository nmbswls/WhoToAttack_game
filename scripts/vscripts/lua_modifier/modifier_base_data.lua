

function CheckOneAttack(keys)
    
    local caster = keys.caster;
    local attacker = keys.attacker;
    
    print(attacker:GetUnitName())
    local attackerIdx = attacker:GetEntityIndex()
    if caster.turn_attacker[attackerIdx] ~= nil then
        return
    end
    caster.turn_attacker[attackerIdx] = 1
    local team_id = attacker:GetTeam();
    local bonus = GameRules.Definitions.Uname2Cost[attacker:GetUnitName()];
    
    print("bonus " .. bonus)
    
    local hero1 = GameRules:GetGameModeEntity().teamid2hero[team_id];
    if hero1 then
        hero1:ModifyGold(2, true, 0);
    end
    
    
    local hero2 = GameRules:GetGameModeEntity().teamid2hero[caster:GetTeam()];
    if hero2 then
        hero2:ModifyGold(2, true, 0);
    end
end
