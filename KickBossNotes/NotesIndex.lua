--[[
  Shared boss-note lookup. BossKey is unchanged from v1.0.0 so custom
  notes saved in KickBossNotesDB keep working.

  Lookup order is raids, then dungeons, then delves. Encounter aliases
  and instance-name matches are used when unit names are readable.
]]

local ADDON, ns = ...

function ns.NamesEqual(a, b)
  if not a or not b then
    return false
  end
  if ns.IsSecret and (ns.IsSecret(a) or ns.IsSecret(b)) then
    return false
  end
  if type(a) ~= "string" or type(b) ~= "string" then
    return false
  end
  a = string.lower((a:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")))
  b = string.lower((b:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")))
  return a == b or a:find(b, 1, true) or b:find(a, 1, true)
end

function ns.ParentKind(parent)
  if not parent then
    return "raid"
  end
  if parent.kind then
    return parent.kind
  end
  return "raid"
end

local function MatchBoss(boss, name)
  if ns.NamesEqual(boss.name, name) then
    return true
  end
  for _, alias in ipairs(boss.encounterNames or {}) do
    if ns.NamesEqual(alias, name) then
      return true
    end
  end
  return false
end

local function SearchList(list, name)
  if not list then
    return nil, nil
  end
  for _, parent in ipairs(list) do
    for _, boss in ipairs(parent.bosses or {}) do
      if MatchBoss(boss, name) then
        return boss, parent
      end
    end
  end
  return nil, nil
end

function ns.FindBoss(name)
  if type(name) ~= "string" or name == "" then
    return nil, nil
  end
  if ns.IsSecret and ns.IsSecret(name) then
    return nil, nil
  end
  local boss, parent = SearchList(ns.RAIDS, name)
  if boss then
    return boss, parent
  end
  boss, parent = SearchList(ns.DUNGEONS, name)
  if boss then
    return boss, parent
  end
  return SearchList(ns.DELVES, name)
end

function ns.AllBossEntries()
  local list = {}
  local function add(parents, kind)
    for _, parent in ipairs(parents or {}) do
      for _, boss in ipairs(parent.bosses or {}) do
        list[#list + 1] = { boss = boss, parent = parent, kind = parent.kind or kind }
      end
    end
  end
  add(ns.RAIDS, "raid")
  add(ns.DUNGEONS, "dungeon")
  add(ns.DELVES, "delve")
  return list
end

-- Hierarchical catalog for the browse dropdown: category > instance > boss.
function ns.GetNotesCatalog()
  return {
    { title = "Raids", kind = "raid", color = "|cffff8040", lists = ns.RAIDS or {} },
    { title = "Dungeons", kind = "dungeon", color = "|cff80c0ff", lists = ns.DUNGEONS or {} },
    { title = "Delves", kind = "delve", color = "|cffc080ff", lists = ns.DELVES or {} },
  }
end

-- Keep the exact v1.0.0 key scheme: parent.key .. ":" .. (boss.key or slug(name)).
function ns.BossKey(boss, parent)
  if not boss then
    return nil
  end
  local pk = parent and parent.key or "unknown"
  local bk = boss.key or (boss.name and boss.name:lower():gsub("%s+", "-")) or "boss"
  return pk .. ":" .. bk
end

function ns.GetCurrentNotesParent()
  if ns.GetCurrentDungeon then
    local dungeon = ns.GetCurrentDungeon()
    if dungeon then
      return dungeon, "dungeon"
    end
  end
  local instanceID, instanceName
  if ns.GetInstanceMapID then
    instanceID, instanceName = ns.GetInstanceMapID()
  end
  if ns.FindRaidByInstance then
    local raid = ns.FindRaidByInstance(instanceID, instanceName)
    if raid then
      return raid, "raid"
    end
  end
  if ns.GetCurrentDelve then
    local delve = ns.GetCurrentDelve()
    if delve then
      return delve, "delve"
    end
  end
  return nil, nil
end
