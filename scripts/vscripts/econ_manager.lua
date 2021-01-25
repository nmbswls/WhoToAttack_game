
if not IsServer() then return end

if EconManager == nil then EconManager = class({}) end

print('require econ manager')
function EconManager:constructor()
	
	
	CustomGameEventManager:RegisterListener("player_query_shop_items_req",function(_, keys)
		self:OnPlayerQueryShopItemsReq(keys)
	end)
	
	CustomGameEventManager:RegisterListener("player_query_econ_data_req",function(_, keys)
		self:OnPlayerQueryEconData(keys)
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
	print('OnPlayerQueryEconInfo')
	
	local playerid = keys.PlayerID
	local player = PlayerResource:GetPlayer(playerid)
	if not player then return end
	local hero = player:GetAssignedHero()
	if not hero then return end
	local data = {
		[1] = "t10",
		[2] = "t11",
	}
	
	CustomNetTables:SetTableValue('econ_data', 'collection_data_' .. playerid, data)
	CustomNetTables:SetTableValue('econ_data', 'coin_data_' .. playerid, {amount = 10})
	
	return;
	local steamid = PlayerResource:GetSteamAccountID(playerid)
	local req = CreateHTTPRequestScriptVM("POST","http://yueyutech.com:10010/GetCollection")
	req:SetHTTPRequestGetOrPostParameter("steamid",tostring(steamid))
	req:Send(function(result)
		if result.StatusCode == 200 then
			local data = JSON:decode(result.Body)
			for name, equip in pairs(data) do
				if name ~= 'steamid' then
					if equip == true then
						if Econ["OnEquip_" .. name .. "_server"] then
							Econ["OnEquip_" .. name .. "_server"](hero)
						end
					else
						if Econ["OnRemove_" .. name .. "_server"] then
							Econ["OnRemove_" .. name .. "_server"](hero)
						end
					end
				end
			end
			CustomNetTables:SetTableValue('econ_data', 'collection_data_' .. playerid, data)
		end
	end)
end

if GameRules.EconManager == nil then GameRules.EconManager = EconManager() end