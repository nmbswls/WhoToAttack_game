

function CheckOneAttack(keys)
    
    local caster = keys.caster;
    local attacker = keys.attacker;
    
    print("check attack")
    print(caster:GetUnitName())
    print(attacker:GetEntityIndex())
    local attackerIdx = attacker:GetEntityIndex()
    if caster.turn_attacker[attackerIdx] ~= nil then
        return
    end
    caster.turn_attacker[attackerIdx] = 1
end
