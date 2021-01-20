
if EconManager == nil then EconManager = class({}) end

function EconManager:OnPlayerQueryShopItemsReq(keys)
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