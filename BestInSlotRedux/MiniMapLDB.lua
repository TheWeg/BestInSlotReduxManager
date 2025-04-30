local BestInSlot, L = unpack(select(2, ...))
local isRegistered = false
local LDB = LibStub("LibDataBroker-1.1", true)
local DBIcon = LibStub("LibDBIcon-1.0", true)

if not LDB then error("LibDataBroker-1.1 is required but not found!") end
if not DBIcon then error("LibDBIcon-1.0 is required but not found!") end

local BiSLDB = LDB:NewDataObject("BestInSlotRedux", {
    type = "launcher",
    text = "Best In Slot Redux",
    icon = "Interface\\Icons\\Achievement_ChallengeMode_Gold",
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("Best In Slot Redux")
        tooltip:AddLine(("%s%s: %s%s|r"):format(BestInSlot.colorHighlight, L["Click"], BestInSlot.colorNormal, L["Show the GUI"]))
    end
})

---@diagnostic disable-next-line: redundant-parameter
function BiSLDB:OnClick(button, down)
  if down then return end -- Ignorer les clics "down", ne traiter que les clics "up".

  if button == "LeftButton" then
      if BestInSlot and BestInSlot.ToggleFrame then
          local success, err = pcall(BestInSlot.ToggleFrame, BestInSlot)
          if not success then
              DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Error during ToggleFrame execution:|r " .. tostring(err))
          end
      else
          DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Error: BestInSlot or ToggleFrame is not available.|r")
      end
  elseif button == "RightButton" then
      -- Placeholder pour des actions supplémentaires (par ex., ouvrir un menu contextuel).
      print("Right-click detected. Add context menu logic here.")
  else
      print("Unhandled button click:", button)
  end
end


function BestInSlot:RegisterMinimapIcon()
    if DBIcon and not DBIcon:IsRegistered("BestInSlotRedux") then
        DBIcon:Register("BestInSlotRedux", BiSLDB, BestInSlot.db.profile.minimap)
        isRegistered = true
    end
end

function BestInSlot:MiniMapButtonVisible(bool)
    if bool then
        if not DBIcon:IsRegistered("BestInSlotRedux") then
            self:RegisterMinimapIcon()
        end
        DBIcon:Show("BestInSlotRedux")
    else
        DBIcon:Hide("BestInSlotRedux")
    end
end

function BestInSlot:MiniMapButtonHideShow()
    BestInSlot.db.char.options.minimapButton = not BestInSlot.db.char.options.minimapButton
    BestInSlot:MiniMapButtonVisible(BestInSlot.db.char.options.minimapButton)
end

