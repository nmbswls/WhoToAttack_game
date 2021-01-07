if WtaEncounters == nil then
	WtaEncounters = class({})
end
LinkLuaModifier("modifier_add_gold", "lua_modifier/modifier_add_gold.lua", LUA_MODIFIER_MOTION_NONE)
--encounter peizhi

EncountersByTurn = {
	[5] = {
		[1] = {eid = 101, weight = 10},
		[2] = {eid = 102, weight = 10},
		[3] = {eid = 103, weight = 10},
		[4] = {eid = 202, weight = 10},
		[5] = {eid = 201, weight = 1},
		[6] = {eid = 301, weight = 10},
		[7] = {eid = 401, weight = 10},
		[8] = {eid = 501, weight = 10},
		[9] = {eid = 601, weight = 1},
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
ETYPE_KUGONG = 1
ETYPE_YINHANGJIA = 2
ETYPE_XIAOCHOU = 3
ETYPE_CHANGDI = 4
ETYPE_SHANGDIAN = 5
ETYPE_CHAOSHENG = 6
ETYPE_RUQIN = 7
--1 - kugong
--2 - yinhangjia
--3 - xiaochou
EncounterInfo = {
	[101] = {
		etype = 1,
		val = 3,
	},
	[102] = {
		etype = 1,
		val = 5,
	},
	[103] = {
		etype = 1,
		val = 8,
	},
	[104] = {
		etype = 1,
		val = 12
	},
	[201] = {
		etype = 2,
		cost = 5,
		payback = 15,
	},
	[202] = {
		etype = 2,
		cost = 10,
		payback = 30,
	},
	[203] = {
		etype = 2,
		cost = 15,
		payback = 45,
	},
	[204] = {
		etype = 2,
		cost = 20,
		payback = 60,
	},
	[301] = {
		etype = 3,
		gailv = {
			[1] = 20,
			[2] = 20,
		}
	},
	[302] = {
		etype = 3,
		gailv = {
			
		}
	},
	[303] = {
		etype = 3,
		gailv = {
			
		}
	},
	[304] = {
		etype = 3,
		gailv = {
			
		}
	},
	[401] = {
		etype = 4,
		
	},
	[402] = {
		etype = 4,
	},
	[403] = {
		etype = 4,
	},
	[404] = {
		etype = 4,
	},
	[501] = {
		etype = 5,
		level = 1,
		cost = 30,
	},
	[502] = {
		etype = 5,
		level = 1,
		cost = 30,
	},
	[503] = {
		etype = 5,
		level = 1,
		cost = 30,
	},
	[504] = {
		etype = 5,
		level = 1,
		cost = 30,
	},
	[601] = {
		etype = 6,
		level = 1,
	},
	[602] = {
		etype = 6,
		level = 2,
	},
	[603] = {
		etype = 6,
		level = 3,
	},
	[604] = {
		etype = 6,
		level = 4,
	},
	[701] = {
		etype = 6,
	},
	[702] = {
		etype = 6,
	},
	[703] = {
		etype = 6,
	},
	[704] = {
		etype = 6,
	},
	[801] = {
		etype = 6,
	},
	[802] = {
		etype = 6,
	},
	[803] = {
		etype = 6,
	},
	[804] = {
		etype = 6,
	},
}

ShopinfoList = {
	[1] = {
		[1] = {item = "item_sphere", weight = 10},
		[2] = {item = "item_sphere", weight = 10},
		[3] = {item = "item_sphere", weight = 10},
		[4] = {item = "item_sphere", weight = 10},
	},
	[2] = {
		[1] = {item = "item_sphere", weight = 10},
		[2] = {item = "item_sphere", weight = 10},
		[3] = {item = "item_sphere", weight = 10},
		[4] = {item = "item_sphere", weight = 10},
		[5] = {item = "item_sphere", weight = 10},
	},
	[3] = {
		[1] = {item = "item_sphere", weight = 10},
		[2] = {item = "item_sphere", weight = 10},
		[3] = {item = "item_sphere", weight = 10},
		[4] = {item = "item_sphere", weight = 10},
		[5] = {item = "item_sphere", weight = 10},
	},
	[4] = {
		[1] = {item = "item_sphere", weight = 10},
		[2] = {item = "item_sphere", weight = 10},
	},
	[5] = {
		[1] = {item = "item_sphere", weight = 10},
		[2] = {item = "item_sphere", weight = 10},
		[3] = {item = "item_sphere", weight = 10},
	},
}

ChaoshengList = {
	[1] = {
		[1] = {name = "evil_skeleton", weight = 10},
		[2] = {name = "evil_skeleton", weight = 10},
		[3] = {name = "evil_skeleton", weight = 10},
		[4] = {name = "evil_skeleton", weight = 10},
	},
	[2] = {
		[1] = {name = "evil_skeleton", weight = 10},
		[2] = {name = "evil_skeleton", weight = 10},
		[3] = {name = "evil_skeleton", weight = 10},
		[4] = {name = "evil_skeleton", weight = 10},
		[5] = {name = "evil_skeleton", weight = 10},
	},
	[3] = {
		[1] = {name = "evil_skeleton", weight = 10},
		[2] = {name = "evil_skeleton", weight = 10},
		[3] = {name = "evil_skeleton", weight = 10},
		[4] = {name = "evil_skeleton", weight = 10},
		[5] = {name = "evil_skeleton", weight = 10},
	},
	[4] = {
		[1] = {name = "evil_skeleton", weight = 10},
		[2] = {name = "evil_skeleton", weight = 10},
	},
	[5] = {
		[1] = {name = "evil_skeleton", weight = 10},
		[2] = {name = "evil_skeleton", weight = 10},
		[3] = {name = "evil_skeleton", weight = 10},
	},
}

MonsterList = {
	[1] = {
		[1] = {name = "evil_skeleton", weight = 10},
		[2] = {name = "evil_skeleton", weight = 10},
		[3] = {name = "evil_skeleton", weight = 10},
		[4] = {name = "evil_skeleton", weight = 10},
	},
	[2] = {
		[1] = {name = "evil_skeleton", weight = 10},
		[2] = {name = "evil_skeleton", weight = 10},
		[3] = {name = "evil_skeleton", weight = 10},
		[4] = {name = "evil_skeleton", weight = 10},
		[5] = {name = "evil_skeleton", weight = 10},
	},
	[3] = {
		[1] = {name = "evil_skeleton", weight = 10},
		[2] = {name = "evil_skeleton", weight = 10},
		[3] = {name = "evil_skeleton", weight = 10},
		[4] = {name = "evil_skeleton", weight = 10},
		[5] = {name = "evil_skeleton", weight = 10},
	},
	[4] = {
		[1] = {name = "evil_skeleton", weight = 10},
		[2] = {name = "evil_skeleton", weight = 10},
	},
	[5] = {
		[1] = {name = "evil_skeleton", weight = 10},
		[2] = {name = "evil_skeleton", weight = 10},
		[3] = {name = "evil_skeleton", weight = 10},
	},
}

function WtaEncounters:init()
	
	--管理每个玩家身上的事件表
	self.curEncounterList = {};
	
end


function WtaEncounters:handleOneEncounter(hero, eid)
	
	if not hero or not hero:IsAlive() then
		return false
	end	
	
	
	local data = EncounterInfo[eid]
	
	if not data then
		return false
	end
	
	if data.etype == ETYPE_KUGONG then
		WhoToAttack:ModifyBaseHP(hero.base, data.val);
	elseif data.etype == ETYPE_YINHANGJIA then
		local cost = data.cost;
		if hero:GetGold() < cost then
			msg.bottom('money not enough', 0)
			return false;
		end
		
		--hero:AddNewModifier(hero, nil, "modifier_add_gold", {duration = 5, payback = 10});
		Timers:CreateTimer(300,function()
			hero:ModifyGold(data[payback], false, 0)
			--hero:AddNewModifier(hero, nil, "modifier_add_gold", {duration = 5, payback = 10});
		end)
		
		hero:ModifyGold(-cost, false, 0)
	elseif data.etype == ETYPE_XIAOCHOU then
		
		if hero:GetGold() < 5 then
			msg.bottom('you need to have minimun 5 gold', hero)
			return false;
		end
		local ownedMoney = hero:GetGold();
		hero:SetGold(0, false);
		
		Timers:CreateTimer(1,function()
			hero:ModifyGold(math.floor(ownedMoney * 1.25), false, 0)
		end)
	elseif data.etype == ETYPE_CHANGDI then
	
	elseif data.etype == ETYPE_SHANGDIAN then
		local cost = data.cost;
		if hero:GetGold() < cost then
			msg.bottom('money not enough', 0)
			return false;
		end
		local shopItems = ShopinfoList[data.level]
		local retItem = GetWeightedOne(shopItems)
		print(retItem.item)
	elseif data.etype == ETYPE_CHAOSHENG then
		local units = ChaoshengList[data.level]
		local retUnit = GetWeightedOne(units)
		
		WhoToAttack:CreateUnit(hero.team, hero:GetAbsOrigin(), retUnit.name, false)
	elseif data.etype == ETYPE_RUQIN then
		local monsters = MonsterList[data.level]
		local retMonster = GetWeightedOne(monsters)
		
		WhoToAttack:SpawnNeutral(hero.team, retMonster.name, 5)
	end
	
	-- print('handleOneEncounter ' .. eid);
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



function GetWeightedOne(dataList)
	local totalWeight = 0;
	for i=1,#dataList do
		totalWeight = totalWeight + dataList[i].weight;
	end
	local rand = RandomInt(1, totalWeight)
	local tmp = 0;
	local ret = nil;
	for i=1,#dataList do
		tmp = tmp + dataList[i].weight;
		if rand <= tmp then
			ret = dataList[i];
			break;
		end
	end
	return ret
end