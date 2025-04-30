local NerubRaid = LibStub("AceAddon-3.0"):GetAddon("BestInSlotRedux"):NewModule("NerubRaid")
local Nerub = "Nerub"
local playername, realm = UnitFullName("player")
local realm = GetNormalizedRealmName()
local tocVersion = select(1, GetBuildInfo())
local tierHelm, tierShoulders, tierChest, tierLegs, tierGloves = 1, 3, 5, 7, 10
if tocVersion >= "11.0.0" then
function NerubRaid:OnEnable()
--local L = LibStub("AceLocale-3.0"):GetLocale("BestInSlotRedux")

	local NerubName = EJ_GetInstanceInfo(1273)
	self:RegisterExpansion("The War Within", EXPANSION_NAME10)
	self:RegisterRaidTier("The War Within", 110000, NerubName, PLAYER_DIFFICULTY3, PLAYER_DIFFICULTY1, PLAYER_DIFFICULTY2, PLAYER_DIFFICULTY6)
	self:RegisterRaidInstance(110000, Nerub, NerubName, {
		bonusids = {
		[1] = {3524},
		[2] = {3524},
		[3] = {3524},
		[4] = {3524},
		},
		difficultyconversion = {
		[1] = 4, --Raid LFR
		[2] = 3, --Raid Normal
		[3] = 5, --Raid Heroic
		[4] = 6, --Raid Mythic
		}
	})
	-------------------------------------------------
	-----Palais des Nérub’ar
	--------------------------------------------------


		-----------------------------------
		-----Boss 1: Ulgrax le Dévoreur
		-----------------------------------
		local bossName = EJ_GetEncounterInfo(2607)
		local lootTable = {
			212388, --Brise-bouchée d’Ulgrax
			212409, --Griffe gravée au venin
			212386, --Enveloppe des ténèbres engloutissantes
			212428, --Cornes du dernier repas
			212424, --Rochers d’épaules de Terrestre aguerris
			212446, --Emblème royal des Nérub’ar
			212419, --Harnais trempé de bile
			212426, --Protège-poignets d’intruse croustillante
			212425, --Entrailles crispées de dévoreur
			212442, --Grande ceinture de l’Affameur
			212423, --Sarouel médullaire épuisé de rebelle
			212431, --Souliers doublés de terralènes
			219915, --Chélicère du béhémoth fétide
		}
		self:RegisterBossLoot(Nerub, lootTable, bossName)
		-----------------------------------
		-----Boss 2: L’horreur liée par le sang
		-----------------------------------
		local bossName = EJ_GetEncounterInfo(2611)
		local lootTable = {
			212395, --Kukri léché par le sang
			212404, --Sceptre de miasmes manifestés
			212417, --Visage noir de l’au-delà
			212439, --Balises de la fausse aube
			212421, --Membrane mouchetée de sang
			212438, --Bandelettes de spectre polluées
			212430, --Cordelette de l’Œil brisé
			212414, --Dépouille de la garde perdue
			212422, --Cuissards d’horreur liée par le sang
			225590, --Bottes du rempart noir
			212447, --Clé de l’Invisible
			219917, --Coagulation rampante
			212451, --Forgesort aberrante
		}
		self:RegisterBossLoot(Nerub, lootTable, bossName)
		-----------------------------------
		-----Boss 3: Sikran, capitaine des Surekis
		-----------------------------------
		local bossName = EJ_GetEncounterInfo(2599)
		local lootTable = {
			225621, --Emblème de vaillance du Zénith
			225619, --Emblème de vaillance mystique
			225618, --Emblème de vaillance terrible
			225620, --Emblème de vaillance vénérée
			223097, --Patron : fermoir d’afflux surrénal
			212413, --Perforateur d’exécution honorable
			212392, --Acier dansant de duelliste
			212405, --Lame de phase parfaite
			212399, --Arbalète en soie à fragmentation
			212427, --Visière du capitaine sublimé
			225577, --Insigne de zélote sureki
			212415, --Bracelets de défense du trône
			212445, --Bottes cavalières à éperons en chitine
			212416, --Bottines à teinte cosmique
			212449, --Arsenal infini de Sikran
		}
		self:RegisterBossLoot(Nerub, lootTable, bossName)
		-----------------------------------
		-----Boss 4: Rasha’nan
		-----------------------------------
		local bossName = EJ_GetEncounterInfo(2609)
		local lootTable = {
			225633, --Idole d’obscénité du Zénith
			225631, --Idole d’obscénité mystique
			225630, --Idole d’obscénité terrible
			225632, --Idole d’obscénité vénérée
			224435, --Patron : doublure en fil vespéral
			212391, --Crochets à festin de prédatrice
			212398, --Matraque des vents incendiaires
			212440, --Coiffe abandonnée de dévotion
			212448, --Médaillon des souvenirs brisés
			225574, --Ailes du chagrin brisé
			212437, --Menottes de falotière ravagées
			225583, --Cordelière érodée de béhémoth
			225586, --Serres grotesques de Rasha’nan
			212453, --Organe corrosif de terreur-du-ciel
		}
		self:RegisterBossLoot(Nerub, lootTable, bossName)
		-----------------------------------
		-----Boss 5: Toressaim Ovi’nax
		-----------------------------------
		local bossName = EJ_GetEncounterInfo(2612)
		local lootTable = {
			225617, --Effigie de blasphème du Zénith
			225615, --Effigie de blasphème mystique
			225614, --Effigie de blasphème terrible
			225616, --Effigie de blasphème vénérée
			226190, --Recette : petite douceur collante
			212389, --Flèche des horreurs transfusées
			212387, --Catalyseur sombre de toressaim
			225588, --Bandages d’expérience sanguine
			212418, --Injecteurs de Sang noir
			225580, --Bobine de Sublimation accélérée
			225582, --Mules en coquilles assimilées
			225576, --Teigne frémissante
			212452, --Seringue macabre
			220305, --Œuf mercurien d’Ovi’nax
		}
		self:RegisterBossLoot(Nerub, lootTable, bossName)
		-----------------------------------
		-----Boss 6: Princesse-nexus Ky’veza
		-----------------------------------
		local bossName = EJ_GetEncounterInfo(2601)
		local lootTable = {
			225629, --Icône de tueur pourfendeur du Zénith
			225627, --Icône de tueur pourfendeur mystique
			225626, --Icône de tueur pourfendeur terrible
			225628, --Icône de tueur pourfendeur vénéré
			223048, --Plans : stylet de siphonnage
			219877, --Lame de distorsion de la faucheuse du Vide
			225636, --Régicide
			212400, --Museleur touché par l’ombre
			225581, --Fermoirs cachés de Ky’veza
			212441, --Manchettes de la nuit sans étoiles
			225589, --Grande ceinture de la manne du Néant
			225591, --Souliers du massacre fugace
			212456, --Contrat de faucheuse du Vide
			221023, --Transmetteur traître
		}
		self:RegisterBossLoot(Nerub, lootTable, bossName)
		-----------------------------------
		-----Boss 7: La cour Soyeuse
		-----------------------------------
		local bossName = EJ_GetEncounterInfo(2608)
		local lootTable = {
			223094, --Dessin : magnifique monture de joaillier
			225625, --Insigne de connivence du Zénith
			225623, --Insigne de connivence mystique
			225622, --Insigne de connivence terrible
			225624, --Insigne de connivence vénérée
			212407, --Mandibule colossale d’Anub’arash
			212397, --Édit entropique de Takazj
			225575, --Faveur de conseil soyeux
			212429, --Spallières de la lumière du Vide murmurant
			225584, --Crispins fourbes de Tournepeau
			212432, --Empaleurs des Mille cicatrices
			212443, --Grèves en carafracas
			212450, --Autorité du seigneur de l’essaim
			220202, --Toile de la maîtresse de l’espionnage
		}
		self:RegisterBossLoot(Nerub, lootTable, bossName)
		-----------------------------------
		-----Boss 8: Reine Ansurek
		-----------------------------------
		local bossName = EJ_GetEncounterInfo(2602)
		local lootTable = {
			224147, --Rênes de rasoir-céleste sureki
			212394, --Dédain de la souveraine
			212401, --Jugement final d’Ansurek
			225579, --Écu de la despote caustique
			212444, --Cadre de l’insurrection réprimée
			212433, --Camouflage venimeux d’omnivore
			212420, --Carapace de garde de la reine
			225587, --Fers de l’offrande dévouée
			212436, --Pognes de paranoïa
			225585, --Écharpe d’aigreur sublime
			212435, --Jambières de défection liquéfiées
			212434, --Sarong conseillé par le Vide
			225578, --Sceau du pacte empoisonné
			212454, --Mandat de la reine folle
		}
		self:RegisterBossLoot(Nerub, lootTable, bossName)

	--------------------------------------------------
	----- Trash Loot
	--------------------------------------------------
	local bossName = "Trash Loot"
	local lootTable = {

	}
	self:RegisterBossLoot(Nerub, lootTable, bossName)
	self:RegisterTierTokens(110000, {
		[tierHelm] = {
			[225622] = {
				["DEATHKNIGHT"] = 212002,
				["WARLOCK"] = 212074,
				["DEMONHUNTER"] = 212065,
			},
			[225623] = {
				["HUNTER"] = 212020,
				["MAGE"] = 212092,
				["DRUID"] = 212056,
			},
			[225624] = {
				["PALADIN"] = 211993,
				["PRIEST"] = 212083,
				["SHAMAN"] = 212011,
			},
			[225625] = {
				["WARRIOR"] = 211984,
				["ROGUE"] = 212038,
				["MONK"] = 212047,
				["EVOKER"] = 212029,
			},
		},
		[tierShoulders] = {
			[225630] = {
				["DEATHKNIGHT"] = 212000,
				["WARLOCK"] = 212072,
				["DEMONHUNTER"] = 212063,
			},
			[225631] = {
				["HUNTER"] = 212018,
				["MAGE"] = 212090,
				["DRUID"] = 212054,
			},
			[225632] = {
				["PALADIN"] = 211991,
				["PRIEST"] = 212081,
				["SHAMAN"] = 212009,
			},
			[225633] = {
				["WARRIOR"] = 211982,
				["ROGUE"] = 212036,
				["MONK"] = 212045,
				["EVOKER"] = 212027,
			},
		},
		[tierChest] = {
			[225614] = {
				["DEATHKNIGHT"] = 212005,
				["WARLOCK"] = 212077,
				["DEMONHUNTER"] = 212068,
			},
			[225615] = {
				["HUNTER"] = 212023,
				["MAGE"] = 212095,
				["DRUID"] = 212059,
			},
			[225616] = {
				["PALADIN"] = 211996,
				["PRIEST"] = 212086,
				["SHAMAN"] = 212014,
			},
			[225617] = {
				["WARRIOR"] = 211987,
				["ROGUE"] = 212041,
				["MONK"] = 212050,
				["EVOKER"] = 212032,
			},
		},
		[tierLegs] = {
			[225626] = {
				["DEATHKNIGHT"] = 212001,
				["WARLOCK"] = 212073,
				["DEMONHUNTER"] = 212064,
			},
			[225627] = {
				["HUNTER"] = 212019,
				["MAGE"] = 212091,
				["DRUID"] = 212055,
			},
			[225628] = {
				["PALADIN"] = 211992,
				["PRIEST"] = 212082,
				["SHAMAN"] = 212010,
			},
			[225629] = {
				["WARRIOR"] = 211983,
				["ROGUE"] = 212037,
				["MONK"] = 212046,
				["EVOKER"] = 212028,
			},
		},
		[tierGloves] = {
			[225618] = {
				["DEATHKNIGHT"] = 212003,
				["WARLOCK"] = 212075,
				["DEMONHUNTER"] = 212066,
			},
			[225619] = {
				["HUNTER"] = 212021,
				["MAGE"] = 212093,
				["DRUID"] = 212057,
			},
			[225620] = {
				["PALADIN"] = 211994,
				["PRIEST"] = 212084,
				["SHAMAN"] = 212012,
			},
			[225621] = {
				["WARRIOR"] = 211985,
				["ROGUE"] = 212039,
				["MONK"] = 212048,
				["EVOKER"] = 212030,
			},
		},
	}, 225634)
end

function NerubRaid:InitializeZoneDetect(ZoneDetect)
	ZoneDetect:RegisterMapID(2232,   Nerub)
	ZoneDetect:RegisterNPCID(209333, Nerub, 1) -- 
	ZoneDetect:RegisterNPCID(206689, Nerub, 2) -- 
	ZoneDetect:RegisterNPCID(208478, Nerub, 3) -- 
	ZoneDetect:RegisterNPCID(208363, Nerub, 4) -- 
	ZoneDetect:RegisterNPCID(208365, Nerub, 4) -- 
	ZoneDetect:RegisterNPCID(213390, Nerub, 4) -- 
	ZoneDetect:RegisterNPCID(208445, Nerub, 5) -- 
	ZoneDetect:RegisterNPCID(206172, Nerub, 6) -- 
	ZoneDetect:RegisterNPCID(214082, Nerub, 7) -- 
	ZoneDetect:RegisterNPCID(209090, Nerub, 8) -- 
end

end
