--[[
  Alt Vault Checklist — live scan of the current character.

  All Blizzard API calls are wrapped in ns.SafeCall / nil checks so a missing
  or renamed Midnight API cannot error the UI.
]]

local ADDON, ns = ...

local function InvSlot(meta)
  local globalName = {
    head = "INVSLOT_HEAD",
    neck = "INVSLOT_NECK",
    shoulder = "INVSLOT_SHOULDER",
    back = "INVSLOT_BACK",
    chest = "INVSLOT_CHEST",
    wrist = "INVSLOT_WRIST",
    hands = "INVSLOT_HAND",
    waist = "INVSLOT_WAIST",
    legs = "INVSLOT_LEGS",
    feet = "INVSLOT_FEET",
    finger1 = "INVSLOT_FINGER1",
    finger2 = "INVSLOT_FINGER2",
    trinket1 = "INVSLOT_TRINKET1",
    trinket2 = "INVSLOT_TRINKET2",
    mainhand = "INVSLOT_MAINHAND",
    offhand = "INVSLOT_OFFHAND",
  }
  local g = globalName[meta.key]
  if g and _G[g] then
    return _G[g]
  end
  return meta.inv
end

local function ItemLevelFromLink(link)
  if not link then
    return nil
  end
  if GetDetailedItemLevelInfo then
    local ilvl = ns.SafeCall(GetDetailedItemLevelInfo, link)
    if type(ilvl) == "number" and ilvl > 0 then
      return ilvl
    end
  end
  return nil
end

local function BagIndexes()
  local bags = { 0, 1, 2, 3, 4, 5 }
  local E = Enum and Enum.BagIndex
  if E then
    bags = {
      E.Backpack or 0,
      E.Bag_1 or 1,
      E.Bag_2 or 2,
      E.Bag_3 or 3,
      E.Bag_4 or 4,
      E.ReagentBag or 5,
    }
  end
  return bags
end

local function ScanOwnedItems()
  local owned = {}
  local equippedSlots = {}

  local function Record(id, ilvl, where)
    if not id or id == 0 then
      return
    end
    local rec = owned[id]
    if not rec then
      rec = { equipped = false, bag = false, ilvl = ilvl }
      owned[id] = rec
    end
    if where == "equipped" then
      rec.equipped = true
    else
      rec.bag = true
    end
    if ilvl and (not rec.ilvl or ilvl > rec.ilvl) then
      rec.ilvl = ilvl
    end
  end

  for i = 1, #ns.SLOTS do
    local meta = ns.SLOTS[i]
    local slot = InvSlot(meta)
    local id = ns.SafeCall(GetInventoryItemID, "player", slot)
    if id then
      local link = ns.SafeCall(GetInventoryItemLink, "player", slot)
      local ilvl
      if ItemLocation and ItemLocation.CreateFromEquipmentSlot and C_Item and C_Item.DoesItemExist and C_Item.GetCurrentItemLevel then
        local loc = ns.SafeCall(ItemLocation.CreateFromEquipmentSlot, slot)
        if loc and ns.SafeCall(C_Item.DoesItemExist, loc) then
          ilvl = ns.SafeCall(C_Item.GetCurrentItemLevel, loc)
        end
      end
      ilvl = ilvl or ItemLevelFromLink(link)
      Record(id, ilvl, "equipped")
      equippedSlots[meta.key] = { id = id, ilvl = ilvl }
    end
  end

  if C_Container and C_Container.GetContainerNumSlots then
    local bags = BagIndexes()
    for b = 1, #bags do
      local bag = bags[b]
      local slots = ns.SafeCall(C_Container.GetContainerNumSlots, bag) or 0
      for slot = 1, slots do
        local id = ns.SafeCall(C_Container.GetContainerItemID, bag, slot)
        if id then
          local link = ns.SafeCall(C_Container.GetContainerItemLink, bag, slot)
          local ilvl
          if ItemLocation and ItemLocation.CreateFromBagAndSlot and C_Item and C_Item.DoesItemExist and C_Item.GetCurrentItemLevel then
            local loc = ns.SafeCall(ItemLocation.CreateFromBagAndSlot, bag, slot)
            if loc and ns.SafeCall(C_Item.DoesItemExist, loc) then
              ilvl = ns.SafeCall(C_Item.GetCurrentItemLevel, loc)
            end
          end
          ilvl = ilvl or ItemLevelFromLink(link)
          Record(id, ilvl, "bag")
        end
      end
    end
  end

  return owned, equippedSlots
end

local function ParseKeystoneLink(link)
  if type(link) ~= "string" then
    return nil
  end
  -- |Hkeystone:itemID:challengeMapID:level:...
  local mapID, level = link:match("keystone:%d+:(%d+):(%d+)")
  if mapID then
    return tonumber(mapID), tonumber(level)
  end
  return nil
end

local function ChallengeMapName(mapID)
  if not mapID or not C_ChallengeMode or not C_ChallengeMode.GetMapUIInfo then
    return nil
  end
  local name = ns.SafeCall(C_ChallengeMode.GetMapUIInfo, mapID)
  if type(name) == "string" and name ~= "" then
    return name
  end
  return nil
end

local function ScanKeystone()
  local level, mapID
  if C_MythicPlus then
    level = ns.SafeCall(C_MythicPlus.GetOwnedKeystoneLevel)
    mapID = ns.SafeCall(C_MythicPlus.GetOwnedKeystoneChallengeMapID)
    if not mapID and C_MythicPlus.GetOwnedKeystoneMapID then
      mapID = ns.SafeCall(C_MythicPlus.GetOwnedKeystoneMapID)
    end
  end

  -- Bag-scan fallback (and confirmation) for the keystone hyperlink.
  if C_Container and C_Container.GetContainerNumSlots then
    local bags = BagIndexes()
    for b = 1, #bags do
      local bag = bags[b]
      local slots = ns.SafeCall(C_Container.GetContainerNumSlots, bag) or 0
      for slot = 1, slots do
        local link = ns.SafeCall(C_Container.GetContainerItemLink, bag, slot)
        local mid, lvl = ParseKeystoneLink(link)
        if mid then
          mapID = mapID or mid
          level = level or lvl
        else
          local id = ns.SafeCall(C_Container.GetContainerItemID, bag, slot)
          if id and C_Item and C_Item.IsItemKeystoneByID then
            if ns.SafeCall(C_Item.IsItemKeystoneByID, id) then
              mid, lvl = ParseKeystoneLink(link)
              mapID = mapID or mid
              level = level or lvl
            end
          end
        end
      end
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

function ns.GetPlayerKeystone()
  return ScanKeystone()
end

local function ScanWeeklyBest()
  if not C_MythicPlus or not C_MythicPlus.GetRunHistory then
    return nil
  end
  -- this week only, completed runs, current season when the 3rd arg exists
  local runs = ns.SafeCall(C_MythicPlus.GetRunHistory, false, false, true)
  if type(runs) ~= "table" then
    runs = ns.SafeCall(C_MythicPlus.GetRunHistory, false, false)
  end
  if type(runs) ~= "table" then
    return nil
  end
  local bestLevel, bestMap, bestScore
  for i = 1, #runs do
    local run = runs[i]
    if type(run) == "table" and run.completed ~= false and run.thisWeek ~= false then
      local lvl = run.level or 0
      if not bestLevel or lvl > bestLevel or (lvl == bestLevel and (run.runScore or 0) > (bestScore or 0)) then
        bestLevel = lvl
        bestMap = run.mapChallengeModeID
        bestScore = run.runScore
      end
    end
  end
  if not bestLevel then
    return nil
  end
  return {
    level = bestLevel,
    mapID = bestMap,
    mapName = ChallengeMapName(bestMap),
    score = bestScore,
  }
end

local function ScanRating()
  if C_PlayerInfo and C_PlayerInfo.GetPlayerMythicPlusRatingSummary then
    local summary = ns.SafeCall(C_PlayerInfo.GetPlayerMythicPlusRatingSummary, "player")
    if type(summary) == "table" and type(summary.currentSeasonScore) == "number" then
      return summary.currentSeasonScore
    end
  end
  if C_ChallengeMode and C_ChallengeMode.GetOverallDungeonScore then
    local score = ns.SafeCall(C_ChallengeMode.GetOverallDungeonScore)
    if type(score) == "number" then
      return score
    end
  end
  return nil
end

function ns.GetPlayerRating()
  return ScanRating()
end

local function ClassifyVaultType(typeId)
  local e = Enum and Enum.WeeklyRewardChestThresholdType
  if e and typeId then
    if e.Raid and typeId == e.Raid then
      return "raid"
    end
    if e.MythicPlus and typeId == e.MythicPlus then
      return "dungeon"
    end
    if e.World and typeId == e.World then
      return "world"
    end
    if e.RankedPvP and typeId == e.RankedPvP then
      return "pvp"
    end
    if e.Activities and typeId == e.Activities then
      -- When MythicPlus exists as its own enum, Activities is typically the
      -- world/delves row. When it does not, Activities is the dungeon row
      -- (current warcraft.wiki.gg documentation: 1 Activities, 3 Raid, 6 World).
      if e.MythicPlus then
        return "world"
      end
      return "dungeon"
    end
  end
  -- Numeric fallback from warcraft.wiki.gg (no MythicPlus field):
  -- 1 Activities, 2 RankedPvP, 3 Raid, 4 AlsoReceive, 5 Concession, 6 World
  if typeId == 3 then
    return "raid"
  end
  if typeId == 6 then
    return "world"
  end
  if typeId == 2 then
    return "pvp"
  end
  if typeId == 1 then
    return "dungeon"
  end
  return "other"
end

local function ActivityItemLevel(activity)
  if type(activity) ~= "table" then
    return nil
  end
  if activity.rewards and activity.rewards[1] and activity.rewards[1].itemDBID
      and C_WeeklyRewards and C_WeeklyRewards.GetItemHyperlink then
    local link = ns.SafeCall(C_WeeklyRewards.GetItemHyperlink, activity.rewards[1].itemDBID)
    local ilvl = ItemLevelFromLink(link)
    if ilvl then
      return ilvl
    end
  end
  if C_WeeklyRewards and C_WeeklyRewards.GetExampleRewardItemHyperlinks and activity.id then
    local link = ns.SafeCall(C_WeeklyRewards.GetExampleRewardItemHyperlinks, activity.id)
    local ilvl = ItemLevelFromLink(link)
    if ilvl then
      return ilvl
    end
  end
  return nil
end

local function ScanVault()
  local vault = {
    unclaimed = false,
    canClaim = false,
    tracks = { dungeon = {}, raid = {}, world = {}, pvp = {}, other = {} },
  }
  if not C_WeeklyRewards then
    return vault
  end
  if C_WeeklyRewards.HasAvailableRewards then
    vault.unclaimed = ns.SafeCall(C_WeeklyRewards.HasAvailableRewards) and true or false
  end
  if C_WeeklyRewards.CanClaimRewards then
    vault.canClaim = ns.SafeCall(C_WeeklyRewards.CanClaimRewards) and true or false
  end
  if not C_WeeklyRewards.GetActivities then
    return vault
  end
  local activities = ns.SafeCall(C_WeeklyRewards.GetActivities)
  if type(activities) ~= "table" then
    return vault
  end
  for i = 1, #activities do
    local a = activities[i]
    if type(a) == "table" then
      local track = ClassifyVaultType(a.type)
      -- Skip filler enum values that are not player-facing vault columns.
      if track ~= "other" or (a.threshold and a.threshold > 0) then
        local slot = {
          index = a.index or (#vault.tracks[track] + 1),
          type = a.type,
          threshold = a.threshold,
          progress = a.progress,
          level = a.level,
          id = a.id,
          activityTierID = a.activityTierID,
          filled = (tonumber(a.progress) or 0) >= (tonumber(a.threshold) or math.huge) and (tonumber(a.threshold) or 0) > 0,
          ilvl = ActivityItemLevel(a),
        }
        local bucket = vault.tracks[track] or vault.tracks.other
        bucket[#bucket + 1] = slot
      end
    end
  end
  local function byIndex(a, b)
    return (a.index or 0) < (b.index or 0)
  end
  for _, bucket in pairs(vault.tracks) do
    table.sort(bucket, byIndex)
  end
  return vault
end

local function PlayerSpec()
  local specIndex
  if C_SpecializationInfo and C_SpecializationInfo.GetSpecialization then
    specIndex = ns.SafeCall(C_SpecializationInfo.GetSpecialization)
  end
  if not specIndex and GetSpecialization then
    specIndex = ns.SafeCall(GetSpecialization)
  end
  if not specIndex then
    return nil, nil, nil
  end
  local id, name, _, _, role
  if C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo then
    id, name, _, _, role = ns.SafeCall(C_SpecializationInfo.GetSpecializationInfo, specIndex)
  end
  if not name and GetSpecializationInfo then
    id, name, _, _, role = ns.SafeCall(GetSpecializationInfo, specIndex)
  end
  return name, id, role
end

function ns.GetPlayerRole()
  local _, _, role = PlayerSpec()
  return role
end

function ns.CollectPlayer()
  local db = ns.DB()
  if not db then
    return
  end
  local key, name, realm = ns.PlayerKey()
  if not key then
    return
  end
  local char = ns.EnsureChar(key, name, realm)

  char.name = name
  char.realm = realm
  char.lastSeen = GetServerTime()
  char.level = UnitLevel("player")

  local className, classFile, classID = UnitClass("player")
  char.className = className
  char.classFile = classFile
  char.classID = classID

  local specName, specID, role = PlayerSpec()
  char.specName = specName
  char.specID = specID
  char.role = role

  local _, race = UnitRace("player")
  char.race = race
  char.faction = UnitFactionGroup("player")

  local overall, equipped = nil, nil
  if GetAverageItemLevel then
    overall, equipped = ns.SafeCall(GetAverageItemLevel)
  end
  char.ilvl = equipped or overall
  char.ilvlOverall = overall

  char.keystone = ScanKeystone()
  char.weeklyBest = ScanWeeklyBest()
  char.rating = ScanRating()
  char.vault = ScanVault()
  local owned, equippedSlots = ScanOwnedItems()
  char.owned = owned
  char.equippedSlots = equippedSlots

  return char
end

local function IdInList(id, list)
  if not id or not list then
    return false
  end
  for i = 1, #list do
    if list[i] == id then
      return true
    end
  end
  return false
end

-- Returns status, bestIlvl, where for a gear entry given a character's owned map.
-- status: "have" | "catalyst" | "missing"
function ns.EvaluateGearEntry(entry, owned, equippedSlots)
  owned = owned or {}
  local bestIlvl, where, status

  if entry.anyIlvl and not entry.id then
    local slotKey = entry.slot
    local recs = {}
    if equippedSlots then
      if slotKey and equippedSlots[slotKey] then
        recs[#recs + 1] = equippedSlots[slotKey]
      end
      -- Rings / trinkets: accept either slot.
      if slotKey and slotKey:find("finger") then
        recs[#recs + 1] = equippedSlots.finger1
        recs[#recs + 1] = equippedSlots.finger2
      elseif slotKey and slotKey:find("trinket") then
        recs[#recs + 1] = equippedSlots.trinket1
        recs[#recs + 1] = equippedSlots.trinket2
      end
    end
    local best
    for i = 1, #recs do
      local rec = recs[i]
      if rec and rec.ilvl and rec.ilvl >= entry.anyIlvl then
        if not best or rec.ilvl > best then
          best = rec.ilvl
        end
      end
    end
    if best then
      return "have", best, "equipped"
    end
    return "missing", nil, nil
  end

  local function consider(id, kind)
    local rec = owned[id]
    if not rec then
      return
    end
    local loc = rec.equipped and "equipped" or "bag"
    if not bestIlvl or (rec.ilvl or 0) > bestIlvl or (rec.ilvl == bestIlvl and loc == "equipped") then
      bestIlvl = rec.ilvl
      where = loc
    end
    if kind == "have" then
      status = "have"
    elseif kind == "catalyst" and status ~= "have" then
      status = "catalyst"
    end
  end

  consider(entry.id, "have")
  if entry.altIds then
    for i = 1, #entry.altIds do
      consider(entry.altIds[i], "have")
    end
  end
  if entry.catalystIds then
    for i = 1, #entry.catalystIds do
      consider(entry.catalystIds[i], "catalyst")
    end
  end

  -- Name fallback: if an ID was somehow missing but a same-named item is
  -- equipped, we still will not guess IDs. Matching is ID-only.

  return status or "missing", bestIlvl, where
end

-- For finger/trinket groups, two list entries must be filled by two distinct
-- owned IDs. The UI still evaluates each row independently; this helper is
-- used to avoid double-counting the same ring for both slots.
function ns.EvaluateGroupedSlots(entries, owned)
  local used = {}
  local results = {}
  local function take(ids, kind)
    local best, bestId, where
    for i = 1, #ids do
      local id = ids[i]
      if id and not used[id] and owned[id] then
        local rec = owned[id]
        local loc = rec.equipped and "equipped" or "bag"
        if not best or (rec.ilvl or 0) > best or (rec.ilvl == best and loc == "equipped") then
          best = rec.ilvl
          bestId = id
          where = loc
        end
      end
    end
    if bestId then
      used[bestId] = true
      return kind, best, where
    end
    return nil
  end
  for i = 1, #entries do
    local entry = entries[i]
    local status, ilvl, where = take(ns.AllItemIDsForEntry(entry), "have")
    if not status then
      status, ilvl, where = take(ns.CatalystIDsForEntry(entry), "catalyst")
    end
    if not status and entry.anyIlvl then
      status, ilvl, where = ns.EvaluateGearEntry(entry, owned, nil)
      -- Grouped "any ilvl" is resolved in the UI with equippedSlots; mark for later.
    end
    results[i] = { status = status or "missing", ilvl = ilvl, where = where, anyIlvl = entry.anyIlvl }
  end
  return results
end

function ns.IsWeeklyAutoChecked(char, auto)
  if not auto or not char then
    return false
  end
  if auto == "unclaimed" then
    return char.vault and char.vault.unclaimed
  end
  local track, index = auto:match("^(%a+):(%d+)$")
  if not track then
    return false
  end
  index = tonumber(index)
  local bucket = char.vault and char.vault.tracks and char.vault.tracks[track]
  if not bucket or not bucket[index] then
    return false
  end
  return bucket[index].filled and true or false
end

function ns.IsWeeklyChecked(char, item)
  if not char or not item then
    return false, false
  end
  local overrides = char.weeklyChecks or {}
  if overrides[item.id] ~= nil then
    return overrides[item.id] and true or false, true
  end
  if item.auto then
    return ns.IsWeeklyAutoChecked(char, item.auto), false
  end
  return false, false
end

function ns.IsGearChecked(char, entry, autoStatus)
  if not char or not entry then
    return false, false
  end
  local overrides = char.gearOverrides or {}
  local key = tostring(entry.id or entry.name)
  if overrides[key] ~= nil then
    return overrides[key] and true or false, true
  end
  return autoStatus == "have", false
end
