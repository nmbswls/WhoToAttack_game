if WtaEncounters == nil then
	WtaEncounters = class({})
end
LinkLuaModifier("modifier_add_gold", "lua_modifier/modifier_add_gold.lua", LUA_MODIFIER_MOTION_NONE)
--encounter peizhi

EncountersByTurn = {
    [2] = {
		[1] = {eid = 101, weight = 10},
		[2] = {eid = 301, weight = 3},
		[3] = {eid = 401, weight = 10},
		[4] = {eid = 601, weight = 10},
		[5] = {eid = 701, weight = 10},
		[6] = {eid = 801, weight = 10},

	},
    [3] = {
		[1] = {eid = 101, weight = 10},
		[2] = {eid = 301, weight = 3},
		[3] = {eid = 401, weight = 10},
		[4] = {eid = 601, weight = 10},
		[5] = {eid = 701, weight = 10},
		[6] = {eid = 801, weight = 10},
	},
    [5] = {
		[1] = {eid = 101, weight = 10},
		[2] = {eid = 301, weight = 4},
		[3] = {eid = 401, weight = 10},
		[4] = {eid = 601, weight = 10},
		[5] = {eid = 701, weight = 10},
		[6] = {eid = 801, weight = 10},
		[7] = {eid = 501, weight = 9999},
	},
	[7] = {
		[1] = {eid = 102, weight = 10},
		[2] = {eid = 201, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 402, weight = 10},
		[5] = {eid = 501, weight = 3},
		[6] = {eid = 602, weight = 10},
		[7] = {eid = 702, weight = 10},
		[8] = {eid = 802, weight = 10},
	},
	[8] = {
		[1] = {eid = 102, weight = 10},
		[2] = {eid = 201, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 402, weight = 10},
		[5] = {eid = 501, weight = 3},
		[6] = {eid = 602, weight = 10},
		[7] = {eid = 702, weight = 10},
		[8] = {eid = 802, weight = 10},
	},
	[10] = {
		[1] = {eid = 102, weight = 10},
		[2] = {eid = 201, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 402, weight = 10},
		[5] = {eid = 502, weight = 9999},
		[6] = {eid = 602, weight = 10},
		[7] = {eid = 702, weight = 10},
		[8] = {eid = 802, weight = 10},
	},
	[12] = {
		[1] = {eid = 103, weight = 10},
		[2] = {eid = 202, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 403, weight = 10},
		[5] = {eid = 502, weight = 3},
		[6] = {eid = 603, weight = 10},
		[7] = {eid = 703, weight = 10},
		[8] = {eid = 803, weight = 10},
	},
	[13] = {
		[1] = {eid = 103, weight = 10},
		[2] = {eid = 202, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 403, weight = 10},
		[5] = {eid = 502, weight = 3},
		[6] = {eid = 603, weight = 10},
		[7] = {eid = 703, weight = 10},
		[8] = {eid = 803, weight = 10},
	},
	[15] = {
		[1] = {eid = 103, weight = 10},
		[2] = {eid = 202, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 403, weight = 10},
		[5] = {eid = 503, weight = 9999},
		[6] = {eid = 603, weight = 10},
		[7] = {eid = 703, weight = 10},
		[8] = {eid = 803, weight = 10},
	},
	[17] = {
		[1] = {eid = 104, weight = 10},
		[2] = {eid = 203, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 404, weight = 10},
		[5] = {eid = 503, weight = 3},
		[6] = {eid = 604, weight = 10},
		[7] = {eid = 704, weight = 10},
		[8] = {eid = 804, weight = 10},
	},
	[18] = {
		[1] = {eid = 104, weight = 10},
		[2] = {eid = 203, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 404, weight = 10},
		[5] = {eid = 503, weight = 3},
		[6] = {eid = 604, weight = 10},
		[7] = {eid = 704, weight = 10},
		[8] = {eid = 804, weight = 10},
	},
	[20] = {
		[1] = {eid = 104, weight = 10},
		[2] = {eid = 203, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 404, weight = 10},
		[5] = {eid = 504, weight = 9999},
		[6] = {eid = 604, weight = 10},
		[7] = {eid = 704, weight = 10},
		[8] = {eid = 804, weight = 10},
	},
	[22] = {
		[1] = {eid = 105, weight = 10},
		[2] = {eid = 204, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 405, weight = 10},
		[5] = {eid = 504, weight = 3},
		[6] = {eid = 605, weight = 10},
		[7] = {eid = 705, weight = 10},
		[8] = {eid = 805, weight = 10},
	},
	[23] = {
		[1] = {eid = 105, weight = 10},
		[2] = {eid = 204, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 405, weight = 10},
		[5] = {eid = 504, weight = 3},
		[6] = {eid = 605, weight = 10},
		[7] = {eid = 705, weight = 10},
		[8] = {eid = 805, weight = 10},
	},
	[25] = {
		[1] = {eid = 105, weight = 10},
		[2] = {eid = 204, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 405, weight = 10},
		[5] = {eid = 505, weight = 9999},
		[6] = {eid = 605, weight = 10},
		[7] = {eid = 705, weight = 10},
		[8] = {eid = 805, weight = 10},
	},
	[27] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[28] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[30] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 9999},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[32] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[33] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[35] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 9999},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[37] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[38] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[40] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 9999},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[42] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[43] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[45] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 9999},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[47] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[48] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[50] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 9999},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[52] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[53] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[55] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 9999},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[57] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[58] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 3},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
	[60] = {
		[1] = {eid = 106, weight = 10},
		[2] = {eid = 205, weight = 10},
		[3] = {eid = 301, weight = 4},
		[4] = {eid = 406, weight = 10},
		[5] = {eid = 505, weight = 9999},
		[6] = {eid = 606, weight = 10},
		[7] = {eid = 706, weight = 10},
		[8] = {eid = 806, weight = 10},
	},
}
--etype
ETYPE_KUGONG = 1
ETYPE_YINHANGJIA = 2
ETYPE_XIAOCHOU = 3
ETYPE_WUSHI = 4
ETYPE_SHANGDIAN = 5
ETYPE_CHAOSHENG = 6
ETYPE_RUQIN = 7
--1 - kugong
--2 - yinhangjia
--3 - xiaochou
EncounterInfo = {
	[101] = {
		etype = 1,
		val = 2,
	},
	[102] = {
		etype = 1,
		val = 3,
	},
	[103] = {
		etype = 1,
		val = 4,
	},
	[104] = {
		etype = 1,
		val = 5,
	},
	[105] = {
		etype = 1,
		val = 6,
	},
	[106] = {
		etype = 1,
		val = 8,
	},
	[201] = {
		etype = 2,
		cost = 5,
		delay = 10,
		payback = 15,
	},
	[202] = {
		etype = 2,
		cost = 10,
		delay = 150,
		payback = 30,
	},
	[203] = {
		etype = 2,
		cost = 15,
		delay = 150,
		payback = 45,
	},
	[204] = {
		etype = 2,
		cost = 20,
		delay = 150,
		payback = 60,
	},
	[301] = {
		etype = 3,
		gailv = {
			[1] = 20,
			[2] = 20,
		}
	},
	[302] = {
		etype = 3,
		gailv = {
			
		}
	},
	[303] = {
		etype = 3,
		gailv = {
			
		}
	},
	[304] = {
		etype = 3,
		gailv = {
			
		}
	},
	[401] = {
		etype = 4,
		item_name = "item_mango2"
	},
	[402] = {
		etype = 4,
		item_name = "item_mango4"
	},
	[403] = {
		etype = 4,
		item_name = "item_mango5"
	},
	[404] = {
		etype = 4,
		item_name = "item_mango7"
	},
	[405] = {
		etype = 4,
		item_name = "item_mango9"
	},
	[406] = {
		etype = 4,
		item_name = "item_mango10"
	},
	[501] = {
		etype = 5,
		level = 1,
		cost = 25,
	},
	[502] = {
		etype = 5,
		level = 2,
		cost = 40,
	},
	[503] = {
		etype = 5,
		level = 3,
		cost = 60,
	},
	[504] = {
		etype = 5,
		level = 4,
		cost = 90,
	},
	[505] = {
		etype = 5,
		level = 5,
		cost = 120,
	},
	[601] = {
		etype = 6,
		level = 1,
	},
	[602] = {
		etype = 6,
		level = 2,
	},
	[603] = {
		etype = 6,
		level = 3,
	},
	[604] = {
		etype = 6,
		level = 4,
	},
	[605] = {
		etype = 6,
		level = 5,
	},
	[606] = {
		etype = 6,
		level = 6,
	},
	[701] = {
		etype = 7,
		level = 1,
	},
	[702] = {
		etype = 7,
		level = 2,
	},
	[703] = {
		etype = 7,
		level = 3,
	},
	[704] = {
		etype = 7,
		level = 4,
	},
	[705] = {
		etype = 7,
		level = 5,
	},
	[706] = {
		etype = 7,
		level = 6,
	},
	[801] = {
		etype = 8,
	},
	[802] = {
		etype = 8,
	},
	[803] = {
		etype = 8,
	},
	[804] = {
		etype = 8,
	},
}

ShopinfoList = {
	[1] = {
		[1] = {item = "item_sphere", weight = 10},
		[2] = {item = "item_glimmer_cape", weight = 10},
		[3] = {item = "item_moneyold", weight = 10},
	},
	[2] = {
		[1] = {item = "item_shell", weight = 10},
		[2] = {item = "item_repairhammer", weight = 10},
		[3] = {item = "item_mangotrees", weight = 10},
		[4] = {item = "item_shell", weight = 10},
	},
	[3] = {
		[1] = {item = "item_moneyevil", weight = 10},
		[2] = {item = "item_omni", weight = 10},
		[3] = {item = "item_shell", weight = 10},
		[4] = {item = "item_shell", weight = 10},
	},
	[4] = {
		[1] = {item = "item_asms", weight = 10},
		[2] = {item = "item_pipe", weight = 10},
		[3] = {item = "item_addmana", weight = 10},
		[4] = {item = "item_pipe", weight = 10},
	},
	[5] = {
		[1] = {item = "item_mjollnir", weight = 10},
		[2] = {item = "item_addattackspeed", weight = 10},
		[3] = {item = "item_bkball", weight = 10},
		[4] = {item = "item_summontiny", weight = 10},
		[5] = {item = "item_castrefresh", weight = 10},
	},
}

ChaoshengList = {
	[1] = {
		[1] = {name = "hidden_ls", weight = 10},
		[2] = {name = "nature_viper", weight = 10},
		[3] = {name = "vibrant_techies", weight = 10},
		[4] = {name = "evil_underlord", weight = 10},
		[5] = {name = "wizard_leshrac", weight = 10},
		[6] = {name = "brawn_siege", weight = 10},
	},
	[2] = {
		[1] = {name = "brawn_centaur", weight = 10},
		[2] = {name = "nature_enchantress", weight = 10},
		[3] = {name = "wizard_furion", weight = 10},
		[4] = {name = "hidden_willow", weight = 10},
		[5] = {name = "evil_abaddon", weight = 10},
		[6] = {name = "vibrant_huskar", weight = 10},
	},
	[3] = {
		[1] = {name = "nature_bear", weight = 10},
		[2] = {name = "brawn_tidehunter", weight = 10},
		[3] = {name = "vibrant_alchemist", weight = 10},
		[4] = {name = "evil_dazzle", weight = 10},
		[5] = {name = "hidden_ta", weight = 10},
		[6] = {name = "wizard_lion", weight = 10},
	},
	[4] = {
		[1] = {name = "nature_bear_special", weight = 10},
		[2] = {name = "brawn_tidehunter_special", weight = 10},
		[3] = {name = "vibrant_alchemist_special", weight = 10},
		[4] = {name = "evil_dazzle_special", weight = 10},
		[5] = {name = "hidden_ta_special", weight = 10},
		[6] = {name = "wizard_lion_special", weight = 10},
	},
	[5] = {
		[1] = {name = "hidden_pa", weight = 10},
		[2] = {name = "vibrant_earthshaker", weight = 10},
		[3] = {name = "wizard_jakiro", weight = 10},
		[4] = {name = "evil_sf", weight = 10},
		[5] = {name = "brawn_axe", weight = 10},
		[6] = {name = "nature_treant", weight = 10},
	},
	[6] = {
		[1] = {name = "hidden_pa_special", weight = 10},
		[2] = {name = "vibrant_earthshaker_special", weight = 10},
		[3] = {name = "wizard_jakiro_special", weight = 10},
		[4] = {name = "evil_sf_special", weight = 10},
		[5] = {name = "brawn_axe_special", weight = 10},
		[6] = {name = "nature_treant_special", weight = 10},
	},
}

MonsterList = {
	[1] = {
		[1] = {name = "neutral_01", weight = 10},
		[2] = {name = "neutral_01", weight = 10},
		[3] = {name = "neutral_01", weight = 10},
		[4] = {name = "neutral_01", weight = 10},
		[5] = {name = "neutral_01", weight = 10},
		[6] = {name = "neutral_01", weight = 10},
	},
	[2] = {
		[1] = {name = "neutral_02", weight = 10},
		[2] = {name = "neutral_02", weight = 10},
		[3] = {name = "neutral_02", weight = 10},
		[4] = {name = "neutral_02", weight = 10},
		[5] = {name = "neutral_02", weight = 10},
		[6] = {name = "neutral_02", weight = 10},
	},
	[3] = {
		[1] = {name = "neutral_03", weight = 10},
		[2] = {name = "neutral_03", weight = 10},
		[3] = {name = "neutral_03", weight = 10},
		[4] = {name = "neutral_03", weight = 10},
		[5] = {name = "neutral_02", weight = 10},
		[6] = {name = "neutral_02", weight = 10},
	},
	[4] = {
		[1] = {name = "neutral_04", weight = 10},
		[2] = {name = "neutral_04", weight = 10},
		[3] = {name = "neutral_04", weight = 10},
		[4] = {name = "neutral_04", weight = 10},
		[5] = {name = "neutral_03", weight = 10},
		[6] = {name = "neutral_03", weight = 10},
	},
	[5] = {
		[1] = {name = "neutral_05", weight = 10},
		[2] = {name = "neutral_05", weight = 10},
		[3] = {name = "neutral_05", weight = 10},
		[4] = {name = "neutral_05", weight = 10},
		[5] = {name = "neutral_04", weight = 10},
		[6] = {name = "neutral_04", weight = 10},
	},
	[6] = {
		[1] = {name = "neutral_06", weight = 10},
		[2] = {name = "neutral_06", weight = 10},
		[3] = {name = "neutral_06", weight = 10},
		[4] = {name = "neutral_06", weight = 10},
		[5] = {name = "neutral_05", weight = 10},
		[6] = {name = "neutral_05", weight = 10},
	},
}

function WtaEncounters:init()
	
	--管理每个玩家身上的事件表
	self.curEncounterList = {};
	
end


function WtaEncounters:handleOneEncounter(hero, eid)
	
	print('try to handle ' .. eid)
	
	if not hero or not hero:IsAlive() then
		return false
	end	
	
	
	local data = EncounterInfo[eid]
	
	if not data then
		return false
	end
	
	if data.etype == ETYPE_KUGONG then
		WhoToAttack:ModifyBaseHP(hero.base, data.val);
	elseif data.etype == ETYPE_YINHANGJIA then
		local cost = data.cost;
		if hero:GetGold() < cost then
			msg.bottom('money not enough', 0)
			return false;
		end
		local delay = data.delay or 300;
		--hero:AddNewModifier(hero, nil, "modifier_add_gold", {duration = 5, payback = 10});
		Timers:CreateTimer(delay,function()
			hero:ModifyGold(data[payback], false, 0)
			--hero:AddNewModifier(hero, nil, "modifier_add_gold", {duration = 5, payback = 10});
		end)
		
		hero:ModifyGold(-cost, false, 0)
	elseif data.etype == ETYPE_XIAOCHOU then
		
		if hero:GetGold() < 5 then
			msg.bottom('you need to have minimun 5 gold', hero)
			return false;
		end
		local ownedMoney = hero:GetGold();
		hero:SetGold(0, false);
		
		Timers:CreateTimer(1,function()
			local rand = RandomInt(100);
			local weightL = {5,15,35,70,90,100}
			local valL = {0,0.5,0.75,1.25,1.5,2}
			local rate = 1;
			for i = 1,#weightL do
				if rand <= weightL[i] then
					rate = valL[i]
				end
			end
			
			hero:ModifyGold(math.floor(ownedMoney * rate), false, 0)
		end)
	elseif data.etype == ETYPE_WUSHI then
		WhoToAttack:GiveItem(hero, data.item_name);
	elseif data.etype == ETYPE_SHANGDIAN then
		local cost = data.cost;
		if hero:GetGold() < cost then
			msg.bottom('money not enough', 0)
			return false;
		end
		local shopItems = ShopinfoList[data.level]
		local retItem = GetWeightedOne(shopItems)
		print(retItem.item)
        if retItem.item then
            hero:ModifyGold(-cost, false, 0)
            WhoToAttack:GiveItem(hero, retItem.item);
        end
	elseif data.etype == ETYPE_CHAOSHENG then
		local units = ChaoshengList[data.level]
		local retUnit = GetWeightedOne(units)
		
		GameRules:GetGameModeEntity().WhoToAttack:CreateUnit(hero.team, hero:GetAbsOrigin(), retUnit.name, false)
	elseif data.etype == ETYPE_RUQIN then
		local monsters = MonsterList[data.level]
		local retMonster = GetWeightedOne(monsters)
		
		GameRules:GetGameModeEntity().WhoToAttack:SpawnNeutral(hero.team, retMonster.name, 3)
	end
	
	-- print('handleOneEncounter ' .. eid);
	return true;
end


function WtaEncounters:GetRandomEncounter(turn, num)

	local turnEncounters = nil;
    turnEncounters = EncountersByTurn[turn]
	
	if turnEncounters == nil then
		return nil
	end
	
	local poolNum = #turnEncounters
	print('poolNum ' .. poolNum)
	
	
	local ret = {};
	if poolNum <= num then
		for i = 1, poolNum do
			table.insert(ret, turnEncounters[i].eid);
		end
		return ret;
	end
	
	--根据采样
	local values = {};
	local newOrder = {};
	for i = 1, #turnEncounters do
		table.insert(newOrder, i);
		local randVal = RandomFloat(0.0, 1.0);
		local val = math.pow(randVal, 1.0 / turnEncounters[i].weight)
		table.insert(values, val);
	end
	
	table.sort(newOrder,function(a,b)
			local valA = values[a];
			local valB = values[b];
			return valA > valB
		end)
		
	
	for i = 1, num do
		table.insert(ret, turnEncounters[newOrder[i]].eid);
	end
	return ret;
end



function GetWeightedOne(dataList)
	local totalWeight = 0;
	for i=1,#dataList do
		totalWeight = totalWeight + dataList[i].weight;
	end
	local rand = RandomInt(1, totalWeight)
	local tmp = 0;
	local ret = nil;
	for i=1,#dataList do
		tmp = tmp + dataList[i].weight;
		if rand <= tmp then
			ret = dataList[i];
			break;
		end
	end
	return ret
end