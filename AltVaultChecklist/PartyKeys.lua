--[[
  Alt Vault Checklist — M+ Key Party Board.

  Shares this character's keystone with party members who also run the
  addon (prefix AVCKEYS). Display only: it never posts to party chat
  unless the player clicks "Post keys to party", and it never inspects
  while the player is in combat.
]]

local ADDON, ns = ...

local PREFIX = "AVCKEYS"
local ASTRAL_PREFIX = "AstralKeys"
local PROTO = 1
local SEND_THROTTLE = 2.0
local BAG_THROTTLE = 2.0
local INSPECT_GAP = 1.6
local INSPECT_TIMEOUT = 4.0
local ILVL_STALE = 300

-- In-memory only. Never written to SavedVariables.
local cache = {} -- [fullName] = { ... }
local inspectQueue = {}
local inspectBusyUntil = 0
local inspectGUID, inspectUnit, inspectStart
local lastSend, lastRequest, lastBagScan = 0, 0, 0
local started = false

local function Now()
  return (GetTime and GetTime()) or 0
end

local function InCombat()
  if InCombatLockdown and InCombatLockdown() then
    return true
  end
  if UnitAffectingCombat and UnitAffectingCombat("player") then
    return true
  end
  return false
end

local function PartyCategoryInstance()
  if Enum and Enum.PartyCategory and Enum.PartyCategory.Instance then
    return Enum.PartyCategory.Instance
  end
  return LE_PARTY_CATEGORY_INSTANCE
end

local function AddonChannel()
  if not IsInGroup or not IsInGroup() then
    return nil
  end
  local inst = PartyCategoryInstance()
  if inst and IsInGroup(inst) then
    return "INSTANCE_CHAT"
  end
  if IsInRaid and IsInRaid() then
    return "RAID"
  end
  return "PARTY"
end

local function ChatChannel()
  return AddonChannel()
end

local function NormalizeRealm(realm)
  if type(realm) ~= "string" or realm == "" then
    realm = ns.SafeCall(GetNormalizedRealmName) or ns.SafeCall(GetRealmName) or ""
  end
  return (realm or ""):gsub("%s+", "")
end

local function FullNameFromParts(name, realm)
  if not name or name == "" then
    return nil
  end
  realm = NormalizeRealm(realm)
  if realm == "" then
    return name
  end
  return name .. "-" .. realm
end

function ns.UnitFullName(unit)
  local name, realm = ns.SafeCall(UnitName, unit)
  if not name then
    return nil
  end
  return FullNameFromParts(name, realm), name, NormalizeRealm(realm)
end

local function SplitFullName(full)
  if type(full) ~= "string" or full == "" then
    return nil, nil
  end
  local name, realm = full:match("^([^%-]+)%-(.+)$")
  if name then
    return name, realm:gsub("%s+", "")
  end
  return full, NormalizeRealm(nil)
end

local function NameKey(full)
  if not full then
    return nil
  end
  local name, realm = SplitFullName(full)
  if not name then
    return nil
  end
  return string.lower(name .. "-" .. (realm or ""))
end

local function SameUnitName(a, b)
  if not a or not b then
    return false
  end
  if Ambiguate then
    local aa = ns.SafeCall(Ambiguate, a, "none") or a
    local bb = ns.SafeCall(Ambiguate, b, "none") or b
    if string.lower(aa) == string.lower(bb) then
      return true
    end
  end
  return NameKey(a) == NameKey(b)
end

local function ChallengeMapName(mapID)
  if not mapID or mapID == 0 or not C_ChallengeMode or not C_ChallengeMode.GetMapUIInfo then
    return nil
  end
  local name = ns.SafeCall(C_ChallengeMode.GetMapUIInfo, mapID)
  if type(name) == "string" and name ~= "" then
    return name
  end
  return nil
end

local function PlayerItemLevel()
  if GetAverageItemLevel then
    local overall, equipped = ns.SafeCall(GetAverageItemLevel)
    if type(equipped) == "number" and equipped > 0 then
      return equipped
    end
    if type(overall) == "number" and overall > 0 then
      return overall
    end
  end
  local db = ns.DB()
  local key = ns.PlayerKey and ns.PlayerKey()
  local char = db and key and db.chars and db.chars[key]
  return char and char.ilvl or nil
end

local function PlayerRating()
  if ns.GetPlayerRating then
    local r = ns.GetPlayerRating()
    if type(r) == "number" then
      return r
    end
  end
  if C_PlayerInfo and C_PlayerInfo.GetPlayerMythicPlusRatingSummary then
    local summary = ns.SafeCall(C_PlayerInfo.GetPlayerMythicPlusRatingSummary, "player")
    if type(summary) == "table" and type(summary.currentSeasonScore) == "number" then
      return summary.currentSeasonScore
    end
  end
  return nil
end

local function UnitRating(unit)
  if unit == "player" or (UnitIsUnit and UnitIsUnit(unit, "player")) then
    return PlayerRating()
  end
  if C_PlayerInfo and C_PlayerInfo.GetPlayerMythicPlusRatingSummary then
    local summary = ns.SafeCall(C_PlayerInfo.GetPlayerMythicPlusRatingSummary, unit)
    if type(summary) == "table" and type(summary.currentSeasonScore) == "number" then
      return summary.currentSeasonScore
    end
  end
  return nil
end

local function PlayerRole()
  local role = ns.SafeCall(UnitGroupRolesAssigned, "player")
  if role and role ~= "NONE" then
    return role
  end
  if ns.GetPlayerRole then
    return ns.GetPlayerRole()
  end
  return role or "NONE"
end

local function PlayerKeystone()
  if ns.GetPlayerKeystone then
    return ns.GetPlayerKeystone()
  end
  local level, mapID
  if C_MythicPlus then
    level = ns.SafeCall(C_MythicPlus.GetOwnedKeystoneLevel)
    mapID = ns.SafeCall(C_MythicPlus.GetOwnedKeystoneChallengeMapID)
    if not mapID and C_MythicPlus.GetOwnedKeystoneMapID then
      mapID = ns.SafeCall(C_MythicPlus.GetOwnedKeystoneMapID)
    end
  end
  if not level and not mapID then
    return nil
  end
  return {
    level = level,
    mapID = mapID,
    mapName = ChallengeMapName(mapID),
  }
end

local function Sanitize(s)
  s = tostring(s or ""):gsub("|", "/"):gsub("[\r\n]", " ")
  return s
end

local function NumOrEmpty(v)
  if type(v) == "number" then
    return tostring(math.floor(v + 0.5))
  end
  return ""
end

function ns.GetGroupUnits()
  local units = { "player" }
  if not IsInGroup or not IsInGroup() then
    return units, 1
  end
  if IsInRaid and IsInRaid() then
    local n = (GetNumGroupMembers and GetNumGroupMembers()) or 0
    for i = 1, n do
      local u = "raid" .. i
      if not (UnitIsUnit and UnitIsUnit(u, "player")) then
        units[#units + 1] = u
      end
    end
  else
    for i = 1, 4 do
      local u = "party" .. i
      if UnitExists and UnitExists(u) then
        units[#units + 1] = u
      end
    end
  end
  return units, #units
end

function ns.PartyGroupSize()
  if not IsInGroup or not IsInGroup() then
    return 1
  end
  return (GetNumGroupMembers and GetNumGroupMembers()) or 1
end

local function FindUnitByName(full)
  local units = ns.GetGroupUnits()
  for i = 1, #units do
    local ufull = ns.UnitFullName(units[i])
    if SameUnitName(ufull, full) then
      return units[i]
    end
  end
  return nil
end

local function PruneCache()
  local present = {}
  local units = ns.GetGroupUnits()
  for i = 1, #units do
    local full = ns.UnitFullName(units[i])
    if full then
      present[NameKey(full)] = true
    end
  end
  for key, rec in pairs(cache) do
    if not present[NameKey(rec.fullName or key)] then
      cache[key] = nil
    end
  end
end

local function EnsureCache(fullName)
  local key = NameKey(fullName)
  if not key then
    return nil
  end
  local rec = cache[key]
  if not rec then
    rec = { fullName = fullName }
    cache[key] = rec
  end
  rec.fullName = fullName
  return rec
end

local function StoreOwnCache()
  local full, name, realm = ns.UnitFullName("player")
  if not full then
    return
  end
  local rec = EnsureCache(full)
  local _, classFile = ns.SafeCall(UnitClass, "player")
  local keystone = PlayerKeystone()
  rec.name = name
  rec.realm = realm
  rec.classFile = classFile
  rec.role = PlayerRole()
  rec.ilvl = PlayerItemLevel()
  rec.rating = PlayerRating()
  rec.hasAddon = true
  rec.source = "self"
  rec.updated = Now()
  if keystone and (keystone.level or keystone.mapID) then
    rec.mapID = keystone.mapID
    rec.level = keystone.level
    rec.mapName = keystone.mapName or ChallengeMapName(keystone.mapID)
    rec.hasKey = true
  else
    rec.mapID = nil
    rec.level = nil
    rec.mapName = nil
    rec.hasKey = false
  end
  return rec
end

local function SendAddon(text)
  local channel = AddonChannel()
  if not channel or not C_ChatInfo or not C_ChatInfo.SendAddonMessage then
    return
  end
  ns.SafeCall(C_ChatInfo.SendAddonMessage, PREFIX, text, channel)
end

local function EncodeOwnKey()
  local rec = StoreOwnCache()
  if not rec then
    return nil
  end
  return table.concat({
    "KEY",
    tostring(PROTO),
    Sanitize(rec.fullName),
    Sanitize(rec.classFile or ""),
    Sanitize(rec.role or "NONE"),
    NumOrEmpty(rec.ilvl),
    NumOrEmpty(rec.rating),
    NumOrEmpty(rec.mapID),
    NumOrEmpty(rec.level),
  }, "|")
end

local function BroadcastKey(force)
  if not IsInGroup or not IsInGroup() then
    return
  end
  local t = Now()
  if not force and lastSend > 0 and (t - lastSend) < SEND_THROTTLE then
    return
  end
  local payload = EncodeOwnKey()
  if not payload then
    return
  end
  lastSend = t
  SendAddon(payload)
end

local function RequestKeys(force)
  if not IsInGroup or not IsInGroup() then
    return
  end
  local t = Now()
  if not force and lastRequest > 0 and (t - lastRequest) < SEND_THROTTLE then
    return
  end
  lastRequest = t
  SendAddon("REQ")
end

local function SplitPipe(text)
  local parts = {}
  local rest = text
  while true do
    local a, b = rest:match("^([^|]*)|(.*)$")
    if not a then
      parts[#parts + 1] = rest
      break
    end
    parts[#parts + 1] = a
    rest = b
    if #parts > 16 then
      break
    end
  end
  return parts
end

local function ParseKeyMessage(text)
  if type(text) ~= "string" then
    return nil
  end
  if text == "REQ" or text:match("^REQ") then
    return { cmd = "REQ" }
  end
  if text:sub(1, 4) ~= "KEY|" then
    return nil
  end
  local parts = SplitPipe(text)
  if parts[1] ~= "KEY" then
    return nil
  end
  local ver = tonumber(parts[2] or "")
  if ver ~= PROTO then
    -- Future versions: still accept if the field layout is a prefix of ours.
    if not ver or ver < 1 then
      return nil
    end
  end
  local fullName = parts[3]
  if not fullName or fullName == "" then
    return nil
  end
  local mapID = tonumber(parts[8] or "")
  local level = tonumber(parts[9] or "")
  if mapID == 0 then
    mapID = nil
  end
  if level == 0 then
    level = nil
  end
  return {
    cmd = "KEY",
    fullName = fullName,
    classFile = parts[4] ~= "" and parts[4] or nil,
    role = parts[5] ~= "" and parts[5] or nil,
    ilvl = tonumber(parts[6] or ""),
    rating = tonumber(parts[7] or ""),
    mapID = mapID,
    level = level,
  }
end

-- Fallback parser for Astral Keys guild/group broadcasts:
--   "updateV8 Name-Realm:CLASS:mapID:level:weeklyBest:week:score"
-- Listen only; this addon never sends on the AstralKeys prefix.
local function ParseAstralMessage(text)
  if type(text) ~= "string" then
    return nil
  end
  local body = text:match("^updateV%d+%s+(.+)$")
  if not body then
    return nil
  end
  local fullName, classFile, mapID, level = body:match("^([^:]+):(%a+):(%d+):(%d+)")
  if not fullName then
    return nil
  end
  mapID = tonumber(mapID)
  level = tonumber(level)
  if not mapID or mapID == 0 then
    mapID = nil
  end
  if not level or level == 0 then
    level = nil
  end
  return {
    fullName = fullName,
    classFile = classFile,
    mapID = mapID,
    level = level,
  }
end

local function ApplyRemoteKey(info, source)
  if not info or not info.fullName then
    return
  end
  if not FindUnitByName(info.fullName) then
    return
  end
  local rec = EnsureCache(info.fullName)
  -- Our own protocol always wins over a third-party fallback.
  if rec.source == "avc" and source ~= "avc" and rec.updated and (Now() - rec.updated) < 120 then
    return
  end
  rec.hasAddon = (source == "avc") or rec.hasAddon
  rec.source = source
  rec.updated = Now()
  if info.classFile and info.classFile ~= "" then
    rec.classFile = info.classFile
  end
  if info.role and info.role ~= "" and info.role ~= "NONE" then
    rec.role = info.role
  end
  if type(info.ilvl) == "number" and info.ilvl > 0 then
    rec.ilvl = info.ilvl
    rec.ilvlFromAddon = true
    rec.ilvlAt = Now()
  end
  if type(info.rating) == "number" then
    rec.rating = info.rating
  end
  rec.mapID = info.mapID
  rec.level = info.level
  rec.mapName = ChallengeMapName(info.mapID)
  rec.hasKey = (info.level and info.level > 0) or (info.mapID and info.mapID > 0) or false
  if ns.RefreshPartyPane then
    ns.RefreshPartyPane()
  end
end

local function OnAddonMessage(prefix, text, channel, sender)
  if prefix == PREFIX then
    local info = ParseKeyMessage(text)
    if not info then
      return
    end
    if info.cmd == "REQ" then
      if sender and UnitName and SameUnitName(sender, ns.UnitFullName("player") or UnitName("player")) then
        return
      end
      BroadcastKey(false)
      return
    end
    if info.cmd == "KEY" then
      if sender and not info.fullName then
        info.fullName = sender
      end
      ApplyRemoteKey(info, "avc")
    end
    return
  end
  if prefix == ASTRAL_PREFIX then
    local info = ParseAstralMessage(text)
    if info then
      ApplyRemoteKey(info, "astral")
    end
  end
end

--------------------------------------------------------------------------
-- Inspect (item level for members without the addon). Out of combat only.
--------------------------------------------------------------------------

local function InspectItemLevel(unit)
  if C_PaperDollInfo and C_PaperDollInfo.GetInspectItemLevel then
    local ilvl = ns.SafeCall(C_PaperDollInfo.GetInspectItemLevel, unit)
    if type(ilvl) == "number" and ilvl > 0 then
      return ilvl
    end
  end
  return nil
end

local function NeedsInspect(unit, rec)
  if not unit or unit == "player" or (UnitIsUnit and UnitIsUnit(unit, "player")) then
    return false
  end
  if rec and rec.ilvlFromAddon and rec.ilvl and rec.ilvlAt and (Now() - rec.ilvlAt) < ILVL_STALE then
    return false
  end
  if rec and rec.ilvl and rec.ilvlAt and (Now() - rec.ilvlAt) < ILVL_STALE then
    return false
  end
  return true
end

local function CanInspectUnit(unit)
  if InCombat() then
    return false
  end
  if not unit or not UnitExists or not UnitExists(unit) then
    return false
  end
  if UnitIsUnit and UnitIsUnit(unit, "player") then
    return false
  end
  if not CanInspect then
    return false
  end
  return ns.SafeCall(CanInspect, unit) and true or false
end

local function FinishInspect()
  inspectGUID, inspectUnit, inspectStart = nil, nil, nil
  inspectBusyUntil = Now() + INSPECT_GAP
  if ClearInspectPlayer then
    ns.SafeCall(ClearInspectPlayer)
  end
end

local function ProcessInspectQueue()
  if InCombat() then
    return
  end
  if inspectGUID then
    if inspectStart and (Now() - inspectStart) > INSPECT_TIMEOUT then
      FinishInspect()
    else
      return
    end
  end
  if Now() < inspectBusyUntil then
    return
  end
  while #inspectQueue > 0 do
    local unit = table.remove(inspectQueue, 1)
    if CanInspectUnit(unit) then
      local full = ns.UnitFullName(unit)
      local rec = full and cache[NameKey(full)]
      if NeedsInspect(unit, rec) then
        inspectUnit = unit
        inspectGUID = ns.SafeCall(UnitGUID, unit)
        inspectStart = Now()
        ns.SafeCall(NotifyInspect, unit)
        return
      end
    end
  end
end

local function QueueInspect(unit)
  if not CanInspectUnit(unit) then
    return
  end
  for i = 1, #inspectQueue do
    if inspectQueue[i] == unit then
      return
    end
  end
  inspectQueue[#inspectQueue + 1] = unit
  ProcessInspectQueue()
end

local function QueueMissingInspects()
  if InCombat() then
    return
  end
  local units, count = ns.GetGroupUnits()
  if count > 5 then
    return
  end
  for i = 1, #units do
    local unit = units[i]
    local full = ns.UnitFullName(unit)
    local rec = full and cache[NameKey(full)]
    if NeedsInspect(unit, rec) then
      QueueInspect(unit)
    end
  end
end

local function OnInspectReady(guid)
  if not guid or guid ~= inspectGUID then
    return
  end
  local unit = inspectUnit
  if unit and UnitExists and UnitExists(unit) then
    local ilvl = InspectItemLevel(unit)
    local full = ns.UnitFullName(unit)
    if full and type(ilvl) == "number" and ilvl > 0 then
      local rec = EnsureCache(full)
      rec.ilvl = ilvl
      rec.ilvlAt = Now()
      rec.ilvlFromAddon = rec.ilvlFromAddon or false
      if ns.RefreshPartyPane then
        ns.RefreshPartyPane()
      end
    end
  end
  FinishInspect()
  ProcessInspectQueue()
end

--------------------------------------------------------------------------
-- Public snapshot used by the Party Keys tab
--------------------------------------------------------------------------

function ns.GetPartyBoardMembers()
  StoreOwnCache()
  PruneCache()
  local units, count = ns.GetGroupUnits()
  local members = {}
  local inGroup = IsInGroup and IsInGroup()
  local tooLarge = inGroup and count > 5
  if tooLarge then
    return members, count, true
  end
  for i = 1, #units do
    local unit = units[i]
    local full, name, realm = ns.UnitFullName(unit)
    if name then
      local rec = full and cache[NameKey(full)]
      local _, classFile = ns.SafeCall(UnitClass, unit)
      local role = ns.SafeCall(UnitGroupRolesAssigned, unit)
      local isSelf = unit == "player" or (UnitIsUnit and UnitIsUnit(unit, "player"))
      local rating = UnitRating(unit)
      local ilvl, hasAddon, hasKey, mapID, level, mapName, source
      if rec then
        ilvl = rec.ilvl
        hasAddon = rec.hasAddon or isSelf
        hasKey = rec.hasKey
        mapID = rec.mapID
        level = rec.level
        mapName = rec.mapName or ChallengeMapName(rec.mapID)
        source = rec.source
        classFile = rec.classFile or classFile
        if rec.role and rec.role ~= "NONE" and (not role or role == "NONE") then
          role = rec.role
        end
        if type(rec.rating) == "number" and not rating then
          rating = rec.rating
        end
      end
      if isSelf then
        hasAddon = true
        source = "self"
        local own = PlayerKeystone()
        if own then
          hasKey = (own.level or own.mapID) and true or false
          mapID = own.mapID
          level = own.level
          mapName = own.mapName or ChallengeMapName(own.mapID)
        else
          hasKey = false
          mapID, level, mapName = nil, nil, nil
        end
        ilvl = PlayerItemLevel() or ilvl
        rating = PlayerRating() or rating
        role = PlayerRole() or role
      end
      members[#members + 1] = {
        unit = unit,
        fullName = full,
        name = name,
        realm = realm,
        classFile = classFile,
        role = role or "NONE",
        ilvl = ilvl,
        rating = rating,
        mapID = mapID,
        level = level,
        mapName = mapName,
        hasAddon = hasAddon and true or false,
        hasKey = hasKey,
        isSelf = isSelf,
        source = source,
      }
    end
  end
  local best = -1
  for i = 1, #members do
    local lvl = members[i].level or 0
    if lvl > best then
      best = lvl
    end
  end
  if best > 0 then
    for i = 1, #members do
      if members[i].level == best then
        members[i].highest = true
      end
    end
  end
  return members, count, false
end

function ns.PartyBoardStatus()
  if not IsInGroup or not IsInGroup() then
    return "Not in a party. Join a group to see everyone's key, rating, and item level."
  end
  local count = ns.PartyGroupSize()
  if count > 5 then
    return string.format("This board is for 5-player parties. You are in a group of %d.", count)
  end
  return string.format("Party of %d. Members without this addon show \"no addon\" and their key as unknown.", count)
end

function ns.PartyKeys_RequestRefresh()
  StoreOwnCache()
  PruneCache()
  if IsInGroup and IsInGroup() then
    RequestKeys(true)
    BroadcastKey(true)
    QueueMissingInspects()
  end
  if ns.RefreshPartyPane then
    ns.RefreshPartyPane()
  end
end

function ns.PartyKeys_PostToChat()
  if not IsInGroup or not IsInGroup() then
    print("|cff88ccffAlt Vault Checklist:|r you are not in a party.")
    return
  end
  if ns.PartyGroupSize() > 5 then
    print("|cff88ccffAlt Vault Checklist:|r this button is for 5-player parties.")
    return
  end
  local members = ns.GetPartyBoardMembers()
  if #members == 0 then
    print("|cff88ccffAlt Vault Checklist:|r no party members to post.")
    return
  end
  local parts = {}
  for i = 1, #members do
    local m = members[i]
    local label = m.name or m.fullName or "?"
    if m.level and m.level > 0 then
      local dungeon = m.mapName or (m.mapID and ("map " .. m.mapID)) or "key"
      parts[#parts + 1] = string.format("%s +%d %s", label, m.level, dungeon)
    elseif m.hasAddon and m.hasKey == false then
      parts[#parts + 1] = label .. " no key"
    else
      parts[#parts + 1] = label .. " unknown"
    end
  end
  local text = "Party keys: " .. table.concat(parts, " | ")
  if #text > 255 then
    text = text:sub(1, 252) .. "..."
  end
  local channel = ChatChannel()
  if not channel or not SendChatMessage then
    print("|cff88ccffAlt Vault Checklist:|r could not post to party chat.")
    return
  end
  ns.SafeCall(SendChatMessage, text, channel)
end

--------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------

local ev = CreateFrame("Frame")

local pendingRoster = false
local pendingInspect = false

local function AfterRoster()
  ev.rosterElapsed = nil
  pendingRoster = false
  StoreOwnCache()
  PruneCache()
  if IsInGroup and IsInGroup() then
    RequestKeys(false)
    BroadcastKey(false)
    QueueMissingInspects()
  else
    wipe(inspectQueue)
  end
  if ns.RefreshPartyPane then
    ns.RefreshPartyPane()
  end
end

local function QueueRoster()
  if pendingRoster then
    return
  end
  pendingRoster = true
  ev.rosterElapsed = 0
end

ev:SetScript("OnUpdate", function(self, elapsed)
  if pendingRoster then
    self.rosterElapsed = (self.rosterElapsed or 0) + elapsed
    if self.rosterElapsed >= 0.35 then
      AfterRoster()
    end
  end
  if inspectGUID and inspectStart and (Now() - inspectStart) > INSPECT_TIMEOUT then
    FinishInspect()
    ProcessInspectQueue()
  end
  if not inspectGUID and #inspectQueue > 0 and Now() >= inspectBusyUntil and not InCombat() then
    ProcessInspectQueue()
  end
end)

ev:SetScript("OnEvent", function(_, event, arg1, arg2, arg3, arg4)
  if event == "ADDON_LOADED" then
    if arg1 ~= ADDON then
      return
    end
    if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
      ns.SafeCall(C_ChatInfo.RegisterAddonMessagePrefix, PREFIX)
      -- Listen-only. We never send on this prefix.
      ns.SafeCall(C_ChatInfo.RegisterAddonMessagePrefix, ASTRAL_PREFIX)
    end
    return
  end

  if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
    started = true
    StoreOwnCache()
    QueueRoster()
    return
  end

  if event == "CHAT_MSG_ADDON" then
    OnAddonMessage(arg1, arg2, arg3, arg4)
    return
  end

  if event == "INSPECT_READY" then
    OnInspectReady(arg1)
    return
  end

  if event == "PLAYER_REGEN_ENABLED" then
    QueueMissingInspects()
    return
  end

  if event == "PLAYER_REGEN_DISABLED" then
    wipe(inspectQueue)
    if inspectGUID then
      inspectGUID, inspectUnit, inspectStart = nil, nil, nil
    end
    return
  end

  if event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED" then
    QueueRoster()
    return
  end

  if event == "CHALLENGE_MODE_COMPLETED" or event == "CHALLENGE_MODE_MAPS_UPDATE" then
    StoreOwnCache()
    BroadcastKey(true)
    if ns.RefreshPartyPane then
      ns.RefreshPartyPane()
    end
    return
  end

  if event == "BAG_UPDATE_DELAYED" then
    local t = Now()
    if lastBagScan > 0 and (t - lastBagScan) < BAG_THROTTLE then
      return
    end
    lastBagScan = t
    local before = EncodeOwnKey()
    StoreOwnCache()
    local after = EncodeOwnKey()
    if before ~= after then
      BroadcastKey(true)
    else
      BroadcastKey(false)
    end
    if ns.RefreshPartyPane then
      ns.RefreshPartyPane()
    end
    return
  end
end)

ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:RegisterEvent("INSPECT_READY")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("PLAYER_REGEN_DISABLED")
ev:RegisterEvent("GROUP_ROSTER_UPDATE")
ev:RegisterEvent("PLAYER_ROLES_ASSIGNED")
ev:RegisterEvent("CHALLENGE_MODE_COMPLETED")
ev:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE")
ev:RegisterEvent("BAG_UPDATE_DELAYED")
