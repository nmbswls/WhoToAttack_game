function OnTreasureActive(keys)
	local caster = keys.caster
	if not caster:IsRealHero() then return end
    UTIL_RemoveImmediate(keys.ability)
	print("treasure used");
end