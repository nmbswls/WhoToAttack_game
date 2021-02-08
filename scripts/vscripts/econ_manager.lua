
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
	
	self.playerEconInfo = {}
	self.playerCollection = {}
    self.playerSlotInfo = {}
	
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
	
	CustomGameEventManager:RegisterListener("player_purchase_req",function(_, keys)
		self:OnPlayerPurchase(keys)
	end)
	
    CustomGameEventManager:RegisterListener("create_donate_order_req",function(_, keys)
        Co(function ()
            self:HandleDonateOrder(keys)
        end)
	end)
    
end

function EconManager:OnPlayerQueryShopItemsReq(keys)
	print('OnPlayerQueryShopItemsReq')
	if self.vEconItems == nil then 
		self.vEconItems = {
			[1001] = {name = "t10", slot = 1, cost = 3, is_count = 0};
			[1002] = {name = "t13", slot = 1, cost = 5, is_count = 0};
			[1003] = {name = "t15", slot = 1, cost = 3, is_count = 0};
			[1004] = {name = "t16", slot = 1, cost = 3, is_count = 0};
			[1005] = {name = "t17", slot = 1, cost = 3, is_count = 0};
			[1006] = {name = "t18", slot = 1, cost = 3, is_count = 0};
			[2001] = {name = "b01", slot = 2, cost = 3, is_count = 0};
			[2002] = {name = "b02", slot = 2, cost = 3, is_count = 0};
			[2003] = {name = "b03", slot = 2, cost = 3, is_count = 0};
			[2004] = {name = "b04", slot = 2, cost = 3, is_count = 0};
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
	
	if self.playerCollection[playerid] then
		CustomNetTables:SetTableValue('econ_data', 'collection_data_' .. playerid, self.playerCollection[playerid])
	end
	
	if self.playerEconInfo[playerid] then
		CustomNetTables:SetTableValue('econ_data', 'coin_data_' .. playerid, {amount = self.playerEconInfo[playerid].coin})
	end
	
	
	local equips = self:GetPlayerEquipInfo(playerid);
    
    if equips then
        CustomNetTables:SetTableValue('econ_data', 'equip_info_' .. playerid, equips)
    end
	

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
	local toEuipId = keys.itemId
    
    local equips = self:GetPlayerEquipInfo(playerid);
    
    if not equips then
        print("get equip info fail.");
        return
    end
	
    local hero = player:GetAssignedHero()
	if not hero then return end
    
    if not toEuipId or not tonumber(toEuipId) then
        print('toEuipId not valid.')
        return
    end
    toEuipId = tonumber(toEuipId)
    local toEuipInfo = self.vEconItems[toEuipId]
    
    if not toEuipInfo then
        print('toEuipInfo not found.')
        return
    end
    
    local slot = toEuipInfo.slot;
    if not slot then
        print('toEuipInfo slot info invalid.')
        return
    end
    DeepPrintTable(equips);
    
	local oldEquipId = equips[slot];
	print('OnPlayerEquip ' .. tostring(oldEquipId) .. " " .. toEuipId)
	if oldEquipId == toEuipId then
		print("tuo zhuangbei ");
		--相同表示脱装备
		equips[slot] = nil;
		
	else
	
		equips[slot] = toEuipId;
		
		if toEuipId ~= nil then
			if EconFuncs["OnEquip_" .. toEuipInfo.name .. "_server"] then
				EconFuncs["OnEquip_" .. toEuipInfo.name .. "_server"](hero)
			end
		end
	end
	
	if oldEquipId ~= nil and self.vEconItems[oldEquipId] ~= nil then
		local oldEquipData = self.vEconItems[oldEquipId]
		if EconFuncs["OnRemove_" .. oldEquipData.name .. "_server"]  then
			EconFuncs["OnRemove_" .. oldEquipData.name .. "_server"](hero)
		end
	end
	
	
	CustomNetTables:SetTableValue('econ_data', 'equip_info_' .. playerid, equips)
	
	--zhao yixia  zhuanhuan biaoqian
	--jiaoyan
	
	
end



function EconManager:OnPlayerPreview(keys)
	local playerid = keys.PlayerID
	local player = PlayerResource:GetPlayer(playerid)
	if not player then return end
    
	local hero = player:GetAssignedHero()
    
    
	if not hero then return end

	local itemId = keys.itemId
    local slot = 0  -- read config
    
    
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
	local playerid = keys.PlayerID
    local player = PlayerResource:GetPlayer(playerid)
	local item = keys.ItemName
	local steamid = PlayerResource:GetSteamAccountID(playerid)
	print('purchase ' .. item)
	
	table.insert(self.playerCollection[playerid], item)
	
	CustomGameEventManager:Send_ServerToPlayer(player, 'player_purchase_rsp', {ret = true})
	
	
	HttpUtils:SendHTTPPost(url, {steam_id = steamid, prop_id = 100}, function(obj)
		DeepPrintTable(obj)
		-- if result.StatusCode == 200 then
			-- --flush all collection_data_
			-- --update point
		-- end
		--obj coin
	end, function(t)
	
	end);
	
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
    local equips = self.playerSlotInfo[playerid];
    if equips == nil then
        equips = {
            [1] = nil,
            [2] = nil,
            [3] = nil,
        }
        self.playerSlotInfo[playerid] = equips
    end
    return equips;
end

function EconManager:InitPlayerEconInfo(steam_id, econ_info)
	local pid = PlayerManager.steamid2playerid[tostring(steam_id)];
	if pid == nil then
		print("invalid steam_id response.")
		return
	end
	local coin_1 = econ_info.coin_1;
	local coin_2 = econ_info.coin_2;
	self.playerSlotInfo[pid] = {
		[1] = nil,
		[2] = nil,
		[3] = nil,
	}
	self.playerCollection[pid] = {}
	self.playerEconInfo[pid] = {coin = coin_1}
	for _, info in pairs(econ_info.decoration_info) do
		if info.use_status then
			local targetSlot = self.vEconItems[tonumber(info.decoration.decoration_id)].slot;
			self.playerSlotInfo[pid][targetSlot] = info.decoration.decoration_id
		end
		table.insert(self.playerCollection[pid],info.decoration.decoration_id)
	end
	
	-- DeepPrintTable(self.playerCollection[pid])
	-- DeepPrintTable(self.playerSlotInfo[pid])
	-- DeepPrintTable(self.playerEconInfo[pid])
	
	self:OnPlayerQueryEconData({PlayerID = pid})
end

function LookAtDonatePaymentIsComplete( player, key )
	GameMode:SetContextThink( DoUniqueString( "LookAtDonatePaymentIsComplete" ), function ()
        local times = 0
        local url = GameRules.Definitions.LogicUrls['donate']
        local state = 0;
        
        HttpUtils:SendHTTPPost(url, { key = key }, function(t)
            CustomGameEventManager:Send_ServerToPlayer( player, "donate_order_complete", {} )
            state = 2
        end, function(t)
            state = 1
        end);
        
        
        if state == 0 then
            return 1
        end
        
        if state == 1 then
            times = times + 1
            return 0.1
        end
        
        if state == 2 then
            return nil
        end
        
	end, 1)
end


function EconManager:HandleDonateOrder(keys)

    DeepPrintTable(keys)

    local price = tonumber(keys.price) or 1.00
	if price <= 0.01 then return end
    
	local pay_method = keys.method
	if pay_method ~= "alipay" and pay_method ~= "wechatpay" then return end
    
	local url = ""
	local steamid = PlayerResource:GetSteamAccountID(keys.PlayerID)
    print('steamd id '.. steamid)
	CustomNetTables:SetTableValue( "econ_data", "donate_order_"..steamid, nil )

    local donateUrl = GameRules.Definitions.LogicUrls['donate']
    
    if not donateUrl then
        return;
    end
    
    
    -- local tryGetCode = function()
        
    -- end
    
    local errno, rspTable = HttpUtils:SendHTTPPostSync(donateUrl, {
            steamid = steamid,
			pay_method = pay_method,
			price = string.format("%.2f", price)
        });
    
    print("ret " .. errno)
	
	-- retry( 6, function ()
		-- local iStatusCode, szBody = send( "/donate/prepay", {
			-- steamid = steamid,
			-- pay_method = pay_method,
			-- game = Game,
			-- price = string.format("%.2f", price)
		-- })
		-- if iStatusCode == 200 then
			-- local body = jsonDecode(szBody)
			-- if body ~= nil and body["result"] ~= nil then
				-- url = body["result"]
				-- LookAtDonatePaymentIsComplete( PlayerResource:GetPlayer( keys.PlayerID ), body["key"])
			-- end
			-- return true
		-- end
		-- Sleep(0.5)
	-- end)

	if url ~= "" then
		CustomNetTables:SetTableValue( "econ_data", "donate_order_"..steamid, {url=url} )
	end
    
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "create_donate_order_rsp", {url="http://www.baidu.com"} )
    
end

if GameRules.EconManager == nil then GameRules.EconManager = EconManager() end