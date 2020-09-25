

function SpawnUnit(keys)
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	
	local difference = point - casterPos
	local ability = keys.ability
	local unitName = ability:GetSpecialValueFor("unit_name")
	
    local team = caster:GetTeam()
	print("spawn unit for " .. unitName .. " team " .. team)
    --给投掷
end 

function Touzhi(keys)

	print("throw " .. unitName)
end