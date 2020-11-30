if GameRules.Definitions == nil then
	GameRules.Definitions = {}
    GameRules.Definitions.StageCount = 4;
	GameRules.Definitions.StageName = {"PREPARE", "PREFIGHT", "FIGHTING", "NEWROUND"}
	GameRules.Definitions.StageTime = {10, 10, 7000, 6}
    GameRules.Definitions.TeamCenterPos = {
	    [6] = Vector(-4735,4735,128),
		[7] = Vector(127,4735,128),
		[8] = Vector(4991,4735,128),
		[9] = Vector(-4735,-127,128),
		[10] = Vector(4991,-127,128),
		[11] = Vector(-4735,-4991,128),
		[12] = Vector(127,-4991,128),
		[13] = Vector(4991,-4991,128),
    }
    GameRules.Definitions.TeamTinyPos = {
	    [6] = Vector(-4735,2687,128),
		[7] = Vector(127,2687,128),
		[8] = Vector(4991,2687,128),
		[9] = Vector(-4735,-2175,128),
		[10] = Vector(4991,-2175,128),
		[11] = Vector(-4735,-7040,128),
		[12] = Vector(127,-7040,128),
		[13] = Vector(4991,-7040,128),
    }
    GameRules.Definitions.MaxBuildSkill = 8
    
    
    GameRules.Definitions.UnitConfigs = {
        [1] = {
            name = "evil_skeleton"
            },
        [2] = {
            name = "nature_ursa"
            },
        [3] = {
            name = "hidden_drow"
            },
        [4] = {
            name = "brwan_ogre"
            },
        [5] = {
            name = "vibrant_dk"
            },
        [6] = {
            name = "brwan_tusk"
            },
        [7] = {
            name = "wizard_lich"
            },
        [8] = {
            name = "hidden_ls"
            },
        [9] = {
            name = "nature_viper"
            },
        [10] = {
            name = "brwan_centaur"
            },
        [11] = {
            name = "test_monster"
            },
    }
    
    
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
    
    GameRules.Definitions.ThroneCnt = 6;
    
    GameRules.Definitions.MaxLevel = 16
    
    GameRules.Definitions.DrawLevelGailv = {
        [1] = {100,100,100, 100, 100,100},
        [2] = {90,100,100, 100, 100,100},
        [3] = {30,50,70, 80, 90,100},
        [4] = {30,50,70, 80, 90,100},
        [5] = {30,50,70, 80, 90,100},
        [6] = {30,50,70, 80, 90,100},
        [7] = {30,50,70, 80, 90,100},
        [8] = {30,50,70, 80, 90,100},
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
    
    GameRules.Definitions.UnitAbilityMap = {
		evil_skeleton = 'cm_mana_aura',
		nature_ursa = 'axe_berserkers_call',
		hidden_drow = 'dr_shooter_aura',
	}
end