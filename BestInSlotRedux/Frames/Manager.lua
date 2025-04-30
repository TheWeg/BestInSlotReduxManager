--lua
local unpack, select, type, tinsert, ceil, abs, min, max
=     unpack, select, type, table.insert, math.ceil, math.abs, math.min, math.max
--WoW API
local IsControlKeyDown, IsShiftKeyDown, GetItemUniqueness, GetItemIcon, DressUpItemLink, GetInventorySlotInfo, GetNumSpecializations, GetSpecializationInfo, GetItemInfo
=     IsControlKeyDown, IsShiftKeyDown, C_Item.GetItemUniqueness, C_Item.GetItemIconByID, DressUpItemLink, GetInventorySlotInfo, GetNumSpecializations, GetSpecializationInfo, C_Item.GetItemInfo
local BestInSlot, L, AceGUI = unpack(select(2, ...))
local frameName = (L["%s manager"]):format("BiS")
local Manager = BestInSlot:GetMenuPrototype(frameName)
local BabbleInventory = LibStub("LibBabble-Inventory-3.0"):GetLookupTable()
local dropdownRaidtier, dropdownDifficulty, dropdownSpecialization, dropdownImport, slotContainer --widgets that are referenced later
local itemGroups = {}
local legionRelicGroups = {}
local itemSelectionMode = false
local lowerRaidTiers = false
local showAllItems = false
local statModifiers = {
  32, --crit
  36, --hâte
  40, --polyvalence
  49  --maîtrise
}
local statText = {
  [32] = ITEM_MOD_CRIT_RATING_SHORT,
  [36] = ITEM_MOD_HASTE_RATING_SHORT,
  [40] = ITEM_MOD_VERSATILITY,
  [49] = ITEM_MOD_MASTERY_RATING_SHORT
}
local statsToItemTable = {
  ["32"] = 221913,
  ["36"] = 221916,
  ["40"] = 221922,
  ["49"] = 221919,
  ["3236"] = 222585,
  ["3632"] = 222585,
  ["3240"] = 222594,
  ["4032"] = 222594,
  ["3249"] = 222593,
  ["4932"] = 222593,
  ["3640"] = 222581,
  ["4036"] = 222581,
  ["3649"] = 222584,
  ["4936"] = 222584,
  ["4049"] = 222588,
  ["4940"] = 222588
}

local GEM_TYPE_INFO =	{	Yellow = {textureKit="yellow", r=0.97, g=0.82, b=0.29},
							Red = {textureKit="red", r=1, g=0.47, b=0.47},
							Blue = {textureKit="blue", r=0.47, g=0.67, b=1},
							Hydraulic = {textureKit="hydraulic", r=1, g=1, b=1},
							Cogwheel = {textureKit="cogwheel", r=1, g=1, b=1},
							Meta = {textureKit="meta", r=1, g=1, b=1},
							Prismatic = {textureKit="prismatic", r=1, g=1, b=1},
							PunchcardRed = {textureKit="punchcard-red", r=1, g=0.47, b=0.47},
							PunchcardYellow = {textureKit="punchcard-yellow", r=0.97, g=0.82, b=0.29},
							PunchcardBlue = {textureKit="punchcard-blue", r=0.47, g=0.67, b=1},
							Domination = {textureKit="domination", r=1, g=1, b=1},
							Cypher = {textureKit="meta", r=1, g=1, b=1},
							Tinker = {textureKit="punchcard-red", r=1, g=0.47, b=0.47},
							Primordial = {textureKit="meta", r=1, g=1, b=1},
							Fragrance = {textureKit="hydraulic", r=1, g=1, b=1},
							SingingThunder = {textureKit="yellow", r=0.97, g=0.82, b=0.29},
							SingingSea = {textureKit="blue",r=0.47, g=0.67, b=1},
							SingingWind = {textureKit="red", r=1, g=0.47, b=0.47}
						}

Manager.Width = 800
Manager.Height = 600

function Manager:SetSlotContainerPosition(callback, funcArgs)
  local selectContainer = slotContainer:GetUserData("selectContainer")
  selectContainer.frame:ClearAllPoints()
  selectContainer:SetPoint("TOPLEFT", slotContainer.frame, "TOPLEFT", -10, -45)
  selectContainer:SetPoint("BOTTOMRIGHT", dropdownImport.frame, "BOTTOMRIGHT", 0, 20)
  if callback then
    local type = type(callback)
    if type == "function" then
      callback(unpack(funcArgs))
    elseif type == "string" and self[callback] then
      self[callback](self, unpack(funcArgs))
    end
  end
end

function Manager:DoMoveAnimation(itemGroup, location, callback, ...)
  slotContainer:PauseLayout()
  itemGroup:ClearAllPoints()

  local button = itemGroup:GetUserData("button")
  local targetX = 0
  local targetY = 0
  if location == "RIGHT" then
    targetX = 150
  elseif location == "LEFT" then
    targetX = -150
  end
  if not self.options.instantAnimation then
    local index = itemGroup:GetUserData("index")
    local ofsX = 150
    local ofsY = -((ceil(index/2) - 1) * 45)
    if index % 2 == 1 then --right
      ofsX = -ofsX
    end
    itemGroup:SetPoint("TOP", slotContainer.frame, "TOP", ofsX, ofsY)
    local timer
    local funcArgs = {...}
    button:SetDisabled(true)
    timer = self:ScheduleRepeatingTimer(function()
      local speedX = 12
      local speedY
      if ofsX == targetX then
        speedY = speedX
      else
        speedY = abs(speedX * (ofsY / ofsX))
      end
      if ofsX < targetX then
        ofsX = min(ofsX + speedX, targetX)
      else
        ofsX = max(ofsX - speedX, targetX)
      end
      ofsY = min(ofsY + speedY, targetY)
      itemGroup:SetPoint("TOP", slotContainer.frame, "TOP", ofsX, ofsY)
      if ofsX == targetX and ofsY == targetY then
        self:CancelTimer(timer)
        button:SetDisabled(false)
        Manager:SetSlotContainerPosition(callback, funcArgs)
      end
    end,
    0.0166)
  else
    itemGroup:SetPoint("TOP", slotContainer.frame, "TOP", targetX, targetY)
    self:SetSlotContainerPosition(callback, {...})
  end
end

local function selectItemLabelOnEnter(widget)
  if itemSelectionMode and GameTooltip:IsVisible() then
    local itemGroup = itemGroups[itemSelectionMode[1]]
    local itemid = itemGroup:GetUserData("icon"):GetUserData("itemid")
    if itemid then
      Manager:GetItemComparisonTooltip(GameTooltip, itemid, Manager:GetSelected(Manager.DIFFICULTY))
    end
  end
end

local function selectItemLabelOnClick(widget, _, key)
    if not (IsControlKeyDown() or IsShiftKeyDown()) then
        local itemid = widget:GetUserData("itemid")
        ---@diagnostic disable-next-line: need-check-nil
        local itemGroup = itemGroups[itemSelectionMode[1]]
        ---@diagnostic disable-next-line: need-check-nil
        if itemSelectionMode[2] and key == "RightButton" then
          ---@diagnostic disable-next-line: need-check-nil
          itemGroup = itemGroups[itemSelectionMode[2]]
        end
        local difficulty = widget:GetUserData("difficulty") or Manager:GetSelected(Manager.DIFFICULTY)
        local list, spec = Manager:GetSelected(Manager.SPECIALIZATION)
        local raidTier = Manager:GetSelected(Manager.RAIDTIER)
        local slotid = itemGroup:GetUserData("slotid")
        local item, itemInfo = Manager:GetItem(itemid, difficulty, BestInSlot:GetModificationTable(raidTier, difficulty, list, slotid))
        Manager:SetItemBestInSlot(raidTier, difficulty, list, slotid, itemid)
        local icon = itemGroup:GetUserData("icon")
        local oldItemId = icon:GetUserData("itemid")
        if item then
            itemGroup:GetUserData("label"):SetText(item.link)
            icon:SetImage(GetItemIcon(item.itemid))
            icon:SetUserData("itemid", item.itemid)
            itemInfo:ContinueOnItemLoad(function()
              icon:SetUserData("itemlink", item.link)
            end)
        else
            itemGroup:GetUserData("label"):SetText("")
            icon:SetImage(unpack(itemGroup:GetUserData("defaultTexture")))
            icon:SetUserData("itemid", nil)
            icon:SetUserData("itemlink", nil)
        end
        ---@diagnostic disable-next-line: need-check-nil
        if item and itemSelectionMode[1] == 15 then
            if select(2, Manager:GetSelected(Manager.SPECIALIZATION)) ~= 72 then --Don't disable for fury warriors
                local offhandGroup = itemGroups[16]
                local offhandIcon = offhandGroup:GetUserData("icon")
                local offhandLabel = offhandGroup:GetUserData("label")
                local offhandButton = offhandGroup:GetUserData("button")
                local subclass = select(7, GetItemInfo(item.itemid))
                if item and (item.equipSlot == "INVTYPE_2HWEAPON" or item.equipSlot == "INVTYPE_RANGED" or (item.equipSlot == "INVTYPE_RANGEDRIGHT" and subclass ~= BabbleInventory.Wands)) then
                    offhandIcon:SetUserData("disabled", true)
                    offhandIcon:SetImage(unpack(offhandGroup:GetUserData("defaultTexture")))
                    offhandLabel:SetText("")
                    offhandButton:SetDisabled(true)
                    Manager:SetItemBestInSlot(raidTier, difficulty, spec, 17, nil)
                else
                    offhandIcon:SetUserData("disabled", false)
                    offhandButton:SetDisabled(false)
                end
            end
        end
        local uniqueness, oldUniqueness
        if item then
            uniqueness = GetItemUniqueness(item.itemid)
        end
        if oldItemId then
            oldUniqueness = GetItemUniqueness(oldItemId)
        end
        --if uniqueness or oldUniqueness then
          ---@diagnostic disable-next-line: need-check-nil
          Manager:FillSelectContainer(itemGroups[itemSelectionMode[1]], raidTier, difficulty, slotid)
        --end
    end
end


local function buttonoverlay(self, elementData)
  if elementData and elementData.item and elementData.item.BestInSlot then
    if self.ProfessionQualityOverlay then
      self.isProfessionItem = false
      self:UpdateCraftedProfessionsQualityShown()
    end
    if self.Count then
      self.Count:SetText("")
    end
    if elementData.item.BestInSlot.icon then
      self:SetItemButtonTexture(elementData.item.BestInSlot.icon)
    end
  end
end
hooksecurefunc(ProfessionsItemFlyoutButtonMixin, "Init", buttonoverlay)

local function embellishIconOnClick(widget, _, key)
  local raidTier = BestInSlot:GetSelected(BestInSlot.RAIDTIER)
  local difficulty = BestInSlot:GetSelected(BestInSlot.DIFFICULTY)
  local list = BestInSlot:GetSelected(BestInSlot.SPECIALIZATION)
  local slot = widget:GetUserData("slot")
  local bisList = Manager.db.char[raidTier][difficulty][list]
  local itemId = bisList[slot]

  if key == "RightButton" then
    if bisList.modifications and bisList.modifications[slot] then
      bisList.modifications[slot].embellish = nil
    end
    widget:SetImage(unpack(widget:GetUserData("defaultImage")))
    widget:SetUserData("embellish")
    local itemTable, itemInfo = Manager:GetItem(itemId, difficulty, bisList.modifications[slot])
    itemInfo:ContinueOnItemLoad(function() widget:GetUserData("itemGroup"):GetUserData("icon"):SetUserData("itemlink", itemTable.link) end)
    return
  end

  local flyout = ToggleProfessionsItemFlyout(widget.frame, widget.frame)
  if flyout then
    flyout.GetElementsImplementation = function(self)
      local elementData = {items = widget:GetUserData("items"), forceAccumulateInventory = false};
      return elementData;
    end
    flyout.OnElementEnabledImplementation = function(button, elementData)
      return true
    end
    flyout.OnElementEnterImplementation = function(elementData, tooltip)
      local tooltipInfo = C_TooltipInfo.GetItemByID(elementData.item.itemID)
      tooltip:AddLine(tooltipInfo.lines[1].leftText, tooltipInfo.lines[1].leftColor.r, tooltipInfo.lines[1].leftColor.g, tooltipInfo.lines[1].leftColor.b)
      tooltip:AddLine(" ")
      tooltip:AddLine(tooltipInfo.lines[5].leftText, 1, 1, 1, true)
    end
    local function OnFlyoutItemSelected(o, flyout, elementData)
      bisList.modifications  = bisList.modifications or {}
      bisList.modifications[slot] = Manager.db.char[raidTier][difficulty][list].modifications[slot] or {}
      bisList.modifications[slot].embellish = elementData.item.itemID
      widget:SetImage(C_Item.GetItemIconByID(elementData.item.itemID))
      widget:SetUserData("embellish", elementData.item.itemID)
      local itemTable, itemInfo = Manager:GetItem(itemId, difficulty, bisList.modifications[slot])
      itemInfo:ContinueOnItemLoad(function() widget:GetUserData("itemGroup"):GetUserData("icon"):SetUserData("itemlink", itemTable.link) end)
    end

    flyout:RegisterCallback(ProfessionsItemFlyoutMixin.Event.ItemSelected, OnFlyoutItemSelected, widget)
    flyout:Init(nil, nil, false)
  end
end

local function statsIconOnClick(widget, _, key)
  local raidTier = BestInSlot:GetSelected(BestInSlot.RAIDTIER)
  local difficulty = BestInSlot:GetSelected(BestInSlot.DIFFICULTY)
  local list = BestInSlot:GetSelected(BestInSlot.SPECIALIZATION)
  local slot = widget:GetUserData("slot")
  local bisList = Manager.db.char[raidTier][difficulty][list]
  local itemId = bisList[slot]

  if key == "RightButton" then
    if bisList.modifications and bisList.modifications[slot] then
      bisList.modifications[slot].stats = nil
    end
    widget:SetImage(unpack(widget:GetUserData("defaultImage")))
    local itemTable, itemInfo = Manager:GetItem(itemId, difficulty, bisList.modifications[slot])
    itemInfo:ContinueOnItemLoad(function() widget:GetUserData("itemGroup"):GetUserData("icon"):SetUserData("itemlink", itemTable.link) end)
    return
  end

  local flyout = ToggleProfessionsItemFlyout(widget.frame, widget.frame)
  if flyout then
    flyout.GetElementsImplementation = function(self)
      --local items = Professions.GenerateFlyoutItemsTable({224072});
      local elementData = {items = widget:GetUserData("items"), forceAccumulateInventory = false};
      return elementData;
    end
    flyout.OnElementEnabledImplementation = function(button, elementData)
      return true
    end
    flyout.OnElementEnterImplementation = function(elementData, tooltip)
      tooltip:AddLine(elementData.item.BestInSlot.statsHeader)
      tooltip:AddLine(" ")
      tooltip:AddLine(elementData.item.BestInSlot.stat1, 1, 1, 1)
      if elementData.item.BestInSlot.stat2 then
        tooltip:AddLine(elementData.item.BestInSlot.stat2, 1, 1, 1)
      end
    end
    local function OnFlyoutItemSelected(o, flyout, elementData)
      bisList.modifications  = bisList.modifications or {}
      bisList.modifications[slot] = bisList.modifications[slot] or {}
      bisList.modifications[slot].stats = elementData.item.BestInSlot.stats
      widget:SetUserData("stats", elementData.item.BestInSlot.stats)
      widget:SetImage(C_Item.GetItemIconByID(statsToItemTable[table.concat(elementData.item.BestInSlot.stats)]))
      local itemTable, itemInfo = Manager:GetItem(itemId, difficulty, bisList.modifications[slot])
      itemInfo:ContinueOnItemLoad(function() widget:GetUserData("itemGroup"):GetUserData("icon"):SetUserData("itemlink", itemTable.link) end)
    end

    flyout:RegisterCallback(ProfessionsItemFlyoutMixin.Event.ItemSelected, OnFlyoutItemSelected, widget)
    flyout:Init(nil, nil, false)
  end
end

local function enchantIconOnClick(widget, _, key)
  local raidTier = BestInSlot:GetSelected(BestInSlot.RAIDTIER)
  local difficulty = BestInSlot:GetSelected(BestInSlot.DIFFICULTY)
  local list = BestInSlot:GetSelected(BestInSlot.SPECIALIZATION)
  local slot = widget:GetUserData("slot")
  local bisList = Manager.db.char[raidTier][difficulty][list]
  local itemId = bisList[slot]

  if key == "RightButton" then
    if bisList.modifications and bisList.modifications[slot] then
      bisList.modifications[slot].enchant = nil
    end
    widget:SetImage(unpack(widget:GetUserData("defaultImage")))
    widget:SetUserData("enchant")
    local itemTable, itemInfo = Manager:GetItem(itemId, difficulty, bisList.modifications[slot])
    itemInfo:ContinueOnItemLoad(function() widget:GetUserData("itemGroup"):GetUserData("icon"):SetUserData("itemlink", itemTable.link) end)
    return
  end

  local flyout = ToggleProfessionsItemFlyout(widget.frame, widget.frame)
  if flyout then
    flyout.GetElementsImplementation = function(self)
      --local items = Professions.GenerateFlyoutItemsTable({224072});
      local elementData = {items = widget:GetUserData("items"), forceAccumulateInventory = false};
      return elementData;
    end
    flyout.OnElementEnabledImplementation = function(button, elementData)
      return true
    end
    flyout.OnElementEnterImplementation = function(elementData, tooltip)
      local spellInfo = Spell:CreateFromSpellID(elementData.item.BestInSlot.spellId)
      local itemInfo
      local enchantList = Manager:GetEnchants(raidTier, widget:GetUserData("invType"))
      if enchantList[tostring(elementData.item.BestInSlot.spellId)] then
        itemInfo = Item:CreateFromItemID(enchantList[tostring(elementData.item.BestInSlot.spellId)])
      end
      spellInfo:ContinueOnSpellLoad(function()
        local tooltipInfo = C_TooltipInfo.GetRecipeResultItem(elementData.item.BestInSlot.spellId, nil,nil,nil,3)
        if itemInfo then
          itemInfo:ContinueOnItemLoad(function()
            tooltip:AddLine(itemInfo:GetItemName())
            if #tooltipInfo.lines > 1 then
              tooltip:AddLine(" ")
              tooltip:AddLine(tooltipInfo.lines[#tooltipInfo.lines].leftText, 1, 1, 1, true)
            end
          end)
        else
          tooltip:AddLine(C_Spell.GetSpellName(elementData.item.BestInSlot.spellId))
          if #tooltipInfo.lines > 1 then
            tooltip:AddLine(" ")
            tooltip:AddLine(tooltipInfo.lines[#tooltipInfo.lines].leftText, 1, 1, 1, true)
          end
        end
      end)
    end
    local function OnFlyoutItemSelected(o, flyout, elementData)
      bisList.modifications  = bisList.modifications or {}
      bisList.modifications[slot] = bisList.modifications[slot] or {}
      bisList.modifications[slot].enchant = elementData.item.BestInSlot.spellId
      widget:SetUserData("enchant", elementData.item.BestInSlot.spellId)
      widget:SetImage(elementData.item.BestInSlot.icon)
      local itemTable, itemInfo = Manager:GetItem(itemId, difficulty, bisList.modifications[slot])
      itemInfo:ContinueOnItemLoad(function() widget:GetUserData("itemGroup"):GetUserData("icon"):SetUserData("itemlink", itemTable.link) end)
    end

    flyout:RegisterCallback(ProfessionsItemFlyoutMixin.Event.ItemSelected, OnFlyoutItemSelected, widget)
    flyout:Init(nil, nil, false)
  end
end

local function gemIconOnClick(widget, what, key)
  local raidTier = BestInSlot:GetSelected(BestInSlot.RAIDTIER)
  local difficulty = BestInSlot:GetSelected(BestInSlot.DIFFICULTY)
  local list = BestInSlot:GetSelected(BestInSlot.SPECIALIZATION)
  local slot = widget:GetUserData("slot")
  local index = widget:GetUserData("index")
  local bisList = Manager.db.char[raidTier][difficulty][list]
  local itemId = bisList[slot]

  if key == "RightButton" then
    if bisList.modifications and bisList.modifications[slot] then
      bisList.modifications[slot]["gem"..index] = nil
    end
    widget:SetImage(unpack(widget:GetUserData("defaultImage")))
    widget:SetUserData("gem")
    local itemTable, itemInfo = Manager:GetItem(itemId, difficulty, bisList.modifications[slot])
    itemInfo:ContinueOnItemLoad(function() widget:GetUserData("itemGroup"):GetUserData("icon"):SetUserData("itemlink", itemTable.link) end)
    return
  end

  local flyout = ToggleProfessionsItemFlyout(widget.frame, widget.frame)
  if flyout then
    flyout.GetElementsImplementation = function(self)
      --local items = Professions.GenerateFlyoutItemsTable({224072});
      local elementData = {items = widget:GetUserData("items"), forceAccumulateInventory = false};
      return elementData;
    end
    flyout.OnElementEnabledImplementation = function(button, elementData)
      return true
    end
    flyout.OnElementEnterImplementation = function(elementData, tooltip)
      GameTooltip:SetItemByID(elementData.item.itemID)
    end
    local function OnFlyoutItemSelected(o, flyout, elementData)
      bisList.modifications  = bisList.modifications or {}
      bisList.modifications[slot] = bisList.modifications[slot] or {}
      bisList.modifications[slot]["gem"..index] = elementData.item.itemID
      widget:SetImage(C_Item.GetItemIconByID(elementData.item.itemID))
      widget:SetUserData("gem", elementData.item.itemID)
      local itemTable, itemInfo = Manager:GetItem(itemId, difficulty, bisList.modifications[slot])
      itemInfo:ContinueOnItemLoad(function() widget:GetUserData("itemGroup"):GetUserData("icon"):SetUserData("itemlink", itemTable.link) end)
    end

    flyout:RegisterCallback(ProfessionsItemFlyoutMixin.Event.ItemSelected, OnFlyoutItemSelected, widget)
    flyout:Init(nil, nil, false)
  end
end

function Manager:FillSelectContainer(itemGroup, raidTier, difficulty, slotid)
  local selectContainer = slotContainer:GetUserData("selectContainer")
  local itemhighlight = "Interface\\QuestFrame\\UI-QuestTitleHighlight"
  selectContainer:SetLayout("Flow")
  selectContainer:ReleaseChildren()
  local header = AceGUI:Create("Heading")
  header:SetFullWidth(true)
  local slotData = self.invSlots[slotid]
  if type(slotData) == "table" then
    slotData = slotData[1]
  end

  local impGroup = AceGUI:Create("SimpleGroup")
  selectContainer:AddChild(impGroup)
  impGroup:SetHeight(0)
  impGroup:PauseLayout()

  local list, spec = Manager:GetSelected(Manager.SPECIALIZATION)
  local slot = itemGroups[itemSelectionMode[1]]:GetUserData("slotid")
  local itemId = Manager.db.char[raidTier][difficulty][list][slot]
  local function generateModButtons()
    local modifications = {}
    if itemId then
      local itemTable, itemInfo = Manager:GetItem(itemId, difficulty, {})
      if not itemInfo:IsItemDataCached() then
        itemInfo:ContinueOnItemLoad(function() Manager:FillSelectContainer(itemGroup, raidTier, difficulty, slotid) end)
        return
      end
      local tooltipData = C_TooltipInfo.GetHyperlink(itemTable.itemstr)
      local stat1Sign, stat1Value, stat2Sign, stat2Value
      local sockets = {}
      if itemTable.recipe then
        local recipeSchematic = C_TradeSkillUI.GetRecipeSchematic(itemTable.recipe, false)
        local embellishTable = self:GetEmbellish(raidTier)
        for _, reagentSlot in ipairs(recipeSchematic.reagentSlotSchematics) do
          if reagentSlot.dataSlotType == 2 and reagentSlot.reagents and reagentSlot.reagents[3] and embellishTable and embellishTable[reagentSlot.reagents[3].itemID] then
            local button = AceGUI:Create("Icon")
            local border = AceGUI:Create("Icon")
            border:SetImage("interface/framegeneral/uiframeiconborder", 0.0078125, 0.5078125, 0.0078125, 0.5078125)
            button:SetUserData("border", border)
            local items = {}
            for i = 3, #reagentSlot.reagents, 3 do
              itemInfo = Item:CreateFromItemID(reagentSlot.reagents[i].itemID)
              itemInfo.BestInSlot = {}
              table.insert(items, itemInfo)
            end
            button:SetUserData("items", items)
            button:SetUserData("slot", slot)
            button:SetUserData("cancelTooltip", function() end)
            local atlasInfo = C_Texture.GetAtlasInfo("professions-slot-bg")
            button:SetUserData("defaultImage", {"interface\\professions\\professions", atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord})
            button:SetImage("interface\\professions\\professions", atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord)
            local current = Manager.db.char[raidTier][difficulty][list].modifications and Manager.db.char[raidTier][difficulty][list].modifications[slot] and Manager.db.char[raidTier][difficulty][list].modifications[slot].embellish
            if current then
              button:SetImage(C_Item.GetItemIconByID(current))
              button:SetUserData("embellish", current)
            end
            button:SetCallback("OnClick", embellishIconOnClick)
            tinsert(modifications, button)
            button:SetCallback("OnEnter", function()
              local embellish = button:GetUserData("embellish")
              if embellish then
                local itemInfo = Item:CreateFromItemID(embellish)
                button:SetUserData("cancelTooltip", itemInfo:ContinueWithCancelOnItemLoad(function()
                  local tooltipInfo = C_TooltipInfo.GetItemByID(embellish)
                  if #tooltipInfo.lines > 4 then
                    GameTooltip:SetOwner(button.frame, "ANCHOR_RIGHT")
                    GameTooltip:AddLine(tooltipInfo.lines[1].leftText, tooltipInfo.lines[1].leftColor.r, tooltipInfo.lines[1].leftColor.g, tooltipInfo.lines[1].leftColor.b)
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine(tooltipInfo.lines[5].leftText, 1, 1, 1, true)
                    GameTooltip:Show()
                  end
                end))
              end
            end)
            button:SetCallback("OnLeave", function()
              button:GetUserData("cancelTooltip")()
              GameTooltip:Hide()
            end)
            break
          end
        end
      end
      local hasTinkerSocket = 0
      for _, line in ipairs(tooltipData.lines) do
        if line.leftText then
          local sign1, value1 = strmatch(line.leftText, "(.)(%d+) "..ITEM_MOD_MODIFIED_CRAFTING_STAT_1)
          if value1 then
            stat1Sign = sign1
            stat1Value = value1
          end
          local sign2, value2 = strmatch(line.leftText, "(.)(%d+) "..ITEM_MOD_MODIFIED_CRAFTING_STAT_2)
          if value2 then
            stat2Sign = sign2
            stat2Value = value2
          end
        end
        if line.type == 3 then
          tinsert(sockets, {
            type = line.leftText,
            icon = line.socketType
          }
          )
          if line.leftText == EMPTY_SOCKET_TINKER then
            hasTinkerSocket = 1
          end
        end
      end
      for i = #sockets + 1, self:GetMaxSoketsBySlot(raidTier, (select(4, C_Item.GetItemInfoInstant(itemId)))) + hasTinkerSocket do
        tinsert(sockets, {
          type = EMPTY_SOCKET_PRISMATIC,
          icon = "Prismatic"
        }
        )
      end
      if stat1Value then
        local items = {}
        if stat2Value then
          for i = 1, #statModifiers do
            for j = i + 1, #statModifiers do
              for k = 1, stat1Value == stat2Value and 1 or 2 do
                itemInfo = Item:CreateFromItemID(statsToItemTable[statModifiers[i]..statModifiers[j]])
                itemInfo.BestInSlot = {}
                if k ==1 then
                  itemInfo.BestInSlot.stats = {statModifiers[i], statModifiers[j]}
                  itemInfo.BestInSlot.statsHeader = ("%s / %s"):format(statText[statModifiers[i]], statText[statModifiers[j]])
                  itemInfo.BestInSlot.stat1 = ("%s%d %s"):format(stat1Sign, stat1Value, statText[statModifiers[i]])
                  itemInfo.BestInSlot.stat2 = ("%s%d %s"):format(stat2Sign, stat2Value, statText[statModifiers[j]])
                else
                  itemInfo.BestInSlot.stats = {statModifiers[j], statModifiers[i]}
                  itemInfo.BestInSlot.statsHeader = ("%s / %s"):format(statText[statModifiers[j]], statText[statModifiers[i]])
                  itemInfo.BestInSlot.stat1 = ("%s%d %s"):format(stat2Sign, stat2Value, statText[statModifiers[i]])
                  itemInfo.BestInSlot.stat2 = ("%s%d %s"):format(stat1Sign, stat1Value, statText[statModifiers[j]])
                end
                table.insert(items, itemInfo)
              end
            end
          end
        else
          for i = 1, #statModifiers do
            itemInfo = Item:CreateFromItemID(statsToItemTable[tostring(statModifiers[i])])
            itemInfo.BestInSlot = {}
            itemInfo.BestInSlot.statsHeader = statText[statModifiers[i]]
            itemInfo.BestInSlot.stat1 = ("%s%d %s"):format(stat1Sign, stat1Value, statText[statModifiers[i]])
            itemInfo.BestInSlot.stats = {statModifiers[i]}
            table.insert(items, itemInfo)
          end
        end
        local button = AceGUI:Create("Icon")
        local border = AceGUI:Create("Icon")
        border:SetImage("interface/framegeneral/uiframeiconborder", 0.0078125, 0.5078125, 0.0078125, 0.5078125)
        button:SetUserData("border", border)
        button:SetUserData("items", items)
        button:SetUserData("slot", slot)
        local atlasInfo = C_Texture.GetAtlasInfo("professions-slot-bg")
        button:SetUserData("defaultImage", {"interface\\professions\\professions", atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord})
        button:SetImage("interface\\professions\\professions", atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord)
        local current = Manager.db.char[raidTier][difficulty][list].modifications and Manager.db.char[raidTier][difficulty][list].modifications[slot] and Manager.db.char[raidTier][difficulty][list].modifications[slot].stats
        if current then
          button:SetImage(C_Item.GetItemIconByID(statsToItemTable[table.concat(current)]))
          button:SetUserData("stats", current)
        end
        button:SetCallback("OnClick", statsIconOnClick)
        button:SetCallback("OnEnter", function()
          local stats = button:GetUserData("stats")
          if stats then
            GameTooltip:SetOwner(button.frame, "ANCHOR_RIGHT")
            GameTooltip:AddLine(("%s %s %s"):format(statText[stats[1]], stats[2] and "/" or "", stats[2] and statText[stats[2]] or ""))
            GameTooltip:AddLine(" ")
            if stats[2] and stats[2] < stats[1] then
              GameTooltip:AddLine(("%s%d %s"):format(stat2Sign, stat2Value, statText[stats[2]]), 1, 1, 1)
            end
            GameTooltip:AddLine(("%s%d %s"):format(stat1Sign, stat1Value, statText[stats[1]]), 1, 1, 1)
            if stats[2] and stats[2] > stats[1] then
              GameTooltip:AddLine(("%s%d %s"):format(stat2Sign, stat2Value, statText[stats[2]]), 1, 1, 1)
            end
          GameTooltip:Show()
          end
        end)
        button:SetCallback("OnLeave", function()
          GameTooltip:Hide()
        end)
        tinsert(modifications, button)
      end

      local invType = C_Item.GetItemInventoryTypeByID(itemId)
      local enchantList = self:GetEnchants(raidTier, invType)
      local enchants = {}
      if enchantList then
        for spellId in pairs(enchantList) do
          if type(spellId) == "number" and not (C_TradeSkillUI.GetProfessionInfoByRecipeID(spellId).professionID == 960 and (UnitClassBase("player")) ~= "DEATHKNIGHT") then
            itemInfo = Item:CreateFromItemID(224708)
            itemInfo.BestInSlot = {}
            itemInfo.BestInSlot.icon = C_Spell.GetSpellTexture(spellId)
            itemInfo.BestInSlot.spellId = spellId
            table.insert(enchants, itemInfo)
          end
        end
        if #enchants > 0 then
          local button = AceGUI:Create("Icon")
          button:SetUserData("items", enchants)
          button:SetUserData("slot", slot)
          button:SetUserData("invType", invType)
          button:SetUserData("cancelTooltip", function() end)
          button:SetImage(C_Item.GetItemIconByID(172416))
          button:SetUserData("defaultImage", {C_Item.GetItemIconByID(172416)})
          local current = Manager.db.char[raidTier][difficulty][list].modifications and Manager.db.char[raidTier][difficulty][list].modifications[slot] and Manager.db.char[raidTier][difficulty][list].modifications[slot].enchant
          if current then
            button:SetImage(C_Spell.GetSpellTexture(current))
            button:SetUserData("enchant", current)
          end
          button:SetCallback("OnClick", enchantIconOnClick)
          button:SetCallback("OnEnter", function()
            local enchant = button:GetUserData("enchant")
            if enchant then
              itemInfo = nil
              if enchantList[tostring(enchant)] then
                itemInfo = Item:CreateFromItemID(enchantList[tostring(enchant)])
              end
              local spellInfo = Spell:CreateFromSpellID(enchant)
              button:SetUserData("cancelTooltip", spellInfo:ContinueWithCancelOnSpellLoad(function()
                local tooltipInfo = C_TooltipInfo.GetRecipeResultItem(enchant, nil,nil,nil,3)
                if itemInfo then
                  button:SetUserData("cancelTooltip", itemInfo:ContinueWithCancelOnItemLoad(function()
                    GameTooltip:SetOwner(button.frame, "ANCHOR_RIGHT")
                    GameTooltip:AddLine(itemInfo:GetItemName())
                    if #tooltipInfo.lines > 1 then
                      GameTooltip:AddLine(" ")
                      GameTooltip:AddLine(tooltipInfo.lines[#tooltipInfo.lines].leftText, 1, 1, 1, true)
                    end
                    GameTooltip:Show()
                  end))
                else
                  GameTooltip:SetOwner(button.frame, "ANCHOR_RIGHT")
                  GameTooltip:AddLine(C_Spell.GetSpellName(enchant))
                  if #tooltipInfo.lines > 1 then
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine(tooltipInfo.lines[#tooltipInfo.lines].leftText, 1, 1, 1, true)
                  end
                  GameTooltip:Show()
                end
              end))
            end
          end)
          button:SetCallback("OnLeave", function()
            button:GetUserData("cancelTooltip")()
            GameTooltip:Hide()
          end)
          tinsert(modifications, button)
        end
      end

      for i = 1, #sockets do
        if sockets[i] then
          local gems = {}
          for _, gem in ipairs(self:GetGems(raidTier, sockets[i].type)) do
            itemInfo = Item:CreateFromItemID(gem)
            itemInfo.BestInSlot = {}
            table.insert(gems, itemInfo)
          end
          local button = AceGUI:Create("Icon")
          button:SetUserData("slot", slot)
          button:SetUserData("index", i)
          button:SetUserData("items", gems)
          local current = Manager.db.char[raidTier][difficulty][list].modifications and Manager.db.char[raidTier][difficulty][list].modifications[slot] and Manager.db.char[raidTier][difficulty][list].modifications[slot]["gem"..i]
          local atlasInfo = C_Texture.GetAtlasInfo(("socket-%s-background"):format(GEM_TYPE_INFO[sockets[i].icon].textureKit))
          button:SetUserData("defaultImage", {"interface\\itemsocketingframe\\sockets", atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord})
          button:SetImage("interface\\itemsocketingframe\\sockets", atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord)
          if current then
            button:SetImage(C_Item.GetItemIconByID(current))
            button:SetUserData("gem", current)
          end
          button:SetCallback("OnClick", gemIconOnClick)
          button:SetCallback("OnEnter", function()
            local gem = button:GetUserData("gem")
            if gem then
              GameTooltip:SetOwner(button.frame, "ANCHOR_RIGHT")
              GameTooltip:SetItemByID(gem)
            end
          end)
          button:SetCallback("OnLeave", function()
            GameTooltip:Hide()
          end)
          tinsert(modifications, button)
        end
      end
    end
    return modifications
  end
  local modifications = generateModButtons()
  if not modifications then return end
  local numMods = #modifications
  for i = 1, #modifications do
    local button = modifications[i]
    local border = button:GetUserData("border")
    if border then
      impGroup:AddChild(border)
      border:SetImageSize(28,28)
      border:SetWidth(28)
      border:SetHeight(28)
      border:SetPoint("TOPLEFT", itemGroup:GetUserData("icon").frame, "BOTTOMLEFT", 5+42*(i-1), -1)
      border.frame:SetPropagateMouseClicks(true)
      border.frame:SetPropagateMouseMotion(true)
    end
    impGroup:AddChild(button)
    button:SetUserData("itemGroup", itemGroups[itemSelectionMode[1]])
    button.frame:RegisterForClicks("AnyDown")
    button:SetImageSize(28,28)
    button:SetWidth(28)
    button:SetHeight(28)
    button:SetPoint("TOPLEFT", itemGroup:GetUserData("icon").frame, "BOTTOMLEFT", 5+42*(i-1), -2)
  end
  if itemSelectionMode[2] then
    slot = itemGroups[itemSelectionMode[2]]:GetUserData("slotid")
    itemId = Manager.db.char[raidTier][difficulty][list][slot]
    modifications = generateModButtons()
    if not modifications then return end
    numMods = numMods + #modifications
    for i = 1, #modifications do
      local button = modifications[i]
      border = button:GetUserData("border")
      if border then
        impGroup:AddChild(border)
        border:SetImageSize(28,28)
        border:SetWidth(28)
        border:SetHeight(28)
        border:SetPoint("TOPLEFT", itemGroups[itemSelectionMode[2]]:GetUserData("icon").frame, "BOTTOMLEFT", 5+42*(i-1), -1)
        border.frame:SetPropagateMouseClicks(true)
        border.frame:SetPropagateMouseMotion(true)
      end
      impGroup:AddChild(button)
      button:SetUserData("itemGroup", itemGroups[itemSelectionMode[2]])
      button.frame:RegisterForClicks("AnyDown")
      button:SetImageSize(28,28)
      button:SetWidth(28)
      button:SetHeight(28)
      button:SetPoint("TOPLEFT", itemGroups[itemSelectionMode[2]]:GetUserData("icon").frame, "BOTTOMLEFT", 5+42*(i-1), -2)
    end
  end
  if numMods > 0 then
    impGroup:SetHeight(32)
  end

  --legion artifact relic
  local relic = itemGroup:GetUserData("relic")
  if relic then
    ---@diagnostic disable-next-line: undefined-field
    header:SetText((L["%1$s from raid tier: %2$s"]):format(_G.RELIC_TOOLTIP_TYPE:format(_G["RELIC_SLOT_TYPE_" ..relic]), self:GetDescription(self.RAIDTIER, raidTier)))
  else
    header:SetText((L["%1$s from raid tier: %2$s"]):format(_G[slotData], self:GetDescription(self.RAIDTIER, raidTier)))
  end
  selectContainer:AddChild(header)

  ---@diagnostic disable-next-line: need-check-nil
  if itemSelectionMode[2] then
    local helpText = AceGUI:Create("Label")
    helpText:SetText(self.colorNormal..L["Use left-click to (de)select the left one, and right-click to select the right one"].."|r")
    helpText:SetFullWidth(true)
    selectContainer:AddChild(helpText)
  end

  local scroll = AceGUI:Create("ScrollFrame")
  local simpleGroup = AceGUI:Create("SimpleGroup")
  simpleGroup:SetFullWidth(true)
  simpleGroup:AddChild(scroll)
  simpleGroup:SetHeight(330)
  simpleGroup:SetLayout("Fill")
  selectContainer:AddChild(simpleGroup)
  local lootOrder
  if relic then
    lootOrder = self.Artifacts:GetRelicsForRaidTier(relic, raidTier, difficulty, lowerRaidTiers)
  else
    if showAllItems then
      lootOrder = self:GetLootOrder(self:GetLootTableBySlot(raidTier, slotid, difficulty, lowerRaidTiers))
    else
      --local list, spec = self:GetSelected(self.SPECIALIZATION)
      local personalizedLootTable, reload = self:GetPersonalizedLootTableBySlot(raidTier, slotid, difficulty, spec, lowerRaidTiers)
      if reload then
        reload:ContinueOnItemLoad(function() Manager:FillSelectContainer(itemGroup, raidTier, difficulty, slotid) end)
        return
      end
      lootOrder = self:GetLootOrder(personalizedLootTable)
    end
  end
  local deselectIcon = AceGUI:Create("InteractiveLabel")
  deselectIcon:SetImage("Interface\\Buttons\\UI-GroupLoot-Pass-Up.blp")
  deselectIcon:SetText(L["Deselect item"])
  deselectIcon:SetCallback("OnClick", selectItemLabelOnClick)
  deselectIcon:SetFullWidth(true)
  deselectIcon:SetImageSize(30,30)
  deselectIcon:SetHighlight(itemhighlight)
  deselectIcon:SetFont(GameFontNormalSmall:GetFont(), 14, "OUTLINE")
  scroll:AddChild(deselectIcon)
  local itemInfo
  for i = 1, #lootOrder do
    local isCached = C_Item.IsItemDataCachedByID(lootOrder[i])
    if not isCached then
      itemInfo = Item:CreateFromItemID(lootOrder[i])
    end
  end
  if itemInfo then
    itemInfo:ContinueOnItemLoad(function() Manager:FillSelectContainer(itemGroup, raidTier, difficulty, slotid) end)
    return
  end
  local firstItem
  for i = 1, #lootOrder do
    local id = lootOrder[i]
    local texture = GetItemIcon(id)
    local label = self:GetItemLinkLabel(id, difficulty)
    local itemRaidTier
    if lowerRaidTiers then
      local item = BestInSlot:GetItem(id)
      itemRaidTier = self:GetRaidTiers(self.INSTANCE, item.dungeon)
      if itemRaidTier ~= raidTier then
        label:SetText(label:GetUserData("itemlink")..(" - (%s)"):format(self:GetDescription(self.RAIDTIER, itemRaidTier)))
      end
    end

    local itemInstances = self:GetInstances(self.RAIDTIER, itemRaidTier or raidTier)
    if #itemInstances > 1 then
      local itemSources, isCatalyst = self:GetItemSources(id)
      local instance
      local numInstances = 0
      for _, instanceId in pairs(itemInstances) do
        if itemSources[instanceId] then
          numInstances = numInstances + 1
          instance = instanceId
        end
      end
      if numInstances < #itemInstances then
        label:SetText(RETRIEVING_ITEM_INFO..(" - (%s)"):format(isCatalyst and L["Catalyst"] or self:GetDescription(self.INSTANCE, instance)))
        itemInfo = Item:CreateFromItemID(label:GetUserData("itemid"))
        itemInfo:ContinueOnItemLoad(function()
          label:SetText(label:GetUserData("itemlink")..(" - (%s)"):format(isCatalyst and L["Catalyst"] or self:GetDescription(self.INSTANCE, instance)))
        end)
      end
    end
    label:SetFullWidth(true)
    label:SetHighlight(itemhighlight)
    label:SetImageSize(30,30)
    local callbacks = label:GetUserData("callbacks")
    callbacks.OnClick = {selectItemLabelOnClick}
    callbacks.OnEnter = {selectItemLabelOnEnter}
    label:SetFont(GameFontNormalSmall:GetFont(), 14, "OUTLINE")
    firstItem = firstItem or label
    scroll:AddChild(label)
  end
  if not relic then
    local showAllLabel = AceGUI:Create("InteractiveLabel")
    showAllLabel:SetHighlight(itemhighlight)
    showAllLabel:SetFullWidth(true)
    showAllLabel:SetImageSize(30,30)
    showAllLabel:SetFont(GameFontNormalSmall:GetFont(), 14, "OUTLINE")
    showAllLabel:SetImage(showAllItems and "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up" or "Interface\\PaperDollInfoFrame\\Character-Plus")
    showAllLabel:SetText(showAllItems and L["Only show items for specialization"] or L["Show all items"])
    showAllLabel:SetCallback("OnClick", function() showAllItems = not showAllItems Manager:FillSelectContainer(itemGroup, raidTier, difficulty, slotid) end)
    scroll:AddChild(showAllLabel)
    local customItemLabel = AceGUI:Create("InteractiveLabel")
    customItemLabel:SetHighlight(itemhighlight)
    customItemLabel:SetFullWidth(true)
    customItemLabel:SetImageSize(30,30)
    customItemLabel:SetImage("Interface\\PaperDollInfoFrame\\Character-Plus")
    customItemLabel:SetFont(GameFontNormalSmall:GetFont(), 14, "OUTLINE")
    customItemLabel:SetText(L["Add a custom item"])
    customItemLabel:SetCallback("OnClick", function() Manager:SetMenu(3, Manager:GetSelected(Manager.INSTANCE)) end)
    scroll:AddChild(customItemLabel)
  end
  ---@diagnostic disable-next-line: need-check-nil
  if itemSelectionMode[2] then
    self.frame:GetUserData("content"):SetUserData("selectedItem", deselectIcon)
    self:ShowTutorial(frameName, 5)
  end
  if #self:GetRaidTiers(self.RAIDTIER, raidTier) > 0 then --if we have lower raid ters then our own
    local lowerRaidTierLabel = AceGUI:Create("InteractiveLabel")
    lowerRaidTierLabel:SetHighlight(itemhighlight)
    lowerRaidTierLabel:SetFullWidth(true)
    lowerRaidTierLabel:SetImageSize(30,30)
    lowerRaidTierLabel:SetFont(GameFontNormalSmall:GetFont(), 14, "OUTLINE")
    lowerRaidTierLabel:SetImage(lowerRaidTiers and "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up" or "Interface\\PaperDollInfoFrame\\Character-Plus")
    lowerRaidTierLabel:SetText(lowerRaidTiers and L["Only show this raid tier"] or L["Add lower raid tiers"])
    lowerRaidTierLabel:SetCallback("OnClick", function() lowerRaidTiers = not lowerRaidTiers Manager:FillSelectContainer(itemGroup, raidTier, difficulty, slotid) end)
    scroll:AddChild(lowerRaidTierLabel)
  end
end

function Manager:HideItemList(callback, ...)
  local raidtier = self:GetSelected(self.RAIDTIER)
  for i=1,#itemSelectionMode do
    ---@diagnostic disable-next-line: need-check-nil
    local itemGroup = itemGroups[itemSelectionMode[i]]
    local button = itemGroup:GetUserData("button")
    button:SetText(L["Select an item"])
    local selectContainer = slotContainer:GetUserData("selectContainer")
    selectContainer:ClearAllPoints()
    selectContainer:ReleaseChildren()
    if not self.options.instantAnimation then
      local index = itemGroup:GetUserData("index")
      local targetX = 150
      local targetY = -((ceil(index/2) - 1) * 45)
      local currentX = 0
      local currentY = 0
      ---@diagnostic disable-next-line: need-check-nil
      if itemSelectionMode[2] then
        if i == 1 then
          currentX = -150
        else
          currentX = 150
        end
      end
      if index % 2 == 1 then --right
        targetX = -targetX
      end
      local timer
      button:SetDisabled(true)
      local funcArgs = {...}
      timer = self:ScheduleRepeatingTimer(function()
          local speedX = 8
          local speedY = abs(targetY / targetX * speedX)
          currentY = max(currentY - speedY, targetY)
          if targetX > 0 then
            currentX = min(currentX + speedX, targetX)
          else
            currentX = max(currentX - speedX, targetX)
          end
          itemGroup:SetPoint("TOP", slotContainer.frame, "TOP", currentX, currentY)
          if currentY == targetY and currentX == targetX then
            self:CancelTimer(timer)
            slotContainer:ResumeLayout()
            slotContainer:DoLayout()
            if BestInSlot.Artifacts then
              if raidtier >= 70000 and raidtier < 800000 then
                for i=1,#legionRelicGroups do
                  legionRelicGroups[i].frame:Show()
                end
              else
                for i=1,#legionRelicGroups do
                  legionRelicGroups[i].frame:Hide()
                end
              end
            end
            button:SetDisabled(false)
            itemSelectionMode = false
            if callback and type(callback) == "function" and i == 1 then
              callback(unpack(funcArgs))
            end
          end
      end,
      0.0166)
    end
  end
  itemSelectionMode = false
  if self.options.instantAnimation then
    slotContainer:ResumeLayout()
    slotContainer:DoLayout()
    if self.Artifacts then
      if raidtier >= 70000 and raidtier < 800000 then
        for i=1,#legionRelicGroups do
          legionRelicGroups[i].frame:Show()
        end
      else
        for i=1,#legionRelicGroups do
          legionRelicGroups[i].frame:Hide()
        end
      end
    end
    if callback and type(callback) == "function" then
      callback(...)
    end
  end
end

function Manager:ShowItemList(widget)
  if itemSelectionMode then
    self:HideItemList()
  else
    local data = widget:GetUserDataTable() --{raidTier = 50400, difficulty = 1, slotid = 1}
    data.difficulty = data.difficulty or self:GetSelected(Manager.DIFFICULTY)
    data.raidTier = data.raidTier or self:GetSelected(Manager.RAIDTIER)
    if not data.difficulty or not data.raidTier or widget:GetUserData("disabled") then return end
    local dualSelect = nil
    if data.slotid == 11 or data.slotid == 12 then --Ring
      dualSelect = {11,12}
      ---@diagnostic disable-next-line: cast-local-type
      itemSelectionMode = {11,12}
    elseif data.slotid == 13 or data.slotid == 14 then --Trinket
      dualSelect = {13,14}
      ---@diagnostic disable-next-line: cast-local-type
      itemSelectionMode = {13,14}
    end
    for i=1,#itemGroups do
      local button = itemGroups[i]:GetUserData("button")
      local buttonSlot = button:GetUserData("slotid")
      if buttonSlot == data.slotid or (dualSelect and (dualSelect[1] == buttonSlot or dualSelect[2] == buttonSlot)) then
        button:SetText(DONE)
        if dualSelect then
          if buttonSlot == dualSelect[1] then
            self:DoMoveAnimation(itemGroups[i], "LEFT", "FillSelectContainer", itemGroups[i], data.raidTier, data.difficulty, data.slotid)
          else
            self:DoMoveAnimation(itemGroups[i], "RIGHT")
          end
        else
          ---@diagnostic disable-next-line: cast-local-type
          itemSelectionMode = {i}
          self:DoMoveAnimation(itemGroups[i], nil, "FillSelectContainer", itemGroups[i], data.raidTier, data.difficulty, data.slotid)
        end
      else
        itemGroups[i].frame:Hide()
      end
    end
  end
end

local function iconOnEnter(icon)
  local itemid = icon:GetUserData("itemid")
  local itemLink = icon:GetUserData("itemlink")
  if itemid and itemLink then
    Manager:GetItemTooltip(itemid, Manager:GetSelected(Manager.DIFFICULTY), Manager.frame, itemLink)
  end
end

local function iconOnLeave() Manager:HideItemTooltip()  end

local function iconOnClick(widget, _, button)
  local itemid = widget:GetUserData("itemid")
  local shift, ctrl = IsShiftKeyDown(), IsControlKeyDown()
  local item = Manager:GetItem(itemid, Manager:GetSelected(Manager.DIFFICULTY))
  if shift then
    local link = (item and item.link) or widget:GetUserData("itemlink")
    if not ChatEdit_InsertLink(link) then
      ChatFrame_OpenChat(link)
    end
  elseif ctrl then
    local link = (item and item.link) or widget:GetUserData("itemlink")
    if link then
      DressUpItemLink(link)
    end
  elseif not shift and not ctrl then
    if button == "LeftButton" then
      Manager:ShowItemList(widget)
        end
      end
    end


local function selectItemButtonOnClick(widget)
  Manager:ShowItemList(widget)
end

function Manager:SetLegionRelics(enabled, container, specialization, bis)
  if enabled then
    local relics = self.Artifacts:GetRelicsForSpecialization(specialization)
    local texture = self.Artifacts:GetTexture()
    for i=1,#legionRelicGroups do
      local group = legionRelicGroups[i]
      group.frame:Show()
      group:SetUserData("relic", relics[i])
      local icon = group:GetUserData("icon")
      local label = group:GetUserData("label")
      local normalCoords, highLightcoords = self.Artifacts:GetTextureCoordinatesForRelic(relics[i])
      local bisRelic = bis[29 + i]
      if not bisRelic or not bisRelic.item then
        icon:SetImage(texture, unpack(normalCoords))
      else
        local relic = self:GetItem(bisRelic.item)
        icon:SetImage(GetItemIcon(relic.itemid))
        icon:SetUserData("itemid", relic.itemid)
        label:SetText(relic.link)
      end
      group:SetUserData("defaultTexture", {texture, unpack(normalCoords)})
    end
  else
    for i=1,#legionRelicGroups do
      legionRelicGroups[i].frame:Hide()
      legionRelicGroups[i]:SetUserData("relic", nil)
    end
  end
end

function Manager:PopulateSlots(slotContainer)
  local container = slotContainer
  local isTwoHander = false
  local raidTier = self:GetSelected(self.RAIDTIER)
  local difficulty = self:GetSelected(self.DIFFICULTY)
  local list, specialization = self:GetSelected(self.SPECIALIZATION)
  local BiSList = self:GetOrderedBestInSlotItems(raidTier, difficulty, list)
  for i=1,#itemGroups do
    local itemGroup = itemGroups[i]
    local slotId = itemGroup:GetUserData("slotid")
    local icon = itemGroup:GetUserData("icon")
    local button = itemGroup:GetUserData("button")
    local label = itemGroup:GetUserData("label")
    local modTable = self:GetModificationTable(raidTier, difficulty, list, slotId)
    local itemid = BiSList[slotId] and BiSList[slotId].item
    local isLegionWeapon = false
    -- Fix by dioxina
    if slotId == 15 and (self:GetSelected(self.RAIDTIER) >= 80200 and self:GetSelected(self.RAIDTIER) < 90000) then
      --Legendary cloak
      icon:SetUserData("disabled", true)
      button:SetDisabled(true)
      CloakItemId = 169223
      local _, link, _, _, _, _, _, _, _, texture = GetItemInfo(CloakItemId)
      icon:SetImage(texture)
      icon:SetUserData("itemid", CloakItemId)
      icon:SetUserData("itemlink", link)
      label:SetText(link)
      isLegionWeapon = true
    elseif slotId == 2 and (self:GetSelected(self.RAIDTIER) >= 80000 and self:GetSelected(self.RAIDTIER) < 90000) then
      --Artifact neck
      icon:SetUserData("disabled", true)
      button:SetDisabled(true)
      NeckItemId = 158075
      local _, link, _, _, _, _, _, _, _, texture = GetItemInfo(NeckItemId)
      icon:SetImage(texture)
      icon:SetUserData("itemid", NeckItemId)
      icon:SetUserData("itemlink", link)
      label:SetText(link)
      isLegionWeapon = true
    elseif (slotId == 16 or slotId == 17) and (self:GetSelected(self.RAIDTIER) >= 70000 and self:GetSelected(self.RAIDTIER) < 80000) then
      --Artifact weapons
      icon:SetUserData("disabled", true)
      button:SetDisabled(true)
      local artifactInfo = select(slotId == 16 and 1 or 2, self.Artifacts:ForSpecialization(specialization))
      if artifactInfo then
        icon:SetImage(artifactInfo.texture)
        icon:SetUserData("itemid", artifactInfo.id)
        icon:SetUserData("itemlink", artifactInfo.link)
        label:SetText(artifactInfo.link)
        isLegionWeapon = true
      end
    --Code for disabling the off-hand slot in Two-handed cases
    elseif slotId == 17 and isTwoHander and select(2, self:GetSelected(self.SPECIALIZATION)) ~= 72 then --72 is a fury warrior
      local selected = self:GetSelected()
      self:SetItemBestInSlot( selected.raidtier, selected.difficulty, selected.specialization, slotId, nil)
      icon:SetUserData("itemid", nil)
      icon:SetUserData("disabled", true)

      button:SetDisabled(true)

      itemid = nil
    else
      icon:SetUserData("disabled", false)

      button:SetDisabled(false)
    end
    if type(itemid) == "number" and self:GetItem(itemid) then --Has a valid itemid value in the database
      --local modTable = Manager.db.char[raidTier][difficulty][list].modifications and Manager.db.char[raidTier][difficulty][list].modifications[slotId]
      local item, itemInfo = self:GetItem(itemid, difficulty, modTable)
      if slotId == 16 then
        local subclass, equipSlot = select(3, C_Item.GetItemInfoInstant(itemid))
        if equipSlot == "INVTYPE_2HWEAPON" or equipSlot == "INVTYPE_RANGED" or (equipSlot == "INVTYPE_RANGEDRIGHT" and subclass ~= BabbleInventory.Wands) then
          isTwoHander = true
        end
      end
      icon:SetImage(GetItemIcon(itemid))
      icon:SetUserData("itemid", itemid)
      itemInfo:ContinueOnItemLoad(function()
        label:SetText(item.link)
        icon:SetUserData("itemlink", item.link)
      end)

      button:SetDisabled(false)
    elseif not isLegionWeapon then
      icon:SetImage(unpack(itemGroup:GetUserData("defaultTexture")))
      icon:SetUserData("itemid", nil)
      label:SetText("")
    end
    icon:SetUserData("raidTier",  self:GetSelected(self.RAIDTIER))
    icon:SetUserData("difficulty", self:GetSelected(self.DIFFICULTY))
    button:SetUserData("raidTier",  self:GetSelected(self.RAIDTIER))
    button:SetUserData("difficulty", self:GetSelected(self.DIFFICULTY))
  end

  self:SetLegionRelics(raidTier >= 70000 and raidTier < 80000, container, specialization, BiSList)
end


function Manager:GetItemSelectionGroup(slotId, textureName, bisIndex)
  local itemGroup = AceGUI:Create("SimpleGroup")
  itemGroup:SetHeight(45)
  itemGroup:PauseLayout()

  local icon = AceGUI:Create("Icon")
  icon:SetImage(textureName)
  icon:SetImageSize(40,40)
  icon:SetWidth(40)
  icon:SetHeight(45)
  icon:SetPoint("TOPLEFT", itemGroup.frame, "TOPLEFT")
  icon.frame:RegisterForClicks("AnyDown")
  icon:SetCallback("OnEnter", iconOnEnter)
  icon:SetCallback("OnLeave", iconOnLeave)
  icon:SetCallback("OnClick", iconOnClick)
  icon:SetUserData("slotid", slotId)
  icon:SetUserData("group", itemGroup)
  itemGroup:AddChild(icon)

  local label = AceGUI:Create("Label")
  label:SetHeight(20)
  label:SetPoint("TOPLEFT", icon.frame, "TOPRIGHT", 0, -5)
  itemGroup:AddChild(label)

  local button = AceGUI:Create("Button")
  button:SetText(L["Select an item"])
  button:SetCallback("OnClick", selectItemButtonOnClick)
  button:SetHeight(25)
  button:SetPoint("BOTTOMLEFT", icon.frame, "BOTTOMRIGHT")
  button:SetUserData("slotid", slotId)
  itemGroup:AddChild(button)

  itemGroup:SetUserData("defaultTexture", {textureName})
  itemGroup:SetUserData("slotid", slotId)
  itemGroup:SetUserData("index", bisIndex)
  itemGroup:SetUserData("icon", icon)
  itemGroup:SetUserData("label",label)
  itemGroup:SetUserData("button", button)
  itemGroup:SetRelativeWidth(0.48)
  return itemGroup
end

function Manager:GetSlotContainer(raidTier, difficulty)
  local container = AceGUI:Create("SimpleGroup")
  itemGroups = {}
  container:SetFullWidth(true)
  container:SetHeight(0)
  container:SetLayout("Flow")
  for i=1,#self.slots do
    local slotId, textureName = GetInventorySlotInfo(self.slots[i])
    local itemGroup = self:GetItemSelectionGroup(slotId, textureName, i)
    container:AddChild(itemGroup)
    tinsert(itemGroups, itemGroup)
  end
  if self.Artifacts then
    local texture = self.Artifacts:GetTexture()
    for i=1,3 do
      local itemGroup = self:GetItemSelectionGroup(29 + i, texture, 16 + i) --30, 31, 32 slotIndex & 17, 18, 19 BiS
      legionRelicGroups[i] = itemGroup
      tinsert(itemGroups, itemGroup)
      container:AddChild(itemGroup)
    end
    --add a dummy group for the AceGUI flow layout to properly line out all the bottom
    container:AddChild(self:QuickCreate("SimpleGroup", {SetRelativeWidth = 0.49, SetHeight = 45, PauseLayout = true}))
  end
  local selectContainer = AceGUI:Create("SimpleGroup")
  selectContainer:SetFullWidth()
  selectContainer:SetHeight(1)
  container:AddChild(selectContainer)
  container:SetUserData("selectContainer", selectContainer)
  return container
end

local function dropdownRaidtierOnValueChanged(_,_,value)
  if itemSelectionMode then
    Manager:HideItemList(dropdownRaidtierOnValueChanged, _, _, value)
    return
  end
  Manager:SetImportDropdownData(dropdownImport)
  Manager:PopulateSlots(slotContainer)
end

local function dropdownDifficultyOnValueChanged(dropdown,_,value)
  if itemSelectionMode then
    Manager:HideItemList(dropdownDifficultyOnValueChanged, _,_,value)
    return
  end
  Manager:SetImportDropdownData(dropdownImport)
  Manager:PopulateSlots(slotContainer)
  Manager:ShowTutorial(frameName, 4)
end

local function dropdownSpecializationOnValueChanged(_,_,value)
  if itemSelectionMode then
    Manager:HideItemList(dropdownSpecializationOnValueChanged, _,_,value)
    return
  end
  Manager:PopulateSlots(slotContainer)
end

local function dropdownImport_OnValueChanged(_,_,value)
  local popup
  if tonumber(value) then
    popup = StaticPopup_Show("BESTINSLOT_CONFIRMIMPORT", Manager:GetDescription(Manager.DIFFICULTY, Manager:GetSelected(Manager.RAIDTIER), value))
  else
    popup = StaticPopup_Show("BESTINSLOT_CONFIRMCHARIMPORT", value)
  end
  popup:SetFrameStrata("TOOLTIP")
end

function Manager:SetImportDropdownData(dropdown)
  local selectedDifficulty = self:GetSelected(self.DIFFICULTY)
  local selectedRaidTier = self:GetSelected(self.RAIDTIER)
  local selectedSpecialization = self:GetSelected(self.SPECIALIZATION)
  local list = self:GetDifficulties(self.RAIDTIER, selectedRaidTier)
  dropdown:SetList({})
  for i = 1, #list do
    dropdown:AddItem(i, list[i])
    if string.find(list[i], "|cFFFFFFFF$") then
      dropdown:SetItemDisabled(i, true)
    end
  end
  --dropdownImport:SetList(list)
  dropdown:SetValue(nil)
  dropdown:SetItemDisabled(selectedDifficulty, true)
  dropdown:SetDisabled(self:GetSelected(self.RAIDTIER) < 59999 or #dropdown.list < 2)
  dropdown:AddItem("spacer", "")
  dropdown:SetItemDisabled("spacer", true)
  local firstChar = true
  local thisChar = self.db:GetCurrentProfile()
  for id, profile in pairs(self.db:GetProfiles()) do
    local charDb = BestInSlotDB.char[profile]
    if charDb and profile ~= thisChar and charDb[selectedRaidTier] and charDb[selectedRaidTier][selectedDifficulty] and charDb[selectedRaidTier][selectedDifficulty][selectedSpecialization] then
      if firstChar then
        firstChar = false
      end
      dropdown:AddItem(profile, profile)
    end
  end
  if firstChar then
    dropdown:AddItem("no_alt", L["No other characters to import"])
    dropdown:SetItemDisabled("no_alt", true)
  end
end

-- Adapted from https://github.com/philanc/plc/blob/master/plc/checksum.lua
local function adler32(s)
  -- return adler32 checksum  (uint32)
  -- adler32 is a checksum defined by Mark Adler for zlib
  -- (based on the Fletcher checksum used in ITU X.224)
  -- implementation based on RFC 1950 (zlib format spec), 1996
  local prime = 65521 --largest prime smaller than 2^16
  local s1, s2 = 1, 0

  -- limit s size to ensure that modulo prime can be done only at end
  -- 2^40 is too large for WoW Lua so limit to 2^30
  if #s > (bit.lshift(1, 30)) then error("adler32: string too large") end

  for i = 1,#s do
    local b = string.byte(s, i)
    s1 = s1 + b
    s2 = s2 + s1
    -- no need to test or compute mod prime every turn.
  end

  s1 = s1 % prime
  s2 = s2 % prime

  return (bit.lshift(s2, 16)) + s1
end --adler32()

local function simcExport()
  local raidTier = Manager:GetSelected(Manager.RAIDTIER)
  local difficulty = Manager:GetSelected(Manager.DIFFICULTY)
  local list = Manager:GetSelected(Manager.SPECIALIZATION)
  local itemList = {}
  for i = 1, #itemGroups do
    local itemId = Manager.db.char[raidTier][difficulty][list][itemGroups[i]:GetUserData("slotid")]
    local modTable = Manager.db.char[raidTier][difficulty][list].modifications[itemGroups[i]:GetUserData("slotid")]
    if itemId then
      local itemTable, itemInfo = Manager:GetItem(itemId, difficulty, modTable)
      if not itemInfo:IsItemDataCached() then
        itemInfo:ContinueOnItemLoad(simcExport)
        return
      end
      tinsert(itemList, itemTable.link)
    end
  end
  local simc = LibStub("AceAddon-3.0"):GetAddon("Simulationcraft")
  local simulationcraftProfile, simcPrintError = simc:GetSimcProfile(false, false, false, itemList)
  if not simcPrintError then
    local doubleSlot = {
      finger1 = 0,
      trinket1 = 0,
      main_hand = 0
    }
    local simcData = {("\n"):split(simulationcraftProfile)}
    local currentSection = ""
    simcData[#simcData] = nil
    for i = 1, #simcData do
      if currentSection == "" and string.match(simcData[i], "%b()") and not string.match(simcData[i], "^# Saved Loadout") then
        currentSection = "### Equipped"
      elseif simcData[i]:sub(1,3) == "###" then
        currentSection = simcData[i]
      elseif currentSection == "### Equipped"then
        if string.match(simcData[i], "^([^=]*)=") then
          simcData[i] = "# "..simcData[i]
        end
      elseif currentSection == "### Linked gear" then
        local match = string.match(simcData[i], "^#%s([^=]*)=")
        if match then
          simcData[i] = string.sub(simcData[i], 3, #simcData[i])
          if doubleSlot[match] then
            if doubleSlot[match] == 0 then
              doubleSlot[match] = 1
            else
              simcData[i] = string.gsub(simcData[i], "^([^=]*)%d","%12")
              simcData[i] = string.gsub(simcData[i], "^main_hand","off_hand")
            end
          end
        end
      end
    end

    simulationcraftProfile = table.concat(simcData, "\n").."\n"

    local checksum = adler32(simulationcraftProfile)

    simulationcraftProfile = simulationcraftProfile .. string.format('# Checksum: %x', checksum)
  end
  local f = simc:GetMainFrame(simcPrintError or simulationcraftProfile)
  f:Show()
end

function Manager:Draw(container)
  container:PauseLayout()

  dropdownRaidtier = self:GetDropdown(self.RAIDTIER, nil, dropdownRaidtierOnValueChanged)
  dropdownRaidtier:SetPoint("TOPLEFT", container.frame, "TOPLEFT", 10, -10)
  container:AddChild(dropdownRaidtier)

  dropdownDifficulty = self:GetDropdown(self.DIFFICULTY, nil, dropdownDifficultyOnValueChanged)
  dropdownDifficulty:SetPoint("TOPLEFT", dropdownRaidtier.frame, "TOPRIGHT")
  container:AddChild(dropdownDifficulty)

  container:SetUserData("difficulty", dropdownDifficulty)

  dropdownSpecialization = self:GetDropdown(self.SPECIALIZATION, nil, dropdownSpecializationOnValueChanged)
  dropdownSpecialization:SetPoint("TOPLEFT", dropdownDifficulty.frame, "TOPRIGHT")
  container:AddChild(dropdownSpecialization)

  slotContainer = self:GetSlotContainer(self:GetSelected(self.RAIDTIER),1)
  slotContainer:SetPoint("TOPLEFT", dropdownRaidtier.frame, "BOTTOMLEFT")
  slotContainer:SetWidth(600)
  slotContainer:SetPoint("BOTTOMLEFT", container.frame, "BOTTOMLEFT", 0, 40)
  container:AddChild(slotContainer)

  local button = AceGUI:Create("Button")
  button:SetText(L["SimulationCraft export"])
  button:SetHeight(25)
  button:SetPoint("BOTTOMLEFT", container.frame, "BOTTOMLEFT")
  local _, loaded = C_AddOns.IsAddOnLoaded("SimulationCraft")
  button:SetCallback("OnEnter", function()
    if loaded then
      if select(2, Manager:GetSelected(Manager.SPECIALIZATION)) ~= PlayerUtil.GetCurrentSpecID() then
        GameTooltip:SetOwner(Manager.frame.frame, "ANCHOR_NONE")
        GameTooltip:SetPoint("TOPLEFT", Manager.frame.frame, "TOPRIGHT", 10, 0)
        GameTooltip:SetText(RED_FONT_COLOR_CODE..SPELL_FAILED_CUSTOM_ERROR_286, 1, .82, 0, true)

        GameTooltip:Show()
      end
    else
		  GameTooltip:SetOwner(Manager.frame.frame, "ANCHOR_NONE")
      GameTooltip:SetPoint("TOPLEFT", Manager.frame.frame, "TOPRIGHT", 10, 0)
		  GameTooltip:SetText(RED_FONT_COLOR_CODE..L["SimulationCraft AddOn required"], 1, .82, 0, true)

		  GameTooltip:Show()
    end
  end)
  button:SetCallback("OnLeave", function()
    GameTooltip:Hide()
  end)
  button:SetCallback("OnClick", function()
    if loaded and select(2, Manager:GetSelected(Manager.SPECIALIZATION)) == PlayerUtil.GetCurrentSpecID() then
      simcExport()
    end
  end)

  container:AddChild(button)

  dropdownImport = AceGUI:Create("Dropdown")
  dropdownImport:SetList(dropdownDifficulty.list)
  dropdownImport:SetLabel(L["Import from other difficulty/character"])
  dropdownImport:SetPoint("BOTTOMRIGHT", container.frame, "BOTTOMRIGHT", -78, 0)
  dropdownImport:SetCallback("OnValueChanged", dropdownImport_OnValueChanged)

  self:SetImportDropdownData(dropdownImport)

  container:AddChild(dropdownImport)
  container:SetUserData("importButton", dropdownImport)

  self:PopulateSlots(slotContainer)
  slotContainer:DoLayout()
end

function Manager:Close()
  self:HideItemTooltip()
  dropdownRaidtier = nil
  dropdownDifficulty = nil
  dropdownSpecialization = nil
  slotContainer = nil
  itemSelectionMode = false
  itemGroups = {}
end

function Manager:DoImport()
  local importDifficulty = dropdownImport:GetValue()
  local raidTier = self:GetSelected(self.RAIDTIER)
  local difficulty = self:GetSelected(self.DIFFICULTY)
  local list, specialization = self:GetSelected(self.SPECIALIZATION)
  local importList, slotInfo = self:GetBestInSlotItems(raidTier, importDifficulty, list)
  for i, itemInfo in pairs(importList) do
    self:SetItemBestInSlot(raidTier, difficulty, list, slotInfo[i], itemInfo.item)
  end
  self:PopulateSlots(slotContainer)
end

function Manager:DoCopyChar()
    local selectedChar = dropdownImport:GetValue()
    local selectedInfo = Manager:GetSelected()
    local otherCharList = BestInSlotDB.char[selectedChar][selectedInfo.raidtier][selectedInfo.difficulty][selectedInfo.specialization]
    for i, iteminfo in pairs(otherCharList) do
      self:Print(i .. ": "..iteminfo)
      self:SetItemBestInSlot(selectedInfo.raidtier, selectedInfo.difficulty, selectedInfo.specialization, i, iteminfo)
    end
    --if charDb and profile ~= thisChar and charDb[selectedRaidTier] and charDb[selectedRaidTier][selectedDifficulty] and charDb[selectedRaidTier][selectedDifficulty][selectedSpecialization] then
    self:PopulateSlots(slotContainer)
end

Manager:RegisterTutorials(frameName,{
  [1] = {text = L["In this menu you can select different parts of the AddOn. The selected menu is displayed in white."], xOffset = 0, yOffset = 350, container = "menu", UpArrow = true},
  [2] = {text = L["On most pages you can set your instance, difficulty and specialization in the top of the page. These settings are saved across all pages."], xOffset = 0, yOffset = -20, UpArrow = true, container = "content", element="difficulty"},
  [3] = {text = (L["On this page you can set your BestInSlot list. You can use the '%s' buttons to select your item for that slot"]):format(L["Select an item"]), text2 = L["You can right-click icons to quickly remove them from your list."], xOffset = 0, yOffset = -50, container = "content"},
  [4] = {text = L["When you've set a difficulty before, you can easily import a previously set list."], onRequest = true, xOffset = 0, yOffset = 0, container="content", element="importButton", DownArrow = true},
  [5] = {text = L["When selecting rings or trinkets, you can see both items at once."], text2 = L["Use left-click to (de)select the left one, and right-click to select the right one"], xOffset = -200, yOffset = -50, container = "content", element = "selectedItem", onRequest = true, UpArrow = true},
})

local function cancel()
 dropdownImport:SetValue(nil)
end

local function doImport()
  Manager:DoImport()
  cancel()
end

local function copyChar()
  Manager:DoCopyChar()
  cancel()
end

StaticPopupDialogs["BESTINSLOT_CONFIRMIMPORT"] = {
  text = L["Are you sure you want to import the %s difficulty? This will override your old BiS list!"],
  button1 = YES,
  button2 = NO,
  OnAccept = doImport,
  OnCancel = cancel,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
  exclusive = 1,
}
StaticPopupDialogs["BESTINSLOT_CONFIRMCHARIMPORT"] = {
  text = L["Are you sure you want to import the list from %s? This will override your old BiS list!"],
  button1 = YES,
  button2 = NO,
  OnAccept = copyChar,
  OnCancel = cancel,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
  exclusive = 1
}
