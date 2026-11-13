--[[
  Addon-message sync for kick orders and presence.

  Prefix: KBNKICK (8 characters, under the 16-character limit).

  Channel selection:
    INSTANCE_CHAT when IsInGroup(LE_PARTY_CATEGORY_INSTANCE / Enum.PartyCategory.Instance)
    RAID when IsInRaid()
    PARTY otherwise

  Midnight chat lockdown:
    C_ChatInfo.InChatMessagingLockdown() is true during an active raid
    encounter, a Mythic+ run, or a PvP match (Blizzard relaxed the original
    "entire instance" lock to those states). SendAddonMessage then returns
    Enum.SendAddonMessageResult.AddOnMessageLockdown.
    We never force a send during lockdown. Messages are queued and flushed
    when the restriction lifts (ENCOUNTER_END, CHALLENGE_MODE_COMPLETED,
    PLAYER_REGEN_ENABLED, ADDON_RESTRICTION_STATE_CHANGED).
    The kick rotation still advances locally from the I Kicked button.

  Throttling (ChatThrottleLib-style, documented defaults on
  C_ChatInfo.SendAddonMessage):
    Each prefix starts with 10 sends and recovers 1 send per second.
    Payloads are chunked to stay under 255 bytes.
]]

local ADDON, ns = ...

local PREFIX = ns.PREFIX
local PROTO = ns.PROTO
local MAX_BYTES = 240 -- stay safely under the 255-byte cap including header
local BURST = 10
local RECOVER = 1.0

local outQueue = {}
local lockdownQueue = {}
local tokens = BURST
local lastTokenTime = 0
local started = false
local lastPresence = 0
local lastRequest = 0
local PRESENCE_GAP = 15
local REQUEST_GAP = 5

-- Peers: [nameKey] = { fullName, version, proto, specID, spellID, seen }
ns.Peers = ns.Peers or {}

local function TrimQueue(list, cap)
  while #list > cap do
    table.remove(list, 1)
  end
end

local function RefillTokens()
  local now = ns.Now()
  if lastTokenTime == 0 then
    lastTokenTime = now
    tokens = BURST
    return
  end
  local elapsed = now - lastTokenTime
  if elapsed > 0 then
    tokens = math.min(BURST, tokens + elapsed * RECOVER)
    lastTokenTime = now
  end
end

local function ResultIsLockdown(result)
  local enum = Enum and Enum.SendAddonMessageResult
  if enum and enum.AddOnMessageLockdown and result == enum.AddOnMessageLockdown then
    return true
  end
  if type(result) == "number" and result == 11 then
    return true
  end
  return false
end

local function ResultIsThrottle(result)
  local enum = Enum and Enum.SendAddonMessageResult
  if enum and enum.AddonMessageThrottle and result == enum.AddonMessageThrottle then
    return true
  end
  if type(result) == "number" and result == 3 then
    return true
  end
  return false
end

local function ResultIsSuccess(result)
  if result == nil then
    return true
  end
  local enum = Enum and Enum.SendAddonMessageResult
  if enum and enum.Success and result == enum.Success then
    return true
  end
  if type(result) == "number" and result == 0 then
    return true
  end
  -- Some wrappers return true / 1 on success.
  if result == true then
    return true
  end
  return false
end

local function SendRaw(payload, channel)
  channel = channel or ns.AddonChannel()
  if not channel or not C_ChatInfo or not C_ChatInfo.SendAddonMessage then
    return false, "nochannel"
  end
  if #payload > 255 then
    return false, "toolong"
  end
  if ns.InChatLockdown() then
    return false, "lockdown"
  end
  local result = ns.PlainCall(C_ChatInfo.SendAddonMessage, PREFIX, payload, channel)
  if ResultIsLockdown(result) then
    return false, "lockdown"
  end
  if ResultIsThrottle(result) then
    return false, "throttle"
  end
  if ResultIsSuccess(result) then
    return true
  end
  -- Treat unknown nil-less failures as soft failures (not in group, etc).
  return false, "failed"
end

local function Enqueue(payload, opts)
  opts = opts or {}
  local item = {
    payload = payload,
    urgent = opts.urgent and true or false,
    created = ns.Now(),
  }
  if ns.InChatLockdown() and not opts.force then
    lockdownQueue[#lockdownQueue + 1] = item
    TrimQueue(lockdownQueue, 40)
    return
  end
  if opts.urgent then
    table.insert(outQueue, 1, item)
  else
    outQueue[#outQueue + 1] = item
  end
  TrimQueue(outQueue, 50)
end

function ns.QueueAddonMessage(payload, opts)
  Enqueue(payload, opts)
  if ns.FlushComm then
    ns.FlushComm()
  end
end

function ns.FlushComm()
  if ns.InChatLockdown() then
    return
  end
  -- Move any lockdown-held messages into the live queue first.
  if #lockdownQueue > 0 then
    for i = 1, #lockdownQueue do
      outQueue[#outQueue + 1] = lockdownQueue[i]
    end
    wipe(lockdownQueue)
  end
  RefillTokens()
  local channel = ns.AddonChannel()
  if not channel then
    wipe(outQueue)
    return
  end
  while #outQueue > 0 and tokens >= 1 do
    local item = table.remove(outQueue, 1)
    local ok, why = SendRaw(item.payload, channel)
    if ok then
      tokens = tokens - 1
    elseif why == "lockdown" then
      table.insert(lockdownQueue, 1, item)
      -- Put the rest back into the lockdown queue too.
      while #outQueue > 0 do
        table.insert(lockdownQueue, 2, table.remove(outQueue))
      end
      return
    elseif why == "throttle" then
      table.insert(outQueue, 1, item)
      tokens = 0
      return
    else
      -- Drop messages that cannot be sent (not in group, bad channel).
    end
  end
end

-- Split a body into chunks that fit with the given header pattern.
local function ChunkBody(kind, seq, body)
  -- Format: K|{proto}|{seq}|{index}|{total}|{chunk}
  local headerBudget = 4 + #tostring(PROTO) + #tostring(seq) + 8 -- rough
  local size = math.max(80, MAX_BYTES - headerBudget)
  local total = math.max(1, math.ceil(#body / size))
  local messages = {}
  for i = 1, total do
    local chunk = body:sub((i - 1) * size + 1, i * size)
    messages[#messages + 1] = string.format("%s|%d|%d|%d|%d|%s", kind, PROTO, seq, i, total, chunk)
  end
  return messages
end

function ns.SendPresence()
  local full = ns.PlayerFullName()
  if not full then
    return
  end
  local info = ns.GetPlayerInterrupt()
  local spellID = (info and info.spellID) or 0
  local _, specID = ns.GetPlayerClassSpec()
  local payload = string.format("P|%d|%s|%d|%d", PROTO, ns.VERSION, specID or 0, spellID)
  ns.QueueAddonMessage(payload)
  lastPresence = ns.Now()
end

function ns.RequestSync(force)
  local now = ns.Now()
  if not force and (now - lastRequest) < REQUEST_GAP then
    return
  end
  lastRequest = now
  ns.QueueAddonMessage(string.format("Q|%d|%s", PROTO, ns.VERSION), { urgent = true })
end

function ns.BroadcastOrder(order, opts)
  opts = opts or {}
  if not order then
    return
  end
  if not opts.force and not ns.IsLeaderOrAssist() then
    if not opts.silent then
      ns.Print("Only the group leader or a raid assistant can share the kick order in a raid. In a party, anyone can share.")
    end
    return
  end
  if not ns.AddonChannel() then
    if not opts.silent then
      ns.Print("You are not in a group.")
    end
    return
  end
  local body = ns.SerializeOrder(order)
  if not body then
    return
  end
  local chunks = ChunkBody("O", order.seq or 1, body)
  if ns.InChatLockdown() and not opts.silent then
    ns.Print("Addon messages are blocked (" .. (ns.LockdownReason() or "lockdown") .. "). The order is queued and will sync when the encounter or key ends.")
  end
  for i = 1, #chunks do
    ns.QueueAddonMessage(chunks[i], { urgent = (i == 1) })
  end
  ns.FlushComm()
end

function ns.BroadcastAdvance(groupIndex, nextIndex, kickerName)
  local seq = (ns.GetOrder() and ns.GetOrder().seq) or 0
  local payload = string.format("A|%d|%d|%d|%s|%d", PROTO, groupIndex or 1, nextIndex or 1, kickerName or "", seq)
  ns.QueueAddonMessage(payload, { urgent = true })
  ns.FlushComm()
end

local incoming = {} -- [senderKey][seq] = { total, parts = {} }

local function Assemble(senderKey, seq, index, total, chunk)
  incoming[senderKey] = incoming[senderKey] or {}
  local bucket = incoming[senderKey][seq]
  if not bucket or bucket.total ~= total then
    bucket = { total = total, parts = {}, count = 0, when = ns.Now() }
    incoming[senderKey][seq] = bucket
  end
  if not bucket.parts[index] then
    bucket.parts[index] = chunk
    bucket.count = bucket.count + 1
  end
  if bucket.count >= total then
    local body = table.concat(bucket.parts, "")
    incoming[senderKey][seq] = nil
    return body
  end
  return nil
end

local function SenderFullName(sender)
  if not sender or sender == "" then
    return nil
  end
  if Ambiguate then
    sender = ns.PlainCall(Ambiguate, sender, "none") or sender
  end
  if not sender:find("-", 1, true) then
    sender = ns.FullNameFromParts(sender, nil)
  end
  return sender
end

local function IsSelf(sender)
  return ns.SameName(sender, ns.PlayerFullName())
end

function ns.OnAddonMessage(prefix, text, channel, sender)
  if prefix ~= PREFIX then
    return
  end
  text = ns.Plain(text)
  sender = ns.Plain(sender)
  if type(text) ~= "string" or text == "" then
    return
  end
  sender = SenderFullName(sender)
  if not sender or IsSelf(sender) then
    return
  end
  local kind, rest = text:match("^(%u)|(.*)$")
  if not kind then
    return
  end
  if kind == "P" then
    local proto, version, specID, spellID = rest:match("^(%d+)|([^|]+)|(%-?%d+)|(%-?%d+)$")
    proto = tonumber(proto)
    if not proto or proto > PROTO then
      return
    end
    ns.Peers[ns.NameKey(sender)] = {
      fullName = sender,
      version = version,
      proto = proto,
      specID = tonumber(specID),
      spellID = tonumber(spellID),
      seen = ns.Now(),
    }
    if ns.RefreshAssignUI then
      ns.RefreshAssignUI()
    end
  elseif kind == "Q" then
    -- Sync request. The leader/assist replies immediately; anyone else who
    -- holds a current order replies after a short delay if no one else has.
    ns.SendPresence()
    if ns.ReplyToSyncRequest then
      ns.ReplyToSyncRequest()
    end
  elseif kind == "O" then
    local proto, seq, index, total, chunk = rest:match("^(%d+)|(%d+)|(%d+)|(%d+)|(.*)$")
    proto, seq, index, total = tonumber(proto), tonumber(seq), tonumber(index), tonumber(total)
    if not proto or proto > PROTO or not seq or not index or not total or not chunk then
      return
    end
    local body = Assemble(ns.NameKey(sender), seq, index, total, chunk)
    if body then
      ns.ApplyRemoteOrder(body, seq, sender)
    end
  elseif kind == "A" then
    local proto, groupIndex, nextIndex, kicker, seq = rest:match("^(%d+)|(%d+)|(%d+)|([^|]*)|(%d+)$")
    proto = tonumber(proto)
    groupIndex = tonumber(groupIndex)
    nextIndex = tonumber(nextIndex)
    seq = tonumber(seq)
    if proto and proto <= PROTO and groupIndex and nextIndex then
      ns.ApplyRemoteAdvance(groupIndex, nextIndex, kicker, seq, sender)
    end
  end
end

function ns.GetPeer(fullName)
  return ns.Peers[ns.NameKey(fullName)]
end

function ns.PrunePeers()
  local now = ns.Now()
  local roster = ns.GetRosterMap and ns.GetRosterMap() or {}
  for key, peer in pairs(ns.Peers) do
    if (now - (peer.seen or 0)) > 180 then
      ns.Peers[key] = nil
    elseif roster[key] == nil and not ns.SameName(peer.fullName, ns.PlayerFullName()) then
      -- Keep briefly after a drop so a reload in the same group still shows them.
      if (now - (peer.seen or 0)) > 60 then
        ns.Peers[key] = nil
      end
    end
  end
end

local ticker

local function Tick()
  if ns._RunDelayed then
    ns._RunDelayed()
  end
  ns.FlushComm()
  ns.PrunePeers()
  if IsInGroup and IsInGroup() and not ns.InChatLockdown() then
    if (ns.Now() - lastPresence) >= PRESENCE_GAP then
      ns.SendPresence()
    end
  end
end

function ns.InitComm()
  if started then
    return
  end
  started = true
  if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
    pcall(C_ChatInfo.RegisterAddonMessagePrefix, PREFIX)
  end
  lastTokenTime = ns.Now()
  tokens = BURST
  if C_Timer and C_Timer.NewTicker then
    ticker = C_Timer.NewTicker(0.4, Tick)
  else
    ns.EventFrame:SetScript("OnUpdate", function(_, elapsed)
      ns._commAccum = (ns._commAccum or 0) + elapsed
      if ns._commAccum >= 0.4 then
        ns._commAccum = 0
        Tick()
      end
    end)
  end
end

-- Delayed callbacks without assuming C_Timer is present.
local delayed = {}
local function After(sec, fn)
  if C_Timer and C_Timer.After then
    C_Timer.After(sec, fn)
    return
  end
  delayed[#delayed + 1] = { when = ns.Now() + sec, fn = fn }
end

function ns._RunDelayed()
  if #delayed == 0 then
    return
  end
  local now = ns.Now()
  local keep = {}
  for i = 1, #delayed do
    local item = delayed[i]
    if now >= (item.when or 0) then
      item.fn()
    else
      keep[#keep + 1] = item
    end
  end
  delayed = keep
end

local wasInGroup = false
local leaveToken = 0
local pruneToken = 0
local joinToken = 0
local lastSyncReply = 0
local SYNC_REPLY_GAP = 3

local function InGroupNow()
  if ns.InAnyGroup then
    return ns.InAnyGroup()
  end
  return (IsInGroup and IsInGroup()) and true or false
end

local function HandleDisband(opts)
  opts = opts or {}
  if InGroupNow() then
    return
  end
  -- Always drop outbound messages and peer state so a later group does
  -- not receive a stale order queued for the previous one.
  if ns.AutoClearOnDisbandEnabled and ns.AutoClearOnDisbandEnabled() then
    if ns.ClearKickList then
      ns.ClearKickList({ announce = opts.announce and true or false })
    elseif ns.ClearCommQueues then
      ns.ClearCommQueues()
    end
  else
    if ns.ClearCommQueues then
      ns.ClearCommQueues()
    end
    if ns.Peers then
      wipe(ns.Peers)
    end
    if ns.RefreshAllUI then
      ns.RefreshAllUI()
    end
  end
  wasInGroup = false
end

-- Party-to-raid conversion can briefly fire GROUP_LEFT. Wait and re-check
-- so we only clear when no home or instance group remains.
local function ScheduleDisbandCheck()
  leaveToken = leaveToken + 1
  local token = leaveToken
  After(0.5, function()
    if token ~= leaveToken then
      return
    end
    if InGroupNow() then
      wasInGroup = true
      return
    end
    HandleDisband({ announce = true })
  end)
end

local function HandleJoin()
  wasInGroup = true
  leaveToken = leaveToken + 1 -- cancel a pending disband (e.g. party-to-raid)
  -- If we kept a list because auto-clear is off, do not let its old
  -- sequence win in a group we are not leading.
  if not (UnitIsGroupLeader and UnitIsGroupLeader("player")) then
    if ns.InvalidateOrderSeq then
      ns.InvalidateOrderSeq()
    end
  end
  ns.SendPresence()
  ns.RequestSync(true)
  -- If we are the actual leader and still have no list after peers reply,
  -- build the default kick order from the roster.
  joinToken = joinToken + 1
  local token = joinToken
  After(2, function()
    if token ~= joinToken then
      return
    end
    if not InGroupNow() then
      return
    end
    if not (UnitIsGroupLeader and UnitIsGroupLeader("player")) then
      return
    end
    if ns.HasActiveOrder and ns.HasActiveOrder() then
      return
    end
    if ns.AutoFillPartyOrder then
      ns.AutoFillPartyOrder()
    end
    if ns.ShareOrder then
      ns.ShareOrder(false)
    end
  end)
end

function ns.ReplyToSyncRequest()
  local function send()
    local now = ns.Now()
    if (now - lastSyncReply) < SYNC_REPLY_GAP then
      return
    end
    if (now - (ns._lastAppliedOrder or 0)) < 1.5 then
      return
    end
    local order = ns.GetOrder and ns.GetOrder()
    if not order or not order.seq or order.seq <= 0 then
      return
    end
    if not ns.AddonChannel() then
      return
    end
    lastSyncReply = now
    ns.BroadcastOrder(order, { silent = true, force = not ns.IsLeaderOrAssist() })
  end
  if ns.IsLeaderOrAssist() then
    send()
    return
  end
  local order = ns.GetOrder and ns.GetOrder()
  if order and order.seq and order.seq > 0 then
    After(1.5, function()
      if InGroupNow() then
        send()
      end
    end)
  end
end

local function SchedulePruneAndBroadcast()
  if not InGroupNow() then
    return
  end
  pruneToken = pruneToken + 1
  local token = pruneToken
  After(1.5, function()
    if token ~= pruneToken then
      return
    end
    if not InGroupNow() then
      return
    end
    if not ns.PruneMissingMembers then
      return
    end
    local changed = ns.PruneMissingMembers()
    if changed then
      if ns.IsLeaderOrAssist() and ns.BroadcastOrder and ns.GetOrder then
        ns.BroadcastOrder(ns.GetOrder(), { silent = true })
      end
      if ns.RefreshAllUI then
        ns.RefreshAllUI()
      end
    end
  end)
end

local function OnGroupStateChange()
  if InGroupNow() then
    leaveToken = leaveToken + 1
    if not wasInGroup then
      HandleJoin()
    else
      if ns.EnsureOrderMatchesRoster then
        ns.EnsureOrderMatchesRoster()
      end
      SchedulePruneAndBroadcast()
      if (ns.Now() - lastPresence) > 2 then
        ns.SendPresence()
      end
    end
  else
    if wasInGroup then
      ScheduleDisbandCheck()
    end
  end
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.OnLogin()
  if InGroupNow() then
    if ns.RestoreSavedOrder then
      ns.RestoreSavedOrder()
    end
    wasInGroup = true
    ns.SendPresence()
    ns.RequestSync(true)
  else
    if ns.AutoClearOnDisbandEnabled and ns.AutoClearOnDisbandEnabled() then
      -- /reload or login while solo: drop a stale list quietly.
      HandleDisband({ announce = false })
    else
      if ns.RestoreSavedOrder then
        ns.RestoreSavedOrder()
      end
    end
    wasInGroup = false
  end
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.OnEnteringWorld(...)
  local isLogin, isReload = ...
  isLogin = ns.Plain(isLogin)
  isReload = ns.Plain(isReload)
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
  if InGroupNow() then
    leaveToken = leaveToken + 1
    if not wasInGroup then
      HandleJoin()
    else
      ns.SendPresence()
      ns.RequestSync()
    end
  else
    -- Immediate clear only on login/reload, where IsInGroup is already
    -- reliable. Mid-session zoning uses the delayed check so a brief
    -- ungrouped flicker cannot wipe the list.
    if isLogin or isReload then
      if ns.AutoClearOnDisbandEnabled and ns.AutoClearOnDisbandEnabled() then
        HandleDisband({ announce = false })
      end
      wasInGroup = false
    elseif wasInGroup then
      ScheduleDisbandCheck()
    end
  end
end

function ns.OnRosterUpdate()
  OnGroupStateChange()
end

function ns.OnGroupLeft()
  OnGroupStateChange()
end

function ns.OnGroupJoined()
  OnGroupStateChange()
end

function ns.OnSpecOrRoleChanged()
  ns.SendPresence()
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.OnCombatState(event)
  if event == "PLAYER_REGEN_ENABLED" then
    ns.FlushComm()
    if ns.IsLeaderOrAssist() and not ns.InChatLockdown() then
      -- Re-share after combat if something was queued or peers just joined.
    end
  end
  if ns.RefreshBar then
    ns.RefreshBar()
  end
end

function ns.OnChallengeState(event)
  if event == "CHALLENGE_MODE_COMPLETED" or event == "CHALLENGE_MODE_RESET" then
    ns.FlushComm()
  end
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.OnRestrictionChanged()
  if not ns.InChatLockdown() then
    ns.FlushComm()
    ns.SendPresence()
  end
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.OnZoneChanged()
  if ns.RefreshAllUI then
    ns.RefreshAllUI()
  end
end

function ns.PendingCommCount()
  return #outQueue + #lockdownQueue
end

function ns.ClearCommQueues()
  wipe(outQueue)
  wipe(lockdownQueue)
  wipe(incoming)
end
