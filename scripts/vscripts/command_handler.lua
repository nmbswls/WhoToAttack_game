

function CRPGExample:HandleCommand(keys)
	--DeepPrintTable(keys)
	
	
	local player = PlayerResource:GetPlayer(keys.playerid)
    local hero = player:GetAssignedHero();
	
	
	
    if hero == nil then
        return
    end
	
	local heroindex = hero:GetEntityIndex()
	local team = hero:GetTeam()
	local tokens =  string.split(string.lower(keys.text))

	
	print(tokens[1]);
	
	if tokens[1] == '-dialog' then
		dialog_manager:FireDialogEvent()
	end
	if tokens[1] == '-cp' then
	
	end

	--测试命令
	if string.find(keys.text,"^e%w%w%w$") ~= nil then
		if hero.effect ~= nil then
			hero:RemoveAbility(hero.effect)
			hero:RemoveModifierByName('modifier_texiao_star')
		end
		hero:AddAbility(keys.text)
		hero:FindAbilityByName(keys.text):SetLevel(1)
		hero.effect = keys.text
	end
	
end