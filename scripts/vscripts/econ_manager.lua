
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

EconFuncs.OnEquip_1001_server = function(hero)
    print('equip t10')
    GameRules:GetGameModeEntity().WhoToAttack:ChangeBaseModel(hero, "models/heroes/techies/fx_techies_remotebomb.vmdl")
    GameRules:GetGameModeEntity().WhoToAttack:ChangeThrowEffect(hero, "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf")
	-- WhoToAttack:ChangeBaseModel(hero, "")
end

EconFuncs.OnRemove_1001_server = function(hero)
    print('unequip t10')
    GameRules:GetGameModeEntity().WhoToAttack:ChangeBaseModel(hero, nil)
    GameRules:GetGameModeEntity().WhoToAttack:ChangeThrowEffect(hero, nil)
	-- WhoToAttack:ChangeBaseModel(hero, "")
end

EconFuncs.OnEquip_1002_server = function(hero)
    print('equip t13')
    GameRules:GetGameModeEntity().WhoToAttack:ChangeThrowEffect(hero, nil)
    
	-- WhoToAttack:ChangeBaseModel(hero, "")
end

EconFuncs.OnRemove_1002_server = function(hero)
    print('unequip t13')
	-- WhoToAttack:ChangeBaseModel(hero, "")
    GameRules:GetGameModeEntity().WhoToAttack:ChangeThrowEffect(hero, nil)
end

EconFuncs.OnEquip_1002_server = function(hero)
    print('equip t15')
	-- WhoToAttack:ChangeBaseModel(hero, "")
end

EconFuncs.OnRemove_1002_server = function(hero)
    print('unequip t15')
	-- WhoToAttack:ChangeBaseModel(hero, "")
end

-- EconItemConfig = {
    -- [1001] = {name = "t10"},
    -- [1002] = {name = "t13"},
    -- [1003] = {name = "t15"},
    -- [1004] = {name = "t16"},
    -- [1005] = {name = "t17"},
    -- [1006] = {name = "t18"},
    -- [2001] = {name = "b01"},
    -- [2002] = {name = "b02"},
    -- [2003] = {name = "b03"},
    -- [2004] = {name = "b04"},
-- }


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
    
    local shopListUrl = GameRules.Definitions.LogicUrls['shopList']
    
    HttpUtils:SendHttpGet(shopListUrl, {}, function(obj)
        print('get shop list success')
        DeepPrintTable(obj)
        if obj.data and obj.data.list then
            self.vEconItems = {}
            for _,info in pairs(obj.data.list) do
                self.vEconItems[tonumber(info.prop_name)] = {
                    id = tonumber(info.prop_name),
                    slot = info.prop_type,
                    cost=info.price,
                    discount = 0}
            end
            DeepPrintTable(self.vEconItems)
            CustomNetTables:SetTableValue('econ_data', 'shop_items', self.vEconItems)
        end
    end, function(t)
        print('get shop list fail')
        print(t)
    end);
    
    CustomNetTables:SetTableValue('econ_data', 'shop_items', self.vEconItems)
end

function EconManager:UpdateEconData(playerid, econ_info)
    
	local coin = econ_info.coin;

	self.playerCollection[playerid] = {}
	self.playerEconInfo[playerid] = {coin = coin}
    
    if econ_info.decoration_info then
        for _, info in pairs(econ_info.decoration_info) do
            table.insert(self.playerCollection[playerid],info.decoration.decoration_id)
        end
    end
    
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
    
end

function EconManager:OnPlayerQueryEconData(keys)
	
	local playerid = keys.PlayerID
	local player = PlayerResource:GetPlayer(playerid)
	if not player then return end
	
    local steamid = PlayerResource:GetSteamAccountID(playerid)
    local invUrl = GameRules.Definitions.LogicUrls['inventory']
    HttpUtils:SendHttpGet(invUrl, {steam_id = tostring(steamid)}, function(obj)
        self:UpdateEconData(playerid, obj.data.client_econ_info)
    end, function(t)
        print('OnPlayerQueryEconData fail')
    end);

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
    
	local oldEquipId = equips[slot];
	print('OnPlayer try Equip ' .. tostring(oldEquipId) .. " " .. tostring(toEuipId))
	if oldEquipId == toEuipId then
		print("tuo zhuangbei ");
		--相同表示脱装备
		equips[slot] = nil;
		
	else
	
		equips[slot] = toEuipId;
		
		if toEuipId ~= nil then
			if EconFuncs["OnEquip_" .. tostring(toEuipInfo.id) .. "_server"] then
				EconFuncs["OnEquip_" .. tostring(toEuipInfo.id) .. "_server"](hero)
			end
		end
	end
	
	if oldEquipId ~= nil and self.vEconItems[oldEquipId] ~= nil then
		local oldEquipData = self.vEconItems[oldEquipId]
		if EconFuncs["OnRemove_" .. tostring(oldEquipData.id) .. "_server"]  then
			EconFuncs["OnRemove_" .. tostring(oldEquipData.id) .. "_server"](hero)
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

	local itemId = tonumber(keys.itemId)
    if not itemId then
        print('OnPlayerPreview itemId not valid.')
        return
    end
    
	local equips = self:GetPlayerEquipInfo(playerid);
    if not equips then
        print("get equip info fail.");
        return
    end
    
    if not self.vEconItems[itemId]then
        print("get item info fail.");
        return
    end
    
    local previewInfo = self.vEconItems[itemId]
    
    local nowPreviewingItemId = self.preview_item_id;
    
    -- if nowPreviewingItemId == itemId then
        -- return;
    -- end
    
    print('OnPlayerPreview ' .. itemId)
    if not previewInfo then
        print('previewInfo not found.')
        return
    end
    
    
    local slot = previewInfo.slot;  -- read config
    
    if not slot then
        print('toEuipInfo slot info invalid.')
        return
    end
    local oldEuip = equips[slot];
    if oldEuip and self.vEconItems[oldEuip] then
        if EconFuncs["OnRemove_" .. tostring(self.vEconItems[oldEuip].id) .. "_server"] then
            EconFuncs["OnRemove_" .. tostring(self.vEconItems[oldEuip].id) .. "_server"](hero)
        end
    end
       
    if nowPreviewingItemId and self.vEconItems[nowPreviewingItemId] then
        if EconFuncs["OnRemove_" .. tostring(self.vEconItems[nowPreviewingItemId].id) .. "_server"] then
            EconFuncs["OnRemove_" .. tostring(self.vEconItems[nowPreviewingItemId].id) .. "_server"](hero)
        end
    end
        
	equips[slot] = nil;
	CustomNetTables:SetTableValue('econ_data', 'equip_info_' .. playerid, equips)
    
    --handle already equip
    
	if EconFuncs["OnEquip_" .. tostring(previewInfo.id) .. "_server"] then
		EconFuncs["OnEquip_" .. tostring(previewInfo.id) .. "_server"](hero)
	end

	Timers:CreateTimer(10, function()
        if self.preview_item_id ~= itemId then
            return
        end
        if EconFuncs["OnRemove_" .. tostring(previewInfo.id) .. "_server"] then
            EconFuncs["OnRemove_" .. tostring(previewInfo.id) .. "_server"](hero)
        end
        self.preview_item_id = nil;
	end)
    
    self.preview_item_id = itemId;
end


function EconManager:OnPlayerPurchase(keys)
	local playerid = keys.PlayerID
    local player = PlayerResource:GetPlayer(playerid)
	local item = keys.ItemName
	local steamid = PlayerResource:GetSteamAccountID(playerid)
	print('purchase ' .. item)
	
	
    local purchaseUrl = GameRules.Definitions.LogicUrls['purchase']
    
	HttpUtils:SendHTTPPost(purchaseUrl, {steam_id = tostring(steamid), prop_name = tostring(1)}, function(obj)
		-- if result.StatusCode == 200 then
			-- --flush all collection_data_
			-- --update point
		-- end
		--obj coin
        
        self:OnPlayerQueryEconData({PlayerID = playerid});
        -- table.insert(self.playerCollection[playerid], item)
        CustomGameEventManager:Send_ServerToPlayer(player, 'player_purchase_rsp', {ret = 1})
	end, function(errno, errmsg)
        print('purchase fail errno:' .. errno .. " " .. tostring(errmsg))
        CustomGameEventManager:Send_ServerToPlayer(player, 'player_purchase_rsp', {ret = 0})
        msg.bottom("购买失败.", playerid, 3)
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
	local coin_1 = econ_info.coin;
	local coin_2 = coin_1;
	self.playerSlotInfo[pid] = {
		[1] = nil,
		[2] = nil,
		[3] = nil,
	}
	self.playerCollection[pid] = {}
	self.playerEconInfo[pid] = {coin = coin_1}
    
    if econ_info.client_decorations_info then
        for _, info in pairs(econ_info.client_decorations_info) do
            if info.use_status then
                local targetSlot = self.vEconItems[tonumber(info.decoration.decoration_id)].slot;
                self.playerSlotInfo[pid][targetSlot] = info.decoration.decoration_id
            end
            table.insert(self.playerCollection[pid],info.decoration.decoration_id)
        end
    end
	
	
	-- DeepPrintTable(self.playerCollection[pid])
	-- DeepPrintTable(self.playerSlotInfo[pid])
	-- DeepPrintTable(self.playerEconInfo[pid])
	if self.playerCollection[pid] then
		CustomNetTables:SetTableValue('econ_data', 'collection_data_' .. pid, self.playerCollection[pid])
	end
	
	if self.playerEconInfo[pid] then
		CustomNetTables:SetTableValue('econ_data', 'coin_data_' .. pid, {amount = self.playerEconInfo[pid].coin})
	end
    
    local equips = self:GetPlayerEquipInfo(pid);
    
    if equips then
        CustomNetTables:SetTableValue('econ_data', 'equip_info_' .. pid, equips)
    end
end

function LookAtDonatePaymentIsComplete( player, key )
	
    Co(function ()
        local times = 0
        local url = GameRules.Definitions.LogicUrls['checkComplete']
        while true do
            times = times + 1
            local errno, rspTable = HttpUtils:SendHTTPPostSync(url,{out_trade_no = key})
            if errno == 0 then
                if rspTable ~= nil and rspTable.data.trade_state == "SUCCESS" then
                    print("pay good");
                    local amount = rspTable.data.amount;
                    GameRules.EconManager:UpdateCurrency(player:GetPlayerID(),amount);
                    CustomGameEventManager:Send_ServerToPlayer( player, "donate_order_complete", {trade_no = key} )
                    break
                end
            end
            
            if times >= 400 then break end
            Sleep(1)
        end
    end)
    
    -- player:SetContextThink( DoUniqueString( "LookAtDonatePaymentIsComplete" ), function ()
        -- print("nmb LookAtDonatePaymentIsComplete")
		
		
	-- end, 5)
end


function EconManager:HandleDonateOrder(keys)

    DeepPrintTable(keys)

    local price = tonumber(keys.price) or 100
	if price <= 1 then return end
    
	local pay_method = keys.method
	if pay_method ~= "alipay" and pay_method ~= "wechatpay" then return end
    
	local url = ""
	local steamid = PlayerResource:GetSteamAccountID(keys.PlayerID)
    print('steamd id '.. tostring(steamid))
	CustomNetTables:SetTableValue( "econ_data", "donate_order_"..steamid, nil )

    local donateUrl = GameRules.Definitions.LogicUrls['donate']
    
    if not donateUrl then
        return;
    end
    
    
    -- local tryGetCode = function()
        
    -- end
    -- tonumber(price)
    local errno, rspTable = HttpUtils:SendHTTPPostSync(donateUrl, {
            steam_id = tostring(steamid),
			pay_method = pay_method,
            donate_type = 2,
			donate_amt = price,
        });
    
    print("ret " .. errno)
    DeepPrintTable(rspTable);
    local key = rspTable.data.out_trade_no;
    url = rspTable.data.code_url;
    
	LookAtDonatePaymentIsComplete( PlayerResource:GetPlayer( keys.PlayerID ), key)
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
		CustomNetTables:SetTableValue( "econ_data", "donate_order_"..steamid, {img_url = url} )
	end
    print("nmbnmc nmc nmc");
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "create_donate_order_rsp", {img_url=url} )
    
end

function EconManager:UpdateCurrency(playerId, amount_info)
    print('UpdateCurrency for' .. tostring(playerId));
    DeepPrintTable(amount_info)
end

if GameRules.EconManager == nil then GameRules.EconManager = EconManager() end