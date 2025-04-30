local Dungeons = LibStub('AceAddon-3.0'):GetAddon('BestInSlotRedux'):NewModule('TWWDungeons')
local dungeonTierId = 111000
local tocVersion = select(1, GetBuildInfo())

local bonusIds_Cata = {										--TWWS1
	bonusids = {
		[1] = {10265,10390,10040},--MM+ Hero		--1=Ilvl610,1/6. 2=MM+.
		[2] = {10299,10390,11342},--M+ Casino		--1=ilvl639,6/6. 2=MM+.
	},
	difficultyconversion = {
		[1] = 16, -- Mythic+
		[2] = 16, -- Great Vault
	},
	}
local bonusIds_MoP = {
bonusids = {
	[1] = {10265,10390},--MM+ Hero					--1=Ilvl610,1/6. 2=MM+.
	[2] = {10299,10390},--M+ Casino					--1=ilvl639,6/6. 2=MM+.
},
difficultyconversion = {
	[1] = 16, -- Mythic+
	[2] = 16, -- Great Vault
},
}
local bonusIds_WoD = {										--DFS3
bonusids = {
	[1] = {10265,10390},--MM+ Hero					--1=Ilvl610,1/6. 2=MM+.
	[2] = {10299,10390},--M+ Casino					--1=ilvl639,6/6. 2=MM+.
},
difficultyconversion = {
	[1] = 16, -- Mythic+
	[2] = 16, -- Great Vault
},
}
local bonusIds_Legion = {									--DFS3
bonusids = {
	[1] = {10265,10390},--MM+ Hero					--1=Ilvl610,1/6. 2=MM+.
	[2] = {10299,10390},--M+ Casino					--1=ilvl639,6/6. 2=MM+.
},
difficultyconversion = {
	[1] = 16, -- Mythic+
	[2] = 16, -- Great Vault/
},
}
local bonusIds_BfA = {										--TWW1
bonusids = {
	[1] = {10265,10390,10018},--MM+ Hero			--1=Ilvl610,1/6. 2=MM+. 3= +551 a l iteme
	[2] = {10299,10390,10047},--M+ Casino			--1=ilvl639,6/6. 2=MM+. 3= +580 a l iteme
},
difficultyconversion = {
	[1] = 16, -- Mythic+
	[2] = 16, -- Great Vault
},
}
local bonusIds_OM = {--Operation Mecagone					--TWW1
bonusids = {
	[1] = {10265,10390,10018,1453},--MM+ Hero		--1=Ilvl610,1/6. 2=MM+.
	[2] = {10299,10390,10047,1453},--M+ Casino		--1=ilvl639,6/6. 2=MM+.
},
difficultyconversion = {
	[1] = 16, -- Mythic+
	[2] = 16, -- Great Vault
},
}
local bonusIds_SL = {										--TWW1
bonusids = {
	[1] = {10265,10390,9919},--MM+ Hero				--1=Ilvl610,1/6. 2=MM+.
	[2] = {10299,10390,9948},--M+ Casino			--1=ilvl639,6/6. 2=MM+.
},
difficultyconversion = {
	[1] = 16, -- Mythic+
	[2] = 16, -- Great Vault
},
}
local bonusIds_DF = {										--DFS4
bonusids = {
	[1] = {10265,10390},--MM+ Hero					--1=Ilvl610,1/6. 2=MM+.
	[2] = {10299,10390},--M+ Casino					--1=ilvl639,6/6. 2=MM+.
},
difficultyconversion = {
	[1] = 16, -- Mythic+
	[2] = 16, -- Great Vault
},
}
local bonusIds_TWW = {										--TWWS1
bonusids = {
	[1] = {10265,10390,1645},--MM+ Hero				--1=Ilvl610,1/6. 2=MM+.
	[2] = {10299,10390,3131},--M+ Casino			--1=ilvl639,6/6. 2=MM+.
},
difficultyconversion = {
	[1] = 16, -- Mythic+
	[2] = 16, -- Great Vault
},
}

										--------------------------------------------------
										-----Sillage necrotique
										--------------------------------------------------



function Dungeons:Sillagenecrotique()
local Sillagenecrotique = "Sillagenecrotique"
local name = C_Map.GetMapInfo(1666).name
self:RegisterRaidInstance(dungeonTierId, Sillagenecrotique, name, bonusIds_SL)

-----------------------------------
-----Boss 1: Chancros
-----------------------------------

local bossName = EJ_GetEncounterInfo(2395)
local lootTable = {
	178730, --Pilonneur de ver congestionne
	178735, --Chancrebuse
	178732, --Visage abominable
	178733, --Spallieres de Chancros
	178734, --Grande ceinture en os fusionne
	178731, --Souliers cousus de visceres
	178736, --Chevaliere egaree de Sutur
}
self:RegisterBossLoot(Sillagenecrotique, lootTable, bossName)

-----------------------------------
-----Boss 2: Amarth, le Moissonneur
-----------------------------------

bossName = EJ_GetEncounterInfo(2391)
lootTable = {
	178737, --Sorcelame d Amarth
	178738, --Chaperon de fin tireur cliquetant
	178740, --Mantelet de reanimateur
	178741, --Crispins de monstruosite ressuscitee
	178739, --Cuissards de frenesie impie
	178742, --Toxine d aile-ecorchee en bouteille
}
self:RegisterBossLoot(Sillagenecrotique, lootTable, bossName)

-----------------------------------
-----Boss 3: Docteur Sutur
-----------------------------------

bossName = EJ_GetEncounterInfo(2392)
lootTable = {
	178743, --Scalpel du docteur Sutur
	178750, --Couvercle de canope incruste
	178749, --Espauliers de boucher vil
	178744, --Pourpoint recemment embaume
	178748, --Gants de chirurgien ensanglantes
	178745, --Cuissardes de malveillance sans repos
	178751, --Crochet a viande de rechange
	178772, --Sacoche de serviteurs defectueux
}
self:RegisterBossLoot(Sillagenecrotique, lootTable, bossName)

-----------------------------------
-----Boss 4: Nalthor le Lieur-de-Givre
-----------------------------------

bossName = EJ_GetEncounterInfo(2396)
lootTable = {
	181819, --Renes de Croc-de-Moelle
	178780, --Lame runique du Lieur-de-Givre
	178777, --Casque du givre sombre
	178779, --Protege-epaules de froidure eternelle
	178782, --Entraves du seigneur de la necropole
	178778, --Garde-jambes en os de liche
	178781, --Anneau rituel de commandant
	178783, --eclat de phylactere drainant
}
self:RegisterBossLoot(Sillagenecrotique, lootTable, bossName)

end



										--------------------------------------------------
										-----Brumes de Tirna Scithe
										--------------------------------------------------



function Dungeons:BrumesdeTirnaScithe()
local BrumesdeTirnaScithe = "BrumesdeTirnaScithe"
local name = C_Map.GetMapInfo(1669).name
self:RegisterRaidInstance(dungeonTierId, BrumesdeTirnaScithe, name, bonusIds_SL)

-----------------------------------
-----Boss 1: Ingra Maloch
-----------------------------------

local bossName = EJ_GetEncounterInfo(2400)
local lootTable = {
	178713, --Bardiche du seigneur drust
	178709, --Sceptre en bois de Scithe
	178694, --Grand heaume en irecorce
	178692, --Visage epine-d ame
	178696, --Mantelet de l ingra Maloch
	178698, --Haubert ombre-pluie
	178704, --Bandelettes mortes-entraves
	178700, --Fermoir d ombres decroissantes
	178708, --Changelin delie
}
self:RegisterBossLoot(BrumesdeTirnaScithe, lootTable, bossName)

-----------------------------------
-----Boss 2: Mandebrume
-----------------------------------

bossName = EJ_GetEncounterInfo(2402)
lootTable = {
	178710, --epine du bois enchevetre
	178691, --Chaperon de la voie cachee
	182305, --Couronne de flore automnale
	178707, --Pendentif vire-piste
	178697, --Espauliers du farceur
	178695, --Garde-epaules de frimiver
	178706, --Gantelets de trame-brume
	178705, --Gants de lutin farceur
	178715, --Ocarina de mandebrume
}
self:RegisterBossLoot(BrumesdeTirnaScithe, lootTable, bossName)

-----------------------------------
-----Boss 3: Tred ova
-----------------------------------

bossName = EJ_GetEncounterInfo(2405)
lootTable = {
	183623, --Gormelin gueule-epine
	178714, --Fleche du savoir de Lakali
	178711, --Hache du bosquet mort
	178712, --Rempart en bourbacide
	178693, --Capuche en soie de cocon
	178703, --Brassards d essaim de ruche
	178702, --Poignets des Broussailles
	178699, --Ceinture avale-seve
	178701, --Greves en carapaces de gorm
}
self:RegisterBossLoot(BrumesdeTirnaScithe, lootTable, bossName)

end



										--------------------------------------------------
										-----Siege de Boralus
										--------------------------------------------------



function Dungeons:SiegedeBoralus()
local SiegedeBoralus = 'SiegedeBoralus'
local name = C_Map.GetMapInfo(1162).name
self:RegisterRaidInstance(dungeonTierId, SiegedeBoralus, name, bonusIds_BfA)

-----------------------------------
-----Boss 1: Crochesang
-----------------------------------

local bossName = EJ_GetEncounterInfo(2654)
local lootTable = {
	159972, --Destin du mutin
	159973, --Massue plombee d abordeur
	159968, --Gants des saccageurs de Fer
	159965, --Large ceinture de Crochesang
	159427, --Cuissards d ecumeur des Lamineurs
	159969, --Jambieres parle-poudre
	159251, --Bottillons de hune
	162541, --Bague du forban nomade
}
self:RegisterBossLoot(SiegedeBoralus, lootTable, bossName)

-----------------------------------
-----Boss 2: Capitaine de l effroi Boisclos
-----------------------------------

bossName = EJ_GetEncounterInfo(2173)
lootTable = {
	159649, --Sabre du pirate de l effroi Boisclos
	159372, --Fers de capitaine de l effroi
	159429, --Gantelets entailles par les cordes
	159237, --Inspecte-poussiere du capitaine
	159309, --Ceinture de pilleur de port
	159434, --Ceinture a outils de canonnier
	159250, --Jambieres d aide-artificier
	159379, --Solerets d appui assure
	159320, --Traquepont d assiegeant
	159623, --Longue-vue d oeil-mort
}
self:RegisterBossLoot(SiegedeBoralus, lootTable, bossName)

-----------------------------------
-----Boss 3: Hadal Sombrabysse
-----------------------------------

bossName = EJ_GetEncounterInfo(2134)
lootTable = {
	159650, --Griffe submersible demembree
	159386, --Ceinturon en chaine d ancre
	159322, --Culotte de marche-mers
	159428, --Plombeurs lestes
	159461, --Bague de l ancien dragueur de fonds
	159622, --Nautile de Hadal
}
self:RegisterBossLoot(SiegedeBoralus, lootTable, bossName)

-----------------------------------
-----Boss 4: Viq Goth
-----------------------------------

bossName = EJ_GetEncounterInfo(2140)
lootTable = {
	159651, --Croissant borde de corail
	231818, --Couronne avide des profondeurs
	231824, --Diademe du leviathan enveloppant
	231830, --Espauliers en carapace de kraken
	231826, --Spallieres barbelees de crochets
	231825, --Corselet tri-coeur
	231827, --Cuirasse de harponneur en plaques
	231822, --Veste en cephalocuir
	159256, --Bandelettes en varech de fer
}
self:RegisterBossLoot(SiegedeBoralus, lootTable, bossName)

end



										--------------------------------------------------
										-----Grim Batol
										--------------------------------------------------



function Dungeons: GrimBatol()
local GrimBatol = "GrimBatol"
local name = C_Map.GetMapInfo(293).name
self:RegisterRaidInstance(dungeonTierId, GrimBatol, name, bonusIds_Cata)

-----------------------------------
-----Boss 1: General Umbriss
-----------------------------------

local bossName = EJ_GetEncounterInfo(2617)
local lootTable = {
	133283, --Lame de Modgud
	157612, --Gardien draconien
	133285, --Heaume de monte marteau-hardi
	133284, --Gilet de skardyn maudit
	133354, --Culotte en fil scintillant
	133286, --Bague d'Umbriss
	133282, --Grace de Skardyn
}
self:RegisterBossLoot(GrimBatol, lootTable, bossName)

-----------------------------------
-----Boss 2: Maitre-forge Throngus
-----------------------------------

bossName = EJ_GetEncounterInfo(2627)
lootTable = {
	157613, --Tranchoir de geomancie
	133288, --Baguette de puissance non corrompue
	133363, --Drape cousu de Trogg
	133289, --Ceinture du maitre-forge
	133290, --Bottes en anneaux de sombrefer
	133287, --Anneau de Dun Algaz
	133291, --Doigt de Throngus
}
self:RegisterBossLoot(GrimBatol, lootTable, bossName)

-----------------------------------
-----Boss 3: Drahga Brule-Ombre
-----------------------------------

bossName = EJ_GetEncounterInfo(2618)
lootTable = {
	133296, --Lame Marche-vent
	133294, --Espauliers de terre sculptee
	133374, --Spallieres de messager monteur de dragon
	133292, --Cape de la nuee azur
	133295, --Brassards de la nuee cramoisie
	133293, --Bottes d'ecaille rouges
	157614, --Bottines d invocateur de flammes
}
self:RegisterBossLoot(GrimBatol, lootTable, bossName)

-----------------------------------
-----Boss 4: Erudax, le duc d En bas
-----------------------------------

bossName = EJ_GetEncounterInfo(2619)
lootTable = {
	133303, --Baton d'essences siphonnees
	133298, --Marteau hardi
	133301, --Masse d'os transforme
	133302, --Couronne des corps affaiblis
	133297, --Gilet de peaux difformes
	133306, --Brassards de guerison ombreuse
	157615, --Jambieres en anneaux de flamecaille
	133299, --Cercle d'os
	133304, --Bourrasque d'ombres
	133305, --Coquille d oeuf corrompu
	133300, --Marque de Khardros
}
self:RegisterBossLoot(GrimBatol, lootTable, bossName)

end



										--------------------------------------------------
										-----Ara-Kara, la cite des echos
										--------------------------------------------------



function Dungeons: AraKaralacitedesechos()
	local AraKaralacitedesechos = "AraKaralacitedesechos"
	local name = C_Map.GetMapInfo(2357).name
	self:RegisterRaidInstance(dungeonTierId, AraKaralacitedesechos, name, bonusIds_TWW)

-----------------------------------
-----Boss 1: Avanoxx
-----------------------------------

local bossName = EJ_GetEncounterInfo(2583)
local lootTable = {
	221150, --Trancheur d  mes arachno de
	221151, --Gantelets de devoreur
	221153, --Garde-jambes tisses de gaze
	221152, --Cuissardes d acier soyeux
	219314, --Essaim d oeufs d Ara-Kara
}
self:RegisterBossLoot(AraKaralacitedesechos, lootTable, bossName)

-----------------------------------
-----Boss 2: Anub zekt
-----------------------------------

bossName = EJ_GetEncounterInfo(2584)
lootTable = {
	221156, --Chapel de visite des cryptes
	221155, --Spallieres de monarque de l essaim
	221154, --Linceul du mande-essaim
	221157, --Manchettes incassables de fleau des hannetons
	221158, --Cordeliere de fouisseur
	219316, --Glande de l essaim perpetuel
}
self:RegisterBossLoot(AraKaralacitedesechos, lootTable, bossName)

-----------------------------------
-----Boss 3: Ki katal la Moissonneuse
-----------------------------------

bossName = EJ_GetEncounterInfo(2585)
lootTable = {
	221159, --Interdiction du moissonneur
	221160, --Glaive-scalpel de chasseur de peste
	221165, --Saigneur cavalier
	221163, --Masque murmurant
	221161, --Corselet de saignesoie experimentale
	221162, --Griffes de sanie souillee
	221164, --Bottillons de venimancie archaique
	219317, --edit de moissonneur
}
self:RegisterBossLoot(AraKaralacitedesechos, lootTable, bossName)

end



										--------------------------------------------------
										-----Cite des Fils
										--------------------------------------------------



function Dungeons: CitedesFils()
local CitedesFils = "CitedesFils"
local name = C_Map.GetMapInfo(2343).name
self:RegisterRaidInstance(dungeonTierId, CitedesFils, name, bonusIds_TWW)

-----------------------------------
-----Boss 1: Mandataire Krix vizk
-----------------------------------

local bossName = EJ_GetEncounterInfo(2594)
local lootTable = {
	221166, --Canne de parole de Krix vizk
	221167, --Brassards de subjugation vociferante
	221170, --Poignes-terreur de contrainte
	221168, --Cordeliere d influence remanente
	221169, --Pas sonores de chuchotement
	219318, --Larynx d orateur oppresseur
}
self:RegisterBossLoot(CitedesFils, lootTable, bossName)

-----------------------------------
-----Boss 2: Crocs de la reine
-----------------------------------

bossName = EJ_GetEncounterInfo(2595)
lootTable = {
	221171, --Croc-de-givre de regicide
	221172, --Seau d obscurite conservee
	221175, --Amict de frissombre
	221176, --Gilet d arachnogivre
	221174, --Garde-givre penombral
	221173, --Cuissards de dualite
	219319, --Instruments a doubles crocs
}
self:RegisterBossLoot(CitedesFils, lootTable, bossName)

-----------------------------------
-----Boss 3: La Coaglamation
-----------------------------------

bossName = EJ_GetEncounterInfo(2600)
lootTable = {
	221177, --Hielaman vieux-sang
	221181, --Amulette hemolymphatique d anciennete
	221179, --Cuirasse de coagulation
	221182, --Rubans vitrioliques tisses de veines
	221180, --etrangleurs sang-lie
	221178, --Solerets macules de sanies
	219320, --Coaglam visqueux
}
self:RegisterBossLoot(CitedesFils, lootTable, bossName)

-----------------------------------
-----Boss 4: Izo, le Grand Faisceau
-----------------------------------

bossName = EJ_GetEncounterInfo(2596)
lootTable = {
	221184, --Arrete-coeur chirurgical
	221183, --Couteau a tartare
	221187, --Capuche d ombres d entrelacement
	221185, --epaulettes de reprise de chair
	221188, --Manteau enduit de visceres
	221186, --Garde-jambes chimeriques entrelaces
	221189, --Bague du sujet 08752
	219321, --Concoctoire de Cirral
}
self:RegisterBossLoot(CitedesFils, lootTable, bossName)

end



										--------------------------------------------------
										-----Le Brise-Aube
										--------------------------------------------------



function Dungeons: LeBriseAube()
local LeBriseAube = "LeBriseAube"
local name = C_Map.GetMapInfo(2359).name
self:RegisterRaidInstance(dungeonTierId, LeBriseAube, name, bonusIds_TWW)

-----------------------------------
-----Boss 1: Mandataire Couronne d ombre
-----------------------------------

local bossName = EJ_GetEncounterInfo(2580)
local lootTable = {
	221132, --Seau ombral debordant
	221135, --epaules ceintes de fanatique noircies
	221134, --Ceinture de fidele de l ombre
	221133, --Ceinturon des sombres manigances
	221136, --Anneau de devotion zelee
	219311, --Pierre de pacte du Vide
}
self:RegisterBossLoot(LeBriseAube, lootTable, bossName)

-----------------------------------
-----Boss 2: Anub ikkaj
-----------------------------------

bossName = EJ_GetEncounterInfo(2581)
lootTable = {
	221137, --Guisarme de berger noir
	221138, --Lame ornementee de pasteur
	221140, --Mantelet de pestombre
	221139, --Carapace de pretre obscur
	221142, --Bandelettes d assaut premedite
	221202, --Solerets d ecrasement de defiance
	221141, --Chevaliere nerubienne noble
	219312, --Cristal de renforcement d Anub ikkaj
}
self:RegisterBossLoot(LeBriseAube, lootTable, bossName)

-----------------------------------
-----Boss 3: Rasha nan
-----------------------------------

bossName = EJ_GetEncounterInfo(2593)
lootTable = {
	221144, --Decoupe-voiles du zephyr
	221145, --Matraque de naufrageur
	221143, --Empaleur de coques incurve
	221146, --Grand heaume de l envol du behemoth
	221148, --epaulettes des ailes coupees
	221147, --Cotte de mailles chitineuse de goliath
	221149, --Mules membraneuses
	219313, --Glas de Mereldar
}
self:RegisterBossLoot(LeBriseAube, lootTable, bossName)

end



										--------------------------------------------------
										-----La Cavepierre
										--------------------------------------------------



function Dungeons: LaCavepierre()
local LaCavepierre = "LaCavepierre"
local name = C_Map.GetMapInfo(2341).name
self:RegisterRaidInstance(dungeonTierId, LaCavepierre, name, bonusIds_TWW)

-----------------------------------
-----Boss 1: E.D.N.A.
-----------------------------------

local bossName = EJ_GetEncounterInfo(2572)
local lootTable = {
	221078, --Manivelle endosquelettique
	221074, --Canon a refraction augmente
	221073, --egide d annulation terrestre
	221077, --Porte-cle Arret d urgence 
	221075, --Cotte de mailles anti-intrusion renforcee
	221076, --Stabilisateurs d E.D.N.A.
	219315, --Module de refraction des agressions
}
self:RegisterBossLoot(LaCavepierre, lootTable, bossName)

-----------------------------------
-----Boss 2: Skarmorak
-----------------------------------

bossName = EJ_GetEncounterInfo(2579)
lootTable = {
	221083, --Brisegarde de la fracture
	221084, --Misericorde skardyn
	221081, --Semblance de l assemblage
	221080, --Poignes saigne-cadavre
	221079, --Ceinturon de fissure de cristal
	221082, --Brodequins d eclat de terre taches
	219300, --Fragment de Skarmorak
}
self:RegisterBossLoot(LaCavepierre, lootTable, bossName)

-----------------------------------
-----Boss 3: Machinistes en chef
-----------------------------------

bossName = EJ_GetEncounterInfo(2590)
lootTable = {
	221085, --Chantefleche en fer melodieuse
	221088, --Pelerine en peau d enclume
	221086, --Garde-mains brulants de machiniste
	221087, --Ceinture de securite de Dorlita
	219301, --Lanceur d ecroumerang suralimente
	219302, --Symphonie du chante-ferraille
}
self:RegisterBossLoot(LaCavepierre, lootTable, bossName)

-----------------------------------
-----Boss 4: Orateur du Vide Eirich
-----------------------------------

bossName = EJ_GetEncounterInfo(2582)
lootTable = {
	226683, --Mecarmure defectueuse
	221090, --Poing de tromperie d Eirich
	221091, --Sermon tranchant
	221089, --Arbalete cajolante
	221094, --Chape ombreuse murmurante
	221095, --Tunique de mandataire d ombre
	221092, --Cuissards de la confiance brisee
	219303, --Accretion du haut-mandataire
}
self:RegisterBossLoot(LaCavepierre, lootTable, bossName)

end



function Dungeons:InitializeZoneDetect(ZoneDetect)
----------------------------------------------------------------------------------------------------------
local Sillagenecrotique = "Sillagenecrotique"
ZoneDetect:RegisterMapID(1666, Sillagenecrotique)
ZoneDetect:RegisterNPCID(162691, Sillagenecrotique, 1)--Chancros
ZoneDetect:RegisterNPCID(163157, Sillagenecrotique, 2)--Amarth, le Moissonneur
ZoneDetect:RegisterNPCID(166882, Sillagenecrotique, 3)--Docteur Sutur
ZoneDetect:RegisterNPCID(166945, Sillagenecrotique, 4)--Nalthor le Lieur-de-Givre

local BrumesdeTirnaScithe = "BrumesdeTirnaScithe"
ZoneDetect:RegisterMapID(1669, BrumesdeTirnaScithe)
ZoneDetect:RegisterNPCID(164567, BrumesdeTirnaScithe, 1)--Ingra Maloch
ZoneDetect:RegisterNPCID(170217, BrumesdeTirnaScithe, 2)--Mandebrume
ZoneDetect:RegisterNPCID(164517, BrumesdeTirnaScithe, 3)--Tred ova

local SiegedeBoralus = 'SiegedeBoralus'
ZoneDetect:RegisterMapID(1162, SiegedeBoralus)
ZoneDetect:RegisterNPCID(144160, SiegedeBoralus, 1)--Crochesang
ZoneDetect:RegisterNPCID(130834, SiegedeBoralus, 1)--Sergeant Bainbridge [H]
ZoneDetect:RegisterNPCID(129208, SiegedeBoralus, 2)--Capitaine de l effroi Boisclos
ZoneDetect:RegisterNPCID(130836, SiegedeBoralus, 3)--Hadal Sombrabysse
ZoneDetect:RegisterNPCID(128652, SiegedeBoralus, 4)--Viq Goth

local GrimBatol = "GrimBatol"
ZoneDetect:RegisterMapID(293, GrimBatol)
ZoneDetect:RegisterNPCID(39625, GrimBatol, 1)--General Umbriss
ZoneDetect:RegisterNPCID(40177, GrimBatol, 2)--Maitre-forge Throngus
ZoneDetect:RegisterNPCID(40319, GrimBatol, 3)--Drahga Brule-Ombre
ZoneDetect:RegisterNPCID(40484, GrimBatol, 4)--Erudax, le duc d En bas

local AraKaralacitedesechos = "AraKaralacitedesechos"
ZoneDetect:RegisterMapID(2167, AraKaralacitedesechos)
ZoneDetect:RegisterNPCID(213179, AraKaralacitedesechos, 1)--Avanoxx
ZoneDetect:RegisterNPCID(215405, AraKaralacitedesechos, 2)--Anub zekt
ZoneDetect:RegisterNPCID(231649, AraKaralacitedesechos, 3)--Ki katal la Moissonneuse

local CitedesFils = "CitedesFils"
ZoneDetect:RegisterMapID(2343, CitedesFils)
ZoneDetect:RegisterNPCID(216619, CitedesFils, 1)--Mandataire Krix vizk
ZoneDetect:RegisterNPCID(216648, CitedesFils, 2)--Crocs de la reine
ZoneDetect:RegisterNPCID(216649, CitedesFils, 2)--Crocs de la reine
ZoneDetect:RegisterNPCID(216320, CitedesFils, 3)--La Coaglamation
ZoneDetect:RegisterNPCID(216658, CitedesFils, 4)--Izo, le Grand Faisceau

local LeBriseAube = "LeBriseAube"
ZoneDetect:RegisterMapID(2169, LeBriseAube)
ZoneDetect:RegisterNPCID(211087, LeBriseAube, 1)--Mandataire Couronne d ombre
ZoneDetect:RegisterNPCID(211089, LeBriseAube, 2)--Anub ikkaj
ZoneDetect:RegisterNPCID(224552, LeBriseAube, 3)--Rasha nan

local LaCavepierre = "LaCavepierre"
ZoneDetect:RegisterMapID(2341, LaCavepierre)
ZoneDetect:RegisterNPCID(210108, LaCavepierre, 1)--E.D.N.A.
ZoneDetect:RegisterNPCID(210156, LaCavepierre, 2)--Skarmorak
ZoneDetect:RegisterNPCID(213216, LaCavepierre, 3)--Machinistes en chef
ZoneDetect:RegisterNPCID(213119, LaCavepierre, 4)--Orateur du Vide Eirich

end

function Dungeons:OnEnable()
self:RegisterExpansion("Myhtic+", "Myhtic+")
self:RegisterRaidTier("Myhtic+", dungeonTierId, ("%s %s"):format("Myhtic+ ", "TWW Season 1"), PLAYER_DIFFICULTY6.."+ Hero 1/6 ",  PLAYER_DIFFICULTY6.."+ Vault Myth 6/6")

self:Sillagenecrotique()
self:BrumesdeTirnaScithe()
self:SiegedeBoralus()
self:GrimBatol()
self:AraKaralacitedesechos()
self:CitedesFils()
self:LeBriseAube()
self:LaCavepierre()
end