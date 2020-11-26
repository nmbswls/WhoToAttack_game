modifier_hide = class({})


function modifier_hide:IsHidden()
    return false
end

function modifier_hide:IsPurgable()
    return false
end



function modifier_hide:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED ,
    }
    return funcs
end

function modifier_hide:OnAttackLanded(params)
    
    print("attacked")
end
