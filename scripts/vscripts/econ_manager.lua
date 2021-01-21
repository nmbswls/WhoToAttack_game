
if not IsServer() then return end

if EconManager == nil then EconManager = class({}) end

print('require econ manager')
function EconManager:constructor()
	
	
	CustomGameEventManager:RegisterListener("player_query_shop_items_req",function(_, keys)
		self:OnPlayerQueryShopItemsReq(keys)
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

if GameRules.EconManager == nil then GameRules.EconManager = EconManager() end