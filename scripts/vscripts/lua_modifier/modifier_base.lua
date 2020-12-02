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
    
    if params.target ~= self:GetParent() then
        return
    end
    -- for k,v in pairs(params) do
        -- print( k .. " " .. tostring(v))
    -- end
    --DeepPrintTable()
    
    --print("on attacked " .. self:GetParent():GetUnitName())
    local attacker = params.attacker;
    if not attacker or attacker:IsNull() then
        return
    end
    
    if attacker:IsAlive() then
        --print("try to kill " .. attacker:GetEntityIndex())
        attacker:Kill(nil, nil)
    end
end
