--[[
  Kick assignment model: one rotation for a 5-player party, or multiple
  raid kick groups (A/B/C) each tagged with a raid target marker.

  The live "who is next" pointer advances when a player clicks I Kicked.
  During Midnight comms lockdown that click still advances locally; the
  advance is queued and shared when messages are allowed again.
]]

local ADDON, ns = ...

local GROUP_LABELS = { "A", "B", "C" }
local MARKERS = {
  { id = 0, name = "No marker" },
  { id = 8, name = "Skull" },
  { id = 7, name = "Cross" },
  { id = 1, name = "Star" },
  { id = 2, name = "Circle" },
  { id = 3, name = "Diamond" },
  { id = 4, name = "Triangle" },
  { id = 5, name = "Moon" },
  { id = 6, name = "Square" },
}

ns.GROUP_LABELS = GROUP_LABELS
ns.MARKERS = MARKERS

-- Estimated remaining cooldown after a manual kick, keyed by nameKey.
ns.KickEstimates = ns.KickEstimates or {}

local function EmptyGroup(index)
  return {
    index = index,
    label = GROUP_LABELS[index] or tostring(index),
    marker = (index == 1 and 8) or (index == 2 and 7) or (index == 3 and 1) or 0,
    members = {}, -- { fullName, classFile, spell, spellID, cooldown }
    nextIndex = 1,
  }
end

local function EmptyOrder()
  return {
    seq = 0,
    version = ns.VERSION,
    author = ns.PlayerFullName(),
    groups = { EmptyGroup(1), EmptyGroup(2), EmptyGroup(3) },
  }
end

local order = EmptyOrder()

function ns.GetOrder()
  return order
end

function ns.MarkerInfo(id)
  for _, m in ipairs(MARKERS) do
    if m.id == id then
      return m
    end
  end
  return MARKERS[1]
end

function ns.MarkerIcon(id)
  if not id or id == 0 then
    return nil
  end
  return "Interface\\TargetingFrame\\UI-RaidTargetingIcon_" .. id
end

local function FindMember(group, fullName)
  for i, member in ipairs(group.members) do
    if ns.SameName(member.fullName, fullName) then
      return i, member
    end
  end
end

function ns.GetRoster()
  local list = {}
  local function add(unit)
    local full, name = ns.UnitFullName(unit)
    if not full then
      return
    end
    local classFile = ns.PlainCall(UnitClassBase, unit)
    if not classFile then
      local _, file = ns.PlainCall(UnitClass, unit)
      classFile = file
    end
    local role = ns.PlainCall(UnitGroupRolesAssigned, unit)
    local specID
    if unit == "player" then
      local _, id = ns.GetPlayerClassSpec()
      specID = id
    end
    -- Peer-shared spec helps pick Survival vs BM hunter kicks, etc.
    local peer = ns.GetPeer(full)
    if peer and peer.specID and peer.specID > 0 then
      specID = peer.specID
    end
    local kick = ns.GetInterruptFor(classFile, specID)
    if (not kick or not kick.spell) and peer and peer.spellID and peer.spellID > 0 then
      kick = kick or {}
      kick.spellID = peer.spellID
    end
    list[#list + 1] = {
      unit = unit,
      fullName = full,
      name = name or ns.ShortName(full),
      classFile = classFile,
      role = role,
      specID = specID,
      kick = kick,
      isPlayer = unit == "player",
    }
  end
  add("player")
  if IsInRaid and IsInRaid() then
    local n = GetNumGroupMembers and GetNumGroupMembers() or 0
    for i = 1, n do
      add("raid" .. i)
    end
  elseif IsInGroup and IsInGroup() then
    local n = GetNumSubgroupMembers and GetNumSubgroupMembers() or 4
    for i = 1, n do
      add("party" .. i)
    end
  end
  -- Deduplicate (player also appears as raidX).
  local seen, unique = {}, {}
  for _, row in ipairs(list) do
    local key = ns.NameKey(row.fullName)
    if key and not seen[key] then
      seen[key] = true
      unique[#unique + 1] = row
    end
  end
  table.sort(unique, function(a, b)
    if a.isPlayer ~= b.isPlayer then
      return a.isPlayer
    end
    return (a.name or "") < (b.name or "")
  end)
  return unique
end

function ns.GetRosterMap()
  local map = {}
  for _, row in ipairs(ns.GetRoster()) do
    map[ns.NameKey(row.fullName)] = row
  end
  return map
end

local function PersistOrder()
  local db = ns.DB()
  if db then
    db.lastOrder = ns.CopyTable(order)
  end
end

function ns.RestoreSavedOrder()
  local db = ns.DB()
  if db and type(db.lastOrder) == "table" and type(db.lastOrder.groups) == "table" then
    order = db.lastOrder
    -- Fill any missing groups so A/B/C always exist.
    for i = 1, 3 do
      if type(order.groups[i]) ~= "table" then
        order.groups[i] = EmptyGroup(i)
      end
      order.groups[i].index = i
      order.groups[i].label = GROUP_LABELS[i]
      order.groups[i].members = order.groups[i].members or {}
      order.groups[i].nextIndex = order.groups[i].nextIndex or 1
    end
  end
end

function ns.HasActiveOrder()
  if not order then
    return false
  end
  if (order.seq or 0) > 0 then
    return true
  end
  for _, group in ipairs(order.groups or {}) do
    if group.members and #group.members > 0 then
      return true
    end
  end
  return false
end

function ns.ResetOrder()
  order = EmptyOrder()
  if wipe then
    wipe(ns.KickEstimates)
  else
    ns.KickEstimates = {}
  end
  PersistOrder()
end

-- Keep the current list but drop its sequence so it cannot overwrite a
-- new group's order after auto-clear was turned off.
function ns.InvalidateOrderSeq()
  if not order then
    return
  end
  order.seq = 0
  PersistOrder()
end

-- Clear the kick rotation and raid groups (memory + lastOrder), reset the
-- pointer and sync sequence, drop queued comms, and refresh the bar/UI.
-- Boss notes and user settings are left alone.
function ns.ClearKickList(opts)
  opts = opts or {}
  local had = ns.HasActiveOrder()
  ns.ResetOrder()
  if ns.ClearCommQueues then
    ns.ClearCommQueues()
  end
  if ns.Peers then
    if wipe then
      wipe(ns.Peers)
    else
      ns.Peers = {}
    end
  end
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
  if had and opts.announce then
    ns.Print("Group disbanded: kick list cleared.")
  end
end

function ns.CanEditOrder()
  return ns.IsLeaderOrAssist()
end

function ns.AddToGroup(groupIndex, fullName)
  if not ns.CanEditOrder() then
    ns.Print("Only the group leader or a raid assistant can change the kick order in a raid.")
    return
  end
  local group = order.groups[groupIndex]
  if not group or not fullName then
    return
  end
  if FindMember(group, fullName) then
    return
  end
  -- Remove from other groups so a player is only in one rotation.
  for i, other in ipairs(order.groups) do
    if i ~= groupIndex then
      local idx = FindMember(other, fullName)
      if idx then
        table.remove(other.members, idx)
        if other.nextIndex > #other.members then
          other.nextIndex = 1
        end
      end
    end
  end
  local roster = ns.GetRosterMap()
  local row = roster[ns.NameKey(fullName)]
  local kick = row and row.kick
  group.members[#group.members + 1] = {
    fullName = (row and row.fullName) or fullName,
    classFile = row and row.classFile,
    spell = kick and kick.spell,
    spellID = kick and kick.spellID,
    cooldown = kick and kick.cooldown,
  }
  order.seq = (order.seq or 0) + 1
  order.author = ns.PlayerFullName()
  order.version = ns.VERSION
  PersistOrder()
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.RemoveFromGroup(groupIndex, fullName)
  if not ns.CanEditOrder() then
    return
  end
  local group = order.groups[groupIndex]
  if not group then
    return
  end
  local idx = FindMember(group, fullName)
  if not idx then
    return
  end
  table.remove(group.members, idx)
  if group.nextIndex > #group.members then
    group.nextIndex = 1
  end
  order.seq = (order.seq or 0) + 1
  order.author = ns.PlayerFullName()
  PersistOrder()
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.MoveInGroup(groupIndex, fullName, delta)
  if not ns.CanEditOrder() then
    return
  end
  local group = order.groups[groupIndex]
  if not group then
    return
  end
  local idx = FindMember(group, fullName)
  if not idx then
    return
  end
  local newIdx = idx + delta
  if newIdx < 1 or newIdx > #group.members then
    return
  end
  local row = table.remove(group.members, idx)
  table.insert(group.members, newIdx, row)
  order.seq = (order.seq or 0) + 1
  order.author = ns.PlayerFullName()
  PersistOrder()
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.SetGroupMarker(groupIndex, markerID)
  if not ns.CanEditOrder() then
    return
  end
  local group = order.groups[groupIndex]
  if not group then
    return
  end
  group.marker = markerID or 0
  order.seq = (order.seq or 0) + 1
  order.author = ns.PlayerFullName()
  PersistOrder()
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.AutoFillPartyOrder()
  if not ns.CanEditOrder() then
    return
  end
  local group = order.groups[1]
  group.members = {}
  for _, row in ipairs(ns.GetRoster()) do
    if row.kick and row.kick.spell then
      group.members[#group.members + 1] = {
        fullName = row.fullName,
        classFile = row.classFile,
        spell = row.kick.spell,
        spellID = row.kick.spellID,
        cooldown = row.kick.cooldown,
      }
    end
  end
  group.nextIndex = 1
  order.seq = (order.seq or 0) + 1
  order.author = ns.PlayerFullName()
  order.version = ns.VERSION
  PersistOrder()
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.ClearGroup(groupIndex)
  if not ns.CanEditOrder() then
    return
  end
  local group = order.groups[groupIndex]
  if not group then
    return
  end
  group.members = {}
  group.nextIndex = 1
  order.seq = (order.seq or 0) + 1
  order.author = ns.PlayerFullName()
  PersistOrder()
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.EnsureOrderMatchesRoster()
  -- Immediate pass: refresh class/spell info. Members who briefly drop
  -- during a load are not removed here; ns.PruneMissingMembers does that
  -- after a short debounce from the roster handler.
  local roster = ns.GetRosterMap()
  local changed = false
  for _, group in ipairs(order.groups) do
    for _, member in ipairs(group.members) do
      local row = roster[ns.NameKey(member.fullName)]
      if row then
        member.classFile = row.classFile or member.classFile
        if row.kick then
          member.spell = row.kick.spell or member.spell
          member.spellID = row.kick.spellID or member.spellID
          member.cooldown = row.kick.cooldown or member.cooldown
        end
      end
    end
    if group.nextIndex > math.max(1, #group.members) then
      group.nextIndex = 1
      changed = true
    end
  end
  if changed then
    PersistOrder()
  end
end

-- Remove players who are no longer in the group. Conservative about
-- half-loaded rosters so a loading screen does not empty the list.
-- Returns true if the order changed. The leader/assist increments seq so
-- the pruned order can be broadcast.
function ns.PruneMissingMembers()
  if not ns.InAnyGroup or not ns.InAnyGroup() then
    return false
  end
  local roster = ns.GetRosterMap()
  local rosterCount = 0
  for _ in pairs(roster) do
    rosterCount = rosterCount + 1
  end
  local memberCount = 0
  for _, group in ipairs(order.groups) do
    memberCount = memberCount + #group.members
  end
  if rosterCount <= 1 and memberCount > 1 then
    return false
  end
  local expected = (GetNumGroupMembers and GetNumGroupMembers()) or 0
  if expected > rosterCount + 1 then
    return false
  end
  local changed = false
  for _, group in ipairs(order.groups) do
    local i = 1
    while i <= #group.members do
      local member = group.members[i]
      local row = roster[ns.NameKey(member.fullName)]
      if not row then
        table.remove(group.members, i)
        changed = true
      else
        member.classFile = row.classFile or member.classFile
        if row.kick then
          member.spell = row.kick.spell or member.spell
          member.spellID = row.kick.spellID or member.spellID
          member.cooldown = row.kick.cooldown or member.cooldown
        end
        i = i + 1
      end
    end
    if group.nextIndex > math.max(1, #group.members) then
      group.nextIndex = 1
      changed = true
    end
  end
  if changed then
    if ns.IsLeaderOrAssist() then
      order.seq = (order.seq or 0) + 1
      order.author = ns.PlayerFullName()
      order.version = ns.VERSION
    end
    PersistOrder()
  end
  return changed
end

local function NextIndexAfter(group, from)
  local n = #group.members
  if n == 0 then
    return 1
  end
  local idx = (from or group.nextIndex or 1) + 1
  if idx > n then
    idx = 1
  end
  return idx
end

function ns.GetNextMember(group)
  if not group or #group.members == 0 then
    return nil, nil
  end
  local idx = group.nextIndex or 1
  if idx < 1 or idx > #group.members then
    idx = 1
    group.nextIndex = 1
  end
  return group.members[idx], idx
end

function ns.RecordKickEstimate(fullName, cooldown)
  if not fullName then
    return
  end
  local cd = tonumber(cooldown) or 15
  ns.KickEstimates[ns.NameKey(fullName)] = {
    fullName = fullName,
    readyAt = ns.Now() + cd,
    cooldown = cd,
  }
end

function ns.EstimatedRemaining(fullName)
  local est = ns.KickEstimates[ns.NameKey(fullName)]
  if not est then
    return nil
  end
  local remain = (est.readyAt or 0) - ns.Now()
  if remain <= 0 then
    return 0
  end
  return remain
end

-- Player clicked I Kicked for a group (or the group they belong to).
function ns.PlayerKicked(groupIndex)
  local me = ns.PlayerFullName()
  if groupIndex then
    local group = order.groups[groupIndex]
    if not group then
      return
    end
    local _, idx = FindMember(group, me)
    if not idx then
      -- Still allow advancing the pointed-at slot if this is a 5-man and they are next.
      local current = ns.GetNextMember(group)
      if not current or not ns.SameName(current.fullName, me) then
        ns.Print("You are not in kick group " .. (group.label or groupIndex) .. ".")
        return
      end
      idx = group.nextIndex
    end
    local member = group.members[idx]
    group.nextIndex = NextIndexAfter(group, idx)
    ns.RecordKickEstimate(me, member and member.cooldown)
    ns.BroadcastAdvance(groupIndex, group.nextIndex, me)
    if ns.RefreshAllUI then
      ns.RefreshAllUI()
    end
    return
  end
  -- No group specified: advance every group the player belongs to.
  local advanced = false
  for i, group in ipairs(order.groups) do
    local _, idx = FindMember(group, me)
    if idx then
      local member = group.members[idx]
      group.nextIndex = NextIndexAfter(group, idx)
      ns.RecordKickEstimate(me, member and member.cooldown)
      ns.BroadcastAdvance(i, group.nextIndex, me)
      advanced = true
    end
  end
  if not advanced then
    ns.Print("Add yourself to a kick group first, or use Auto-fill party.")
    return
  end
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.SerializeOrder(ord)
  ord = ord or order
  -- Compact text: ver`author`marker:name,name`marker:name...
  -- Names cannot contain backticks. Realms use hyphens.
  local parts = { ord.version or ns.VERSION, ord.author or "", tostring(#ord.groups) }
  for _, group in ipairs(ord.groups) do
    local names = {}
    for _, member in ipairs(group.members) do
      names[#names + 1] = (member.fullName or "") .. "^" .. (member.classFile or "") .. "^" .. tostring(member.spellID or 0) .. "^" .. tostring(member.cooldown or 0) .. "^" .. (member.spell or "")
    end
    parts[#parts + 1] = tostring(group.marker or 0) .. ":" .. tostring(group.nextIndex or 1) .. ":" .. table.concat(names, ",")
  end
  return table.concat(parts, "`")
end

function ns.ApplyRemoteOrder(body, seq, sender)
  seq = tonumber(seq)
  if not seq then
    return
  end
  if order.seq and seq < order.seq then
    -- Ours is newer. If we are authoritative, push it back so they catch up.
    if ns.IsLeaderOrAssist() then
      ns.BroadcastOrder(order)
    end
    return
  end
  if order.seq and seq == order.seq then
    return
  end
  local chunks = {}
  local startAt = 1
  while true do
    local i, j = string.find(body, "`", startAt, true)
    if not i then
      chunks[#chunks + 1] = string.sub(body, startAt)
      break
    end
    chunks[#chunks + 1] = string.sub(body, startAt, i - 1)
    startAt = j + 1
  end
  -- version, author, numGroups, then groups...
  if #chunks < 3 then
    return
  end
  local version, author, numGroups = chunks[1], chunks[2], tonumber(chunks[3])
  if not numGroups then
    return
  end
  local newOrder = {
    seq = seq,
    version = version,
    author = author,
    groups = {},
  }
  for i = 1, 3 do
    newOrder.groups[i] = EmptyGroup(i)
    local raw = chunks[3 + i]
    if raw then
      local marker, nextIndex, roster = raw:match("^(%d+):(%d+):(.*)$")
      if not marker then
        marker, nextIndex = raw:match("^(%d+):(%d+)$")
        roster = ""
      end
      newOrder.groups[i].marker = tonumber(marker) or 0
      newOrder.groups[i].nextIndex = tonumber(nextIndex) or 1
      if roster and roster ~= "" then
        for entry in string.gmatch(roster, "[^,]+") do
          local fullName, classFile, spellID, cooldown, spell = entry:match("^(.-)%^(.-)%^(%-?%d+)%^(%-?%d+)%^(.*)$")
          if not fullName then
            fullName = entry
          end
          if fullName and fullName ~= "" then
            newOrder.groups[i].members[#newOrder.groups[i].members + 1] = {
              fullName = fullName,
              classFile = classFile ~= "" and classFile or nil,
              spellID = tonumber(spellID),
              cooldown = tonumber(cooldown),
              spell = (spell and spell ~= "") and spell or nil,
            }
          end
        end
      end
    end
  end
  order = newOrder
  ns._lastAppliedOrder = ns.Now()
  PersistOrder()
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.ApplyRemoteAdvance(groupIndex, nextIndex, kicker, seq, sender)
  local group = order.groups[groupIndex]
  if not group then
    return
  end
  -- Accept advances even if seq is slightly behind, as long as it is not from a stale overwritten order.
  if seq and order.seq and seq < order.seq and (order.seq - seq) > 0 then
    -- Stale order; ignore.
    if seq < order.seq then
      return
    end
  end
  if nextIndex < 1 then
    nextIndex = 1
  end
  group.nextIndex = nextIndex
  if kicker and kicker ~= "" then
    local _, member = FindMember(group, kicker)
    if not member then
      -- Try to match without relying on group membership.
      for _, g in ipairs(order.groups) do
        local _, m = FindMember(g, kicker)
        if m then
          member = m
          break
        end
      end
    end
    ns.RecordKickEstimate(kicker, member and member.cooldown)
  end
  if ns.RefreshBar then
    ns.RefreshBar()
  end
  if ns.RefreshAssignUI then
    ns.RefreshAssignUI()
  end
end

function ns.ShareOrder(verbose)
  if not ns.IsLeaderOrAssist() then
    if verbose then
      ns.Print("Only the group leader or a raid assistant can share the kick order in a raid. In a 5-player party, anyone can share.")
    end
    return
  end
  if not IsInGroup or not IsInGroup() then
    if verbose then
      ns.Print("You are not in a group.")
    end
    return
  end
  if (order.seq or 0) == 0 and #order.groups[1].members == 0 then
    ns.AutoFillPartyOrder()
  end
  ns.BroadcastOrder(order)
  if verbose and not ns.InChatLockdown() then
    ns.Print("Kick order shared with the group (addon message).")
  end
end

function ns.PostOrderToChat()
  local channel = ns.ChatChannel()
  if not channel then
    ns.Print("You are not in a group.")
    return
  end
  if ns.InChatLockdown() then
    ns.Print("Chat and addon messages are blocked during a boss encounter or Mythic+ run. Post the order between pulls, after the boss, or after the key.")
    return
  end
  if not C_ChatInfo or not C_ChatInfo.SendChatMessage then
    -- Fallback to global SendChatMessage if still present.
    if not SendChatMessage then
      ns.Print("Cannot send chat messages.")
      return
    end
  end
  local lines = {}
  lines[#lines + 1] = "Kick order:"
  for _, group in ipairs(order.groups) do
    if #group.members > 0 then
      local names = {}
      for i, member in ipairs(group.members) do
        local label = ns.ShortName(member.fullName)
        if i == (group.nextIndex or 1) then
          label = ">" .. label .. "<"
        end
        names[#names + 1] = label
      end
      local marker = ns.MarkerInfo(group.marker)
      local prefix = "Group " .. group.label
      if marker and marker.id ~= 0 then
        prefix = prefix .. " (" .. marker.name .. ")"
      end
      lines[#lines + 1] = prefix .. ": " .. table.concat(names, " -> ")
    end
  end
  if #lines == 1 then
    ns.Print("No kick order to post. Add players to a group first.")
    return
  end
  local send = (C_ChatInfo and C_ChatInfo.SendChatMessage) or SendChatMessage
  for _, line in ipairs(lines) do
    ns.SafeCall(send, line, channel)
  end
end

function ns.OnCooldownUpdate()
  if ns.RefreshBar then
    ns.RefreshBar()
  end
end
