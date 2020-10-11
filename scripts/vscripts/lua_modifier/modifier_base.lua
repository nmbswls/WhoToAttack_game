modifier_base = class({})


function modifier_base:IsHidden()
    return false
end

function modifier_base:IsPurgable()
    return false
end

function modifier_base:RemoveOnDeath()
    return false
end



function modifier_base:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACKED ,
    }
    return funcs
end

function modifier_base:OnAttacked(params)

    print("on attacked")
    local attacker = params.attacker;
    if not attacker or attacker:IsNull() then
        return
    end
    
    if attacker:IsAlive() then
        attacker:Kill(nil, self:GetCaster())
    end
end
