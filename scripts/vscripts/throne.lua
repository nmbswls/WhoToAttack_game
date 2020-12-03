if WtaThrones == nil then
	WtaThrones = class({})
end

function WtaThrones:init(teamNum)

    print("throne init num:" .. teamNum)
    
	local throneNum = GameRules.Definitions.ThroneCnt;
	self.teamNum = teamNum;
	self.throneList = {};
	self.throneTeamScores = {};
	self.sortedTeamIdx = {};
	for i=1,throneNum do 
		table.insert(self.throneTeamScores,{});
		table.insert(self.sortedTeamIdx,{});
		for tid = 6, 6+self.teamNum-1 do
			self.throneTeamScores[i][tid] = 5;
			table.insert(self.sortedTeamIdx[i],tid);
		end
	end
	
	for i=1,throneNum do 
		local throne = CreateUnitByName("god_throne", GameRules.Definitions.ThronePos[i], true, nil, nil, 3);
		table.insert(self.throneList,throne);
		local throneAb = throne:FindAbilityByName("throne_show_score");
		for tid = 6, 6+self.teamNum-1 do
            local name = "modifier_show_score_player_" .. string.format("%02d", tid);
			local mod = throneAb:ApplyDataDrivenModifier(throne,throne,name,{duration = -1});
            mod:SetStackCount(5);
        end
	end
	
end

function WtaThrones:AddScore(throneIdx, teamId)
	
	if throneIdx <= 0 or throneIdx > #self.throneTeamScores then
		return
	end
	
	self.throneTeamScores[throneIdx][teamId] = self.throneTeamScores[throneIdx][teamId] + 1;
	
	self:_refreshScore(throneIdx, teamId)
	
	self:_updateThroneShow(throneIdx);
end

function WtaThrones:_updateThroneShow(throneIdx)

	local throne = self.throneList[throneIdx];
	
	for tid=6,6+self.teamNum-1 do
		--remove all
		throne:RemoveModifierByName("modifier_show_score_player_" .. string.format("%02d", tid));
	end
	local order = self.sortedTeamIdx[throneIdx];
    local scoreList = self.throneTeamScores[throneIdx];
	local ability = throne:FindAbilityByName("throne_show_score");
	for _, tid in pairs(order) do
		--add again
		local mod = ability:ApplyDataDrivenModifier(throne, throne, "modifier_show_score_player_" .. string.format("%02d", tid),{duration = -1});
        mod:SetStackCount(scoreList[tid]);
	end

end

function WtaThrones:_refreshScore(throneIdx, teamId)

	if throneIdx <= 0 or throneIdx > #self.throneTeamScores then
		return
	end

	local scoreList = self.throneTeamScores[throneIdx];
	local newOrder = {};
	for tid=6,6+self.teamNum-1 do
		table.insert(newOrder, tid);
	end
	
	local sortedIdx = self.sortedTeamIdx[throneIdx];
	
	table.sort(newOrder,function(a,b)
			local scoreA = scoreList[a];
			local scoreB = scoreList[b];
			return scoreA > scoreB
		end)
		
	self.sortedTeamIdx[throneIdx] = newOrder;
	
	--just give value. refresh win turn end
end

function nmb()
	--refresh buffs
	--hero 身上标记自己有的throne buff到时候直接删
	for _,hero in pairs(heromap) do
		--remove throne buff
	end
	
	--refresh 满足阈值
	--并列都没有效果
end