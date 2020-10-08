modifier_base = class({})


function modifier_base:IsHidden()
    return true
end

function modifier_base:IsPurgable()
    return false
end

function modifier_base:RemoveOnDeath()
    return false
end



function modifier_base:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

