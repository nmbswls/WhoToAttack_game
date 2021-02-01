
if not IsServer() then return end


function EconRemoveParticle(pid)
	ParticleManager:DestroyParticle(pid, true)
	ParticleManager:ReleaseParticleIndex(pid)
end

function EconCreateParticleOverhead(hero, particleName)
	local pid = ParticleManager:CreateParticle(particleName,PATTACH_OVERHEAD_FOLLOW,hero)
	ParticleManager:SetParticleControlEnt(pid,0,hero,PATTACH_OVERHEAD_FOLLOW,"follow_overhead",hero:GetAbsOrigin(),true)
	return pid
end

EconFuncs = {}

EconFuncs.OnEquip_t10_server = function(hero)
    print('equip t10')
	-- WhoToAttack:ChangeBaseModel(hero, "")
end

EconFuncs.OnRemove_t10_server = function(hero)
    print('unequip t10')
	-- WhoToAttack:ChangeBaseModel(hero, "")
end

EconFuncs.OnEquip_t13_server = function(hero)
    print('equip t13')
	-- WhoToAttack:ChangeBaseModel(hero, "")
end

EconFuncs.OnRemove_t13_server = function(hero)
    print('unequip t13')
	-- WhoToAttack:ChangeBaseModel(hero, "")
end

EconFuncs.OnEquip_t15_server = function(hero)
    print('equip t15')
	-- WhoToAttack:ChangeBaseModel(hero, "")
end

EconFuncs.OnRemove_t15_server = function(hero)
    print('unequip t15')
	-- WhoToAttack:ChangeBaseModel(hero, "")
end

if EconManager == nil then EconManager = class({}) end

print('require econ manager')
function EconManager:constructor()
	
    self.SlotInfo = {}
	
	CustomGameEventManager:RegisterListener("player_query_shop_items_req",function(_, keys)
		self:OnPlayerQueryShopItemsReq(keys)
	end)
	
	CustomGameEventManager:RegisterListener("player_query_econ_data_req",function(_, keys)
		self:OnPlayerQueryEconData(keys)
	end)
	
	CustomGameEventManager:RegisterListener("player_equip_req",function(_, keys)
		self:OnPlayerEquip(keys)
	end)
	
    CustomGameEventManager:RegisterListener("player_preview_req",function(_, keys)
		self:OnPlayerPreview(keys)
	end)
	
end
function EconManager:OnPlayerQueryShopItemsReq(keys)
	print('OnPlayerQueryShopItemsReq')
	if self.vEconItems == nil then 
		self.vEconItems = {
			[1] = {name = "t10", image = "", cost = 3};
			[2] = {name = "t13", image = "", cost = 5};
			[3] = {name = "t15", image = "", cost = 3};
		}
		CustomNetTables:SetTableValue('econ_data', 'shop_items', self.vEconItems)
	end
	--if self.vEconItems == nil then 
	--	HttpUtils:SendHTTPGet('http://yueyutech.com:10010/GetShopItems',function(result)
	--		if result.StatusCode == 200 then
	--			local items = JSON:decode(result.Body)
	--			self.vEconItems = items
	--			CustomNetTables:SetTableValue('econ_data', 'shop_items', items)
	--		end
	--	end);
	--end
end

function EconManager:OnPlayerQueryEconData(keys)
	
	local playerid = keys.PlayerID
	local player = PlayerResource:GetPlayer(playerid)
	if not player then return end
	local data = {
		[1] = "t10",
		[2] = "t15",
	}
	
	
	CustomNetTables:SetTableValue('econ_data', 'collection_data_' .. playerid, data)
	CustomNetTables:SetTableValue('econ_data', 'coin_data_' .. playerid, {amount = 10})
	

	-- local steamid = PlayerResource:GetSteamAccountID(playerid)
	-- local req = CreateHTTPRequestScriptVM("POST","http://yueyutech.com:10010/GetCollection")
	-- req:SetHTTPRequestGetOrPostParameter("steamid",tostring(steamid))
	-- req:Send(function(result)
		-- if result.StatusCode == 200 then
			-- local data = JSON:decode(result.Body)
			-- for name, equip in pairs(data) do
				-- if name ~= 'steamid' then
					-- if equip == true then
						-- if Econ["OnEquip_" .. name .. "_server"] then
							-- Econ["OnEquip_" .. name .. "_server"](hero)
						-- end
					-- else
						-- if Econ["OnRemove_" .. name .. "_server"] then
							-- Econ["OnRemove_" .. name .. "_server"](hero)
						-- end
					-- end
				-- end
			-- end
			-- CustomNetTables:SetTableValue('econ_data', 'collection_data_' .. playerid, data)
		-- end
	-- end)
end


function EconManager:OnPlayerEquip(keys)
	local playerid = keys.PlayerID
    local player = PlayerResource:GetPlayer(playerid)
	local steamid = PlayerResource:GetSteamAccountID(playerid)
	local to_equip = keys.to_equip
	local slot = 1  -- read config
    
    local equips = self:GetPlayerEquipInfo(playerid);
    
    if not equips then
        print("get equip info fail.");
        return
    end
	
    print('OnPlayerEquip ' .. tostring(to_equip))
    
	local hero = player:GetAssignedHero()
	if not hero then return end
	
	
	local oldEquip = equips[slot];
	equips[slot] = to_equip;
	
	CustomNetTables:SetTableValue('econ_data', 'equip_info_' .. playerid, equips)
	
	--zhao yixia  zhuanhuan biaoqian
	--jiaoyan
	if to_equip ~= nil then
		if EconFuncs["OnEquip_" .. to_equip .. "_server"] then
			EconFuncs["OnEquip_" .. to_equip .. "_server"](hero)
		end
	end
	
	if oldEquip ~= nil and EconFuncs["OnEquip_" .. oldEquip .. "_server"]  then
		EconFuncs["OnEquip_" .. oldEquip .. "_server"](hero)
	end
	
end



function EconManager:OnPlayerPreview(keys)
	local playerid = keys.PlayerID
	local player = PlayerResource:GetPlayer(playerid)
	if not player then return end
    
	local hero = player:GetAssignedHero()
    
    
	if not hero then return end

	local name = keys.item
    local slot = 1  -- read config
    
    
	local equips = self:GetPlayerEquipInfo(playerid);
    if not equips then
        print("get equip info fail.");
        return
    end
    
	equips[slot] = nil;
	CustomNetTables:SetTableValue('econ_data', 'equip_info_' .. playerid, equips)
    
    --handle already equip
    
	if EconFuncs["OnEquip_" .. name .. "_server"] then
		EconFuncs["OnEquip_" .. name .. "_server"](hero)
	end

	Timers:CreateTimer(10, function()
		EconFuncs["OnRemove_" .. name .. "_server"](hero)
	end)
end


function EconManager:OnPlayerPurchase(keys)
	local id = keys.PlayerID
    local player = PlayerResource:GetPlayer(playerid)
	local item = keys.ItemName
	local steamid = PlayerResource:GetSteamAccountID(id)
	

	
	-- local req = CreateHTTPRequestScriptVM('POST', 'http://yueyutech.com:10010/Purchase')
	-- req:SetHTTPRequestGetOrPostParameter('steamid', tostring(steamid))
	-- req:SetHTTPRequestGetOrPostParameter('item', tostring(item))
	-- req:Send(function(result)
		-- if result.StatusCode == 200 then
			-- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'bom_player_purchase_message', {})
		-- end
		-- self:OnPlayerAskCollection({PlayerID=id})
	-- end)
end

function EconManager:GetPlayerEquipInfo(playerid)
    local equips = self.SlotInfo[playerid];
    if equips == nil then
        equips = {
            [1] = nil,
            [2] = nil,
            [3] = nil,
        }
        self.SlotInfo[playerid] = equips
    end
    return equips;
end


if GameRules.EconManager == nil then GameRules.EconManager = EconManager() end