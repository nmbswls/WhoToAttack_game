function OnUse(keys)
	local caster = keys.caster
	if not caster:IsRealHero() then return end
    --UTIL_RemoveImmediate(keys.ability)
	caster:AddExperience(10,0,false,false);
end