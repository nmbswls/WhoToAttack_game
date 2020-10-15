LinkLuaModifier( "modifier_builder_grow_mana", "builder_abilities/builder_grow" ,LUA_MODIFIER_MOTION_NONE )
builder_grow = class({})

function builder_grow:GetIntrinsicModifierName()
    return "modifier_builder_grow_mana"
end

modifier_builder_grow_mana = class({
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    AllowIllusionDuplicate  = function(self) return false end,
    
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_MANA_BONUS
        }
    end,
})

function modifier_builder_grow_mana:GetModifierManaBonus() 
    local level = self:GetParent():GetLevel();
    return level * 10 
end
