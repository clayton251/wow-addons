--[[
  Clayton's Kick & Boss Notes — core, SavedVariables, secret-safe helpers,
  slash commands, and event dispatch.

  This addon is display-only. It never casts, clicks, or automates gameplay.
]]

local ADDON, ns = ...
_G.KickBossNotes = ns

ns.ADDON_NAME = ADDON
ns.TITLE = "Clayton's Kick & Boss Notes"
ns.VERSION = "1.0.0"
ns.PROTO = 1
ns.PREFIX = "KBNKICK"

local db

local defaults = {
  version = 1,
  minimap = { hide = false, angle = 200 },
  bar = { point = "BOTTOM", x = 0, y = 220, scale = 1, locked = false, shown = true },
  notesFrame = { point = "RIGHT", x = -80, y = 40, scale = 1, locked = false },
  config = { point = "CENTER", x = 0, y = 0 },
  autoShowNotes = true,
  showBar = true,
  customNotes = {},
  lastOrder = nil,
}

function ns.CopyTable(src)
  if type(src) ~= "table" then
    return src
  end
  local dst = {}
  for k, v in pairs(src) do
    if type(v) == "table" then
      dst[k] = ns.CopyTable(v)
    else
      dst[k] = v
    end
  end
  return dst
end

local function MergeDefaults(dst, src)
  for k, v in pairs(src) do
    if type(v) == "table" then
      if type(dst[k]) ~= "table" then
        dst[k] = ns.CopyTable(v)
      else
        MergeDefaults(dst[k], v)
      end
    elseif dst[k] == nil then
      dst[k] = v
    end
  end
end

function ns.IsSecret(value)
  if value == nil or not issecretvalue then
    return false
  end
  local ok, secret = pcall(issecretvalue, value)
  return ok and secret and true or false
end

function ns.Plain(value)
  if value == nil or ns.IsSecret(value) then
    return nil
  end
  return value
end

function ns.SafeCall(fn, ...)
  if type(fn) ~= "function" then
    return nil
  end
  local ok, a, b, c, d, e, f = pcall(fn, ...)
  if not ok then
    return nil
  end
  return a, b, c, d, e, f
end

-- Return only non-secret values so callers can safely compare them.
function ns.PlainCall(fn, ...)
  local a, b, c, d, e, f = ns.SafeCall(fn, ...)
  if ns.IsSecret(a) then a = nil end
  if ns.IsSecret(b) then b = nil end
  if ns.IsSecret(c) then c = nil end
  if ns.IsSecret(d) then d = nil end
  if ns.IsSecret(e) then e = nil end
  if ns.IsSecret(f) then f = nil end
  return a, b, c, d, e, f
end

function ns.DB()
  return db
end

function ns.Now()
  return (GetTime and GetTime()) or 0
end

function ns.ServerNow()
  return (GetServerTime and GetServerTime()) or 0
end

function ns.InCombat()
  if InCombatLockdown and InCombatLockdown() then
    return true
  end
  local affecting = ns.PlainCall(UnitAffectingCombat, "player")
  return affecting and true or false
end

function ns.PartyCategoryInstance()
  if Enum and Enum.PartyCategory and Enum.PartyCategory.Instance then
    return Enum.PartyCategory.Instance
  end
  return LE_PARTY_CATEGORY_INSTANCE
end

function ns.IsInInstanceGroup()
  local inst = ns.PartyCategoryInstance()
  if inst and IsInGroup then
    return IsInGroup(inst) and true or false
  end
  return false
end

function ns.AddonChannel()
  if not IsInGroup or not IsInGroup() then
    return nil
  end
  if ns.IsInInstanceGroup() then
    return "INSTANCE_CHAT"
  end
  if IsInRaid and IsInRaid() then
    return "RAID"
  end
  return "PARTY"
end

function ns.ChatChannel()
  return ns.AddonChannel()
end

function ns.IsRaidGroup()
  return (IsInRaid and IsInRaid()) and true or false
end

function ns.IsLeaderOrAssist()
  if UnitIsGroupLeader and UnitIsGroupLeader("player") then
    return true
  end
  if UnitIsGroupAssistant and UnitIsGroupAssistant("player") then
    return true
  end
  -- In a 5-player party anyone may set and share the order.
  if IsInGroup and IsInGroup() and not ns.IsRaidGroup() then
    return true
  end
  -- Solo editing is always allowed (nothing to share).
  if not IsInGroup or not IsInGroup() then
    return true
  end
  return false
end

function ns.RestrictionActive(restrictionType)
  if not C_RestrictedActions or not C_RestrictedActions.IsAddOnRestrictionActive then
    return false
  end
  local active = ns.PlainCall(C_RestrictedActions.IsAddOnRestrictionActive, restrictionType)
  return active and true or false
end

function ns.InChatLockdown()
  if C_ChatInfo and C_ChatInfo.InChatMessagingLockdown then
    local restricted = ns.PlainCall(C_ChatInfo.InChatMessagingLockdown)
    if restricted then
      return true
    end
  end
  -- Fallback if the dedicated API is missing: encounter, M+, or PvP match.
  local types = Enum and Enum.AddOnRestrictionType
  if types then
    if types.Encounter and ns.RestrictionActive(types.Encounter) then
      return true
    end
    if types.ChallengeMode and ns.RestrictionActive(types.ChallengeMode) then
      return true
    end
    if types.PvPMatch and ns.RestrictionActive(types.PvPMatch) then
      return true
    end
  end
  return false
end

function ns.CooldownsRestricted(spellID)
  if C_Secrets and C_Secrets.ShouldSpellCooldownBeSecret and spellID then
    local secret = ns.PlainCall(C_Secrets.ShouldSpellCooldownBeSecret, spellID)
    if secret ~= nil then
      return secret and true or false
    end
  end
  if C_Secrets and C_Secrets.ShouldCooldownsBeSecret then
    local secret = ns.PlainCall(C_Secrets.ShouldCooldownsBeSecret)
    if secret ~= nil then
      return secret and true or false
    end
  end
  -- Combat, encounter, or M+ typically hide cooldown numbers.
  if ns.InCombat() then
    return true
  end
  local types = Enum and Enum.AddOnRestrictionType
  if types then
    if types.Encounter and ns.RestrictionActive(types.Encounter) then
      return true
    end
    if types.ChallengeMode and ns.RestrictionActive(types.ChallengeMode) then
      return true
    end
  end
  return false
end

function ns.LockdownReason()
  if not ns.InChatLockdown() then
    return nil
  end
  local types = Enum and Enum.AddOnRestrictionType
  if types then
    if types.ChallengeMode and ns.RestrictionActive(types.ChallengeMode) then
      return "Mythic+ run in progress"
    end
    if types.Encounter and ns.RestrictionActive(types.Encounter) then
      return "Boss encounter in progress"
    end
    if types.PvPMatch and ns.RestrictionActive(types.PvPMatch) then
      return "PvP match in progress"
    end
  end
  return "Instance comms lockdown"
end

function ns.NormalizeRealm(realm)
  if type(realm) ~= "string" or realm == "" then
    realm = ns.PlainCall(GetNormalizedRealmName) or ns.PlainCall(GetRealmName) or ""
  end
  return (realm or ""):gsub("%s+", "")
end

function ns.FullNameFromParts(name, realm)
  if type(name) ~= "string" or name == "" then
    return nil
  end
  realm = ns.NormalizeRealm(realm)
  if realm == "" then
    return name
  end
  return name .. "-" .. realm
end

function ns.UnitFullName(unit)
  local name, realm = ns.PlainCall(UnitName, unit)
  if not name then
    return nil
  end
  return ns.FullNameFromParts(name, realm), name, ns.NormalizeRealm(realm)
end

function ns.PlayerFullName()
  return ns.UnitFullName("player")
end

function ns.SplitFullName(full)
  if type(full) ~= "string" or full == "" then
    return nil, nil
  end
  local name, realm = full:match("^([^%-]+)%-(.+)$")
  if name then
    return name, realm:gsub("%s+", "")
  end
  return full, ns.NormalizeRealm(nil)
end

function ns.NameKey(full)
  if not full then
    return nil
  end
  local name, realm = ns.SplitFullName(full)
  if not name then
    return nil
  end
  return string.lower(name .. "-" .. (realm or ""))
end

function ns.SameName(a, b)
  if not a or not b then
    return false
  end
  if Ambiguate then
    local aa = ns.PlainCall(Ambiguate, a, "none") or a
    local bb = ns.PlainCall(Ambiguate, b, "none") or b
    if string.lower(aa) == string.lower(bb) then
      return true
    end
  end
  return ns.NameKey(a) == ns.NameKey(b)
end

function ns.ShortName(full)
  if not full then
    return "?"
  end
  if Ambiguate then
    local short = ns.PlainCall(Ambiguate, full, "short")
    if type(short) == "string" and short ~= "" then
      return short
    end
  end
  local name = ns.SplitFullName(full)
  return name or full
end

function ns.GetInstanceMapID()
  if not GetInstanceInfo then
    return nil, nil, nil
  end
  local name, instanceType, _, _, _, _, _, instanceID = ns.PlainCall(GetInstanceInfo)
  return ns.Plain(instanceID), ns.Plain(name), ns.Plain(instanceType)
end

function ns.ClassColor(classFile)
  local c = RAID_CLASS_COLORS and classFile and RAID_CLASS_COLORS[classFile]
  if c then
    return c.r or 1, c.g or 1, c.b or 1
  end
  return 1, 0.82, 0
end

function ns.ColorText(classFile, text)
  local r, g, b = ns.ClassColor(classFile)
  return string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, text or "")
end

function ns.PlayerRole()
  -- Prefer assigned group role, then spec role.
  local assigned = ns.PlainCall(UnitGroupRolesAssigned, "player")
  if assigned == "TANK" or assigned == "HEALER" or assigned == "DAMAGER" then
    return assigned
  end
  if GetSpecializationRole then
    local spec = ns.PlainCall(GetSpecialization)
    if spec then
      local role = ns.PlainCall(GetSpecializationRole, spec)
      if role == "TANK" or role == "HEALER" or role == "DAMAGER" then
        return role
      end
    end
  end
  if C_SpecializationInfo and C_SpecializationInfo.GetSpecializationRole then
    local role = ns.PlainCall(C_SpecializationInfo.GetSpecializationRole)
    if role == "TANK" or role == "HEALER" or role == "DAMAGER" then
      return role
    end
  end
  return "DAMAGER"
end

function ns.RoleLabel(role)
  if role == "TANK" then
    return "Tank"
  elseif role == "HEALER" then
    return "Healer"
  end
  return "DPS"
end

function ns.Print(...)
  local parts = { ... }
  for i = 1, #parts do
    parts[i] = tostring(parts[i])
  end
  local msg = "|cff00ccffKBN|r: " .. table.concat(parts, " ")
  if DEFAULT_CHAT_FRAME then
    DEFAULT_CHAT_FRAME:AddMessage(msg)
  end
end

function ns.CustomNote(bossKey)
  if not db or not db.customNotes or not bossKey then
    return ""
  end
  return db.customNotes[bossKey] or ""
end

function ns.SetCustomNote(bossKey, text)
  if not db or not bossKey then
    return
  end
  db.customNotes = db.customNotes or {}
  if not text or text == "" then
    db.customNotes[bossKey] = nil
  else
    db.customNotes[bossKey] = text
  end
  if ns.RefreshNotes then
    ns.RefreshNotes()
  end
end

local SLASH_HELP = [[
/kbn or /kicknotes — toggle the main window
/kbn help — this list
/kbn config — options (scale, lock, auto-show notes)
/kbn notes — show or hide the boss notes panel
/kbn bar — show or hide the kick assignment bar
/kbn lock — lock or unlock movable frames
/kbn share — share the kick order (out of comms lockdown)
/kbn reset — reset window positions]]

local function SlashHandler(msg)
  msg = string.lower(string.trim and string.trim(msg) or (msg or ""):gsub("^%s+", ""):gsub("%s+$", ""))
  if msg == "" or msg == "show" or msg == "toggle" then
    if ns.ToggleConfig then
      ns.ToggleConfig()
    end
  elseif msg == "help" or msg == "?" then
    ns.Print("Clayton's Kick & Boss Notes v" .. ns.VERSION)
    for line in SLASH_HELP:gmatch("[^\n]+") do
      ns.Print(line)
    end
    if ns.InChatLockdown() then
      ns.Print("Addon messages are blocked right now (" .. (ns.LockdownReason() or "lockdown") .. "). The kick order is queued and will sync when the encounter or key ends. Use I Kicked to advance locally.")
    end
  elseif msg == "config" or msg == "options" or msg == "opt" then
    if ns.ShowConfig then
      ns.ShowConfig("options")
    end
  elseif msg == "notes" or msg == "note" then
    if ns.ToggleNotes then
      ns.ToggleNotes()
    end
  elseif msg == "bar" or msg == "kick" or msg == "kicks" then
    if ns.ToggleBar then
      ns.ToggleBar()
    end
  elseif msg == "lock" then
    if ns.ToggleLock then
      ns.ToggleLock()
    end
  elseif msg == "share" or msg == "sync" then
    if ns.ShareOrder then
      ns.ShareOrder(true)
    end
  elseif msg == "reset" then
    if db then
      db.bar.point, db.bar.x, db.bar.y = "BOTTOM", 0, 220
      db.notesFrame.point, db.notesFrame.x, db.notesFrame.y = "RIGHT", -80, 40
      db.config.point, db.config.x, db.config.y = "CENTER", 0, 0
    end
    if ns.ApplyFramePositions then
      ns.ApplyFramePositions()
    end
    ns.Print("Window positions reset.")
  else
    ns.Print("Unknown command. Try /kbn help.")
  end
end

SLASH_KICKBOSSNOTES1 = "/kbn"
SLASH_KICKBOSSNOTES2 = "/kicknotes"
SlashCmdList.KICKBOSSNOTES = SlashHandler

function KickBossNotes_OnAddonCompartmentClick()
  if ns.ToggleConfig then
    ns.ToggleConfig()
  end
end

function KickBossNotes_OnAddonCompartmentEnter(_, menuButton)
  if GameTooltip and menuButton then
    GameTooltip:SetOwner(menuButton, "ANCHOR_LEFT")
    GameTooltip:SetText(ns.TITLE, 1, 0.82, 0)
    GameTooltip:AddLine("Click to open kick assignments and boss notes.", 1, 1, 1, true)
    GameTooltip:Show()
  end
end

function KickBossNotes_OnAddonCompartmentLeave()
  if GameTooltip then
    GameTooltip:Hide()
  end
end

local eventFrame = CreateFrame("Frame")
ns.EventFrame = eventFrame

eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "ADDON_LOADED" then
    local name = ...
    if name ~= ADDON then
      return
    end
    KickBossNotesDB = KickBossNotesDB or {}
    db = KickBossNotesDB
    MergeDefaults(db, defaults)
    if ns.InitUI then
      ns.InitUI()
    end
    if ns.InitComm then
      ns.InitComm()
    end
  elseif event == "PLAYER_LOGIN" then
    if ns.OnLogin then
      ns.OnLogin()
    end
  elseif event == "PLAYER_ENTERING_WORLD" then
    if ns.OnEnteringWorld then
      ns.OnEnteringWorld(...)
    end
  elseif event == "GROUP_ROSTER_UPDATE" then
    if ns.OnRosterUpdate then
      ns.OnRosterUpdate()
    end
  elseif event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_ROLES_ASSIGNED" then
    if ns.OnSpecOrRoleChanged then
      ns.OnSpecOrRoleChanged()
    end
  elseif event == "CHAT_MSG_ADDON" then
    if ns.OnAddonMessage then
      ns.OnAddonMessage(...)
    end
  elseif event == "ENCOUNTER_START" then
    if ns.OnEncounterStart then
      ns.OnEncounterStart(...)
    end
  elseif event == "ENCOUNTER_END" then
    if ns.OnEncounterEnd then
      ns.OnEncounterEnd(...)
    end
  elseif event == "PLAYER_TARGET_CHANGED" then
    if ns.OnTargetChanged then
      ns.OnTargetChanged()
    end
  elseif event == "SPELL_UPDATE_COOLDOWN" or event == "SPELL_UPDATE_USABLE" then
    if ns.OnCooldownUpdate then
      ns.OnCooldownUpdate()
    end
  elseif event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" then
    if ns.OnCombatState then
      ns.OnCombatState(event)
    end
  elseif event == "CHALLENGE_MODE_START" or event == "CHALLENGE_MODE_COMPLETED" or event == "CHALLENGE_MODE_RESET" then
    if ns.OnChallengeState then
      ns.OnChallengeState(event)
    end
  elseif event == "ADDON_RESTRICTION_STATE_CHANGED" then
    if ns.OnRestrictionChanged then
      ns.OnRestrictionChanged(...)
    end
  elseif event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" then
    if ns.OnZoneChanged then
      ns.OnZoneChanged()
    end
  end
end)

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:RegisterEvent("PLAYER_ROLES_ASSIGNED")
eventFrame:RegisterEvent("CHAT_MSG_ADDON")
eventFrame:RegisterEvent("ENCOUNTER_START")
eventFrame:RegisterEvent("ENCOUNTER_END")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
eventFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
eventFrame:RegisterEvent("SPELL_UPDATE_USABLE")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
eventFrame:RegisterEvent("CHALLENGE_MODE_START")
eventFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
eventFrame:RegisterEvent("CHALLENGE_MODE_RESET")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:RegisterEvent("ZONE_CHANGED")
-- Never register COMBAT_LOG_EVENT or COMBAT_LOG_EVENT_UNFILTERED.
-- Midnight errors if an addon tries, and the payloads would be unreadable anyway.
pcall(function()
  eventFrame:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
end)
