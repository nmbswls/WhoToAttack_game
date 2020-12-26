if GameRules.Definitions == nil then
	GameRules.Definitions = {}
    GameRules.Definitions.StageCount = 4;
	GameRules.Definitions.StageName = {"PREPARE", "PREFIGHT", "FIGHTING", "NEWROUND"}
	GameRules.Definitions.StageTime = {4, 4, 4, 4}
	GameRules.Definitions.ThrowBaseRange = 1200
	GameRules.Definitions.OpenDoorNumByAlive = {
		[1] = 1,
		[2] = 1,
		[3] = 2,
		[4] = 3,
		[5] = 3,
		[6] = 4,
		[7] = 4,
		[8] = 5,
	}
	
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
    
    GameRules.Definitions.CardRedrawCost = 5 -- 抽卡开销
    GameRules.Definitions.CardPriceRate = 2 --人口为x的卡价格为2x
    GameRules.Definitions.UnitBonusRate = 2 --人口为x的怪死后加多少钱 
	
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
        [37] = {
            name = "hidden_willow"
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
        [37] = "hidden_willow",
    }
    GameRules.Definitions.ChessPoolSize = 8
    
    
    GameRules.Definitions.MaxCost = 8
    
    GameRules.Definitions.CardListByCost = {
        [1] = {"evil_skeleton","nature_ursa","hidden_drow","brwan_tusk","wizard_zeus","vibrant_warlock"},
        [2] = {"vibrant_dk","wizard_lich","nature_wolf","hidden_riki","evil_clinkz","brwan_ogre"},
        [3] = {"hidden_ls","nature_viper","vibrant_techies","evil_underlord","wizard_leshrac","brwan_siege"},
        [4] = {},
        [5] = {"brwan_centaur","nature_enchantress","wizard_furion","hidden_willow","evil_abaddon","vibrant_huskar"},
        [6] = {"nature_bear","brwan_tidehunter","vibrant_alchemist","evil_dazzle","hidden_ta","wizard_lion"},
[7] = {},
    
[8] = {"hidden_pa","vibrant_earthshaker","wizard_jakiro","evil_sf","brwan_axe","nature_treant"},
    
    }
    
    GameRules.Definitions.CardInitCntByCost = {
        [1] = 4,
        [2] = 4,
        [3] = 4,
        [4] = 3,
        [5] = 3,
        [6] = 3,
        [7] = 2,
        [8] = 2,
    }
    
    GameRules.Definitions.ThroneCnt = 6;
	GameRules.Definitions.ThroneConfig = {
		[1] = {
			unit_name = "throne_nature",
			bonus_name = "modifier_bonus_nature"
		},
        [2] = {
			unit_name = "throne_evil",
			bonus_name = "evil_Modifier"
		},
        [3] = {
			unit_name = "throne_hidden",
			bonus_name = "hidden_Modifier"
		},
        [4] = {
			unit_name = "throne_vibrant",
			bonus_name = "vibrant_Modifier"
		},
        [5] = {
			unit_name = "throne_wizard",
			bonus_name = "wizard_Modifier"
		},
        [6] = {
			unit_name = "throne_brawn",
			bonus_name = "brawnAura_Modifier"
		},
	}
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
        [1] = {100,100,100, 100, 100,100,100,100},
        [2] = {90,100,100, 100, 100,100,100,100},
        [3] = {85,100,100, 100, 100,100,100,100},
        [4] = {80,100,100, 100, 100,100,100,100},
        [5] = {70,90,100, 100, 100,100,100,100},
        [6] = {65,85,100, 100, 100,100,100,100},
        [7] = {55,80,100, 100, 100,100,100,100},
        [8] = {45,75,100, 100, 100,100,100,100},
        [9] = {40,75,100, 100, 100,100,100,100},
        [10] = {35,70,95, 95, 100,100,100,100},
        [11] = {30,65,90, 90, 100,100,100,100},
        [12] = {20,60,85, 85, 100,100,100,100},
        [13] = {20,55,82, 82, 100,100,100,100},
        [14] = {15,50,80, 80, 100,100,100,100},
        [15] = {15,45,75, 75, 95,100,100,100},
        [16] = {13,42,73, 73, 93,100,100,100},
        [17] = {10,37,70, 70, 90,100,100,100},
        [18] = {9,34,69, 69, 90,100,100,100},
        [19] = {8,31,64, 64, 88,100,100,100},
        [20] = {7,28,61, 61, 86,99,99,100},
        [21] = {6,24,54, 54, 81,98,98,100},
        [22] = {5,20,48, 48, 78,97,97,100},
        [23] = {5,18,44, 44, 72,95,95,100},
        [24] = {5,15,40, 40, 65,92,92,100},
        [25] = {5,15,39, 39, 63,90,90,100},
        [26] = {5,15,38, 38, 62,88,88,100},
        [27] = {5,15,37, 37, 61,86,86,100},
        [28] = {5,15,35, 35, 59,84,84,100},
        [29] = {4,14,34, 34, 57,82,82,100},
        [30] = {3,12,32, 32, 55,80,80,100},
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
        hidden_willow = 5,
        nature_bear = 6,
        brwan_tidehunter = 6,
        vibrant_alchemist = 6,
        evil_dazzle = 6,
        hidden_ta = 6,
        wizard_lion = 6,
        hidden_pa = 8,
        vibrant_earthshaker = 8,
        wizard_jakiro = 8,
        evil_sf = 8,
        brwan_axe = 8,
        nature_treant = 8,
    }
    
    GameRules.Definitions.UnitAbilityMap = {
		evil_skeleton = 'cm_mana_aura',
		nature_ursa = 'axe_berserkers_call',
		hidden_drow = 'dr_shooter_aura',
	}
end
