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




--配置 存储于GameRules.Definitions
--CHESS_POOL_SIZE      基本卡池大小
--CardListByCost       不同等级的单位列表
--chess_ability_list   单位技能映射表 可多个
--chess_2_mana         各棋子消耗映射

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

--打怪 


require 'utils.msg'
require 'utils'
require 'definitions'
require 'UnitAi'
require 'timers'


LinkLuaModifier("modifier_toss", "lua_modifier/modifier_toss.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_base", "lua_modifier/modifier_base.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hide", "lua_modifier/modifier_hide.lua", LUA_MODIFIER_MOTION_NONE)



if WhoToAttack == nil then
	_G.WhoToAttack = class({})
end

require 'treasure'
require 'throne'


local sounds = {
    "soundevents/game_sounds.vsndevts",
    "soundevents/game_sounds_dungeon.vsndevts",
    "soundevents/game_sounds_dungeon_enemies.vsndevts",
    "soundevents/custom_soundboard_soundevents.vsndevts",
    "soundevents/game_sounds_winter_2018.vsndevts",
    "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts",
    "soundevents/game_sounds_creeps.vsndevts",
    "soundevents/game_sounds_ui.vsndevts",
    "soundevents/game_sounds_items.vsndevts",
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
    
}

function Precache( context )
    print("Precache...")
    for _, v in pairs(sounds) do
        PrecacheResource("soundfile", v, context)
    end
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

    --init player base_pos
    for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
        local pos = GameRules.Definitions.TeamCenterPos[team_i]
        local hero = TeamId2Hero(team_i);
        if hero then
            local newBase = CreateUnitByName("player_jidi", pos, true, nil, nil, team_i)
            hero.base = newBase
            newBase:AddNewModifier(newBase, nil, "modifier_base", {})
            newBase.in_battle_id = team_i
            newBase.turn_attacker = {}
	    newBase.hero = hero
            for i = 1,GameRules.Definitions.ThroneCnt do
                table.insert(self.thrones[i], {team = team_i, score = 0})
            end
        end
        
    end
    
    
    -- local playerStarts = Entities:FindAllByClassname("info_player_start_dota")
    -- for _, pos in pairs(playerStarts) do
    
    -- end
    
    WtaThrones:init(GameRules:GetGameModeEntity().playing_player_count);
    
    self:UpdateThroneInfo()
    
    --5秒后开始游戏
    Timers:CreateTimer(5,function()
        
        print('GAME START!')
        --初始化棋子库
        self:InitCardPool(GameRules:GetGameModeEntity().playing_player_count)
        self.start_time = GameRules:GetGameTime()
        self.battle_round = 1
        self:SetStage(1)
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
    
	--print("count down " .. stageCountdown)
    if self.state == 2 then
        
    end
    
    if(self.stage == 3) then
        
        --20秒之后才开始计算胜负
        
        for team = 6,13 do
            --self:CheckWinLoseForTeam(team)
        end
        
        if self:GetBattleCount() == 0 and stageElapsed >= 3 then
            print("go next??")
            isNext = true;
        else 
            if stageCountdown == 30 then
                --lock all touzhi
                for i,v in pairs(self.heromap) do
                    if IsHeroValid(v) == true then
                        --LockTouzhi(v:GetTeam())
                    end
                end
            end
        end
            
        
        
        if stageCountdown <= 0 then
            for team = 6,13 do
                
                if TeamId2Hero(team) then
                    if not TeamId2Hero(team).is_battle_completed then
                        self:DrawARound(team)
                        TeamId2Hero(team).is_battle_completed = true
                    end
                end
            end
        end
        
    end
    
    
    
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
    end

    if(self.stage == 3) then
        self:RemoveJidiWudi();
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
    end
    
    for team_i=DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
        local hero = TeamId2Hero(team_i);
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
	
    self:AddJidiWudi();
    
    for _,hero in pairs(GameRules:GetGameModeEntity().heromap) do
        if IsHeroValid(hero) == true then
            for _,bonusName in pairs(hero.throne_bonus) do
                hero:RemoveModifierByName(bonusName);
            end
            hero.throne_bonus = {}
        end
    end
    
    
    for i=1,GameRules.Definitions.ThroneCnt do
        local orders = WtaThrones.sortedTeamIdx[i];
        local throne = WtaThrones.throneList[i];
        local ability = throne:FindAbilityByName("throne_give_bonus");
        for idx, tid in pairs(orders) do 
            local hero = GameRules:GetGameModeEntity().teamid2hero[tid];
            if hero then
                local bonusName = "modifier_bonus_" .. string.format("%02d", idx);
                table.insert(hero.throne_bonus, bonusName);
                ability:ApplyDataDrivenModifier(throne, hero, bonusName, {});
            end
        end
    end
    
    
    local allTeam = {}
    for team_i,battle_field in pairs(self.battle_field_list) do
        table.insert(allTeam, team_i);
        battle_field.is_open = false;
    end
    
    if self.battle_round % 3 == 1 then
        self.open_door_list = allTeam
        --self.open_door_list = {}
    elseif self.battle_round % 3 == 2 then
        local shuffled = table.shuffle(allTeam);
        self.open_door_list = {}
        for i = 1, 1 do
            table.insert(self.open_door_list, shuffled[i]);
        end
    else
        local newTeam = {}
        for i = 1, #allTeam do
            if not table.contains(self.open_door_list, allTeam[i]) then
                table.insert(newTeam, shuffled[i])
            end
        end
        self.open_door_list = newTeam
    end
    --print("open list:");
    for i = 1, #self.open_door_list do
        
        local tid = self.open_door_list[i];
        --print("tid " .. tid);
        
        local bf = TeamId2BattleField(tid)
        bf.is_open = true;
        
        CustomGameEventManager:Send_ServerToAllClients("ping_open_doors", {x = GameRules.Definitions.TeamCenterPos[tid].x, y = GameRules.Definitions.TeamCenterPos[tid].y, z = GameRules.Definitions.TeamCenterPos[tid].z})
    end
    
    for i,hero in pairs(GameRules:GetGameModeEntity().heromap) do
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

function WhoToAttack:AddJidiWudi()
	
     for i,hero in pairs(GameRules:GetGameModeEntity().heromap) do
        if IsHeroValid(hero) then
            local jidi = hero.base
            if jidi then
				local ability = jidi:FindAbilityByName('passive_player_jidi')
                if ability then
                    ability:ApplyDataDrivenModifier(jidi, jidi, "modifier_jidi_wudi",
                    {
                        duration = -1,
                    })
                end
            end
        end
    end	
end

function WhoToAttack:RemoveJidiWudi()

	for i,hero in pairs(GameRules:GetGameModeEntity().heromap) do
	if IsHeroValid(hero) then
	    local jidi = hero.base
	    if jidi then

            jidi:RemoveModifierByName("modifier_jidi_wudi");
	    end
	end
	end	
end

function WhoToAttack:StartABattleRound()
    if self.is_game_ended == true then
        return
    end
    
    PostPlayerInfo()
    
    --移除每个场地中的隐身modifier
    for i = DOTA_TEAM_CUSTOM_MIN, DOTA_TEAM_CUSTOM_MAX do
        self:ShowPrepare(i)
        
        --test code
        self:SpawnNeutral(i);
    end
    
    GameRules:SetTimeOfDay(0.3)
    self.game_status = 2 --game_status 2 zhandou zhong
    self.battle_timer = 50

    --ResetAllDeadChessList()
    
    
    
    -- GameRules:GetGameModeEntity().battle_count = 0
    self:InitBattleTable()
end


function WhoToAttack:SpawnNeutral(team)
    
    local pos = GameRules.Definitions.TeamCenterPos[team]

    for i = 1, 3 do
        local unit = self:CreateUnit(3, pos, "evil_skeleton")
        Timers:CreateTimer(0.5, function()
            unit.in_battle_id = team;
        end)
    end
    
end

function WhoToAttack:CanBuildUnits()

    if not self.stage then
        return false
    end
    
    if self.stage == 2 or self.stage == 3 then
        return true
    end
    
    return false
end

function WhoToAttack:CanThrow()

    if not self.stage then
        return false
    end
    
    if self.stage == 2 or self.stage == 3 then
        return true
    end
    
    return false
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

function WhoToAttack:DrawARound(team)

	local hero = TeamId2Hero(team)
	if hero == nil or hero:IsNull() == true or hero:IsAlive() == false then
		return
	end
	
	-- GameRules:GetGameModeEntity().battle_count = GameRules:GetGameModeEntity().battle_count - 1
	self:SetBattleTable(team,false)

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
    local hero = TeamId2Hero(team)
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

function WhoToAttack:GetBattleField(team)

    --to do
end

function WhoToAttack:ModifyBaseHP(hero, hp)
	if hero == nil or hp == nil then
		return
	end
	
	if not hero.base then
		return
	end
	local base = hero.base;
	local nowHp = base:GetHealth();
	if nowHp <= 0 then
		return	
	end
	local newHp = nowHp + hp;
	if newHp < 0 then
		newHp = 0
	end
	
	if newHp == 0 then
		base:ForceKill(false)
		hero:ForceKill(false)
		self:DoPlayerDie(hero)
	else
		base:SetHealth(newHp)
	end

end

function WhoToAttack:DoPlayerDie(hero)
	if hero.dead then
		return
	end
	hero.dead = true;
	
	hero.ranking = self.alive_count;
	
	self.alive_count = self.alive_count - 1;
	
	if self.alive_count == 0 then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end
end

function WhoToAttack:CreateUnit(team, pos, unitName)
    local hero = TeamId2Hero(team)
    --local newyUnit = CreateUnitByName(unitName, pos, true, hero, hero, team)
    local newyUnit = CreateUnitByName(unitName, pos, true, nil, nil, team)
    if newyUnit then
        newyUnit:SetAbsOrigin(pos);
        FindClearSpaceForUnit(newyUnit, pos, true)
        newyUnit.team = team
        
        self:InitUnit(team,newyUnit)
        
        local a = AddAbilityAndSetLevel(newyUnit, "modifier_container",1)
        local ret = a:ApplyDataDrivenModifier(newyUnit, newyUnit,"modifier_test_01",{})
        
        if not ret then
            --print("add modifier fail")
        else
            --print("add modifier suc")
        end
        --add buffs
        -- if hero.buffs then
            
        -- end
        
    end
    
    
    return newyUnit
end

--初始化新刷新的棋子
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
            unit:SetContextThink("OnUnitThink", function() return UnitAI:OnUnitThink(unit) end, 1)
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
        ability = AddBuildSkill(hero, completeSkillName)
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
    RemoveAbility(hero, skillIdx)
    
    table.remove(hero.build_skills, skillIdx)
    hero.build_skill_cnt = hero.build_skill_cnt - 1;
    for i=0,15 do
        local aaa = hero:GetAbilityByIndex(i)
        if aaa then print(i .. " , ".. aaa:GetAbilityName()) end
	end
    print("build list:")
    for i = 1, #hero.build_skills do 
        DeepPrintTable(hero.build_skills[i])
    end
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
    
    if diffx > 500 or diffy > 500 then
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
            print("to destoy: " .. v:GetUnitName())
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
	
	--返回每个阵营的单位数量
	if self.to_be_destory_list[team] ~= nil then
		for p,q in pairs(self.to_be_destory_list[team]) do
			if q:GetUnitName() ~= 'fissure' then
				if q.team_id == team then
					myunit_count = myunit_count + 1
				else
					enemyunit_count = enemyunit_count + 1
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

function WhoToAttack:ShowPrepare(team)
	if self.to_be_destory_list[team] ~= nil then
		for _,ent in pairs(self.to_be_destory_list[team]) do
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

function TeamId2BattleField(id)
	if id == nil then
		return nil
	else
		return GameRules:GetGameModeEntity().WhoToAttack.battle_field_list[id]
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
	local hero = TeamId2Hero(team_id)
	if hero then
		hero.lock_draw = locked
	end
end

function WhoToAttack:DrawCards(team_id, auto_draw)
    
    
	
    local h = TeamId2Hero(team_id)
	
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
    msg.bottom('draw card '..cards, pid)

    -- for _,n in pairs(now_hold_cards) do
        -- print("c: " .. n)
    -- end
    -- print("total: " .. cards)
    
    CustomGameEventManager:Send_ServerToTeam(team_id,"show_cards",{
            hand_cards = now_hold_cards,
        })
    
end


function WhoToAttack:PickCard(team_id, card_idx)
    
    local hero = TeamId2Hero(team_id)
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
        msg.bottom('no enough money', pid, 1)
        return false
    end
    
    
    
    local ret = self:UpgradeBuildSkill(hero, unitName)
    
    if not ret then
        return false
    end
	
    hero:ModifyGold(-cost, true, 0);
    
    print("pick card  " .. unitName)
    hero.now_hold_cards[card_idx] = ""
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
	local hero = TeamId2Hero(team_id)
    
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




--通用方法
function PlayerId2Hero(id)
	return GameRules:GetGameModeEntity().playerid2hero[id]
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
        self:UpgradeBuildSkill(hero,"evil_skeleton")
    end)
    
    
    
	hero:SetMana(0)
	hero:SetStashEnabled(false)

	hero.team = hero:GetTeam()
	hero.team_id = hero:GetTeam()
    hero.can_toss = false;
    hero.is_open = true;
    
    hero.build_skill_cnt = 0
    hero.build_skills = {}
    
    hero.throne_bonus = {}
    
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
    
    --print("player count " .. all_playing_player_count .. "   " .. playercount);
    
	if playercount == all_playing_player_count then
		--InitPlayerIDTable()
		self.alive_count = playercount;
		Timers:CreateTimer(0.1,function()
			--开始
			self:StartGame()
		end)
	end 
	
end



function WhoToAttack:OnPlayerConnectFull(keys)
	--to do 断线重连
	-- prt('[OnPlayerConnectFull] PlayerID='..keys.PlayerID..',userid='..keys.userid..',index='..keys.index)
    
    
	GameRules:GetGameModeEntity().playerid2steamid[keys.PlayerID] = tostring(PlayerResource:GetSteamID(keys.PlayerID))
	GameRules:GetGameModeEntity().steamid2playerid[tostring(PlayerResource:GetSteamID(keys.PlayerID))] = keys.PlayerID
	GameRules:GetGameModeEntity().steamid2name[tostring(PlayerResource:GetSteamID(keys.PlayerID))] = tostring(PlayerResource:GetPlayerName(keys.PlayerID))
	GameRules:GetGameModeEntity().userid2player[keys.userid] = keys.index + 1

	GameRules:GetGameModeEntity().connect_state[keys.PlayerID] = true
	local hero = PlayerId2Hero(keys.PlayerID)
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
    local bonus = GameRules.Definitions.Uname2Cost[attacker:GetUnitName()] * GameRules.Definitions.UnitBonusRate;
	
    print("team " .. attacker_team .. " add money")
    
    local hero1 = GameRules:GetGameModeEntity().teamid2hero[attacker_team];
    if hero1 then
        hero1:ModifyGold(bonus, true, 0);
    end
    
	--亡语
	--DeathRattle(u,attacker)

	--进坟场
	-- AddChess2DeadChessList({
		-- at_team_id = u.at_team_id or u.team_id,
		-- chess_base_name = GetUnitBaseName(u),
		-- items = GetAllItemsInUnits({[1] = u}),
		-- level = u:GetLevel(),
	-- })

	
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
        
        for nPlayerNumber = 0, DOTA_MAX_TEAM_PLAYERS do
                Timers:CreateTimer(0,function()
                    local hPlayer = PlayerResource:GetPlayer(nPlayerNumber)
                    if hPlayer and PlayerResource:IsValidTeamPlayer(nPlayerNumber) then
                        hPlayer:MakeRandomHeroSelection()
					end
			end)
		end
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
    
    if tokens[1] == '-upskill' then
        local stype = "evil"
        if tokens[2] ~= nil then
            stype = tokens[2]
        end
        self:UpgradeBuildSkill(hero, stype)
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
    
    local hero = GameRules:GetGameModeEntity().playerid2hero[keys.PlayerID]
    if not hero then
	--不发送了 完全崩溃了
        return
    end
    
	local player = PlayerResource:GetPlayer(keys.PlayerID)
    local ret = GameRules:GetGameModeEntity().WhoToAttack:PickCard(hero:GetTeam(), tonumber(idx))
    
    CustomGameEventManager:Send_ServerToPlayer(player, "pick_cards_rsp", {ret = ret, buy_idx = idx});
    --PickCard();
end

function WhoToAttack:OnDrawCards(keys)
    local hero = GameRules:GetGameModeEntity().playerid2hero[keys.PlayerID]
    if hero:GetGold() < GameRules.Definitions.CardRedrawCost then
        msg.bottom('money not enough', keys.PlayerID)
        return
    end
    local err = GameRules:GetGameModeEntity().WhoToAttack:DrawCards(hero:GetTeam());
    
    if not err then
    	hero:ModifyGold(-GameRules.Definitions.CardRedrawCost, true, 0);
    end
    
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    CustomGameEventManager:Send_ServerToPlayer(player, "lock_cards_rsp", {locked = false});
end

function WhoToAttack:OnLockCards(keys)
    local locked = keys.locked
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    CustomGameEventManager:Send_ServerToPlayer(player, "lock_cards_rsp", {locked = locked});
end

function WhoToAttack:OnConfirmRemoveAbility(keys)
    local idx = keys.AbilityIdx
    local hero = GameRules:GetGameModeEntity().playerid2hero[keys.PlayerID]
    
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
    
    local hero = GameRules:GetGameModeEntity().playerid2hero[keys.player_id]
    
    
    
    
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

    
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap( WhoToAttack, 'OnGameRulesStateChange' ), self );
	ListenToGameEvent("dota_player_pick_hero",Dynamic_Wrap(WhoToAttack,"OnPlayerPickHero"),self)
	ListenToGameEvent("player_connect_full", Dynamic_Wrap(WhoToAttack,"OnPlayerConnectFull" ),self)
	ListenToGameEvent("player_disconnect", Dynamic_Wrap(WhoToAttack, "OnPlayerDisconnect"), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(WhoToAttack, "OnEntityKilled"), self)
	ListenToGameEvent("player_chat",Dynamic_Wrap(WhoToAttack,"HandleCommand"),self)
    ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(WhoToAttack,"OnPlayerGainedLevel"), self)
    
    CustomGameEventManager:RegisterListener("PickCard",Dynamic_Wrap(WhoToAttack, 'OnPickCard'))
    CustomGameEventManager:RegisterListener("ConfirmAbilityRemove",Dynamic_Wrap(WhoToAttack, 'OnConfirmRemoveAbility'))
    CustomGameEventManager:RegisterListener("lock_cards_req",Dynamic_Wrap(WhoToAttack, 'OnLockCards'))
    CustomGameEventManager:RegisterListener("draw_cards_req",Dynamic_Wrap(WhoToAttack, 'OnDrawCards'))
    
    
    
    
    --出生点初始化
    Timers:CreateTimer(1, function()
        self:InitTinyBornPlace()
    end)
    
    GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(WhoToAttack, "DamageFilter"), self)
    
    GameRules:SetUseUniversalShopMode(true);
    GameRules:SetGoldTickTime(0)
    GameRules:SetGoldPerTick(0)
    GameRules:SetStartingGold(500)
	GameRules:GetGameModeEntity():SetFogOfWarDisabled(true);
    GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled(false)
    GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)
    
    
	GameRules:GetGameModeEntity().playerid2steamid = {}
	
	self.battle_round = 0
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
        [6] = {is_open = true},
		[7] = {is_open = true},
		[8] = {is_open = true},
		[9] = {is_open = true},
		[10] = {is_open = true},
		[11] = {is_open = true},
		[12] = {is_open = true},
		[13] = {is_open = true},
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


function WhoToAttack:MoveUnit(target, pos)


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
	end
    
	target:AddNewModifier(target,nil,"modifier_toss",
	{
		vx = pos.x,
		vy = pos.y,
	})	

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



local function findEmptyAbility(hero)
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

function AddBuildSkill(hero, completeSKillName)
    
	local emptyAbility = findEmptyAbility(hero)
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


function RemoveAbility(hero, skillIdx)
    
    if not hero.build_skills[skillIdx] then
        return
    end
    local abilityName = hero.build_skills[skillIdx].skill_name
    local ability = hero:FindAbilityByName(abilityName)
    
    --s1 s2 s3 s4 e5 e6 e7 e8
    --s1 s2 s4 s3 
    
    local lastFilledSkill = nil
    for i = skillIdx, hero.build_skill_cnt do
        
        if i+1 > GameRules.Definitions.MaxBuildSkill then
            lastFilledSkill = i
            break
        end
        local nextSkillName = hero:GetAbilityByIndex(i):GetAbilityName();
        --local nextSkillName = hero.build_skills[i+1].skill_name;
        if string.find(nextSkillName,'empty') ~= nil then
            lastFilledSkill = i
            break
        end
        
        hero:SwapAbilities(hero.build_skills[i].skill_name, nextSkillName, true, true)
        
    end
    
    local replaceAbilityName = "empty" .. lastFilledSkill
    
    print("last skill name " .. replaceAbilityName)
    
    local replaceAbility = hero:AddAbility(replaceAbilityName)
    replaceAbility:SetLevel(1)
	hero:SwapAbilities(replaceAbilityName,abilityName,true,false)
    
    --remove something
    hero:RemoveAbility(abilityName)
    
end

function GetBuildSkillName(unitName)
    return "build_" .. unitName
end
