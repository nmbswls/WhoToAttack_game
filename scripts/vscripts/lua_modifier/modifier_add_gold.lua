modifier_add_gold = class({})


function modifier_add_gold:IsHidden()
    return false
end

function modifier_add_gold:IsPurgable()
    return false
end

function modifier_add_gold:RemoveOnDeath()
    return false
end

function modifier_add_gold:OnCreated(kv)
    if not IsServer() then
		return
	end
	
	self.payback = kv.payback;
	
end

function modifier_add_gold:OnDestroy()
    if not IsServer() then
        return
    end
	local hero = self:GetParent();
	if not hero or not hero:IsRealHero() then
		return
	end
	
	hero:ModifyGold(self.payback, false, 0);
end
