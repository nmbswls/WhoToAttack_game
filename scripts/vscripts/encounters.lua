if WtaEncounters == nil then
	WtaEncounters = class({})
end

--encounter peizhi

EncountersByTurn = {
	[5] = {
		[1] = {eid = 1, weight = 10}
		[2] = {eid = 2, weight = 10}
		[3] = {eid = 3, weight = 10}
		[4] = {eid = 4, weight = 10}
		[5] = {eid = 5, weight = 1}
		[6] = {eid = 6, weight = 10}
		[7] = {eid = 7, weight = 10}
		[8] = {eid = 8, weight = 10}
		[9] = {eid = 9, weight = 1}
	},
	[6] = {},
	[7] = {},
	[8] = {},
	[9] = {},
}

EncounterInfo = {
	[1] = {
		eid = 1,
		type = 5,
	},
	[2] = {
	
	},
	[3] = {
	
	},
	[4] = {
	
	},
}


function WtaEncounters:init()
	
	--管理每个玩家身上的事件表
	self.curEncounterList = {};
	
end


function WtaEncounters:handleOneEncounter(eid)
	if type == 1 then
	
	elseif type == 2 then
	
	end
	
end

function WtaEncounters:

function WtaEncounters:GetRandomEncounter(turn, num)
	if EncountersByTurn[turn] == nil then
		return nil
	end
	local encounters = EncountersByTurn[turn]
	local poolNum = #encounters
	local ret = {};
	if num <= poolNum then
		for i = 1, poolNum do
			table.insert(ret, encounters[i].id);
		end
		return ret;
	end
	
	local idx = 1
	--根据采样
	
	
	local values = {};
	local newOrder = {};
	for i = 1, #encounters do
		table.insert(newOrder, i);
		local randVal = RandomFloat(0.0, 1.0);
		local val = math.pow(randVal, 1.0 / encounters[i].weight)
		table.insert(values, val);
	end
	
	table.sort(newOrder,function(a,b)
			local valA = values[a];
			local valB = values[b];
			return valA > valB
		end)
		
	
	for i = 1, num do
		table.insert(ret, encounters[newOrder[i]].id);
	end
	return ret;
end