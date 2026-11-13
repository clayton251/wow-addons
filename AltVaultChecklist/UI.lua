--[[
  Alt Vault Checklist — movable window, character table, weekly, gear, and party key panes.
]]

local ADDON, ns = ...

local FRAME_NAME = "AltVaultChecklistFrame"
local frame, charRows, detail
local selectedKey
local activeTab = "weekly" -- "weekly" | "gear" | "keys"
local ROW_HEIGHT = 28

local COLORS = {
  have = { 0.30, 0.85, 0.40 },
  catalyst = { 0.95, 0.75, 0.25 },
  missing = { 0.70, 0.70, 0.70 },
  unclaimed = { 1.00, 0.55, 0.20 },
  dim = { 0.55, 0.55, 0.55 },
}

local function ClassColor(classFile)
  local c = RAID_CLASS_COLORS and classFile and RAID_CLASS_COLORS[classFile]
  if c then
    return c.r, c.g, c.b
  end
  return 1, 0.82, 0
end

local function ColorText(r, g, b, text)
  return string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, text or "")
end

local function FormatKeystone(keystone)
  if not keystone or not keystone.level then
    return ColorText(0.55, 0.55, 0.55, "—")
  end
  local name = keystone.mapName or (keystone.mapID and ("Map " .. keystone.mapID)) or "Key"
  return string.format("+%d %s", keystone.level, name)
end

local function FormatWeeklyBest(best)
  if not best or not best.level then
    return ColorText(0.55, 0.55, 0.55, "—")
  end
  local name = best.mapName
  if name then
    return string.format("+%d %s", best.level, name)
  end
  return string.format("+%d", best.level)
end

local function FormatRating(rating)
  if type(rating) ~= "number" then
    return ColorText(0.55, 0.55, 0.55, "—")
  end
  return string.format("%d", math.floor(rating + 0.5))
end

local function FormatTrack(slots)
  if type(slots) ~= "table" or #slots == 0 then
    return ColorText(0.55, 0.55, 0.55, "—")
  end
  local parts = {}
  local filled = 0
  for i = 1, #slots do
    local s = slots[i]
    if s.filled then
      filled = filled + 1
      local bit = tostring(s.level or "✓")
      if s.ilvl then
        bit = bit .. string.format(" (%d)", s.ilvl)
      end
      parts[#parts + 1] = ColorText(0.30, 0.85, 0.40, bit)
    else
      local prog = ""
      if s.progress and s.threshold then
        prog = string.format("%d/%d", s.progress, s.threshold)
      else
        prog = "—"
      end
      parts[#parts + 1] = ColorText(0.55, 0.55, 0.55, prog)
    end
  end
  return table.concat(parts, "  ")
end

local function TrackFilledCount(slots)
  if type(slots) ~= "table" then
    return 0, 0
  end
  local n, f = #slots, 0
  for i = 1, n do
    if slots[i].filled then
      f = f + 1
    end
  end
  return f, n
end

--------------------------------------------------------------------------
-- Row / tab construction
--------------------------------------------------------------------------

local function MakeCheck(parent, onClick, onRightClick)
  local box = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
  box:SetSize(24, 24)
  box:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  box:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
      self:SetChecked(self._autoState)
      if onRightClick then
        onRightClick(self)
      end
      return
    end
    if onClick then
      onClick(self, self:GetChecked())
    end
  end)
  return box
end

local function EnsureRowPool(parent, pool, needed, factory)
  while #pool < needed do
    pool[#pool + 1] = factory(parent, #pool + 1)
  end
  for i = 1, #pool do
    if i <= needed then
      pool[i]:Show()
    else
      pool[i]:Hide()
    end
  end
end

--------------------------------------------------------------------------
-- Detail panes
--------------------------------------------------------------------------

local weeklyRows = {}
local gearRows = {}
local weeklyAddBox

local function WeeklyItems()
  local db = ns.DB()
  return (db and db.weeklyItems) or ns.DEFAULT_WEEKLY
end

local function RefreshWeeklyPane(char)
  if not detail or not detail.weekly then
    return
  end
  local items = WeeklyItems()
  local pane = detail.weekly
  EnsureRowPool(pane.scrollChild, weeklyRows, #items, function(parent, idx)
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(26)
    row:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, -4 - (idx - 1) * 26)
    row:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -4, -4 - (idx - 1) * 26)
    row.check = MakeCheck(row, function(box, checked)
      if not box.char or not box.item then
        return
      end
      box.char.weeklyChecks = box.char.weeklyChecks or {}
      box.char.weeklyChecks[box.item.id] = checked and true or false
      if ns.RefreshUI then
        ns.RefreshUI()
      end
    end, function(box)
      if not box.char or not box.item then
        return
      end
      box.char.weeklyChecks = box.char.weeklyChecks or {}
      box.char.weeklyChecks[box.item.id] = nil
      if ns.RefreshUI then
        ns.RefreshUI()
      end
    end)
    row.check:SetPoint("LEFT", 0, 0)
    row.label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.label:SetPoint("LEFT", row.check, "RIGHT", 4, 0)
    row.label:SetPoint("RIGHT", row, "RIGHT", -80, 0)
    row.label:SetJustifyH("LEFT")
    row.tag = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.tag:SetPoint("RIGHT", row, "RIGHT", -22, 0)
    row.tag:SetJustifyH("RIGHT")
    row.remove = CreateFrame("Button", nil, row, "UIPanelCloseButton")
    row.remove:SetSize(20, 20)
    row.remove:SetPoint("RIGHT", row, "RIGHT", 2, 0)
    row.remove:SetScript("OnClick", function(self)
      local item = self.item
      if not item or not tostring(item.id):find("^custom_") then
        return
      end
      local dbi = ns.DB()
      if not dbi or not dbi.weeklyItems then
        return
      end
      for i = #dbi.weeklyItems, 1, -1 do
        if dbi.weeklyItems[i].id == item.id then
          table.remove(dbi.weeklyItems, i)
        end
      end
      ns.RefreshUI()
    end)
    return row
  end)

  for i = 1, #items do
    local item = items[i]
    local row = weeklyRows[i]
    row:SetPoint("TOPLEFT", pane.scrollChild, "TOPLEFT", 4, -4 - (i - 1) * 26)
    row:SetPoint("TOPRIGHT", pane.scrollChild, "TOPRIGHT", -4, -4 - (i - 1) * 26)
    row.check.char = char
    row.check.item = item
    if char then
      local checked, isOverride = ns.IsWeeklyChecked(char, item)
      local auto = item.auto and ns.IsWeeklyAutoChecked(char, item.auto)
      row.check._autoState = auto
      row.check:SetChecked(checked)
      row.label:SetText(item.label)
      if isOverride then
        row.tag:SetText("manual  (right-click to clear)")
      elseif item.auto then
        row.tag:SetText(auto and "auto" or "auto")
        if auto then
          row.label:SetTextColor(0.30, 0.85, 0.40)
        else
          row.label:SetTextColor(1, 1, 1)
        end
      else
        row.tag:SetText("manual")
        row.label:SetTextColor(1, 1, 1)
      end
      if tostring(item.id):find("^custom_") then
        row.remove.item = item
        row.remove:Show()
      else
        row.remove.item = nil
        row.remove:Hide()
      end
    else
      row.check:SetChecked(false)
      row.check._autoState = false
      row.label:SetText(item.label)
      row.label:SetTextColor(0.7, 0.7, 0.7)
      row.tag:SetText("")
      row.remove:Hide()
    end
  end
  pane.scrollChild:SetHeight(math.max(80, #items * 26 + 12))
end

local function RefreshGearPane(char)
  if not detail or not detail.gear then
    return
  end
  local pane = detail.gear
  if not char then
    pane.note:SetText("Select a character to see their gearing list.")
    EnsureRowPool(pane.scrollChild, gearRows, 0, function() end)
    return
  end

  local list = ns.GetGearList(char.classFile, char.specName, char.specID)
  if not list then
    local who = char.className or char.classFile or "this character"
    local spec = char.specName or "unknown spec"
    if not char.classFile then
      pane.note:SetText((char.name or "This alt") .. " has not been logged in with the addon yet, so class and a BiS list could not be determined. Log in on them once to scan.")
    else
      pane.note:SetText(string.format("No verified Midnight Season 2 BiS list is bundled for %s (%s). Key, vault, rating, and weekly checklists still track for this character.", who, spec))
    end
    EnsureRowPool(pane.scrollChild, gearRows, 0, function() end)
    pane.scrollChild:SetHeight(20)
    return
  end

  pane.note:SetText(string.format("%s  •  Target ilvl %s  •  %s", list.title, tostring(list.targetIlvl or "—"), list.notes or ""))

  local items = list.items
  EnsureRowPool(pane.scrollChild, gearRows, #items, function(parent, idx)
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(36)
    row.check = MakeCheck(row, function(box, checked)
      if not box.char or not box.entry then
        return
      end
      box.char.gearOverrides = box.char.gearOverrides or {}
      box.char.gearOverrides[tostring(box.entry.id or box.entry.name)] = checked and true or false
      if ns.RefreshUI then
        ns.RefreshUI()
      end
    end, function(box)
      if not box.char or not box.entry then
        return
      end
      box.char.gearOverrides = box.char.gearOverrides or {}
      box.char.gearOverrides[tostring(box.entry.id or box.entry.name)] = nil
      if ns.RefreshUI then
        ns.RefreshUI()
      end
    end)
    row.check:SetPoint("LEFT", 0, 0)
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(28, 28)
    row.icon:SetPoint("LEFT", row.check, "RIGHT", 2, 0)
    row.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.name:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 6, 2)
    row.name:SetPoint("RIGHT", row, "RIGHT", -140, 0)
    row.name:SetJustifyH("LEFT")
    row.source = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.source:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -1)
    row.source:SetPoint("RIGHT", row, "RIGHT", -140, 0)
    row.source:SetJustifyH("LEFT")
    row.status = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    row.status:SetPoint("RIGHT", row, "RIGHT", -4, 0)
    row.status:SetWidth(130)
    row.status:SetJustifyH("RIGHT")
    -- Tooltip
    row:EnableMouse(true)
    row:SetScript("OnEnter", function(self)
      if not self.entry then
        return
      end
      GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
      if self.entry.id and GameTooltip.SetItemByID then
        GameTooltip:SetItemByID(self.entry.id)
      else
        GameTooltip:AddLine(self.entry.name or "Item")
      end
      GameTooltip:AddLine(" ")
      GameTooltip:AddLine("Source: " .. (self.entry.source or "—"), 1, 1, 1, true)
      if self.entry.catalystNote then
        GameTooltip:AddLine(self.entry.catalystNote, 0.95, 0.75, 0.25, true)
      end
      if self.entry.altNote then
        GameTooltip:AddLine(self.entry.altNote, 0.7, 0.85, 1, true)
      end
      GameTooltip:AddLine("Left-click the checkbox to override. Right-click clears the override.", 0.6, 0.6, 0.6, true)
      GameTooltip:Show()
    end)
    row:SetScript("OnLeave", function()
      GameTooltip:Hide()
    end)
    return row
  end)

  -- Grouped evaluation for rings and trinkets so one item cannot fill both slots.
  local owned = char.owned or {}
  local grouped = {}
  local byGroup = { finger = {}, trinket = {} }
  for i = 1, #items do
    local g = items[i].slot and items[i].slot:match("^(finger)") or (items[i].slot and items[i].slot:match("^(trinket)"))
    if g then
      byGroup[g][#byGroup[g] + 1] = { index = i, entry = items[i] }
    end
  end
  for g, listg in pairs(byGroup) do
    if #listg > 0 then
      local entries = {}
      for j = 1, #listg do
        entries[j] = listg[j].entry
      end
      local ev = ns.EvaluateGroupedSlots(entries, owned)
      for j = 1, #listg do
        if ev[j] and ev[j].status == "missing" and listg[j].entry.anyIlvl then
          local st, il, wh = ns.EvaluateGearEntry(listg[j].entry, owned, char.equippedSlots)
          ev[j] = { status = st, ilvl = il, where = wh }
        end
        grouped[listg[j].index] = ev[j]
      end
    end
  end

  for i = 1, #items do
    local entry = items[i]
    local row = gearRows[i]
    row:SetPoint("TOPLEFT", pane.scrollChild, "TOPLEFT", 4, -4 - (i - 1) * 36)
    row:SetPoint("TOPRIGHT", pane.scrollChild, "TOPRIGHT", -4, -4 - (i - 1) * 36)
    row.entry = entry
    row.check.char = char
    row.check.entry = entry

    local status, ilvl, where
    if grouped[i] then
      status, ilvl, where = grouped[i].status, grouped[i].ilvl, grouped[i].where
    else
      status, ilvl, where = ns.EvaluateGearEntry(entry, owned, char.equippedSlots)
    end
    local checked, isOverride = ns.IsGearChecked(char, entry, status)
    row.check._autoState = (status == "have")
    row.check:SetChecked(checked)

    local slotLabel = entry.slot or ""
    for s = 1, #ns.SLOTS do
      if ns.SLOTS[s].key == entry.slot then
        slotLabel = ns.SLOTS[s].label
        break
      end
    end
    row.name:SetText(string.format("%s  %s", slotLabel, entry.name or "?"))

    local icon
    if entry.id and C_Item and C_Item.GetItemIconByID then
      icon = ns.SafeCall(C_Item.GetItemIconByID, entry.id)
    end
    if icon then
      row.icon:SetTexture(icon)
    else
      row.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    end

    row.source:SetText(entry.source or "")

    local c = COLORS[status] or COLORS.missing
    row.name:SetTextColor(c[1], c[2], c[3])

    local statusBits = {}
    if status == "have" then
      local loc = where == "bag" and "in bags" or "equipped"
      if ilvl then
        statusBits[#statusBits + 1] = string.format("%s %d", loc, ilvl)
      else
        statusBits[#statusBits + 1] = loc
      end
    elseif status == "catalyst" then
      if ilvl then
        statusBits[#statusBits + 1] = string.format("catalyst src %d", ilvl)
      else
        statusBits[#statusBits + 1] = "catalyst source"
      end
    else
      statusBits[#statusBits + 1] = "missing"
    end
    if entry.targetIlvl then
      statusBits[#statusBits + 1] = string.format("target %d", entry.targetIlvl)
    end
    if isOverride then
      statusBits[#statusBits + 1] = "manual"
    end
    row.status:SetText(table.concat(statusBits, "  •  "))
    row.status:SetTextColor(c[1], c[2], c[3])
  end
  pane.scrollChild:SetHeight(math.max(80, #items * 36 + 12))
end

local FillDetailHeader

local function SetTab(tab)
  local leavingKeys = (activeTab == "keys" and tab ~= "keys")
  activeTab = tab
  if not detail then
    return
  end
  if tab == "weekly" or tab == "gear" then
    if leavingKeys then
      FillDetailHeader()
    end
  end
  if tab == "weekly" then
    detail.weekly:Show()
    detail.gear:Hide()
    if detail.party then
      detail.party:Hide()
    end
    if detail.weeklyAdd then
      detail.weeklyAdd:Show()
    end
    detail.tabWeekly:LockHighlight()
    detail.tabGear:UnlockHighlight()
    if detail.tabKeys then
      detail.tabKeys:UnlockHighlight()
    end
  elseif tab == "gear" then
    detail.weekly:Hide()
    detail.gear:Show()
    if detail.party then
      detail.party:Hide()
    end
    if detail.weeklyAdd then
      detail.weeklyAdd:Hide()
    end
    detail.tabWeekly:UnlockHighlight()
    detail.tabGear:LockHighlight()
    if detail.tabKeys then
      detail.tabKeys:UnlockHighlight()
    end
  else
    detail.weekly:Hide()
    detail.gear:Hide()
    if detail.weeklyAdd then
      detail.weeklyAdd:Hide()
    end
    if detail.hideBtn then
      detail.hideBtn:Hide()
      detail.removeBtn:Hide()
    end
    if detail.party then
      detail.party:Show()
    end
    detail.tabWeekly:UnlockHighlight()
    detail.tabGear:UnlockHighlight()
    if detail.tabKeys then
      detail.tabKeys:LockHighlight()
    end
    if ns.RefreshPartyPane then
      ns.RefreshPartyPane()
    end
  end
end

--------------------------------------------------------------------------
-- Main refresh
--------------------------------------------------------------------------

local function RefreshHeader()
  if not frame then
    return
  end
  local secs = ns.SecondsUntilWeeklyReset()
  local countdown = secs and ns.FormatDuration(secs) or "?"
  frame.resetText:SetText(string.format("Weekly reset in %s  (%s)", countdown, ns.US_RESET_LABEL))

  local db = ns.DB()
  local unclaimed = {}
  if db then
    for _, key in ipairs(ns.SortedCharKeys(true)) do
      local c = db.chars[key]
      if c and c.vault and c.vault.unclaimed then
        unclaimed[#unclaimed + 1] = c.name
      end
    end
  end
  if #unclaimed > 0 then
    frame.alertText:SetText("Unclaimed Great Vault: " .. table.concat(unclaimed, ", "))
    frame.alertText:SetTextColor(1, 0.55, 0.20)
  else
    frame.alertText:SetText("No unclaimed vault rewards recorded.")
    frame.alertText:SetTextColor(0.6, 0.6, 0.6)
  end
end

local function RefreshCharTable()
  if not frame then
    return
  end
  local db = ns.DB()
  if not db then
    return
  end
  local keys = ns.SortedCharKeys(frame.showHidden)
  EnsureRowPool(frame.list, charRows, #keys, function(parent, idx)
    local row = CreateFrame("Button", nil, parent)
    row:SetHeight(ROW_HEIGHT)
    row:RegisterForClicks("LeftButtonUp")
    row.bg = row:CreateTexture(nil, "BACKGROUND")
    row.bg:SetAllPoints()
    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.ilvl = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.key = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.best = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.rating = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.dung = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.raid = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.world = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.vault = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    local cols = {
      { fs = row.name,   w = 130 },
      { fs = row.ilvl,   w = 40 },
      { fs = row.key,    w = 140 },
      { fs = row.best,   w = 130 },
      { fs = row.rating, w = 50 },
      { fs = row.dung,   w = 130 },
      { fs = row.raid,   w = 90 },
      { fs = row.world,  w = 90 },
      { fs = row.vault,  w = 50 },
    }
    local x = 6
    for i = 1, #cols do
      cols[i].fs:SetPoint("LEFT", row, "LEFT", x, 0)
      cols[i].fs:SetWidth(cols[i].w - 4)
      cols[i].fs:SetJustifyH("LEFT")
      cols[i].fs:SetWordWrap(false)
      x = x + cols[i].w
    end
    row:SetScript("OnClick", function(self)
      selectedKey = self.charKey
      local dbi = ns.DB()
      if dbi then
        dbi.selectedKey = selectedKey
      end
      ns.RefreshUI()
    end)
    return row
  end)

  if not selectedKey then
    selectedKey = db.selectedKey or keys[1]
  end

  for i = 1, #keys do
    local key = keys[i]
    local char = db.chars[key]
    local row = charRows[i]
    row:SetPoint("TOPLEFT", frame.list, "TOPLEFT", 0, -(i - 1) * ROW_HEIGHT)
    row:SetPoint("TOPRIGHT", frame.list, "TOPRIGHT", 0, -(i - 1) * ROW_HEIGHT)
    row.charKey = key

    local selected = (key == selectedKey)
    if selected then
      row.bg:SetColorTexture(0.20, 0.35, 0.55, 0.45)
    elseif i % 2 == 0 then
      row.bg:SetColorTexture(1, 1, 1, 0.04)
    else
      row.bg:SetColorTexture(0, 0, 0, 0)
    end

    local r, g, b = ClassColor(char.classFile)
    local label = char.name or key
    if char.hidden then
      label = label .. "  (hidden)"
    end
    if not char.lastSeen then
      label = label .. "  (not scanned)"
    end
    row.name:SetText(label)
    row.name:SetTextColor(r, g, b)

    if char.ilvl then
      row.ilvl:SetText(string.format("%d", math.floor(char.ilvl + 0.5)))
    else
      row.ilvl:SetText(ColorText(0.55, 0.55, 0.55, "—"))
    end
    row.key:SetText(FormatKeystone(char.keystone))
    row.best:SetText(FormatWeeklyBest(char.weeklyBest))
    row.rating:SetText(FormatRating(char.rating))

    local tracks = char.vault and char.vault.tracks or {}
    row.dung:SetText(FormatTrack(tracks.dungeon))
    row.raid:SetText(FormatTrack(tracks.raid))
    row.world:SetText(FormatTrack(tracks.world))
    if char.vault and char.vault.unclaimed then
      row.vault:SetText(ColorText(1, 0.55, 0.20, "YES"))
    elseif char.lastSeen then
      row.vault:SetText(ColorText(0.30, 0.85, 0.40, "no"))
    else
      row.vault:SetText(ColorText(0.55, 0.55, 0.55, "—"))
    end
  end
  frame.list:SetHeight(math.max(ROW_HEIGHT, #keys * ROW_HEIGHT))
end

function FillDetailHeader()
  if not detail then
    return
  end
  local db = ns.DB()
  local char = db and selectedKey and db.chars[selectedKey]
  if char then
    local r, g, b = ClassColor(char.classFile)
    local spec = char.specName or ""
    local lvl = char.level and ("  " .. char.level) or ""
    local hero = char.hero and ("  •  " .. char.hero) or ""
    detail.title:SetText(ColorText(r, g, b, (char.name or selectedKey) .. lvl) .. "  " .. spec .. hero)
    local seen = ""
    if char.lastSeen then
      seen = "Last scanned: " .. date("%a %b %d %I:%M %p", char.lastSeen) .. " (this computer's clock)"
    else
      seen = "Log in on this character to scan key, vault, and bags."
    end
    detail.sub:SetText(seen)
    if detail.hideBtn then
      detail.hideBtn:SetText(char.hidden and "Unhide" or "Hide")
      detail.hideBtn:Show()
      detail.removeBtn:Show()
    end
  else
    detail.title:SetText("No character selected")
    detail.sub:SetText("")
    if detail.hideBtn then
      detail.hideBtn:Hide()
      detail.removeBtn:Hide()
    end
  end
end

local function RefreshDetail()
  if not detail then
    return
  end
  local db = ns.DB()
  local char = db and selectedKey and db.chars[selectedKey]
  if activeTab ~= "keys" then
    FillDetailHeader()
  end
  RefreshWeeklyPane(char)
  RefreshGearPane(char)
  SetTab(activeTab)
end

function ns.RefreshUI()
  if not frame or not frame:IsShown() then
    -- Still keep header-free; data is in SavedVariables either way.
    if frame then
      RefreshHeader()
    end
    return
  end
  RefreshHeader()
  RefreshCharTable()
  RefreshDetail()
end

--------------------------------------------------------------------------
-- Party Keys tab
--------------------------------------------------------------------------

local partyRows = {}
local PARTY_ROW_HEIGHT = 30

local ROLE_ATLAS = {
  TANK = "roleicon-tiny-tank",
  HEALER = "roleicon-tiny-healer",
  DAMAGER = "roleicon-tiny-dps",
}

local ROLE_LABEL = {
  TANK = "Tank",
  HEALER = "Healer",
  DAMAGER = "DPS",
  NONE = "—",
}

local function SetRoleIcon(tex, role)
  tex:Hide()
  if not role or role == "NONE" then
    return
  end
  local atlas = ROLE_ATLAS[role]
  if atlas and tex.SetAtlas then
    local ok = pcall(tex.SetAtlas, tex, atlas)
    if ok then
      tex:Show()
      return
    end
  end
  if GetTexCoordsForRoleSmallCircle then
    tex:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
    local a, b, c, d = GetTexCoordsForRoleSmallCircle(role)
    if a then
      tex:SetTexCoord(a, b, c, d)
      tex:Show()
    end
  end
end

local function PartyStatusLabel(member)
  if member.isSelf then
    return ColorText(0.30, 0.85, 0.40, "you")
  end
  if member.hasAddon then
    return ColorText(0.30, 0.85, 0.40, "addon")
  end
  if member.source == "astral" then
    return ColorText(0.70, 0.80, 1.00, "Astral Keys")
  end
  return ColorText(0.85, 0.70, 0.30, "no addon")
end

local function PartyKeyLabel(member)
  if member.level and member.level > 0 then
    local name = member.mapName or (member.mapID and ("Map " .. member.mapID)) or "Key"
    local text = string.format("+%d %s", member.level, name)
    if member.highest then
      text = text .. "  ★"
    end
    return text
  end
  if member.hasAddon and member.hasKey == false then
    return ColorText(0.55, 0.55, 0.55, "no key")
  end
  if member.hasAddon then
    return ColorText(0.55, 0.55, 0.55, "no key")
  end
  return ColorText(0.55, 0.55, 0.55, "unknown")
end

function ns.RefreshPartyPane()
  if not detail or not detail.party then
    return
  end
  if activeTab ~= "keys" then
    return
  end
  if not frame or not frame:IsShown() then
    return
  end
  local pane = detail.party
  local members, count, tooLarge = {}, 0, false
  if ns.GetPartyBoardMembers then
    members, count, tooLarge = ns.GetPartyBoardMembers()
  end
  detail.title:SetText("M+ Party Board")
  if ns.PartyBoardStatus then
    detail.sub:SetText(ns.PartyBoardStatus())
  else
    detail.sub:SetText("")
  end
  if tooLarge then
    pane.note:SetText("Leave the raid or form a 5-player party to use this board.")
  else
    pane.note:SetText("Party members need Alt Vault Checklist 2.1 or later to share their key. Without it, the key shows as unknown. Item level for those players is read by inspect, only while you are out of combat. “Post keys to party” sends one summary to party chat when you click it.")
  end
  if pane.postBtn then
    if IsInGroup and IsInGroup() and not tooLarge then
      pane.postBtn:Enable()
    else
      pane.postBtn:Disable()
    end
  end

  EnsureRowPool(pane.scrollChild, partyRows, #members, function(parent, idx)
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(PARTY_ROW_HEIGHT)
    row.bg = row:CreateTexture(nil, "BACKGROUND")
    row.bg:SetAllPoints()
    row.roleIcon = row:CreateTexture(nil, "ARTWORK")
    row.roleIcon:SetSize(16, 16)
    row.roleIcon:SetPoint("LEFT", row, "LEFT", 8, 0)
    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.role = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.ilvl = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.rating = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.key = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.status = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    local cols = {
      { fs = row.name,   x = 28,  w = 150 },
      { fs = row.role,   x = 180, w = 60 },
      { fs = row.ilvl,   x = 250, w = 50 },
      { fs = row.rating, x = 310, w = 60 },
      { fs = row.key,    x = 380, w = 220 },
      { fs = row.status, x = 610, w = 140 },
    }
    for i = 1, #cols do
      cols[i].fs:SetPoint("LEFT", row, "LEFT", cols[i].x, 0)
      cols[i].fs:SetWidth(cols[i].w - 4)
      cols[i].fs:SetJustifyH("LEFT")
      cols[i].fs:SetWordWrap(false)
    end
    return row
  end)

  for i = 1, #members do
    local m = members[i]
    local row = partyRows[i]
    row:SetPoint("TOPLEFT", pane.scrollChild, "TOPLEFT", 0, -(i - 1) * PARTY_ROW_HEIGHT)
    row:SetPoint("TOPRIGHT", pane.scrollChild, "TOPRIGHT", 0, -(i - 1) * PARTY_ROW_HEIGHT)
    if m.highest then
      row.bg:SetColorTexture(0.55, 0.42, 0.05, 0.40)
    elseif i % 2 == 0 then
      row.bg:SetColorTexture(1, 1, 1, 0.04)
    else
      row.bg:SetColorTexture(0, 0, 0, 0)
    end
    local r, g, b = ClassColor(m.classFile)
    row.name:SetText(m.name or m.fullName or "?")
    row.name:SetTextColor(r, g, b)
    SetRoleIcon(row.roleIcon, m.role)
    row.role:SetText(ROLE_LABEL[m.role] or "—")
    if m.ilvl then
      row.ilvl:SetText(string.format("%d", math.floor(m.ilvl + 0.5)))
    else
      row.ilvl:SetText(ColorText(0.55, 0.55, 0.55, "—"))
    end
    row.rating:SetText(FormatRating(m.rating))
    row.key:SetText(PartyKeyLabel(m))
    if m.highest then
      row.key:SetTextColor(1, 0.86, 0.20)
    else
      row.key:SetTextColor(1, 1, 1)
    end
    row.status:SetText(PartyStatusLabel(m))
  end
  pane.scrollChild:SetHeight(math.max(PARTY_ROW_HEIGHT, #members * PARTY_ROW_HEIGHT + 8))
end

function ns.ShowPartyKeysTab()
  ns.CreateUI()
  SetTab("keys")
end

--------------------------------------------------------------------------
-- Frame construction
--------------------------------------------------------------------------

local function MakeLabel(parent, template, text, x, y)
  local fs = parent:CreateFontString(nil, "OVERLAY", template or "GameFontNormal")
  fs:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
  fs:SetText(text)
  return fs
end

local function MakeTabButton(parent, label, x)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(120, 22)
  b:SetPoint("TOPLEFT", parent, "TOPLEFT", x, -6)
  b:SetText(label)
  return b
end

local function MakeScrollPane(parent, name)
  local pane = CreateFrame("Frame", nil, parent)
  pane:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, -36)
  pane:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -8, 8)
  local scroll = CreateFrame("ScrollFrame", name, pane, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", pane, "TOPLEFT", 0, 0)
  scroll:SetPoint("BOTTOMRIGHT", pane, "BOTTOMRIGHT", -22, 0)
  local child = CreateFrame("Frame", nil, scroll)
  child:SetWidth(1)
  child:SetHeight(1)
  scroll:SetScrollChild(child)
  scroll:SetScript("OnSizeChanged", function(self)
    child:SetWidth(self:GetWidth())
  end)
  pane.scroll = scroll
  pane.scrollChild = child
  return pane
end

function ns.CreateUI()
  if frame then
    return frame
  end
  local db = ns.DB()
  local w = (db and db.window and db.window.width) or 900
  local h = (db and db.window and db.window.height) or 580

  frame = CreateFrame("Frame", FRAME_NAME, UIParent, "BackdropTemplate")
  frame:SetSize(w, h)
  frame:SetFrameStrata("HIGH")
  frame:SetToplevel(true)
  frame:SetClampedToScreen(true)
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local dbi = ns.DB()
    if dbi then
      local point, _, _, x, y = self:GetPoint(1)
      dbi.window.point = point or "CENTER"
      dbi.window.x = x or 0
      dbi.window.y = y or 0
    end
  end)
  if frame.SetBackdrop then
    frame:SetBackdrop({
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
      tile = true, tileSize = 32, edgeSize = 32,
      insets = { left = 8, right = 8, top = 8, bottom = 8 },
    })
    frame:SetBackdropColor(0, 0, 0, 0.95)
  end

  if db and db.window then
    frame:ClearAllPoints()
    frame:SetPoint(db.window.point or "CENTER", UIParent, db.window.point or "CENTER", db.window.x or 0, db.window.y or 0)
  else
    frame:SetPoint("CENTER")
  end

  tinsert(UISpecialFrames, FRAME_NAME)

  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOP", frame, "TOP", 0, -16)
  title:SetText("Alt Vault Checklist")
  frame.title = title

  local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
  close:SetScript("OnClick", function()
    frame:Hide()
  end)

  frame.resetText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.resetText:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -40)

  frame.alertText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  frame.alertText:SetPoint("TOPLEFT", frame.resetText, "BOTTOMLEFT", 0, -2)

  frame.showHiddenBox = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
  frame.showHiddenBox:SetSize(24, 24)
  frame.showHiddenBox:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -44, -36)
  frame.showHiddenBox:SetScript("OnClick", function(self)
    frame.showHidden = self:GetChecked() and true or false
    ns.RefreshUI()
  end)
  frame.showHiddenLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.showHiddenLabel:SetPoint("RIGHT", frame.showHiddenBox, "LEFT", -2, 0)
  frame.showHiddenLabel:SetText("Show hidden")

  frame.helpBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  frame.helpBtn:SetSize(50, 20)
  frame.helpBtn:SetPoint("RIGHT", frame.showHiddenLabel, "LEFT", -8, 0)
  frame.helpBtn:SetText("Help")
  frame.helpBtn:SetScript("OnClick", function()
    SlashCmdList.ALTVAULTCHECKLIST("help")
    print("|cff88ccffTip:|r Hide or Remove is on each character's detail pane. Remove asks you to click Confirm.")
  end)

  -- Column headers
  local header = CreateFrame("Frame", nil, frame)
  header:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -72)
  header:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -16, -72)
  header:SetHeight(18)
  local headerBg = header:CreateTexture(nil, "BACKGROUND")
  headerBg:SetAllPoints()
  headerBg:SetColorTexture(0.15, 0.15, 0.2, 0.8)

  local colDefs = {
    { text = "Character", w = 130 },
    { text = "iLvl",      w = 40 },
    { text = "Key",       w = 140 },
    { text = "Weekly Best", w = 130 },
    { text = "Rating",    w = 50 },
    { text = "Dungeons",  w = 130 },
    { text = "Raid",      w = 90 },
    { text = "World",     w = 90 },
    { text = "Claim?",    w = 50 },
  }
  local hx = 6
  for i = 1, #colDefs do
    local fs = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    fs:SetPoint("LEFT", header, "LEFT", hx, 0)
    fs:SetWidth(colDefs[i].w - 4)
    fs:SetJustifyH("LEFT")
    fs:SetText(colDefs[i].text)
    hx = hx + colDefs[i].w
  end

  frame.list = CreateFrame("Frame", nil, frame)
  frame.list:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, 0)
  frame.list:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", 0, 0)
  -- Height is set during refresh; give it a starting size.
  frame.list:SetHeight(ROW_HEIGHT * 6)
  charRows = {}

  -- Detail panel fills the rest of the window.
  detail = CreateFrame("Frame", nil, frame, "BackdropTemplate")
  detail:SetPoint("TOPLEFT", frame.list, "BOTTOMLEFT", 0, -8)
  detail:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -16, 16)
  if detail.SetBackdrop then
    detail:SetBackdrop({
      bgFile = "Interface\\Buttons\\WHITE8x8",
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile = true, tileSize = 8, edgeSize = 12,
      insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    detail:SetBackdropColor(0, 0, 0, 0.35)
  end

  detail.title = detail:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  detail.title:SetPoint("TOPLEFT", detail, "TOPLEFT", 12, -8)
  detail.sub = detail:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  detail.sub:SetPoint("TOPLEFT", detail.title, "BOTTOMLEFT", 0, -2)

  detail.hideBtn = CreateFrame("Button", nil, detail, "UIPanelButtonTemplate")
  detail.hideBtn:SetSize(70, 20)
  detail.hideBtn:SetPoint("TOPRIGHT", detail, "TOPRIGHT", -8, -8)
  detail.hideBtn:SetText("Hide")
  detail.hideBtn:SetScript("OnClick", function()
    if not selectedKey then return end
    local dbi = ns.DB()
    local char = dbi and dbi.chars[selectedKey]
    if not char then return end
    ns.SetCharHidden(selectedKey, not char.hidden)
    ns.RefreshUI()
  end)
  detail.removeBtn = CreateFrame("Button", nil, detail, "UIPanelButtonTemplate")
  detail.removeBtn:SetSize(70, 20)
  detail.removeBtn:SetPoint("RIGHT", detail.hideBtn, "LEFT", -4, 0)
  detail.removeBtn:SetText("Remove")
  detail.removeBtn._armed = nil
  detail.removeBtn:SetScript("OnClick", function(self)
    if not selectedKey then return end
    if self._armed ~= selectedKey then
      self._armed = selectedKey
      self:SetText("Confirm")
      return
    end
    ns.DeleteChar(selectedKey)
    self._armed = nil
    self:SetText("Remove")
    selectedKey = ns.DB() and ns.DB().selectedKey
    ns.RefreshUI()
  end)
  detail.removeBtn:SetScript("OnLeave", function(self)
    if self._armed then
      self._armed = nil
      self:SetText("Remove")
    end
  end)

  detail.tabWeekly = MakeTabButton(detail, "Weekly", 8)
  detail.tabWeekly:ClearAllPoints()
  detail.tabWeekly:SetPoint("TOPLEFT", detail, "TOPLEFT", 8, -40)
  detail.tabWeekly:SetScript("OnClick", function()
    SetTab("weekly")
  end)
  detail.tabGear = MakeTabButton(detail, "Gear / BiS", 132)
  detail.tabGear:ClearAllPoints()
  detail.tabGear:SetPoint("TOPLEFT", detail, "TOPLEFT", 132, -40)
  detail.tabGear:SetScript("OnClick", function()
    SetTab("gear")
  end)
  detail.tabKeys = MakeTabButton(detail, "Party Keys", 256)
  detail.tabKeys:ClearAllPoints()
  detail.tabKeys:SetPoint("TOPLEFT", detail, "TOPLEFT", 256, -40)
  detail.tabKeys:SetScript("OnClick", function()
    SetTab("keys")
  end)

  local tabBody = CreateFrame("Frame", nil, detail)
  tabBody:SetPoint("TOPLEFT", detail, "TOPLEFT", 4, -66)
  tabBody:SetPoint("BOTTOMRIGHT", detail, "BOTTOMRIGHT", -4, 4)

  detail.weekly = MakeScrollPane(tabBody, "AltVaultChecklistWeeklyScroll")
  detail.weekly:SetPoint("TOPLEFT", tabBody, "TOPLEFT", 0, 0)
  detail.weekly:SetPoint("BOTTOMRIGHT", tabBody, "BOTTOMRIGHT", 0, 28)

  -- Add-custom weekly item
  local add = CreateFrame("Frame", nil, detail.weekly)
  add:SetPoint("BOTTOMLEFT", tabBody, "BOTTOMLEFT", 4, 2)
  add:SetPoint("BOTTOMRIGHT", tabBody, "BOTTOMRIGHT", -4, 2)
  add:SetHeight(24)
  -- Reparent add bar to detail so it stays visible above the scroll.
  add:SetParent(detail)
  add:SetPoint("BOTTOMLEFT", detail, "BOTTOMLEFT", 8, 8)
  add:SetPoint("BOTTOMRIGHT", detail, "BOTTOMRIGHT", -8, 8)
  local addLabel = add:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  addLabel:SetPoint("LEFT", add, "LEFT", 0, 0)
  addLabel:SetText("Add weekly item:")
  weeklyAddBox = CreateFrame("EditBox", "AltVaultChecklistWeeklyAdd", add, "InputBoxTemplate")
  weeklyAddBox:SetSize(280, 20)
  weeklyAddBox:SetPoint("LEFT", addLabel, "RIGHT", 8, 0)
  weeklyAddBox:SetAutoFocus(false)
  weeklyAddBox:SetMaxLetters(80)
  local addBtn = CreateFrame("Button", nil, add, "UIPanelButtonTemplate")
  addBtn:SetSize(70, 20)
  addBtn:SetPoint("LEFT", weeklyAddBox, "RIGHT", 6, 0)
  addBtn:SetText("Add")
  local function AddCustomWeekly()
    local text = weeklyAddBox:GetText()
    text = text and text:gsub("^%s+", ""):gsub("%s+$", "") or ""
    if text == "" then
      return
    end
    local dbi = ns.DB()
    dbi.weeklyItems = dbi.weeklyItems or {}
    local id = "custom_" .. tostring(GetServerTime()) .. "_" .. tostring(math.random(1000, 9999))
    dbi.weeklyItems[#dbi.weeklyItems + 1] = { id = id, label = text, auto = nil }
    weeklyAddBox:SetText("")
    weeklyAddBox:ClearFocus()
    ns.RefreshUI()
  end
  addBtn:SetScript("OnClick", AddCustomWeekly)
  weeklyAddBox:SetScript("OnEnterPressed", AddCustomWeekly)
  weeklyAddBox:SetScript("OnEscapePressed", function(self)
    self:ClearFocus()
  end)
  detail.weeklyAdd = add

  detail.gear = MakeScrollPane(tabBody, "AltVaultChecklistGearScroll")
  detail.gear:SetPoint("TOPLEFT", tabBody, "TOPLEFT", 0, 0)
  detail.gear:SetPoint("BOTTOMRIGHT", tabBody, "BOTTOMRIGHT", 0, 0)
  detail.gear.note = detail.gear:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  -- Put the note above the scroll content, inside the tab body header area.
  -- Actually attach to the pane top; shrink scroll to leave room.
  local noteHolder = CreateFrame("Frame", nil, detail.gear)
  noteHolder:SetPoint("TOPLEFT", tabBody, "TOPLEFT", 6, 0)
  noteHolder:SetPoint("TOPRIGHT", tabBody, "TOPRIGHT", -28, 0)
  noteHolder:SetHeight(36)
  detail.gear.note:SetParent(noteHolder)
  detail.gear.note:ClearAllPoints()
  detail.gear.note:SetPoint("TOPLEFT", noteHolder, "TOPLEFT", 0, 0)
  detail.gear.note:SetPoint("BOTTOMRIGHT", noteHolder, "BOTTOMRIGHT", 0, 0)
  detail.gear.note:SetJustifyH("LEFT")
  detail.gear.note:SetJustifyV("TOP")
  detail.gear.note:SetWordWrap(true)
  detail.gear.scroll:SetPoint("TOPLEFT", tabBody, "TOPLEFT", 0, -38)

  -- Party Keys pane (current group, not the selected alt)
  local party = CreateFrame("Frame", nil, tabBody)
  party:SetPoint("TOPLEFT", tabBody, "TOPLEFT", 0, 0)
  party:SetPoint("BOTTOMRIGHT", tabBody, "BOTTOMRIGHT", 0, 0)
  party:Hide()

  party.refreshBtn = CreateFrame("Button", nil, party, "UIPanelButtonTemplate")
  party.refreshBtn:SetSize(90, 22)
  party.refreshBtn:SetPoint("TOPLEFT", party, "TOPLEFT", 4, 0)
  party.refreshBtn:SetText("Refresh")
  party.refreshBtn:SetScript("OnClick", function()
    if ns.PartyKeys_RequestRefresh then
      ns.PartyKeys_RequestRefresh()
    elseif ns.RefreshPartyPane then
      ns.RefreshPartyPane()
    end
  end)

  party.postBtn = CreateFrame("Button", nil, party, "UIPanelButtonTemplate")
  party.postBtn:SetSize(150, 22)
  party.postBtn:SetPoint("LEFT", party.refreshBtn, "RIGHT", 6, 0)
  party.postBtn:SetText("Post keys to party")
  party.postBtn:SetScript("OnClick", function()
    if ns.PartyKeys_PostToChat then
      ns.PartyKeys_PostToChat()
    end
  end)

  party.note = party:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  party.note:SetPoint("TOPLEFT", party, "TOPLEFT", 4, -26)
  party.note:SetPoint("TOPRIGHT", party, "TOPRIGHT", -8, -26)
  party.note:SetJustifyH("LEFT")
  party.note:SetJustifyV("TOP")
  party.note:SetWordWrap(true)
  party.note:SetHeight(36)

  local pheader = CreateFrame("Frame", nil, party)
  pheader:SetPoint("TOPLEFT", party, "TOPLEFT", 0, -64)
  pheader:SetPoint("TOPRIGHT", party, "TOPRIGHT", -22, -64)
  pheader:SetHeight(18)
  local pheaderBg = pheader:CreateTexture(nil, "BACKGROUND")
  pheaderBg:SetAllPoints()
  pheaderBg:SetColorTexture(0.15, 0.15, 0.2, 0.8)
  local pcols = {
    { text = "Name",   x = 28,  w = 150 },
    { text = "Role",   x = 180, w = 60 },
    { text = "iLvl",   x = 250, w = 50 },
    { text = "Rating", x = 310, w = 60 },
    { text = "Key",    x = 380, w = 220 },
    { text = "Source", x = 610, w = 140 },
  }
  for i = 1, #pcols do
    local fs = pheader:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    fs:SetPoint("LEFT", pheader, "LEFT", pcols[i].x, 0)
    fs:SetWidth(pcols[i].w - 4)
    fs:SetJustifyH("LEFT")
    fs:SetText(pcols[i].text)
  end

  local pscroll = CreateFrame("ScrollFrame", "AltVaultChecklistPartyScroll", party, "UIPanelScrollFrameTemplate")
  pscroll:SetPoint("TOPLEFT", pheader, "BOTTOMLEFT", 0, 0)
  pscroll:SetPoint("BOTTOMRIGHT", party, "BOTTOMRIGHT", -22, 4)
  local pchild = CreateFrame("Frame", nil, pscroll)
  pchild:SetWidth(1)
  pchild:SetHeight(1)
  pscroll:SetScrollChild(pchild)
  pscroll:SetScript("OnSizeChanged", function(self)
    pchild:SetWidth(self:GetWidth())
  end)
  party.scroll = pscroll
  party.scrollChild = pchild
  detail.party = party

  SetTab("weekly")
  frame:Hide()
  frame:SetScript("OnShow", function()
    if ns.CollectPlayer then
      ns.CollectPlayer()
    end
    ns.RefreshUI()
  end)
  return frame
end

function ns.ToggleUI()
  ns.CreateUI()
  if frame:IsShown() then
    frame:Hide()
  else
    frame:Show()
  end
end

function ns.ShowUI()
  ns.CreateUI()
  frame:Show()
end

function ns.ResetUIPosition()
  if not frame then
    return
  end
  frame:ClearAllPoints()
  frame:SetPoint("CENTER")
end
