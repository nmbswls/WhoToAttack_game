GameRules.BASE_SERVER_URL = "http://yueyutech.com:10011"

if Server == nil then Server = class({}) end


function Server:constructor()
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(Server, "OnGameStateChanged"), nil)
    CustomGameEventManager:RegisterListener("OnQueryPlayerInfo", Dynamic_Wrap(Server, "OnQueryPlayerInfo"))
end


function Server:OnQueryPlayerInfo()
    local players = {}

    local steamid_playerid_map = {}

    for id = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayer(id) then
            local steamid = PlayerResource:GetSteamAccountID(id)
            steamid_playerid_map[steamid] = id
            table.insert(players, steamid)
        end
    end
	
    local player_json = JSON:encode(players)
    
	--on send info
	--HttpUtils:SendHTTPPost()
	
	-- local req = CreateHTTPRequestScriptVM("POST", GameRules.__NewServerUrl__ .. "/GetRating")
    -- req:SetHTTPRequestGetOrPostParameter('player_json', player_json)
    -- req:SetHTTPRequestGetOrPostParameter('mapname', GetMapName())
    -- req:Send(function(result)
        -- if result.StatusCode == 200 then
            -- local body = JSON:decode(result.Body)

            -- -- 记录数据
            -- GameRules.vDCTData = GameRules.vDCTData or {}
            -- for _, data in pairs(body) do
                -- if data['dct'] then
                    -- local id = steamid_playerid_map[data['steamid']]
                    -- GameRules.vDCTData[id] = data['dct']
                -- end
            -- end

            -- CustomNetTables:SetTableValue("player_rating_data", "rating_data", stringTable(body));
            -- CustomGameEventManager:Send_ServerToAllClients('player_rating_data_arrived', {})
        -- end
    -- end)
end

function Server:OnPostRetInfo()


end

function Server:OnGameStateChanged(something, debug)
    local newState = GameRules:State_Get()
    if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        Server:OnQueryPlayerRating()
    end
    if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        
    end

    if newState >= DOTA_GAMERULES_STATE_POST_GAME and ( IsInToolsMode() )then
        Server:OnPostRetInfo()
    end
end

if GameRules.Server == nil then GameRules.Server = Server() end
