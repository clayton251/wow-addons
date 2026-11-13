--[[
  Display-only UI: a compact kick bar, a boss-notes panel, and a config
  window with Assign / Notes / Options tabs.
]]

local ADDON, ns = ...

local BAR_W, BAR_H = 360, 150
local NOTES_W, NOTES_H = 420, 420
local CFG_W, CFG_H = 880, 580
local GOLD = { 1, 0.82, 0 }
local BACKDROP = {
  bgFile = "Interface\\Buttons\\WHITE8X8",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 8, edgeSize = 12,
  insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

local bar, notes, config, minimapBtn
local assignState = { group = 1, selected = nil }
local notesState = { key = nil, kind = nil, boss = nil, parent = nil }

local function Skin(frame, r, g, b, a)
  frame:SetBackdrop(BACKDROP)
  frame:SetBackdropColor(r or 0.06, g or 0.06, b or 0.08, a or 0.94)
  frame:SetBackdropBorderColor(0.35, 0.3, 0.2, 1)
end

local function Font(parent, size, flags)
  local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fs:SetFont((GameFontNormal:GetFont()), size or 12, flags)
  fs:SetTextColor(1, 0.82, 0)
  fs:SetJustifyH("LEFT")
  return fs
end

local function Button(parent, text, w, h, onClick)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(w or 100, h or 22)
  b:SetText(text or "")
  if onClick then
    b:SetScript("OnClick", onClick)
  end
  return b
end

local function MakeMovable(frame, dbKey, lockedFn)
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:SetClampedToScreen(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function(self)
    if lockedFn and lockedFn() then
      return
    end
    self:StartMoving()
  end)
  frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local db = ns.DB()
    if not db or not db[dbKey] then
      return
    end
    local point, _, _, x, y = self:GetPoint()
    db[dbKey].point = point
    db[dbKey].x = x
    db[dbKey].y = y
  end)
end

local function ApplyPoint(frame, info, defaultPoint, defaultX, defaultY)
  frame:ClearAllPoints()
  if info and info.point then
    frame:SetPoint(info.point, UIParent, info.point, info.x or 0, info.y or 0)
  else
    frame:SetPoint(defaultPoint, defaultX or 0, defaultY or 0)
  end
end

-- Own-interrupt cooldown: swirl always (secrets allowed into Cooldown APIs).
-- Numeric remaining time only when the value is not secret.
function ns.ReadOwnCooldownRemaining(spellID)
  if not spellID or not C_Spell or not C_Spell.GetSpellCooldown then
    return nil
  end
  if ns.CooldownsRestricted(spellID) then
    return nil
  end
  local ok, info = pcall(C_Spell.GetSpellCooldown, spellID)
  if not ok or type(info) ~= "table" then
    return nil
  end
  local start, duration = info.startTime, info.duration
  if ns.IsSecret(start) or ns.IsSecret(duration) then
    return nil
  end
  if type(start) ~= "number" or type(duration) ~= "number" or duration <= 0 then
    return 0
  end
  local remain = start + duration - ns.Now()
  if remain < 0 then
    return 0
  end
  return remain
end

function ns.ApplyCooldownSwirl(cooldownFrame, spellID)
  if not cooldownFrame or not spellID then
    return
  end
  if not C_Spell or not C_Spell.GetSpellCooldown then
    return
  end
  local ok, info = pcall(C_Spell.GetSpellCooldown, spellID)
  if not ok or type(info) ~= "table" then
    return
  end
  -- Pass values through even if they are secret; do not inspect them.
  if cooldownFrame.SetCooldown then
    pcall(cooldownFrame.SetCooldown, cooldownFrame, info.startTime, info.duration)
  end
end

local function FormatRemain(secs)
  if type(secs) ~= "number" then
    return "—"
  end
  if secs <= 0 then
    return "ready"
  end
  if secs >= 10 then
    return string.format("%ds", math.floor(secs + 0.5))
  end
  return string.format("%.1fs", secs)
end

-- ---------------------------------------------------------------------------
-- Kick bar
-- ---------------------------------------------------------------------------
local barLines = {}

local function BuildBar()
  bar = CreateFrame("Frame", "KickBossNotesBar", UIParent, "BackdropTemplate")
  bar:SetSize(BAR_W, BAR_H)
  bar:SetFrameStrata("MEDIUM")
  Skin(bar)
  MakeMovable(bar, "bar", function()
    local db = ns.DB()
    return db and db.bar and db.bar.locked
  end)

  bar.title = Font(bar, 13)
  bar.title:SetPoint("TOPLEFT", 10, -8)
  bar.title:SetText("Kick Order")

  bar.status = Font(bar, 10)
  bar.status:SetPoint("TOPRIGHT", -10, -8)
  bar.status:SetTextColor(0.75, 0.75, 0.75)

  bar.kickBtn = Button(bar, "I Kicked", 90, 22, function()
    ns.PlayerKicked()
  end)
  bar.kickBtn:SetPoint("BOTTOMLEFT", 8, 8)

  bar.assignBtn = Button(bar, "Assign", 70, 22, function()
    ns.ShowConfig("assign")
  end)
  bar.assignBtn:SetPoint("LEFT", bar.kickBtn, "RIGHT", 6, 0)

  bar.notesBtn = Button(bar, "Notes", 70, 22, function()
    ns.ShowNotes()
  end)
  bar.notesBtn:SetPoint("LEFT", bar.assignBtn, "RIGHT", 6, 0)

  bar.hideBtn = Button(bar, "Hide", 50, 22, function()
    ns.ToggleBar()
  end)
  bar.hideBtn:SetPoint("BOTTOMRIGHT", -8, 8)

  local container = CreateFrame("Frame", nil, bar)
  container:SetPoint("TOPLEFT", 8, -26)
  container:SetPoint("BOTTOMRIGHT", -8, 34)
  bar.container = container

  for i = 1, 3 do
    local line = CreateFrame("Frame", nil, container, "BackdropTemplate")
    line:SetHeight(32)
    line:SetPoint("TOPLEFT", 0, -((i - 1) * 34))
    line:SetPoint("TOPRIGHT", 0, -((i - 1) * 34))
    Skin(line, 0.1, 0.1, 0.12, 0.8)
    line.icon = line:CreateTexture(nil, "ARTWORK")
    line.icon:SetSize(16, 16)
    line.icon:SetPoint("LEFT", 6, 0)
    line.label = Font(line, 11)
    line.label:SetPoint("LEFT", line.icon, "RIGHT", 4, 0)
    line.label:SetWidth(54)
    line.order = Font(line, 11)
    line.order:SetPoint("LEFT", line.label, "RIGHT", 4, 0)
    line.order:SetPoint("RIGHT", -6, 0)
    line.order:SetTextColor(1, 1, 1)
    line.cd = CreateFrame("Cooldown", nil, line, "CooldownFrameTemplate")
    line.cd:SetPoint("RIGHT", -4, 0)
    line.cd:SetSize(20, 20)
    line.cd:SetHideCountdownNumbers(true)
    barLines[i] = line
  end

  bar:Hide()
end

function ns.RefreshBar()
  if not bar then
    return
  end
  local db = ns.DB()
  if not db or db.showBar == false then
    bar:Hide()
    return
  end
  local order = ns.GetOrder()
  local visible = 0
  for i = 1, 3 do
    local group = order.groups[i]
    local line = barLines[i]
    if group and #group.members > 0 then
      visible = visible + 1
      line:Show()
      local marker = ns.MarkerInfo(group.marker)
      if marker.id ~= 0 then
        line.icon:SetTexture(ns.MarkerIcon(marker.id))
        line.icon:Show()
      else
        line.icon:Hide()
      end
      line.label:SetText("Grp " .. group.label)
      local parts = {}
      local nextIdx = group.nextIndex or 1
      for idx, member in ipairs(group.members) do
        local name = ns.ShortName(member.fullName)
        local colored = ns.ColorText(member.classFile, name)
        local suffix = ""
        if ns.SameName(member.fullName, ns.PlayerFullName()) then
          local remain = ns.ReadOwnCooldownRemaining(member.spellID)
          if remain == nil then
            remain = ns.EstimatedRemaining(member.fullName)
            if remain and remain > 0 then
              suffix = " (~" .. FormatRemain(remain) .. ")"
            elseif remain == 0 then
              suffix = ""
            end
            if member.spellID then
              ns.ApplyCooldownSwirl(line.cd, member.spellID)
            end
          else
            if remain > 0 then
              suffix = " (" .. FormatRemain(remain) .. ")"
            end
            ns.ApplyCooldownSwirl(line.cd, member.spellID)
          end
        else
          local remain = ns.EstimatedRemaining(member.fullName)
          if remain and remain > 0 then
            suffix = " (~" .. FormatRemain(remain) .. ")"
          end
        end
        if idx == nextIdx then
          parts[#parts + 1] = "|cffffd100> " .. colored .. suffix .. "|r"
        else
          parts[#parts + 1] = colored .. suffix
        end
      end
      line.order:SetText(table.concat(parts, "  "))
    else
      line:Hide()
    end
  end
  if ns.InChatLockdown() then
    bar.status:SetText("|cffff8844" .. (ns.LockdownReason() or "Comms locked") .. "|r")
  elseif ns.PendingCommCount and ns.PendingCommCount() > 0 then
    bar.status:SetText("Sync queued")
  else
    bar.status:SetText("v" .. ns.VERSION)
  end
  local height = 70 + math.max(1, visible) * 34
  bar:SetHeight(height)
  if visible == 0 then
    -- Still show the bar so the player can open Assign.
    barLines[1]:Show()
    barLines[1].icon:Hide()
    barLines[1].label:SetText("Grp A")
    barLines[1].order:SetText("|cff888888No kick order yet — open Assign.|r")
  end
  bar:Show()
end

function ns.ToggleBar()
  local db = ns.DB()
  if not db then
    return
  end
  db.showBar = not (db.showBar ~= false)
  if db.showBar then
    ns.RefreshBar()
    bar:Show()
  else
    bar:Hide()
  end
end

-- ---------------------------------------------------------------------------
-- Notes panel
-- ---------------------------------------------------------------------------
local function SetNotesContent(boss, parent, kind)
  notesState.boss = boss
  notesState.parent = parent
  notesState.kind = kind
  notesState.key = ns.BossKey(boss, parent)
  if notes.edit then
    notes.edit:SetText(ns.CustomNote(notesState.key))
  end
  ns.RefreshNotes()
end

local function BuildNotes()
  notes = CreateFrame("Frame", "KickBossNotesPanel", UIParent, "BackdropTemplate")
  notes:SetSize(NOTES_W, NOTES_H)
  notes:SetFrameStrata("HIGH")
  Skin(notes)
  MakeMovable(notes, "notesFrame", function()
    local db = ns.DB()
    return db and db.notesFrame and db.notesFrame.locked
  end)

  notes.title = Font(notes, 14)
  notes.title:SetPoint("TOPLEFT", 12, -10)
  notes.title:SetText("Boss Notes")

  notes.role = Font(notes, 11)
  notes.role:SetPoint("TOPRIGHT", -80, -10)
  notes.role:SetTextColor(0.8, 0.8, 0.8)

  notes.close = Button(notes, "X", 22, 22, function()
    notes:Hide()
  end)
  notes.close:SetPoint("TOPRIGHT", -8, -8)

  notes.picker = Button(notes, "Browse bosses...", 200, 22, function()
    ns.ToggleBossPicker()
  end)
  notes.picker:SetPoint("TOPLEFT", 12, -34)

  notes.pickerMenu = CreateFrame("Frame", nil, notes, "BackdropTemplate")
  notes.pickerMenu:SetPoint("TOPLEFT", notes.picker, "BOTTOMLEFT", 0, -2)
  notes.pickerMenu:SetSize(300, 280)
  Skin(notes.pickerMenu, 0.08, 0.08, 0.1, 0.98)
  notes.pickerMenu:SetFrameStrata("DIALOG")
  notes.pickerMenu:Hide()
  notes.pickerMenu.buttons = {}

  local scroll = CreateFrame("ScrollFrame", "KickBossNotesScroll", notes, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", 12, -64)
  scroll:SetPoint("BOTTOMRIGHT", -30, 90)
  notes.scroll = scroll

  local child = CreateFrame("Frame", nil, scroll)
  child:SetSize(NOTES_W - 44, 800)
  scroll:SetScrollChild(child)
  notes.body = Font(child, 12)
  notes.body:SetPoint("TOPLEFT", 0, 0)
  notes.body:SetWidth(NOTES_W - 50)
  notes.body:SetJustifyH("LEFT")
  notes.body:SetTextColor(0.95, 0.95, 0.9)
  notes.bodyFrame = child

  local customLabel = Font(notes, 11)
  customLabel:SetPoint("BOTTOMLEFT", 12, 64)
  customLabel:SetText("Your note")

  local editBox = CreateFrame("EditBox", nil, notes, "InputBoxTemplate")
  editBox:SetAutoFocus(false)
  editBox:SetMultiLine(false)
  editBox:SetMaxLetters(500)
  editBox:SetHeight(24)
  editBox:SetPoint("BOTTOMLEFT", 16, 36)
  editBox:SetPoint("BOTTOMRIGHT", -16, 36)
  editBox:SetScript("OnEnterPressed", function(self)
    if notesState.key then
      ns.SetCustomNote(notesState.key, self:GetText())
    end
    self:ClearFocus()
  end)
  editBox:SetScript("OnEscapePressed", function(self)
    self:ClearFocus()
  end)
  notes.edit = editBox

  notes.save = Button(notes, "Save note", 90, 22, function()
    if notesState.key then
      ns.SetCustomNote(notesState.key, notes.edit:GetText())
      ns.Print("Saved your note for this boss.")
    end
  end)
  notes.save:SetPoint("BOTTOMLEFT", 12, 8)

  notes:Hide()
end

local function BulletBlock(title, list)
  if not list or #list == 0 then
    return ""
  end
  local lines = { "|cffffd100" .. title .. "|r" }
  for _, item in ipairs(list) do
    lines[#lines + 1] = "  • " .. item
  end
  return table.concat(lines, "\n")
end

function ns.RefreshNotes()
  if not notes then
    return
  end
  local role = ns.PlayerRole()
  notes.role:SetText(ns.RoleLabel(role))
  local boss, parent, kind = notesState.boss, notesState.parent, notesState.kind
  if not boss then
    notes.title:SetText("Boss Notes")
    notes.picker:SetText("Browse bosses...")
    local dungeon = ns.GetCurrentDungeon()
    local text = "|cffffd100Select a boss, or target one when names are available.|r\n\n"
    if dungeon then
      text = text .. "|cffffd100" .. dungeon.name .. " — kick priorities|r\n"
      for _, kick in ipairs(dungeon.kicks or {}) do
        text = text .. string.format("  • [%s] %s — %s (%s)\n", kick.priority, kick.spell, kick.caster, kick.note or "")
      end
      if dungeon.extras then
        text = text .. "\n|cffffd100Also|r\n"
        for _, extra in ipairs(dungeon.extras) do
          text = text .. "  • " .. extra .. "\n"
        end
      end
    else
      text = text .. "When you zone into a Season 2 dungeon, that dungeon's interrupt list appears here automatically."
    end
    notes.body:SetText(text)
    notes.bodyFrame:SetHeight(math.max(200, notes.body:GetStringHeight() + 20))
    return
  end
  local title = boss.name
  if parent and parent.name then
    title = boss.name .. "  |cffaaaaaa(" .. parent.name .. ")|r"
  end
  notes.title:SetText("Boss Notes")
  notes.picker:SetText(boss.name)
  local n = boss.notes or {}
  local parts = {}
  if kind == "dungeon" then
    -- Brief dungeon boss notes plus the dungeon kick list.
    parts[#parts + 1] = BulletBlock("General", n.general)
    parts[#parts + 1] = BulletBlock(ns.RoleLabel(role), role == "TANK" and n.tank or (role == "HEALER" and n.healer or n.dps))
    if parent and parent.kicks then
      local kicks = {}
      for _, kick in ipairs(parent.kicks) do
        kicks[#kicks + 1] = string.format("[%s] %s — %s. %s", kick.priority, kick.spell, kick.caster, kick.note or "")
      end
      parts[#parts + 1] = BulletBlock("Dungeon kick priorities", kicks)
    end
  else
    parts[#parts + 1] = BulletBlock("General", n.general)
    if role == "TANK" then
      parts[#parts + 1] = BulletBlock("Tank", n.tank)
    elseif role == "HEALER" then
      parts[#parts + 1] = BulletBlock("Healer", n.healer)
    else
      parts[#parts + 1] = BulletBlock("DPS", n.dps)
    end
    -- Offer the other roles as a shorter reference at the bottom? Keep it tight: only current role + general.
  end
  local custom = ns.CustomNote(notesState.key)
  if custom and custom ~= "" then
    parts[#parts + 1] = "|cff7ec8ffYour note|r\n  • " .. custom
  end
  notes.body:SetText(table.concat(parts, "\n\n"))
  notes.bodyFrame:SetHeight(math.max(200, notes.body:GetStringHeight() + 20))
end

function ns.ToggleBossPicker()
  if not notes or not notes.pickerMenu then
    return
  end
  if notes.pickerMenu:IsShown() then
    notes.pickerMenu:Hide()
    return
  end
  local entries = ns.AllBossEntries()
  local y = -6
  for i, entry in ipairs(entries) do
    local b = notes.pickerMenu.buttons[i]
    if not b then
      b = CreateFrame("Button", nil, notes.pickerMenu)
      b:SetHeight(18)
      b:SetPoint("LEFT", 6, 0)
      b:SetPoint("RIGHT", -6, 0)
      b.text = Font(b, 11)
      b.text:SetPoint("LEFT", 2, 0)
      b.text:SetTextColor(1, 1, 1)
      b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
      b:SetScript("OnClick", function(self)
        SetNotesContent(self.entry.boss, self.entry.parent, self.entry.kind)
        notes.pickerMenu:Hide()
      end)
      notes.pickerMenu.buttons[i] = b
    end
    b.entry = entry
    local prefix = entry.kind == "raid" and "|cffff8040Raid|r  " or "|cff80c0ffM+|r  "
    b.text:SetText(prefix .. entry.boss.name .. "  |cff888888" .. (entry.parent.name or "") .. "|r")
    b:ClearAllPoints()
    b:SetPoint("TOPLEFT", 6, y)
    b:SetPoint("TOPRIGHT", -6, y)
    b:Show()
    y = y - 18
  end
  for i = #entries + 1, #notes.pickerMenu.buttons do
    notes.pickerMenu.buttons[i]:Hide()
  end
  notes.pickerMenu:SetHeight(math.min(300, 12 + #entries * 18))
  notes.pickerMenu:Show()
end

function ns.ShowBossNotes(name, auto)
  local boss, parent = ns.FindBoss(name)
  if not boss then
    return false
  end
  local kind = "raid"
  for _, dungeon in ipairs(ns.DUNGEONS or {}) do
    if parent == dungeon then
      kind = "dungeon"
      break
    end
  end
  SetNotesContent(boss, parent, kind)
  notes:Show()
  return true
end

function ns.ShowNotes()
  if not notes then
    return
  end
  if notes:IsShown() then
    notes:Hide()
    return
  end
  ns.RefreshNotes()
  notes:Show()
end

function ns.ToggleNotes()
  ns.ShowNotes()
end

function ns.OnEncounterStart(_, encounterName)
  encounterName = ns.Plain(encounterName)
  local db = ns.DB()
  if not db or db.autoShowNotes == false then
    return
  end
  if type(encounterName) == "string" then
    ns.ShowBossNotes(encounterName, true)
  end
end

function ns.OnEncounterEnd()
  ns.FlushComm()
end

function ns.OnTargetChanged()
  local db = ns.DB()
  if not db or db.autoShowNotes == false then
    return
  end
  local name = ns.PlainCall(UnitName, "target")
  if type(name) == "string" and name ~= "" then
    ns.ShowBossNotes(name, true)
  end
end

-- ---------------------------------------------------------------------------
-- Config window
-- ---------------------------------------------------------------------------
local tabs = {}
local pages = {}

local function ShowTab(name)
  for key, page in pairs(pages) do
    if key == name then
      page:Show()
    else
      page:Hide()
    end
  end
  for key, tab in pairs(tabs) do
    if key == name then
      tab:LockHighlight()
    else
      tab:UnlockHighlight()
    end
  end
  if name == "assign" and ns.RefreshAssignUI then
    ns.RefreshAssignUI()
  elseif name == "notes" then
    ns.RefreshNotes()
  end
end

local rosterButtons, groupButtons = {}, {}
local groupSelect

local function BuildAssignPage(parent)
  local page = CreateFrame("Frame", nil, parent)
  page:SetAllPoints()
  pages.assign = page

  local hint = Font(page, 11)
  hint:SetPoint("TOPLEFT", 16, -46)
  hint:SetPoint("TOPRIGHT", -16, -46)
  hint:SetTextColor(0.8, 0.8, 0.8)
  page.hint = hint

  -- Roster
  local rosterFrame = CreateFrame("Frame", nil, page, "BackdropTemplate")
  rosterFrame:SetPoint("TOPLEFT", 16, -70)
  rosterFrame:SetSize(340, 420)
  Skin(rosterFrame, 0.08, 0.08, 0.1, 0.9)
  local rt = Font(rosterFrame, 12)
  rt:SetPoint("TOPLEFT", 8, -8)
  rt:SetText("Group roster")
  page.rosterFrame = rosterFrame

  -- Groups
  local groupFrame = CreateFrame("Frame", nil, page, "BackdropTemplate")
  groupFrame:SetPoint("TOPLEFT", rosterFrame, "TOPRIGHT", 12, 0)
  groupFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -16, 58)
  Skin(groupFrame, 0.08, 0.08, 0.1, 0.9)
  page.groupFrame = groupFrame

  local gt = Font(groupFrame, 12)
  gt:SetPoint("TOPLEFT", 8, -8)
  gt:SetText("Kick groups")

  groupSelect = {}
  for i = 1, 3 do
    local b = Button(groupFrame, "Group " .. ns.GROUP_LABELS[i], 80, 22, function()
      assignState.group = i
      ns.RefreshAssignUI()
    end)
    b:SetPoint("TOPLEFT", 8 + (i - 1) * 86, -28)
    groupSelect[i] = b
  end

  page.markerBtn = Button(groupFrame, "Marker: Skull", 140, 22, function()
    ns.CycleGroupMarker()
  end)
  page.markerBtn:SetPoint("TOPRIGHT", -8, -28)

  page.addBtn = Button(groupFrame, "Add selected", 110, 22, function()
    if assignState.selected then
      ns.AddToGroup(assignState.group, assignState.selected)
    end
  end)
  page.addBtn:SetPoint("BOTTOMLEFT", 8, 8)

  page.upBtn = Button(groupFrame, "Up", 50, 22, function()
    if assignState.selected then
      ns.MoveInGroup(assignState.group, assignState.selected, -1)
    end
  end)
  page.upBtn:SetPoint("LEFT", page.addBtn, "RIGHT", 6, 0)

  page.downBtn = Button(groupFrame, "Down", 50, 22, function()
    if assignState.selected then
      ns.MoveInGroup(assignState.group, assignState.selected, 1)
    end
  end)
  page.downBtn:SetPoint("LEFT", page.upBtn, "RIGHT", 4, 0)

  page.removeBtn = Button(groupFrame, "Remove", 70, 22, function()
    if assignState.selected then
      ns.RemoveFromGroup(assignState.group, assignState.selected)
    end
  end)
  page.removeBtn:SetPoint("LEFT", page.downBtn, "RIGHT", 4, 0)

  page.clearBtn = Button(groupFrame, "Clear", 60, 22, function()
    ns.ClearGroup(assignState.group)
  end)
  page.clearBtn:SetPoint("BOTTOMRIGHT", -8, 8)
end

function ns.CycleGroupMarker()
  if not ns.CanEditOrder() then
    ns.Print("Only the group leader or a raid assistant can change markers in a raid.")
    return
  end
  local group = ns.GetOrder().groups[assignState.group]
  if not group then
    return
  end
  local current = group.marker or 0
  local idx = 1
  for i, m in ipairs(ns.MARKERS) do
    if m.id == current then
      idx = i
      break
    end
  end
  idx = idx + 1
  if idx > #ns.MARKERS then
    idx = 1
  end
  ns.SetGroupMarker(assignState.group, ns.MARKERS[idx].id)
end

local function FillButtonList(parent, store, count, width, height, onClick)
  while #store < count do
    local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
    b:SetSize(width, height)
    Skin(b, 0.12, 0.12, 0.14, 0.9)
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetSize(14, 14)
    b.icon:SetPoint("LEFT", 6, 0)
    b.text = Font(b, 11)
    b.text:SetPoint("LEFT", 24, 0)
    b.text:SetPoint("RIGHT", -6, 0)
    b.text:SetTextColor(1, 1, 1)
    b:SetScript("OnClick", onClick)
    b:SetScript("OnEnter", function(self)
      if self.tooltip then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(self.tooltip, 1, 1, 1, 1, true)
        GameTooltip:Show()
      end
    end)
    b:SetScript("OnLeave", function()
      GameTooltip:Hide()
    end)
    store[#store + 1] = b
  end
end

function ns.RefreshAssignUI()
  if not pages.assign or not pages.assign:IsShown() then
    -- Still update hint if hidden? Skip.
  end
  if not config or not pages.assign then
    return
  end
  local page = pages.assign
  local lockdown = ns.InChatLockdown()
  local reason = ns.LockdownReason()
  local who = ns.CanEditOrder() and "You can edit and share the order." or "Leader or assistant must change the raid kick order. You can still click I Kicked."
  if lockdown then
    page.hint:SetText("|cffff8844Comms locked: " .. (reason or "encounter or M+") .. ".|r Order changes stay local and will sync when the lock ends. " .. who)
  else
    local pending = ns.PendingCommCount and ns.PendingCommCount() or 0
    local extra = pending > 0 and (" " .. pending .. " message(s) queued.") or ""
    page.hint:SetText("Syncs to party and raid members who also run this addon. " .. who .. extra)
  end

  local roster = ns.GetRoster()
  FillButtonList(page.rosterFrame, rosterButtons, #roster, 324, 26, function(self)
    assignState.selected = self.fullName
    ns.RefreshAssignUI()
  end)
  for i, row in ipairs(roster) do
    local b = rosterButtons[i]
    b:Show()
    b:ClearAllPoints()
    b:SetPoint("TOPLEFT", 8, -28 - (i - 1) * 28)
    b.fullName = row.fullName
    b.icon:Hide()
    local kickName = (row.kick and row.kick.spell) or "No kick"
    local peer = ns.GetPeer(row.fullName)
    local addonTag
    if row.isPlayer then
      addonTag = "you  v" .. ns.VERSION
    elseif peer then
      addonTag = "KBN v" .. (peer.version or "?")
    else
      addonTag = "|cff888888no addon|r"
    end
    b.text:SetText(ns.ColorText(row.classFile, ns.ShortName(row.fullName)) .. "  |cffcccccc" .. kickName .. "|r  " .. addonTag)
    b.tooltip = (row.kick and row.kick.note) or kickName
    if ns.SameName(row.fullName, assignState.selected) then
      b:SetBackdropColor(0.3, 0.25, 0.1, 1)
    else
      b:SetBackdropColor(0.12, 0.12, 0.14, 0.9)
    end
  end
  for i = #roster + 1, #rosterButtons do
    rosterButtons[i]:Hide()
  end

  local group = ns.GetOrder().groups[assignState.group]
  local marker = ns.MarkerInfo(group and group.marker or 0)
  if page.markerBtn then
    page.markerBtn:SetText("Marker: " .. marker.name)
  end
  for i, b in ipairs(groupSelect or {}) do
    if i == assignState.group then
      b:LockHighlight()
    else
      b:UnlockHighlight()
    end
  end
  local members = (group and group.members) or {}
  FillButtonList(page.groupFrame, groupButtons, #members, 430, 26, function(self)
    assignState.selected = self.fullName
    ns.RefreshAssignUI()
  end)
  for i, member in ipairs(members) do
    local b = groupButtons[i]
    b:Show()
    b:ClearAllPoints()
    b:SetPoint("TOPLEFT", 8, -60 - (i - 1) * 28)
    b.fullName = member.fullName
    if group.marker ~= 0 and i == 1 then
      b.icon:SetTexture(ns.MarkerIcon(group.marker))
      b.icon:Show()
    else
      b.icon:Hide()
    end
    local nextMark = (i == (group.nextIndex or 1)) and "|cffffd100NEXT|r  " or ""
    local spell = member.spell or ""
    b.text:SetText(nextMark .. i .. ". " .. ns.ColorText(member.classFile, ns.ShortName(member.fullName)) .. "  |cffcccccc" .. spell .. "|r")
    if ns.SameName(member.fullName, assignState.selected) then
      b:SetBackdropColor(0.3, 0.25, 0.1, 1)
    else
      b:SetBackdropColor(0.12, 0.12, 0.14, 0.9)
    end
  end
  for i = #members + 1, #groupButtons do
    groupButtons[i]:Hide()
  end
end

local function BuildNotesPage(parent)
  local page = CreateFrame("Frame", nil, parent)
  page:SetAllPoints()
  pages.notes = page
  local hint = Font(page, 12)
  hint:SetPoint("TOPLEFT", 20, -60)
  hint:SetWidth(820)
  hint:SetText("The notes panel can also be opened from the kick bar or with /kbn notes. It pops up when a boss encounter starts (if the name is not hidden by Midnight) or when you target a boss out of a restricted instance. Use Browse to open any boss by hand.")
  hint:SetTextColor(0.85, 0.85, 0.8)
  local open = Button(page, "Open notes panel", 160, 24, function()
    if notes then
      notes:Show()
      ns.RefreshNotes()
    end
  end)
  open:SetPoint("TOPLEFT", 20, -130)
end

local function BuildOptionsPage(parent)
  local page = CreateFrame("Frame", nil, parent)
  page:SetAllPoints()
  pages.options = page

  local y = -70
  local function Check(label, getter, setter)
    local c = CreateFrame("CheckButton", nil, page, "UICheckButtonTemplate")
    c:SetPoint("TOPLEFT", 24, y)
    c.text = c:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    c.text:SetPoint("LEFT", c, "RIGHT", 4, 0)
    c.text:SetText(label)
    c:SetScript("OnShow", function(self)
      self:SetChecked(getter())
    end)
    c:SetScript("OnClick", function(self)
      setter(self:GetChecked())
    end)
    y = y - 32
    return c
  end

  Check("Show kick bar", function()
    local db = ns.DB()
    return not db or db.showBar ~= false
  end, function(val)
    local db = ns.DB()
    if db then
      db.showBar = val and true or false
    end
    ns.RefreshBar()
  end)

  Check("Lock frames (bar and notes)", function()
    local db = ns.DB()
    return db and db.bar and db.bar.locked
  end, function(val)
    local db = ns.DB()
    if db then
      db.bar.locked = val and true or false
      db.notesFrame.locked = val and true or false
    end
  end)

  Check("Auto-show notes on encounter start or target", function()
    local db = ns.DB()
    return not db or db.autoShowNotes ~= false
  end, function(val)
    local db = ns.DB()
    if db then
      db.autoShowNotes = val and true or false
    end
  end)

  Check("Show minimap button", function()
    local db = ns.DB()
    return not (db and db.minimap and db.minimap.hide)
  end, function(val)
    local db = ns.DB()
    if db then
      db.minimap = db.minimap or {}
      db.minimap.hide = not val
    end
    if minimapBtn then
      if val then
        minimapBtn:Show()
      else
        minimapBtn:Hide()
      end
    end
  end)

  local scaleLabel = Font(page, 12)
  scaleLabel:SetPoint("TOPLEFT", 28, y - 8)
  scaleLabel:SetText("Kick bar scale")
  y = y - 28
  local slider = CreateFrame("Slider", "KickBossNotesScaleSlider", page, "OptionsSliderTemplate")
  slider:SetPoint("TOPLEFT", 30, y)
  slider:SetMinMaxValues(0.7, 1.6)
  slider:SetValueStep(0.05)
  slider:SetObeyStepOnDrag(true)
  slider:SetWidth(220)
  slider:SetScript("OnShow", function(self)
    local db = ns.DB()
    self:SetValue((db and db.bar and db.bar.scale) or 1)
  end)
  slider:SetScript("OnValueChanged", function(_, value)
    local db = ns.DB()
    if db and db.bar then
      db.bar.scale = value
    end
    if bar then
      bar:SetScale(value)
    end
  end)
  y = y - 50

  local notesScaleLabel = Font(page, 12)
  notesScaleLabel:SetPoint("TOPLEFT", 28, y)
  notesScaleLabel:SetText("Notes panel scale")
  y = y - 20
  local slider2 = CreateFrame("Slider", "KickBossNotesNotesScaleSlider", page, "OptionsSliderTemplate")
  slider2:SetPoint("TOPLEFT", 30, y)
  slider2:SetMinMaxValues(0.7, 1.6)
  slider2:SetValueStep(0.05)
  slider2:SetObeyStepOnDrag(true)
  slider2:SetWidth(220)
  slider2:SetScript("OnShow", function(self)
    local db = ns.DB()
    self:SetValue((db and db.notesFrame and db.notesFrame.scale) or 1)
  end)
  slider2:SetScript("OnValueChanged", function(_, value)
    local db = ns.DB()
    if db and db.notesFrame then
      db.notesFrame.scale = value
    end
    if notes then
      notes:SetScale(value)
    end
  end)

  local about = Font(page, 11)
  about:SetPoint("TOPLEFT", 28, y - 60)
  about:SetWidth(800)
  about:SetTextColor(0.8, 0.8, 0.8)
  about:SetText("Clayton's Kick & Boss Notes is display-only. It never casts or automates combat.\n\nIn Midnight, addons cannot read the combat log, and they cannot compare enemy casts, other players' cooldowns, or NPC names during a dungeon or raid lockdown. The kick order is set out of combat (or between bosses) and shown as a static rotation. Click I Kicked to advance it. Your own interrupt cooldown swirl still displays; the number is shown only when Blizzard allows it. Other players' timers are estimates from that button.\n\nAddon messages (prefix KBNKICK) sync the order in party, raid, and instance groups, but Blizzard blocks those messages during a boss encounter or a Mythic+ run. They are queued and sent when the lock ends.")
end

local function BuildConfig()
  config = CreateFrame("Frame", "KickBossNotesConfig", UIParent, "BackdropTemplate")
  config:SetSize(CFG_W, CFG_H)
  config:SetFrameStrata("DIALOG")
  Skin(config)
  MakeMovable(config, "config", function()
    return false
  end)
  config:Hide()
  tinsert(UISpecialFrames, "KickBossNotesConfig")

  local title = Font(config, 16)
  title:SetPoint("TOPLEFT", 16, -14)
  title:SetText(ns.TITLE)

  local close = Button(config, "Close", 70, 22, function()
    config:Hide()
  end)
  close:SetPoint("TOPRIGHT", -12, -12)

  local tabDefs = {
    { key = "assign", label = "Assign" },
    { key = "notes", label = "Notes" },
    { key = "options", label = "Options" },
  }
  for i, def in ipairs(tabDefs) do
    local tab = Button(config, def.label, 90, 24, function()
      ShowTab(def.key)
    end)
    tab:SetPoint("TOPLEFT", 16 + (i - 1) * 96, -40)
    tabs[def.key] = tab
  end

  BuildAssignPage(config)
  BuildNotesPage(config)
  BuildOptionsPage(config)

  -- Footer actions on every tab
  local auto = Button(config, "Auto-fill party", 120, 24, function()
    ns.AutoFillPartyOrder()
    ns.RefreshAssignUI()
  end)
  auto:SetPoint("BOTTOMLEFT", 16, 16)

  local share = Button(config, "Share order", 110, 24, function()
    ns.ShareOrder(true)
  end)
  share:SetPoint("LEFT", auto, "RIGHT", 8, 0)

  local post = Button(config, "Post kick order to party/raid", 200, 24, function()
    ns.PostOrderToChat()
  end)
  post:SetPoint("LEFT", share, "RIGHT", 8, 0)

  local sync = Button(config, "Request sync", 110, 24, function()
    ns.RequestSync(true)
    ns.SendPresence()
    ns.Print("Sync requested.")
  end)
  sync:SetPoint("LEFT", post, "RIGHT", 8, 0)

  ShowTab("assign")
end

-- ---------------------------------------------------------------------------
-- Minimap button
-- ---------------------------------------------------------------------------
local function BuildMinimap()
  local btn = CreateFrame("Button", "KickBossNotesMinimapButton", Minimap)
  btn:SetSize(32, 32)
  btn:SetFrameStrata("MEDIUM")
  btn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
  local icon = btn:CreateTexture(nil, "BACKGROUND")
  icon:SetTexture("Interface\\Icons\\Ability_Kick")
  icon:SetSize(20, 20)
  icon:SetPoint("CENTER")
  local border = btn:CreateTexture(nil, "OVERLAY")
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  border:SetSize(54, 54)
  border:SetPoint("TOPLEFT")
  btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  btn:RegisterForDrag("LeftButton")
  btn:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", function(s)
      local mx, my = Minimap:GetCenter()
      local cx, cy = GetCursorPosition()
      local scale = Minimap:GetEffectiveScale()
      cx, cy = cx / scale, cy / scale
      local angle = math.deg(math.atan2(cy - my, cx - mx))
      local db = ns.DB()
      if db and db.minimap then
        db.minimap.angle = angle
      end
      ns.UpdateMinimap()
    end)
  end)
  btn:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
  end)
  btn:SetScript("OnClick", function(_, button)
    if button == "RightButton" then
      ns.ToggleBar()
    else
      ns.ToggleConfig()
    end
  end)
  btn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText(ns.TITLE, 1, 0.82, 0)
    GameTooltip:AddLine("Left-click: assignments and notes", 1, 1, 1)
    GameTooltip:AddLine("Right-click: toggle kick bar", 1, 1, 1)
    GameTooltip:Show()
  end)
  btn:SetScript("OnLeave", function()
    GameTooltip:Hide()
  end)
  minimapBtn = btn
end

function ns.UpdateMinimap()
  if not minimapBtn then
    return
  end
  local db = ns.DB()
  if db and db.minimap and db.minimap.hide then
    minimapBtn:Hide()
    return
  end
  minimapBtn:Show()
  local angle = (db and db.minimap and db.minimap.angle) or 200
  local rad = math.rad(angle)
  local radius = (Minimap:GetWidth() / 2) + 10
  minimapBtn:ClearAllPoints()
  minimapBtn:SetPoint("CENTER", Minimap, "CENTER", math.cos(rad) * radius, math.sin(rad) * radius)
end

-- ---------------------------------------------------------------------------
-- Public
-- ---------------------------------------------------------------------------
function ns.ApplyFramePositions()
  local db = ns.DB()
  if bar then
    ApplyPoint(bar, db and db.bar, "BOTTOM", 0, 220)
    bar:SetScale((db and db.bar and db.bar.scale) or 1)
  end
  if notes then
    ApplyPoint(notes, db and db.notesFrame, "RIGHT", -80, 40)
    notes:SetScale((db and db.notesFrame and db.notesFrame.scale) or 1)
  end
  if config then
    ApplyPoint(config, db and db.config, "CENTER", 0, 0)
  end
  ns.UpdateMinimap()
end

function ns.ToggleLock()
  local db = ns.DB()
  if not db then
    return
  end
  local locked = not (db.bar and db.bar.locked)
  db.bar.locked = locked
  db.notesFrame.locked = locked
  ns.Print(locked and "Frames locked." or "Frames unlocked. Drag to move.")
end

function ns.ShowConfig(tab)
  if not config then
    return
  end
  config:Show()
  if tab then
    ShowTab(tab)
  end
  ns.RefreshAssignUI()
end

function ns.ToggleConfig()
  if not config then
    return
  end
  if config:IsShown() then
    config:Hide()
  else
    ns.ShowConfig("assign")
  end
end

function ns.RefreshAllUI()
  ns.RefreshBar()
  if notes and notes:IsShown() then
    ns.RefreshNotes()
  end
  if config and config:IsShown() then
    ns.RefreshAssignUI()
  end
end

function ns.InitUI()
  BuildBar()
  BuildNotes()
  BuildConfig()
  BuildMinimap()
  ns.ApplyFramePositions()
  ns.RefreshBar()
end
