--全局变量
--start_time           开始时间
--team2playerid        保存队伍到玩家id的映射
--playerid2team        保存玩家id到队伍的映射
--heromap              保存英雄id到实体的映射
--playerid2hero        保存玩家到英雄实体的映射
--teamid2hero          保存队伍到英雄实体的映射

--playerid2steamid     保存playerid到steamid映射
--steamid2playerid     
--steamid2name
--userid2player        映射为玩家实体idx 不是从0开始的id
--connect_state        全员连接状态 键为playerid
--isConnected          保存连接状态


--配置
--CHESS_POOL_SIZE      基本卡池大小
--chess_list_by_mana   不同等级的棋子列表
--chess_ability_list   单位技能映射表 可多个
--chess_2_mana         各棋子消耗映射

--信息
--stage                信息 准备0 预备1 战斗2
--stat_info            玩家状态信息
--battle_round         战斗回合
--battle_start_time    战斗回合开始时间
--dead_chess_list      各战场墓地

--stage_start_time     state 开始时间
--game_start_time      全局游戏开始时间
--last_tick            上次tick时间


--is_game_ended        结束游戏标记位
--prepare_timer        准备阶段计时器
--battle_timer         战斗阶段计时器
--game_status          游戏状态 1 准备 2 战斗
--start_ai             ai是否开启

--damage_stat          伤害统计
--to_be_destory_list   战斗开始后临时创建的单位集合 key为队伍 val为列表

--battle_state         战场结束标记位集合
--client_key           保存客户端认证 开局时随机


--单位属性
--is_battle_completed  战斗是否结束
--is_in_battle         是否进战
--in_battle_id         在哪个战场  at_team_id
--alreadywon           是否已胜利
--team_id              所属队伍
--attack_target        所选的攻击对象

--英雄属性

--打怪 

require 'definitions'
require 'UnitAi'
require 'timers'


if WhoToAttack == nil then
	WhoToAttack = class({})
end


function Precache( context )
    print("Precache...")
    -- local precache_list = require("precache")
	-- for _, precache_item in pairs(precache_list) do
		-- --预载precache.lua里的资源
		-- if string.find(precache_item, ".vpcf") then
			-- -- print('[precache]'..precache_item)
			-- PrecacheResource( "particle",  precache_item, context)
		-- end
		-- if string.find(precache_item, ".vmdl") then 	
			-- -- print('[precache]'..precache_item)
			-- PrecacheResource( "model",  precache_item, context)
		-- end
		-- if string.find(precache_item, ".vsndevts") then
			-- -- print('[precache]'..precache_item)
			-- PrecacheResource( "soundfile",  precache_item, context)
		-- end
		-- if string.find(precache_item, ".v") == false then
			-- -- print('[precache]'..precache_item)
			-- PrecacheResource( "particle_folder",  precache_item, context)
		-- end
    -- end
    -- --预载入
    -- local chess_mana_1 = {'chess_cm','chess_tusk','chess_axe','chess_eh','chess_clock','chess_ss','chess_bh','chess_dr','chess_tk','chess_am','chess_tiny','chess_mars','chess_ww','chess_wd','chess_dw','chess_ember','chess_storm','chess_earth','chess_io'}
    -- for k,v in pairs(chess_mana_1) do
    	-- if v ~= nil then
    		-- PrecacheUnitByNameSync(v, context)
    	-- end
    -- end
    print("Precache OK")
end

--入口函数
function WhoToAttack:StartGame()


    self.stage_start_time = GameRules:GetGameTime()
    self.game_start_time = GameRules:GetGameTime()

       for i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
        CustomGameEventManager:Send_ServerToTeam(i,"start_game",{
            key = GetClientToken(i),
        })
    end

    --5秒后开始游戏
    Timers:CreateTimer(5,function()
        
        print('GAME START!')
        --初始化棋子库
        --InitChessPool(GameRules:GetGameModeEntity().playing_player_count)
        self.start_time = GameRules:GetGameTime()
        self:SetState(1)
        --StartAPrepareRound()
    end)
    
    
    
    
end

function WhoToAttack:OnThink()
    if IsClient() or self.is_game_ended then return nil end
    
    if self.stage == nil or self.stage == 0 then
        return 1
    end
    
    local stageElapsed = GameRules:GetGameTime() - self.stage_start_time
    local stageCountdown = math.floor(GameRules.Definitions.StageTime[self.stage] - stageElapsed)
    local isNext = false;
    
    if(self.stage == 1) then
        -- for i,v in pairs (GameRules:GetGameModeEntity().heromap) do
            -- --清理开始战斗后失效的技能
            -- OnHeroInBattle(v)
        -- end
    end
    
	print("count down " .. stageCountdown)
    if(self.stage == 3) then
    
        --20秒之后才开始计算胜负
        if stageElapsed > 20 then
        
            for team = 6,13 do
                self:CheckWinLoseForTeam(team)
            end
            
            if GetBattleCount() == 0 and stageElapsed >= 3 then
                isNext = true;
            else 
                if stageCountdown == 30 then
                    --lock all touzhi
                    for i,v in pairs(self.heromap) do
                        if IsUnitExist(v) == true then
                            --LockTouzhi(v:GetTeam())
                        end
                    end
                end
            end
            
        end
        
        if stageCountdown <= 0 then
            for team = 6,13 do
                if not TeamId2Hero(team).is_battle_completed then
                    DrawARound(team)
                    TeamId2Hero(team).is_battle_completed = true
                end
            end
        end
        
    end
    
    
    
    if(stageCountdown > 0 and stageCountdown < 4 and self.last_tick ~= stageCountdown) then
        self.last_tick = stageCountdown
    end
    
    if(stageCountdown <= 0 or isNext) then
        if(self.stage > GameRules.Definitions.StateCount) then 
            self.battle_round = self.battle_round + 1
            self:SetState(1)
        else
            self:SetState(self.stage + 1)
        end
    end
	
    if(GameRules:IsGamePaused()) then
        return 1
    end
	
    local playerInfoTable = {}
    --for playerId, playerInfo in pairs(GameRules.DW.PlayerList) do
        --拼装playerinfo
    
    --end
    
    --战斗中 检测是否战斗结束
    
	
    --Paixu分数
    return 1
    
end

function WhoToAttack:SetState(newStage)
    self.stage = newStage;
    self:OnStageChanged();
    self.stage_start_time = GameRules:GetGameTime()
end

function WhoToAttack:OnStageChanged()
    
    print("new state " .. self.stage .. " round " .. self.battle_round)
    
    if(self.stage == 1) then
        self:StartAPrepareRound()
    end
    
    if(self.stage == 2) then
        
    end

    if(self.stage == 3) then
        self:StartABattleRound()
    end
    
    if(self.stage == 4) then
        --未投掷也要清理
        for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
            self:ClearBattle(team_i)
        end
    end
    
	for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
		CustomGameEventManager:Send_ServerToTeam(team_i, "battle_info",{
			key = GetClientKey(team_i),
			type = stage,
			round = self.battle_round,
		})
	end
end

function WhoToAttack:StartAPrepareRound()
	if self.is_game_ended == true then
		return
	end
	--每回合特殊处理
	--预加载
	if self.battle_round < 5 then
		for k,v in pairs(GameRules:GetGameModeEntity().chess_list_by_mana[GameRules:GetGameModeEntity().battle_round+1]) do
			--瞬间同时加载卡顿
			PrecacheAUnit(k,v)
		end
	end
	
	--选择开门玩家
	
	--GameRules:GetGameModeEntity().opened_ply;
	--to do RandomInt
	
	--通知客户端显示开门玩家
	-- ShowOpenDoor({
		-- t = 'round_pvp',
		-- text = GameRules:GetGameModeEntity().battle_round
	-- })

    --给予每回合成长
	-- Timers:CreateTimer(0.3,function()
		-- for i,v in pairs(GameRules:GetGameModeEntity().heromap) do
			-- if IsUnitExist(v) == true then
				-- AddPickAndRemoveAbility(v)
				-- local level = v:GetLevel()
				-- AddAbilityAndSetLevel(v,'summon_hero',level)

				-- v.is_battle_completed = nil
				
				-- --基于回合成长经验
				-- if GameRules:GetGameModeEntity().battle_round ~= 1 then			
					-- v:AddExperience(1,0,false,false)					
				-- end

				-- GameRules:GetGameModeEntity().damage_stat[v:GetTeam()] = {}
			-- end
		-- end
		
	-- end)
	-- --抽卡
	-- Timers:CreateTimer(0.5,function()
		-- for i,v in pairs(GameRules:GetGameModeEntity().heromap) do
			-- if IsUnitExist(v) == true then
				-- --自动抽卡一次
				-- --Draw5ChessAndShow(v:GetTeam(), false)
			-- end
		-- end
	-- end)
	
	-- Timers:CreateTimer(1,function()
	
		-- for i,v in pairs(GameRules:GetGameModeEntity().heromap) do
			-- if IsUnitExist(v) == true then
				-- --给蓝
				-- local mana = 0;
				-- AddMana(v, mana)
				-- AddTotalMoneyStat(v:GetPlayerID(), mana)
			-- end
		-- end
	-- end)
	
	
end

function WhoToAttack:StartABattleRound()
    if self.is_game_ended == true then
        return
    end
    
    PostPlayerInfo()
    
    --移除每个场地中的隐身modifier
    for i = DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
        ShowPrepare(i)
        
        --test code
        self:SpawnNeutral(i);
    end
    
    GameRules:SetTimeOfDay(0.3)
    self.game_status = 2 --game_status 2 zhandou zhong
    self.battle_timer = 50

    --ResetAllDeadChessList()
    
    -- GameRules:GetGameModeEntity().battle_count = 0
    InitBattleTable()
end


function WhoToAttack:SpawnNeutral(team)
    
    local pos = GameRules.Definitions.TeamCenterPos[team]

    for i = 1, 3 do
        self:CreateUnit(3, pos, "test_monster", 1)
    end
    
end

function WhoToAttack:SendRoundTimeInfo()

    -- local center_index = ''..Entities:FindByName(nil,"center0"):entindex()..','..Entities:FindByName(nil,"center1"):entindex()..','..Entities:FindByName(nil,"center2"):entindex()..','..Entities:FindByName(nil,"center3"):entindex()..','..Entities:FindByName(nil,"center4"):entindex()..','..Entities:FindByName(nil,"center5"):entindex()..','..Entities:FindByName(nil,"center6"):entindex()..','..Entities:FindByName(nil,"center7"):entindex()
    -- --发送当前游戏时间给客户端
    -- for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
        -- CustomGameEventManager:Send_ServerToTeam(team_i,"show_time",{
            -- key = GetClientKey(team_i),
            -- timer_round = GameRules:GetGameModeEntity().battle_timer,
            -- round_status = "battle",
            -- total_time = math.floor(GameRules:GetGameTime() - GameRules:GetGameModeEntity().start_time),
            -- center_index = center_index
        -- })
    -- end

end

function StatClassCount(team_id)
	--通用技能
	-- local combo_chess_table_self = {}
	-- local combo_count_table_self = {}

	-- --第一次循环：棋子分组
	-- for w,vw in pairs(GameRules:GetGameModeEntity().to_be_destory_list[team_id]) do
		-- if vw.team_id == team_id then --我的棋子
			-- for _,k in pairs(GameRules:GetGameModeEntity().class_type) do
				-- if combo_chess_table_self[k] == nil then
					-- combo_chess_table_self[k] = {}
				-- end
				-- if vw:FindAbilityByName(k) ~= nil then
					-- table.insert(combo_chess_table_self[k],vw)
				-- end
			-- end
		-- end
	-- end

	-- --第二次循环：计数
	-- for k,vk in pairs(combo_chess_table_self) do
		-- --统计不同的种类数
		-- local diff_count = 0
		-- local diff_string = ''
		-- for _,chess in pairs(combo_chess_table_self[k]) do
			-- --去掉等级变量
			-- local find_name = chess:GetUnitName()
			-- if string.find(find_name,'11') ~= nil then
				-- find_name = string.sub(find_name,1,-3)
			-- end
			-- if string.find(find_name,'1') ~= nil then
				-- find_name = string.sub(find_name,1,-2)
			-- end
			-- --搜索是否重复了
			-- if string.find(diff_string,find_name) == nil then
				-- diff_count = diff_count + 1
				-- diff_string = diff_string..'-'..find_name
			-- end
		-- end
		-- if diff_count > 0 then
			-- combo_count_table_self[k] = diff_count
		-- end
	-- end
	-- ShowCombo({
		-- team_id = team_id,
		-- combo_table = combo_count_table_self,
	-- })

	-- --统计所有buff
	-- for u,v in pairs(GameRules:GetGameModeEntity().combo_ability_type) do

	-- end
end


function DrawARound(team)

	local hero = TeamId2Hero(team)
	if hero == nil or hero:IsNull() == true or hero:IsAlive() == false then
		return
	end
	
	-- GameRules:GetGameModeEntity().battle_count = GameRules:GetGameModeEntity().battle_count - 1
	SetBattleTable(team,false)

	--通知UI显示胜负
	-- for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
		-- CustomGameEventManager:Send_ServerToTeam(team_i,"show_round_win_lose",{
			-- key = GetClientKey(team_i),
			-- player_id = hero:GetPlayerID(),
			-- winlose = "draw",
		-- })
	-- end
end

function WhoToAttack:CheckWinLoseForTeam(team)
    if TeamId2Hero(team).is_battle_completed then
        return
    end
    
    --统计活着的敌我单位数量
    local myUnit, enemyUnit = GetUnitCountInBattleGround(team)

    if myUnit == 0 and enemyUnit == 0 then
        DrawARound(team)
        TeamId2Hero(team).is_battle_completed = true
        return
    end

    if myUnit > 0 and enemyUnit == 0 then
    
        WinARound(team,mychess,my_last_chess)
        TeamId2Hero(team).is_battle_completed = true
        return
    elseif myUnit == 0 then
        
        LoseARound(team,enemychess_new)
        TeamId2Hero(team).is_battle_completed = true
        return
    else
        return 1
    end
end

function WhoToAttack:CreateUnit(team, pos, unitName, amount)
    local hero = TeamId2Hero(team)
    for n =1, amount do
        local newyUnit = CreateUnitByName(unitName, XY2Vector(vi.x,vi.y,team), true, hero, hero, team)
        newyUnit:SetAbsOrigin(pos);
        FindClearSpaceForUnit(newyUnit, pos, true)
        newyUnit.team = team
        self:InitUnit(team,newyUnit)
    end
end

--初始化新刷新的棋子
function WhoToAttack:InitUnit(team, unit)
    if unit == nil or not unit:IsNull() then
        return
    end
    unit.is_in_battle = false
	unit.team_id = team
    unit.in_battle_id = 0
    local unitName = unit:GetUnitName();
    
    if table.contains(GameRules.Definitions.ChessAbilityList, unitName) then
        local a = GameRules.Definitions.ChessAbilityList[unitName]
        local a_level = 1
        if unit:FindAbilityByName(a) == nil then
            AddAbilityAndSetLevel(unit,a,a_level)
        else
            unit:FindAbilityByName(a):SetLevel(a_level)
        end
    end
    
    if table.contains(GameRules.Definitions.UnitNames, unitName) then
        --table.insert(self.to_be_destory_list, unit)
        CreateTimer(function()
            unit:SetContextThink("OnUnitThink", function() return UnitAI:OnUnitThink(unit) end, 1)
        end, 0.5)
    end
    
end

function WhoToAttack:ChangeBattleField(target, pos)
    
    if pos ~= nil then
        --find closet
    end

	local minDist = 0
	local minIdx = -1
	--for k, vinfo in pairs(GameRules:GetGameModeEntity().base_pos) do
		--if 
	--end
    local targetBattle = 6
    target.is_in_battle = true
	target.in_battle_id = targetBattle;
    
    table.insert(self.to_be_destory_list[targetBattle], target)
	--GameRules:GetGameModeEntity().battle.insert
	--更新羁绊
	StatClassCount(minIdx)
end



function WhoToAttack:ClearBattle(teamid)
	for _,v in pairs(self.to_be_destory_list[teamid]) do
		if v ~= nil and v:IsNull() == false then
			--AddAbilityAndSetLevel(v,'no_selectable')
			v:Destroy()
		end
	end
	GameRules:GetGameModeEntity().to_be_destory_list[teamid] = {}
end


--业务工具方法

function GetUnitCountInBattleGround(team)
	local myunit_count = 0
	local enemyunit_count = 0
	
	local team_objs = {}
	
	--返回每个阵营的单位数量
	if GameRules:GetGameModeEntity().to_be_destory_list[team] ~= nil then
		for p,q in pairs(GameRules:GetGameModeEntity().to_be_destory_list[team]) do
			if q:GetUnitName() ~= 'fissure' then
				if q.team_id == team then
					mychess_count = mychess_count + 1
				else
					enemychess_count = enemychess_count + 1
				end
			end
		end
	end

	return myunit_count,enemyunit_count
end


function ResetAllDeadChessList()
	GameRules:GetGameModeEntity().dead_chess_list = {
		[6] = {},
		[7] = {},
		[8] = {},
		[9] = {},
		[10] = {},
		[11] = {},
		[12] = {},
		[13] = {},
	}
end

function ShowPrepare(team)
	if GameRules:GetGameModeEntity().to_be_destory_list[team] ~= nil then
		for _,ent in pairs(GameRules:GetGameModeEntity().to_be_destory_list[team]) do
			RemoveAbilityAndModifier(ent,'invisible_to_enemy')
		end
	end
end

function InitBattleHero(hero)
	--CancelPickChess(hero)
	--hero:FindAbilityByName('pick_chess'):SetActivated(false)
	--hero:FindAbilityByName('recall_chess'):SetActivated(false)
end


function AddTotalMoneyStat(player_id, money)
	if IsUnitExist(PlayerId2Hero(player_id)) == false then
		return
	end
	local total_money1 = GetStat(player_id,'total_money')
	AddStat(player_id,'total_money',money)
	local total_money2 = GetStat(player_id,'total_money')
	-- prt('total_money'..player_id..': '..total_money1..'-->'..total_money2)
end

function TeamId2Hero(id)
	if id == nil then
		return nil
	else
		return GameRules:GetGameModeEntity().teamid2hero[id]
	end
end

function RemoveFromToBeDestroyList(u)
	for p,q in pairs(GameRules:GetGameModeEntity().to_be_destory_list[(u.at_team_id or u.team_id)]) do
		if u ~= nil and u:IsNull() == false and q ~= nil and q:IsNull() == false then
			if q:entindex() == u:entindex() then
				table.remove(GameRules:GetGameModeEntity().to_be_destory_list[(u.at_team_id or u.team_id)],p)
			end
		end
	end
end

function GetStat(id,prop)
	local hero =  PlayerId2Hero(id)
	if hero == nil or hero.steam_id == nil then
		return nil
	end
	return GameRules:GetGameModeEntity().stat_info[hero.steam_id][prop]
end
function SetStat(id,prop,v,need_update_ui)
	if id == nil then 
		return
	end
	local hero =  PlayerId2Hero(id)
	if hero == nil or hero.steam_id == nil then
		return
	end
	GameRules:GetGameModeEntity().stat_info[hero.steam_id][prop] = v
	if need_update_ui ~= false then
		UpdateStatUI()
	end
end
function AddStat(id,prop,amount)
	local hero =  PlayerId2Hero(id)
	if hero == nil or hero.steam_id == nil then
		return
	end
	if amount == nil then
		amount = 1
	end
	GameRules:GetGameModeEntity().stat_info[hero.steam_id][prop] = GameRules:GetGameModeEntity().stat_info[hero.steam_id][prop] + amount
	if prop == 'hero_damage' then
		PlayerResource:IncrementLastHits(id)
	end
	if prop == 'hero_damaged' then
		PlayerResource:IncrementDenies(id)
	end

	if prop == 'win_round' then
		PlayerResource:IncrementKills(id,1)
	end
	if prop == 'lose_round' then
		PlayerResource:IncrementDeaths(id,1)
	end
	if prop == 'draw_round' then
		PlayerResource:IncrementAssists(id,1)
	end

	UpdateStatUI()
end



function PostPlayerInfo()
	--快照
	SnapShotPlayers()
	UpdateStatUI()
end

function SnapShotPlayers()
	for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
		local hero = TeamId2Hero(team_i)
		if IsUnitExist(hero) == true and hero.steam_id ~= nil then
			local lineup_count = 0
			local lineup = ''
			for _,v in pairs(GameRules:GetGameModeEntity().mychess[team_i]) do
				if v ~= nil and v.chess ~= nil and lineup_count < hero:GetLevel() then 
					lineup = lineup..v.chess..','
					lineup_count = lineup_count + 1
				end
			end
			SetStat(hero:GetPlayerID(),'chess_lineup',lineup,false)


		end
	end
end

function InitCardPool()
	
	local chess_pool_times = GameRules:GetGameModeEntity().CHESS_POOL_SIZE or 6
	for cost,v in pairs(GameRules:GetGameModeEntity().chess_list_by_mana) do
		for _,chess in pairs(v) do
			local chess_count = 5
			for i=1,chess_count do
				AddAChessToChessPool(chess)
			end
		end
	end
end

function AddAChessToChessPool(chess)

	local maxcount = 3

	for count = 1,maxcount do
		if GameRules:GetGameModeEntity().chess_2_mana[chess] ~= nil and FindValueInTable(special_piece,chess) == false then
			local cost = GameRules:GetGameModeEntity().chess_2_mana[chess]
			table.insert(GameRules:GetGameModeEntity().chess_pool[cost],chess)
		end
	end
end


function UpdateStatUI()
	CustomNetTables:SetTableValue( "player_info_table", "player_info", 
		{ data = GameRules:GetGameModeEntity().stat_info, 
		  hehe = RandomInt(1,100000)})
end

function SetBattleTable(team_id, value)
	GameRules:GetGameModeEntity().battle_state[team_id] = value
end

function GetBattleCount()
	local battle_count = 0
	for _,i in pairs(GameRules:GetGameModeEntity().battle_count) do
		if i == true then
			battle_count = battle_count + 1
		end
	end
	return battle_count
end




--通用方法
function PlayerId2Hero(id)
	return GameRules:GetGameModeEntity().playerid2hero[id]
end

function GetClientToken(team)
	return GameRules:GetGameModeEntity().client_key[team]
end


function IsUnitExist(u)
	if u ~= nil and u:IsNull() == false and u:IsAlive() == true and u.is_removing ~= true then
		return true
	else
		return false
	end
end

function PrecacheAUnit(delay,unitname)
	Timers:CreateTimer(delay,function()
		PrecacheUnitByNameAsync(unitname,function()
		end)
	end)
end

function AddAbilityAndSetLevel(u,a,l)
	if l == nil then
		l = 1
	end
	if u == nil or u:IsNull() == true then
		return
	end
	if u:FindAbilityByName(a) == nil then
		u:AddAbility(a)
		if u:FindAbilityByName(a) ~= nil then
			u:FindAbilityByName(a):SetLevel(l)
		end
	else
		u:FindAbilityByName(a):SetLevel(l)
	end
end

function RemoveAbilityAndModifier(u,a)
	if u == nil or u:IsNull() == true then
		return
	end
	if u:FindAbilityByName(a) ~= nil then
		u:RemoveAbility(a)
		u:RemoveModifierByName('modifier_'..a)
	end
end


function GetPlayingPlayerCount()
	if GameRules:GetGameModeEntity().playing_player_count > 0 then
		return GameRules:GetGameModeEntity().playing_player_count
	end
	
	local playing_player_count = 0
	local obing_player_count = 0
	for player_id,_ in pairs(GameRules:GetGameModeEntity().playerid2steamid) do
		if PlayerResource:GetTeam(player_id) >= 6 and PlayerResource:GetTeam(player_id) <= 13 then
			playing_player_count = playing_player_count + 1
		end
		if PlayerResource:GetTeam(player_id) == 1 then
			obing_player_count = obing_player_count + 1
		end
	end
	GameRules:GetGameModeEntity().playing_player_count = playing_player_count
	GameRules:GetGameModeEntity().obing_player_count = obing_player_count
	
	-- if GameRules:GetGameModeEntity().obing_player_count > 0 then
		-- combat('OB COUNT: '..GameRules:GetGameModeEntity().obing_player_count)
		-- CustomGameEventManager:Send_ServerToAllClients("show_ob_count",{
			-- count = GameRules:GetGameModeEntity().obing_player_count
		-- })
	-- end
	return GameRules:GetGameModeEntity().playing_player_count

end


function InitBattleTable()
	GameRules:GetGameModeEntity().battle_state = {
		[6] = false,
		[7] = false,
		[8] = false,
		[9] = false,
		[10] = false,
		[11] = false,
		[12] = false,
		[13] = false,
	}
end

function AddChess2DeadChessList(keys)
	local at_team_id = keys.at_team_id --必填
	local chess_base_name = keys.chess_base_name --必填
	if at_team_id == nil or chess_base_name == nil then
		return
	end
	local level = keys.level or 0
	if string.find(chess_base_name,'chess_') ~= nil then
		--level = GameRules:GetGameModeEntity().chess_2_mana[chess_base_name]
	end
	local items = keys.items or {}
	local index = table.maxn(GameRules:GetGameModeEntity().dead_chess_list[at_team_id]) + 1
	
	table.insert(GameRules:GetGameModeEntity().dead_chess_list[at_team_id],{
		index = index,
		chess_base_name = chess_base_name,
		items = items,
		level = level,
	})
end



function AddMana(unit, mana, show_number)
	if mana == nil or mana <= 0 then
		return
	end
	if show_number == nil then
		show_number = true
	end
	mana_result = mana
	unit:SetMana(mana_result)
end

--事件监听
function WhoToAttack:OnPlayerPickHero(keys)
	if not IsServer() then
		return
	end
		
	local player = EntIndexToHScript(keys.player)
	local hero = EntIndexToHScript(keys.heroindex)
	local children = hero:GetChildren()
	
	--移除饰品
	for k,child in pairs(children) do
	   if child:GetClassname() == "dota_item_wearable" then
		   child:RemoveSelf()
	   end
	end
	--移除物品
	for slot=0,9 do
		if hero:GetItemInSlot(slot)~= nil then
			hero:RemoveItem(hero:GetItemInSlot(slot))
		end
	end
	
	hero:SetHullRadius(1)
	hero:SetAbilityPoints(0)
	
	--移除占位符技能
	for i=1,16 do
		hero:RemoveAbility("empty"..i)
	end
	
	
	hero:SetMana(0)
	hero:SetStashEnabled(false)

	hero.team = hero:GetTeam()
	hero.team_id = hero:GetTeam()

	GameRules:GetGameModeEntity().team2playerid[hero:GetTeam()] = player:GetPlayerID()
	GameRules:GetGameModeEntity().playerid2team[player:GetPlayerID()] = hero:GetTeam()

	--将所有玩家的英雄存到一个数组
	local heroindex = keys.heroindex
	GameRules:GetGameModeEntity().heromap[heroindex] = EntIndexToHScript(heroindex)
	GameRules:GetGameModeEntity().playerid2hero[player:GetPlayerID()] = EntIndexToHScript(heroindex)
	GameRules:GetGameModeEntity().teamid2hero[hero:GetTeam()] = EntIndexToHScript(heroindex)
	
	local playercount = 0
	for i,vi in pairs(GameRules:GetGameModeEntity().heromap) do
		playercount = playercount +1
	end

	local all_playing_player_count = GetPlayingPlayerCount()
	--下发消息 
	--combat("PLAYER JOINED: "..playercount.."/"..GameRules:GetGameModeEntity().playing_player_count)
    
    print("player count " .. all_playing_player_count .. "   " .. playercount);
    
	if playercount == all_playing_player_count then
		--InitPlayerIDTable()

		Timers:CreateTimer(0.1,function()
			--开始
			self:StartGame()
		end)
	end 
	
end


function WhoToAttack:OnPlayerConnectFull(keys)
	-- prt('[OnPlayerConnectFull] PlayerID='..keys.PlayerID..',userid='..keys.userid..',index='..keys.index)

	GameRules:GetGameModeEntity().playerid2steamid[keys.PlayerID] = tostring(PlayerResource:GetSteamID(keys.PlayerID))
	GameRules:GetGameModeEntity().steamid2playerid[tostring(PlayerResource:GetSteamID(keys.PlayerID))] = keys.PlayerID
	GameRules:GetGameModeEntity().steamid2name[tostring(PlayerResource:GetSteamID(keys.PlayerID))] = tostring(PlayerResource:GetPlayerName(keys.PlayerID))
	GameRules:GetGameModeEntity().userid2player[keys.userid] = keys.index + 1

	GameRules:GetGameModeEntity().connect_state[keys.PlayerID] = true
	
	--???
	if GameRules:GetGameModeEntity().isConnected[keys.index + 1] == true then
		local hero = PlayerId2Hero(keys.PlayerID)
		if hero ~= nil then
			--重连 要重新推ui信息
			hero.isDisconnected = false
		end
	end
	GameRules:GetGameModeEntity().isConnected[keys.index+1] = true
    
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    player:SetSelectedHero("builder")
end

function WhoToAttack:OnPlayerDisconnect(keys)
	if not IsServer() then
		return
	end
	
	local hero = PlayerId2Hero(keys.PlayerID)
	if hero == nil then
		return
	end
	
	hero.isDisconnected = true
	GameRules:GetGameModeEntity().connect_state[keys.PlayerID] = false
	
	--用于与客户端同步离线信息
	CustomNetTables:SetTableValue( "dac_table", "disconnect", 
		{ 
			table = GameRules:GetGameModeEntity().connect_state,
		} 
	)
end

function WhoToAttack:OnEntityKilled(keys)
	local u = EntIndexToHScript(keys.entindex_killed)
	if u == nil then
		return
	end
	if u:IsHero() == true then
		return
	end
	if u:GetUnitName() == "invisible_unit" then
		return
	end
	
	if GameRules:GetGameModeEntity().game_status == 2 then
		--战斗阶段
		local xx = Vector2X(u:GetAbsOrigin(),u.at_team_id or u.team_id)
		local yy = Vector2Y(u:GetAbsOrigin(),u.at_team_id or u.team_id)
		--从目标战场中移除
		RemoveFromToBeDestroyList(u)
	end
	
	--杀人者
	if keys.entindex_attacker == nil then
		return
	end
	
	local attacker = EntIndexToHScript(keys.entindex_attacker)
	attacker = attacker.damage_owner or attacker

	--亡语
	--DeathRattle(u,attacker)

	--进坟场
	AddChess2DeadChessList({
		at_team_id = u.at_team_id or u.team_id,
		chess_base_name = GetUnitBaseName(u),
		items = GetAllItemsInUnits({[1] = u}),
		level = u:GetLevel(),
	})

	if attacker == nil then
		return
	end
	if string.find(attacker:GetUnitName(),'pve') ~= nil then
		return
	end
	if string.find(u:GetUnitName(),'pve') ~= nil then
		return
	end
	
	--attacker 获取teamid
	--给加钱
	
end

function WhoToAttack:OnNpcSpawned(data)
    local spawnedUnit = EntIndexToHScript(data.entindex)
    if(spawnedUnit == nil or spawnedUnit:IsNull()) then
        return
    end


    spawnedUnit:SetDeathXP(0)

    local owner = spawnedUnit:GetOwner()
    if(owner == nil or owner:IsNull()) then return end

    if(owner:GetTeam() == DOTA_TEAM_GOODGUYS or owner:GetTeam() == DOTA_TEAM_BADGUYS) then
        local unitName = spawnedUnit:GetName()
        
    end
end


function WhoToAttack:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get();
	
	if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		print("game setup");
		--self:GameSetup();
    end
end






function Activate()
	GameRules:GetGameModeEntity().WhoToAttack = WhoToAttack()
	GameRules:GetGameModeEntity().WhoToAttack:InitGameMode()
end

function WhoToAttack:InitGameMode()
    
    
	
    
    self.stage = 0
    GameRules:GetGameModeEntity():SetThink("OnThink", self, 0)
    
    GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetHeroSelectionTime(0)
  	GameRules:SetStrategyTime(0)
  	GameRules:SetShowcaseTime(0)
    
    
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 1 );
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 1 );
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 0 );
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 );
    
    
    GameRules:GetGameModeEntity().playing_player_count = 0

    
    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( WhoToAttack, 'OnGameRulesStateChange' ), self );
	ListenToGameEvent("dota_player_pick_hero",Dynamic_Wrap(WhoToAttack,"OnPlayerPickHero"),self)
	ListenToGameEvent("player_connect_full", Dynamic_Wrap(WhoToAttack,"OnPlayerConnectFull" ),self)
	ListenToGameEvent("player_disconnect", Dynamic_Wrap(WhoToAttack, "OnPlayerDisconnect"), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(WhoToAttack, "OnEntityKilled"), self)
	
	
	GameRules:GetGameModeEntity().playerid2steamid = {}
	
	self.battle_round = 1
	self.is_game_ended =false
	
	
	GameRules:GetGameModeEntity().team2playerid = {}
	GameRules:GetGameModeEntity().playerid2team = {}
	
	GameRules:GetGameModeEntity().heromap = {}
    GameRules:GetGameModeEntity().playerid2hero = {}
	GameRules:GetGameModeEntity().teamid2hero = {}
	
	GameRules:GetGameModeEntity().steamid2playerid = {}
    GameRules:GetGameModeEntity().playerid2steamid = {}
    GameRules:GetGameModeEntity().steamid2name = {}
	GameRules:GetGameModeEntity().userid2player = {}
	
	GameRules:GetGameModeEntity().client_key = {
		[1] = RandomInt(1,1000000),
	    [6] = RandomInt(1,1000000),
		[7] = RandomInt(1,1000000),
		[8] = RandomInt(1,1000000),
		[9] = RandomInt(1,1000000),
		[10] = RandomInt(1,1000000),
		[11] = RandomInt(1,1000000),
		[12] = RandomInt(1,1000000),
		[13] = RandomInt(1,1000000),
    }
	
	GameRules:GetGameModeEntity().connect_state = {
	    [0] = false,
	    [1] = false,
	    [2] = false,
	    [3] = false,
	    [4] = false,
	    [5] = false,
	    [6] = false,
	    [7] = false,
	}
	
	GameRules:GetGameModeEntity().damage_stat = {
		[6] = {},
		[7] = {},
		[8] = {},
		[9] = {},
		[10] = {},
		[11] = {},
		[12] = {},
		[13] = {},
	}
	
	GameRules:GetGameModeEntity().mychess = {
    	[6] = {},
		[7] = {},
		[8] = {},
		[9] = {},
		[10] = {},
		[11] = {},
		[12] = {},
		[13] = {},
	}
	GameRules:GetGameModeEntity().to_be_destory_list = {
		[6] = {},
		[7] = {},
		[8] = {},
		[9] = {},
		[10] = {},
		[11] = {},
		[12] = {},
		[13] = {},
	}
	
	GameRules:GetGameModeEntity().isConnected = {}
	
	GameRules:GetGameModeEntity().CHESS_POOL_SIZE = 5
	GameRules:GetGameModeEntity().game_status = 0
	GameRules:GetGameModeEntity().prepare_timer = 35
	GameRules:GetGameModeEntity().battle_timer = 50

	GameRules:GetGameModeEntity().chess_ability_list = {
		chess_cm = 'cm_mana_aura',
		chess_axe = 'axe_berserkers_call',
		chess_dr = 'dr_shooter_aura',
	}
    
    
end






function ChessAI(u)
	if not GameRules:GetGameModeEntity().start_ai then
		return
	end
	if u.aitimer ~= nil and Timers.timers[u.aitimer] ~= nil then
		return
	end
	
	--AddAbilityAndSetLevel(u,'jiaoxie')
	--RemoveAbilityAndModifier(u,'jiaoxie_wudi')
	
	--Logic here register aitimer
	u.aitimer = Timers:CreateTimer(delay, function()
		if u == nil or u:IsNull() == true or u:IsAlive() == false or u.alreadywon == true or self.is_game_ended == true then
			return
		end
		
		--防止误调用
		if u:FindAbilityByName('modifier_no_hp_bar') ~= nil or u:FindAbilityByName('modifier_jiaoxie_wudi') ~= nil then
			u:Destroy()
			return
		end
		
		local ai_delay = 0
		
		local attack_result = FindAClosestEnemyAndAttack(u)
		if attack_result ~= nil and attack_result > 0 then
			return attack_result + ai_delay
		end
				
		--tick here
		return RandomFloat(0.1,0.2) + ai_delay
	end)
end