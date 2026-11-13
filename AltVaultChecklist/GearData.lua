--[[
  Alt Vault Checklist — BiS / gearing lists
  Midnight Season 2 (patch 12.1.5), compiled 2026-11-12.

  Primary source for slot lists: Method.gg overall Best-in-Slot tables
  (one page per spec). Hero-talent choice is the most popular Mythic+
  tree in MaxWoW's top-50 M+ samples (week of 2026-11-12), except
  Evoker, whose MaxWoW pages did not hydrate hero names; those three
  use Method's published M+ talent recommendation instead.

  Cross-checked against Wowhead / Icy Veins / Archon-style guides when
  preparing the original four-spec lists, and when resolving a missing
  Method link (Outlaw chest).

  Every numeric item ID was verified on 2026-11-12 against the Wowhead
  tooltip API (nether.wowhead.com/tooltip/item/<id>?dataEnv=1&locale=0).
  Display names below are the tooltip-verified names. IDs are never invented.

  Entries with anyIlvl and no id are intentional Method 'any 334 ilvl'
  rows (Feral Druid); they are not missing IDs.
]]

local ADDON, ns = ...
ns.Gear = ns.Gear or {}
ns.GearBySpecID = ns.GearBySpecID or {}

-- No hardcoded roster. Characters are registered the first time they log in.
ns.Roster = {}

ns.DEFAULT_WEEKLY = {
  { id = "vault_mp_1", label = "Vault: 1 M+ dungeon", auto = "dungeon:1" },
  { id = "vault_mp_4", label = "Vault: 4 M+ dungeons", auto = "dungeon:2" },
  { id = "vault_mp_8", label = "Vault: 8 M+ dungeons", auto = "dungeon:3" },
  { id = "vault_raid_1", label = "Vault: raid slot 1", auto = "raid:1" },
  { id = "vault_raid_2", label = "Vault: raid slot 2", auto = "raid:2" },
  { id = "vault_raid_3", label = "Vault: raid slot 3", auto = "raid:3" },
  { id = "vault_world_1", label = "Vault: world / delves slot 1", auto = "world:1" },
  { id = "vault_world_2", label = "Vault: world / delves slot 2", auto = "world:2" },
  { id = "vault_world_3", label = "Vault: world / delves slot 3", auto = "world:3" },
  { id = "prof_weekly", label = "Weekly profession quests", auto = nil },
}

ns.SLOTS = {
  { key = "head",     inv = 1,  label = "Head" },
  { key = "neck",     inv = 2,  label = "Neck" },
  { key = "shoulder", inv = 3,  label = "Shoulders" },
  { key = "back",     inv = 15, label = "Back" },
  { key = "chest",    inv = 5,  label = "Chest" },
  { key = "wrist",    inv = 9,  label = "Wrist" },
  { key = "hands",    inv = 10, label = "Hands" },
  { key = "waist",    inv = 6,  label = "Waist" },
  { key = "legs",     inv = 7,  label = "Legs" },
  { key = "feet",     inv = 8,  label = "Feet" },
  { key = "finger1",  inv = 11, label = "Ring",     group = "finger" },
  { key = "finger2",  inv = 12, label = "Ring",     group = "finger" },
  { key = "trinket1", inv = 13, label = "Trinket",  group = "trinket" },
  { key = "trinket2", inv = 14, label = "Trinket",  group = "trinket" },
  { key = "mainhand", inv = 16, label = "Main Hand" },
  { key = "offhand",  inv = 17, label = "Off Hand" },
}

-- Blood Death Knight — San'layn
ns.Gear["DEATHKNIGHT:Blood"] = {
  title = "Blood Death Knight",
  specID = 250,
  hero = "San'layn",
  notes = "M+ hero talent used for this list: San'layn (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for San'layn.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/blood-death-knight/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Skullguard of the Risen Sacrifice", id = 268229, targetIlvl = 344, source = "Nek’zali the Soulcoiler", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "C'thraxxi Binders Pauldrons", id = 239037, targetIlvl = 344, source = "Temple of Sethraliss" },
    { slot = "back", name = "Bloodthorn Burnous", id = 251190, targetIlvl = 344, source = "The Blinding Vale" },
    { slot = "chest", name = "Reckless Spirit Breastplate", id = 268222, targetIlvl = 344, source = "The Coiled Altar", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Overseer's Vambraces", id = 251133, targetIlvl = 344, source = "Murder Row" },
    { slot = "hands", name = "Bonds of the Hash'ura", id = 251214, targetIlvl = 344, source = "Den of Nalorakk", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Girdle of Toxic Regret", id = 268259, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Chausses of Unbound Rancor", id = 271878, targetIlvl = 344, source = "Ula’tek", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Spellbreaker's March", id = 237828, targetIlvl = 331, source = "Crafted" },
    { slot = "finger1", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger2", name = "Masterwork Sin'dorei Band", id = 240949, targetIlvl = 331, source = "Crafted" },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "mainhand", name = "Maze-roa, Warlord's Fury", id = 268213, targetIlvl = 344, source = "The Coiled Altar" },
  },
}
ns.GearBySpecID[250] = ns.Gear["DEATHKNIGHT:Blood"]

-- Frost Death Knight — Deathbringer
ns.Gear["DEATHKNIGHT:Frost"] = {
  title = "Frost Death Knight",
  specID = 251,
  hero = "Deathbringer",
  notes = "M+ hero talent used for this list: Deathbringer (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Frost Death Knight.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/frost-death-knight/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Baleful Grave-Knight's Casque", id = 271474, targetIlvl = 344, source = "Kythix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Baleful Grave-Knight's Gibbets", id = 271472, targetIlvl = 344, source = "Murder Row (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Baleful Grave-Knight's Breastplate", id = 271477, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Spellbreaker's Bracers", id = 237834, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Baleful Grave-Knight's Deathgrips", id = 271475, targetIlvl = 344, source = "Entombed Sentinels", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Girdle of Toxic Regret", id = 268259, targetIlvl = 344, source = "Coiled Altar" },
    { slot = "legs", name = "Chausses of Unbound Rancor", id = 271878, targetIlvl = 344, source = "Ula’tek" },
    { slot = "feet", name = "Scaled Fiend's Warboots", id = 268260, targetIlvl = 344, source = "Entombed Sentinels" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kythix" },
    { slot = "finger2", name = "Loa Worshiper's Band", id = 251513, targetIlvl = 331, source = "Crafted" },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "mainhand", name = "Maze-roa, Warlord's Fury", id = 268213, targetIlvl = 344, source = "The Coiled Altar", altIds = { 268209 }, altNote = "Alternative: Aman'muso, Warlord's Vengeance — The Coiled Altar." },
    { slot = "offhand", name = "Jaw of the Shackled Goddess", id = 268202, targetIlvl = 344, source = "Ula’tek" },
  },
}
ns.GearBySpecID[251] = ns.Gear["DEATHKNIGHT:Frost"]

-- Unholy Death Knight — San'layn
ns.Gear["DEATHKNIGHT:Unholy"] = {
  title = "Unholy Death Knight",
  specID = 252,
  hero = "San'layn",
  notes = "M+ hero talent used for this list: San'layn (most popular in MaxWoW's top 50 M+ players this season: 49/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Unholy DK.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/unholy-death-knight/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Baleful Grave-Knight's Casque", id = 271474, targetIlvl = 344, source = "Kythix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Baleful Grave-Knight's Gibbets", id = 271472, targetIlvl = 344, source = "Murder Row (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Baleful Grave-Knight's Breastplate", id = 271477, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Spellbreaker's Bracers", id = 237834, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Baleful Grave-Knight's Deathgrips", id = 271475, targetIlvl = 344, source = "Entombed Sentinels", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Girdle of Toxic Regret", id = 268259, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Chausses of Unbound Rancor", id = 271878, targetIlvl = 344, source = "Ula’tek" },
    { slot = "feet", name = "Spellbreaker's March", id = 237828, targetIlvl = 331, source = "Crafted" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kythix" },
    { slot = "finger2", name = "Band of the Amani Warlord", id = 273792, targetIlvl = 344, source = "Altar of Fangs" },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "mainhand", name = "Maze-roa, Warlord's Fury", id = 268213, targetIlvl = 344, source = "The Coiled Altar" },
  },
}
ns.GearBySpecID[252] = ns.Gear["DEATHKNIGHT:Unholy"]

-- Havoc Demon Hunter — Aldrachi Reaver
ns.Gear["DEMONHUNTER:Havoc"] = {
  title = "Havoc Demon Hunter",
  specID = 577,
  hero = "Aldrachi Reaver",
  notes = "M+ hero talent used for this list: Aldrachi Reaver (most popular in MaxWoW's top 50 M+ players this season: 46/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Havoc Demon Hunter.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/havoc-demon-hunter/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Gaze of the Coiled Watcher", id = 271875, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Frothing Venom Spaulders", id = 268246, targetIlvl = 344, source = "Vashnik the Malignant (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Chestwrap of Palpable Terror", id = 281236, targetIlvl = 344, source = "Kith’ix" },
    { slot = "wrist", name = "Silvermoon Agent's Deflectors", id = 244576, targetIlvl = 331, source = "Crafted; Embellishment: Arcanoweave Lining" },
    { slot = "hands", name = "Abyssal Doomhound's Studded Gauntlets", id = 271538, targetIlvl = 344, source = "Entombed Sentinels" },
    { slot = "waist", name = "Sash of the Forlorn Vessel", id = 268256, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Coiled Hex Legguards", id = 268225, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Sand-Shined Snakeskin Sandals", id = 159327, targetIlvl = 344, source = "Temple of Sethraliss" },
    { slot = "finger1", name = "Vile Alchemist's Band", id = 268249, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "finger2", name = "Signet of Snarling Servitude", id = 251136, targetIlvl = 344, source = "Murder Row" },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "mainhand", name = "Aman'muso, Warlord's Vengeance", id = 268209, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "offhand", name = "Spellbreaker's Warglaive", id = 237840, targetIlvl = 331, source = "Crafted; Embellishment: Hunter's Ritual Stone" },
  },
}
ns.GearBySpecID[577] = ns.Gear["DEMONHUNTER:Havoc"]

-- Vengeance Demon Hunter — Annihilator
ns.Gear["DEMONHUNTER:Vengeance"] = {
  title = "Vengeance Demon Hunter",
  specID = 581,
  hero = "Annihilator",
  notes = "M+ hero talent used for this list: Annihilator (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Vengeance Demon Hunter.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/vengeance-demon-hunter/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Gaze of the Coiled Watcher", id = 271875, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Scavenger's Spaulders", id = 251146, targetIlvl = 344, source = "Den of Nalorakk (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Adherent's Silken Shroud", id = 239656, targetIlvl = 331, source = "Crafted; Embellishment: Arcanoweave Lining" },
    { slot = "chest", name = "Chestwrap of Palpable Terror", id = 281236, targetIlvl = 344, source = "Kith’ix", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Silvermoon Agent's Deflectors", id = 244576, targetIlvl = 331, source = "Crafted; Embellishment: Arcanoweave Lining" },
    { slot = "hands", name = "Subjugator's Chilling Grips", id = 193758, targetIlvl = 344, source = "Ruby Life Pools (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Sash of the Forlorn Vessel", id = 268256, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Breeches of the Sacred Hall", id = 159313, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Arctic Explorer's Legwraps", id = 251153, targetIlvl = 344, source = "Den of Nalorakk" },
    { slot = "finger1", name = "Ritual Binder's Ring", id = 159459, targetIlvl = 344, source = "Kings’ Rest" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "mainhand", name = "Aman'muso, Warlord's Vengeance", id = 268209, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "offhand", name = "Tomb-Creeper's Claw", id = 270930, targetIlvl = 344, source = "Nek’zali" },
  },
}
ns.GearBySpecID[581] = ns.Gear["DEMONHUNTER:Vengeance"]

-- Devourer Demon Hunter — Annihilator
ns.Gear["DEMONHUNTER:Devourer"] = {
  title = "Devourer Demon Hunter",
  specID = 1480,
  hero = "Annihilator",
  notes = "M+ hero talent used for this list: Annihilator (most popular in MaxWoW's top 50 M+ players this season: 26/50). MaxWoW M+ sample (top 50, week of 2026-11-12): Annihilator 26/50. Method also recommends Annihilator for M+ as the safer default; Void-Scarred has a higher ceiling. Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Devourer Demon Hunter.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/devourer-demon-hunter/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Gaze of the Coiled Watcher", id = 271875, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Frothing Venom Spaulders", id = 268246, targetIlvl = 344, source = "Vashnik the Malignant (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Chestwrap of Palpable Terror", id = 281236, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Silvermoon Agent's Deflectors", id = 244576, targetIlvl = 331, source = "Crafted; Embellishment: Arcanoweave Lining" },
    { slot = "hands", name = "Abyssal Doomhound's Studded Gauntlets", id = 271538, targetIlvl = 344, source = "Entombed Sentinels" },
    { slot = "waist", name = "Sash of the Forlorn Vessel", id = 268256, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Coiled Hex Legguards", id = 268225, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Silvermoon Agent's Sneakers", id = 244569, targetIlvl = 331, source = "Crafted; Embellishment: Arcanoweave Lining" },
    { slot = "finger1", name = "Charged Sandstone Band", id = 158366, targetIlvl = 344, source = "Temple of Sethraliss" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Gebbo's Bottomless Bag", id = 270164, targetIlvl = 344, source = "The Lost Explorers" },
    { slot = "trinket2", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Baleful Hexblade", id = 268211, targetIlvl = 344, source = "The Coiled Altar" },
  },
}
ns.GearBySpecID[1480] = ns.Gear["DEMONHUNTER:Devourer"]

-- Balance Druid — Elune's Chosen
ns.Gear["DRUID:Balance"] = {
  title = "Balance Druid",
  specID = 102,
  hero = "Elune's Chosen",
  notes = "M+ hero talent used for this list: Elune's Chosen (most popular in MaxWoW's top 50 M+ players this season: 43/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Balance Druid.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/balance-druid/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Gaze of the Coiled Watcher", id = 271875, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Frothing Venom Spaulders", id = 268246, targetIlvl = 344, source = "Vashnik the Malignant (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Chestwrap of Palpable Terror", id = 281236, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Silvermoon Agent's Deflectors", id = 244576, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Ruthless Slaughtergrips", id = 268234, targetIlvl = 344, source = "Sszorak (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Sash of the Forlorn Vessel", id = 268256, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Coiled Hex Legguards", id = 268225, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Sand-Shined Snakeskin Sandals", id = 159327, targetIlvl = 344, source = "Temple of Sethraliss" },
    { slot = "finger1", name = "Vile Alchemist's Band", id = 268249, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Vile Vial of Volatile Venom", id = 273796, targetIlvl = 344, source = "Altar of Fangs" },
    { slot = "trinket2", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Aln'hara Lantern", id = 245769, targetIlvl = 331, source = "Crafted" },
  },
}
ns.GearBySpecID[102] = ns.Gear["DRUID:Balance"]

-- Feral Druid — Druid of the Claw
ns.Gear["DRUID:Feral"] = {
  title = "Feral Druid",
  specID = 103,
  hero = "Druid of the Claw",
  notes = "M+ hero talent used for this list: Druid of the Claw (most popular in MaxWoW's top 50 M+ players this season: 32/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Feral Druid.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/feral-druid/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Gaze of the Coiled Watcher", id = 271875, targetIlvl = 344, source = "Ula'tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula'tek" },
    { slot = "shoulder", name = "Any item, item level 334+", anyIlvl = 334, targetIlvl = 334, source = "Method overall list does not name a specific drop for this slot; any 334+ piece is accepted. This is not a missing item ID." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Chestwrap of Palpable Terror", id = 281236, targetIlvl = 344, source = "Kith'ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Silvermoon Agent's Deflectors", id = 244576, targetIlvl = 331, source = "Crafted; Embellishment: Arcanoweave Lining" },
    { slot = "hands", name = "Any item, item level 334+", anyIlvl = 334, targetIlvl = 334, source = "Method overall list does not name a specific drop for this slot; any 334+ piece is accepted. This is not a missing item ID." },
    { slot = "waist", name = "Sash of the Forlorn Vessel", id = 268256, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Coiled Hex Legguards", id = 268225, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "feet", name = "Any item, item level 334+", anyIlvl = 334, targetIlvl = 334, source = "Method overall list does not name a specific drop for this slot; any 334+ piece is accepted. This is not a missing item ID." },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "finger2", name = "Any item, item level 334+", anyIlvl = 334, targetIlvl = 334, source = "Method overall list does not name a specific drop for this slot; any 334+ piece is accepted. This is not a missing item ID." },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar Kith’ix", altIds = { 281215 }, altNote = "Also accepted: Twisted Horror's Tendril (281215)." },
    { slot = "mainhand", name = "Abyssal Broodfiend's Bardiche", id = 268215, targetIlvl = 344, source = "Ula'tek" },
  },
}
ns.GearBySpecID[103] = ns.Gear["DRUID:Feral"]

-- Guardian Druid — Elune's Chosen
ns.Gear["DRUID:Guardian"] = {
  title = "Guardian Druid",
  specID = 104,
  hero = "Elune's Chosen",
  notes = "M+ hero talent used for this list: Elune's Chosen (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Guardian Druid.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/guardian-druid/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Gaze of the Coiled Watcher", id = 271875, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Somber Spaulders", id = 251223, targetIlvl = 344, source = "Voidscar Arena (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Chestwrap of Palpable Terror", id = 281236, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Fury-fletched Armlets", id = 251135, targetIlvl = 344, source = "Murder Row" },
    { slot = "hands", name = "Gauntlets of Fevered Defense", id = 251124, targetIlvl = 344, source = "Murder Row (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Sash of the Forlorn Vessel", id = 268256, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Coiled Hex Legguards", id = 268225, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "feet", name = "Breakwater Boots", id = 268247, targetIlvl = 344, source = "Nymrissa Wavecaller" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "finger2", name = "Alluring Bubbleband", id = 268266, targetIlvl = 344, source = "Nymrissa Wavecaller" },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "mainhand", name = "Abyssal Broodfiend's Bardiche", id = 268215, targetIlvl = 344, source = "Ula’tek" },
  },
}
ns.GearBySpecID[104] = ns.Gear["DRUID:Guardian"]

-- Restoration Druid — Wildstalker
ns.Gear["DRUID:Restoration"] = {
  title = "Restoration Druid",
  specID = 105,
  hero = "Wildstalker",
  notes = "M+ hero talent used for this list: Wildstalker (most popular in MaxWoW's top 50 M+ players this season: 45/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Resto Druid.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/restoration-druid/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Gaze of the Coiled Watcher", id = 271875, targetIlvl = 344, source = "Ula'tek / Catalyst", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Amulet of the Twin Fangs", id = 268251, targetIlvl = 344, source = "The Twin Fangs" },
    { slot = "shoulder", name = "Silvermoon Agent's Mantle", id = 244572, targetIlvl = 331, source = "Crafted" },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "War Trial Vestments", id = 251159, targetIlvl = 344, source = "Den of Nalorakk / Catalyst", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Silvermoon Agent's Deflectors", id = 244576, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Enigmatic Dreamwatcher's Gauntlets", id = 271529, targetIlvl = 344, source = "Entombed Sentinels (Tier Token)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Sash of the Forlorn Vessel", id = 268256, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Coiled Hex Legguards", id = 268225, targetIlvl = 344, source = "The Coiled Altar / Catalyst", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Breakwater Boots", id = 268247, targetIlvl = 344, source = "Nymrissa Wavecaller" },
    { slot = "finger1", name = "Vile Alchemist's Band", id = 268249, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "finger2", name = "Sickening Signet of Atroxus", id = 252258, targetIlvl = 344, source = "Voidscar Arena" },
    { slot = "trinket1", name = "Wavecaller's Seastone", id = 270167, targetIlvl = 344, source = "Nymrissa Wavecaller" },
    { slot = "trinket2", name = "Soulcoiler Ritual Vessel", id = 270162, targetIlvl = 344, source = "Nek'zali the Soulcoiler" },
    { slot = "mainhand", name = "Staff of the Lightning Serpent", id = 159636, targetIlvl = 344, source = "Temple of Sethraliss", altIds = { 271092 }, altNote = "Alternative: Jan'thrazet, the Soul Fang — Ula'tek." },
    { slot = "offhand", name = "Spine of the Hissing Abyss", id = 268197, targetIlvl = 344, source = "Entombed Sentinels" },
  },
}
ns.GearBySpecID[105] = ns.Gear["DRUID:Restoration"]

-- Devastation Evoker — Scalecommander
ns.Gear["EVOKER:Devastation"] = {
  title = "Devastation Evoker",
  specID = 1467,
  hero = "Scalecommander",
  notes = "M+ hero talent used for this list: Scalecommander. Method lists a Scalecommander Mythic+ & Cleave build first; a Flameshaper M+ build is also published. Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/devastation-evoker/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Sethraliss' Fanged Helm", id = 239035, targetIlvl = 344, source = "Temple of Selthraliss(Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Soulslither Spaulders", id = 268231, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Awoken Dreadfang Cuirass", id = 271876, targetIlvl = 344, source = "Ula’tek" },
    { slot = "wrist", name = "Farstrider's Plated Bracers", id = 244584, targetIlvl = 331, source = "Crafting" },
    { slot = "hands", name = "Aberrant Commander's Gauntlets", id = 281238, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Serpentine Mixing Belt", id = 268254, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "legs", name = "Cuisses of the Uncoiled Union", id = 268237, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Ferocious Scaleboots", id = 268233, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "finger2", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "trinket1", name = "Gebbo's Bottomless Bag", id = 270164, targetIlvl = 344, source = "The Lost Explorers" },
    { slot = "trinket2", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Aln'hara Lantern", id = 245769, targetIlvl = 331, source = "Crafting" },
  },
}
ns.GearBySpecID[1467] = ns.Gear["EVOKER:Devastation"]

-- Preservation Evoker — Flameshaper
ns.Gear["EVOKER:Preservation"] = {
  title = "Preservation Evoker",
  specID = 1468,
  hero = "Flameshaper",
  notes = "M+ hero talent used for this list: Flameshaper. Method: Flameshaper is the default for both raid and M+ (Chronowarden is a viable alternative). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Preservation Evoker.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/preservation-evoker/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Calamitous Echo's Magmashapers", id = 271501, targetIlvl = 344, source = "The Venomous Abyss", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "The Venomous Abyss" },
    { slot = "shoulder", name = "Calamitous Echo's Sundered Peaks", id = 271499, targetIlvl = 344, source = "The Venomous Abyss", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Awoken Dreadfang Cuirass", id = 271876, targetIlvl = 344, source = "The Venomous Abyss (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Rising Tide Wristguards", id = 268217, targetIlvl = 344, source = "Nymrissa Wavecaller" },
    { slot = "hands", name = "Aberrant Commander's Gauntlets", id = 281238, targetIlvl = 344, source = "Kith'ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Serpentine Mixing Belt", id = 268254, targetIlvl = 344, source = "The Venomous Abyss" },
    { slot = "legs", name = "Earthen Pillars of Calamity", id = 271500, targetIlvl = 344, source = "The Venomous Abyss", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Ferocious Scaleboots", id = 268233, targetIlvl = 344, source = "Sszorak / Temple of Sethraliss", altIds = { 159388 }, altNote = "Also accepted: Sabatons of Coruscating Energy (159388)." },
    { slot = "finger1", name = "Vile Alchemist's Band", id = 268249, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith'ix / Temple of Sethraliss", altIds = { 158366 }, altNote = "Also accepted: Charged Sandstone Band (158366)." },
    { slot = "trinket1", name = "Gebbo's Bottomless Bag", id = 270164, targetIlvl = 344, source = "The Venomous Abyss" },
    { slot = "trinket2", name = "Soulcoiler Ritual Vessel", id = 270162, targetIlvl = 344, source = "The Venomous Abyss" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "The Venomous Abyss", altIds = { 268205 }, altNote = "Alternative: Venomancer's Winged Channeler — The Venomous Abyss." },
    { slot = "offhand", name = "Luminescent Sprout", id = 251191, targetIlvl = 344, source = "The Blinding Vale / Entombed Sentinels", altIds = { 268197 }, altNote = "Also accepted: Spine of the Hissing Abyss (268197)." },
  },
}
ns.GearBySpecID[1468] = ns.Gear["EVOKER:Preservation"]

-- Augmentation Evoker — Chronowarden
ns.Gear["EVOKER:Augmentation"] = {
  title = "Augmentation Evoker",
  specID = 1473,
  hero = "Chronowarden",
  notes = "M+ hero talent used for this list: Chronowarden. Method talents recommend Chronowarden for raid and high keys; Scalecommander for lower keys / weekly vault keys. Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Augmentation Evoker.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/augmentation-evoker/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Sethraliss' Fanged Helm", id = 239035, targetIlvl = 344, source = "Temple of Selthraliss(Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Amulet of the Twin Fangs", id = 268251, targetIlvl = 344, source = "Twin Fangs" },
    { slot = "shoulder", name = "Soulslither Spaulders", id = 268231, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Awoken Dreadfang Cuirass", id = 271876, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Farstrider's Plated Bracers", id = 244584, targetIlvl = 331, source = "Crafting" },
    { slot = "hands", name = "Aberrant Commander's Gauntlets", id = 281238, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Farstrider's Trophy Belt", id = 244581, targetIlvl = 331, source = "Crafting" },
    { slot = "legs", name = "Cuisses of the Uncoiled Union", id = 268237, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Ferocious Scaleboots", id = 268233, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "finger2", name = "Vile Alchemist's Band", id = 268249, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "trinket1", name = "Font of Venomous Rage", id = 270168, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Spine of the Hissing Abyss", id = 268197, targetIlvl = 344, source = "Entombed Sentinels" },
  },
}
ns.GearBySpecID[1473] = ns.Gear["EVOKER:Augmentation"]

-- Beast Mastery Hunter — Pack Leader
ns.Gear["HUNTER:Beast Mastery"] = {
  title = "Beast Mastery Hunter",
  specID = 253,
  hero = "Pack Leader",
  notes = "M+ hero talent used for this list: Pack Leader (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for BM Hunter.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/beast-mastery-hunter/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Voidscarred Crown", id = 251220, targetIlvl = 344, source = "Voidscar Arena (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’Tek" },
    { slot = "shoulder", name = "Soulslither Spaulders", id = 268231, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Awoken Dreadfang Cuirass", id = 271876, targetIlvl = 344, source = "Ula’Tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Farstrider's Plated Bracers", id = 244584, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Aberrant Commander's Gauntlets", id = 281238, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Farstrider's Trophy Belt", id = 244581, targetIlvl = 331, source = "Crafted" },
    { slot = "legs", name = "Cuisses of the Uncoiled Union", id = 268237, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Ferocious Scaleboots", id = 268233, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger1", name = "Vile Alchemist's Band", id = 268249, targetIlvl = 344, source = "Vashnik" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket2", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’Tek", altIds = { 270168 }, altNote = "Also accepted: Font of Venomous Rage (270168)." },
    { slot = "mainhand", name = "Caustic Repose Greatbow", id = 268207, targetIlvl = 344, source = "Ula’Tek" },
  },
}
ns.GearBySpecID[253] = ns.Gear["HUNTER:Beast Mastery"]

-- Marksmanship Hunter — Sentinel
ns.Gear["HUNTER:Marksmanship"] = {
  title = "Marksmanship Hunter",
  specID = 254,
  hero = "Sentinel",
  notes = "M+ hero talent used for this list: Sentinel (most popular in MaxWoW's top 50 M+ players this season: 44/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for MM Hunter.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/marksmanship-hunter/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Crown of the Eternal Fang", id = 268230, targetIlvl = 344, source = "Nek'zali the Soulcoiler", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’Tek" },
    { slot = "shoulder", name = "Soulslither Spaulders", id = 268231, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Shroud of the Skulking Viper", id = 271487, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "chest", name = "Awoken Dreadfang Cuirass", id = 271876, targetIlvl = 344, source = "Ula’Tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Farstrider's Plated Bracers", id = 244584, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Aberrant Commander's Gauntlets", id = 281238, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Farstrider's Trophy Belt", id = 244581, targetIlvl = 331, source = "Crafted" },
    { slot = "legs", name = "Cuisses of the Uncoiled Union", id = 268237, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Boots of the Reckless Wayfarer", id = 268258, targetIlvl = 344, source = "The Lost Explorers" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "finger2", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "trinket1", name = "Font of Venomous Rage", id = 270168, targetIlvl = 344, source = "Ula’Tek" },
    { slot = "trinket2", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’Tek" },
    { slot = "mainhand", name = "Caustic Repose Greatbow", id = 268207, targetIlvl = 344, source = "Ula’Tek" },
  },
}
ns.GearBySpecID[254] = ns.Gear["HUNTER:Marksmanship"]

-- Survival Hunter — Sentinel
ns.Gear["HUNTER:Survival"] = {
  title = "Survival Hunter",
  specID = 255,
  hero = "Sentinel",
  notes = "M+ hero talent used for this list: Sentinel (most popular in MaxWoW's top 50 M+ players this season: 44/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Survival Hunter.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/survival-hunter/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Sethraliss' Fanged Helm", id = 239035, targetIlvl = 344, source = "Temple of Sethraliss", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula'tek" },
    { slot = "shoulder", name = "Jaws of the Skulking Viper", id = 271490, targetIlvl = 344, source = "The Coiled Altar", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Colled Altar" },
    { slot = "chest", name = "Awoken Dreadfang Cuirass", id = 271876, targetIlvl = 344, source = "Ula'tek" },
    { slot = "wrist", name = "Farstrider's Plated Bracers", id = 244584, targetIlvl = 331, source = "Crafting" },
    { slot = "hands", name = "Aberrant Commander's Gauntlets", id = 281238, targetIlvl = 344, source = "Kith'ix", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Farstrider's Trophy Belt", id = 244581, targetIlvl = 331, source = "Crafting" },
    { slot = "legs", name = "Cuisses of the Uncoiled Union", id = 268237, targetIlvl = 344, source = "The Colled Altar", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Ferocious Scaleboots", id = 268233, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith'ix" },
    { slot = "finger2", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula'tek" },
    { slot = "trinket2", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith'ix" },
    { slot = "mainhand", name = "Abyssal Broodfiend's Bardiche", id = 268215, targetIlvl = 344, source = "Ula'tek" },
  },
}
ns.GearBySpecID[255] = ns.Gear["HUNTER:Survival"]

-- Arcane Mage — Sunfury
ns.Gear["MAGE:Arcane"] = {
  title = "Arcane Mage",
  specID = 62,
  hero = "Sunfury",
  notes = "M+ hero talent used for this list: Sunfury (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/arcane-mage/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Venomkeeper's Horrific Cowl", id = 271874, targetIlvl = 344, source = "Ula’tek" },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Primal Leywarden's Manaflux", id = 271562, targetIlvl = 344, source = "The Lost Explorers" },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Crest of the Primal Leywarden", id = 271567, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "wrist", name = "Martyr's Bindings", id = 239648, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Primal Leywarden's Manashapers", id = 271565, targetIlvl = 344, source = "Entombed Sentinels" },
    { slot = "waist", name = "Caustic Chain-Wrapped Sash", id = 268257, targetIlvl = 344, source = "Sszorak" },
    { slot = "legs", name = "Voidweaver's Leggings", id = 281235, targetIlvl = 344, source = "Kith’ix" },
    { slot = "feet", name = "Cackling Soultreads", id = 268255, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "finger2", name = "Pilfered Precious Band", id = 251148, targetIlvl = 344, source = "Den of Narolakk" },
    { slot = "trinket1", name = "Freightrunner's Flask", id = 250215, targetIlvl = 344, source = "Murder Row" },
    { slot = "trinket2", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Aln'hara Lantern", id = 245769, targetIlvl = 331, source = "Crafted" },
  },
}
ns.GearBySpecID[62] = ns.Gear["MAGE:Arcane"]

-- Fire Mage — Sunfury
ns.Gear["MAGE:Fire"] = {
  title = "Fire Mage",
  specID = 63,
  hero = "Sunfury",
  notes = "M+ hero talent used for this list: Sunfury (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Fire Mage.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/fire-mage/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Venomkeeper's Horrific Cowl", id = 271874, targetIlvl = 344, source = "Ula’tek" },
    { slot = "neck", name = "Pendant of Malefic Fury", id = 251142, targetIlvl = 344, source = "Murder Row" },
    { slot = "shoulder", name = "Ornaments of the Eternal Coil", id = 268241, targetIlvl = 344, source = "The Twin Fangs" },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Primordial Robe of Rites", id = 273785, targetIlvl = 344, source = "Altar of Fangs" },
    { slot = "wrist", name = "Martyr's Bindings", id = 239648, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Grasps of the Eternal Shadow", id = 268243, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "waist", name = "Caustic Chain-Wrapped Sash", id = 268257, targetIlvl = 344, source = "Sszorak" },
    { slot = "legs", name = "Initiate's Sacrificial Tights", id = 268236, targetIlvl = 344, source = "Nek’zali the soulcoiler" },
    { slot = "feet", name = "Cackling Soultreads", id = 268255, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "finger1", name = "Alluring Bubbleband", id = 268266, targetIlvl = 344, source = "Nymrissa Wavecaller (solo raid)" },
    { slot = "finger2", name = "Ritual Binder's Ring", id = 159459, targetIlvl = 344, source = "King’s Rest" },
    { slot = "trinket1", name = "Vile Vial of Volatile Venom", id = 273796, targetIlvl = 344, source = "Altar of Fangs" },
    { slot = "trinket2", name = "Gebbo's Bottomless Bag", id = 270164, targetIlvl = 344, source = "The Lost Explorers" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Aln'hara Lantern", id = 245769, targetIlvl = 331, source = "Crafted" },
  },
}
ns.GearBySpecID[63] = ns.Gear["MAGE:Fire"]

-- Frost Mage — Frostfire
ns.Gear["MAGE:Frost"] = {
  title = "Frost Mage",
  specID = 64,
  hero = "Frostfire",
  notes = "M+ hero talent used for this list: Frostfire (most popular in MaxWoW's top 50 M+ players this season: 26/50). MaxWoW M+ sample: Frostfire 26/50 (close split). This list follows Method's overall Frost Mage BiS used with that default. Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Frost Mage.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/frost-mage/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Venomkeeper's Horrific Cowl", id = 271874, targetIlvl = 344, source = "Ula’tek" },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Primal Leywarden's Manaflux", id = 271562, targetIlvl = 344, source = "The Lost Explorers" },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Crest of the Primal Leywarden", id = 271567, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "wrist", name = "Martyr's Bindings", id = 239648, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Primal Leywarden's Manashapers", id = 271565, targetIlvl = 344, source = "Entombed Sentinels" },
    { slot = "waist", name = "Arcanoweave Cord", id = 239664, targetIlvl = 331, source = "Crafted" },
    { slot = "legs", name = "Voidweaver's Leggings", id = 281235, targetIlvl = 344, source = "Kith’ix" },
    { slot = "feet", name = "Cackling Soultreads", id = 268255, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "finger2", name = "Charged Sandstone Band", id = 158366, targetIlvl = 344, source = "Temple of Sethraliss" },
    { slot = "trinket1", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket2", name = "Gebbo's Bottomless Bag", id = 270164, targetIlvl = 344, source = "The Lost Explorers" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Vessel of Last Rites", id = 159667, targetIlvl = 344, source = "King’s Rest" },
  },
}
ns.GearBySpecID[64] = ns.Gear["MAGE:Frost"]

-- Brewmaster Monk — Master of Harmony
ns.Gear["MONK:Brewmaster"] = {
  title = "Brewmaster Monk",
  specID = 268,
  hero = "Master of Harmony",
  notes = "M+ hero talent used for this list: Master of Harmony (most popular in MaxWoW's top 50 M+ players this season: 43/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/brewmaster-monk/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Gaze of the Coiled Watcher", id = 271875, targetIlvl = 344, source = "Ula’tek" },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Snakeskin Spaulders", id = 273774, targetIlvl = 344, source = "Altar of Fangs (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Hide of Pestilence", id = 251226, targetIlvl = 344, source = "Voidscar Arena (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Silvermoon Agent's Deflectors", id = 244576, targetIlvl = 331, source = "Crafting" },
    { slot = "hands", name = "Subjugator's Chilling Grips", id = 193758, targetIlvl = 344, source = "Ruby Life Pools (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Sash of the Forlorn Vessel", id = 268256, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Coiled Hex Legguards", id = 268225, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Miststalker's Striders", id = 272240, targetIlvl = 344, source = "Labyrinth of Kindo’jan" },
    { slot = "finger1", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger2", name = "Loa Worshiper's Band", id = 251513, targetIlvl = 331, source = "Crafting" },
    { slot = "trinket1", name = "Font of Venomous Rage", id = 270168, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "mainhand", name = "Abyssal Broodfiend's Bardiche", id = 268215, targetIlvl = 344, source = "Ula’tek" },
  },
}
ns.GearBySpecID[268] = ns.Gear["MONK:Brewmaster"]

-- Windwalker Monk — Conduit of the Celestials
ns.Gear["MONK:Windwalker"] = {
  title = "Windwalker Monk",
  specID = 269,
  hero = "Conduit of the Celestials",
  notes = "M+ hero talent used for this list: Conduit of the Celestials (most popular in MaxWoW's top 50 M+ players this season: 48/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Windwalker Monk.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/windwalker-monk/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Gaze of the Coiled Watcher", id = 271875, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Tassels of the Monkey King", id = 271517, targetIlvl = 344, source = "The Lost Explorers", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Chestwrap of Palpable Terror", id = 281236, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Silvermoon Agent's Deflectors", id = 244576, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Gauntlets of Fevered Defense", id = 251124, targetIlvl = 344, source = "Murder Row", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Sash of the Forlorn Vessel", id = 268256, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Coiled Hex Legguards", id = 268225, targetIlvl = 344, source = "The Coiled Altar", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Silvermoon Agent's Sneakers", id = 244569, targetIlvl = 331, source = "Crafted" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "finger2", name = "Band of the Amani Warlord", id = 273792, targetIlvl = 344, source = "Altar of Fangs" },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "mainhand", name = "Abyssal Broodfiend's Bardiche", id = 268215, targetIlvl = 344, source = "Ula’tek" },
  },
}
ns.GearBySpecID[269] = ns.Gear["MONK:Windwalker"]

-- Mistweaver Monk — Conduit of the Celestials
ns.Gear["MONK:Mistweaver"] = {
  title = "Mistweaver Monk",
  specID = 270,
  hero = "Conduit of the Celestials",
  notes = "M+ hero talent used for this list: Conduit of the Celestials (most popular in MaxWoW's top 50 M+ players this season: 49/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Mistweaver Monk.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/mistweaver-monk/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Gaze of the Coiled Watcher", id = 271875, targetIlvl = 344, source = "Ula’tek", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Somber Spaulders", id = 251223, targetIlvl = 344, source = "Voidscar Arena", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Chestwrap of Palpable Terror", id = 281236, targetIlvl = 344, source = "Kith'ix", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Restless Spirit Shackles", id = 268240, targetIlvl = 344, source = "Nek’zali the Soulcoiler" },
    { slot = "hands", name = "Monkey King's Fighting Fists", id = 271520, targetIlvl = 344, source = "Entombed Sentinels", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Sash of the Forlorn Vessel", id = 268256, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Coiled Hex Legguards", id = 268225, targetIlvl = 344, source = "The Coiled Altar", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Bespittled Slitherslippers", id = 268261, targetIlvl = 344, source = "The Twin Fangs" },
    { slot = "finger1", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger2", name = "Alluring Bubbleband", id = 268266, targetIlvl = 344, source = "Nymrissa Wavecaller" },
    { slot = "trinket1", name = "Wavecaller's Seastone", id = 270167, targetIlvl = 344, source = "Nymrissa Wavecaller" },
    { slot = "trinket2", name = "Soulcoiler Ritual Vessel", id = 270162, targetIlvl = 344, source = "Nekzali the Soulcoiler" },
    { slot = "mainhand", name = "Sanctified Knight's Phoenixblade", id = 281056, targetIlvl = 344, source = "Kith’ix" },
    { slot = "offhand", name = "Aln'hara Lantern", id = 245769, targetIlvl = 331, source = "Crafted", altIds = { 245874 }, altNote = "Also accepted: Darkmoon Sigil: Void (245874)." },
  },
}
ns.GearBySpecID[270] = ns.Gear["MONK:Mistweaver"]

-- Holy Paladin — Lightsmith
ns.Gear["PALADIN:Holy"] = {
  title = "Holy Paladin",
  specID = 65,
  hero = "Lightsmith",
  notes = "M+ hero talent used for this list: Lightsmith (most popular in MaxWoW's top 50 M+ players this season: 42/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Holy Paladin.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/holy-paladin/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Corroded Hulk's Skullcap", id = 281239, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Cinderfury Shoulderguards", id = 251138, targetIlvl = 344, source = "Murder Row (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Reckless Spirit Breastplate", id = 268222, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Shellbound Bracers", id = 268239, targetIlvl = 344, source = "The Lost Explorers" },
    { slot = "hands", name = "Gauntlets of the Avian Sentinel", id = 159413, targetIlvl = 344, source = "King’s Rest (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Girdle of Toxic Regret", id = 268259, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Chausses of Unbound Rancor", id = 271878, targetIlvl = 344, source = "Ula’tek" },
    { slot = "feet", name = "Scaled Fiend's Warboots", id = 268260, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "finger1", name = "Vile Alchemist's Band", id = 268249, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Soulcoiler Ritual Vessel", id = 270162, targetIlvl = 344, source = "Nek’zali the Soulcoiler" },
    { slot = "trinket2", name = "Gebbo's Bottomless Bag", id = 270164, targetIlvl = 344, source = "Mor'zahi" },
    { slot = "mainhand", name = "Baleful Hexblade", id = 268211, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "offhand", name = "Bubblefin Splash Guard", id = 268262, targetIlvl = 344, source = "The Tidebound Grotto" },
  },
}
ns.GearBySpecID[65] = ns.Gear["PALADIN:Holy"]

-- Protection Paladin — Lightsmith
ns.Gear["PALADIN:Protection"] = {
  title = "Protection Paladin",
  specID = 66,
  hero = "Lightsmith",
  notes = "M+ hero talent used for this list: Lightsmith (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/protection-paladin/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Corroded Hulk's Skullcap", id = 281239, targetIlvl = 344, source = "Kith’ix" },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "C'thraxxi Binders Pauldrons", id = 239037, targetIlvl = 344, source = "Temple of Sethraliss (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Reckless Spirit Breastplate", id = 268222, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Embalmer's Steadying Bracers", id = 159409, targetIlvl = 344, source = "Kings’ Rest" },
    { slot = "hands", name = "Scaleplate Strangulators", id = 268220, targetIlvl = 344, source = "The Twin Fangs (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Girdle of Toxic Regret", id = 268259, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Chausses of Unbound Rancor", id = 271878, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Entombed Cultist's Sabatons", id = 268245, targetIlvl = 344, source = "Nek’zali the Soulcoiler" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "finger2", name = "Band of the Amani Warlord", id = 273792, targetIlvl = 344, source = "Altar of Fangs" },
    { slot = "trinket1", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "mainhand", name = "Aman'muso, Warlord's Vengeance", id = 268209, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "offhand", name = "Venom-Slashed Scuteward", id = 268196, targetIlvl = 344, source = "The Lost Explorers" },
  },
}
ns.GearBySpecID[66] = ns.Gear["PALADIN:Protection"]

-- Retribution Paladin — Herald of the Sun
ns.Gear["PALADIN:Retribution"] = {
  title = "Retribution Paladin",
  specID = 70,
  hero = "Herald of the Sun",
  notes = "M+ hero talent used for this list: Herald of the Sun (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/retribution-paladin/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Warhelm of the Consecrated Flame", id = 271465, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Pauldrons of the Consecrated Flame", id = 271463, targetIlvl = 344, source = "Murder Row (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Bulwark of the Consecrated Flame", id = 271468, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Spellbreaker's Bracers", id = 237834, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Gauntlets of the Consecrated Flame", id = 271466, targetIlvl = 344, source = "Den of Nalorakk (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Girdle of Toxic Regret", id = 268259, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Greaves of the Consecrated Flame", id = 271464, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Scaled Fiend's Warboots", id = 268260, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "finger2", name = "Loa Worshiper's Band", id = 251513, targetIlvl = 331, source = "Crafted" },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "mainhand", name = "Maze-roa, Warlord's Fury", id = 268213, targetIlvl = 344, source = "The Coiled Altar" },
  },
}
ns.GearBySpecID[70] = ns.Gear["PALADIN:Retribution"]

-- Discipline Priest — Oracle
ns.Gear["PRIEST:Discipline"] = {
  title = "Discipline Priest",
  specID = 256,
  hero = "Oracle",
  notes = "M+ hero talent used for this list: Oracle (most popular in MaxWoW's top 50 M+ players this season: 42/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/discipline-priest/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Venomkeeper's Horrific Cowl", id = 271874, targetIlvl = 344, source = "Ula'tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula'tek" },
    { slot = "shoulder", name = "Brood Cleanser's Amice", id = 239031, targetIlvl = 344, source = "Temple of Sethraliss (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Bloodthorn Burnous", id = 251190, targetIlvl = 344, source = "The Blinding Vale" },
    { slot = "chest", name = "Summoner's Searing Shirt", id = 251139, targetIlvl = 344, source = "Murder Row (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Martyr's Bindings", id = 239648, targetIlvl = 331, source = "Crafted (Arcanoweave Lining)" },
    { slot = "hands", name = "Grasps of the Eternal Shadow", id = 268243, targetIlvl = 344, source = "Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Caustic Chain-Wrapped Sash", id = 268257, targetIlvl = 344, source = "Sszorak" },
    { slot = "legs", name = "Forest Dream Leg-guards", id = 251160, targetIlvl = 344, source = "Den of Nalorakk (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Cackling Soultreads", id = 268255, targetIlvl = 344, source = "Coiled Altar" },
    { slot = "finger1", name = "Band of the Amani Warlord", id = 273792, targetIlvl = 344, source = "Altar of Fangs" },
    { slot = "finger2", name = "Sickening Signet of Atroxus", id = 252258, targetIlvl = 344, source = "Voidscar Arena" },
    { slot = "trinket1", name = "Hex Lord's Dooming Idol", id = 270169, targetIlvl = 344, source = "Coiled Altar" },
    { slot = "trinket2", name = "Wavecaller's Seastone", id = 270167, targetIlvl = 344, source = "Nymrissa Wavecaller" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula'tek" },
    { slot = "offhand", name = "Aln'hara Lantern", id = 245769, targetIlvl = 331, source = "Crafted (Hunter's Ritual Stone)" },
  },
}
ns.GearBySpecID[256] = ns.Gear["PRIEST:Discipline"]

-- Holy Priest — Oracle
ns.Gear["PRIEST:Holy"] = {
  title = "Holy Priest",
  specID = 257,
  hero = "Oracle",
  notes = "M+ hero talent used for this list: Oracle (most popular in MaxWoW's top 50 M+ players this season: 49/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/holy-priest/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Venomkeeper's Horrific Cowl", id = 271874, targetIlvl = 344, source = "Ula'tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula'tek" },
    { slot = "shoulder", name = "Cosmic Penitent's Echoing Screams", id = 271553, targetIlvl = 344, source = "Lost Explorers (Token)" },
    { slot = "back", name = "Speakeasy Shroud", id = 251132, targetIlvl = 344, source = "Murder Row" },
    { slot = "chest", name = "Tidebound Sorcereress's Robes", id = 268221, targetIlvl = 344, source = "Nymrissa Wavecaller (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Martyr's Bindings", id = 239648, targetIlvl = 331, source = "Crafted(Arcanoweave Lining)" },
    { slot = "hands", name = "Handwraps of Blasphemous Rites", id = 273773, targetIlvl = 344, source = "Altar of Fangs (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Cincture of the Abyssal Grotto", id = 268232, targetIlvl = 344, source = "Nymrissa Wavecaller" },
    { slot = "legs", name = "Voidweaver's Leggings", id = 281235, targetIlvl = 344, source = "Kith'ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Nek'zali's Spiritwalkers", id = 268218, targetIlvl = 344, source = "Nek'zali" },
    { slot = "finger1", name = "Signet of Snarling Servitude", id = 251136, targetIlvl = 344, source = "Murder Row" },
    { slot = "finger2", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "trinket1", name = "Soulcoiler Ritual Vessel", id = 270162, targetIlvl = 344, source = "Nek'zali" },
    { slot = "trinket2", name = "Gebbo's Bottomless Bag", id = 270164, targetIlvl = 344, source = "Lost Explorers" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula'tek" },
    { slot = "offhand", name = "Aln'hara Lantern", id = 245769, targetIlvl = 331, source = "Crafted (Darkmoon Sigil: Hunt)" },
  },
}
ns.GearBySpecID[257] = ns.Gear["PRIEST:Holy"]

-- Shadow Priest — Archon
ns.Gear["PRIEST:Shadow"] = {
  title = "Shadow Priest",
  specID = 258,
  hero = "Archon",
  notes = "M+ hero talent used for this list: Archon (most popular in MaxWoW's top 50 M+ players this season: 36/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Shadow Priest Overall Best Gear.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/SHADOW-PRIEST/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Cosmic Penitent's Truesight", id = 271555, targetIlvl = 344, source = "Tier set token / Catalyst", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Mantle of Ceremonial Ascension", id = 239045, targetIlvl = 344, source = "Kings’ Rest" },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Cosmic Penitent's Eclipsing Robes", id = 271558, targetIlvl = 344, source = "Tier set token / Catalyst", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Martyr's Bindings", id = 239648, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Cosmic Penitent's Celestial Grips", id = 271556, targetIlvl = 344, source = "Tier set token / Catalyst", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Martyr's Waistwrap", id = 239649, targetIlvl = 331, source = "Crafted" },
    { slot = "legs", name = "Enveloping Legwraps of the Cosmic Penitent", id = 271554, targetIlvl = 344, source = "Tier set token / Catalyst", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Cackling Soultreads", id = 268255, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "finger2", name = "Vile Alchemist's Band", id = 268249, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "trinket1", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket2", name = "Freightrunner's Flask", id = 250215, targetIlvl = 344, source = "Murder Row" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Spine of the Hissing Abyss", id = 268197, targetIlvl = 344, source = "Entomed Sentinels" },
  },
}
ns.GearBySpecID[258] = ns.Gear["PRIEST:Shadow"]

-- Assassination Rogue — Fatebound
ns.Gear["ROGUE:Assassination"] = {
  title = "Assassination Rogue",
  specID = 259,
  hero = "Fatebound",
  notes = "M+ hero talent used for this list: Fatebound (most popular in MaxWoW's top 50 M+ players this season: 26/50). MaxWoW M+ sample: Fatebound 26/50 (close split). This list follows Method's overall Assassination BiS. Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Assassination Rogue.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/assassination-rogue/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Gaze of the Coiled Watcher", id = 271875, targetIlvl = 344, source = "Ula'tek (Catalyzed)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Somber Spaulders", id = 251223, targetIlvl = 344, source = "Voidscar Arena (Catalyzed)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Chestwrap of Palpable Terror", id = 281236, targetIlvl = 344, source = "Kith’ix (Catalyzed)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Silvermoon Agent's Deflectors", id = 244576, targetIlvl = 331, source = "Crafting" },
    { slot = "hands", name = "Chosen Bloodslayer's Fanged Grips", id = 271511, targetIlvl = 344, source = "Entombed Sentinels" },
    { slot = "waist", name = "Sash of the Forlorn Vessel", id = 268256, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Coiled Hex Legguards", id = 268225, targetIlvl = 344, source = "The Coiled Altar (Catalyzed)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Silvermoon Agent's Sneakers", id = 244569, targetIlvl = 331, source = "Crafting" },
    { slot = "finger1", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "mainhand", name = "Zatha'tek, Breath of Corruption", id = 271093, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Sharpened Lightwood Slasher", id = 275070, targetIlvl = 344, source = "Altar of Fangs" },
  },
}
ns.GearBySpecID[259] = ns.Gear["ROGUE:Assassination"]

-- Outlaw Rogue — Trickster
ns.Gear["ROGUE:Outlaw"] = {
  title = "Outlaw Rogue",
  specID = 260,
  hero = "Trickster",
  notes = "M+ hero talent used for this list: Trickster (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Outlaw Rogue.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/outlaw-rogue/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Gaze of the Coiled Watcher", id = 271875, targetIlvl = 344, source = "Ula'tek" },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Chosen Bloodslayer's Voodoo Guards", id = 271508, targetIlvl = 344, source = "The Lost Explorers" },
    { slot = "back", name = "Amani Summoning Shawl", id = 268248, targetIlvl = 344, source = "Nek’zali the Soulcoiler" },
    { slot = "chest", name = "Chosen Bloodslayer's Banded Poncho", id = 271513, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Restless Spirit Shackles", id = 268240, targetIlvl = 344, source = "Nek’zali the Soulcoiler" },
    { slot = "hands", name = "Chosen Bloodslayer's Fanged Grips", id = 271511, targetIlvl = 344, source = "Murder Row (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Silvermoon Agent's Utility Belt", id = 244573, targetIlvl = 331, source = "Crafting; Embellishment: Arcanoweave Lining" },
    { slot = "legs", name = "Chosen Bloodslayer's Reinforced Pants", id = 271509, targetIlvl = 344, source = "Sszorak" },
    { slot = "feet", name = "Silvermoon Agent's Sneakers", id = 244569, targetIlvl = 331, source = "Crafting; Embellishment: Arcanoweave Lining" },
    { slot = "finger1", name = "Alluring Bubbleband", id = 268266, targetIlvl = 344, source = "Nymrissa Wavecaller" },
    { slot = "finger2", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "trinket1", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "trinket2", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "mainhand", name = "Aman'muso, Warlord's Vengeance", id = 268209, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "offhand", name = "Sharpened Lightwood Slasher", id = 275070, targetIlvl = 344, source = "Altar of Fangs" },
  },
}
ns.GearBySpecID[260] = ns.Gear["ROGUE:Outlaw"]

-- Subtlety Rogue — Trickster
ns.Gear["ROGUE:Subtlety"] = {
  title = "Subtlety Rogue",
  specID = 261,
  hero = "Trickster",
  notes = "M+ hero talent used for this list: Trickster (most popular in MaxWoW's top 50 M+ players this season: 48/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Subtlety Rogue.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/subtlety-rogue/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Chosen Bloodslayer's Spirit Shroud", id = 271510, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Chosen Bloodslayer's Voodoo Guards", id = 271508, targetIlvl = 344, source = "Vashnik the Maligant (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Chosen Bloodslayer's Banded Poncho", id = 271513, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Silvermoon Agent's Deflectors", id = 244576, targetIlvl = 344, source = "Leatherworking" },
    { slot = "hands", name = "Chosen Bloodslayer's Fanged Grips", id = 271511, targetIlvl = 344, source = "Sszorak (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Sash of the Forlorn Vessel", id = 268256, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Chosen Bloodslayer's Reinforced Pants", id = 271509, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Arctic Explorer's Legwraps", id = 251153, targetIlvl = 344, source = "Den of Nalorakk" },
    { slot = "finger1", name = "Lightwarden's Bind", id = 251194, targetIlvl = 344, source = "Blinding Vale" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "mainhand", name = "Zatha'tek, Breath of Corruption", id = 271093, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Farstrider's Mercy", id = 237837, targetIlvl = 344, source = "Blacksmithing" },
  },
}
ns.GearBySpecID[261] = ns.Gear["ROGUE:Subtlety"]

-- Elemental Shaman — Farseer
ns.Gear["SHAMAN:Elemental"] = {
  title = "Elemental Shaman",
  specID = 262,
  hero = "Farseer",
  notes = "M+ hero talent used for this list: Farseer (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Elemental Shaman.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/elemental-shaman/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Voidscarred Crown", id = 251220, targetIlvl = 344, source = "Voidscar Arena (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Soulslither Spaulders", id = 268231, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Awoken Dreadfang Cuirass", id = 271876, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Farstrider's Plated Bracers", id = 244584, targetIlvl = 344, source = "Leatherworking; Embellishment: Arcanoweave Lining" },
    { slot = "hands", name = "Aberrant Commander's Gauntlets", id = 281238, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Farstrider's Trophy Belt", id = 244581, targetIlvl = 344, source = "Leatherworking; Embellishment: Arcanoweave Lining" },
    { slot = "legs", name = "Cuisses of the Uncoiled Union", id = 268237, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Ferocious Scaleboots", id = 268233, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger1", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Vile Vial of Volatile Venom", id = 273796, targetIlvl = 344, source = "Altar of Fangs" },
    { slot = "trinket2", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Bubblefin Splash Guard", id = 268262, targetIlvl = 344, source = "Nymrissa Wavecaller" },
  },
}
ns.GearBySpecID[262] = ns.Gear["SHAMAN:Elemental"]

-- Enhancement Shaman — Stormbringer
ns.Gear["SHAMAN:Enhancement"] = {
  title = "Enhancement Shaman",
  specID = 263,
  hero = "Stormbringer",
  notes = "M+ hero talent used for this list: Stormbringer (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Enhancement Shaman.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/enhancement-shaman/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Serpent Crown of the Ophidian Oracle", id = 271483, targetIlvl = 344, source = "Voidscar Arena (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Hissing Mantle of the Ophidian Oracle", id = 271481, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Fanged Raiment of the Ophidian Oracle", id = 271486, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Farstrider's Plated Bracers", id = 244584, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Hexing Grips of the Ophidian Oracle", id = 271484, targetIlvl = 344, source = "Kith’ix" },
    { slot = "waist", name = "Serpentine Mixing Belt", id = 268254, targetIlvl = 344, source = "Vashnik the Malignant" },
    { slot = "legs", name = "Leggings of the Ophidian Oracle", id = 271482, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Boots of the Reckless Wayfarer", id = 268258, targetIlvl = 344, source = "Entombed Sentinels" },
    { slot = "finger1", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "mainhand", name = "Aman'muso, Warlord's Vengeance", id = 268209, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "offhand", name = "Farstrider's Chopper", id = 237850, targetIlvl = 331, source = "Crafted" },
  },
}
ns.GearBySpecID[263] = ns.Gear["SHAMAN:Enhancement"]

-- Restoration Shaman — Totemic
ns.Gear["SHAMAN:Restoration"] = {
  title = "Restoration Shaman",
  specID = 264,
  hero = "Totemic",
  notes = "M+ hero talent used for this list: Totemic (most popular in MaxWoW's top 50 M+ players this season: 49/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Restoration Shaman.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/restoration-shaman/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Serpent Crown of the Ophidian Oracle", id = 271483, targetIlvl = 344, source = "The Twin Fangs" },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Jangling Felpaulets", id = 251131, targetIlvl = 344, source = "Murder Row" },
    { slot = "back", name = "Adherent's Silken Shroud", id = 239656, targetIlvl = 331, source = "Crafted" },
    { slot = "chest", name = "Awoken Dreadfang Cuirass", id = 271876, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Farstrider's Plated Bracers", id = 244584, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Hexing Grips of the Ophidian Oracle", id = 271484, targetIlvl = 344, source = "Entombed Sentinels" },
    { slot = "waist", name = "Cursed Reliquary Cincture", id = 268216, targetIlvl = 344, source = "Nek’zali the Soulcoiler" },
    { slot = "legs", name = "Leggings of the Ophidian Oracle", id = 271482, targetIlvl = 344, source = "Sszorak" },
    { slot = "feet", name = "Scaled Shoes of the Ophidian Oracle", id = 271485, targetIlvl = 344, source = "Catalyst", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "finger1", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger2", name = "Pilfered Precious Band", id = 251148, targetIlvl = 344, source = "Den of Nalorakk" },
    { slot = "trinket1", name = "Soulcoiler Ritual Vessel", id = 270162, targetIlvl = 344, source = "Nek’zali the Soulcoiler" },
    { slot = "trinket2", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Venom-Slashed Scuteward", id = 268196, targetIlvl = 344, source = "The Lost Explorers" },
  },
}
ns.GearBySpecID[264] = ns.Gear["SHAMAN:Restoration"]

-- Affliction Warlock — Soul Harvester
ns.Gear["WARLOCK:Affliction"] = {
  title = "Affliction Warlock",
  specID = 265,
  hero = "Soul Harvester",
  notes = "M+ hero talent used for this list: Soul Harvester (most popular in MaxWoW's top 50 M+ players this season: 35/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Affliction Warlock.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/affliction-warlock/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Venomkeeper's Horrific Cowl", id = 271874, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Brood Cleanser's Amice", id = 239031, targetIlvl = 344, source = "Temple of Sethraliss (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Adherent's Silken Shroud", id = 239656, targetIlvl = 344, source = "Tailoring; Embellishment: Arcanoweave Lining" },
    { slot = "chest", name = "Robes of the Reborn Serpent", id = 239032, targetIlvl = 344, source = "Temple of Sethraliss (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Martyr's Bindings", id = 239648, targetIlvl = 344, source = "Tailoring; Embellishment: Arcanoweave Lining" },
    { slot = "hands", name = "Handwraps of Oscillating Polarity", id = 159247, targetIlvl = 344, source = "Temple of Sethraliss (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Ethereal Netherwrap", id = 251222, targetIlvl = 344, source = "Voidscar Arena" },
    { slot = "legs", name = "Voidweaver's Leggings", id = 281235, targetIlvl = 344, source = "Kith'ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Cackling Soultreads", id = 268255, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "finger1", name = "Band of the Amani Warlord", id = 273792, targetIlvl = 344, source = "Altar of Fangs" },
    { slot = "finger2", name = "Alluring Bubbleband", id = 268266, targetIlvl = 344, source = "Nymrissa Wavecaller" },
    { slot = "trinket1", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith'ix" },
    { slot = "trinket2", name = "Stormbound Emblem of Dazar", id = 273649, targetIlvl = 344, source = "King’s Rest" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Kokia's Burnout Rod", id = 193766, targetIlvl = 344, source = "Ruby Life Pools" },
  },
}
ns.GearBySpecID[265] = ns.Gear["WARLOCK:Affliction"]

-- Demonology Warlock — Diabolist
ns.Gear["WARLOCK:Demonology"] = {
  title = "Demonology Warlock",
  specID = 266,
  hero = "Diabolist",
  notes = "M+ hero talent used for this list: Diabolist (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall / Raid Best Gear for Demonology Warlock.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/demonology-warlock/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Venomkeeper's Horrific Cowl", id = 271874, targetIlvl = 344, source = "Ula’tek" },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Spires of the Damned Necrolyte", id = 271544, targetIlvl = 344, source = "Lost Explorers/Catalyst", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Damned Necrolyte's Rattling Robes", id = 271549, targetIlvl = 344, source = "Vashnik the Malignant/Catalyst", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Martyr's Bindings", id = 239648, targetIlvl = 331, source = "Crafted; Embellishment: Arcanoweave Lining" },
    { slot = "hands", name = "Damned Necrolyte's Charred Grasps", id = 271547, targetIlvl = 344, source = "Catalysted From The Coiled Altar", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Ethereal Netherwrap", id = 251222, targetIlvl = 344, source = "Voidscar Arena" },
    { slot = "legs", name = "Damned Necrolyte's Leg Bindings", id = 271545, targetIlvl = 344, source = "Sszorak" },
    { slot = "feet", name = "Cackling Soultreads", id = 268255, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "finger1", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Stormbound Emblem of Dazar", id = 273649, targetIlvl = 344, source = "King’s Rest" },
    { slot = "trinket2", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith’ix" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Aln'hara Lantern", id = 245769, targetIlvl = 331, source = "Crafted; Embellishment: Hunter's Ritual Stone" },
  },
}
ns.GearBySpecID[266] = ns.Gear["WARLOCK:Demonology"]

-- Destruction Warlock — Diabolist
ns.Gear["WARLOCK:Destruction"] = {
  title = "Destruction Warlock",
  specID = 267,
  hero = "Diabolist",
  notes = "M+ hero talent used for this list: Diabolist (most popular in MaxWoW's top 50 M+ players this season: 40/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best in Slot Gear for Destruction Warlock.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/destruction-warlock/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Venomkeeper's Horrific Cowl", id = 271874, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Spires of the Damned Necrolyte", id = 271544, targetIlvl = 344, source = "The Lost Explorers", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Adherent's Silken Shroud", id = 239656, targetIlvl = 344, source = "Tailoring; Embellishment: Arcanoweave Lining" },
    { slot = "chest", name = "Tidebound Sorcereress's Robes", id = 268221, targetIlvl = 344, source = "Nymrissa Wavecaller (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Martyr's Bindings", id = 239648, targetIlvl = 344, source = "Tailoring; Embellishment: Arcanoweave Lining" },
    { slot = "hands", name = "Damned Necrolyte's Charred Grasps", id = 271547, targetIlvl = 344, source = "Entombed Sentinels", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Damned Necrolyte's Clanging Cinch", id = 271543, targetIlvl = 344, source = "Sszorak (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "legs", name = "Voidweaver's Leggings", id = 281235, targetIlvl = 344, source = "Kith'ix", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Cackling Soultreads", id = 268255, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "finger1", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith'ix" },
    { slot = "finger2", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "trinket1", name = "Gebbo's Bottomless Bag", id = 270164, targetIlvl = 344, source = "The Lost Explorers" },
    { slot = "trinket2", name = "Twisted Horror's Tendril", id = 281215, targetIlvl = 344, source = "Kith'ix" },
    { slot = "mainhand", name = "Jan'thrazet, the Soul Fang", id = 271092, targetIlvl = 344, source = "Ula’tek" },
    { slot = "offhand", name = "Frostscale's Mystic Frond", id = 268263, targetIlvl = 344, source = "Nymrissa Wavecaller" },
  },
}
ns.GearBySpecID[267] = ns.Gear["WARLOCK:Destruction"]

-- Arms Warrior — Slayer
ns.Gear["WARRIOR:Arms"] = {
  title = "Arms Warrior",
  specID = 71,
  hero = "Slayer",
  notes = "M+ hero talent used for this list: Slayer (most popular in MaxWoW's top 50 M+ players this season: 50/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/arms-warrior/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Corroded Hulk's Skullcap", id = 281239, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "C'thraxxi Binders Pauldrons", id = 239037, targetIlvl = 344, source = "Temple of Sethraliss (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "Coiled Altar" },
    { slot = "chest", name = "Reckless Spirit Breastplate", id = 268222, targetIlvl = 344, source = "Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Spellbreaker's Bracers", id = 237834, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Bonds of the Hash'ura", id = 251214, targetIlvl = 344, source = "Den of Nalorakk (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Girdle of Toxic Regret", id = 268259, targetIlvl = 344, source = "Coiled Altar" },
    { slot = "legs", name = "Chausses of Unbound Rancor", id = 271878, targetIlvl = 344, source = "Ula’tek", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Spellbreaker's March", id = 237828, targetIlvl = 331, source = "Crafted" },
    { slot = "finger1", name = "Apex Brute's Claw Ring", id = 268252, targetIlvl = 344, source = "Sszorak" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "trinket2", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "mainhand", name = "Maze-roa, Warlord's Fury", id = 268213, targetIlvl = 344, source = "The Coiled Altar (Very Rare)", altIds = { 273782 }, altNote = "Method alternate weapon: Vile Writhefang Glaive (Altar of Fangs)." },
  },
}
ns.GearBySpecID[71] = ns.Gear["WARRIOR:Arms"]

-- Fury Warrior — Slayer
ns.Gear["WARRIOR:Fury"] = {
  title = "Fury Warrior",
  specID = 72,
  hero = "Slayer",
  notes = "M+ hero talent used for this list: Slayer (most popular in MaxWoW's top 50 M+ players this season: 38/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear for Fury Warrior.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/fury-warrior/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Corroded Hulk's Skullcap", id = 281239, targetIlvl = 344, source = "Kith’ix (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "Cinderfury Shoulderguards", id = 251138, targetIlvl = 344, source = "Murder Row (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "Coiled Altar" },
    { slot = "chest", name = "Reckless Spirit Breastplate", id = 268222, targetIlvl = 344, source = "Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Spellbreaker's Bracers", id = 237834, targetIlvl = 331, source = "Crafted" },
    { slot = "hands", name = "Gauntlets of the Avian Sentinel", id = 159413, targetIlvl = 344, source = "King’s Rest (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Girdle of Toxic Regret", id = 268259, targetIlvl = 344, source = "Coiled Altar" },
    { slot = "legs", name = "Chausses of Unbound Rancor", id = 271878, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Spellbreaker's March", id = 237828, targetIlvl = 331, source = "Crafted" },
    { slot = "finger1", name = "Sickening Signet of Atroxus", id = 252258, targetIlvl = 344, source = "Voidscar Arena" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "trinket2", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "mainhand", name = "Maze-roa, Warlord's Fury", id = 268213, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "offhand", name = "Lu'selama, Light's Justice", id = 280799, targetIlvl = 344, source = "Kith’ix" },
  },
}
ns.GearBySpecID[72] = ns.Gear["WARRIOR:Fury"]

-- Protection Warrior — Mountain Thane
ns.Gear["WARRIOR:Protection"] = {
  title = "Protection Warrior",
  specID = 73,
  hero = "Mountain Thane",
  notes = "M+ hero talent used for this list: Mountain Thane (most popular in MaxWoW's top 50 M+ players this season: 49/50). Method overall Best-in-Slot (Midnight Season 2 / 12.1.5). Item level usually beats a 'perfect' lower piece. Sim yourself (Raidbots) before spending crests or sparks. Source table: Overall Best Gear.",
  sources = "Method.gg overall BiS; M+ hero talent from MaxWoW top-50 (or Method talents for Evoker); IDs verified via Wowhead tooltip API, 2026-11-12",
  sourceURL = "https://www.method.gg/guides/protection-warrior/gearing",
  targetIlvl = 344,
  items = {
    { slot = "head", name = "Corroded Hulk's Skullcap", id = 281239, targetIlvl = 344, source = "Tier - Kith’ix" },
    { slot = "neck", name = "Aqirbane Reliquary", id = 268265, targetIlvl = 344, source = "Ula’tek" },
    { slot = "shoulder", name = "C'thraxxi Binders Pauldrons", id = 239037, targetIlvl = 344, source = "Temple of Sethraliss (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "back", name = "Silken Voodoo Drape", id = 268253, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "chest", name = "Reckless Spirit Breastplate", id = 268222, targetIlvl = 344, source = "The Coiled Altar (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "wrist", name = "Spellbreaker's Bracers", id = 237834, targetIlvl = 331, source = "Crafting" },
    { slot = "hands", name = "Scaleplate Strangulators", id = 268220, targetIlvl = 344, source = "The Twin Fangs (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "waist", name = "Girdle of Toxic Regret", id = 268259, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "legs", name = "Chausses of Unbound Rancor", id = 271878, targetIlvl = 344, source = "Ula’tek (Catalyst)", catalystNote = "Listed as a Season 2 catalyst / tier-set target. After you catalyze, the resulting tier piece may use a different item ID; if the box does not auto-tick, check it manually." },
    { slot = "feet", name = "Spellbreaker's March", id = 237828, targetIlvl = 331, source = "Crafting" },
    { slot = "finger1", name = "Alluring Bubbleband", id = 268266, targetIlvl = 344, source = "The Tidebound Grotto" },
    { slot = "finger2", name = "Band of the Swarmcaller", id = 281029, targetIlvl = 344, source = "Kith’ix" },
    { slot = "trinket1", name = "Voracious Heart of Ula'tek", id = 270175, targetIlvl = 344, source = "Ula’tek" },
    { slot = "trinket2", name = "Zul'jin's Guillotine Technique", id = 270173, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "mainhand", name = "Aman'muso, Warlord's Vengeance", id = 268209, targetIlvl = 344, source = "The Coiled Altar" },
    { slot = "offhand", name = "Venom-Slashed Scuteward", id = 268196, targetIlvl = 344, source = "The Lost Explorers" },
  },
}
ns.GearBySpecID[73] = ns.Gear["WARRIOR:Protection"]


function ns.GearKey(classFile, specName)
  if not classFile or not specName or specName == "" then
    return nil
  end
  return string.format("%s:%s", classFile, specName)
end

local function NormalizeSpecName(name)
  if not name then
    return nil
  end
  name = name:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  return name
end

function ns.GetGearList(classFile, specName, specID)
  if type(specID) == "number" and ns.GearBySpecID[specID] then
    return ns.GearBySpecID[specID]
  end
  local key = ns.GearKey(classFile, NormalizeSpecName(specName))
  if key and ns.Gear[key] then
    return ns.Gear[key]
  end
  -- Case-insensitive / spacing fallback (localized clients should hit specID first).
  if classFile and specName then
    local want = (classFile .. ":" .. specName):lower():gsub("%s+", "")
    for k, list in pairs(ns.Gear) do
      if type(k) == "string" and k:lower():gsub("%s+", "") == want then
        return list
      end
    end
  end
  return nil
end

function ns.AllItemIDsForEntry(entry)
  local ids = {}
  if entry.id then
    ids[#ids + 1] = entry.id
  end
  if entry.altIds then
    for i = 1, #entry.altIds do
      ids[#ids + 1] = entry.altIds[i]
    end
  end
  return ids
end

function ns.CatalystIDsForEntry(entry)
  return entry.catalystIds or {}
end

