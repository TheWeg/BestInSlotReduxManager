local TerremineRaid = LibStub("AceAddon-3.0"):GetAddon("BestInSlotRedux"):NewModule("TerremineRaid")
local Terremine = "Terremine"
local tier = 110100
local tocVersion = select(1, GetBuildInfo())
local tierHelm, tierShoulders, tierChest, catWaist, tierLegs, catFeet, catWrist, tierGloves, catBack, weaponSlot = 1, 3, 5, 8, 9, 10, 6, 7, 4, 15


local Lacolonie = "Lacolonie"
local HydromelleriedeBrassecendre = "HydromelleriedeBrassecendre"
local FailledeFlammeNoire = "FailledeFlammeNoire"
local PrieuredelaFlammesacree = "PrieuredelaFlammesacree"
local LeFilon = "LeFilon"
local TheatredelaSouffrance = "TheatredelaSouffrance"
local OperationVannesouvertes = "OperationVannesouvertes"
local operationmecagone = "operationmecagone"

if tocVersion >= "11.0.0" then
	function TerremineRaid:OnEnable()
		local bossName, lootTable
		local L = LibStub("AceLocale-3.0"):GetLocale("BestInSlotRedux")

		local raidTargetIlvl = {
			645,
			658,
			665,
			678
		}
		local raidBonusIds = {
			{
				11976,
				10353
			},
			{
				11984
			},
			{
				11990,
				10355
			},
			{
				11996,
				10356
			}
		}

		local difficultyIdRanking = {
			[11969] = 1, -- veteran 1/8
			[11970] = 1, -- veteran 2/8
			[11971] = 1, -- veteran 3/8
			[11972] = 1, -- veteran 4/8
			[11973] = 1, -- veteran 5/8
			[11974] = 1, -- veteran 6/8
			[11975] = 1, -- veteran 7/8
			[11976] = 1, -- veteran 8/8
			[11977] = 2, -- champion 1/8
			[11978] = 2, -- champion 2/8
			[11979] = 2, -- champion 3/8
			[11980] = 2, -- champion 4/8
			[11981] = 2, -- champion 5/8
			[11982] = 2, -- champion 6/8
			[11983] = 2, -- champion 7/8
			[11984] = 2, -- champion 8/8
			[12040] = 2, -- crafted
			[11985] = 3, -- hero 1/6
			[11986] = 3, -- hero 2/6
			[11987] = 3, -- hero 3/6
			[11988] = 3, -- hero 4/6
			[11989] = 3, -- hero 5/6
			[11990] = 3, -- hero 6/6
			[12042] = 3, -- crafted
			[11991] = 4, -- myth 1/6
			[11992] = 4, -- myth 2/6
			[11993] = 4, -- myth 3/6
			[11994] = 4, -- myth 4/6
			[11995] = 4, -- myth 5/6
			[11996] = 4, -- myth 6/6
			[12043] = 4, -- crafted
			[12071] = 4, -- Awakened 1/14
			[12072] = 4, -- Awakened 2/14
			[12073] = 4, -- Awakened 3/14
			[12074] = 4, -- Awakened 4/14
			[12075] = 4, -- Awakened 5/14
			[12076] = 4, -- Awakened 6/14
			[12077] = 4, -- Awakened 7/14
			[12078] = 4, -- Awakened 8/14
			[12079] = 4, -- Awakened 9/14
			[12080] = 4, -- Awakened 10/14
			[12081] = 4, -- Awakened 11/14
			[12082] = 4, -- Awakened 12/14
			[12083] = 4, -- Awakened 13/14
			[12084] = 4  -- Awakened 14/14
		}

		local maxSockets = {
			[1] = 1,
			[2] = 2,
			[6] = 1,
			[9] = 1,
			[11] = 2
		}

		local socketsBonusIds = {
			10878,
			10879,
			10880
		}

		local gems = {
			[EMPTY_SOCKET_PRISMATIC] = {
				213455,
				213458,
				213461,
				213464,
				213467,
				213470,
				213473,
				213476,
				213479,
				213482,
				213485,
				213488,
				213491,
				213494,
				213497,
				213500,
				213503,
				213506,
				213509,
				213512,
				213517,
				213740,
				213743,
				213746
			},
			[EMPTY_SOCKET_SINGING_THUNDER] = {
				228634,
				228638,
				228642,
				228648
			},
			[EMPTY_SOCKET_SINGING_SEA] = {
				228636,
				228639,
				228644,
				228647
			},
			[EMPTY_SOCKET_SINGING_WIND] = {
				228635,
				228640,
				228643,
				228646
			},
			[EMPTY_SOCKET_TINKER] = {
				221906,
				221910
			}
		}

		local weaponEnchants = {
			[445339] = 7463, --Authority of Radiant Power
			[445336] = 7457, --Authority of Storms
			[445341] = 7460, --Authority of the Depths
			[445379] = 7439, --Council's Guile
			[445351] = 7448, --Oathsworn's Tenacity
			[445385] = 7445, --Stonebound Artistry
			[445317] = 7442, --Stormrider's Fury
			[445403] = 7454,
			[327082] = 6245, --Rune of the Apocalypse
			[326805] = 6241, --Rune of Sanguination
			[326977] = 6244, --Rune of Unending Thirst
			[53343]  = 3370, --Rune of Razorice
			[53344]  = 3368, --Rune of the Fallen Crusader
			[62158]  = 3847  --Rune of the Stoneskin Gargoyle
		}

		local chestEnchants = {  --torse
			[445333] = 7364, --Crystalline Radiance
			[445353] = 7355, --Stormrider's Agility
			[445321] = 7361, --Oathsworn's Strength
			[445322] = 7358  --Council's Intellect
		}

		local enchants = {
			[5] = chestEnchants,
			[7] = {  --jambes
				[1216519] = 7654, --Charged Armor Kit
				["1216519"] = 235336, --Charged Armor Kit
				[451825] = 7601, --Stormbound Armor Kit
				["451825"] = 219911, --Stormbound Armor Kit
				[451828] = 7595, --Defender's Armor Kit
				["451828"] = 219908, --Defender's Armor Kit
				[451831] = 7598, --Dual Layered Armor Kit
				["451831"] = 219914, --Dual Layered Armor Kit
				[457620] = 7531, --Daybreak Spellthread
				[457623] = 7534  --Sunset Spellthread
			},
			[8] = {  --pieds
				[445368] = 7418, --Scout's March
				[445335] = 7421, --Cavalry's March
				[445396] = 7424  --Defender's March
			},
			[9] = {  --poignets
				[445334] = 7385, --Chant of Armored Avoidance
				[445325] = 7391, --Chant of Armored Leech
				[445330] = 7397  --Chant of Armored Speed
			},
			[11] = { --bague
				[445394] = 7470, --Cursed Critical Strike
				[445388] = 7473, --Cursed Haste
				[445383] = 7476, --Cursed Versatility
				[445359] = 7479, --Cursed Mastery
				[445387] = 7334, --Radiant Critical Strike
				[445320] = 7340, --Radiant Haste
				[445349] = 7352, --Radiant Versatility
				[445375] = 7346  --Radiant Mastery
			},
			[13] = weaponEnchants, --arme
			[15] = weaponEnchants, --distance
			[16] = { --cape
				[445386] = 7403, --Chant of Winged Grace
				[445393] = 7409, --Chant of Leeching Fangs
				[445389] = 7415  --Chant of Burrowing Rapidity
			},
			[17] = weaponEnchants, --arme 2 mains
			[20] = chestEnchants  --robe
		}

		local embellish = {
			[213770] = 10520, --Lentille de focalisation élémentaire
			[213773] = 10518, --Pierre du Néant prismatique
			[213776] = 10521, --Lumière stellaire capturée
			[219506] = 11109, --Bande d’armure frémissante
			[221943] = 11226, --Balise de redistribution d’énergie
			[221937] = 11209, --Bourse de grenades de poche
			[221940] = 11210, --Module du chaos dissimulé
			[222870] = 11303, --Doublure en fil auroral
			[222873] = 11304, --Doublure en fil vespéral
			[219497] = 11103, --Manche d’arme bénie
			[226027] = 11299, --Cachet de Sombrelune : Brillance
			[226024] = 11300, --Cachet de Sombrelune : Sublimation
			[226030] = 11302, --Cachet de Sombrelune : Symbiose
			[226033] = 11301  --Cachet de Sombrelune : Vivacité
		}

		local TerremineName = EJ_GetInstanceInfo(1296)
		self:RegisterExpansion("The War Within", EXPANSION_NAME10)
		self:RegisterRaidTier("The War Within", 110100, EXPANSION_SEASON_NAME:format("", 2):gsub("  ", " "), raidBonusIds, raidTargetIlvl, difficultyIdRanking, maxSockets, socketsBonusIds, gems, enchants, embellish, PLAYER_DIFFICULTY3, PLAYER_DIFFICULTY1, PLAYER_DIFFICULTY2, PLAYER_DIFFICULTY6)


		local mPlusBonusIds = {
			{
				11976,
				10356
			},
			{
				11984,
				10390
			},
			{
				11990,
				10390
			},
			{
				11996,
				10390
			}
		}

		local name = C_Map.GetMapInfo(1490).name
		self:RegisterRaidInstance(tier, operationmecagone, name, mPlusBonusIds)


		-----------------------------------
		-----Boss 5: Cogne-Chariottes
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2336)
		lootTable = {
			168955, --Amplificateur cognitif electrisant
			168962, --Empaleuse aceree
			168967, --Supraconducteurs plaques or
			168957, --Ceinture de championnat de mekgenieur
			168958, --Large ceinture du maitre de l arene
			168966, --Cuissards en alliage epais
			168964, --Bottes multifil
			168965, --Placage en platine modulaire
		}
		self:RegisterBossLoot(operationmecagone, lootTable, bossName)
		-----------------------------------
		-----Boss 6: K.U.-J.0.
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2339)
		lootTable = {
			168970, --Mantelet de maitre des dechets
			168969, --Mitaines d operateur
			168971, --Poignes pneumatiques rapides
			168968, --Jambieres brulees par les flammes
			168972, --Grandes bottes pyroclastiques
			232546, --Echappements de K.U.-J.O
		}
		self:RegisterBossLoot(operationmecagone, lootTable, bossName)
		-----------------------------------
		-----Boss 7: Jardin du Machiniste
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2348)
		lootTable = {
			168973, --Ameliorateur neurosynaptique
			169608, --Lame en dents-de-scie dechirante
			168976, --Ceinture e sanglage automatique
			168974, --Cuissieres autoreparatrices
			168975, --Bottines precieuses de machiniste
			169344, --Batterie de mana ingenieuse
		}
		self:RegisterBossLoot(operationmecagone, lootTable, bossName)
		-----------------------------------
		-----Boss 8: Roi Mecagone
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2331)
		lootTable = {
			169378, --Snorf dore
			--169005, --Couvre-chef d influence mentale de mekgenieur
			235224,
			--169004, --Lentilles de previsionniste psychogene
			235223,
			--169003, --Lunettes d illustre inventeur
			235222,
			--169006, --Verres trifocaux d inventeur ingenieux
			235226,
			--168987, --Garde-epaules de lucidite vacillante
			235812,
			--168984, --epaulettes extravagantes
			235811,
			--168979, --Chassis mecanise en plaques
			235809,
			--168981, --Cotte de mailles e circuit integre
			235810,
			168989, --Bandelettes hyperconductrices
			168978, --Deflecteurs anodises
			168980, --Gantelets d autorite absolue
			168985, --Protege-mains autonettoyants
			168983, --Ceinturon de monarque maniaque
			168986, --Sporran du roi fou
			168988, --Pantalon d intendant royal
			168982, --Mecano-eperons regaliens
		}
		self:RegisterBossLoot(operationmecagone, lootTable, bossName)


		--------------------------------------------------
		-----La colonie
		--------------------------------------------------
		local name = C_Map.GetMapInfo(2316).name
		self:RegisterRaidInstance(tier, Lacolonie, name, mPlusBonusIds)

		-----------------------------------
		-----Boss 1: Kyrioss
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2566)
		lootTable = {
			221032, --Mande-foudre voltaïque
			221033, --Grifforage hyperactive
			221037, --Rubans à plumes de freux chargées
			221036, --Manieurs du vent d’orage
			221034, --Garde-jambes sangle-tonnerre
			221035, --Bottines de l’essor galvanique
			219294, --Plumet de freux de la tempête chargé
		}
		self:RegisterBossLoot(Lacolonie, lootTable, bossName)
		-----------------------------------
		-----Boss 2: Garde de la tempête Gorren
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2567)
		lootTable = {
			221038, --Marteau-tonnerre fracassant
			221039, --Arc-tempête porté par le courroux
			221045, --Rempart brise-bourrasque
			221041, --Armure brise-éclair
			221040, --Ceinture de conduction
			221042, --Kilt de monte-grain
			221043, --Semelles d’arpentenuée
			219295, --Sceau de concordance algari
		}
		self:RegisterBossLoot(Lacolonie, lootTable, bossName)
		-----------------------------------
		-----Boss 3: Monstruosité de pierre du Vide
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2568)
		lootTable = {
			221046, --Brise-rotule du béhémoth
			221044, --Écheveau ombreux du colosse
			221047, --Regard de la monstruosité
			221048, --Amict de l’Oubli
			221049, --Pourpoint de la pierre éveillée
			221050, --Jambards durcis anciens
			221197, --Anneau chancreux
			219296, --Noyau de Skardyn entropique
		}
		self:RegisterBossLoot(Lacolonie, lootTable, bossName)

		--------------------------------------------------
		-----Hydromellerie de Brassecendre
		--------------------------------------------------
		name = C_Map.GetMapInfo(2335).name
		self:RegisterRaidInstance(tier, HydromelleriedeBrassecendre, name, mPlusBonusIds)


		-----------------------------------
		-----Boss 1: Maître brasseur Aldryr
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2586)
		lootTable = {
			221051, --Écraseuse des désarçonnés
			221052, --Espauliers moussus
			221054, --Serviette du chef Mâchonne
			221053, --Coups de poing mal en point
			219297, --Chope de Brassecendre
		}
		self:RegisterBossLoot(HydromelleriedeBrassecendre, lootTable, bossName)
		-----------------------------------
		-----Boss 2: I’pa
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2587)
		lootTable = {
			221057, --Mélangeur collant
			221056, --Calice de la boisson
			221055, --Capuche imprégnée de Brassecendre
			221060, --Tonnelet de sauvetage sanglé
			221059, --Gardebières pâles d’I’pa
			221058, --Baudrier d’ouvrier de la brasserie
			221061, --Grandes bottes couvertes de houblon
		}
		self:RegisterBossLoot(HydromelleriedeBrassecendre, lootTable, bossName)
		-----------------------------------
		-----Boss 3: Benk Bourdon
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2588)
		lootTable = {
			221063, --Touillette brise-ruche
			221062, --Kriss ardent de la succession
			221201, --Perche à cendrabeille ignifugée
			221064, --Cendrecrispins duveteux
			221067, --Gants apiaires percés
			221065, --Bottines à pollen
			219298, --Bourdonneur de miel vorace
		}
		self:RegisterBossLoot(HydromelleriedeBrassecendre, lootTable, bossName)
		-----------------------------------
		-----Boss 4: Goldie Baronnie
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2589)
		lootTable = {
			221068, --Partageuse de bénéfices
			221070, --Casquette « Meilleure DRH d’Azeroth »
			221072, --Mantelet d’affaires lucratives
			221069, --Plaques d’affaires anti-entailles
			221071, --Bottes à sangles casse-reins
			221198, --Bague de 85 ans de carrière
			219299, --Biéraliseur synergétique
		}
		self:RegisterBossLoot(HydromelleriedeBrassecendre, lootTable, bossName)


		--------------------------------------------------
		-----Faille de Flamme-Noire
		--------------------------------------------------
		name = C_Map.GetMapInfo(2304).name
		self:RegisterRaidInstance(tier, FailledeFlammeNoire, name, mPlusBonusIds)

		-----------------------------------
		-----Boss 1: Vieux Barbecire
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2569)
		lootTable = {
			221096, --Bissectrice du rail
			221097, --Écope arcanique
			221098, --Maille crasseuse de chevalier taupe
			221099, --Jonc d’or de Mèche
			219304, --Sifflet de conducteur en cire
		}
		self:RegisterBossLoot(FailledeFlammeNoire, lootTable, bossName)
		-----------------------------------
		-----Boss 2: Blazikon
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2559)
		lootTable = {
			221100, --Grand heaume en acier de cire
			221103, --Torque lumineux vacillant
			221104, --Entraves encaustiques
			221102, --Luisegriffes chatoyantes
			221101, --Corde à bougie odorante
			219305, --Cire de Blazikon sculptée
		}
		self:RegisterBossLoot(FailledeFlammeNoire, lootTable, bossName)
		-----------------------------------
		-----Boss 3: Le roi-bougie
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2560)
		lootTable = {
			221105, --Décapiteuse de la zone d’ombre
			221109, --Linceul du porteur de bougie
			221108, --Pognes malveillantes du roi
			221107, --Boucle du garde-éclat
			221106, --Solerets du soir piétiné
			219306, --Burin du roi-bougie
		}
		self:RegisterBossLoot(FailledeFlammeNoire, lootTable, bossName)
		-----------------------------------
		-----Boss 4: Les Ténèbres
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2561)
		lootTable = {
			225548, --Cherche-mèche
			221111, --Arme d’hast du sombre destin
			221110, --Découpeur crépusculaire
			221113, --Visage de la tombée du jour
			221115, --Amict photophobe
			221112, --Fermoirs caligineux
			221114, --Jambières du rejeton d’ombre
			219307, --Vestiges de ténèbres
		}
		self:RegisterBossLoot(FailledeFlammeNoire, lootTable, bossName)


		--------------------------------------------------
		-----Prieure de la Flamme sacree
		--------------------------------------------------
		name = C_Map.GetMapInfo(2308).name
		self:RegisterRaidInstance(tier, PrieuredelaFlammesacree, name, mPlusBonusIds)

		-----------------------------------
		-----Boss 1: Capitaine Dailcri
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2571)
		lootTable = {
			221116, --Arme d’hast de défense glorieuse
			221117, --Mur du prieuré sanctifié
			221118, --Garde-bras forgeflammes
			221119, --Poignes au serment sacré
			221121, --Écharpe de la vassale honorable
			221120, --Bottes de garde inébranlable
			219308, --Chevalière du prieuré
		}
		self:RegisterBossLoot(PrieuredelaFlammesacree, lootTable, bossName)
		-----------------------------------
		-----Boss 2: Baron Braunpique
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2570)
		lootTable = {
			221122, --Main de Beledar
			221125, --Heaume de croisade vertueuse
			221126, --Grande tenue de garde zélé
			221124, --Manchettes de baron consacrées
			221123, --Brodequins en plaques dévoués
			219309, --Tome de dévotion à la lumière
		}
		self:RegisterBossLoot(PrieuredelaFlammesacree, lootTable, bossName)
		-----------------------------------
		-----Boss 3: Prieuresse Murrpray
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2573)
		lootTable = {
			221127, --Zweihander marquebraise
			221128, --Masse séraphique forgée dans les étoiles
			221131, --Couronne de flammes élyséenne
			221203, --Épaules de réanimation pyroforgées
			221130, --Vareuse séraphique de consécration
			221129, --Marche-brasiers divins
			221200, --Bague de nécromancie radieuse
			219310, --Fragment de lumière détonant
		}
		self:RegisterBossLoot(PrieuredelaFlammesacree, lootTable, bossName)


		--------------------------------------------------
		-----Le Filon
		--------------------------------------------------
		name = C_Map.GetMapInfo(1010).name
		self:RegisterRaidInstance(tier, LeFilon, name, mPlusBonusIds)

		-----------------------------------
		-----Boss 1: Disperseur de foule automatique
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2109)
		lootTable = {
			159638, --Gourdin à manche électrique
			159663, --Anti-foule P4r-T
			158353, --Manchettes servo-bras
			159357, --Poignes de disperseur rivetées
			155864, --Poignes de fer motorisées
			158350, --Jambards de fêtard chahuteur
			159462, --Anneau de championnat de footbombe
		}
		self:RegisterBossLoot(LeFilon, lootTable, bossName)
		-----------------------------------
		-----Boss 2: Azerokk
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2114)
		lootTable = {
			158357, --Manchettes de terre enragée
			158359, --Protège-bras de Fureur-de-Pierre
			159231, --Chauffe-doigts du rat de la mine
			159226, --Ceinture de sécurité d’excavateur
			159725, --Ceinture du géologue sans scrupules
			159361, --Chaîne entrecroisée de croque-schiste
			159336, --Bottes de mineur mercenaire
			159679, --Solerets des éléments déchaînés
			159612, --Cœur résonnant d’Azerokk
		}
		self:RegisterBossLoot(LeFilon, lootTable, bossName)
		-----------------------------------
		-----Boss 3: Rixxa Fluxifuge
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2115)
		lootTable = {
			159639, --P.A.C.I.F.I.S.T.E. mod. 7
			159287, --Cape d’intentions douteuses
			159240, --Crispins anti-transpirants de Rixxa
			159305, --Gants d’éleveur corrosifs
			158341, --Garde-jambes d’explosion chimique
			159451, --Garde-jambes en plaques de plomb
			159235, --Mules d’alchimiste dérangé
		}
		self:RegisterBossLoot(LeFilon, lootTable, bossName)
		-----------------------------------
		-----Boss 4: Nabab Razzbam
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2116)
		lootTable = {
			161135, --Schéma : Méca-nabab Mod. II
			159641, --D-G4-G
			--158364, --Turban de haute altitude
			235419,
			--159415, --Espauliers flambe-ciel
			235415,
			--159232, --Protège-épaules délicieusement aérodynamiques
			235418,
			--159360, --Spallières anti-impact
			235416,
			--158307, --Corselet anti-mitraille
			235460,
			--159298, --Gilet de plénipotentiaire de la KapitalRisk
			235417,
			--158349, --Jupon du baron d’azérite personnalisé
			235420,
			159611, --Gros bouton rouge de Razzbam
		}
		self:RegisterBossLoot(LeFilon, lootTable, bossName)


		--------------------------------------------------
		-----Theatre de la Souffrance
		--------------------------------------------------
		name = C_Map.GetMapInfo(1683).name
		self:RegisterRaidInstance(tier, TheatredelaSouffrance, name, mPlusBonusIds)

		-----------------------------------
		-----Boss 1: L’affrontement
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2397)
		lootTable = {
			182107, --Accrétion vitale
			183484, --Agressivité non contenue
			182441, --Avantage du tireur d’élite
			183197, --Destruction contrôlée
			181705, --Effervescence céleste
			183503, --Katar empoisonné
			183332, --Souvenir de la Marque du maître assassin
			178866, --Décapiteur de décimation de Dessia
			178799, --Chaperon du traqueur de l’amphithéâtre
			178803, --Amict léché par la peste
			178795, --Gilet des secrets dissimulés
			178800, --Garde-jambes en oxxéine galvanisés
			178871, --Chevalière du serment de sang
			178810, --Fiole d’essence spectrale
		}
		self:RegisterBossLoot(TheatredelaSouffrance, lootTable, bossName)
		-----------------------------------
		-----Boss 2: Trancheboyau
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2401)
		lootTable = {
			180932, --Attisé par la violence
			183510, --Calcul des probabilités
			181840, --Inspiration de la Lumière
			181866, --Peste flétrissante
			178793, --Corselet de protection abdominale
			178806, --Bandelettes en gaze contaminées
			178798, --Poignes des rossées accablantes
			178869, --Cercle en chair amalgamée
			178808, --Viscères de haine amalgamée
		}
		self:RegisterBossLoot(TheatredelaSouffrance, lootTable, bossName)
		-----------------------------------
		-----Boss 3: Xav l’Invaincu
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2390)
		lootTable = {
			182383, --Danse avec le destin
			182657, --Enchaînement fatal
			182559, --Justification du templier
			183220, --Souvenir de la Souillure de Razelikh
			183385, --Souvenir du Déchaînement
			183300, --Souvenir du Jugement du magistrat
			180844, --Vitalité brutale
			178865, --Pique d’autorité de Xav
			178789, --Couteau du façonneur de chair
			178863, --Fendoir maculé de sang
			178864, --Martelet de prédateur sang-lié
			178794, --Cotte de mailles de combattant triomphant
			178807, --Garde-poignets du combattant de la fosse
			178801, --Jambières de compétiteur intrépide
		}
		self:RegisterBossLoot(TheatredelaSouffrance, lootTable, bossName)
		-----------------------------------
		-----Boss 4: Kul’tharok
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2389)
		lootTable = {
			181980, --Acceptation de la mort
			182128, --Appel des flammes
			182769, --Moteur à combustion
			182456, --Renvoi du mal
			182617, --Souvenir de la Caresse de la mort
			183375, --Souvenir de la Grande tenue diabolique
			181624, --Transfert rapide
			178792, --Habit d’âmes cousues
			178805, --Ceinturon des rêves brisés
			178796, --Bottes de substance frémissante
			178870, --Bague rituelle en os
			178809, --Rubis d’effusion d’âmes
		}
		self:RegisterBossLoot(TheatredelaSouffrance, lootTable, bossName)
		-----------------------------------
		-----Boss 5: Mordretha, l’impératrice immortelle
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2417)
		lootTable = {
			182131, --Apparitions obsédantes
			182648, --Focalisation de tireur de précision
			183476, --Inspiration stellaire
			182743, --Malignité concentrée
			181511, --Précision du Néant
			183225, --Souvenir de Lycara
			183314, --Souvenir des Ombres cautérisantes
			178867, --Barricade de l’empire sans fin
			178868, --Promesse du marche-mort
			178802, --Espauliers du combattant inflexible
			178804, --Corde de l’impératrice déchue
			178797, --Souliers de l’usurpateur vaincu
			178872, --Anneau de conflit perpétuel
			178811, --Codex sinistre
		}
		self:RegisterBossLoot(TheatredelaSouffrance, lootTable, bossName)


		--------------------------------------------------
		-----Operation Vannes ouvertes
		--------------------------------------------------
		name = C_Map.GetMapInfo(2387).name
		self:RegisterRaidInstance(tier, OperationVannesouvertes, name, mPlusBonusIds)

		-----------------------------------
		-----Boss 1: Grand-M.A.M.A.
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2648)
		lootTable = {
			234491, --Ka-BOUM !-rang sonique
			234503, --Missiles cachés de sille-ciel
			234500, --Plaques à ferraille mécanisées
			234497, --Chaussettes fatales non-conductrices
			232542, --Médibolide imprégné de ténèbres
		}
		self:RegisterBossLoot(OperationVannesouvertes, lootTable, bossName)
		-----------------------------------
		-----Boss 2: Duo de démolition
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2649)
		lootTable = {
			234492, --B.B.B.F.G. B de Keeza
			234498, --Masque de filtrage du moulin à eau
			234502, --Plastron anti-explosion roussi de Bront
			234505, --Projecteur d’intérimaire de la KapitalRisk
			232541, --Stimulateur cardiaque improvisé à l’hydroglycérine
		}
		self:RegisterBossLoot(OperationVannesouvertes, lootTable, bossName)
		-----------------------------------
		-----Boss 3: Face de marais
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2650)
		lootTable = {
			236768, --Craboum
			234494, --Turbo-soc de Gallytech
			234506, --Plaque d’immersion de plongeon dans la boue
			234499, --Bandelettes en varech dérangé
			234495, --Sarouel étrangle-lames
			232543, --Boue rituelle retentissante
		}
		self:RegisterBossLoot(OperationVannesouvertes, lootTable, bossName)
		-----------------------------------
		-----Boss 4: Geezle Gigazap
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2651)
		lootTable = {
			234490, --Disjoncteur
			234493, --Volt-ohmmètre coercitif de Geezle
			234507, --Filtre de siphonnage d’électricité
			234496, --Veste en caoutchouc de saboteur
			234504, --Gratte-échauffaudage de démarreur
			234501, --Générateur portatif
			232545, --Zap-clap de Gigazap
		}
		self:RegisterBossLoot(OperationVannesouvertes, lootTable, bossName)
		self:RegisterRaidInstance(tier, Terremine, TerremineName)


		--------------------------------------------------
		-----Libération de Terremine
		--------------------------------------------------

		-----------------------------------
		-----Boss 1: Vexie et les Écrouabouilles
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2639)
		lootTable = {
			228892, --Levier de vitesse des Mécanos
			231268, --Machette explofurie
			228858, --Masque de plein gaz
			228875, --Plaque frontale de vandale
			228839, --Drapeau de course du circuit clandé
			228852, --Blazer de gloire
			228868, --Protège-bras grondants
			228861, --Ceinture à outils de rafistolage
			228865, --Jupon de médecin d’arène
			228876, --Pneus lisses de bolide
			228862, --Solerets criblés d’éclats
			230197, --Clé de rechange d’Écrouabouille
			230019, --Sifflet à mécano de Vexie
		}
		self:RegisterBossLoot(Terremine, lootTable, bossName)

		-----------------------------------
		-----Boss 2: Chaudron du carnage
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2640)
		lootTable = {
			228806, --Gallybrouzouf sanglant du zénith
			228803, --Gallybrouzouf sanglant effroyable
			228804, --Gallybrouzouf sanglant mystique
			228805, --Gallybrouzouf sanglant vénéré
			228904, --Coqueluche du public
			228900, --Arc du tournoi
			228890, --Retentisseur de superfan
			228846, --Manchettes à graffitis galvaniques
			228873, --Ceinture de poids-lourd
			228856, --Cordon de combat d’adversaire
			228847, --Pédilles de cavale
			228840, --Anneau de championnat terni
			230190, --Gros bouton rouge de Torq
			230191, --Veilleuse de Fusendo
		}
		self:RegisterBossLoot(Terremine, lootTable, bossName)
		-----------------------------------
		-----Boss 3: Rik Rebond
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2641)
		lootTable = {
			228818, --Gallybrouzouf poli du zénith
			228815, --Gallybrouzouf poli effroyable
			228816, --Gallybrouzouf poli mystique
			228817, --Gallybrouzouf poli vénéré
			228897, --Creuse-sillons pyrotechnique
			228895, --Sabre à ignition remixé
			231311, --Mur merveilleux de leader
			228841, --Amulette semi-charmée
			228857, --Bracelet d’admission à la sous-fête
			228869, --Bracelets cliquetants de la reine tueuse
			228845, --Ceinture de la diva féroce
			228874, --Bottes de marche de Rik
			230194, --Radio Rebond
		}
		self:RegisterBossLoot(Terremine, lootTable, bossName)

		-----------------------------------
		-----Boss 4: Stix Jettetout
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2642)
		lootTable = {
			228814, --Gallybrouzouf rouillé du zénith
			228811, --Gallybrouzouf rouillé effroyable
			228812, --Gallybrouzouf rouillé mystique
			228813, --Gallybrouzouf rouillé vénéré
			236687, --Pierre de foyer explosive
			228903, --Creusoir à détritus
			228896, --Détecteur de métaux de Stix
			228859, --Chaperon en ferraille stérilisée
			228871, --Masque de l’équipe de nettoyage
			228849, --Compacteurs de mécadécharge
			228854, --Pantalon jeté de rat des cales
			230026, --Champ de ferraille 9001
			230189, --Méga-aimant d’as de la casse
		}
		self:RegisterBossLoot(Terremine, lootTable, bossName)

		-----------------------------------
		-----Boss 5: Pignonneur Crosseplatine
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2653)
		lootTable = {
			228802, --Gallybrouzouf graissé du zénith
			228799, --Gallybrouzouf graissé effroyable
			228800, --Gallybrouzouf graissé mystique
			228801, --Gallybrouzouf graissé vénéré
			228898, --Bâton badaboum à alphabobine
			228894, --Lame-tronçonneuse GIGAMORT
			228844, --Propulseur personnel de pilote d’essai
			228884, --Fermoir de cobaye
			228867, --Manieurs gravicrasses
			228882, --Tapis roulant de raffinerie
			228888, --Lanceurs bêta accélérés
			230186, --Monsieur Requinque
			230193, --Monsieur Traque-et-Tient
		}
		self:RegisterBossLoot(Terremine, lootTable, bossName)

		-----------------------------------
		-----Boss 6: Le Bandit manchot
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2644)
		lootTable = {
			228810, --Gallybrouzouf doré du zénith
			228807, --Gallybrouzouf doré effroyable
			228808, --Gallybrouzouf doré mystique
			228809, --Gallybrouzouf doré vénéré
			232526, --As-des-Machines
			228905, --Giga perce-coffre
			231266, --Perforateur à nombre aléatoire
			228906, --Détecteur de fraude d’opérateur
			228850, --Chemisette au rabais
			228885, --Grosse blinde d’arnaque
			228886, --Ceinturon à pièces
			228883, --Chaussures pour grosses pointures
			228843, --Roulette miniature
			230027, --Maison de cartes
			230188, --Service spécial du Gallagio
		}
		self:RegisterBossLoot(Terremine, lootTable, bossName)

		-----------------------------------
		-----Boss 7: Verr’Minh, chefs de la sécurité
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2645)
		lootTable = {
			232804, --Coup de poing en fusion de Capo
			228901, --Gourdin de l’opé rentable
			228902, --Offre refusée d’affranchi
			228893, --« Petite frangine »
			228842, --Bijou béni de Gobleone
			228870, --Mantelet sur mesure de sous-chef
			228860, --Épaulettes de gros bras sur le retour
			228851, --Plastron à l’épreuve des balles
			228878, --Menottes affranchies
			228863, --Doigts collants de gros bras
			228880, --Holster de porte-flingue
			228853, --Garde-jambes de mercenaire musclé
			228879, --Palmes de Murloc en ciment
			230199, --Numéro d’urgence des brutes de Minh
			230192, --Pichet Moxie de Verr
		}
		self:RegisterBossLoot(Terremine, lootTable, bossName)

		-----------------------------------
		-----Boss 8: Roi du chrome Gallywix
		-----------------------------------
		bossName = EJ_GetEncounterInfo(2646)
		lootTable = {
			228819, --Bibelot extravagant
			235626, --Les clés du G-néral
			236960, --Prototype d’A.S.M.R.
			228891, --Punisseur capital
			228899, --Pouce de fer de Gallywix
			228889, --Titan d’industrie
			228848, --Tricorne de racketteur imprégné de ténèbres
			228855, --Espauliers sur la paille
			228864, --Uniforme de cartel « épuré »
			228881, --Brassards à liasses illicites
			228872, --Serre-pognes dorés
			228877, --Chaîne avide de croupier
			228866, --Pantalons à poches profondes
			228887, --Écraseurs de compétition acharnés
			231265, --Le diamant Jastor
			230029, --Tenue explosive chromebustible
			230198, --Œil de Kezan
		}
		self:RegisterBossLoot(Terremine, lootTable, bossName)

		--------------------------------------------------
		----- Trash Loot
		--------------------------------------------------
		bossName = "Trash Loot"
		lootTable = {
			232663, --Plaques d’identification de mercenaire de Terremine
			232656, --Mantelet fêtard de psychopathe
			232655, --Baudrier de concierge de la Cuverie
			232657, --Couvre-chef à chalumeau de mécagénieur
			232658, --Protège-chevilles d’incancinelle
			232659, --Chaperon de loyaliste tenace
			232660, --Large ceinture du salon de minuit
			232661, --Plaques d’épaules de Wrynn illégales
			232662, --Grande ceinture de globulin fusionnée
		}
		self:RegisterBossLoot(Terremine, lootTable, bossName)

		----------------------------------------------------------------------------------------------------------

		local cwap = {
			["DEATHKNIGHT"] = 229250,
			["PALADIN"] = 229241,
			["WARRIOR"] = 229232
		}
		local cwam = {
			["HUNTER"] = 229271,
			["SHAMAN"] = 229259,
			["EVOKER"] = 229277
		}
		local cwal = {
			["DEMONHUNTER"] = 229313,
			["DRUID"] = 229304,
			["ROGUE"] = 229286,
			["MONK"] = 229295
		}
		local cwac = {
			["WARLOCK"] = 229322,
			["MAGE"] = 229340,
			["PRIEST"] = 229331
		}
		local cfp = {
			["DEATHKNIGHT"] = 229255,
			["PALADIN"] = 229246,
			["WARRIOR"] = 229237
		}
		local cfm = {
			["HUNTER"] = 229273,
			["SHAMAN"] = 229264,
			["EVOKER"] = 229282
		}
		local cfl = {
			["DEMONHUNTER"] = 229318,
			["DRUID"] = 229309,
			["ROGUE"] = 229291,
			["MONK"] = 229300
		}
		local cfc = {
			["WARLOCK"] = 229327,
			["MAGE"] = 229345,
			["PRIEST"] = 229336
		}
		local cwrp= {
			["DEATHKNIGHT"] = 229249,
			["PALADIN"] = 229240,
			["WARRIOR"] = 229231
		}
		local cwrm = {
			["HUNTER"] = 229267,
			["SHAMAN"] = 229258,
			["EVOKER"] = 229276
		}
		local cwrl = {
			["DEMONHUNTER"] = 229312,
			["DRUID"] = 229303,
			["ROGUE"] = 229285,
			["MONK"] = 229294
		}
		local cwrc = {
			["WARLOCK"] = 229321,
			["MAGE"] = 229339,
			["PRIEST"] = 229330
		}
		local cb = {
			["DEATHKNIGHT"] = 229248,
			["PALADIN"] = 229239,
			["WARRIOR"] = 229230,
			["HUNTER"] = 229266,
			["SHAMAN"] = 229257,
			["EVOKER"] = 229275,
			["DEMONHUNTER"] = 229311,
			["DRUID"] = 229302,
			["ROGUE"] = 229284,
			["MONK"] = 229293,
			["WARLOCK"] = 229320,
			["MAGE"] = 229338,
			["PRIEST"] = 229329
		}

		local chp = {
			["DEATHKNIGHT"] = 229253,
			["PALADIN"] = 229244,
			["WARRIOR"] = 229235,
		}

		local chm = {
			["HUNTER"] = 229271,
			["SHAMAN"] = 229262,
			["EVOKER"] = 229280,
		}

		local chl = {
			["DEMONHUNTER"] = 229316,
			["DRUID"] = 229307,
			["ROGUE"] = 229289,
			["MONK"] = 229298,
		}

		local chc = {
			["WARLOCK"] = 229325,
			["MAGE"] = 229343,
			["PRIEST"] = 229334,
		}

		local csp = {
			["DEATHKNIGHT"] = 229251,
			["PALADIN"] = 229242,
			["WARRIOR"] = 229233,
		}

		local csm = {
			["HUNTER"] = 229269,
			["SHAMAN"] = 229260,
			["EVOKER"] = 229278,
		}

		local csl = {
			["DEMONHUNTER"] = 229314,
			["DRUID"] = 229305,
			["ROGUE"] = 229287,
			["MONK"] = 229296,
		}

		local csc = {
			["WARLOCK"] = 229323,
			["MAGE"] = 229341,
			["PRIEST"] = 229332,
		}

		local ccp = {
			["DEATHKNIGHT"] = 229256,
			["PALADIN"] = 229247,
			["WARRIOR"] = 229238,
		}

		local ccm = {
			["HUNTER"] = 229274,
			["SHAMAN"] = 229265,
			["EVOKER"] = 229283,
		}

		local ccl = {
			["DEMONHUNTER"] = 229319,
			["DRUID"] = 229310,
			["ROGUE"] = 229292,
			["MONK"] = 229301,
		}

		local ccc = {
			["WARLOCK"] = 229328,
			["MAGE"] = 229346,
			["PRIEST"] = 229337,
		}

		local clp = {
			["DEATHKNIGHT"] = 229252,
			["PALADIN"] = 229243,
			["WARRIOR"] = 229234,
		}

		local clm = {
			["HUNTER"] = 229270,
			["SHAMAN"] = 229261,
			["EVOKER"] = 229279,
		}

		local cll = {
			["DEMONHUNTER"] = 229315,
			["DRUID"] = 229306,
			["ROGUE"] = 229288,
			["MONK"] = 229297,
		}

		local clc = {
			["WARLOCK"] = 229324,
			["MAGE"] = 229342,
			["PRIEST"] = 229333,
		}

		local cgp = {
			["DEATHKNIGHT"] = 229254,
			["PALADIN"] = 229245,
			["WARRIOR"] = 229236,
		}

		local cgm = {
			["HUNTER"] = 229272,
			["SHAMAN"] = 229263,
			["EVOKER"] = 229281,
		}

		local cgl = {
			["DEMONHUNTER"] = 229317,
			["DRUID"] = 229308,
			["ROGUE"] = 229290,
			["MONK"] = 229299,
		}

		local cgc = {
			["WARLOCK"] = 229326,
			["MAGE"] = 229344,
			["PRIEST"] = 229335,
		}

		self:RegisterTierTokens(110100, {
			[tierHelm] = {
				[228807] = {
					["DEATHKNIGHT"] = 229253,
					["WARLOCK"] = 229325,
					["DEMONHUNTER"] = 229316,
				},
				[228808] = {
					["HUNTER"] = 229271,
					["MAGE"] = 229343,
					["DRUID"] = 229307,
				},
				[228809] = {
					["PALADIN"] = 229244,
					["PRIEST"] = 229334,
					["SHAMAN"] = 229262,
				},
				[228810] = {
					["WARRIOR"] = 229235,
					["ROGUE"] = 229289,
					["MONK"] = 229298,
					["EVOKER"] = 229280,
				},
			},
			[tierShoulders] = {
				[228815] = {
					["DEATHKNIGHT"] = 229251,
					["WARLOCK"] = 229323,
					["DEMONHUNTER"] = 229314,
				},
				[228816] = {
					["HUNTER"] = 229269,
					["MAGE"] = 229341,
					["DRUID"] = 229305,
				},
				[228817] = {
					["PALADIN"] = 229242,
					["PRIEST"] = 229332,
					["SHAMAN"] = 229260,
				},
				[228818] = {
					["WARRIOR"] = 229233,
					["ROGUE"] = 229287,
					["MONK"] = 229296,
					["EVOKER"] = 229278,
				},
			},
			[tierChest] = {
				[228799] = {
					["DEATHKNIGHT"] = 229256,
					["WARLOCK"] = 229328,
					["DEMONHUNTER"] = 229319,
				},
				[228800] = {
					["HUNTER"] = 229274,
					["MAGE"] = 229346,
					["DRUID"] = 229310,
				},
				[228801] = {
					["PALADIN"] = 229247,
					["PRIEST"] = 229337,
					["SHAMAN"] = 229265,
				},
				[228802] = {
					["WARRIOR"] = 229238,
					["ROGUE"] = 229292,
					["MONK"] = 229301,
					["EVOKER"] = 229283,
				},
			},
			[tierLegs] = {
				[228811] = {
					["DEATHKNIGHT"] = 229252,
					["WARLOCK"] = 229324,
					["DEMONHUNTER"] = 229315,
				},
				[228812] = {
					["HUNTER"] = 229270,
					["MAGE"] = 229342,
					["DRUID"] = 229306,
				},
				[228813] = {
					["PALADIN"] = 229243,
					["PRIEST"] = 229333,
					["SHAMAN"] = 229261,
				},
				[228814] = {
					["WARRIOR"] = 229234,
					["ROGUE"] = 229288,
					["MONK"] = 229297,
					["EVOKER"] = 229279,
				},
			},
			[tierGloves] = {
				[228803] = {
					["DEATHKNIGHT"] = 229254,
					["WARLOCK"] = 229326,
					["DEMONHUNTER"] = 229317,
				},
				[228804] = {
					["HUNTER"] = 229272,
					["MAGE"] = 229344,
					["DRUID"] = 229308,
				},
				[228805] = {
					["PALADIN"] = 229245,
					["PRIEST"] = 229335,
					["SHAMAN"] = 229263,
				},
				[228806] = {
					["WARRIOR"] = 229236,
					["ROGUE"] = 229290,
					["MONK"] = 229299,
					["EVOKER"] = 229281,
				},
			},
		}, L["Token"], 228819)

		self:RegisterTierTokens(110100, {
			[tierHelm] = {
				[235419] = chl,
				[235222] = chp,
				[235223] = chm,
				[235224] = chl,
				[235226] = chc,
				[178799] = chm,
				[221047] = chp,
				[221055] = chc,
				[221070] = chm,
				[221100] = chp,
				[221113] = chm,
				[221125] = chl,
				[221131] = chc,
				[228848] = chl,
				[228858] = chp,
				[228859] = chm,
				[228871] = chc,
				[232657] = chl,
				[232659] = chm,
				[234498] = chl
			},
			[tierShoulders] = {
				[235418] = csc,
				[235416] = csm,
				[235415] = csp,
				[235811] = csl,
				[235812] = csc,
				[178802] = csp,
				[178803] = csc,
				[221048] = csm,
				[221052] = csp,
				[221072] = csc,
				[221098] = csm,
				[221115] = csc,
				[221201] = csl,
				[221203] = csp,
				[228855] = csp,
				[228860] = csm,
				[228870] = csc,
				[228875] = csl,
				[232656] = csc,
				[232661] = csp,
				[234500] = csl,
				[234503] = csm
			},
			[tierChest] = {
				[235460] = ccm,
				[235420] = ccc,
				[235417] = ccl,
				[235809] = ccp,
				[235810] = ccm,
				[178792] = ccc,
				[178793] = ccp,
				[178794] = ccm,
				[178795] = ccl,
				[221041] = ccm,
				[221049] = ccl,
				[221069] = ccp,
				[221126] = ccc,
				[221130] = ccl,
				[228850] = ccc,
				[228851] = ccp,
				[228852] = ccm,
				[228864] = ccl,
				[234496] = ccc,
				[234502] = ccm,
				[234506] = ccp
			},
			[catWaist] = {
				[159226] = cwac,
				[159361] = cwam,
				[159725] = cwal,
				[168957] = cwal,
				[168958] = cwac,
				[168976] = cwap,
				[168983] = cwam,
				[168986] = cwal,
				[178804] = cwac,
				[178805] = cwal,
				[221040] = cwap,
				[221058] = cwal,
				[221101] = cwam,
				[221107] = cwal,
				[221121] = cwac,
				[228845] = cwam,
				[228856] = cwal,
				[228861] = cwac,
				[228873] = cwap,
				[228877] = cwam,
				[228880] = cwal,
				[228882] = cwac,
				[228886] = cwap,
				[232655] = cwac,
				[232660] = cwam,
				[232662] = cwap,
				[234501] = cwam,
				[234505] = cwap
			},
			[tierLegs] = {
				[158341] = clm,
				[158350] = clc,
				[159451] = clp,
				[168966] = clp,
				[168968] = cll,
				[168974] = clm,
				[168988] = clc,
				[178800] = clp,
				[178801] = cll,
				[221034] = clp,
				[221042] = cll,
				[221050] = clc,
				[221065] = clm,
				[221114] = cll,
				[221129] = clm,
				[228853] = clp,
				[228854] = cll,
				[228865] = clc,
				[228866] = clm,
				[234495] = clc
			},
			[catFeet] = {
				[159235] = cfc,
				[159336] = cfl,
				[159679] = cfp,
				[168964] = cfc,
				[168972] = cfp,
				[168975] = cfl,
				[168982] = cfm,
				[178796] = cfm,
				[178797] = cfl,
				[221035] = cfm,
				[221043] = cfc,
				[221061] = cfp,
				[221071] = cfl,
				[221106] = cfm,
				[221120] = cfl,
				[221123] = cfp,
				[228847] = cfc,
				[228862] = cfm,
				[228874] = cfp,
				[228876] = cfl,
				[228879] = cfc,
				[228883] = cfm,
				[228887] = cfp,
				[228888] = cfl,
				[232658] = cfl,
				[234497] = cfc
			},
			[catWrist] = {
				[158353] = cwrl,
				[158357] = cwrm,
				[158359] = cwrp,
				[159240] = cwrc,
				[168967] = cwrm,
				[168978] = cwrp,
				[168989] = cwrc,
				[178806] = cwrc,
				[178807] = cwrp,
				[221037] = cwrc,
				[221053] = cwrl,
				[221059] = cwrm,
				[221064] = cwrp,
				[221104] = cwrc,
				[221118] = cwrp,
				[221124] = cwrm,
				[228846] = cwrm,
				[228857] = cwrc,
				[228868] = cwrp,
				[228869] = cwrl,
				[228878] = cwrm,
				[228881] = cwrc,
				[228884] = cwrp,
				[228885] = cwrl,
				[234499] = cwrl
			},
			[tierGloves] = {
				[155864] = cgp,
				[159231] = cgc,
				[159305] = cgl,
				[159357] = cgm,
				[168969] = cgc,
				[168971] = cgm,
				[168980] = cgp,
				[168985] = cgl,
				[178798] = cgm,
				[221036] = cgl,
				[221067] = cgc,
				[221102] = cgl,
				[221108] = cgc,
				[221112] = cgp,
				[221119] = cgm,
				[228849] = cgp,
				[228863] = cgl,
				[228867] = cgm,
				[228872] = cgc,
				[234504] = cgp
			},
			[catBack] = {
				[159287] = cb,
				[168970] = cb,
				[221054] = cb,
				[221109] = cb,
				[228839] = cb,
				[228844] = cb,
				[234507] = cb
			}
		}, L["Catalyst"])

		self:RegisterTierTokens(110100, {
			[weaponSlot] = {
				[232526] = {
					["PALADIN"] = 232805,
					["SHAMAN"] = 232805,
					["DRUID"] = 232805,
					["EVOKER"] = 232805
				}
			}
		}, L["Transformed"])

			----------------------------------------------------------------------------------------------------------
		--[[ forge
		local tradeskill = C_Spell.GetSpellInfo(2018).name
		self:RegisterRaidInstance(110100, tradeskill, tradeskill, {{12040, 9627}, {12040, 9627}, {12040, 12042, 9627}, {12040, 12043, 9627}}, {}, {{38, 8}, {38, 8}, {38, 8}, {38, 8}})
		lootTable = {
			222430,
			222434,
			222432,
			222436,
			222437,
			222431,
			222433,
			222435,
			222429,
			222443,
			222447,
			222438,
			222441,
			222448,
			222444,
			222440,
			222439,
			222445,
			222450,
			222442,
			222446,
			222451,
			222449,
			222463,
			222458,
			222459
		}
		self:RegisterBossLoot(tradeskill, lootTable, tradeskill)

		-- enchantement
		tradeskill = C_Spell.GetSpellInfo(7411).name
		self:RegisterRaidInstance(110100, tradeskill, tradeskill, {{12040, 9627}, {12040, 9627}, {12040, 12042, 9627}, {12040, 12043, 9627}}, {}, {{38, 8}, {38, 8}, {38, 8}, {38, 8}})
		lootTable = {
			224405,
		}
		self:RegisterBossLoot(tradeskill, lootTable, tradeskill)

		-- couture
		tradeskill = C_Spell.GetSpellInfo(3908).name
		self:RegisterRaidInstance(110100, tradeskill, tradeskill, {{12040, 9627}, {12040, 9627}, {12040, 12042, 9627}, {12040, 12043, 9627}}, {}, {{38, 8}, {38, 8}, {38, 8}, {38, 8}})
		lootTable = {
			222817,
			222818,
			222815,
			222822,
			222820,
			222814,
			222819,
			222816,
			222821,
			222812,
			222809,
			222808,
			222811,
			222807,
			222810
		}
		self:RegisterBossLoot(tradeskill, lootTable, tradeskill)

		-- joaillerie
		tradeskill = C_Spell.GetSpellInfo(25229).name
		self:RegisterRaidInstance(110100, tradeskill, tradeskill, {{12040, 9627}, {12040, 9627}, {12040, 12042, 9627}, {12040, 12043, 9627}}, {}, {{38, 8}, {38, 8}, {38, 8}, {38, 8}})
		lootTable = {
			215136,
			215135,
			215134,
			215133
		}
		self:RegisterBossLoot(tradeskill, lootTable, tradeskill)

		-- alchimie
		tradeskill = C_Spell.GetSpellInfo(2259).name
		self:RegisterRaidInstance(110100, tradeskill, tradeskill, {{12040, 9627}, {12040, 9627}, {12040, 12042, 9627}, {12040, 12043, 9627}}, {}, {{38, 8}, {38, 8}, {38, 8}, {38, 8}})
		lootTable = {
			210816
		}
		self:RegisterBossLoot(tradeskill, lootTable, tradeskill)

		-- calligraphie
		tradeskill = C_Spell.GetSpellInfo(45357).name
		self:RegisterRaidInstance(110100, tradeskill, tradeskill, {{12040, 9627}, {12040, 9627}, {12040, 12042, 9627}, {12040, 12043, 9627}}, {}, {{38, 8}, {38, 8}, {38, 8}, {38, 8}})
		lootTable = {
			222567,
			222568,
			222566,
		}
		self:RegisterBossLoot(tradeskill, lootTable, tradeskill)

		-- travail du cuir
		tradeskill = C_Spell.GetSpellInfo(2108).name
		self:RegisterRaidInstance(110100, tradeskill, tradeskill, {{12040, 9627}, {12040, 9627}, {12040, 12042, 9627}, {12040, 12043, 9627}}, {}, {{38, 8}, {38, 8}, {38, 8}, {38, 8}})
		lootTable = {
			219334,
			219329,
			219327,
			219333,
			219328,
			219331,
			219332,
			219330,
			219335,
			219340,
			219342,
			219336,
			219341,
			219339,
			219337,
			219338,
			219502,
			219512,
			219507,
			219508,
			219489,
			219492,
			219501,
			219511,
			219509,
			219513
		}
		self:RegisterBossLoot(tradeskill, lootTable, tradeskill)

		-- ingénierie
		tradeskill = C_Spell.GetSpellInfo(4036).name
		self:RegisterRaidInstance(110100, tradeskill, tradeskill, {{12040, 9627}, {12040, 9627}, {12040, 12042, 9627}, {12040, 12043, 9627}}, {}, {{38, 8}, {38, 8}, {38, 8}, {38, 8}})
		lootTable = {
			221803,
			221807,
			221805,
			221808,
			221801,
			221802,
			221804,
			221969,
			221806
		}
		self:RegisterBossLoot(tradeskill, lootTable, tradeskill)]]
		lootTable = {
			-- forge
			450226,
			450221,
			450225,
			450223,
			450227,
			450228,
			450222,
			450224,
			450220,
			450234,
			450238,
			450229,
			450232,
			450239,
			450241,
			450235,
			450233,
			450231,
			450246,
			450250,
			450230,
			450236,
			450237,
			450242,
			450240,
			450245,
			-- enchantement
			445355,
			-- couture
			446935,
			446932,
			446940,
			446941,
			446938,
			446945,
			446943,
			446937,
			446942,
			446931,
			446934,
			446930,
			446933,
			446939,
			446944,
			-- joaillerie
			435385,
			435384,
			435383,
			435382,
			-- alchimie
			427185,
			-- calligraphie
			444198,
			444199,
			444197,
			-- travail du cuir
			441054,
			441052,
			441053,
			441051,
			441058,
			441060,
			441063,
			441066,
			444070,
			443951,
			443961,
			443960,
			441057,
			441055,
			441056,
			441059,
			441061,
			441065,
			441062,
			441064,
			444071,
			444073,
			444068,
			443949,
			443958,
			443950,
			-- ingénierie
			447316,
			447320,
			447318,
			447321,
			447314,
			447315,
			447317,
			447352,
			447319
			--[[222430,
			222434,
			222432,
			222436,
			222437,
			222431,
			222433,
			222435,
			222429,
			222443,
			222447,
			222438,
			222441,
			222448,
			222444,
			222440,
			222439,
			222445,
			222450,
			222442,
			222446,
			222451,
			222449,
			222463,
			222458,
			222459,
			224405,
			222817,
			222818,
			222815,
			222822,
			222820,
			222814,
			222819,
			222816,
			222821,
			222812,
			222809,
			222808,
			222811,
			222807,
			222810,
			215136,
			215135,
			215134,
			215133,
			210816,
			222567,
			222568,
			222566,
			219334,
			219329,
			219327,
			219333,
			219328,
			219331,
			219332,
			219330,
			219335,
			219340,
			219342,
			219336,
			219341,
			219339,
			219337,
			219338,
			219502,
			219512,
			219507,
			219508,
			219489,
			219492,
			219501,
			219511,
			219509,
			219513,
			221803,
			221807,
			221805,
			221808,
			221801,
			221802,
			221804,
			221969,
			221806]]
		}
		self:RegisterCraft(110100, lootTable, {{12040, 9627}, {12040, 9627}, {12040, 12042, 9627}, {12040, 12043, 9627}}, {}, {{38, 8}, {38, 8}, {38, 8}, {38, 8}})
		-- quêtes
		quests = QUESTS_LABEL
		self:RegisterRaidInstance(110100, quests, quests, {{},{},{},{}}, {658, 658, 658, 658})
		lootTable = {
			228411
		}
		self:RegisterBossLoot(quests, lootTable, quests)


		local overrides = {
			[228411] = {
				noAdditionalSockets = true
			},
			[215136] = {
				defaultSockets = 1
			},
			[215135] = {
				defaultSockets = 1
			},
			[215134] = {
				defaultSockets = 1
			},
			[215133] = {
				defaultSockets = 1
			}
		}
		self:RegisterOverrides(overrides)
	end

	function TerremineRaid:InitializeZoneDetect(ZoneDetect)
		ZoneDetect:RegisterMapID(2406,   Terremine)
		ZoneDetect:RegisterNPCID(225821, Terremine, 1) -- 
		ZoneDetect:RegisterNPCID(225822, Terremine, 1) -- 
		ZoneDetect:RegisterNPCID(229177, Terremine, 2) -- 
		ZoneDetect:RegisterNPCID(229181, Terremine, 2) -- 
		--ZoneDetect:RegisterNPCID(228652, Terremine, 3) -- 
		ZoneDetect:RegisterNPCID(228648, Terremine, 3) -- 
		ZoneDetect:RegisterNPCID(230322, Terremine, 4) -- 
		ZoneDetect:RegisterNPCID(230583, Terremine, 5) -- 
		ZoneDetect:RegisterNPCID(228458, Terremine, 6) -- 
		ZoneDetect:RegisterNPCID(229953, Terremine, 7) --
		ZoneDetect:RegisterNPCID(231075, Terremine, 8) --


		ZoneDetect:RegisterMapID(2315, Lacolonie)
		ZoneDetect:RegisterNPCID(209230, Lacolonie, 1)
		ZoneDetect:RegisterNPCID(207205, Lacolonie, 2)
		ZoneDetect:RegisterNPCID(207207, Lacolonie, 3)

		ZoneDetect:RegisterMapID(2335, HydromelleriedeBrassecendre)
		ZoneDetect:RegisterNPCID(210271, HydromelleriedeBrassecendre, 1)
		ZoneDetect:RegisterNPCID(218002, HydromelleriedeBrassecendre, 2)
		ZoneDetect:RegisterNPCID(210267, HydromelleriedeBrassecendre, 3)
		ZoneDetect:RegisterNPCID(214661, HydromelleriedeBrassecendre, 4)

		ZoneDetect:RegisterMapID(2303, FailledeFlammeNoire)
		ZoneDetect:RegisterNPCID(210153, FailledeFlammeNoire, 1)
		ZoneDetect:RegisterNPCID(208743, FailledeFlammeNoire, 2)
		ZoneDetect:RegisterNPCID(208745, FailledeFlammeNoire, 3)
		ZoneDetect:RegisterNPCID(208747, FailledeFlammeNoire, 4)

		ZoneDetect:RegisterMapID(2308, PrieuredelaFlammesacree)
		ZoneDetect:RegisterNPCID(207946, PrieuredelaFlammesacree, 1)
		ZoneDetect:RegisterNPCID(207939, PrieuredelaFlammesacree, 2)
		ZoneDetect:RegisterNPCID(207940, PrieuredelaFlammesacree, 3)

		ZoneDetect:RegisterMapID(1010, LeFilon)
		ZoneDetect:RegisterNPCID(129214, LeFilon, 1)
		ZoneDetect:RegisterNPCID(129227, LeFilon, 2)
		ZoneDetect:RegisterNPCID(129231, LeFilon, 3)
		ZoneDetect:RegisterNPCID(129232, LeFilon, 4)
		ZoneDetect:RegisterNPCID(132713, LeFilon, 4)

		ZoneDetect:RegisterMapID(1683, TheatredelaSouffrance)
		ZoneDetect:RegisterNPCID(164451, TheatredelaSouffrance, 1)
		ZoneDetect:RegisterNPCID(164461, TheatredelaSouffrance, 1)
		ZoneDetect:RegisterNPCID(164463, TheatredelaSouffrance, 1)
		ZoneDetect:RegisterNPCID(162317, TheatredelaSouffrance, 2)
		ZoneDetect:RegisterNPCID(162329, TheatredelaSouffrance, 3)
		ZoneDetect:RegisterNPCID(162309, TheatredelaSouffrance, 4)
		ZoneDetect:RegisterNPCID(165946, TheatredelaSouffrance, 5)

		ZoneDetect:RegisterMapID(2387, OperationVannesouvertes)
		ZoneDetect:RegisterNPCID(226398, OperationVannesouvertes, 1)
		ZoneDetect:RegisterNPCID(226403, OperationVannesouvertes, 2)
		ZoneDetect:RegisterNPCID(226402, OperationVannesouvertes, 2)
		ZoneDetect:RegisterNPCID(226396, OperationVannesouvertes, 3)
		ZoneDetect:RegisterNPCID(236950, OperationVannesouvertes, 4)

		ZoneDetect:RegisterMapID(1490, operationmecagone)
		ZoneDetect:RegisterNPCID(144244, operationmecagone, 1)
		ZoneDetect:RegisterNPCID(145185, operationmecagone, 1)
		ZoneDetect:RegisterNPCID(144246, operationmecagone, 2)
		ZoneDetect:RegisterNPCID(144248, operationmecagone, 3)
		ZoneDetect:RegisterNPCID(144249, operationmecagone, 4)
		ZoneDetect:RegisterNPCID(150396, operationmecagone, 4)
		ZoneDetect:RegisterNPCID(150397, operationmecagone, 4)
	end


end
