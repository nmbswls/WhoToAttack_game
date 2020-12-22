--handle player info here
if PlayerInfoManager == nil then
	PlayerInfoManager = class({})
end

function PlayerInfoManager:init()
	self.team_mode = 1 -- 1 单人 2 多人
	self.player_count = 0
	self.team2playerid = {}
	self.playerid2team = {}
	
	self.heromap = {}
    self.playerid2hero = {}
	self.teamid2hero = {} -- team 对应多个英雄 如果是多人模式得话
	
	self.steamid2playerid = {}
    self.playerid2steamid = {}
    self.steamid2name = {}
	self.userid2player = {}
end

function PlayerInfoManager:getHeroByPlayer(player_id)
	
	return self.playerid2hero[player_id]
end

function PlayerInfoManager:getHeroByTeam(team_id)
	if team_id < 6 or team_id > 13 then
		return nil,nil
	end
	if self.team_mode == 1 then
		return self.teamid2hero[team_id], nil
	else
		return self.teamid2hero[team_id][1], self.teamid2hero[team_id]
	end
end

function PlayerInfoManager:getTeamIdByPlayer(player_id)
	return self.playerid2team[player_id]
end

function PlayerInfoManager:DoEachHero(func)
	
	if not self.heromap then
		return
	end

	for _,hero in pairs(self.heromap) do
		func(hero)
	end
end


function PlayerInfoManager:GetPlayingPlayerCount()
	if self.player_count > 0 then
		return self.player_count
	end
	
	local ingameCnt = 0
	local obCnt = 0
	for player_id,_ in pairs(self.playerid2steamid) do
		if PlayerResource:GetTeam(player_id) >= 6 and PlayerResource:GetTeam(player_id) <= 13 then
			ingameCnt = ingameCnt + 1
		end
		if PlayerResource:GetTeam(player_id) == 1 then
			obCnt = obCnt + 1
		end
	end
	self.player_count = ingameCnt
	self.ob_player_count = obCnt
	
	return player_count

end