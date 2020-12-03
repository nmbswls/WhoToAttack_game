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
        [12] = {
            name = "wizard_zeus"
            },
        [13] = {
            name = "vibrant_warlock"
            },
        [14] = {
            name = "nature_wolf"
            },
        [15] = {
            name = "hidden_riki"
            },
        [16] = {
            name = "evil_clinkz"
            },
        [17] = {
            name = "vibrant_techies"
            },
        [18] = {
            name = "evil_underlord"
            },
        [19] = {
            name = "wizard_leshrac"
            },
        [20] = {
            name = "brwan_siege"
            },
        [21] = {
            name = "nature_enchantress"
            },
        [22] = {
            name = "wizard_furion"
            },
        [23] = {
            name = "evil_abaddon"
            },
        [24] = {
            name = "vibrant_huskar"
            },
        [25] = {
            name = "nature_bear"
            },
        [26] = {
            name = "brwan_tidehunter"
            },
        [27] = {
            name = "vibrant_alchemist"
            },
        [28] = {
            name = "evil_dazzle"
            },
        [29] = {
            name = "hidden_ta"
            },
        [30] = {
            name = "wizard_lion"
            },
        [31] = {
            name = "hidden_pa"
            },
        [32] = {
            name = "vibrant_earthshaker"
            },
        [33] = {
            name = "wizard_jakiro"
            },
        [34] = {
            name = "evil_sf"
            },
        [35] = {
            name = "brwan_axe"
            },
        [36] = {
            name = "nature_treant"
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
        [11] = "test_monster",
        [12] = "wizard_zeus",
        [13] = "vibrant_warlock",
        [14] = "nature_wolf",
        [15] = "hidden_riki",
        [16] = "evil_clinkz",
        [17] = "vibrant_techies",
        [18] = "evil_underlord",
        [19] = "wizard_leshrac",
        [20] = "brwan_siege",
        [21] = "nature_enchantress",
        [22] = "wizard_furion",
        [23] = "evil_abaddon",
        [24] = "vibrant_huskar",
        [25] = "nature_bear",
        [26] = "brwan_tidehunter",
        [27] = "vibrant_alchemist",
        [28] = "evil_dazzle",
        [29] = "hidden_ta",
        [30] = "wizard_lion",
        [31] = "hidden_pa",
        [32] = "vibrant_earthshaker",
        [33] = "wizard_jakiro",
        [34] = "evil_sf",
        [35] = "brwan_axe",
        [36] = "nature_treant",
    }
    GameRules.Definitions.ChessPoolSize = 6
    
    
    GameRules.Definitions.MaxCost = 6
    
    GameRules.Definitions.CardListByCost = {
        [1] = {"evil_skeleton","nature_ursa","hidden_drow","brwan_tusk","wizard_zeus","vibrant_warlock"},
        [2] = {"vibrant_dk","wizard_lich","nature_wolf","hidden_riki","evil_clinkz","brwan_ogre"},
        [3] = {"hidden_ls","nature_viper","vibrant_techies","evil_underlord","wizard_leshrac","brwan_siege"},
        [4] = {"hidden_pa","vibrant_earthshaker","wizard_jakiro","evil_sf","brwan_axe","nature_treant"},
        [5] = {"brwan_centaur","nature_enchantress","wizard_furion","evil_abaddon","vibrant_huskar"},
        [6] = {"nature_bear","brwan_tidehunter","vibrant_alchemist","evil_dazzle","hidden_ta","wizard_lion"},
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
    GameRules.Definitions.ThronePos = {
        [1] = Vector(-511,127,128),
        [2] = Vector(-511,-384,128),
        [3] = Vector(767,127,128),
        [4] = Vector(767,-384,128),
        [5] = Vector(127,384,128),
        [6] = Vector(127,-640,128),
    }
    
    GameRules.Definitions.MaxLevel = 30;
    GameRules.Definitions.HeroExpTable = {
			[1] = 0,
			[2] = 10,
			[3] = 22,
			[4] = 36,
			[5] = 52,
			[6] = 70,
			[7] = 90,
			[8] = 112,
			[9] = 136,

			[10] = 162,
			[11] = 190,
			[12] = 220,
			[13] = 252,
			[14] = 286,
			[15] = 322,
			[16] = 360,
			[17] = 400,
			[18] = 442,
			[19] = 486,
			[20] = 532,
			[21] = 580,
			[22] = 630,
			[23] = 682,
			[24] = 736,
			[25] = 792,
			[26] = 850,
			[27] = 910,
			[28] = 972,
			[29] = 1036,
			[30] = 1102,
		}
	
    
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
        hidden_drow = 1,
        wizard_zeus = 1,
        brwan_ogre = 2,
        vibrant_dk = 2,
        brwan_tusk = 1,
        wizard_lich = 2,
        hidden_ls = 3,
        nature_viper = 3,
        brwan_centaur = 5,
        vibrant_warlock = 1,
        nature_wolf = 2,
        hidden_riki = 2,
        evil_clinkz = 2,
        vibrant_techies = 3,
        evil_underlord = 3,
        wizard_leshrac = 3,
        brwan_siege = 3,
        nature_enchantress = 5,
        wizard_furion = 5,
        evil_abaddon = 5,
        vibrant_huskar = 5,
        nature_bear = 6,
        brwan_tidehunter = 6,
        vibrant_alchemist = 6,
        evil_dazzle = 6,
        hidden_ta = 6,
        wizard_lion = 6,
        hidden_pa = 4,
        vibrant_earthshaker = 4,
        wizard_jakiro = 4,
        evil_sf = 4,
        brwan_axe = 4,
        nature_treant = 4,
    }
    
    GameRules.Definitions.UnitAbilityMap = {
		evil_skeleton = 'cm_mana_aura',
		nature_ursa = 'axe_berserkers_call',
		hidden_drow = 'dr_shooter_aura',
	}
end
