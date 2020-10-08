if GameRules.Definitions == nil then
	GameRules.Definitions = {}
    GameRules.Definitions.StageCount = 4;
	GameRules.Definitions.StageName = {"PREPARE", "PREFIGHT", "FIGHTING", "NEWROUND"}
	GameRules.Definitions.StageTime = {3, 4, 7000, 6}
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
    GameRules.Definitions.MaxBuildSkill = 8
    GameRules.Definitions.UnitNames = {
        [1] = "test_monster",
        [2] = "monster1",
    }
    GameRules.Definitions.ChessPoolSize = 6
    GameRules.Definitions.CardListByCost = {
        [1] = {"u01","u02"},
        [2] = {"u03","u04"},
        [3] = {"u05","u06"},
        [4] = {"u07","u08"},
        [5] = {"u09"},
        [6] = {"u10"},
        [7] = {"u11"},
        [8] = {"u12"},
    }
    GameRules.Definitions.CardInitCntByCost = {
        [1] = 4,
        [2] = 4,
        [3] = 3,
        [4] = 3,
        [5] = 2,
        [6] = 2,
        [7] = 1,
        [8] = 1,
    }
    
    GameRules.Definitions.DrawLevelGailv = {
        [1] = 4,
        [2] = 4,
        [3] = 3,
        [4] = 3,
        [5] = 2,
        [6] = 2,
        [7] = 1,
        [8] = 1,
    }
    
    GameRules.Definitions.Uname2Mana = {
        u01 = 1,
        u02 = 1,
        u03 = 2,
        u04 = 2,
        u05 = 3,
        u06 = 3,
        u07 = 4,
        u08 = 4,
        u09 = 5,
        u10 = 6,
        u11 = 7,
        u12 = 8,
    }
    
    GameRules.Definitions.ChessAbilityMap = {
		u01 = 'cm_mana_aura',
		u02 = 'axe_berserkers_call',
		u03 = 'dr_shooter_aura',
	}
end