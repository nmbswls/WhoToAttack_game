if GameRules.Definitions == nil then
	GameRules.Definitions = {}
    GameRules.Definitions.StageCount = 4;
	GameRules.Definitions.StageName = {"PREPARE", "PREFIGHT", "FIGHTING", "NEWROUND"}
	GameRules.Definitions.StageTime = {3, 4, 7, 6}
    GameRules.Definitions.TeamCenterPos = {
	    [6] = Vector(0,0,128),
		[7] = Vector(600,0,128),
		[8] = Vector(1200,0,128),
		[9] = Vector(1800,0,128),
		[10] = Vector(2400,0,128),
		[11] = Vector(3000,0,128),
		[12] = Vector(3600,0,128),
		[13] = Vector(4200,0,128),
    }
    
    GameRules.Definitions.UnitNames = {
        [1] = "test_monster",
        [2] = "monster1",
    }
end