--  lua functions
local select, setmetatable, error, type, rawget, rawset, pairs, tonumber, strsplit, tContains, unpack, tostring, wipe, tinsert, tsort, tconcat, tremove
    = select, setmetatable, error, type, rawget, rawset, pairs, tonumber, strsplit, tContains, unpack, tostring, wipe, table.insert, table.sort, table.concat, table.remove
-- WoW API
local GetNumSpecializations, GetSpecializationInfo, GetItemInfo, IsEquippedItem, GetContainerNumSlots, GetContainerItemID, UnitClass, GetInventorySlotInfo, GetNumGuildMembers, ConvertRGBtoColorString, GetInventoryItemLink, GetContainerItemInfo, GetAddOnMetadata, GetItemSpecInfo, GetItemUniqueness, IsInGuild, GetGuildInfo, GetSpecialization, GetSpecializationInfoByID, IsInRaid, UnitName, IsInGroup, GetGuildRosterInfo, UnitFullName, UnitRace, UnitSex
---@diagnostic disable-next-line: deprecated
    = GetNumSpecializations, GetSpecializationInfo, C_Item.GetItemInfo, IsEquippedItem, GetContainerNumSlots, GetContainerItemID, UnitClass, GetInventorySlotInfo, GetNumGuildMembers, ConvertRGBtoColorString, GetInventoryItemLink, GetContainerItemInfo, C_AddOns.GetAddOnMetadata, C_Item.GetItemSpecInfo, C_Item.GetItemUniqueness, IsInGuild, GetGuildInfo, GetSpecialization, GetSpecializationInfoByID, IsInRaid, UnitName, IsInGroup, GetGuildRosterInfo, UnitFullName, UnitRace, UnitSex

local E = select(2, ...)
local BestInSlot = LibStub("AceAddon-3.0"):NewAddon("BestInSlotRedux", "AceComm-3.0", "AceHook-3.0", "AceSerializer-3.0", "AceTimer-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("BestInSlotRedux")
local AceEvent = LibStub("AceEvent-3.0")
E[1] = BestInSlot
E[2] = L
E[3] = AceGUI
BestInSlot.unsafeIDs = {}
BestInSlot.options = {}
BestInSlot.defaultModuleState = false
BestInSlot.options.DEBUG = false
-- Authors
BestInSlot.Author1 = ("%s%s @ %s"):format("|c"..RAID_CLASS_COLORS.DEMONHUNTER.colorStr, "Beleria".."|r",ConvertRGBtoColorString(PLAYER_FACTION_COLORS[1]).."Argent Dawn-EU|r")
BestInSlot.Author2 = ("%s%s @ %s"):format("|c"..RAID_CLASS_COLORS.PALADIN.colorStr, "Anhility".."|r",ConvertRGBtoColorString(PLAYER_FACTION_COLORS[1]).."Ravencrest-EU|r")
BestInSlot.Author3 = ("%s%s @ %s"):format("|c"..RAID_CLASS_COLORS.ROGUE.colorStr, "Sar\195\173th".."|r",ConvertRGBtoColorString(PLAYER_FACTION_COLORS[1]).."Tarren Mill-EU|r")
BestInSlot.Author0 = ("%s%s @ %s"):format("|c"..RAID_CLASS_COLORS.ROGUE.colorStr, "Swarley".."|r",ConvertRGBtoColorString(PLAYER_FACTION_COLORS[1]).."Burning Legion-NA|r")
BestInSlot.Author4 = ("%s%s @ %s"):format("|c"..RAID_CLASS_COLORS.DRUID.colorStr, "Dioxina".."|r",ConvertRGBtoColorString(PLAYER_FACTION_COLORS[1]).."Antonidas-EU|r")
--@non-debug@
BestInSlot.version = 20250429203700
--@end-non-debug@
BestInSlot.AlphaVersion = false --not (GetAddOnMetadata("BestInSlotRedux", "Version"):find("Release") and true or false)
local slashCommands = {}
local defaults = {
  char = {
    ['*'] = { --raidTier
      ['*'] = { --raidDifficulty
         ['*'] = { --listType (spec as number, customList as string)
           ['*'] = nil
         }
       },
    },
    latestVersion = 1,
    selected = {},
    windowpos = {},
    customlists = {},
    tutorials = {},
    options = {
      windowFixed = false,
      showBiSTooltip = true,
      sendAutomaticUpdates = true,
      receiveAutomaticUpdates = true,
      minimapButton = true,
      guildtooltip = true,
      showBossTooltip = true,
      keepHistory = false,
      tooltipCombat = false,
      historyLength = "30d",
      historyAutoDelete = true,
      tooltipSource = true,
      statsInManager = true,
      showGuildRankInTooltip = {
        ['*'] = true
      },
      overviewfilter = {},
    },
  },
  global = {
    options = {
      instantAnimation = false,
    },
    customitems = {

    },
    tutorials = true,
  },
  factionrealm = {
    _history = {
      ['*'] = {}, --players database
    },
    ['*'] = { --guildname
      ['*'] = { -- charactername
        ['*'] = { -- raidTier
          ['*'] = { -- difficulty

          }
        }
      }
    }
  },
  profile = {
    minimap = {
      hide = false,
    }
  },
}
---
--Datatypes to be used with some of BestInSlots functions
---
BestInSlot.EXPANSION = 1
BestInSlot.RAIDTIER = 2
BestInSlot.INSTANCE = 3
BestInSlot.BOSS = 4
BestInSlot.DIFFICULTY = 5
BestInSlot.SPECIALIZATION = 6

BestInSlot.MSGPREFIX = "BiS"
---
--Color codes used by the add-on
---
BestInSlot.colorHighlight = RED_FONT_COLOR_CODE
BestInSlot.colorNormal = NORMAL_FONT_COLOR_CODE
---
--data = {
--  raidTiers = {
--    [raidTierId] = {
--      description = "Raid Tier Description",
--      difficulties = {"difficultyName1", "difficultyName2"},
--      expansion = expansionId,
--      instances = {},
--      tierTokens = {},
--      tierItems = {
--        [Class1] = {
--          [difficultyName1] = {
--            tierItemId1,
--            tierItemId2,
--            tierItemId3,
--          },
--          [difficultyName2] = {
--            tierItemId1,
--            tierItemId2,
--            tierItemId3,
--          },
--        }
--      }
--    }
--  },
--  instances = {
--    [instanceId] = {
--      raidTier = raidTierID,
--      expansion = expansionId,
--      description = "Description
--    }
--  },
--  expansions = {
--    [expansionId] = {
--      raidTiers = {},
--      instances = {},
--      description = "Description",
--    }
--  }
--}
---
local data = {
  raidTiers = {},
  instances = {__default={
    difficultyconversion = {
      [1] = 4,  --Raid LFR
      [2] = 3,  --Raid Normal
      [3] = 5,  --Raid Heroic
      [4] = 6,  --Raid Mythic
      [5] = 83,  --Raid LFR Extended
      [6] = 82,  --Raid Normal Extended
      [7] = 84,  --Raid Heroic Extended
      [8] = 85, --Raid Mythic Extended
    },
    bonusids = {
      [1] = {3524},
      [2] = {3524},
      [3] = {3524},
      [4] = {3524},
      [5] = {3524},
      [6] = {3524},
      [7] = {3524},
      [8] = {3524},
    },
  }},
  expansions = {},
  bosses = {},
  tiertokens = {},
}

local ilvlOffsetIDs = {
  [1] = 5846,
  [2] = 5847,
  [3] = 5848,
  [4] = 5849,
  [5] = 5850,
  [6] = 5851,
  [7] = 5852,
  [8] = 5853,
  [9] = 5854,
  [10] = 5855,
  [20] = 5865,
  [30] = 5875,
  [40] = 5885,
  [50] = 5895,
  [60] = 5905,
  [70] = 5915,
  [80] = 5925,
  [90] = 5935,
  [100] = 5945,
  [200] = 6045,
  [300] = 6145,
  [400] = 6245,
  [500] = 9967,
  [600] = 10067,
  [700] = 11440,
  [800] = 11540,
  [900] = 11640
}

---
--itemData = {
--  [instanceName]={
--    [bossId] = {
--      [itemid] = {
--        dungeon = "dungeon",
--        link = "link",
--        isBiS = {
--          [difficulty] = {
--            [specId] = true
--          }
--        }
--        [difficulty] = ..
--        equipSlot = "INVTYPE_[SLOT]"
--      }
--    }
--  }
--}
--
--itemData's metatable can accept itemids. When it is requested an itemid it'll look in nested tables to find the item in question
---
local itemDataCache = {}
local itemData = setmetatable({},{
   __index = function(tbl, key)
      local value = itemDataCache[key]
      if value then return value end
      for dungeon,dungeonData in pairs(tbl) do --we can do this without error checking because the __newindex metamethod will check if it's a table
        for bossId, bossData in pairs(dungeonData) do
          if bossData[key] then itemDataCache[key] = bossData[key] return itemDataCache[key] end
        end
      end
   end,
   __newindex = function(table, key, value)
      if type(value) ~= "table" then error("Can only add tables to the itemData table") end
      rawset(table, key, value)
   end
})
local tierTokenData = {}
local customItems = {}
local trackIdRanking = {}
local maxDifficulties
local contextToDifficulty = {
  [4] = 1,
  [3] = 2,
  [5] = 3,
  [6] = 4,
  [68] = 1,
  [69] = 2,
  [70] = 3
}
BestInSlot.slots = {"HeadSlot", "NeckSlot","ShoulderSlot","BackSlot","ChestSlot","WristSlot","HandsSlot","WaistSlot","LegsSlot","FeetSlot", "Finger0Slot","Finger1Slot","Trinket0Slot","Trinket1Slot", "MainHandSlot","SecondaryHandSlot"}
BestInSlot.invSlots = {
  [1] = "INVTYPE_HEAD",
  [2] = "INVTYPE_NECK",
  [3] = "INVTYPE_SHOULDER",
  [4] = "INVTYPE_BODY",
  [5] = {"INVTYPE_CHEST", "INVTYPE_ROBE"},
  [6] = "INVTYPE_WAIST",
  [7] = "INVTYPE_LEGS",
  [8] = "INVTYPE_FEET",
  [9] = "INVTYPE_WRIST",
  [10] = "INVTYPE_HAND",
  [11] = "INVTYPE_FINGER",
  [12] = "INVTYPE_FINGER",
  [13] = "INVTYPE_TRINKET",
  [14] = "INVTYPE_TRINKET",
  [15] = "INVTYPE_CLOAK",
  [16] = {"INVTYPE_WEAPON", "INVTYPE_2HWEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_RANGED", "INVTYPE_RANGEDRIGHT", "INVTYPE_NON_EQUIP"},
  [17] = {"INVTYPE_WEAPONOFFHAND", "INVTYPE_SHIELD", "INVTYPE_WEAPON", "INVTYPE_HOLDABLE", "INVTYPE_NON_EQUIP"},
  --[18] = {"INVTYPE_RANGED", "INVTYPE_THROWN", "INVTYPE_RANGEDRIGHT", "INVTYPE_RELIC"}
}
BestInSlot.invSlotsId = {
	[1] = {1},
	[2] = {2},
	[3] = {3},
	[4] = {4},
	[5] = {5},
	[6] = {6},
	[7] = {7},
	[8] = {8},
	[9] = {9},
	[10] = {10},
	[11] = {11,12},
	[12] = {13,14},
	[13] = {16,17},
	[14] = {17},
  [15] = {16},
  [16] = {15},
  [17] = {16,17},
  [20] = {5},
  [21] = {16},
  [22] = {16},
  [23] = {17}
}
BestInSlot.dualWield = {250, 251, 252, 268, 269, 259, 260, 261, 263, 71, 72}

------------------------------------------------------------------------------------------------------------------------------------------------
-- MODULE REGISTRATION
------------------------------------------------------------------------------------------------------------------------------------------------

--- This function can be used by modules to add their data to the add-on. It checks if the proper values are set
--@param #string unlocalizedName the Localized Name of the expansion to register
--@param #string localizedDescription The localized description of the expansion to add
function BestInSlot:RegisterExpansion(unlocalizedName, localizedDescription)
  if data.expansions[unlocalizedName]  then
    return
  end
  data.expansions[unlocalizedName] = {description = localizedDescription, raidTiers = {}, instances = {}}
end
--- Registers a raid tier to BestInSlot
-- @param #string expansion The expansion ID, must have been registered before by using BestInSlot:RegisterExpansion
-- @param #number raidTier The number corresponding with the Raid Tier, must be unique. The standard is to use the patch version the raid tier belongs to (e.g. 50400 for patch 5.4)
-- @param #string description The description of the raid tier. By default 'Patch 5.4'
-- @param #... The next parameters are considered the difficulties you would like to add, can be "Normal", "Heroic", and "Mythic".
function BestInSlot:RegisterRaidTier(expansion, raidTier, description, bonusIds, targetiLvl, trackId, maxSockets, socketsBonusIds, gems, enchants, embellish, ...)
  local difficulties = {...}
  if data.raidTiers[raidTier] then error("This raid tier is already registered!") end
  if not data.expansions[expansion] then error("The expansion has not been registered yet!") end
  if not description or type(description) ~= "string" then error("The raid tier needs to provide a description!") end
  if not difficulties or #difficulties == 0  then error("The raid tier "..description.." needs to provide difficulties!") end
  maxDifficulties = #difficulties
  for i = 1,#difficulties do
    if type(difficulties[i]) ~= "string" then error("Difficulty parameter not set correctly") end
  end
  trackIdRanking = trackId
  data.raidTiers[raidTier] = {description = description, difficulties = difficulties}
  data.raidTiers[raidTier].expansion = expansion
  data.raidTiers[raidTier].targetiLvl = targetiLvl
  data.raidTiers[raidTier].bonusIds = bonusIds
  data.raidTiers[raidTier].instances = {}
  data.raidTiers[raidTier].module = (raidTier >= 69000) and "PvP" or (raidTier < 60000) and "WoDDungeon" or "WoD"
  data.raidTiers[raidTier].sockets = maxSockets
  data.raidTiers[raidTier].socketsIds = socketsBonusIds
  data.raidTiers[raidTier].gems = gems
  data.raidTiers[raidTier].enchants = enchants
  data.raidTiers[raidTier].embellish = embellish
  tinsert(data.expansions[expansion].raidTiers, raidTier)
end

local newInstanceMetatable = {
  --[[__index = function(tbl, key)
    local value = rawget(tbl, key)
    if value then return value end
    for k,v in pairs(tbl) do
      if v[key] then return v[key] end
    end
  end,]]
  __newindex = function(tbl, key, value)
    if type(value) ~= "table" then error("Can only add tables with item info inside instance tables") end
    if key == "tieritems" or key == "misc" or key == "customitems" then
      rawset(tbl, key, value)
      return
    end
    key = tonumber(key)
    if not key then error("Key must be a number!") end
    rawset(tbl, key, value)
  end
}

local instanceDefaultIndexMetatable = {
  __index = function(tbl, key)
    return data.instances.__default[key]
  end
}

function BestInSlot:RegisterOverrides(itemlist)
  for itemId, list in pairs(itemlist) do
    itemData[itemId].overrides = list
  end
end

function BestInSlot:GetEmbellish(raidTier)
  return data.raidTiers[raidTier].embellish or {}
end

function BestInSlot:GetGems(raidTier, socketType)
  return data.raidTiers[raidTier].gems[socketType] or {}
end

function BestInSlot:GetEnchants(raidTier, invType)
  return data.raidTiers[raidTier].enchants[invType] or {}
end

function BestInSlot:GetMaxSoketsBySlot(raidTier, slot)
  return data.raidTiers[raidTier].sockets[slot] or 0
end

function BestInSlot:GetModificationTable(raidTier, difficulty, list, slot)
  return self.db.char[raidTier][difficulty][list].modifications and self.db.char[raidTier][difficulty][list].modifications[slot]
end

---Register a raid instance to BestInSlot
--@param #number raidTier The raidTier ID as used at BestInSlot:RegisterRaidTier
--@param #string unlocalizedName An unlocalized name of the raid to add, to identify the instance, must be unique!
--@param #string description A localized description of the raid instance to add
--@param #table args Optional arguments to override default values. See data.instances.__default
function BestInSlot:RegisterRaidInstance(raidTier, unlocalizedName, description, bonusId, targetiLvl, modifiers)
  if not data.raidTiers[raidTier] then error("The raid tier "..raidTier.." has not been registered yet!") end
  local localizedExpansion = data.raidTiers[raidTier].expansion
  if not data.expansions[localizedExpansion] then error("The expansion "..localizedExpansion.." has not been registered yet!") end
  if not data.raidTiers[raidTier] then error("The raid tier "..raidTier.." has not been registered yet") end
  if data.instances[unlocalizedName] then error("This raid instance has already been registered!") end
  data.instances[unlocalizedName] = setmetatable({expansion = localizedExpansion, raidTier = raidTier, description = description, targetiLvl = targetiLvl, bonusId = bonusId, modifiers = modifiers}, instanceDefaultIndexMetatable)
  tinsert(data.expansions[localizedExpansion].instances, unlocalizedName)
  tinsert(data.raidTiers[raidTier].instances, unlocalizedName)
  itemData[unlocalizedName] = setmetatable({}, newInstanceMetatable)
  if self.db.global.customitems[unlocalizedName] then
    for itemlink in pairs(self.db.global.customitems[unlocalizedName]) do
      self:RegisterCustomItem(unlocalizedName, nil, itemlink) --The second parameter will be extracted out of the itemlink if not supplied
    end
  end
end

---Register tier tokens, not supported for MoP or lower
function BestInSlot:RegisterTierTokens(raidTier, tierTokens, itemType, omniToken)
	if not data.raidTiers[raidTier] then error("This raid tier is not registered yet") end
	local raidTierData = data.raidTiers[raidTier]
	local difficulties = raidTierData.difficulties
	for slotId, tierSlots in pairs(tierTokens) do
		for tokenId, tokenClasses in pairs(tierSlots) do
      if type(tokenId) == "number" then
        local tierIds={}
        tierTokenData[tokenId] = {classes = tokenClasses, raidtier = raidTier, slotid = slotId, itemType = itemType}
        if omniToken then
          if not tierTokenData[omniToken] then
            tierTokenData[omniToken] = {}
            tierTokenData[omniToken].raidtier = raidTier
            tierTokenData[omniToken].slotid = 0
            tierTokenData[omniToken].itemType = itemType
          end
          tierTokenData[omniToken].tierSlots = tierTokenData[omniToken].tierSlots or {}
          for class, tierId in pairs(tokenClasses) do
            tierTokenData[omniToken][class] = tierTokenData[omniToken][class] or {}
            tierTokenData[omniToken][class][slotId] = tierId
          end
        end
        for class, tierId in pairs(tokenClasses) do
          table.insert(tierIds,tierId)
        end
        local dungeon = itemData[tokenId].dungeon
        BestInSlot:RegisterBossLoot(dungeon,tierIds,data.bosses[dungeon][itemData[tokenId].bossid],nil,itemData[tokenId].bossid, itemType)
      end
		end
		if omniToken then
			tinsert(tierTokenData[omniToken].tierSlots, slotId)
		end
	end
end


---Adds the named difficulty to the available difficulty
--@param #number raidtier The Raidtier to append the difficulty to
--@param #string difficulty The name of the difficulty
function BestInSlot:AddDifficultyToRaidTier(raidtier, difficulty)
  if not data.raidTiers[raidtier] then error("Raidtier '"..tostring(raidtier).."' does not exist!") end
  tinsert(data.raidTiers[raidtier].difficulties, difficulty)
end

--- Register Miscelaneous items
-- @param #number raidTier The Raid tier to add the misc items to
-- @param #table miscItems A table containing the miscelaneous items, should be formatted in the following format: {["Legendary Cloak Quest"] = {idCloak1, idCloak2, ...}, ["Ordos"] = {idOrdos1, idOrdos2, ...}}
-- @param #bool legionLegendary
function BestInSlot:RegisterMiscItems(instance, miscItems, legionLegendary)
  if not data.instances[instance] then error("This instance is not registered yet") end
  local misc = {}
  for miscName,miscLootTable in pairs(miscItems) do
    if type(miscName) ~= "string" or type(miscLootTable) ~= "table" then error("Misc table is not formatted properly, should be {key = {itemId1, itemId2}} Where key is a description of the source}") end
    for i=1,#miscLootTable do
      local itemid = miscLootTable[i]
      local itemtable
      if type(itemid) == "table" then
        itemtable = itemid
        itemid = itemtable.id
        if not itemid then self.console:AddError("ItemTable didn't provide id", itemid) end
      end
      local link, equipSlot
      if legionLegendary == true then --fix for Legion Legendaries itemlevel
        _, link, _, _, _, _, _, _, equipSlot = GetItemInfo(("item:%d::::::::::::1:3630"):format(itemid))
      else
        _, link, _, _, _, _, _, _, equipSlot = GetItemInfo(("item:%d::::::::::::1:3524"):format(itemid))
      end
      if not link then self.unsafeIDs[itemid] = true end
      misc[itemid] = {
        dungeon = instance,
        difficulty = miscLootTable.difficulty,
        link = link,
        equipSlot = equipSlot,
        isBiS = {},
        misc = miscName,
      }
    end
  end
  itemData[instance].misc = misc
end

local  bossNewIndexMetatable = {
  __newindex = function(tbl, key, value)
    if type(value) ~= "table" then BestInSlot.console:AddError("Item info must be a table!", key, value) end
    key = tonumber(key)
    if not key then BestInSlot.console:AddError("Item info must be a table!", key, value) end
    rawset(tbl, key, value)
  end
}

--- Register boss loot of an instance. Must call this function in the order you want to put the bosses in
-- @param #string unlocalizedInstanceName The unlocalized name of the instance to add the loot to.
-- @param #table lootTable The table containing the loot for the boss, must be formatted as follows: {["Normal"] = {itemId1, itemId2}, ["Heroic"] = {itemId1, itemId2}}
-- @param #string bossName Localized name of the boss, you can use LibBabbleBoss-3.0 for this.
-- @param #number tierToken If supplied, registers this item as a boss that drops the supplied tiertoken. 1 = HeadSlot, 3 = ShoulderSlot, 5 = ChestSlot, 7 = LegsSlot, 10 = Handslot, 15 = BackSlot.
function BestInSlot:RegisterBossLoot(unlocalizedInstanceName, lootTable, bossName, tierToken, bossId, itemType)
  local instance = data.instances[unlocalizedInstanceName]
  if not instance then error("The instance \""..unlocalizedInstanceName.."\" has not yet been registered!") end
  lootTable.info = {name = bossName}
  local bossLootTable = bossId and itemData[unlocalizedInstanceName][bossId] or setmetatable({}, bossNewIndexMetatable)
  local addToBoss = bossId ~= nil
  local bossId = bossId or #itemData[unlocalizedInstanceName] + 1
  for i=1,#lootTable do
    local itemid = lootTable[i]
    local itemtable
    if type(itemid) == "table" then
      itemtable = itemid
      itemid = itemtable.id
      if not itemid then self.console:AddError("ItemTable didn't provide id", itemid) end
    end
    local item = itemData[itemid]
    if item and not item.customitem then --The item already existed
      if not item.multiplesources then
        item.multiplesources = {}
        if item.bossid and item.dungeon then
          item.multiplesources[item.dungeon] = {}
          item.multiplesources[item.dungeon][item.bossid] = true
        else
          self:Print(item)
          self:Print(self.unsafeIDs)
        end
      end
      item.multiplesources[unlocalizedInstanceName] = item.multiplesources[unlocalizedInstanceName] or {}
      item.multiplesources[unlocalizedInstanceName][bossId] = true
      bossLootTable[itemid] = item
    else
      if item and item.customitem then
        local itemInfo = Item:CreateFromItemID(itemid)
        itemInfo:ContinueOnItemLoad(function()
          self:Print("You have added a custom item that is being registered as a module. This is being removed from your custom items.", true)
          self:Print("Removing: "..itemInfo:GetItemLink(), true)
        end)
        self:UnregisterCustomItem(itemid)
      end
      bossLootTable[itemid] = {
        dungeon = unlocalizedInstanceName,
        bossid = bossId,
        difficulty = itemtable and itemtable.difficulty or -1,
        exceptions = itemtable and itemtable.exceptions,
        isTierSet = itemType == L["Token"],
        isCatalyst = itemType == L["Catalyst"]
      }
      local itemInfo = Item:CreateFromItemID(i)
      itemInfo:ContinueOnItemLoad(function() bossLootTable[itemid].link = itemInfo:GetItemLink() bossLootTable[itemid].equipSlot = itemInfo:GetInventoryTypeName() end)
    end
  end
  data.bosses[unlocalizedInstanceName] = data.bosses[unlocalizedInstanceName] or {}
  if not addToBoss then
    tinsert(itemData[unlocalizedInstanceName], bossLootTable) --add loot to itemData
    tinsert(data.bosses[unlocalizedInstanceName], bossName) --add Boss info to data
  end
  if tierToken then
    data.tiertokens[unlocalizedInstanceName] = data.tiertokens[unlocalizedInstanceName] or {}
    data.tiertokens[unlocalizedInstanceName][tierToken] = {dungeon = unlocalizedInstanceName, bossid = #data.bosses[unlocalizedInstanceName]}
  end
  BestInSlot.hasModules = true
end

function BestInSlot:RegisterCraft(raidTier, craftList, bonusId, targetiLvl, modifiers)
  if not data.instances.Tradeskills then
    self:RegisterRaidInstance(raidTier, "Tradeskills", TRADESKILLS, bonusId, targetiLvl, modifiers)
    data.bosses.Tradeskills = {}
    for _, id in pairs(Enum.Profession) do
      itemData.Tradeskills[id] = setmetatable({}, bossNewIndexMetatable)
    end
  end
  for i = 1, #craftList do
    local professionInfo = C_TradeSkillUI.GetProfessionInfoByRecipeID(craftList[i])
    local outputItemID = C_TradeSkillUI.GetRecipeSchematic(craftList[i], false).outputItemID
    if not (professionInfo and outputItemID) then
      self:Print("error with RecipeID: "..craftList[i])
    else
      if not data.bosses.Tradeskills[professionInfo.profession] then
        data.bosses.Tradeskills[professionInfo.profession] = professionInfo.parentProfessionName
      end
      local tradeskillTable = itemData.Tradeskills[professionInfo.profession]
      tradeskillTable[outputItemID] = {
        dungeon = "Tradeskills",
        bossid = professionInfo.profession,
        difficulty = -1,
        recipe = craftList[i]
      }
      local itemInfo = Item:CreateFromItemID(outputItemID)
      itemInfo:ContinueOnItemLoad(function() tradeskillTable[outputItemID].link = itemInfo:GetItemLink() tradeskillTable[outputItemID].equipSlot = itemInfo:GetInventoryTypeName() end)
    end
  end
end

function BestInSlot:RegisterGems()
  
end

function BestInSlot:RegisterEnchants()
  
end

function BestInSlot:RegisterEmbelish()
  
end

--Simple helper to check if an array has any key
local function hasItems(array)
  for _ in pairs(array) do
    return true
  end
  return false
end

--- Called on initializing the add-on
function BestInSlot:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("BestInSlotDB", defaults)
  SLASH_BESTINSLOT1, SLASH_BESTINSLOT2 = '/bestinslot', '/bis'
  self:RegisterComm(self.MSGPREFIX)
  self.options.instantAnimation = self.db.global.options.instantAnimation
  self.options.showBiSTooltip = self.db.char.options.showBiSTooltip
  self.options.windowFixed = self.db.char.options.windowFixed
  self.options.sendAutomaticUpdates = self.db.char.options.sendAutomaticUpdates
  self.options.receiveAutomaticUpdates = self.db.char.options.receiveAutomaticUpdates

  AceEvent:RegisterEvent("GET_ITEM_INFO_RECEIVED", function(event, itemid) BestInSlot:SendEvent("GET_ITEM_INFO_RECEIVED", itemid) end)
  self:RegisterEvent("GET_ITEM_INFO_RECEIVED", "OnItemInfoGenerated")

  self:Print((L["has been initialized, use %s to show the GUI"]):format((L["%s or %s"]):format(self.colorHighlight.."/bis"..self.colorNormal, self.colorHighlight.."/bestinslot"..self.colorNormal)))
end

--- Called on enabling the add-on
function BestInSlot:OnEnable()
  AceEvent:RegisterEvent("PLAYER_GUILD_UPDATE", function()
    BestInSlot:SendEvent("PLAYER_GUILD_UPDATE")
  end)
  self:MiniMapButtonVisible(self.db.char.options.minimapButton)
  self:SetBestInSlotInfo()
  local coreModules = {
    "ZoneDetect",
    "History",
    "History",
    "Timer"
  }
  for i=1, #coreModules do
    self:EnableModule(coreModules[i])
  end

  --Activer les modules BiS Core
  local loadOrder = {}
  local waitList = {}
  local ZoneDetect = self:GetModule("ZoneDetect")
  for k,v in pairs(BestInSlot.modules) do
    if not v.enabledState then
---@diagnostic disable-next-line: undefined-field
      if v.dependancy then
---@diagnostic disable-next-line: undefined-field
        waitList[v.dependancy] = waitList[v.dependancy] or {}
---@diagnostic disable-next-line: undefined-field
        tinsert(waitList[v.dependancy], v)
      else
        tinsert(loadOrder, v)
      end
    end
  end
  while #loadOrder ~= 0 do
    local module = tremove(loadOrder)
    local moduleName = module.moduleName
    module:Enable()
    module:InitializeZoneDetect(ZoneDetect)
    if waitList[moduleName] then
      local addToList = waitList[moduleName]
      for i=1,#addToList do
        tinsert(loadOrder, addToList[i])
      end
    end
  end
end

function BestInSlot:OnDisable()
  self:Unhook(GameTooltip, "OnTooltipSetItem")
  self:Unhook(ItemRefTooltip, "OnTooltipSetItem")
end

function BestInSlot:GetDifficultyIdForDungeon(bisId, dungeon, toBiS)
  local returnId, bonusIds
  if not toBiS then
    if dungeon and data.instances[dungeon] then
      returnId, bonusIds = data.instances[dungeon].difficultyconversion[bisId], data.instances[dungeon].bonusids[bisId]
    else
      returnId, bonusIds = data.instances.__default.difficultyconversion[bisId], data.instances.__default.bonusids[bisId]
    end
  else
    local tbl = data.instances[dungeon] or data.instances.__default
    for BiSId, WoWId in pairs(tbl.difficultyconversion) do
      if bisId == WoWId then
        returnId, bonusIds = BiSId, tbl.bonusids[BiSId]
      end
    end
  end
  if not returnId then return end
  if type(bonusIds) == "table" then
    return returnId, unpack(bonusIds)
  else
    return returnId, bonusIds
  end
end


function BestInSlot:GetItemInfoFromLink(itemlink)
  --local _,itemid, enchantId, gemId1, gemId2, gemId3, gemId4, suffixId, uniqueId, linkLevel, specId, upgradeId, instanceDifficultyID, numBonusId, bonusId1, bonusId2, bonusId3, bonusId4, bonusId5, upgradeVal = (":"):split(itemlink)
  itemlink = select(2,GetItemInfoFromHyperlink(itemlink))
  if not itemlink then --battlepet/keystone
    return
  end
  local itemSplit = {(":"):split(itemlink)}
  local itemid = tonumber(itemSplit[1])
  local difficultyId = 0
  if itemData[itemid] and itemData[itemid].overrides and itemData[itemid].overrides.noScalling then
    difficultyId = maxDifficulties
  else
    if itemSplit[13] and not (itemSplit[13] == "") then
      local itemEquipLoc = select(4, C_Item.GetItemInfoInstant(itemlink))
      if itemEquipLoc == "INVTYPE_NON_EQUIP_IGNORE" or (itemSplit[13] == "1" and itemSplit[14] == "3524") then
        difficultyId = contextToDifficulty[tonumber(itemSplit[12])] or 0
      else
        for i = 1, itemSplit[13] do
          local foundDifficulty = trackIdRanking[tonumber(itemSplit[13 + i])]
          if foundDifficulty and foundDifficulty > difficultyId then
            difficultyId = foundDifficulty
          end
        end
      end
    end
  end
  return tonumber(itemid), difficultyId
end


function BestInSlot:OnItemInfoGenerated(event, itemid)
  local item = itemData[itemid]
  if item then
    local _, link, _, _, _, _, _, _, equipSlot = GetItemInfo(item.customitem or itemid)
    if not link then return end
    item.link = link
    item.equipSlot = equipSlot
    if item.tieritem then
      item.bossid = equipSlot and data.tiertokens[item.dungeon][self:GetItemSlotID(equipSlot)].bossid
    end
    if self.unsafeIDs[itemid] then self.unsafeIDs[itemid] = nil end
  end
end

--- Vérifie si le joueur a un objet dans son sac ou équipé
-- @param #number itemid L'ID de l'objet à vérifier si le joueur a
-- @param #number [difficulty] L'ID de difficulté que l'objet doit avoir.
-- @param #bool [checkHigherDifficulties] Lorsque true, il vérifie les difficultés les plus élevées et renvoie le numéro de difficulté lorsqu'il est trouvé, ou nil lorsqu'il n'est pas trouvé.
-- @return #boolean true si le joueur l'a, sinon false
function BestInSlot:HasItem(itemid, difficulty)
  if not (itemid and difficulty) then return end
  local result = 0
  local slots = BestInSlot.invSlotsId[C_Item.GetItemInventoryTypeByID(itemid)]
  for _, slotID in pairs(slots) do
    local link = GetInventoryItemLink("player", slotID)
    if link then
      local id, itemDifficulty = self:GetItemInfoFromLink(link)
      if id == itemid and itemDifficulty and itemDifficulty >= difficulty then
        result = result + 1
        if result == #slots then
          break
        end
      end
    end
  end
  for i = 0, NUM_BAG_SLOTS do
    if result == #slots then
      break
    end
    for j = 1, C_Container.GetContainerNumSlots(i) do
      local itemInfo = C_Container.GetContainerItemInfo(i, j)
      if itemInfo and itemInfo.hyperlink then
        local id, itemDifficulty = self:GetItemInfoFromLink(itemInfo.hyperlink)
        if id == itemid and itemDifficulty and itemDifficulty >= difficulty then
          result = result + 1
          if result == #slots then
            break
          end
        end
      end
    end
  end
  return result > 0 and result
end

------------------------------------------------------------------------------------------------------------------------------------------------
-- Commandes Slash
------------------------------------------------------------------------------------------------------------------------------------------------

--- Une fonction BestInSlot pour enregistrer une commande Slash personnalisée. Elle sera automatiquement affichée dans /help et devrait pouvoir être appelée via /bis [cmd]
-- @param #string cmd La commande à enregistrer
-- @param #string descr La description à afficher lorsque '/bis help' est tapé
-- @param #function func La fonction à appeler lorsque cette commande Slash est invoquée
-- @param #number prefOrder L'emplacement préféré de ce message dans la boîte de dialogue '/bis help'. Peut être nil
function BestInSlot:RegisterSlashCmd(cmd, descr, func, prefOrder)
  if type(cmd) ~= "string" then error("Command should be a string") end
  if type(func) ~= "function" then error("Second argument of RegisterSlashCmd should be the function that should be called when the command is given") end
  if type(descr) ~= "string"  then error("Slashcommand should provide a description as third parameter") end
  if prefOrder and type(prefOrder) ~= "number" then error("If provided, prefOrder should be a number") end
  cmd = (cmd):lower()
  if slashCommands[cmd] then error("Slash command "..cmd.." is already registered!") end
  slashCommands[cmd] = {func = func, descr = descr, prefOrder = prefOrder}
end

function SlashCmdList.BESTINSLOT(msg, editbox)
  local args = {}
  local first = true
  local command
  for w in (msg):gmatch("%w+") do
    if first then
      command = w
      first = false
    else
      tinsert(args, w)
    end
  end
  if not command then
    slashCommands.show.func()
  else
    command = (command):lower()
    if not slashCommands[command] then
      BestInSlot:Print((L["Command not recognized, try '%s' for help"]):format("/bis help"), true)
    else
      slashCommands[command].func(unpack(args))
    end
  end
end

BestInSlot:RegisterSlashCmd("help", (L["%s - this dialog"]):format("/bis help"), function()
  local orderedList = {}
  for k in pairs(slashCommands) do
    tinsert(orderedList, k)
  end
  tsort(orderedList)
  for i=1,#orderedList do
    if slashCommands[orderedList[i]].prefOrder then
      tinsert(orderedList, slashCommands[orderedList[i]].prefOrder, orderedList[i])
      tremove(orderedList, i + 1)
    end
  end
  DEFAULT_CHAT_FRAME:AddMessage(BestInSlot.colorHighlight..("-"):rep(5)..BestInSlot.colorNormal.."BestInSlotRedux "..L["commands"]..BestInSlot.colorHighlight..("-"):rep(5).."|r")
  BestInSlot:Print(("%s: %s (%s)"):format(GAME_VERSION_LABEL, GetAddOnMetadata("BestInSlotRedux", "Version"), BestInSlot.version))
  for i=1,#orderedList do
    BestInSlot:Print(slashCommands[orderedList[i]].descr, true)
  end
  DEFAULT_CHAT_FRAME:AddMessage(BestInSlot.colorHighlight..("-"):rep(36).."|r")
end)

BestInSlot:RegisterSlashCmd("debug", (L["%s - enable/disable debug messages"]):format("/bis debug"), function()
  if BestInSlot.options.DEBUG then
    BestInSlot:Print(L["Disabling debug messages"])
    BestInSlot.options.DEBUG = false
  else
    BestInSlot.options.DEBUG = true
    BestInSlot:Print(L["Enabling debug messages"])
  end
  BestInSlot:SendEvent("DebugOptionsChanged", BestInSlot.options.DEBUG)
end)

local itemslotidCache = {}

function BestInSlot:GetItemSlotID(equipSlot, spec)
  if not equipSlot then return end
  if spec == 72 and equipSlot == "INVTYPE_2HWEAPON" then return 16,17 end --fury warrior 2-handers
  if itemslotidCache[equipSlot] then
    if #itemslotidCache[equipSlot] == 1 then return itemslotidCache[equipSlot][1] else return itemslotidCache[equipSlot][1], itemslotidCache[equipSlot][2] end
  end
  local result = {}
  for i=1,#self.invSlots do
    if type(self.invSlots[i]) == "string" then
      if self.invSlots[i] == equipSlot then
        tinsert(result, i)
      end
    elseif type(self.invSlots[i]) == "table" then
      for j=1,#self.invSlots[i] do
        if self.invSlots[i][j] == equipSlot then
          tinsert(result, i)
        end
      end
    end
  end
  itemslotidCache[equipSlot] = result
  return unpack(result)
end

------------------------------------------------------------------------------------------------------------------------------------------------
-- Getters pour les données
------------------------------------------------------------------------------------------------------------------------------------------------

---
-- Cette fonction renvoie un tableau d'éléments par identifiant pour définir dans quel ordre les éléments fournis dans itemArray doivent être affichés
-- @param #array itemArray Le tableau d'éléments à trier
-- @param #string mode Le mode de tri, ne prend actuellement en charge que "SORT_MODE_ILVL" et est défini par défaut sur celui-ci
---
function BestInSlot:GetLootOrder(itemArray, mode)
  local sortArray = {}
  local mode = mode or "SORT_MODE_ILVL"
  if mode == "SORT_MODE_ILVL" then
    for k,v in pairs(itemArray) do
      if #sortArray == 0 then
        tinsert(sortArray, k)
      else
        local position
        for i=1,#sortArray do
          if sortArray[i] > k then
            position = i
            break
          end
        end
        position = position or #sortArray + 1
        tinsert(sortArray, position, k)
      end
    end
  end
  return sortArray
end

--- Récupérez la table de butin personnalisée pour le joueur.
-- @param #number raidTier Le raidtier pour lequel récupérer la table de butin
-- @param #number slotID L'ID de slot pour lequel récupérer la table de butin
-- @param #number difficulty L'ID de difficulté pour lequel récupérer la table de butin
-- @param #number specializationId L'ID de spécialisation pour lequel récupérer le butin
-- @param #boolean lowerRaidTiers Affiche également le butin des niveaux de raid inférieurs
-- @param #number La spécialisation à utiliser pour comparer l'unicité
-- @return #table La table de butin du joueur
function BestInSlot:GetPersonalizedLootTableBySlot(raidTier, slotId, difficulty, specializationId, lowerRaidTiers, uniquenessSpec)
  local specRole, class = select(6, GetSpecializationInfoByID(specializationId))
  local incomplete
  uniquenessSpec = uniquenessSpec or specializationId
  if specializationId == 72 and slotId == 17 then --Les guerriers furieux peuvent manier tout ce qu'ils ont dans leur main secondaire
    return self:GetPersonalizedLootTableBySlot(raidTier, 16, difficulty, specializationId, lowerRaidTiers) --return main hand loot list instead
  end

  local items = self:GetLootTableBySlot(raidTier, slotId, difficulty, lowerRaidTiers)
  if not items then
    return
  end
  for id, item in pairs(items) do
    local canUse
    local statFilter = GetItemSpecInfo(item.itemid)
    if item.exceptions then
      local checks = {specRole, class}
      for i, check in pairs({"role", "class"}) do
        local checkitem = item.exceptions[check]
        if checkitem and type(checkitem) == "table" and tContains(checkitem, checks[i]) or checkitem == checks[i] then
          exceptions[item.itemid] = true
          break
        end
      end
    end
    if statFilter then
      if #statFilter == 0 then --Il n'y a pas d'informations sur les spécifications d'élément disponibles pour cet élément, normalement la table doit être nulle
        if raidTier > 70000 and (slotId == 2 or slotId == 11 or slotId == 12) and item.misc ~= LOOT_JOURNAL_LEGENDARIES then
          canUse = true
        else
          canUse = item.customitem ~= nil
        end
      else
        canUse = tContains(statFilter, specializationId)
      end
    elseif C_Item.IsItemDataCachedByID(item.itemid) then
      canUse = true
    else
      incomplete = Item:CreateFromItemID(item.itemid)
      canUse = false
    end
    if canUse and tContains(data.raidTiers[raidTier].instances, item.dungeon) then --check item uniqueness
      local family, count = GetItemUniqueness(item.itemid)
      if count == 1 and self:IsItemBestInSlot(item.itemid, difficulty, uniquenessSpec) then
        canUse = false
      end
    end
    if canUse and slotId == 17 and C_Item.GetItemInventoryTypeByID(id) == Enum.InventoryType["IndexWeaponType"] then
      canUse = false
      for i=1,#self.dualWield do
        if self.dualWield[i] == specializationId then
          canUse = true
          break
        end
      end
    end
    if not canUse then
      items[id] = nil
    end
  end
  local addSpec
  if specializationId == 73 then --Prot warriors
    addSpec = 71 --Arms
  elseif specializationId == 104 then --Guardian Druid
    addSpec = 103 --Feral Druid
  elseif specializationId == 66 and slotId ~= 16 and slotId ~= 17 then --Prot Pally
    addSpec = 70 --Ret Pally
  elseif specializationId == 250 then --Sang DK
    addSpec = 252 --DK impie
  elseif specializationId == 268 then --Moine maître brasseur
    addSpec = 269 --Moine Marche-Vent
  elseif specializationId == 105 and slotId ~= 16 and slotId ~= 17 then --Resto Druide
    addSpec = 102 --Druide Équilibre
  elseif specializationId == 264 and slotId ~= 16 and slotId ~= 17 then --Resto Shaman
    addSpec = 262 --Chaman élémentaire
  elseif specializationId == 257 or specializationId == 256 then --Tous deux prêtres guérisseurs
    addSpec = 258 --Prêtre de l'ombre
  end
  --ToDo Implémenter un correctif pour le paladin
  if addSpec then
    local dpsItems = self:GetPersonalizedLootTableBySlot(raidTier, slotId, difficulty, addSpec, lowerRaidTiers, specializationId)
    ---@diagnostic disable-next-line: param-type-mismatch
    for itemid, item in pairs(dpsItems) do
      if not items[itemid] then
        items[itemid] = item
      end
    end
  end
  return items, incomplete
end

local function addLootToTableByFilter(tbl, itemlist, slotId, difficulty)
  for id in pairs(itemlist) do
    local slots = BestInSlot.invSlotsId[C_Item.GetItemInventoryTypeByID(id)]
    if slots and tContains(slots, slotId) then
      local item = BestInSlot:GetItem(id, difficulty)
  ---@diagnostic disable-next-line: param-type-mismatch
      --if (not slotId) or (type(BestInSlot.invSlots[slotId]) == "string" and BestInSlot.invSlots[slotId] == item.equipSlot) or (type(BestInSlot.invSlots[slotId]) == "table" and tContains(BestInSlot.invSlots[slotId],item.equipSlot)) then
        if (not difficulty) or (not item.difficulty or (item.difficulty == -1 or item.difficulty == difficulty or (type(item.difficulty) == "table") and tContains(item.difficulty, difficulty)) ) then
          tbl[id] = item
        end
      --end
    end
  end
end

-- Obtient le butin pour le donjon fourni
-- @param #string dungeon Nom non localisé du donjon
-- @param #number slotId SlotId facultatif à ajouter
function BestInSlot:GetLootTableByDungeon(dungeon, slotId, difficulty)
  local items = {}
  local dungeonData = itemData[dungeon]
  for bossId=1,#dungeonData do
    addLootToTableByFilter(items, dungeonData[bossId], slotId, difficulty)
  end
  if dungeonData.tieritems then
    addLootToTableByFilter(items, dungeonData.tieritems, slotId, difficulty)
  end
  if dungeonData.misc then
    addLootToTableByFilter(items, dungeonData.misc, slotId, difficulty)
  end
  if dungeonData.customitems then
    addLootToTableByFilter(items, dungeonData.customitems, slotId, difficulty)
  end
  return items
end

local function helperFullLootTable(tbl, itemlist, difficulty)
  for id in pairs(itemlist) do
    local item = BestInSlot:GetItem(id, difficulty)
    if (not difficulty) or (not item.difficulty or (item.difficulty == -1 or item.difficulty == difficulty or (type(item.difficulty) == "table") and tContains(item.difficulty, difficulty)) ) then
      tbl[id] = item
    end
  end
end

function BestInSlot:GetFullLootTableForRaidTier(raidTier, difficulty)
  local items = {}
  for _, dungeon in pairs(self:GetInstances(self.RAIDTIER, raidTier)) do
    local dungeonData = itemData[dungeon]
    for bossId=1,#dungeonData do
      helperFullLootTable(items, dungeonData[bossId], difficulty)
    end
    if dungeonData.tieritems then
      helperFullLootTable(items, dungeonData.tieritems, difficulty)
    end
    if dungeonData.misc then
      helperFullLootTable(items, dungeonData.misc, difficulty)
    end
    if dungeonData.customitems then
      helperFullLootTable(items, dungeonData.customitems, difficulty)
    end
  end
  return items
end

-- Obtenir la table de butin pour le raidTier, l'emplacement et la difficulté fournis
-- @param #number raidTier Le raidtier pour lequel demander la table de butin
-- @param #number slotId L'ID d'emplacement à demander
-- @param #number difficulty L'ID de difficulté du raidTier pour lequel demander les données
-- @param #boolean lowerRaidTiers Obtenir également des données pour les niveaux de raid inférieurs
-- @return #table La table de butin
function BestInSlot:GetLootTableBySlot(raidTier, slotId, difficulty, lowerRaidTiers)
  local items = {}
  local dungeons = data.raidTiers[raidTier].instances
  for i=1,#dungeons do
    for id, item in pairs(self:GetLootTableByDungeon(dungeons[i], slotId, difficulty)) do
      items[id] = item
    end
  end
  if lowerRaidTiers then
    local module = data.raidTiers[raidTier].module
    local raidTiers = self:GetRaidTiers()
    for i=1,#raidTiers do
      ---@diagnostic disable-next-line: need-check-nil
      if raidTiers[i] == raidTier then break end --stop the loop at the raidTier that we already have data from
      ---@diagnostic disable-next-line: need-check-nil
      if module == data.raidTiers[raidTiers[i]].module then
        ---@diagnostic disable-next-line: need-check-nil
        for id, item in pairs(self:GetLootTableBySlot(raidTiers[i], slotId, difficulty)) do
          items[id] = item
        end
      end
    end
  end
  return items
end

function BestInSlot:ItemExists(itemid)
  if itemData[itemid] ~= nil then
    return true, "item", itemData[itemid].dungeon
  elseif tierTokenData[itemid] ~= nil then
    return true, "tiertoken", tierTokenData[itemid].dungeon
  else
    return false
  end
end

function BestInSlot:AddilvlModifiers(bonusIds, baseilvl, targetilvl)
  if baseilvl >= targetilvl then
    return
  end
  local dif = targetilvl - baseilvl
  for i = 0, #tostring(dif) - 1 do
    tinsert(bonusIds, ilvlOffsetIDs[floor(dif / 10^i) % 10 * 10^i])
  end
end


--Obtient une chaîne d'élément à utiliser dans WoWAPI
--@param #number itemid L'identifiant de l'élément
function BestInSlot:GetItemString(itemid, difficulty, modificationTable)
  if not itemid then error("You should provide an itemid!") end
  difficulty = difficulty or 1
  local tier = self:GetSelected(self.RAIDTIER)
  local enchantId = ""
  if modificationTable and modificationTable.enchant then
    enchantId = self:GetEnchants(tier, C_Item.GetItemInventoryTypeByID(itemid))[modificationTable.enchant]
  end
  local gem1 = modificationTable and modificationTable.gem1 or ""
  local gem2 = modificationTable and modificationTable.gem2 or ""
  local gem3 = modificationTable and modificationTable.gem3 or ""
  local bonusIds = data.instances[itemData[itemid].dungeon].bonusId or data.raidTiers[tier].bonusIds
  bonusIds = {unpack(bonusIds[difficulty])}
  local baseiLvl = select(4, C_Item.GetItemInfo(itemid))
  local targetiLvl = data.instances[itemData[itemid].dungeon].targetiLvl or data.raidTiers[tier].targetiLvl
  local maxSockets = self:GetMaxSoketsBySlot(tier, C_Item.GetItemInventoryTypeByID(itemid))
  if #targetiLvl > 0 then
    BestInSlot:AddilvlModifiers(bonusIds, baseiLvl, targetiLvl[difficulty])
  end
  if modificationTable and modificationTable.embellish then
    tinsert(bonusIds, self:GetEmbellish(tier)[modificationTable.embellish])
  end
  if not modificationTable and itemData[itemid] and itemData[itemid].overrides and itemData[itemid].overrides.defaultSockets then
    tinsert(bonusIds, data.raidTiers[tier].socketsIds[itemData[itemid].overrides.defaultSockets])
  elseif modificationTable and maxSockets > 0 and not (itemData[itemid] and itemData[itemid].overrides and itemData[itemid].overrides.noAdditionalSockets) then
    tinsert(bonusIds, data.raidTiers[tier].socketsIds[maxSockets])
  end
  local numBonusIDs = #bonusIds
  local bonusString = string.rep("%d:", numBonusIDs + 1):format(numBonusIDs, unpack(bonusIds))
  local modifiersString = ""
  local modifiers
  if data.instances[itemData[itemid].dungeon].modifiers or modificationTable and modificationTable.stats then
    modifiers = data.instances[itemData[itemid].dungeon].modifiers and {unpack(data.instances[itemData[itemid].dungeon].modifiers[difficulty])} or {}
  end
  if modifiers then
    if modificationTable and modificationTable.stats then
      local modifiertype = {29, 30}
      for i = 1, #modificationTable.stats do
        tinsert(modifiers, modifiertype[i])
        tinsert(modifiers, modificationTable.stats[i])
      end
    end
    local numModifiers = #modifiers
    modifiersString = string.rep("%d:", numModifiers + 1):format(numModifiers / 2, unpack(modifiers))
  end
  --item:itemId:enchantId:gemId1:gemId2:gemId3:gemId4:suffixId:uniqueId:linkLevel:specializationID:upgradeId:instanceDifficultyId:numBonusIds:bonusId1:bonusId2:upgradeValue
  return ("item:%d:%s:%s:%s:%s::::::::%s%s"):format(itemid, enchantId or "", gem1, gem2, gem3, bonusString, modifiersString)
end

--Obtient la table d'éléments internes pour l'ID d'élément spécifié
--@param #numéro ID d'élément L'ID de l'élément
--@param #chaîne de difficulté La difficulté de l'élément
--@return #table La table d'éléments internes
function BestInSlot:GetItem(itemid, difficulty, modificationTable)
  if type(itemid) == "string" then
    itemid = tonumber(itemid)
  end
  if itemid then
    if itemData[itemid] then
      local itemInfo = Item:CreateFromItemID(itemid)
      local newItemTable = setmetatable({}, {__index=itemData[itemid]})
      if difficulty and newItemTable.difficulty == -1 then --This is an item that has multiple states, therefore we need to set it's state
        itemInfo:ContinueOnItemLoad(function()
          local itemStr = self:GetItemString(itemid, difficulty, modificationTable)
          local link = select(2,GetItemInfo(itemStr))
          newItemTable.itemstr = itemStr
          newItemTable.link = link
        end)
        newItemTable.difficulty = difficulty
      else
        newItemTable.itemstr = "item:"..itemid
      end
      newItemTable.itemid = itemid
      newItemTable.recipe = itemData[itemid].recipe
      newItemTable.overrides = itemData[itemid].overrides
      newItemTable.itemType = "" or tierTokenData[itemid] and tierTokenData[itemid].itemType
      return newItemTable, itemInfo
    end
  end
end

function BestInSlot:GetItemSources(itemid)
  if self:ItemExists(itemid) then
    local item = itemData[itemid]
    local sources = {}
    sources[item.dungeon] = {}
    if item.bossid then
      sources[item.dungeon][item.bossid] = true
    end
    if item.multiplesources then
      for k,v in pairs(item.multiplesources) do
        sources[k] = sources[k] or {}
        for bossId in pairs(v) do
          sources[k][bossId] = true
        end
      end
    end
    return sources, item.isCatalyst
  end
end

function BestInSlot:AddCustomItem(itemid, itemstr, dungeon, updatePrevious)--, warlordsCrafted, stage, suffix)
  if updatePrevious then
    local item = itemData[itemid]
    if item then
      itemData[item.dungeon].customitems[itemid] = nil
      rawset(itemData, itemid, nil)
      self.db.global.customitems[item.dungeon][item.customitem] = nil
    end
  end
  self.db.global.customitems[dungeon] = self.db.global.customitems[dungeon] or {}
  self.db.global.customitems[dungeon][itemstr] = true
  self:RegisterCustomItem(dungeon, itemid, itemstr)
end

local function helperGetCustomItems(dungeon)
  local result = {}
  local count = 0
  if itemData[dungeon] and itemData[dungeon].customitems then
    for itemid, item in pairs(itemData[dungeon].customitems) do
      tinsert(result, itemid)
      count = count + 1
    end
  end
  return result, count
end

function BestInSlot:GetCustomItems(dungeon)
  if not dungeon then
    local result = {}
    local totalcount = 0
    for _, instance in pairs(self:GetInstances()) do
      local count
      result[instance], count = helperGetCustomItems(instance)
      totalcount = totalcount + count
    end
    return result, totalcount
  end
  return helperGetCustomItems(dungeon)
end

function BestInSlot:RegisterCustomItem(dungeon, itemid, itemlink)
  if not itemData[dungeon] then error("Invalid dungeon given to RegisterCustomItem!") end
  if not itemid then
    itemid = self:GetItemInfoFromLink(format("|H%s|h", itemlink))
    if not itemid then error("Couldn't convert itemlink to itemid!") end
  end
  itemData[dungeon].customitems = itemData[dungeon].customitems or {}
  local _, link, _, _, _, _, _, _, equipSlot = GetItemInfo(itemlink)
  if not link then self.unsafeIDs[itemid] = true end
  itemData[dungeon].customitems[itemid] = {
    dungeon = dungeon,
    isBiS = {

    },
    link = link,
    equipSlot = equipSlot,
    customitem = itemlink,
  }
end

function BestInSlot:UnregisterCustomItem(itemid)
  local item = itemData[itemid]
  self:Print(item)
  if not item or not item.customitem then return end
  local dungeon = item.dungeon
  local raidtier = self:GetRaidTiers(self.INSTANCE, dungeon)
  for difficulty, difficTable in pairs(item.isBiS) do
    for specId, bis in pairs(difficTable) do
      if bis then
        self:SetItemBestInSlot(raidtier, difficulty, specId, self:GetItemSlotID(item.equipSlot), nil)
      end
    end
  end
  self.db.global.customitems[dungeon][item.customitem] = nil
  itemData[dungeon].customitems[itemid] = nil
  rawset(itemData, itemid, nil) --rawSet remplace la prévention par défaut de la suppression des informations sur les éléments.
end
--- Obtient une description localisée pour l'identifiant non localisé fourni
-- @param #number datatype Le type de données facultatif à interroger peut être BestInSlot.EXPANSION, BestInSlot_TYPE_RAIDTIER, BestInSlot.INSTANCE, BestInSlot.BOSS ou BestInSlot.DIFFICULTY
-- @param #multiple arg1 Le filtre pour le type de données fourni
-- @param #multiple arg2 Le deuxième filtre pour le type de données fourni, nécessaire pour TYPE_BOSS et TYPE_DIFFUCLTY
function BestInSlot:GetDescription(datatype, arg1, arg2)
  if not arg1 or not datatype then error("This function requires atleast 2 arguments, a datatype and an argument for that datatype") end
  if datatype == self.RAIDTIER then
    arg1 = tonumber(arg1)
    if not arg1 or not data.raidTiers[arg1] then return "" end
    return data.raidTiers[arg1].description
  elseif datatype == self.EXPANSION then
    if not data.expansions[arg1] then return "" end
    return data.expansions[arg1].description
  elseif datatype == self.INSTANCE then
    if not data.instances[arg1] then return "" end
    return data.instances[arg1].description
  elseif datatype == self.BOSS then
    arg2 = tonumber(arg2)
    if not arg2 then error("The GetDescription function for datatype TYPE_BOSS requires 2 arguments") end
    if not data.bosses[arg1] then return "" end
    return data.bosses[arg1][arg2]
  elseif datatype == self.DIFFICULTY then
    arg2 = tonumber(arg2)
    if not arg2 then error("The GetDescription function for datatype TYPE_DIFFICULTY requires 2 argumets") end
    if type(arg1) == "number" then --assume it's a raid tier
      return data.raidTiers[arg1].difficulties[arg2]
    elseif type(arg1) == "string" then --assume it's a dungeon
      return data.raidTiers[data.instances[arg1].raidTier].difficulties[arg2]
    else
      error(tostring(arg1).." is not a string or number.")
    end
  end
  error(tostring(datatype).." is an invalid datatype!")
end
--- Obtient les extensions
-- @param #number datatype Type de données facultatif à interroger, si nul, il donnera toutes les extensions car le résultat peut être BestInSlot.EXPANSION, BestInSlot_TYPE_RAIDTIER, BestInSlot.INSTANCE, BestInSlot.BOSS ou BestInSlot.DIFFICULTY
-- @param #multiple arg Le filtre pour le type de données fourni
function BestInSlot:GetExpansions(datatype, arg)
  if not datatype then
    local expansions = {}
    for k,v in pairs(data.expansions) do
      tinsert(expansions, k)
    end
    return expansions
  elseif datatype == self.RAIDTIER then
    if data.raidTiers[arg] then
      return data.raidTiers[arg].expansion
    end
    return ""
  elseif datatype == self.INSTANCE then
    if data.instances[arg] then
      return data.instances[arg].expansion
    end
    return ""
  else
    error("Invalid type given!")
  end
end

--- Obtient les raidtiers
-- @param #number datatype Type de données facultatif à interroger, si nul, il donnera tout car le résultat peut être BestInSlot.EXPANSION, BestInSlot_TYPE_RAIDTIER, BestInSlot.INSTANCE
-- @param #multiple arg Le filtre pour le type de données fourni
function BestInSlot:GetRaidTiers(datatype, arg)
  local raidTiers = {}
  -- Pas de filtre
  if not datatype or datatype == self.RAIDTIER then
    for k,v in pairs(data.raidTiers) do
      if not datatype or (v.module == data.raidTiers[arg].module and k < arg) then
        tinsert(raidTiers, k)
      end
    end
    tsort(raidTiers)
    return raidTiers
  elseif not arg then return
  -- Filtre d'extension
  elseif datatype == self.EXPANSION then
    if not data.expansions[arg] then return raidTiers end
    for i=1,#data.expansions[arg].raidTiers do
      tinsert(raidTiers, data.expansions[arg].raidTiers[i])
    end
    tsort(raidTiers)
    return raidTiers
  -- Filtre d'instance, renverra un seul raidTier, pas sous forme de table !
  elseif datatype == self.INSTANCE then
    if data.instances[arg] then
      return data.instances[arg].raidTier
    else return end
  end
end

--- Obtient les difficultés
-- @param #number datatype Type de données facultatif à interroger, si nul, il donnera tout car le résultat peut être BestInSlot.EXPANSION, BestInSlot_TYPE_RAIDTIER, BestInSlot.INSTANCE
-- @param #multiple Le filtre pour le type de données fourni
function BestInSlot:GetDifficulties(datatype, arg)
  local difficulties = {}
  if datatype == self.RAIDTIER then
    if not data.raidTiers[arg] then return difficulties end
    for i=1,#data.raidTiers[arg].difficulties do
      tinsert(difficulties, data.raidTiers[arg].difficulties[i])
    end
    return difficulties
  elseif datatype == self.INSTANCE then
    if not arg or not data.instances[arg] then return difficulties end
    local raidTier = data.instances[arg].raidTier
    for i=1,#data.raidTiers[raidTier].difficulties do
      tinsert(difficulties, data.raidTiers[raidTier].difficulties[i])
    end
    return difficulties
  end
  error("Invalid datatype given!")
end

--- Obtient les instances
-- @param #number datatype Type de données facultatif à interroger, si nul, il donnera tout car le résultat peut être BestInSlot.EXPANSION, BestInSlot_TYPE_RAIDTIER, BestInSlot.INSTANCE
-- @param #multiple Le filtre pour le type de données fourni
function BestInSlot:GetInstances(datatype, arg)
  local instances = {}
  if not datatype then
    for k,v in pairs(data.instances) do
      if k ~= "__default" then
        tinsert(instances, k)
      end
    end
    return instances
  elseif datatype == BestInSlot.RAIDTIER then
    if not data.raidTiers[arg] then return instances end
    for i=1, #data.raidTiers[arg].instances do
      tinsert(instances, data.raidTiers[arg].instances[i])
    end
    return instances
  end
  error("Invalid datatype given!")
end

function BestInSlot:GetLatest(datatype, filterdatatype, arg)
  -- Obtenez la dernière extension
  if datatype == self.EXPANSION then
    local selectedExpansion
    local selectedRaidTier = 0
    for k,v in pairs(data.expansions) do
      for i=1,#v.raidTiers do
        if v.raidTiers[i] > selectedRaidTier then
          selectedRaidTier = v.raidTiers[i]
          selectedExpansion = k
        end
      end
    end
    return selectedExpansion

 -- Obtenez le dernier niveau de raid
  elseif datatype == self.RAIDTIER then
    local selected = 0
    for k,v in pairs(data.raidTiers) do
      local isFiltered = false
      if filterdatatype then
        if filterdatatype == self.EXPANSION and v.expansion ~= arg then
          isFiltered = true
        end
      end
      if not isFiltered then
        selected = math.max(selected, k)
      end
    end
    return selected
  -- Obtenir la dernière instance (en fonction du dernier niveau de raid, si aucun argument n'est fourni)
  elseif datatype == self.INSTANCE then
    local raidTier
    if arg then
      if filterdatatype == self.RAIDTIER then
        raidTier = arg
      else
        error("This has not been implemented yet!")
      end
    else
      raidTier = self:GetLatest(self.RAIDTIER)
    end
    return data.raidTiers[raidTier].instances[#data.raidTiers[raidTier].instances]
  elseif datatype == self.DIFFICULTY then
    if arg then
      if filterdatatype == self.INSTANCE then
        local raidTier = self:GetRaidTiers(self.INSTANCE, arg)
        return self:GetLatest(self.DIFFICULTY, self.RAIDTIER, raidTier)
      elseif filterdatatype == self.RAIDTIER then
        local raidTierData = data.raidTiers[arg].difficulties
        return #raidTierData
      end
    end
    error("This has not been implemented yet!")
  end
  error(tostring(datatype).." is an invalid datatype")
end

---Obtient les boss pour l'instance
--@param #string instance L'instance pour laquelle obtenir les boss
--@return #table Table avec les noms des boss, l'ID du boss est le même que l'index de la table
function BestInSlot:GetInstanceBosses(instance)
  local bosses = {}
  local instanceData = data.bosses[instance]
  if not instanceData then return bosses end
  for i=1,#instanceData do
    bosses[i] = instanceData[i]
  end
  return bosses
end

local function helperGetBestInSlotItems(raidTier, difficulty, specialization, slotId)
  if not raidTier or not difficulty or not specialization then
    BestInSlot.console:AddError("Not enough parameters given for function 'helperGetBestInSlotItems'", raidTier, difficulty, specialization, slotId)
    if slotId then return nil else return {} end
  end
  local slots = BestInSlot.slots
  local requiredItems = {}
  local slotInfo = {}
  if not data.raidTiers[raidTier] then return requiredItems end
  BestInSlot.db.char[raidTier][difficulty][specialization].modifications = BestInSlot.db.char[raidTier][difficulty][specialization].modifications or {}
  for i=1,#slots do
    BestInSlot.db.char[raidTier][difficulty][specialization].modifications[i] = BestInSlot.db.char[raidTier][difficulty][specialization].modifications[i] or {}
    ---@diagnostic disable-next-line: param-type-mismatch
    local slotid = GetInventorySlotInfo(slots[i])
    local itemid = BestInSlot.db.char[raidTier][difficulty][specialization][slotid]
    local modificationTable = BestInSlot.db.char[raidTier][difficulty][specialization].modifications and BestInSlot.db.char[raidTier][difficulty][specialization].modifications[slotid]
    if type(itemid) == "number" then
      local item = BestInSlot:GetItem(itemid)
      local itemRecord = {item = itemid, obtained = BestInSlot:HasItem(itemid, difficulty) or false, customitem = item and item.customitem, modifications = modificationTable}
      requiredItems[i] = itemRecord
      slotInfo[i] = slotid
    end
  end
  if raidTier >= 70000 and raidTier < 80000 and BestInSlot.Artifacts then
    local relics = { BestInSlot.Artifacts:GetBestInSlotRelics(raidTier, difficulty, specialization) }
    for i=1,3 do
      if relics[i] then
        requiredItems[29 + i] = {item = relics[i], obtained = BestInSlot:HasItem(relics[i], difficulty) or false}
        slotInfo[29 + i] = 29 + i
      end
    end
  end
  return requiredItems, slotInfo
end

--- Obtenez les éléments BestInSlot actuels pour le niveau de raid et la difficulté
-- @param #number raidTier Le niveau de raid pour obtenir le BestInSlot
-- @param #number difficulty La difficulté à demander
function BestInSlot:GetBestInSlotItems(raidTier, difficulty, specialization, slotId)
  if not raidTier or not difficulty then
    BestInSlot.console:AddError("BestInSlot:GetBestInSlot() missed parameter RaidTier or difficulty", raidTier, difficulty, specialization)
    return {}
  end
  if not specialization then
    local bisItems = {}
    local slotInfo = {}
    for i=1,GetNumSpecializations() do
      local specId = GetSpecializationInfo(i)
      bisItems[specId], slotInfo[specId] = helperGetBestInSlotItems(raidTier,difficulty,specId, slotId)
    end
    bisItems.spec = GetSpecializationInfo(self:GetSpecialization())
    return bisItems, slotInfo
  else
    return helperGetBestInSlotItems(raidTier,difficulty,specialization, slotId)
  end
end

local function helperOrderBiSItems(table, orderTable)
  local newTable = {}
  for i in pairs(orderTable) do
    newTable[orderTable[i]] = table[i]
  end
  return newTable
end
--- Obtenir les éléments BestInSlot actuels pour le raidTier et la difficulté classés par SlotId au lieu d'une simple liste
-- @param #number raidTier Le raidTier à partir duquel obtenir le BestInSlot
-- @param #number difficulty La difficulté à demander
-- @param #number specialization L'ID de spécialisation à demander
function BestInSlot:GetOrderedBestInSlotItems(raidTier, difficulty, specialization)
  local BiSList, OrderedList = self:GetBestInSlotItems(raidTier, difficulty, specialization)
  if specialization then
    return helperOrderBiSItems(BiSList, OrderedList)
  else
    local newTable = {}
    ---@diagnostic disable-next-line: param-type-mismatch
    for k,v in pairs(BiSList) do
      ---@diagnostic disable-next-line: need-check-nil
      if v and OrderedList[k] then
        ---@diagnostic disable-next-line: need-check-nil
        newTable[k] = helperOrderBiSItems(v, OrderedList[k])
      end
    end
    return newTable
  end
end

---
function BestInSlot:SetBestInSlotInfo()
  local raidTiers = self:GetRaidTiers()
  local specs = self:GetCustomLists(self:GetAllSpecializations())
  local result
  for i=1,#raidTiers do
---@diagnostic disable-next-line: need-check-nil
    local raidTier = raidTiers[i]
    local bisList = self.db.char[raidTier]
    local difficulties = self:GetDifficulties(self.RAIDTIER, raidTier)
    for difficId in pairs(bisList) do
      for specId in pairs(specs) do
        local specBiS = bisList[difficId][specId]
        for j in pairs(specBiS) do
          local item = itemData[specBiS[j]]
          if item then
            item.isBiS = item.isBiS or {}
            item.isBiS[difficId] = item.isBiS[difficId] or {}
            item.isBiS[difficId][specId] = true
          end
        end
      end
    end
  end
end


function BestInSlot:IsItemTierToken(itemId)
  return (tierTokenData[itemId] ~= nil), tierTokenData[itemId] and tierTokenData[itemId].itemType
end

local function helperIsTokenBestInSlot(BiSList, difficulty, specId, slotid)
  for i, iteminfo in pairs(BiSList) do
    local item = BestInSlot:GetItem(iteminfo.item, difficulty)
    if item.tieritem and BestInSlot:GetItemSlotID(item.equipSlot) == slotid then
      return BestInSlot:IsItemBestInSlot(item.itemid, difficulty, specId)
    end
  end
end

function BestInSlot:IsTokenBestInSlot(tokenItemId, difficulty, specId)
  -- Vérification si l'item est un token de niveau de raid
  if not self:IsItemTierToken(tokenItemId) then
    return {}
  end

  -- Utilisation de la bonne variable pour récupérer les données sur le token
  local iteminfo = tierTokenData[tokenItemId]  -- Utilisez tokenItemId et non ItemId

  -- Si iteminfo est nil, retournez false pour éviter d'essayer de l'indexer
  if not iteminfo then
    return {}
  end

  -- Récupération de la classe du joueur
  local _, class = UnitClass("player")

  -- Vérification si la classe du joueur est compatible avec le token
  if iteminfo.classes and not iteminfo.classes[class] then 
    return {}
  end

  -- Si specId n'est pas fourni, procédez à la recherche des meilleures pièces pour chaque spécialisation
  if not specId then
    local array = {}

    -- Si le token n'est pas associé à un emplacement spécifique (slotid == 0)
    if iteminfo.slotid == 0 then
      local setList = iteminfo[class]  -- Liste des items pour la classe
      for i = 1, #setList do
        -- Recherche des meilleures pièces pour chaque spécialisation
        ---@diagnostic disable-next-line: param-type-mismatch
        for specId in pairs(self:GetBestInSlotItems(iteminfo.raidtier, difficulty)) do
          if specId ~= "spec" then
            -- Vérification si l'item est BiS pour la spécialisation
            local itemIsBiS = BestInSlot:IsItemBestInSlot(setList[i], difficulty, specId)
            if itemIsBiS then
              if not array[specId] then
                array[specId] = {}
              end
              -- Ajout de l'item BiS à l'array
              tinsert(array[specId], (itemIsBiS and setList[i]))
            end
          end
        end
      end
      return array  -- Retour des résultats
    else
      -- Si l'item est associé à un emplacement spécifique
      ---@diagnostic disable-next-line: param-type-mismatch
      for specId, BiSList in pairs(self:GetBestInSlotItems(iteminfo.raidtier, difficulty)) do
        if specId ~= "spec" then
          -- Vérification si l'item est BiS pour la spécialisation
          array[specId] = (BestInSlot:IsItemBestInSlot(iteminfo.classes[class], difficulty, specId) and iteminfo.classes[class])
        end
      end
      return array  -- Retour des résultats
    end
  else
    -- Si specId est fourni, vérifier si l'item est BiS pour cette spécialisation
    return (BestInSlot:IsItemBestInSlot(iteminfo.classes[class], difficulty, specId) and iteminfo.classes[class])
  end
end


--- Vérifie si l'ID d'élément fourni est BestInSlot
-- @param number itemdId L'ID d'élément à vérifier
-- @param number difficulty La difficulté pour laquelle interroger la liste
-- @return table Tableau avec les spécifications pour lesquelles cet élément est BiS.
-- @return boolean false si ce n'est pas le meilleur dans l'emplacement
function BestInSlot:IsItemBestInSlot(itemId, difficulty, specId)
  local isSpecial, itemType = self:IsItemTierToken(itemId)
  local isBis = {}
  if isSpecial then
    isBis = self:IsTokenBestInSlot(itemId, difficulty, specId)
  end
  local item = BestInSlot:GetItem(itemId)
  if item then
    if not item.isBiS then
      self:SetBestInSlotInfo()
      if not item.isBiS then --assume theere are no BiS items
        itemData[itemId].isBiS = {}
      end
    end
    if difficulty == nil then
      return item.isBiS
    elseif specId == nil then
      if item.isBiS[difficulty] then
        for i, j in pairs(item.isBiS[difficulty]) do
          isBis[i] = itemId
        end
      end
      return isBis
    else
       if item.isBiS[difficulty] then
        return item.isBiS[difficulty][specId]
      else
        return item.isBiS[difficulty]
      end
    end
    return isBis
  end
end

local automaticUpdateQueue = {}
local automaticUpdateTimers

local function doAutomaticUpdate()
  for i=1,#automaticUpdateQueue do
    BestInSlot:SendAddonMessage("automaticUpdate",automaticUpdateQueue[i], "GUILD")
  end
  wipe(automaticUpdateQueue)
end

local function queueAutomaticUpdate(data)
  local wasPresent = false
  for i=1,#automaticUpdateQueue do
    local item = automaticUpdateQueue[i]
    if item.raidTier == data.raidTier and item.difficulty == data.difficulty and item.spec == data.spec and item.spec == data.spec then
      item.bis = data.bis
      if automaticUpdateTimers ~= nil then
        automaticUpdateTimers:Cancel()
      end
      automaticUpdateTimers = C_Timer.NewTimer(10, doAutomaticUpdate)
      wasPresent = true
      break
    end
  end
  if not wasPresent then
    tinsert(automaticUpdateQueue, data)
    if automaticUpdateTimers == nil or automaticUpdateTimers._remainingIterations == 0 then
      automaticUpdateTimers = C_Timer.NewTimer(10, doAutomaticUpdate)
    end
  end
end

--- Définir l'élément comme élément BestInSlot
-- @param #number raidTier Le niveau de raid auquel ajouter l'élément
-- @param #number difficultyId La difficulté à laquelle ajouter l'élément
-- @param #number specialization L'ID de spécialisation
-- @param #number slotId L'emplacement auquel ajouter l'élément
-- @param #number itemId L'ID d'élément à ajouter
function BestInSlot:SetItemBestInSlot(raidTier, difficultyId, specialization, slotId, itemId)
  local currentId = self.db.char[raidTier][difficultyId][specialization][slotId]
  if type(currentId) == "number" then --Vérifie si le numéro a été récupéré, le retour par défaut de la base de données est un tableau vide
  if currentId ~= itemId then
    self.db.char[raidTier][difficultyId][specialization].modifications = self.db.char[raidTier][difficultyId][specialization].modifications or {}
    self.db.char[raidTier][difficultyId][specialization].modifications[slotId] = self.db.char[raidTier][difficultyId][specialization].modifications[slotId] or {}
    self.db.char[raidTier][difficultyId][specialization].modifications[slotId].embellish = nil
    self.db.char[raidTier][difficultyId][specialization].modifications[slotId].stats = nil
    self.db.char[raidTier][difficultyId][specialization].modifications[slotId].gem1 = nil
    self.db.char[raidTier][difficultyId][specialization].modifications[slotId].gem2 = nil
    self.db.char[raidTier][difficultyId][specialization].modifications[slotId].gem3 = nil
  end
    if itemData[currentId] then --vérifie si l'élément est présent dans le cache, si c'est le cas, nous devons définir son BeST sur false
      if itemData[currentId].isBiS and itemData[currentId].isBiS[difficultyId] then
        local lowerRaidTiers = self:GetRaidTiers(self.RAIDTIER, raidTier)
        local isStillBiS = false
        local compareSlots
        if slotId == 11 or slotId == 12 then compareSlots = {11,12}
        elseif slotId == 13 or slotId == 14 then compareSlots = {13,14}
        elseif slotId == 16 or slotId == 17 then compareSlots = {16,17}
        else compareSlots = {slotId} end
        local i = 1
        while i <= #lowerRaidTiers and not isStillBiS do
          for j=1,#compareSlots do
            ---@diagnostic disable-next-line: need-check-nil
            local id = self.db.char[lowerRaidTiers[i]][difficultyId][specialization][compareSlots[j]]
            if id == currentId then
              isStillBiS = true
              break
            end
          end
          i = i + 1
        end
        if not isStillBiS then
          itemData[currentId].isBiS[difficultyId][specialization] = nil
        end
      end
    end
  end
  self.db.char[raidTier][difficultyId][specialization][slotId] = itemId
  if IsInGuild() and self.options.sendAutomaticUpdates and type(specialization) ~= "string" then
    queueAutomaticUpdate({raidTier = raidTier, difficulty = difficultyId, bis = self:GetBestInSlotItems(raidTier, difficultyId, specialization), spec = specialization})
  end
  if itemId and itemData[itemId] then
    itemData[itemId].isBiS = itemData[itemId].isBiS or {}
    itemData[itemId].isBiS[difficultyId] = itemData[itemId].isBiS[difficultyId] or {}
    itemData[itemId].isBiS[difficultyId][specialization] = true
  end
end

local function helperSaveBestInSlotList(tierdb, guildname, guildplayer, bislist, raidtier, difficulty, spec, registerHistory)
  -- Si la spécialisation n'existe pas encore dans la base de données
  if not tierdb[spec] then
    -- Ajoute une nouvelle liste dans l'historique si nécessaire
    if registerHistory and not BestInSlot.History:HasHistory(guildplayer, raidtier, difficulty, spec) then
      BestInSlot.History:Add(
        guildplayer,
        { raidtier = raidtier, difficulty = difficulty, spec = spec },
        BestInSlot.History.NEWLIST
      )
    end
  else
    -- Vérifie et enregistre les modifications par emplacement (slot) si l'historique est activé
    if registerHistory then
      for slot, slotdata in pairs(bislist) do
        local previtem = tierdb[spec][slot]
        -- Si un emplacement est modifié, enregistre l'ancien et le nouvel item
        if not previtem or previtem.item ~= slotdata.item then
          --tierdb[spec][slot] = slotdata
          BestInSlot.History:Add(
            guildplayer,
            {
              raidtier = raidtier,
              difficulty = difficulty,
              slot = slot,
              previtem = previtem and previtem.item,
              newitem = slotdata.item
            }
          )
        end
      end
    end
  end
  -- Met à jour la base de données pour la spécialisation avec la nouvelle liste
  tierdb[spec] = bislist
end


function BestInSlot:SaveGuildBestInSlotList(guildname, guildplayer, bislist, raidtier, difficulty, spec, version)
  -- Vérifie que la base de données est correctement initialisée
  local chardb = self.db.factionrealm[guildname] and self.db.factionrealm[guildname][guildplayer]
  if not chardb then
    self.console:Add("Error: Guild or player data not found", guildname, guildplayer)
    return
  end
  -- Met à jour la spécialisation active
  chardb.activeSpec = bislist.spec or chardb.activeSpec
  -- Vérifie que les données de raidtier et difficulty existent
  chardb[raidtier] = chardb[raidtier] or {}
  local tierdb = chardb[raidtier][difficulty] or {}
  chardb[raidtier][difficulty] = tierdb
  -- Détermine si l'historique doit être enregistré
  local registerHistory = version > 275
  -- Log des informations pour le débogage
  self.console:Add("Save guild bis list", guildname, guildplayer, raidtier, difficulty, spec, version, registerHistory, bislist)
  -- Sauvegarde les listes en fonction des spécialisations
  if not spec then
    -- Si aucune spécialisation spécifique n'est fournie, sauvegarde toutes les spécialisations
    for specid, specdata in pairs(bislist) do
      if specid ~= "spec" then
        helperSaveBestInSlotList(tierdb, guildname, guildplayer, specdata, raidtier, difficulty, specid, registerHistory)
      end
    end
  else
    -- Sinon, sauvegarde uniquement la spécialisation spécifiée
    helperSaveBestInSlotList(tierdb, guildname, guildplayer, bislist, raidtier, difficulty, spec, registerHistory)
  end
  -- Déclenche un événement pour indiquer que le cache de la guilde a été mis à jour
  self:SendEvent("GuildCacheUpdated")
end


local function tableHasItems(tbl)
  -- Vérifie si l'entrée est une table valide et contient des éléments
  if type(tbl) == "table" then
    return next(tbl) ~= nil -- Utilise `next` pour vérifier efficacement si la table est vide
  end
  return false
end


local GetCacheDataCache = {}
local GuildBiSCache = {}
local function refreshCache()
  BestInSlot:UnregisterEvent("GuildCacheUpdated", GetCacheDataCache.eventId)
  wipe(GetCacheDataCache)
  wipe(GuildBiSCache)
end


-- Récupère les listes BiS mises en cache
-- @return Les listes Bis
function BestInSlot:GetCacheData()
  -- Si les données sont déjà en cache, on les retourne directement
  if #GetCacheDataCache > 0 then
    return unpack(GetCacheDataCache)
  end
  local db = self.db.factionrealm
  local result = {}
  local raidTiers = {}
  local guilds = {}
  local difficulties = {}
  -- Parcours des données de la guilde
---@diagnostic disable-next-line: param-type-mismatch
  for guildName, guildData in pairs(db) do
    if guildName ~= "_history" and tableHasItems(guildData) then
      tinsert(guilds, guildName)
      -- Parcours des joueurs de la guilde
      for playerName, playerData in pairs(guildData) do
        if tableHasItems(playerData) then
          result[playerName] = {guild = guildName}
          -- Parcours des niveaux de raid
          for raidTier, raidTierData in pairs(playerData) do
            if tableHasItems(raidTierData) then
              -- Ajout du raidTier si nécessaire (on utilise une table pour vérifier la présence)
              if not raidTiers[raidTier] then
                raidTiers[raidTier] = true
                tinsert(raidTiers, raidTier)
              end
              -- Parcours des difficultés du raid
              for difficulty, bisList in pairs(raidTierData) do
                if tableHasItems(bisList) then
                  difficulties[raidTier] = difficulties[raidTier] or {}
                  -- Vérification si la difficulté existe déjà
                  local addDifficulty = true
                  if type(difficulties[raidTier]) == "table" then
                    for _, existingDifficulty in ipairs(difficulties[raidTier]) do
                      if existingDifficulty == difficulty then
                        addDifficulty = false
                        break
                      end
                    end
                  end
                  -- Ajout de la difficulté si elle n'existe pas encore
                  if addDifficulty then
                    tinsert(difficulties[raidTier], difficulty)
                    tsort(difficulties[raidTier])  -- Tri des difficultés après ajout
                  end
                  -- Ajout de l'entrée pour le joueur dans la table de résultats
                  tinsert(result[playerName], {raidTier, difficulty})
                end
              end
            end
          end
        end
      end
    end
  end
  -- Mise à jour du cache avec les nouvelles données
  GetCacheDataCache = { result, raidTiers, guilds, difficulties }
  GetCacheDataCache.eventId = self:RegisterEvent("GuildCacheUpdated", refreshCache)
  -- Retourne les résultats en cache
  return unpack(GetCacheDataCache)
end




--- Obtient une liste avec les joueurs qui ont besoin de l'ID d'élément spécifié
-- @return table Table avec le joueur comme clé et ses spécifications comme table comme valeur

function BestInSlot:GetGuildMembersByItemID(itemid, difficulty)
  -- Vérification du cache pour éviter des calculs inutiles
  if GuildBiSCache[itemid] and GuildBiSCache[itemid][difficulty] then
    return GuildBiSCache[itemid][difficulty]
  end
  -- Si l'utilisateur n'est pas dans une guilde, retournez une table vide
  if not IsInGuild() then return {} end
  -- Obtenez le nom de la guilde et les données en cache
  local guildName = GetGuildInfo("player")
  local playerData, raidData, guildData, difficultyData = self:GetCacheData()
  -- Vérifiez que guildData est valide et contient le nom de la guilde
  if type(guildData) ~= "table" or not tContains(guildData, guildName) then
    return {}
  end
  -- Initialisation du tableau de résultats
  local result = {}
  -- Obtenez les données du token pour l'item donné
  local tokenData = tierTokenData[itemid]
  -- Si playerData est une table, itérons à travers les joueurs
  if type(playerData) == "table" then
    for player, playerInfo in pairs(playerData) do
      local class = self:GetPlayerClass(player)
      -- Si playerInfo est une table, traiter les informations de raid pour chaque joueur
      if type(playerInfo) == "table" then
        for i = 1, #playerInfo do
          local raidInfo = playerInfo[i]
          -- Si raidInfo est une table et correspond à la difficulté, traiter les données
          if type(raidInfo) == "table" and raidInfo[2] == difficulty then
            -- Obtenez la liste BiS pour ce raid et le joueur
            local raidBiSList = self.db.factionrealm[guildName][player][raidInfo[1]][raidInfo[2]]
            -- Vérification de raidBiSList
            if type(raidBiSList) == "table" then
              for specId, specData in pairs(raidBiSList) do
                -- Vérification de specData et traitement de l'item
                if type(specData) == "table" then
                  local itemTable = {}
                  -- Si tokenData existe, utilisez-le pour configurer les slots
                  if tokenData and class then
                    -- Si tokenData.slotid == 0, on utilise tokenData[class]
                    if tokenData.slotid == 0 then
                      itemTable = tokenData[class]
                    else
                      itemTable[tokenData.slotid] = tokenData.classes[class]
                    end
                    local inBiS
                    local obtained = true
                    -- Vérification de chaque slot dans itemTable
                    for slot, id in pairs(itemTable) do
                      if specData[slot] and specData[slot].item == id then
                        inBiS = true
                        result[player] = result[player] or {}
                        obtained = obtained and specData[slot].obtained
                      end
                    end
                    -- Si l'item est dans la BiS, ajoutez-le aux résultats
                    if inBiS then
                      result[player][specId] = {obtained = obtained, text = tierTokenData[itemid].itemType}
                    end
                  end
                    -- Si tokenData est nil, vérifiez chaque élément de specData
                  for j in pairs(specData) do
                    if specData[j].item == itemid then
                      result[player] = result[player] or {}
                      result[player][specId] = result[player][specId] or specData[j].obtained
                      break
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  -- Met à jour le cache avec les nouvelles données pour cet item et cette difficulté
  if not GuildBiSCache[itemid] then
    GuildBiSCache[itemid] = {}
  end
  GuildBiSCache[itemid][difficulty] = result
  -- Retourne les résultats obtenus
  return result
end



--- Fonction pour récupérer le nil que GetSpecialization() renvoie
-- @return 1,2,3,4 selon la spécialisation du personnage, par défaut 1 si aucune n'est sélectionnée

function BestInSlot:GetSpecialization()
  -- Récupère la spécialisation active du joueur, ou retourne 1 si aucune spécialisation n'est trouvée
  local spec = GetSpecialization()
  -- Si GetSpecialization retourne une valeur valide, la renvoyer, sinon retourner la valeur par défaut 1
  if spec and spec > 0 then
    return spec
  else
    return 1  -- Valeur par défaut si aucune spécialisation n'est active
  end
end


--- Fonction permettant de récupérer toutes les spécialisations du joueur
-- @return table Tableau avec comme index l'ID global et comme valeur la description localisée

function BestInSlot:GetAllSpecializations()
  local result = {}
  -- Parcours toutes les spécialisations disponibles et les ajoute à la table résultat
  for i = 1, GetNumSpecializations() do
    local id, name = GetSpecializationInfo(i)
    result[id] = name
  end
  return result
end

local playerClassCache = setmetatable({DEFAULT = {}}, {
  __index = function(table, key)
    -- Si les données existent déjà dans le cache, on les retourne directement
    local cachedData = rawget(table, key)
    if cachedData then return cachedData end
    -- Extraction du nom et du royaume du joueur si spécifié (ex: Joueur-Realm)
    local searchName, searchRealm = key, nil
    if key:find("-") then
      searchName, searchRealm = key:match("(%D+)-(%D+)")
    end
    -- Fonction pour rechercher dans un groupe (raid ou party)
    local function findInGroup(groupPrefix, groupSize)
      for i = 1, groupSize do
        local unit = groupPrefix..i
        local name, realm = UnitName(unit)
        if name and (not realm or realm == searchRealm) and name == searchName then
          local localized, class = UnitClass(unit)
          table[key] = {class, localized}
          return {class, localized}
        end
      end
    end
    -- Recherche dans un raid
    if IsInRaid() then
      local result = findInGroup("raid", 40)
      if result then return result end
    -- Recherche dans un groupe
    elseif IsInGroup() then
      local result = findInGroup("party", 5)
      if result then return result end
    end
    -- Recherche dans la guilde
    if IsInGuild() then
      local playerRealm = select(2, UnitFullName("player"))
      for i = 1, GetNumGuildMembers() do
        local nameWithRealm, _, _, _, localizedClass, _, _, _, _, _, class = GetGuildRosterInfo(i)
        local playerName, realm = nameWithRealm:match("(%D+)-(%D+)")
        if playerName == searchName and ((not searchRealm and realm == playerRealm) or realm == searchRealm) then
          table[key] = {class, localizedClass}
          return {class, localizedClass}
        end
      end
    end
    -- Si rien n'est trouvé, on retourne les données par défaut
    return rawget(table, "DEFAULT")
  end
})

-- Rechercher la classe d'un joueur dans la guilde
-- @param #string name Le nom du joueur à rechercher
-- @return #string La classe du joueur s'il est trouvé
-- @return #nil Nil si le joueur n'a pas été trouvé

function BestInSlot:GetPlayerClass(name)
  -- Vérifie si un nom de joueur est fourni
  if not name then return nil end
  -- Vérifie si le joueur existe dans le cache
  local playerClassData = playerClassCache[name]
  -- Si les données du joueur ne sont pas dans le cache, retourne nil
  if not playerClassData then
    return nil
  end
  -- Retourne la classe et les informations associées (si disponibles)
  return playerClassData[1], playerClassData[2]
end



function BestInSlot:GetPlayerString(name)
  -- Vérification si le nom est valide
  if not name or name == "" then
    return "|cffb5b4ffUnknown name|r"  -- Retourne un nom par défaut si le nom est invalide
  end
  -- Récupère la classe du joueur (si possible)
  local playerClass = self:GetPlayerClass(name)
  -- Si la classe du joueur est inconnue, retourner le nom avec la couleur par défaut
  if not playerClass then
    return ("|cffb5b4ff%s|r"):format(name)
  else
    -- Si la classe est connue, retourner le nom avec la couleur de la classe
    return ("%s%s|r"):format(self:GetClassColor(playerClass) or "|cffb5b4ff", name)
  end
end



function BestInSlot:GetClassColor(class)
  -- Vérifier si la classe existe dans RAID_CLASS_COLORS
  local classColor = RAID_CLASS_COLORS[class]
  -- Si la classe est trouvée, retourner la couleur associée
  if classColor then
    return "|c" .. classColor.colorStr
  end
  -- Si la classe n'est pas trouvée, retourner une couleur par défaut (gris ici)
  return "|cffb5ffb4"  -- Couleur par défaut : gris clair
end



function BestInSlot:GetClassString(class)
  -- Vérifier si LOCALIZED_CLASS_NAMES_MALE est défini et accessible
  local className = (LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[class]) or "Unknown class"
  
  -- Retourne la chaîne formatée avec la couleur de la classe et le nom localisé de la classe
  return (self:GetClassColor(class) or "|cffb5ffb4") .. className .. "|r"
end




local guildRankCache = {}
function BestInSlot:GetGuildRank(player)
  -- Vérification si le nom du joueur est valide
  if not player or player == "" then
    return nil
  end
  -- Si les informations du joueur sont déjà en cache, on les retourne
  if guildRankCache[player] then
    return unpack(guildRankCache[player])
  end
  -- Extraire le nom et le royaume du joueur (si spécifié)
  local searchName, searchRealm = player, nil
  local playerRealm = select(2, UnitFullName("player"))
  -- Si le nom du joueur contient un tiret, cela signifie qu'un royaume est spécifié
  if player:find("-") then
    searchName, searchRealm = player:match("(%D+)-(%D+)")
  end
  -- Recherche dans le roster de la guilde
  for i = 1, GetNumGuildMembers() do
    local nameWithRealm, rankDescr, guildRank = GetGuildRosterInfo(i)
    local playerName, realmName = nameWithRealm:match("(%D+)-(%D+)")
    -- Vérifier si le joueur trouvé correspond au nom et au royaume
    if playerName == searchName and 
       ((not searchRealm and realmName == playerRealm) or (searchRealm and realmName == searchRealm)) then
       -- Cache les informations de rang de guilde
      guildRankCache[player] = {guildRank + 1, rankDescr}
      return unpack(guildRankCache[player])
    end
  end
  -- Si le joueur n'a pas été trouvé, retourner nil
  return nil
end



function BestInSlot:GetPlayerInfo()
  -- Récupérer les informations du joueur
  local race, raceFileName = UnitRace("player")
  local sex = UnitSex("player") == 2 and -1 or 0  -- 0 pour masculin, -1 pour féminin
  local name = UnitName("player")
  local class, classFileName = UnitClass("player")

  -- Retourner les informations sous forme de table
  return { 
    race = race,      -- Race du joueur
    sex = sex,        -- Sexe du joueur (-1 pour féminin, 0 pour masculin)
    name = name,      -- Nom du joueur
    class = class     -- Classe du joueur
  }
end

