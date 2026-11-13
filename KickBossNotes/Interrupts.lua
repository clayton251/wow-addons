--[[
  Interrupt spell table for every class and spec, including Devourer DH.

  Sources (November 2026, Midnight 12.1 / 12.1.5):
  - Warcraft Wiki, "Interrupt": https://warcraft.wiki.gg/wiki/Interrupt
    (spell names, IDs implied by ability pages, base cooldowns, lockout)
  - Wowhead Devourer Demon Hunter Abilities guide:
    Disrupt is the Devourer kick, 15s cooldown, 5s school lockout.
    https://www.wowhead.com/guide/classes/demon-hunter/devourer/abilities-talents-pve-dps
  - Spell IDs cross-checked against common interrupt ID lists (Kick 1766,
    Counterspell 2139, Rebuke 96231, Mind Freeze 47528, Disrupt 183752,
    Pummel 6552, Spell Lock 19647, Skull Bash 106839, Spear Hand Strike
    116705, Wind Shear 57994, Counter Shot 147362, Muzzle 187707,
    Quell 351338, Silence 15487, Solar Beam 78675, Axe Toss 89766).

  Base cooldowns are the untalented values. Talents, haste, and set bonuses
  can change them; the addon uses these only for the estimated "other
  players" timer after a manual I Kicked click.

  UNVERIFIED: Devourer specialization ID has been reported as both 1473
  and 1480. All Demon Hunter specs use Disrupt, so either ID is fine.
  Restoration Druid is listed as having no baseline kick; a talent may
  grant Skull Bash (unverified for 12.1.5). Holy and Discipline Priests
  have no interrupt. Warlock kicks require the matching pet.
]]

local ADDON, ns = ...

-- classFile -> default interrupt, plus optional per-spec overrides.
-- spec IDs are Retail specialization IDs.
ns.INTERRUPT_SPELLS = {
  WARRIOR = {
    spell = "Pummel",
    spellID = 6552,
    cooldown = 15,
    range = "melee",
  },
  PALADIN = {
    spell = "Rebuke",
    spellID = 96231,
    cooldown = 15,
    range = "melee",
    note = "Protection also has Avenger's Shield (31935) as a bonus interrupt; assignments use Rebuke.",
  },
  HUNTER = {
    spell = "Counter Shot",
    spellID = 147362,
    cooldown = 24,
    range = "ranged",
    specs = {
      [253] = { spell = "Counter Shot", spellID = 147362, cooldown = 24, range = "ranged" }, -- Beast Mastery
      [254] = { spell = "Counter Shot", spellID = 147362, cooldown = 24, range = "ranged" }, -- Marksmanship
      [255] = { spell = "Muzzle", spellID = 187707, cooldown = 15, range = "melee" }, -- Survival
    },
  },
  ROGUE = {
    spell = "Kick",
    spellID = 1766,
    cooldown = 15,
    range = "melee",
  },
  PRIEST = {
    spell = nil,
    spellID = nil,
    cooldown = nil,
    note = "Holy and Discipline have no interrupt.",
    specs = {
      [256] = { spell = nil, note = "Discipline has no interrupt." },
      [257] = { spell = nil, note = "Holy has no interrupt." },
      [258] = { spell = "Silence", spellID = 15487, cooldown = 45, range = "ranged", note = "Shadow silence; 4s lockout vs NPCs." },
    },
  },
  DEATHKNIGHT = {
    spell = "Mind Freeze",
    spellID = 47528,
    cooldown = 15,
    range = "15 yd",
  },
  SHAMAN = {
    spell = "Wind Shear",
    spellID = 57994,
    cooldown = 12,
    range = "ranged",
  },
  MAGE = {
    spell = "Counterspell",
    spellID = 2139,
    cooldown = 24,
    range = "ranged",
  },
  WARLOCK = {
    spell = "Spell Lock",
    spellID = 19647,
    cooldown = 24,
    range = "ranged",
    note = "Requires a Felhunter (Command Demon). Demonology may use Axe Toss (89766) with a Felguard instead.",
    specs = {
      [265] = { spell = "Spell Lock", spellID = 19647, cooldown = 24, range = "ranged", note = "Felhunter pet." },
      [266] = { spell = "Axe Toss", spellID = 89766, cooldown = 30, range = "ranged", note = "Felguard pet. Spell Lock (19647) is also available with a Felhunter." },
      [267] = { spell = "Spell Lock", spellID = 19647, cooldown = 24, range = "ranged", note = "Felhunter pet." },
    },
  },
  MONK = {
    spell = "Spear Hand Strike",
    spellID = 116705,
    cooldown = 15,
    range = "melee",
  },
  DRUID = {
    spell = "Skull Bash",
    spellID = 106839,
    cooldown = 15,
    range = "13 yd",
    note = "Requires Cat or Bear Form.",
    specs = {
      [102] = { spell = "Solar Beam", spellID = 78675, cooldown = 60, range = "ranged", note = "Balance: interrupts the primary target and silences under the beam." },
      [103] = { spell = "Skull Bash", spellID = 106839, cooldown = 15, range = "13 yd" },
      [104] = { spell = "Skull Bash", spellID = 106839, cooldown = 15, range = "13 yd" },
      [105] = { spell = nil, note = "Restoration has no baseline interrupt (UNVERIFIED: a talent may grant Skull Bash)." },
    },
  },
  DEMONHUNTER = {
    spell = "Disrupt",
    spellID = 183752,
    cooldown = 15,
    range = "melee",
    note = "Used by Havoc, Vengeance, and Devourer.",
  },
  EVOKER = {
    spell = "Quell",
    spellID = 351338,
    cooldown = 40,
    range = "ranged",
    note = "Base cooldown 40s on Warcraft Wiki; talents may reduce it.",
  },
}

local DEVOURER_SPEC_IDS = {
  [1473] = true,
  [1480] = true,
}

function ns.GetPlayerClassSpec()
  local classFile = ns.PlainCall(UnitClassBase, "player")
  if not classFile then
    local _, file = ns.PlainCall(UnitClass, "player")
    classFile = file
  end
  local specID, specName
  local specIndex = ns.PlainCall(GetSpecialization) or (C_SpecializationInfo and ns.PlainCall(C_SpecializationInfo.GetSpecialization))
  if specIndex and GetSpecializationInfo then
    specID, specName = ns.PlainCall(GetSpecializationInfo, specIndex)
  end
  if (not specID) and C_SpecializationInfo and C_SpecializationInfo.GetSpecializationInfo then
    specID, specName = ns.PlainCall(C_SpecializationInfo.GetSpecializationInfo, specIndex)
  end
  return classFile, specID, specName
end

function ns.GetUnitClassSpec(unit)
  unit = unit or "player"
  local classFile = ns.PlainCall(UnitClassBase, unit)
  if not classFile then
    local _, file = ns.PlainCall(UnitClass, unit)
    classFile = file
  end
  local specID
  if unit == "player" then
    local _, id = ns.GetPlayerClassSpec()
    specID = id
  elseif GetInspectSpecialization then
    -- Only use this when an inspect is already available; we do not inspect in combat.
    specID = ns.PlainCall(GetInspectSpecialization, unit)
    if specID == 0 then
      specID = nil
    end
  end
  return classFile, specID
end

local function CopyInterrupt(src)
  if not src then
    return nil
  end
  return {
    spell = src.spell,
    spellID = src.spellID,
    cooldown = src.cooldown,
    range = src.range,
    note = src.note,
  }
end

function ns.GetInterruptFor(classFile, specID, specName)
  if type(classFile) ~= "string" or classFile == "" then
    return nil
  end
  classFile = string.upper(classFile)
  local row = ns.INTERRUPT_SPELLS[classFile]
  if not row then
    return nil
  end
  local info = CopyInterrupt(row)
  if row.specs and specID and row.specs[specID] then
    local over = row.specs[specID]
    for k, v in pairs(over) do
      info[k] = v
    end
  elseif classFile == "DEMONHUNTER" and specID and DEVOURER_SPEC_IDS[specID] then
    info.note = "Devourer Demon Hunter uses Disrupt."
  elseif classFile == "DEMONHUNTER" and type(specName) == "string" and string.lower(specName) == "devourer" then
    info.note = "Devourer Demon Hunter uses Disrupt."
  end
  return info
end

function ns.GetPlayerInterrupt()
  local classFile, specID, specName = ns.GetPlayerClassSpec()
  return ns.GetInterruptFor(classFile, specID, specName), classFile, specID
end
