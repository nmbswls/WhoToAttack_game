--全局变量
--start_time           开始时间
--teamNum 
--numPerTeam 

--PlayerManager 
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
--GetPlayingPlayerCount



--配置 存储于GameRules.Definitions
--CHESS_POOL_SIZE      基本卡池大小
--CardListByCost       不同等级的单位列表

--信息
--stage                信息 准备0 预备1 战斗2
--stat_info            玩家状态信息

--battle_field_list    战场信息

--battle_round         回合数
--battle_start_time    战斗回合开始时间
--open_door_list       开门列表
--thrones              王座列表 包含各英雄值
--alive_count          存活玩家个数

--*dead_chess_list      各战场墓地
--player_stat
--stage_start_time     state 开始时间
--game_start_time      全局游戏开始时间
--last_tick            上次tick时间


--is_game_ended        结束游戏标记位
--prepare_timer        准备阶段计时器
--battle_timer         战斗阶段计时器
--game_status          游戏状态 1 准备 2 战斗
--start_ai             ai是否开启

--card_pool            卡池

--damage_stat          伤害统计
--to_be_destory_list   战斗开始后临时创建的单位集合 key为队伍 val为列表

--battle_state         战场结束标记位集合
--client_key           保存客户端认证 开局时随机


--单位属性
--is_battle_completed  战斗是否结束
--is_in_battle         是否进战
--in_battle_id         在哪个战场  at_team_id
--team_id              所属队伍
--attack_target        所选的攻击对象

--battle_field

--英雄属性
--将战场绑在hero身上 合理吗？
--can_toss             是否可以投掷
--base                 基地
--is_open
--now_hold_cards       当前从卡池中抽出 玩家预览选择的卡片
--lock_draw            是否锁定所抽卡
--build_skill_cnt      建造技能数量
--build_skills         可建造单位技能
----skill_name level exp     代表一个建造技能
--throne_bonus         王座效果
--cur_encounters       当前事件

--throw_effect            饰品-投掷特效
--base_model 		   饰品-基地模型

--打怪 


require 'utils.msg'
require 'utils.table_func'
require 'utils.system'
require 'definitions'
require 'UnitAi'
require 'timers'
require 'amhc_library/amhc'
require 'utils.http_utils'
require 'utils.json'

LinkLuaModifier("modifier_toss", "lua_modifier/modifier_toss.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_toss_fast", "lua_modifier/modifier_toss_fast.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_hide", "lua_modifier/modifier_hide.lua", LUA_MODIFIER_MOTION_NONE)



if WhoToAttack == nil then
	_G.WhoToAttack = class({})
end

require 'treasure'
require 'throne'
require 'encounters'
require 'player_manager'
require 'econ_manager'


local sounds = {
    "soundevents/game_sounds.vsndevts",
    "soundevents/game_sounds_dungeon.vsndevts",
    "soundevents/game_sounds_dungeon_enemies.vsndevts",
    "soundevents/custom_soundboard_soundevents.vsndevts",
    "soundevents/game_sounds_winter_2018.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts",
    "soundevents/game_sounds_creeps.vsndevts",
    "soundevents/game_sounds_ui.vsndevts",
    "soundevents/game_sounds_ui_imported.vsndevts",
    "soundevents/game_sounds_items.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_drowranger.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_abyssal_underlord.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_skeletonking.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_riki.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_life_stealer.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_viper.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_furion.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_huskar.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_jakiro.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_dark_willow.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts",
}

function Precache( context )
    print("Precache...")
    for _, v in pairs(sounds) do
        PrecacheResource("soundfile", v, context)
    end
	PrecacheResource( "model",  "models/props_structures/rock_golem/tower_radiant_rock_golem.vmdl", context)
	
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
            -- key = GetClientToken(i),
        })
        
    end

    --init player base_pos
    for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
        local pos = GameRules.Definitions.TeamCenterPos[team_i]
        local hero = PlayerManager:getHeroByTeam(team_i);
        if hero then
            local newBase = CreateUnitByName("player_jidi", pos, true, nil, nil, team_i)
            hero.base = newBase
            newBase.in_battle_id = team_i
            newBase.turn_attacker = {}
			newBase.hero = hero
			if hero.base_model ~= nil then
				newBase:SetOriginalModel(hero.base_model)
				newBase:SetModel(hero.base_model)
			end
			newBase.origin_model = "models/heroes/undying/undying_tower.vmdl"
			
            self.field_base[team_i] = newBase;
            for i = 1,GameRules.Definitions.ThroneCnt do
                table.insert(self.thrones[i], {team = team_i, score = 0})
            end
			
			self:UpdatePlayerStat(hero);
        end
        
    end
    --self:FakeBase()
    
    -- local playerStarts = Entities:FindAllByClassname("info_player_start_dota")
    -- for _, pos in pairs(playerStarts) do
    
    -- end
    CustomNetTables:SetTableValue( "player_info_table", "user_panel_ranking", self.player_stat);
    WtaThrones:init(PlayerManager.player_count);
    
    self:UpdateThroneInfo()
    
	
    --延迟后开始游戏
    Timers:CreateTimer(1,function()
        
        print('GAME START!')
        --初始化棋子库
        self:InitCardPool(PlayerManager:GetPlayingPlayerCount())
        self.start_time = GameRules:GetGameTime()
        self.battle_round = 1
        self:SetStage(1)
        --StartAPrepareRound()
    end)
    
end

function WhoToAttack:FakeBase()
	local newBase = CreateUnitByName("player_jidi", GameRules.Definitions.TeamCenterPos[13], true, nil, nil, 13)
	newBase.in_battle_id = 13
	newBase.turn_attacker = {}
	newBase.hero = nil
    self.field_base[13] = newBase;
end

function WhoToAttack:CheckWinLoseForTeam(team)
    local hero = PlayerManager:getHeroByTeam(team)
    if not hero then
        print("team" .. team .. " no hero")
        return
    end

    if hero.is_battle_completed then
        return
    end
    
    --统计活着的敌我单位数量
    local myUnit, enemyUnit = self:GetUnitCountInBattleGround(team)

    if myUnit == 0 and enemyUnit == 0 then
        --DrawARound(team)
        hero.is_battle_completed = true
        return
    end

    if myUnit > 0 and enemyUnit == 0 then
    
        --WinARound(team,mychess,my_last_chess)
        hero.is_battle_completed = true
        return
    elseif myUnit == 0 then
        
        --LoseARound(team,enemychess_new)
        hero.is_battle_completed = true
        return
    else
        return 1
    end
end

function WhoToAttack:OnThink()
	for nPlayerID = 0, PlayerResource:GetPlayerCount() do
		self:UpdatePlayerColor( nPlayerID )
	end
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
    
	--print("count down " .. stageCountdown)
    if self.stage == 2 then
        self:PingOpenDoor()
    end
    
    if(self.stage == 3) then
        
        --20秒之后才开始计算胜负
        
		for _,hero in pairs(PlayerManager.heromap) do
			--self:CheckWinLoseForTeam(hero)
		end
		
        
        if self:GetBattleCount() == 0 and stageElapsed >= 3 then
            print("go next??")
            isNext = true;
        else 
            if stageCountdown == 30 then
                
            end
        end
            
        
        
        if stageCountdown <= 0 then
			for _,hero in pairs(PlayerManager.heromap) do
				if IsHeroValid(hero) then
                    if not hero.is_battle_completed then
                        self:DrawARound(hero)
                        hero.is_battle_completed = true
                    end
                end
			end
        end
    end
    
    CustomGameEventManager:Send_ServerToAllClients("show_time",{
			time_left = stageCountdown,
			stage = self.stage,
			round = self.battle_round,
		})
    
	--?? shayisi
    if(stageCountdown > 0 and stageCountdown < 4 and self.last_tick ~= stageCountdown) then
        self.last_tick = stageCountdown
    end
    
    if(stageCountdown <= 0 or isNext) then
    
        
        if(self.stage >= GameRules.Definitions.StageCount) then 
            self.battle_round = self.battle_round + 1
            self:SetStage(1)
        else
            self:SetStage(self.stage + 1)
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

function WhoToAttack:PingOpenDoor()
	
	if not self.open_door_list then
		return
	end
	
	for i = 1, #self.open_door_list do
        
        local hero = self.open_door_list[i];
		local tid = hero.team_id;
        
        CustomGameEventManager:Send_ServerToAllClients("ping_open_doors", 
			{x = GameRules.Definitions.TeamCenterPos[tid].x, 
			y = GameRules.Definitions.TeamCenterPos[tid].y, 
			z = GameRules.Definitions.TeamCenterPos[tid].z})
    end
end
function WhoToAttack:SetStage(newStage)
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
        self:StartABattleRound()
        Timers:CreateTimer(5, function()
            self:RemoveJidiWudi();
        end)
    end

    if(self.stage == 3) then
        
        for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
            self:SetBattleTable(team_i, true)
        end
    end
    
    if(self.stage == 4) then
        --未投掷也要清理
        self:ClearBattle(1)
        for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
            self:ClearBattle(team_i)
        end
		CustomNetTables:SetTableValue( "player_info_table", "user_panel_ranking", self.player_stat);
    end
    
    for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
        local hero = PlayerManager:getHeroByTeam(team_i);
        if hero then
            if self.stage == 2 or self.stage == 3 then
                print("can toss now");
                hero.can_toss = true;
            else
                hero.can_toss = false;
            end
        end
        
    end
    
    
	for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
        
       
		CustomGameEventManager:Send_ServerToTeam(team_i, "battle_info",{
			--key = GetClientKey(team_i),
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
		-- for k,v in pairs(GameRules:GetGameModeEntity().chess_list_by_mana[self.battle_round+1]) do
			-- --瞬间同时加载卡顿
			-- PrecacheAUnit(k,v)
		-- end
	end
	
	for _,hero in pairs(PlayerManager.heromap) do
        self:SpawnNeutral(hero.team);
    end
	
    self:AddJidiWudi();
    
    WtaThrones:UpdateLevelByTurn(self.battle_round)
	
    for _,hero in pairs(PlayerManager.heromap) do
        if IsHeroValid(hero) == true then
            for _,bonusName in pairs(hero.throne_bonus) do
                hero:RemoveModifierByName(bonusName);
            end
            hero.throne_bonus = {}
        end
    end
    
    
    for i=1,GameRules.Definitions.ThroneCnt do
		WtaThrones:ReorderTeams(i);
        local orders = WtaThrones.sortedTeamIdx[i];
        local throne = WtaThrones.throneList[i];
        local ability = throne:GetAbilityByIndex(2);
        local giveBonus = true;
        if #orders > 1 then
            if WtaThrones.throneTeamScores[i][orders[2]] == WtaThrones.throneTeamScores[i][orders[1]] then
                giveBonus = false
            end
        end
        
        if giveBonus then
            local hero = PlayerManager:getHeroByTeam(orders[1]);
            if hero then
                local bonusName = GameRules.Definitions.ThroneConfig[i].bonus_name;
                table.insert(hero.throne_bonus, bonusName);
                ability:ApplyDataDrivenModifier(throne, hero, bonusName, {});
            end
        end
    end
    
	local playerNum = 0;
	local aliveHero = {}
	for _, hero in pairs(PlayerManager.heromap) do
		if IsHeroValid(hero) then
			table.insert(aliveHero, hero);
			playerNum = playerNum + 1;
		end
	end
	
	
	for tid =6,13 do
		self.battle_field_list[tid].is_open = false;
	end
    
    if playerNum == 0 then
        return
    end
	
    local openDoorTurn = self.battle_round  % 5;
    
    if openDoorTurn == 0 then
        self.open_door_list = aliveHero
    elseif openDoorTurn == 1 or openDoorTurn == 3 then
        local shuffled = table.shuffle(aliveHero);
        self.open_door_list = {}
        local openDoorNum = GameRules.Definitions.OpenDoorNumByAlive[playerNum]
        for i = 1, openDoorNum do
            table.insert(self.open_door_list, shuffled[i]);
        end
    else
        local tmp = {}
        local last_open_door = self.open_door_list
        for i = 1, #aliveHero do
            if not table.contains(last_open_door, aliveHero[i]) then
                table.insert(tmp, aliveHero[i])
            end
        end
        self.open_door_list = tmp
    end
	
	
	local open_door_info = {}
	
    --print("open list:");
    for i = 1, #self.open_door_list do
        
        local hero = self.open_door_list[i];
		local tid = hero.team_id;
		print('open door' .. tid)
		self.battle_field_list[tid].is_open = true;
        
        --加开门特效
        local jidi = hero.base
        if jidi then
            local ability = jidi:FindAbilityByName('is_player_jidi')
            if ability then
                ability:ApplyDataDrivenModifier(jidi, jidi, "modifier_opendoor_effect",
                {
                    duration = -1,
                })
            end
        end
        table.insert(open_door_info, hero:GetPlayerID());
    end
    CustomNetTables:SetTableValue( "player_info_table", "open_door_info", open_door_info);
    for _,hero in pairs(PlayerManager.heromap) do
        if IsHeroValid(hero) == true then
            --给蓝
            local mana = 0;
            if hero.base then
                hero.base.turn_attacker = {}
            end
            hero:SetMana(hero:GetMaxMana());
    
            --自动抽卡
            self:DrawCards(hero:GetTeam(), true);
                
            --回合加经验
            hero:AddExperience(10,0,false,false);
			
			local eids = WtaEncounters:GetRandomEncounter(self.battle_round, 3)
			hero.cur_encounters = {}
			if eids then
				CustomGameEventManager:Send_ServerToTeam(hero.team,"show_encounters",{
					encounters = eids,
				})
				hero.cur_encounters = eids;
			else
                CustomGameEventManager:Send_ServerToTeam(hero.team,"show_encounters",{
					encounters = nil,
				})
            end
			
        end
    end
    
end

function WhoToAttack:AddJidiWudi()
	
	PlayerManager:DoEachHero(function(hero)
			if not IsHeroValid(hero) then
				return
			end
			
			local jidi = hero.base
			if jidi then
				local ability = jidi:FindAbilityByName('is_player_jidi')
				if ability then
					ability:ApplyDataDrivenModifier(jidi, jidi, "modifier_jidi_wudi",
					{
						duration = -1,
					})
				end
                jidi:RemoveModifierByName("modifier_opendoor_effect");
			end
		end)
end

function WhoToAttack:RemoveJidiWudi()

	PlayerManager:DoEachHero(function(hero)
			if not IsHeroValid(hero) then
				return
			end
			
			local jidi = hero.base
			if jidi then
				jidi:RemoveModifierByName("modifier_jidi_wudi");
			end
		end)
end

function WhoToAttack:StartABattleRound()
    if self.is_game_ended == true then
        return
    end
    
    
    --移除每个场地中的隐身modifier
    for i = DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
        self:ShowPrepare(i)
        
        --test code
        
    end
    
    
    
    
    GameRules:SetTimeOfDay(0.3)
    self.game_status = 2 --game_status 2 zhandou zhong
    self.battle_timer = 50

    -- GameRules:GetGameModeEntity().battle_count = 0
    self:InitBattleTable()
end


function WhoToAttack:SpawnNeutral(team, monsterName, count)
	
    if not self.is_single then
        return
    end
    
	if monsterName == nil then
		monsterName = "evil_skeleton"
	end
	if count == nil then
		count = 4
	end
	
    local randUnit = GameRules.Definitions.SoloMonsterPool[RandomInt(1, #GameRules.Definitions.SoloMonsterPool)];
    local cost = GameRules.Definitions.Uname2Cost[randUnit];
    
    if not cost then
        cost = 1
    end
    local round = self.battle_round;
    count = math.ceil((round * 1.6 + 5 )/ cost);
    
    -- local hero = PlayerManager:getHeroByTeam(team)
    -- if hero then
        -- local mana = hero:GetMaxMana();
        -- count = math.ceil(mana / cost);
    -- end
    
    local pos = GameRules.Definitions.TeamCenterPos[team] + Vector(0,-500,0)

    for i = 1, count do
        local unit = self:CreateUnit(3, pos, randUnit)
        Timers:CreateTimer(0.5, function()
            unit.in_battle_id = team;
        end)
    end
    
end

function WhoToAttack:CanBuildUnits()

    if not self.stage then
        return false
    end
    
    if self.stage == 1 or self.stage == 2 or self.stage == 3 then
        return true
    end
    
    return false
end

function WhoToAttack:CanThrow()

    if not self.stage then
        return false
    end
    
    if self.stage == 2 then
        return true
    end
    
    return false
end



function StatClassCount(team_id)
	--empty
end


function WhoToAttack:UpdateThroneInfo()

    --print("UpdateThroneInfo")
    
    for i = 1,GameRules.Definitions.ThroneCnt do
        table.sort( self.thrones[i], function(a,b) return ( a.score > b.score ) end )
        
        for tid = 1, #self.thrones[i] do 
            --print(self.thrones[i][tid].team .. "   " ..  self.thrones[i][tid].score)
        end
    end
    
    
    
    CustomNetTables:SetTableValue( "player_info_table", "throne_info", { data = self.thrones[i], hehe = RandomInt(1,100000)})
end

function WhoToAttack:DrawARound(hero)
	if hero == nil or hero:IsNull() == true or hero:IsAlive() == false then
		return
	end
	
	-- GameRules:GetGameModeEntity().battle_count = GameRules:GetGameModeEntity().battle_count - 1
	self:SetBattleTable(hero.team, false)

	--通知UI显示胜负
	-- for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
		-- CustomGameEventManager:Send_ServerToTeam(team_i,"show_round_win_lose",{
			-- key = GetClientKey(team_i),
			-- player_id = hero:GetPlayerID(),
			-- winlose = "draw",
		-- })
	-- end
end


function WhoToAttack:DoPlayerDie(hero)
	if hero.dead then
		return
	end
	hero.dead = true;
    if hero:IsAlive() == true then
		hero:ForceKill(false)
	end
	
	hero.ranking = self.alive_count;
    
	self.alive_count = self.alive_count - 1;
	print('alive count ' .. self.alive_count)
	if self.alive_count == 0 then
        print('single game end')
        self:EndGame()
    elseif self.alive_count == 1 then
        print('multi game end')
        self:EndGame()
	end
	
	WtaThrones:ClearScore(hero.team);
end

function WhoToAttack:EndGame()
    
    local winTeam = nil
    local endData = {}
    for _,hero in pairs(PlayerManager.heromap) do
        --self:CheckWinLoseForTeam(hero)
		if hero:IsAlive() then
			hero.ranking = 1
			winTeam = hero.team
		end
        print("end game info " .. hero.ranking);
        table.insert(endData,{player_id = hero:GetPlayerID(), tid = hero.team, rank = hero.ranking})
    end
	winTeam = winTeam or DOTA_TEAM_BADGUYS
    CustomNetTables:SetTableValue( "end_info", "end_info", endData)
    GameRules:SetGameWinner(winTeam)
	
	
	self:ReportEndInfo();
end

function WhoToAttack:CreateUnit(team, pos, unitName, spe)
	
	if spe then
		unitName = unitName .. "_special"
	end

    local hero = PlayerManager:getHeroByTeam(team)
    --local newyUnit = CreateUnitByName(unitName, pos, true, hero, hero, team)
    local newyUnit = CreateUnitByName(unitName, pos, true, nil, nil, team)
    if newyUnit then
        newyUnit:SetAbsOrigin(pos);
        FindClearSpaceForUnit(newyUnit, pos, true)
        newyUnit.team = team
        
        self:InitUnit(team,newyUnit)
        
        local a = AddAbilityAndSetLevel(newyUnit, "modifier_container",1)
        

		for i = 0,4 do
			local pSkill = newyUnit:GetAbilityByIndex(i)
			if pSkill then
				pSkill:SetLevel(1);
				if spe then
					pSkill:SetLevel(2);
				end
			end

		end
	
        

		local yinshenFeature = newyUnit:FindAbilityByName("unit_feature_yinshen");
		if yinshenFeature then
			yinshenFeature:ApplyDataDrivenModifier(newyUnit, newyUnit, "modifier_yinshen_begin", {});
		end
		
		if team ~= 3 then
			newyUnit.originManaRegen = newyUnit:GetManaRegen();
			newyUnit:SetBaseManaRegen(0);
		end
        
		
		
        
        local level = newyUnit:GetLevel();
        if string.find(unitName, "nature") then
            WtaThrones:AddScore(1,team, level)
        elseif string.find(unitName, "evil") then
            WtaThrones:AddScore(2,team, level)
        elseif string.find(unitName, "hidden") then
            WtaThrones:AddScore(3,team, level)
        elseif string.find(unitName, "vibrant") then
            WtaThrones:AddScore(4,team, level)
        elseif string.find(unitName, "wizard") then
            WtaThrones:AddScore(5,team, level)
        elseif string.find(unitName, "brawn") then
            WtaThrones:AddScore(6,team, level)
		end
    end
    
    
    return newyUnit
end

--初始化
function WhoToAttack:InitUnit(team, unit)
    if unit == nil or unit:IsNull() then
        return
    end    
    unit.is_in_battle = false
	unit.team_id = team
    unit.in_battle_id = 0
    local unitName = unit:GetUnitName();
    local isSpecial = false
    --print("init units name:"..unitName)
    
    if string.find(unitName,'_special') ~= nil then
        unitName = string.sub(unitName,1,-9)
        isSpecial = true
    end
    
    if table.contains(GameRules.Definitions.UnitAbilityMap, unitName) then
        local a = GameRules.Definitions.ChessAbilityList[unitName]
        local a_level = 1
        if unit:FindAbilityByName(a) == nil then
            AddAbilityAndSetLevel(unit,a,a_level)
        else
            unit:FindAbilityByName(a):SetLevel(a_level)
        end
    end
    if table.contains(GameRules.Definitions.UnitNames, unitName) then
        table.insert(self.to_be_destory_list[1], unit)
        Timers:CreateTimer(0.5, function()
			if IsValidEntity(unit) then
				unit:SetContextThink("OnUnitThink", function() return UnitAI:OnUnitThink(unit) end, 1)
			end
        end)
    end
    
end

function WhoToAttack:CheckBuildSkill(hero, skillName)
    if hero.build_skill_cnt >= GameRules.Definitions.MaxBuildSkill then
        print("too many build skills");
        return false
    end
    
    for i = 1, #hero.build_skills do 
        if hero.build_skills[i].name == skillName then
            if hero.build_skills[i].level >= 10 then
                return false
            end
        end
    end
    
    return true
end

function WhoToAttack:UpgradeBuildSkill(hero, buildUnit)

    local pid = hero:GetPlayerID();
    print("try upgrade " .. buildUnit)
    
    
    local completeSkillName = GetBuildSkillName(buildUnit)
    
    local skillIdx = nil;
    for i = 1, #hero.build_skills do 
        if hero.build_skills[i].skill_name == completeSkillName then
            skillIdx = i;
            break;
        end
    end
    
    
    local ability = nil
    
    --print(skillIdx)
    if skillIdx == nil then
	--new skill check num
	if hero.build_skill_cnt >= GameRules.Definitions.MaxBuildSkill then
		print("too many build skills");
		msg.bottom('技能栏满', pid, 1)
		return false
	    end
		
		
        table.insert(hero.build_skills, {skill_name = completeSkillName, level = 1, exp = 1})
        hero.build_skill_cnt = hero.build_skill_cnt + 1
        skillIdx = hero.build_skill_cnt
        ability = self:AddBuildSkill(hero, completeSkillName)
    else 
        if hero.build_skills[skillIdx].level == 10 then
            msg.bottom('召唤升到满级', pid, 1)
            return false;
        end
        --print("try find exists skill")
        hero.build_skills[skillIdx].level = hero.build_skills[skillIdx].level + 1
        ability = hero:FindAbilityByName(completeSkillName)
        if ability ~= nil then
            ability:SetLevel(hero.build_skills[skillIdx].level)
        end
        -- local oldSkill = hero:GetAbilityByIndex(skillIdx-1)
        -- if oldSkill then
            -- hero:RemoveAbilityByHandle(oldSkill)
        -- end
    end
    
    
    -- local newSkillName = "build_" .. hero.build_skills[skillIdx].name .. "_" .. string.format("%02d", hero.build_skills[skillIdx].level)
    
    -- local newAbility = hero:AddAbility(newSkillName)
    -- newAbility:SetLevel(hero.build_skills[skillIdx].exp)
    -- newAbility:SetAbilityIndex(skillIdx-1)
    
    
    for i=0,15 do
		local aaa = hero:GetAbilityByIndex(i)
        --if aaa then print(i .. " , ".. aaa:GetAbilityName()) end
	end
    
    return true
end

function WhoToAttack:AddBuildSkill(hero, completeSKillName)
    
	local emptyAbility = self:findEmptyAbility(hero)
    if not emptyAbility then
        print("no empty skill slot found")
        return nil
    end
    
    local newAbility = hero:AddAbility(completeSKillName)
    hero:SwapAbilities(completeSKillName, emptyAbility, true, false)
    hero:RemoveAbility(emptyAbility)
    newAbility:SetLevel(1);
    return newAbility
end

function WhoToAttack:DelBuildSkill(hero, skillIdx)
    
    print("try del " .. skillIdx)
    
    if skillIdx > hero.build_skill_cnt then
        print("not enough skill")
        return
    end
    
    local sname = hero.build_skills[skillIdx].skill_name;
    local slevel = hero.build_skills[skillIdx].level;
    local unitName = string.sub(sname, 7)
    
    for i=1,slevel do
        self:AddCardToPool(unitName);
    end
    
    print("DelBuildSkill " .. sname .. " " .. slevel)
    self:RemoveAbilityWithEmpty(hero, skillIdx)
    
    
    for i=0,15 do
        local aaa = hero:GetAbilityByIndex(i)
        if aaa then print(i .. " , ".. aaa:GetAbilityName()) end
	end
    print("build list:")
    for i = 1, #hero.build_skills do 
        DeepPrintTable(hero.build_skills[i])
    end
end

function WhoToAttack:TopCertainAbility(hero, skillIdx)
	if skillIdx > hero.build_skill_cnt then
        print("no such skill")
        return
    end
	if hero.build_skill_cnt == 1 or skillIdx == 1 then
		return
	end
	--1 2 3 4 5
	--4 1 2 3 5
	local tarAbiName = hero.build_skills[skillIdx].skill_name;
	for i = skillIdx, 2, -1 do
        hero:SwapAbilities(hero.build_skills[i].skill_name, hero.build_skills[i-1].skill_name, true, true)
        local tmp = hero.build_skills[i]
        hero.build_skills[i] = hero.build_skills[i-1]
        hero.build_skills[i-1] = tmp;
    end
	
	
end

function WhoToAttack:RemoveAbilityWithEmpty(hero, skillIdx)
    
    if not hero.build_skills[skillIdx] then
        return
    end
    local abilityName = hero.build_skills[skillIdx].skill_name
    local ability = hero:FindAbilityByName(abilityName)
    
    --s1 s2 s3 s4 e5 e6 e7 e8
    --s1 s2 s4 s3 
    print('remove ability : ' .. abilityName)
    
    print('RemoveAbilityWithEmpty ' .. skillIdx)
    
    local lastFilledSkill = GameRules.Definitions.MaxBuildSkill
    
    for i = skillIdx, hero.build_skill_cnt-1 do
        hero:SwapAbilities(hero.build_skills[i].skill_name, hero.build_skills[i+1].skill_name, true, true)
        local tmp = hero.build_skills[i]
        hero.build_skills[i] = hero.build_skills[i+1]
        hero.build_skills[i+1] = tmp;
    end
    
    -- for i = skillIdx, GameRules.Definitions.MaxBuildSkill do
        
        -- if i+1 > GameRules.Definitions.MaxBuildSkill then
            -- lastFilledSkill = i
            -- break
        -- end
        -- --skillIdx 下标从1开始 dota2技能栏下标从0开始 这里需要-
        -- local curSkillName = hero:GetAbilityByIndex(i):GetAbilityName()
        -- local nextSkillName = hero:GetAbilityByIndex(i):GetAbilityName();
        -- print('nextSkillName ' .. nextSkillName)
        -- --local nextSkillName = hero.build_skills[i+1].skill_name;
        -- if string.find(nextSkillName,'empty') ~= nil then
            -- lastFilledSkill = i
            -- break
        -- end
        
        -- hero:SwapAbilities(hero.build_skills[i].skill_name, nextSkillName, true, true)
        -- print('swap ' .. hero.build_skills[i].skill_name .. ' with ' .. nextSkillName)
    -- end
    
    --local replaceAbilityName = "empty" .. lastFilledSkill
    local replaceAbilityName = "empty" .. hero.build_skill_cnt
    print("last skill name " .. replaceAbilityName)
    
    local replaceAbility = hero:AddAbility(replaceAbilityName)
    replaceAbility:SetLevel(1)
	hero:SwapAbilities(replaceAbilityName,abilityName,true,false)
    
    --remove something
    hero:RemoveAbility(abilityName)
    
    table.remove(hero.build_skills, hero.build_skill_cnt)
    hero.build_skill_cnt = hero.build_skill_cnt - 1;
    
end


function WhoToAttack:AdjustSkillOrder(hero)
    if not hero then
        return
    end
    for i = 0, 9 do
        local ability = hero:GetAbilityByIndex(i)
        if ability then
            local abilityName = ability:GetAbilityName();
            local needAName = "build_" .. hero.build_skills[i+1].name
            if abilityName ~= needAName then
                hero:SwapAbilities(needAName, abilityName,true,true)
            end
        end
    end
end

function WhoToAttack:GetPosBattleField(pos)

    if pos == nil then
        return nil
    end

	local minDist = 0
	local minIdx = -1

    for team_i = 6, 13 do 
        local p2 = GameRules.Definitions.TeamCenterPos[team_i]
        local distance = (p2 - pos):Length2D()
        if minIdx == -1 or distance < minDist then
            minDist = distance
            minIdx = team_i;
        end
    end
    
    if minIdx == -1 then
        return nil
    end
	print('get pos batle field ' .. minIdx)
    return self.battle_field_list[minIdx]
end

function WhoToAttack:CheckThrowTarget(target, pos)
    
    if pos == nil then
        --find closet
        return -1
    end

	local minDist = 0
	local minIdx = -1
    
	for team_i = 6, 13 do 
        local p2 = GameRules.Definitions.TeamCenterPos[team_i]
        local distance = (p2 - pos):Length2D()
        if minIdx == -1 or distance < minDist then
            minDist = distance
            minIdx = team_i;
        end
    end
    --print("touzhi target battle " .. minIdx)
    
    if minIdx == -1 then
        return -1
    end    
    
    local diffx = math.abs(GameRules.Definitions.TeamCenterPos[minIdx].x - pos.x);
    local diffy = math.abs(GameRules.Definitions.TeamCenterPos[minIdx].y - pos.y);
    
    --print("diffx " .. diffx)
    --print("diffy " .. diffy)
    
    if diffx > GameRules.Definitions.ThrowBaseRange or diffy > GameRules.Definitions.ThrowBaseRange then
        return -1;
    end
    
    return minIdx;
    
end


function WhoToAttack:ChangeBattleField(target, battleIdx)
    
    target.is_in_battle = true
	target.in_battle_id = battleIdx;
    table.insert(self.to_be_destory_list[battleIdx], target)
	--GameRules:GetGameModeEntity().battle.insert
	--更新羁绊
	StatClassCount(battleIdx)
end



function WhoToAttack:ClearBattle(teamid)
	for _,v in pairs(self.to_be_destory_list[teamid]) do
		if v ~= nil and v:IsNull() == false then
            --print("to destoy: " .. v:GetUnitName())
			--AddAbilityAndSetLevel(v,'no_selectable')
			v:Destroy()
		end
	end
	self.to_be_destory_list[teamid] = {}
end


--业务工具方法

function WhoToAttack:GetUnitCountInBattleGround(team)
	local myunit_count = 0
	local enemyunit_count = 0
	
	local team_objs = {}
	
	
	if self.to_be_destory_list[team] == nil then
		return myunit_count,enemyunit_count
	end
	--返回每个阵营的单位数量
	
	for _,unit in pairs(self.to_be_destory_list[team]) do
		
		if unit.team_id == team then
			myunit_count = myunit_count + 1
		else
			enemyunit_count = enemyunit_count + 1
		end
	end
	return myunit_count,enemyunit_count
end


function WhoToAttack:ShowPrepare(team)
	if self.to_be_destory_list[team] ~= nil then
		for _,ent in pairs(self.to_be_destory_list[team]) do
			RemoveAbilityAndModifier(ent,'invisible_to_enemy')
		end
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



function WhoToAttack:InitCardPool()
	
	local chess_pool_times = GameRules.Definitions.ChessPoolSize or 6
    
	for cost,vlist in pairs(GameRules.Definitions.CardListByCost) do
		for _,unit in pairs(vlist) do
			local init_cnt = GameRules.Definitions.CardInitCntByCost[cost] * chess_pool_times
			for i=1, init_cnt do
				self:AddCardToPool(unit)
			end
		end
	end
end

function WhoToAttack:AddCardToPool(unit)

	--local maxcount = 3

    local cost = GameRules.Definitions.Uname2Cost[unit];
    if cost == nil then
        print("cost info lost: " .. unit)
        return
    end
    
	--for count = 1,maxcount do
        table.insert(self.card_pool[cost], unit)
	--end
end

function WhoToAttack:LockCard(team_id, locked)
	local hero = PlayerManager:getHeroByTeam(team_id)
	if hero == nil then
		return false;
	end
	if locked == 1 then
		hero.lock_draw = true
    else
        hero.lock_draw = false
	end
	return true
end

function WhoToAttack:DrawCards(team_id, auto_draw)
    
    
	
    local h = PlayerManager:getHeroByTeam(team_id)
	
	--自动抽卡时 才会被锁定阻挡
	if auto_draw and h.lock_draw then
		return
	end

	if h.now_hold_cards ~= nil then
		for _,card in pairs(h.now_hold_cards) do
			if card ~= nil then
				self:AddCardToPool(card)
			end
		end
	end
	h.now_hold_cards = {}
	
	local cards,now_hold_cards = self:RandomNDrawNew(team_id,5)
	h.now_hold_cards = now_hold_cards
    
    local pid = GameRules:GetGameModeEntity().team2playerid[team_id]
    --msg.bottom('draw card '..cards, pid)

    -- for _,n in pairs(now_hold_cards) do
        -- print("c: " .. n)
    -- end
    -- print("total: " .. cards)
    
    CustomGameEventManager:Send_ServerToTeam(team_id,"show_cards",{
            hand_cards = now_hold_cards,
        })
    
end


function WhoToAttack:PickCard(team_id, card_idx)
    
    local hero = PlayerManager:getHeroByTeam(team_id)
    local pid = GameRules:GetGameModeEntity().team2playerid[team_id]

	if not hero or not hero.now_hold_cards then
        return false
    end
	
    if card_idx <= 0 or card_idx > #hero.now_hold_cards then
        return false
    end
    
    local unitName = hero.now_hold_cards[card_idx]
    
    if not unitName or unitName == "" then
        print("card " .. card_idx .. " is nil")
        return false
    end
    
    local cost = GameRules.Definitions.Uname2Cost[unitName] * GameRules.Definitions.CardPriceRate;
    
    if not cost then
        print("card " .. card_idx .. " has no cost config.")
        return false;
    end
    
    if hero:GetGold() < cost then
        msg.bottom('金钱不足', pid, 1)
        return false
    end
    
    
    
    local ret = self:UpgradeBuildSkill(hero, unitName)
    
    if not ret then
        return false
    end
	
    hero:ModifyGold(-cost, false, 0);
	
    
    print("pick card  " .. unitName)
    hero.now_hold_cards[card_idx] = ""
	--EmitGlobalSound("General.CastFail_NoMana")
	local player = PlayerResource:GetPlayer(pid)
	hero:EmitSoundParams("Item.PickUpRingWorld",0,4,0)
	
    return true
end



function WhoToAttack:RandomNDrawNew(team_id,n)
	local ret_list_str = ""
	local ret_list_table = {}
	local true_count = 0
		
	while true_count < n do
		local ret = self:RandomDrawNew(team_id)
		if ret ~= nil then
			ret_list_str = ret_list_str..ret..','
			true_count = true_count + 1
            table.insert(ret_list_table,ret);
		end
	end
	return ret_list_str, ret_list_table
end

function WhoToAttack:RandomDrawNew(team_id)
	local hero = PlayerManager:getHeroByTeam(team_id)
    
    if not hero then
        return
    end
    
	local ret_card = nil
    
	local ran = RandomInt(1,100)
	local hero_level = hero:GetLevel()

    local level = hero:GetLevel()
	--local table_11chess = Get11ChessBaseNameTable(team_id)
	
    local gailv = {}
    
    if level > GameRules.Definitions.MaxLevel then
        gailv = GameRules.Definitions.DrawLevelGailv[GameRules.Definitions.MaxLevel]
    else
        gailv = GameRules.Definitions.DrawLevelGailv[level]
    end

    --正常抽牌
    local cost = 0;
    for i, per in pairs(gailv) do
        if ran <= per then
            cost = i
            break
        end
    end
    
    ret_card = self:DrawCardFromPool(cost, hero);
    --print("draw card " .. ret_card);
	return ret_card
end

function WhoToAttack:DrawCardFromPool(cost, hero)

    if #self.card_pool[cost] == 0 then
        return "null"
    end

	local index = RandomInt(1,table.maxn(self.card_pool[cost]))
	local chess_name = self.card_pool[cost][index]

    
	table.remove(self.card_pool[cost],index)
	return chess_name
end


function UpdateStatUI()
	CustomNetTables:SetTableValue( "player_info_table", "player_info", 
		{ data = GameRules:GetGameModeEntity().stat_info, 
		  hehe = RandomInt(1,100000)})
end

function WhoToAttack:InitBattleTable()

	self.battle_state = {
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

function WhoToAttack:SetBattleTable(team_id, value)
	self.battle_state[team_id] = value
end

function WhoToAttack:GetBattleCount()
	local battle_count = 0
	for _,i in pairs(self.battle_state) do
        
		if i == true then
			battle_count = battle_count + 1
		end
	end
	return battle_count
end




function GetClientToken(team)
	return GameRules:GetGameModeEntity().client_key[team]
end


function IsHeroValid(hero)
    if hero == nil or hero:IsNull() then
        return false;
    end
    
    if not hero:IsRealHero() then
        return false;
    end
    
    if not hero:IsAlive() then
        return false;
    end
    
    return true;
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
		return nil
	end
    local newAbility = u:FindAbilityByName(a)
	if newAbility == nil then
		newAbility = u:AddAbility(a)
	end
    if newAbility ~= nil then
        u:FindAbilityByName(a):SetLevel(l)
    end
    return newAbility
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



function WhoToAttack:ModifyBaseHP(base, modHp)
	
    if base == nil or modHp == nil then
        return
    end
	local hero = base.hero;
	
    if not hero then
        return
    end
	
    local nowHp = base:GetHealth();
	
    if nowHp <= 0 then
      return
    end
    local newHp = nowHp + modHp;
    if newHp < 0 then
       newHp = 0
    end

    if newHp == 0 then
       base:ForceKill(false)
       self:DoPlayerDie(hero)
    else
       base:SetHealth(newHp)
    end

	self:UpdatePlayerStat(hero);
	CustomNetTables:SetTableValue( "player_info_table", "user_panel_ranking", self.player_stat);
	
end

function WhoToAttack:UpdatePlayerStat(hero)
	if not hero or not hero.base then
		return
	end
	
	local pid = hero:GetPlayerID()
	local steamId = PlayerResource:GetSteamID(pid)
	local hp = hero.base:GetHealth();
	local money = hero:GetGold() or 0;
	if not self.player_stat[pid] then
		self.player_stat[pid] = {}
	end
	self.player_stat[pid].pid = pid;
	self.player_stat[pid].steamId = steamId;
	self.player_stat[pid].hp = hp;
	self.player_stat[pid].money = money;
	
end

function WhoToAttack:MoveUnit(hero, target, pos, isFast)


	if target == nil or target:IsNull() == true then
	   return
	end

	local pos = pos

	--可扩展的 暂时不需要
	-- if set_forward == true then
	   -- caster:SetForwardVector((position - caster:GetAbsOrigin()):Normalized())
	-- end


	target:Stop()
	-- caster:InterruptMotionControllers(false)
	-- caster:RemoveHorizontalMotionController(caster)
	-- caster:RemoveVerticalMotionController(caster)
	if target:HasModifier("modifier_toss")  then
		-- return
		target:RemoveModifierByName("modifier_toss")
		target:RemoveModifierByName("modifier_toss_fast")
	end
	local effName = nil;
	if hero ~= nil and hero.throw_effect ~= nil then
		effName = hero.throw_effect
	end
	local modifierName = "modifier_toss";
	if isFast then
		modifierName = "modifier_toss_fast";
	end
	target:AddNewModifier(target,nil,modifierName,
	{
		vx = pos.x,
		vy = pos.y,
		throwEffect = effName,
	})

end



-- function GetPlayingPlayerCount()
	-- if GameRules:GetGameModeEntity().playing_player_count > 0 then
		-- return GameRules:GetGameModeEntity().playing_player_count
	-- end
	
	-- local playing_player_count = 0
	-- local obing_player_count = 0
	-- for player_id,_ in pairs(GameRules:GetGameModeEntity().playerid2steamid) do
		-- if PlayerResource:GetTeam(player_id) >= 6 and PlayerResource:GetTeam(player_id) <= 13 then
			-- playing_player_count = playing_player_count + 1
		-- end
		-- if PlayerResource:GetTeam(player_id) == 1 then
			-- obing_player_count = obing_player_count + 1
		-- end
	-- end
	-- GameRules:GetGameModeEntity().playing_player_count = playing_player_count
	-- GameRules:GetGameModeEntity().obing_player_count = obing_player_count
	
	-- -- if GameRules:GetGameModeEntity().obing_player_count > 0 then
		-- -- combat('OB COUNT: '..GameRules:GetGameModeEntity().obing_player_count)
		-- -- CustomGameEventManager:Send_ServerToAllClients("show_ob_count",{
			-- -- count = GameRules:GetGameModeEntity().obing_player_count
		-- -- })
	-- -- end
	-- return GameRules:GetGameModeEntity().playing_player_count

-- end



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
	for slot=0,10 do
		if hero:GetItemInSlot(slot)~= nil then
			hero:RemoveItem(hero:GetItemInSlot(slot))
		end
	end
	
	hero:SetHullRadius(1)
	hero:SetAbilityPoints(0)
	
	hero.throw_effect = nil; --"particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf";
	
    for i=1, GameRules.Definitions.MaxBuildSkill do 
        hero:FindAbilityByName("empty"..i):SetLevel(1)
    end
	--移除占位符技能
	for i=GameRules.Definitions.MaxBuildSkill+1,16 do
		hero:RemoveAbility("empty"..i)
	end
	
    
    --local a2 = AddAbilityAndSetLevel(hero,"wudi",1)
    local growAbility = AddAbilityAndSetLevel(hero,"builder_growth",1)
    growAbility:ApplyDataDrivenModifier(hero,hero,"modifier_builder_growth",{});
    hero:AddItemByName("item_throw_one")
    
    
    -- hero:SetAbilityByIndex(a0,11);
    -- hero:SetAbilityByIndex(a1,12);
    -- hero:SetAbilityByIndex(a2,13);
    -- hero:SetAbilityByIndex(nil, 1);
    -- a0:SetAbilityIndex(11)
    --a1:SetAbilityIndex(12)
    --a2:SetAbilityIndex(13)
    
    -- for i=0,10 do
		-- local aaa = hero:GetAbilityByIndex(i)
        -- if aaa then print(i .. " , ".. aaa:GetAbilityName()) end
        
	-- end
    Timers:CreateTimer(2,function()
        -- self:UpgradeBuildSkill(hero,"brawn_siege")
    end)
    
    
    
	hero:SetMana(0)
	hero:SetStashEnabled(false)
	
	
	hero.team = hero:GetTeam()
	hero.team_id = hero:GetTeam()
    hero.can_toss = false;
    
    hero.build_skill_cnt = 0
    hero.build_skills = {}
    
    hero.throne_bonus = {}
    
	GameRules:GetGameModeEntity().team2playerid[hero:GetTeam()] = player:GetPlayerID()
	GameRules:GetGameModeEntity().playerid2team[player:GetPlayerID()] = hero:GetTeam()

	--将所有玩家的英雄存到一个数组
	local heroindex = keys.heroindex
	
	PlayerManager.heromap[heroindex] = EntIndexToHScript(heroindex)
	PlayerManager.playerid2hero[player:GetPlayerID()] = EntIndexToHScript(heroindex)
	PlayerManager.teamid2hero[hero:GetTeam()] = EntIndexToHScript(heroindex)
	local playercount = 0
	for i,vi in pairs(PlayerManager.heromap) do
		playercount = playercount +1
	end
	
	local allCount = PlayerManager:GetPlayingPlayerCount();

	-- local all_playing_player_count = GetPlayingPlayerCount()
	-- --下发消息 
	-- --combat("PLAYER JOINED: "..playercount.."/"..GameRules:GetGameModeEntity().playing_player_count)
    
    -- --print("player count " .. all_playing_player_count .. "   " .. playercount);
    
	if playercount == allCount then
		self.alive_count = playercount;
		Timers:CreateTimer(0.1,function()
			--开始
			self:SendStartGameReq();
		end)
        
        if playercount == 1 then
            self.is_single = true;
        end
	end 
	
end



function WhoToAttack:OnPlayerConnectFull(keys)
	--to do 断线重连
	-- prt('[OnPlayerConnectFull] PlayerID='..keys.PlayerID..',userid='..keys.userid..',index='..keys.index)
    
    
	PlayerManager.playerid2steamid[keys.PlayerID] = tostring(PlayerResource:GetSteamAccountID(keys.PlayerID))
	PlayerManager.steamid2playerid[tostring(PlayerResource:GetSteamAccountID(keys.PlayerID))] = keys.PlayerID
	PlayerManager.steamid2name[tostring(PlayerResource:GetSteamAccountID(keys.PlayerID))] = tostring(PlayerResource:GetPlayerName(keys.PlayerID))
	PlayerManager.userid2player[keys.userid] = keys.index + 1

	GameRules:GetGameModeEntity().connect_state[keys.PlayerID] = true
	local hero = PlayerManager:getHeroByPlayer(keys.PlayerID)
	--???
	if GameRules:GetGameModeEntity().isConnected[keys.index + 1] == true then
		
		if hero ~= nil then
			--重连 要重新推ui信息
			hero.isDisconnected = false
		end
	end
	GameRules:GetGameModeEntity().isConnected[keys.index+1] = true
    
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    player:SetSelectedHero("builder")
	
	
	Timers:CreateTimer(RandomFloat(0.1,0.5),function()
			local team_id = GameRules:GetGameModeEntity().playerid2team[keys.PlayerID]
			if hero ~= nil then
                CustomGameEventManager:Send_ServerToTeam(team_id,"show_cards",{
                    hand_cards = hero.now_hold_cards,
                })
            end
		end)
end

function WhoToAttack:OnPlayerDisconnect(keys)
	if not IsServer() then
		return
	end
	
	local hero = PlayerManager:getHeroByPlayer(keys.PlayerID)
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
    
    if not keys.entindex_killed then
		return
	end

	local u = EntIndexToHScript(keys.entindex_killed)
	if u == nil or not IsValidEntity(u) then
		return
	end
	if u:IsHero() == true then
		return
	end
	if u:GetUnitName() == "invisible_unit" then
		return
	end
    
    if self.stage == 1 or self.stage == 4 then
        --只有游戏中单位被杀才有反应
        return
    end
	
	--杀人者
	if keys.entindex_attacker == nil then
		return
	end
	
	local attacker = EntIndexToHScript(keys.entindex_attacker)
	attacker = attacker.damage_owner or attacker
    
    if attacker == nil then
        return
    end
    
    local attacker_team = attacker:GetTeam()
    
    local killed_level = u:GetLevel()
    local bonus = killed_level * 1;
    if string.find(u:GetUnitName(), "neutral") then
		bonus = killed_level * 2;
	end
    local hero1 = PlayerManager:getHeroByTeam(attacker_team);
    
    if hero1 and bonus then
		hero1:EmitSound("lockjaw_Courier.gold")
        print("team " .. attacker_team .. " get bonus " .. bonus)
        hero1:ModifyGold(bonus, false, 0);
		self:UpdatePlayerStat(hero1);
    end
    
    --local bonus = GameRules.Definitions.Uname2Cost[attacker:GetUnitName()] * GameRules.Definitions.UnitBonusRate;
	
	--亡语
	--DeathRattle(u,attacker)

	--进坟场
	

	
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

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
        print("hero selection")
        for nPlayerNumber = 0, DOTA_MAX_TEAM_PLAYERS do
			Timers:CreateTimer(0,function()
				local hPlayer = PlayerResource:GetPlayer(nPlayerNumber)
				if hPlayer and PlayerResource:IsValidTeamPlayer(nPlayerNumber) then
					hPlayer:MakeRandomHeroSelection()
				end
			end)
		end
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS  then
	
		print("start game")
    elseif nNewState == DOTA_GAMERULES_STATE_POST_GAME then
        print('post game')
    
	end
end

function WhoToAttack:HandleCommand(keys)
	--DeepPrintTable(keys)
	
	
	local player = PlayerResource:GetPlayer(keys.playerid)
    local hero = player:GetAssignedHero();
	
	
	
    if hero == nil then
        return
    end
	
	local heroindex = hero:GetEntityIndex()
	local team = hero:GetTeam()
	local tokens =  string.split(string.lower(keys.text))

	
	print(tokens[1]);
	
	if tokens[1] == '-dialog' then
		dialog_manager:FireDialogEvent()
	end
	if tokens[1] == '-cp' then
	
	end
    
    if tokens[1] == '-report' then
        self:ReportEndInfo()
    end
    
    if tokens[1] == '-end' then
        self:DoPlayerDie(hero);
        --self:EndGame(DOTA_TEAM_BADGUYS)
        --self:DoPlayerDie(hero);
    end
    
    if tokens[1] == '-http' then
        SendHttpGet("abc");
    end
	
	if tokens[1] == '-top' then
		local idx = 1
        if tokens[2] ~= nil then
            idx = tokens[2]
        end
		self:TopCertainAbility(hero,tonumber(idx))
	end
	
	if tokens[1] == '-shijian' then
		local eid = 1
        if tokens[2] ~= nil then
            eid = tokens[2]
        end
		WtaEncounters:handleOneEncounter(hero, tonumber(eid))
	end
    
    if tokens[1] == '-upskill' then
        local stype = "evil"
        if tokens[2] ~= nil then
            stype = tokens[2]
        end
        self:UpgradeBuildSkill(hero, stype)
    end
	
	if tokens[1] == '-clear' then
        
        WtaThrones:ClearScore(team)
    end
    
    if tokens[1] == '-draw' then
        
        self:DrawCards(team)
        
    end
    
    if tokens[1] == '-pick' then
        
        if tokens[2] ~= nil then
            self:PickCard(team, tonumber(tokens[2]))
        end
    end
    
    if tokens[1] == '-del' then
        if tokens[2] ~= nil then
            self:DelBuildSkill(hero,tonumber(tokens[2]))
        end
    end
    
    if tokens[1] == '-trydel' then
        CustomGameEventManager:Send_ServerToPlayer(player, "player_remove_ability", {});
    end
    
    if tokens[1] == '-exp' then
        hero:AddExperience(10,0,false,false)
    end
    
    if tokens[1] == '-score' then
        WtaThrones:AddScore(1,6)
    end
    
    if tokens[1] == 'add_money' then
        
        local data = {
            [1] = {money = 10},
            [2] = {money = 20}
        }
        
        msg.bottom('nmsl nsl', keys.playerid, 1)
        
        CustomNetTables:SetTableValue( "player_info_table", "player_info", { data = data, hehe = RandomInt(1,100000)})

        
    end

	--测试命令
	if string.find(keys.text,"^e%w%w%w$") ~= nil then
		if hero.effect ~= nil then
			hero:RemoveAbility(hero.effect)
			hero:RemoveModifierByName('modifier_texiao_star')
		end
		hero:AddAbility(keys.text)
		hero:FindAbilityByName(keys.text):SetLevel(1)
		hero.effect = keys.text
	end
	
end

function WhoToAttack:OnPickCard(keys)
    local idx = keys.card_idx
    
    local hero = PlayerManager:getHeroByPlayer(keys.PlayerID)
    if not hero then
	--不发送了 完全崩溃了
        return
    end
    
	local player = PlayerResource:GetPlayer(keys.PlayerID)
    local ret = GameRules:GetGameModeEntity().WhoToAttack:PickCard(hero:GetTeam(), tonumber(idx))
    
    CustomGameEventManager:Send_ServerToPlayer(player, "pick_cards_rsp", {ret = ret, buy_idx = idx});
    --PickCard();
end

function WhoToAttack:OnChooseEncounter(keys)
	local eidx = tonumber(keys.eidx);
	
	local hero = PlayerManager:getHeroByPlayer(keys.PlayerID)
	local ret = false;
	
	if not eidx then
		return false
	end
	
	if hero and hero.cur_encounters then
		if eidx > 0 and eidx <= #hero.cur_encounters then
			ret = WtaEncounters:handleOneEncounter(hero, hero.cur_encounters[eidx])
			if ret == true then	
				hero.cur_encounters = {};
			end
		end
	end
	CustomGameEventManager:Send_ServerToTeam(hero.team, "ChooseEncounterRsp", {ret = ret});
end


function WhoToAttack:OnDrawCards(keys)
    local hero = PlayerManager:getHeroByPlayer(keys.PlayerID)
    if hero:GetGold() < GameRules.Definitions.CardRedrawCost then
        msg.bottom('金钱不足', keys.PlayerID)
        return
    end
    local err = GameRules:GetGameModeEntity().WhoToAttack:DrawCards(hero:GetTeam());
    
    if not err then
    	hero:ModifyGold(-GameRules.Definitions.CardRedrawCost, false, 0);
    end
    
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    CustomGameEventManager:Send_ServerToPlayer(player, "lock_cards_rsp", {locked = false});
	
	hero:EmitSound("Item.PickUpRecipeWorld")
end

function WhoToAttack:OnLockCards(keys)
    local locked = keys.locked
    local player = PlayerResource:GetPlayer(keys.PlayerID)
	local hero = PlayerManager:getHeroByPlayer(keys.PlayerID)
	if WhoToAttack:LockCard(hero.team, locked) then
		CustomGameEventManager:Send_ServerToPlayer(player, "lock_cards_rsp", {locked = locked});
	end
end

function WhoToAttack:OnConfirmRemoveAbility(keys)
    local idx = keys.AbilityIdx
    local hero = PlayerManager:getHeroByPlayer(keys.PlayerID)
    
    GameRules:GetGameModeEntity().WhoToAttack:DelBuildSkill(hero, tonumber(idx)+1)
end

function WhoToAttack:DamageFilter(damageTable)
    if not damageTable.entindex_attacker_const and damageTable.entindex_victim_const then return true end

    local attacker = EntIndexToHScript(damageTable.entindex_attacker_const)
    local victim = EntIndexToHScript(damageTable.entindex_victim_const)

    -- 处理硬化技能
    -- if victim:HasAbility('yinghua') then
        -- if victim:HasModifier('modifier_skeleton_king_reincarnation_scepter_active') or 
            -- victim:HasModifier('modifier_skeleton_king_reincarnation_scepter') then
            -- return true
        -- else
            -- if not damageTable.entindex_inflictor_const then
                -- local ability = victim:FindAbilityByName('yinghua')
                -- local damage_block = ability:GetSpecialValueFor('damage_block')
                -- local damage_min = ability:GetSpecialValueFor('damage_min')
                -- if damageTable.damage > damage_min then
                    -- damageTable.damage = math.max(damageTable.damage - damage_block, damage_min )
                -- end
            -- end
        -- end
    -- end
    return true
end

function WhoToAttack:OnPlayerGainedLevel(keys)
    
    local hero = PlayerManager:getHeroByPlayer(keys.player_id)
    
    if not hero then
        print("cnm mei hero")
        return
    end
    hero:SetAbilityPoints(0)
    local nowMana = hero:GetMana();
    local nowMaxMana = hero:GetMaxMana();
    local growModifier = hero:FindModifierByName("modifier_builder_growth")
    growModifier:SetStackCount(hero:GetLevel());
    
    Timers:CreateTimer(0.01, function()
        local maxManaDiff = hero:GetMaxMana() - nowMaxMana;
        hero:SetMana(nowMana + maxManaDiff);
        --hero:SetMana(1000)
        print("max mana "..hero:GetMaxMana())
        print("mana diff " .. maxManaDiff);
    end)
    
    
    
	-- for i = 6, 13 do
		-- GameRules:GetGameModeEntity().population_max[i] = GetMaxChessCount(i)
		
		-- local hero = TeamId2Hero(i)

		-- if hero ~= nil then 

		-- end


	-- end
end




function WhoToAttack:OnKeing(keys)
    local player_id = keys.PlayerID
    local url = GameRules.Definitions.LogicUrls[keys.event];
    if not url then
        msg.bottom("逻辑异常", player_id, 1);
        return;
    end
    
    
    
    if keys.user_specific == 1 then
        url = url..'/@'..PlayerManager.playerid2steamid[player_id]
    end
    
    for i,v in pairs(keys.params) do
        url = url..'&'..i..'='..v
    end

    url = url.."&key="..GetDedicatedServerKey('nmsl')
    
    Timers:CreateTimer(RandomFloat(0,1),function()
			-- print(send_url)
			HttpUtils:SendHTTP(url,function(t)
				-- DeepPrintTable(t)
				-- CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id),'send_http_cb',{
					-- key = GetClientKey(GameRules:GetGameModeEntity().playerid2team[player_id]),
					-- event = keys.cb,
					-- data = json.encode(t),
				-- })
                print('success');
                DeepPrintTable(t)
                
			end)
	    end)
    
end

function WhoToAttack:InitTinyBornPlace()
    -- 将对应队伍的出生点放到随机的位置去
    local playerStarts = Entities:FindAllByClassname("info_player_start_dota")
    for _, start in pairs(playerStarts) do
        if start:GetTeamNumber() >= DOTA_TEAM_CUSTOM_1 or start:GetTeamNumber() <= DOTA_TEAM_CUSTOM_8 then
            start:SetOrigin(GameRules.Definitions.TeamTinyPos[start:GetTeamNumber()]);
        end
    end
end

function Activate()
	GameRules:GetGameModeEntity().WhoToAttack = WhoToAttack()
	GameRules:GetGameModeEntity().WhoToAttack:InitGameMode()
end

function WhoToAttack:InitGameMode()
    
    
	PlayerManager:init()
	
    self.game_id = "";
	self.teamNum = 8;
	self.numPerTeam = 1;
    self.stage = 0;
	self.player_stat = {}
	
    GameRules:GetGameModeEntity():SetThink("OnThink", self, 0)
    
    GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetHeroSelectionTime(0)
  	GameRules:SetStrategyTime(0)
  	GameRules:SetShowcaseTime(0)
    
    
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 1 );
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 1 );
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3, 1 );
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_4, 1 );
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_5, 1 );
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_6, 1 );
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_7, 1 );
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_8, 1 );
	
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 0 );
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 );
	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 255, 0, 0 }	--		red
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2]  = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 197, 77, 168 }	--      Pink
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 255, 108, 0 }		--		Orange
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 52, 85, 255 }		--		Blue
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 101, 212, 19 }	--		Green
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 129, 83, 54 }		--		Brown
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--		purple


	for team = 0, (DOTA_TEAM_COUNT-1) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	for nPlayerID = 0, PlayerResource:GetPlayerCount() do
		self:UpdatePlayerColor( nPlayerID )
	end
    
    

    
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap( WhoToAttack, 'OnGameRulesStateChange' ), self );
	ListenToGameEvent("dota_player_pick_hero",Dynamic_Wrap(WhoToAttack,"OnPlayerPickHero"),self)
	ListenToGameEvent("player_connect_full", Dynamic_Wrap(WhoToAttack,"OnPlayerConnectFull" ),self)
	ListenToGameEvent("player_disconnect", Dynamic_Wrap(WhoToAttack, "OnPlayerDisconnect"), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(WhoToAttack, "OnEntityKilled"), self)
	--ListenToGameEvent("player_chat",Dynamic_Wrap(WhoToAttack,"HandleCommand"),self)
    ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(WhoToAttack,"OnPlayerGainedLevel"), self)
    
    CustomGameEventManager:RegisterListener("PickCard",Dynamic_Wrap(WhoToAttack, 'OnPickCard'))
    CustomGameEventManager:RegisterListener("ConfirmAbilityRemove",Dynamic_Wrap(WhoToAttack, 'OnConfirmRemoveAbility'))
    CustomGameEventManager:RegisterListener("lock_cards_req",Dynamic_Wrap(WhoToAttack, 'OnLockCards'))
    CustomGameEventManager:RegisterListener("draw_cards_req",Dynamic_Wrap(WhoToAttack, 'OnDrawCards'))
    
	CustomGameEventManager:RegisterListener("ChooseEncounterReq",Dynamic_Wrap(WhoToAttack, 'OnChooseEncounter'))
    
    
	
    
    --出生点初始化
    Timers:CreateTimer(1, function()
        self:InitTinyBornPlace()
    end)
    
    GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(WhoToAttack, "DamageFilter"), self)
    
    GameRules:SetUseUniversalShopMode(true);
    GameRules:SetHeroRespawnEnabled( false )
    GameRules:SetGoldTickTime(0)
    GameRules:SetGoldPerTick(0)
    GameRules:SetStartingGold(7)
	GameRules:GetGameModeEntity():SetFogOfWarDisabled(true);
    GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled(false)
    GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)
    
    
	
	self.battle_round = 0
	self.is_game_ended =false
	
	
	GameRules:GetGameModeEntity().team2playerid = {}
	GameRules:GetGameModeEntity().playerid2team = {}
	
	
	
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
	
    self.field_base = {
        [6] = nil,
        [7] = nil,
        [8] = nil,
        [9] = nil,
        [10] = nil,
        [11] = nil,
        [12] = nil,
        [13] = nil,
    }
    
	self.thrones = {
    	[1] = {},
		[2] = {},
		[3] = {},
		[4] = {},
		[5] = {},
		[6] = {},
	}
    self.open_door_list = {}
	self.to_be_destory_list = {
        [1] = {},
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
	
	self.battle_field_list = {
        [6] = {idx = 6, is_open = true},
		[7] = {idx = 7, is_open = true},
		[8] = {idx = 8, is_open = true},
		[9] = {idx = 9, is_open = true},
		[10] = {idx = 10, is_open = true},
		[11] = {idx = 11, is_open = true},
		[12] = {idx = 12, is_open = true},
		[13] = {idx = 13, is_open = true},
    }

	self.card_pool = {
		[1] = {},
		[2] = {},
		[3] = {},
		[4] = {},
		[5] = {},
        [6] = {},
        [7] = {},
        [8] = {},
	}
    GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
    GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(GameRules.Definitions.MaxLevel)
    GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(GameRules.Definitions.HeroExpTable)
end



function WhoToAttack:findEmptyAbility(hero)
	local ability = nil
	for i = 0, GameRules.Definitions.MaxBuildSkill-1 do
		ability = hero:GetAbilityByIndex(i)
		if ability then
			local name = ability:GetAbilityName()
			if name == "empty1"
				or name == "empty2"
			    or name == "empty3"
			    or name == "empty4"
			    or name == "empty5"
                or name == "empty6"
                or name == "empty7"
                or name == "empty8"
			   then
				return name
			end
		end
	end
	return nil
end


function WhoToAttack:GiveItem(hero, item_name)
    if not item_name then
        return;
    end
    local has_enemy_slot = false
    for slot=0,5 do
        if hero:GetItemInSlot(slot) == nil or (hero:GetItemInSlot(slot):GetAbilityName() == item_name and hero:GetItemInSlot(slot):IsStackable()) then
            has_enemy_slot = true
        end
    end
    if has_enemy_slot == true then
        hero:AddItemByName(item_name)
    else
        self:DropItemAppointed(item_name, hero, hero)
    end
end

function WhoToAttack:DropItemAppointed(item_name, owner, center_unit)
    if center_unit == nil or center_unit:IsNull() == true or center_unit:GetAbsOrigin() == nil then
		center_unit = owner
	end
	local newItem = CreateItem( item_name, owner, owner )
	local drop = CreateItemOnPositionForLaunch(center_unit:GetAbsOrigin(), newItem )
	local dropRadius = RandomFloat( 10, 100 )
	
	newItem:LaunchLootInitialHeight( false, 0, 200, 0.75, center_unit:GetAbsOrigin() + Vector(RandomFloat( -100, 100 ),RandomFloat( -100, 100 ),0))
end

function WhoToAttack:ChangeBaseModel(hero, model_name)
    
	hero.base_model = model_name;
	local base = hero.base;
	if not base or base:IsNull() then
		return
	end
    
    if model_name == nil or model_name == "" then
        model_name = base.origin_model;
    end
    if not model_name then
        return --"models/props_structures/rock_golem/tower_radiant_rock_golem.vmdl";
    end
    
	if base:IsAlive() then
		base:SetModel(model_name);
		base:SetOriginalModel(model_name);
	end
end

function WhoToAttack:ChangeThrowEffect(hero, throw_effect)
	hero.throw_effect = throw_effect;
end

function GetBuildSkillName(unitName)
    return "build_" .. unitName
end

function YinshenExtraDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local damage = 10
	local damageTable = {
    	victim=target,
    	attacker=caster,
    	damage_type = DAMAGE_TYPE_PHYSICAL,
    	damage=damage
    }
    ApplyDamage(damageTable)
end

function AddMaxHP(keys)
	local caster = keys.caster
	local target = keys.target
	local hp = keys.hp
	
	local hp1 = target:GetMaxHealth()
	
	hp1 = hp1 + tonumber(hp)
	
	
	target:SetBaseMaxHealth(hp1)
	target:SetMaxHealth(hp1)
	target:SetHealth(hp1)
	
end

function Modifier_ChangeBaseHp(keys)
	local target = keys.target
	local modHp = keys.modHp
	GameRules:GetGameModeEntity().WhoToAttack:ModifyBaseHP(target, modHp)
end

function Modifier_GiveMana(keys)
	local target = keys.target
	if not target then
		target = keys.caster;
	end
	local mana = keys.mana
	target:GiveMana(mana);
end

function Action_DrawCard(keys)
	local hero = keys.caster;
	if hero == nil or not hero:IsAlive() then
		return
	end
	GameRules:GetGameModeEntity().WhoToAttack:DrawCards(hero.team);
end

function Setmodel_Chicken(keys)
        local unit = keys.target;
        unit:SetModel("models/items/courier/mighty_chicken/mighty_chicken.vmdl");
        

end

function RemoveOriginalWearables(keys)
        local unit = keys.target;
	for i, v in pairs(unit:GetChildren()) do
		if v:GetClassname() == 'dota_item_wearable' then
			v:RemoveSelf()
		end
	end
end

function Action_SpawnRandomLv5(keys)
	local hero = keys.caster;
	if hero == nil or not hero:IsAlive() then
		return
	end
	
    local level5units = GameRules.Definitions.CardListByCost[5];
	if not level5units then
		return
	end
	
	local rand = RandomInt(1,#level5units)
	local unitName = level5units[rand];
    GameRules:GetGameModeEntity().WhoToAttack:CreateUnit(hero.team, hero:GetAbsOrigin(),unitName,false);
end

function Action_SpawnTiny(keys)
	local hero = keys.caster;
	if hero == nil or not hero:IsAlive() then
		return
	end  
	--GameRules.Definitions.
     local newyUnit = GameRules:GetGameModeEntity().WhoToAttack:CreateUnit(hero.team, hero:GetAbsOrigin(),"tiny_illusion",spe);
end

function Action_AddBaseFeature(keys)
	local hero = keys.caster;
    --local featureId = keys.featureId;
    

	if hero == nil or not hero:IsAlive() then
		return
	end  
    local base = hero.base;
    if not base or not base:IsAlive() then
        return
    end
    -- if not featureId then
        -- return
    -- end
	--local fname = GameRules.Definitions.JidiFeatures[featureId];
    local newAbility = base:AddAbility("SnowAura");
    if newAbility then
        newAbility:SetLevel(1);
    end
end

function Action_AddFireBaseFeature(keys)
	local hero = keys.caster;
    --local featureId = keys.featureId;
    

	if hero == nil or not hero:IsAlive() then
		return
	end  
    local base = hero.base;
    if not base or not base:IsAlive() then
        return
    end
    -- if not featureId then
        -- return
    -- end
	--local fname = GameRules.Definitions.JidiFeatures[featureId];
    local newAbility = base:AddAbility("FireAura");
    if newAbility then
        newAbility:SetLevel(1);
    end
end

function Action_AddModelBaseFeature(keys)
	local hero = keys.caster;
    --local featureId = keys.featureId;
    

	if hero == nil or not hero:IsAlive() then
		return
	end  
    local base = hero.base;
    if not base or not base:IsAlive() then
        return
    end
    -- if not featureId then
        -- return
    -- end
	--local fname = GameRules.Definitions.JidiFeatures[featureId];
    local newAbility = base:AddAbility("ModelAura");
    if newAbility then
        newAbility:SetLevel(1);
    end
end

function Action_AddBlinkBaseFeature(keys)
	local hero = keys.caster;
    --local featureId = keys.featureId;
    

	if hero == nil or not hero:IsAlive() then
		return
	end  
    local base = hero.base;
    if not base or not base:IsAlive() then
        return
    end
    -- if not featureId then
        -- return
    -- end
	--local fname = GameRules.Definitions.JidiFeatures[featureId];
    local newAbility = base:AddAbility("BlinkAura");
    if newAbility then
        newAbility:SetLevel(1);
    end
end

--fuck with logic server

function WhoToAttack:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end
	return color
end

function WhoToAttack:UpdatePlayerColor( nPlayerID )
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end

function WhoToAttack:SendStartGameReq()
	
	if PlayerManager:GetPlayingPlayerCount() == 0 then
		Timers:CreateTimer(30,function()
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)				
		end)
		return
	end
	local url = "";
	-- HttpUtils:SendHTTPPost(url, {}, function(t)
	
	-- end, function(t)
	
	-- end);
    
    -- Timers:CreateTimer(3,function()
        
        
        -- self:OnStartGameReqSuccess();
    -- end)
	
	local steamids = {}
	for _,hero in pairs(PlayerManager.heromap) do
		local pid = hero:GetPlayerID()
		local steam_id = PlayerManager:GetSteamIdByPid(pid)
		table.insert(steamids, {steam_id = steam_id})
    end
	
    --拼接要向服务器发送的steamid数据
	-- for pid,sid in pairs(PlayerManager.playerid2steamid) do
		-- if PlayerResource:GetTeam(pid) >= 6 and PlayerResource:GetTeam(pid) <= 13 then
			-- table.insert(GameRules:GetGameModeEntity().send_status,sid)
			-- GameRules:GetGameModeEntity().upload_detail_stat[sid] = {}
			-- if GameRules:GetGameModeEntity().playerid2hero[pid] ~= nil then
				-- if GameRules:GetGameModeEntity().steamidlist == '' then
					-- GameRules:GetGameModeEntity().steamidlist = sid
					-- GameRules:GetGameModeEntity().steamidlist_heroindex = sid..'_'..GameRules:GetGameModeEntity().playerid2hero[pid]:entindex()
				-- else
					-- GameRules:GetGameModeEntity().steamidlist = GameRules:GetGameModeEntity().steamidlist..','..sid
					-- GameRules:GetGameModeEntity().steamidlist_heroindex = GameRules:GetGameModeEntity().steamidlist_heroindex..','..sid..'_'..GameRules:GetGameModeEntity().playerid2hero[pid]:entindex()
				-- end
				-- if PlayerResource:HasCustomGameTicketForPlayerID ( pid ) == true then
					-- GameRules:GetGameModeEntity().steamidlist_heroindex = GameRules:GetGameModeEntity().steamidlist_heroindex..'_vip'
				-- end
			-- end
		-- end
	-- end
    
    
	
	local info_json = JSON:encode({data = steamids})
	print(info_json)
    local url = GameRules.Definitions.LogicUrls['info']
    
    
    if url then
        HttpUtils:SendHTTPPost(url, {data = steamids}, function(t)
            
           -- data                            	= table: 0x002ef828 (table)
           -- {
              -- list                            	= table: 0x0030db48 (array table)
              -- [
                 -- 1                               	= table: 0x0030db70 (table)
                 -- {
                    -- client_basic_info               	= table: 0x00336758 (table)
                    -- {
                       -- steam_id                        	= "76561198063208676" (string)
                       -- score                           	= 0 (number)
                    -- }
                 -- }
              -- ]
           -- }
            
            if t.data then
                self.game_id = t.data.game_id
                self:OnStartGameReqSuccess(t.data.list)
            else
                self:OnStartGameReqSuccess(nil)
            end
            
        end, function(errno)
            print('info fail')
            if errno == -1 then
                self:OnNetError();
            end
			
			--继续游戏
			self:OnStartGameReqSuccess()
        end)
    end
end

function WhoToAttack:OnStartGameReqSuccess(data)
    
	local fakeData = '{"data":[{"steam_id":"76561198063208676","client_econ_info":{"coin_1":5,"coin_2":3,"decoration_info":[{"use_status":1,"decoration":{"decoration_id":1001}}]}}]}'
	local fakeDataTable = JSON:decode(fakeData)
	-- DeepPrintTable(fakeDataTable);
    --start game with shipin for each player
    
	if data then
        for _,v in pairs(data) do
            local steam_id = v.client_basic_info.steam_id
            GameRules.EconManager:InitPlayerEconInfo(steam_id, v.client_econ_info);
        end
    end
	
	
	
	
    --初始化设置
    
    --初始化卡池
    --初始化分数信息，放进nettable 客户端显示
    self:StartGame();

end

function WhoToAttack:OnStartGameReqFail()
    self:StartGame();
end

function WhoToAttack:ReportEndInfo()

	local reportInfo = {}
	for _,hero in pairs(PlayerManager.heromap) do
		
		local coinGain = 0
		if hero.ranking then 
			coinGain = GameRules.Definitions.RankingCoinReward[hero.ranking] or 0;
		end
		
        if not hero.ranking then
            hero.ranking = -1;
        end
        
		local pid = hero:GetPlayerID()
		local steam_id = PlayerManager:GetSteamIdByPid(pid)
		table.insert(reportInfo, {steam_id = tostring(steam_id), team = hero.team, rank = -1, coin_diff = coinGain, score_diff = 0})
    end
    
    local url = GameRules.Definitions.LogicUrls['report']
    print('end game game id ' .. self.game_id)
    if url then
        HttpUtils:SendHTTPPost(url, {game_id = self.game_id, report_detail = reportInfo}, function(t)
            DeepPrintTable(t)
        end, function(errno)
            print('report fail ' .. errno)
        end);
    end

	local sssstr = JSON:encode(reportInfo)
	
end

function WhoToAttack:OnNetError()
    print('net error');
    msg.bottom('服务器之神嗝屁了',nil,3);
end
