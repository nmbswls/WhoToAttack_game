if WtaEncounters == nil then
	WtaEncounters = class({})
end

--encounter peizhi

EncountersByTurn = {
	[5] = {
		[1] = {eid = 101, weight = 10},
		[2] = {eid = 102, weight = 10},
		[3] = {eid = 103, weight = 10},
		[4] = {eid = 104, weight = 10},
		[5] = {eid = 105, weight = 1},
		[6] = {eid = 106, weight = 10},
		[7] = {eid = 107, weight = 10},
		[8] = {eid = 108, weight = 10},
		[9] = {eid = 109, weight = 1},
	},
	[10] = {
		[1] = {eid = 201, weight = 10},
		[2] = {eid = 202, weight = 10},
		[3] = {eid = 203, weight = 10},
	},
	[15] = {
		[1] = {eid = 301, weight = 10},
		[2] = {eid = 302, weight = 10},
		[3] = {eid = 303, weight = 10},
	},
	[20] = {
		[1] = {eid = 401, weight = 10},
		[2] = {eid = 402, weight = 10},
		[3] = {eid = 403, weight = 10},
	},
	[25] = {
		[1] = {eid = 501, weight = 10},
		[2] = {eid = 502, weight = 10},
		[3] = {eid = 503, weight = 10},
	},
}
--etype
--1 - kugong
--2 - 
EncounterInfo = {
	[101] = {
		etype = 1,
	},
	[102] = {
		etype = 1,
	},
	[3] = {
		etype = 1,
	},
	[4] = {
		etype = 1,
	},
}


function WtaEncounters:init()
	
	--管理每个玩家身上的事件表
	self.curEncounterList = {};
	
end


function WtaEncounters:handleOneEncounter(hero, eid)
	local data = EncounterInfo[eid]
	
	if not data then
		return false
	end
	
	if data.etype == 1 then
	
	elseif data.etype == 2 then
	
	end
	
	print('handleOneEncounter ' .. eid);
	return true;
end


function WtaEncounters:GetRandomEncounter(turn, num)

	local turnEncounters = nil;
	print('GetRandomEncounter')
	for t, data in pairs(EncountersByTurn) do
		turnEncounters = data;
		if turn <= t then
			break
		end
	end
	
	if turnEncounters == nil then
		return nil
	end
	
	local poolNum = #turnEncounters
	print('poolNum ' .. poolNum)
	
	
	local ret = {};
	if poolNum <= num then
		for i = 1, poolNum do
			table.insert(ret, turnEncounters[i].id);
		end
		return ret;
	end
	
	--根据采样
	local values = {};
	local newOrder = {};
	for i = 1, #turnEncounters do
		table.insert(newOrder, i);
		local randVal = RandomFloat(0.0, 1.0);
		local val = math.pow(randVal, 1.0 / turnEncounters[i].weight)
		table.insert(values, val);
	end
	
	table.sort(newOrder,function(a,b)
			local valA = values[a];
			local valB = values[b];
			return valA > valB
		end)
		
	
	for i = 1, num do
		table.insert(ret, turnEncounters[newOrder[i]].eid);
	end
	return ret;
end