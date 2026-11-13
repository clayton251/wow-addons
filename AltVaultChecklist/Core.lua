--[[
  Alt Vault Checklist — core, SavedVariables, events, slash commands,
  minimap button, and addon-compartment entry.
]]

local ADDON, ns = ...
_G.AltVaultChecklist = ns

ns.ADDON_NAME = ADDON
ns.VERSION = "2.1.1"
-- US weekly reset is Tuesday 15:00 UTC (10:00 AM America/New_York while EST).
-- The game API C_DateAndTime.GetSecondsUntilWeeklyReset already uses the
-- player's region, so we do not hard-code the clock for the countdown.
ns.US_RESET_LABEL = "Tue 15:00 UTC / 10:00 AM ET"

local db

local defaults = {
  version = 1,
  minimap = { hide = false, angle = 220 },
  window = { point = "CENTER", x = 0, y = 0, width = 900, height = 580 },
  selectedKey = nil,
  weeklyItems = nil, -- copied from ns.DEFAULT_WEEKLY on first run
  weeklyResetAt = 0, -- GetServerTime() of the next reset when we last snapshotted
  chars = {},
}

local function CopyTable(src)
  if type(src) ~= "table" then
    return src
  end
  local dst = {}
  for k, v in pairs(src) do
    if type(v) == "table" then
      dst[k] = CopyTable(v)
    else
      dst[k] = v
    end
  end
  return dst
end

function ns.SafeCall(fn, ...)
  if type(fn) ~= "function" then
    return nil
  end
  local ok, a, b, c, d, e = pcall(fn, ...)
  if not ok then
    return nil
  end
  return a, b, c, d, e
end

function ns.DB()
  return db
end

function ns.CharKey(name, realm)
  if not name then
    return nil
  end
  if not realm or realm == "" then
    realm = "Unknown"
  end
  realm = realm:gsub("%s+", "")
  return name .. "-" .. realm
end

function ns.PlayerKey()
  local name, realm = UnitName("player")
  if not realm or realm == "" then
    realm = ns.SafeCall(GetNormalizedRealmName) or ns.SafeCall(GetRealmName)
  end
  return ns.CharKey(name, realm), name, realm
end

function ns.EnsureChar(key, name, realm)
  db.chars = db.chars or {}
  local char = db.chars[key]
  if not char then
    char = {
      name = name,
      realm = realm or "Unknown",
      weeklyChecks = {},
      gearOverrides = {},
      owned = {},
    }
    db.chars[key] = char
  end
  return char
end

function ns.SecondsUntilWeeklyReset()
  local secs = ns.SafeCall(C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset)
  if type(secs) == "number" and secs >= 0 then
    return secs
  end
  return nil
end

function ns.NextResetTime()
  local secs = ns.SecondsUntilWeeklyReset()
  if not secs then
    return nil
  end
  return (GetServerTime() or 0) + secs
end

function ns.FormatDuration(secs)
  if type(secs) ~= "number" or secs < 0 then
    return "?"
  end
  local d = math.floor(secs / 86400)
  local h = math.floor((secs % 86400) / 3600)
  local m = math.floor((secs % 3600) / 60)
  if d > 0 then
    return string.format("%dd %dh", d, h)
  end
  if h > 0 then
    return string.format("%dh %dm", h, m)
  end
  return string.format("%dm", m)
end

local function ResetWeeklyFields(char)
  char.key = nil
  char.weeklyBest = nil
  char.vault = nil
  char.weeklyChecks = {}
end

function ns.CheckWeeklyReset()
  local nextReset = ns.NextResetTime()
  if not nextReset then
    return
  end
  local prev = db.weeklyResetAt or 0
  -- If the stored "next reset" is in the past, a reset has occurred.
  if prev > 0 and nextReset > prev + 60 then
    for _, char in pairs(db.chars) do
      ResetWeeklyFields(char)
    end
  end
  db.weeklyResetAt = nextReset
end

local function InitDatabase()
  if type(AltVaultChecklistDB) ~= "table" then
    AltVaultChecklistDB = CopyTable(defaults)
  end
  db = AltVaultChecklistDB
  if type(db.chars) ~= "table" then
    db.chars = {}
  end
  if type(db.minimap) ~= "table" then
    db.minimap = CopyTable(defaults.minimap)
  end
  if type(db.window) ~= "table" then
    db.window = CopyTable(defaults.window)
  end
  if type(db.weeklyItems) ~= "table" then
    db.weeklyItems = CopyTable(ns.DEFAULT_WEEKLY)
  end
  -- Characters are added automatically the first time they log in.
  -- No hardcoded roster is seeded.
end

function ns.SortedCharKeys(includeHidden)
  local playerKey = ns.PlayerKey()
  local keys = {}
  for key, char in pairs(db.chars) do
    if includeHidden or not (char and char.hidden) or key == playerKey then
      keys[#keys + 1] = key
    end
  end
  table.sort(keys, function(a, b)
    if a == playerKey then
      return true
    end
    if b == playerKey then
      return false
    end
    local ca, cb = db.chars[a], db.chars[b]
    local ha = (ca and ca.hidden) and 1 or 0
    local hb = (cb and cb.hidden) and 1 or 0
    if ha ~= hb then
      return ha < hb
    end
    local na = (ca and ca.name) or a
    local nb = (cb and cb.name) or b
    if na ~= nb then
      return na < nb
    end
    return a < b
  end)
  return keys
end

function ns.SetCharHidden(key, hidden)
  local char = db.chars and db.chars[key]
  if not char then
    return
  end
  char.hidden = hidden and true or nil
end

function ns.DeleteChar(key)
  if not db.chars or not key then
    return
  end
  local playerKey = ns.PlayerKey()
  db.chars[key] = nil
  if db.selectedKey == key then
    db.selectedKey = (playerKey ~= key) and playerKey or nil
  end
end

--------------------------------------------------------------------------
-- Minimap button
--------------------------------------------------------------------------
local mini

local function Minimap_UpdatePosition()
  if not mini then
    return
  end
  local angle = math.rad(db.minimap.angle or 220)
  local radius = (Minimap:GetWidth() / 2) + 8
  mini:ClearAllPoints()
  mini:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
end

local function Minimap_Drag(_, button)
  if button ~= "LeftButton" then
    return
  end
  if not mini.dragging then
    return
  end
  local mx, my = Minimap:GetCenter()
  local cx, cy = GetCursorPosition()
  local scale = Minimap:GetEffectiveScale()
  cx, cy = cx / scale, cy / scale
  local angle = math.deg(math.atan2(cy - my, cx - mx))
  if angle < 0 then
    angle = angle + 360
  end
  db.minimap.angle = angle
  Minimap_UpdatePosition()
end

local function CreateMinimapButton()
  if mini or not Minimap then
    return
  end
  mini = CreateFrame("Button", "AltVaultChecklistMinimapButton", Minimap)
  mini:SetSize(32, 32)
  mini:SetFrameStrata("MEDIUM")
  mini:SetFrameLevel(8)
  mini:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
  local icon = mini:CreateTexture(nil, "ARTWORK")
  icon:SetTexture("Interface\\Icons\\INV_Relics_Hourglass")
  icon:SetSize(20, 20)
  icon:SetPoint("CENTER")
  icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
  local border = mini:CreateTexture(nil, "OVERLAY")
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  border:SetSize(54, 54)
  border:SetPoint("TOPLEFT")
  mini:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  mini:RegisterForDrag("LeftButton")
  mini:SetScript("OnDragStart", function(self)
    self.dragging = true
    self:SetScript("OnUpdate", Minimap_Drag)
  end)
  mini:SetScript("OnDragStop", function(self)
    self.dragging = false
    self:SetScript("OnUpdate", nil)
  end)
  mini:SetScript("OnClick", function(_, button)
    if button == "LeftButton" then
      ns.ToggleUI()
    else
      db.minimap.hide = true
      mini:Hide()
      print("|cff88ccffAlt Vault Checklist:|r minimap button hidden. Type |cffffd200/altcheck minimap|r to show it again.")
    end
  end)
  mini:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Alt Vault Checklist")
    GameTooltip:AddLine("Left-click: open the checklist", 1, 1, 1)
    GameTooltip:AddLine("Right-click: hide this button", 0.8, 0.8, 0.8)
    GameTooltip:AddLine("Drag: move around the minimap", 0.8, 0.8, 0.8)
    GameTooltip:Show()
  end)
  mini:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)
  Minimap_UpdatePosition()
  if db.minimap.hide then
    mini:Hide()
  else
    mini:Show()
  end
end

function ns.SetMinimapShown(shown)
  db.minimap.hide = not shown
  if mini then
    if shown then
      mini:Show()
    else
      mini:Hide()
    end
  end
end

--------------------------------------------------------------------------
-- Addon compartment (retail micro menu)
--------------------------------------------------------------------------
function AltVaultChecklist_OnAddonCompartmentClick()
  ns.ToggleUI()
end

function AltVaultChecklist_OnAddonCompartmentEnter(_, menuButton)
  if not GameTooltip then
    return
  end
  GameTooltip:SetOwner(menuButton, "ANCHOR_LEFT")
  GameTooltip:AddLine("Alt Vault Checklist")
  GameTooltip:AddLine("Account-wide key, vault, and gear checklists", 1, 1, 1)
  GameTooltip:AddLine("Party Keys tab: /altcheck keys", 0.8, 0.8, 0.8)
  GameTooltip:AddLine("Slash command: /altcheck", 0.8, 0.8, 0.8)
  GameTooltip:Show()
end

function AltVaultChecklist_OnAddonCompartmentLeave()
  if GameTooltip then
    GameTooltip:Hide()
  end
end

--------------------------------------------------------------------------
-- Slash commands
--------------------------------------------------------------------------
SLASH_ALTVAULTCHECKLIST1 = "/altcheck"
SLASH_ALTVAULTCHECKLIST2 = "/avc"
SLASH_ALTVAULTCHECKLIST3 = "/altvault"

SlashCmdList.ALTVAULTCHECKLIST = function(msg)
  msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
  if msg == "minimap" then
    ns.SetMinimapShown(true)
    print("|cff88ccffAlt Vault Checklist:|r minimap button shown.")
    return
  end
  if msg == "resetpos" then
    db.window = CopyTable(defaults.window)
    if ns.ResetUIPosition then
      ns.ResetUIPosition()
    end
    print("|cff88ccffAlt Vault Checklist:|r window position reset.")
    return
  end
  if msg == "scan" then
    if ns.CollectPlayer then
      ns.CollectPlayer()
    end
    if ns.RefreshUI then
      ns.RefreshUI()
    end
    print("|cff88ccffAlt Vault Checklist:|r rescan complete.")
    return
  end
  if msg == "keys" or msg == "party" then
    if ns.ShowUI then
      ns.ShowUI()
    end
    if ns.ShowPartyKeysTab then
      ns.ShowPartyKeysTab()
    end
    return
  end
  if msg == "help" then
    print("|cff88ccffAlt Vault Checklist|r  v" .. (ns.VERSION or ""))
    print("  /altcheck           Open or close the window")
    print("  /altcheck keys      Open the Party Keys tab")
    print("  /altcheck scan      Rescan the character you are on")
    print("  /altcheck minimap   Show the minimap button if you hid it")
    print("  /altcheck resetpos  Reset the window to the center of the screen")
    print("  /altcheck help      This list")
    print("|cffffd200What it does:|r logs each character you play, detects class and spec,")
    print("and loads the matching Midnight Season 2 BiS list. Switching specs rescans")
    print("and reloads the list. The table tracks your key, weekly best, M+ rating,")
    print("and Great Vault (dungeons, raid, world/delves).")
    print("The Party Keys tab lists your current party's name, role, item level,")
    print("M+ rating, and keystone. Friends need this addon to share their key.")
    print("Hide or remove an alt from the window with the buttons on its detail pane.")
    print("Left-click a checkbox to override it; right-click clears the override.")
    return
  end
  ns.ToggleUI()
end

--------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------
local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_LOGOUT")
ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
ev:RegisterEvent("BAG_UPDATE_DELAYED")
ev:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE")
ev:RegisterEvent("WEEKLY_REWARDS_UPDATE")
ev:RegisterEvent("CHALLENGE_MODE_COMPLETED")
ev:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE")
ev:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
ev:RegisterEvent("PLAYER_LEVEL_UP")

local bagPending = false

local function DelayedCollect()
  ev:SetScript("OnUpdate", nil)
  bagPending = false
  if ns.CollectPlayer then
    ns.CollectPlayer()
  end
  if ns.RefreshUI then
    ns.RefreshUI()
  end
end

local function QueueCollect()
  if bagPending then
    return
  end
  bagPending = true
  ev.elapsed = 0
  ev:SetScript("OnUpdate", function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed >= 0.4 then
      DelayedCollect()
    end
  end)
end

ev:SetScript("OnEvent", function(_, event, arg1)
  if event == "ADDON_LOADED" then
    if arg1 ~= ADDON then
      return
    end
    InitDatabase()
    return
  end

  if event == "PLAYER_LOGIN" then
    ns.CheckWeeklyReset()
    if C_MythicPlus then
      ns.SafeCall(C_MythicPlus.RequestMapInfo)
      ns.SafeCall(C_MythicPlus.RequestCurrentAffixes)
    end
    CreateMinimapButton()
    if ns.CreateUI then
      ns.CreateUI()
    end
    QueueCollect()
    return
  end

  if event == "PLAYER_LOGOUT" then
    if ns.CollectPlayer then
      ns.CollectPlayer()
    end
    return
  end

  if not db then
    return
  end

  if event == "PLAYER_ENTERING_WORLD"
      or event == "WEEKLY_REWARDS_UPDATE"
      or event == "CHALLENGE_MODE_COMPLETED"
      or event == "CHALLENGE_MODE_MAPS_UPDATE"
      or event == "PLAYER_SPECIALIZATION_CHANGED"
      or event == "PLAYER_LEVEL_UP"
      or event == "PLAYER_EQUIPMENT_CHANGED"
      or event == "PLAYER_AVG_ITEM_LEVEL_UPDATE"
      or event == "BAG_UPDATE_DELAYED" then
    if event == "WEEKLY_REWARDS_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
      ns.CheckWeeklyReset()
    end
    QueueCollect()
  end
end)
