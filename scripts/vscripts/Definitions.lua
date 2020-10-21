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
        [1] = "evil_skeleton",
        [2] = "nature_ursa",
        [3] = "hidden_drow",
        [4] = "brwan_ogre",
        [5] = "vibrant_dk",
        [6] = "brwan_tusk",
        [7] = "wizard_lich",
        [8] = "hidden_ls",
        [9] = "nature_viper",
        [10] = "brwan_centaur",
        [11] = "test_monster"
    }
    GameRules.Definitions.ChessPoolSize = 6
    
    
    GameRules.Definitions.MaxCost = 6
    
    GameRules.Definitions.CardListByCost = {
        [1] = {"evil_skeleton","nature_ursa"},
        [2] = {"hidden_drow","brwan_ogre"},
        [3] = {"vibrant_dk","brwan_tusk"},
        [4] = {"wizard_lich","hidden_ls"},
        [5] = {"nature_viper"},
        [6] = {"brwan_centaur"},
    }
    GameRules.Definitions.CardInitCntByCost = {
        [1] = 4,
        [2] = 4,
        [3] = 3,
        [4] = 3,
        [5] = 2,
        [6] = 2,
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
    
    GameRules.Definitions.Uname2Cost = {
        evil_skeleton = 1,
        nature_ursa = 1,
        hidden_drow = 2,
        brwan_ogre = 2,
        vibrant_dk = 3,
        brwan_tusk = 3,
        wizard_lich = 4,
        hidden_ls = 4,
        nature_viper = 5,
        brwan_centaur = 6,
    }
    
    GameRules.Definitions.ChessAbilityMap = {
		evil_skeleton = 'cm_mana_aura',
		nature_ursa = 'axe_berserkers_call',
		hidden_drow = 'dr_shooter_aura',
	}
end