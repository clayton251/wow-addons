--[[
  Midnight Season 2 Mythic+ dungeon pool, interrupt-priority casts, and
  short dungeon boss notes.

  Sources (researched November 13, 2026; patch 12.1.5 / Season 2):
  - Blizzard: "Midnight Season 2 is Now Live!"
    https://news.blizzard.com/en-us/article/24294369/midnight-season-2-is-now-live
    Pool: Altar of Fangs, Murder Row, Den of Nalorakk, The Blinding Vale,
    Voidscar Arena, Ruby Life Pools, Kings' Rest, Temple of Sethraliss.
  - Wowhead Season 2 M+ overview (updated 2026-09-29):
    https://www.wowhead.com/guide/midnight/mythic-plus-season-overview
  - Interrupt priorities: Orboro "Midnight Season 2 Mythic+ Interrupt &
    Utility Cheat Sheet" (updated 2026-08-24; 91 verified entries):
    https://orboro.net/pages/midnight-season-2-mythic-plus-interrupt-utility-cheat-sheet
  - Legacy instance map IDs from Warcraft Wiki InstanceID:
    Ruby Life Pools 2521, Kings' Rest 1762, Temple of Sethraliss 1877.
    https://warcraft.wiki.gg/wiki/InstanceID

  UNVERIFIED:
  - Instance map IDs for the five Midnight-original dungeons were not
    published on Warcraft Wiki's InstanceID list at the time of writing.
    Those dungeons are matched by instance name from GetInstanceInfo()
    (and by challenge-mode map name when a key is active).
  - Dungeon boss notes for newer Midnight dungeons are abbreviated from
    the Orboro sheet and Warcraft Wiki encounter lists. Treat them as
    a starting point; hotfixes can change casts.
  - Legacy dungeon notes reflect current Orboro Season 2 data plus well
    known mechanics; some older-expansion tricks may have been retuned.
]]

local ADDON, ns = ...

ns.DUNGEONS = {
  {
    key = "altar-of-fangs",
    name = "Altar of Fangs",
    short = "Altar",
    instanceIDs = {}, -- UNVERIFIED: no published InstanceID found
    nameMatches = { "Altar of Fangs" },
    kicks = {
      { caster = "Primal Serpent", spell = "Piercing Hiss", priority = "High", note = "Group damage and haste slow. Assign a dedicated kick." },
      { caster = "High Evolutionist", spell = "Envenom", priority = "High", note = "Kick as many as possible; poison-dispel any that land." },
      { caster = "Ula'tek's Chosen", spell = "Mass Envenom", priority = "Critical", note = "Group venom. Dispel the stack if the kick is missed." },
      { caster = "The Writhing Coil", spell = "Toxic Atrophy", priority = "Critical", note = "Boss casts this three times in sequence; reduces speed and damage. Dispel after a miss." },
    },
    extras = {
      "High Evolutionist Evolve is a stop/CC, not a normal kick (Critical).",
      "Dispel Paralyzing Shots (Twinfang Harrower) and Regurgitate (Rav'i).",
      "Purge or soothe Ravenous Claws on Ravenous Descendants.",
    },
    bosses = {
      {
        name = "Rav'i",
        notes = {
          general = { "Avoid the cone. Jump onto the boss platform, not the surrounding poison.", "Dispel Regurgitate if it lands, or use a movement-clear." },
          tank = { "Face the cone away from the group." },
          healer = { "Dispel Regurgitate quickly." },
          dps = { "Stay out of the cone and poison puddles." },
        },
      },
      {
        name = "The Writhing Coil",
        notes = {
          general = { "Kick Toxic Atrophy (three-cast sequence).", "Death Rattle: the whole group must run far enough to break the cast and uncoil the boss." },
          tank = { "Hold the boss still so kicks can land, then be ready to move for Death Rattle." },
          healer = { "Dispel Toxic Atrophy if a kick is missed." },
          dps = { "Save a kick for every Toxic Atrophy. Run out on Death Rattle." },
        },
      },
      {
        name = "Zul'jan",
        notes = {
          general = { "Final boss of Altar of Fangs. Community reports: do not immune the physical frontal used to clear beam-soak stacks, or the stacks may remain. UNVERIFIED / hotfix-sensitive." },
          tank = { "Aim the physical frontal as assigned so soak stacks can be cleared." },
          healer = { "Watch soak damage and any leftover stack after a missed frontal." },
          dps = { "Soak beams as assigned. Avoid immuning the stack-clear frontal." },
        },
      },
    },
  },
  {
    key = "murder-row",
    name = "Murder Row",
    short = "Murder Row",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Murder Row" },
    kicks = {
      { caster = "Felonious Mage", spell = "Fel Missiles", priority = "High", note = "Priority kick before filler casts." },
      { caster = "Seductive Sayaad", spell = "Seduction", priority = "High", note = "Kick the CC. Dispel the target if it lands." },
      { caster = "Kystia Manaheart's images", spell = "Felstorm", priority = "Critical", note = "Interrupt and burn the mirror images before pulsing damage ramps." },
      { caster = "Wrathguard Flayer", spell = "Fel Rage", priority = "Critical", note = "Stop the damage-reduction buff. Purge if the kick is missed." },
      { caster = "Fel Invoker", spell = "Health Funnel", priority = "Critical", note = "Stop the large enemy heal channel." },
      { caster = "Lithiel Cinderfury", spell = "Chaos Bolt", priority = "Critical", note = "Kick every Chaos Bolt. No fallback if missed." },
    },
    extras = {
      "Dispel Corroding Spittle (Felwyrm / Kystia and Nibbles) and Heartstop Poison (Zaen).",
      "Decurse Curse of Doom on Corrupted Warlocks.",
      "Zaen: Murder in a Row — hide behind intact freight (line of sight).",
    },
    bosses = {
      {
        name = "Kystia Manaheart",
        notes = {
          general = { "Kystia and Nibbles share the encounter. Kick Felstorm on the images and burn them.", "Dispel Corroding Spittle." },
          tank = { "Keep the pair controllable for kicks and image burns." },
          healer = { "Dispel Corroding Spittle on either target." },
          dps = { "Swap to images and kick Felstorm." },
        },
      },
      {
        name = "Zaen Bladesorrow",
        notes = {
          general = { "Dispel Heartstop Poison immediately so it does not stack.", "Murder in a Row: keep freight intact and LoS the shot." },
          tank = { "Face dangerous shots so the group can LoS behind freight." },
          healer = { "Heartstop Poison is a critical dispel." },
          dps = { "Do not break all freight before Murder in a Row." },
        },
      },
      {
        name = "Xathuux the Annihilator",
        notes = {
          general = { "Third boss of Murder Row. No interrupt row was listed on the Orboro sheet. UNVERIFIED: play the dungeon journal and watch for new kick targets." },
          tank = { "Handle journal frontals and tank busters as they appear." },
          healer = { "Expect heavy burst; confirm dispels in the journal." },
          dps = { "Stay out of clearly telegraphed zones." },
        },
      },
      {
        name = "Lithiel Cinderfury",
        notes = {
          general = { "Kick every Chaos Bolt — critical, no fallback." },
          tank = { "Hold Lithiel in kick range." },
          healer = { "Chaos Bolt that lands is a major hit; be ready to top the target." },
          dps = { "Assign a kick rotation solely around Chaos Bolt if needed." },
        },
      },
    },
  },
  {
    key = "den-of-nalorakk",
    name = "Den of Nalorakk",
    short = "Nalorakk",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Den of Nalorakk" },
    kicks = {
      { caster = "Keen-Eyed Striker", spell = "Rummage", priority = "High", note = "Section high-priority kick." },
      { caster = "Earthwhisper Tender", spell = "Healing Breeze", priority = "Critical", note = "Stop the heal. Purge the buff if it completes." },
      { caster = "Frigid Mauler", spell = "Frigid Roar", priority = "High", note = "Kick before cold-area pressure lands." },
      { caster = "Sentinel of Winter", spell = "Shroud of Winter", priority = "Critical", note = "Reserve a kick for this boss cast." },
      { caster = "Stormbound Mystic", spell = "Arc Lightning", priority = "High", note = "Assign a kick to stop repeated group pressure." },
    },
    extras = {
      "Dispel Insatiable Hunger (Spirit of Hunger, critical), Toxic Spores (Hoardmonger), Cryosurge, and Glacial Torment.",
      "Purge or soothe Mother's Wrath and Bestial Wrath.",
      "Sentinel of Winter Frozen Tempest: stay in the safe eye.",
    },
    bosses = {
      {
        name = "The Hoardmonger",
        notes = {
          general = { "Dispel Toxic Spores. Forceful Slam is a soak (Full Send / community). UNVERIFIED timing." },
          tank = { "Position so soaks are easy to hit." },
          healer = { "Dispel Toxic Spores promptly." },
          dps = { "Help soak Forceful Slam." },
        },
      },
      {
        name = "Sentinel of Winter",
        notes = {
          general = { "Kick Shroud of Winter. Dispel Glacial Torment.", "Frozen Tempest: stand in the safe eye. Community tip: tank near a wall but keep the boss off the snow or the fight may reset (hotfix-sensitive)." },
          tank = { "Hold near a wall for cleave, off the snow." },
          healer = { "Glacial Torment is a critical dispel. Heal through tempest if anyone leaves the eye." },
          dps = { "Save a kick for Shroud of Winter. Stay in the eye." },
        },
      },
      {
        name = "Nalorakk",
        notes = {
          general = { "Final boss of the den. Assign remaining kicks (Healing Breeze / Arc Lightning style trash on the way).", "UNVERIFIED: confirm current journal soaks and intercepts (Fury of the War God is cited as an intercept)." },
          tank = { "Handle intercepts and soaks as assigned." },
          healer = { "Plan for burst on intercepts and group hits." },
          dps = { "Help soaks and intercepts; do not ignore assigned kicks on leftover casters." },
        },
      },
    },
  },
  {
    key = "blinding-vale",
    name = "The Blinding Vale",
    short = "Blinding Vale",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "The Blinding Vale", "Blinding Vale" },
    kicks = {
      { caster = "Radiant Spellsower", spell = "Light Bolt Volley", priority = "Critical", note = "No listed fallback. Kick this first." },
      { caster = "Kezkitt", spell = "Light Bolt", priority = "High", note = "Recurring high-priority kick through the first-boss fight." },
      { caster = "Lightfeather Petalwing", spell = "Disorienting Screech", priority = "High", note = "Stop the group disruption." },
      { caster = "Lightwarden Ruia", spell = "Warden's Wrath", priority = "Critical", note = "No fallback if missed." },
      { caster = "Ziekket", spell = "Lightspore Shot", priority = "High", note = "Kick every cast." },
    },
    extras = {
      "Dispel or kill Bloodthorn Roots on Ikuzz.",
      "Focus Lightgorged Lasher shields — they heal nearby enemies while up.",
      "Lightblossom Trinity: step into the flower to soak the beam, not in front of it.",
    },
    bosses = {
      {
        name = "Lightblossom Trinity",
        notes = {
          general = { "Kick Kezkitt's Light Bolt. Soak Lightblossom Beam by stepping into the flower, not in front of it." },
          tank = { "Hold the trinity so the soak flower is easy to reach." },
          healer = { "Beam soaks and Light Bolt hits can spike." },
          dps = { "Assign a dedicated Light Bolt kick. Soak the flower correctly." },
        },
      },
      {
        name = "Ikuzz the Light Hunter",
        notes = {
          general = { "Dispel Bloodthorn Roots or kill the roots quickly.", "Community: vanishing or similar can drop a fixate and prevent its stack, but does not clear the root." },
          tank = { "Kite or hold as needed when fixates go out." },
          healer = { "Dispel roots when possible." },
          dps = { "Swap to roots if they are not dispelled." },
        },
      },
      {
        name = "Lightwarden Ruia",
        notes = {
          general = { "Kick Warden's Wrath every time.", "Pulverizing Strikes: spread for the locked cones and stand still once targeted." },
          tank = { "Give the group space to spread for cones." },
          healer = { "Cones and a missed Warden's Wrath are the big hits." },
          dps = { "Kick Warden's Wrath. Stand still in your cone." },
        },
      },
      {
        name = "Ziekket",
        notes = {
          general = { "Kick Lightspore Shot every cast." },
          tank = { "Hold Ziekket in kick range." },
          healer = { "Top the group if Lightspore Shot lands." },
          dps = { "Do not let Lightspore Shot finish." },
        },
      },
    },
  },
  {
    key = "voidscar-arena",
    name = "Voidscar Arena",
    short = "Voidscar",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Voidscar Arena" },
    kicks = {
      { caster = "Dominated Brawler", spell = "Demoralizing Shout", priority = "High", note = "Kick before it lands on the group." },
      { caster = "Voidtouched Magi", spell = "Shadowbolt Volley", priority = "Critical", note = "Critical group cast." },
      { caster = "Angry Krolusk", spell = "Violent Sand", priority = "High", note = "Assign a kick." },
      { caster = "Killvore Screamer", spell = "Mad Shriek", priority = "High", note = "Stop the screech." },
      { caster = "Voidminder", spell = "Mending Void", priority = "Critical", note = "Stop the enemy heal." },
    },
    extras = {
      "Dispel Melt Armor (critical, Sycophantic Tarasek) and Corrosive Essence.",
      "Purge or soothe Bolster on Longtooth Tuskarr.",
      "Orb of Disruption / Disrupting Blast cannot be stopped with a normal interrupt — kill the orb. Shell Guard needs hard CC (Full Send).",
    },
    bosses = {
      {
        name = "Taz'Rah",
        notes = {
          general = { "First Voidscar boss. UNVERIFIED: use the journal plus leftover trash kick rules on the approach." },
          tank = { "Control positioning for group kicks." },
          healer = { "Watch for group casts that escape the kick rotation." },
          dps = { "Keep kicking high-priority trash habits if those mobs are part of the pull." },
        },
      },
      {
        name = "Atroxus",
        notes = {
          general = { "Dispel Mind-Numbing Poison only after a failed mechanic (situational)." },
          tank = { "Call when the associated mechanic is failed so the dispel happens." },
          healer = { "Do not pre-dispel Mind-Numbing Poison; wait for a failed mechanic." },
          dps = { "Do the mechanic so the poison does not need a dispel." },
        },
      },
      {
        name = "Charonus",
        notes = {
          general = { "Gravitic Orbs: kite fixating orbs into an Unstable Singularity.", "The final boss's targeted projectile sequence is a dodge, not a tank soak (Orboro / community, corroborated)." },
          tank = { "Do not try to soak the targeted projectile sequence. Help herd orbs if needed." },
          healer = { "Movement-heavy phase; keep people up through orb and projectile mistakes." },
          dps = { "Kite orbs into the singularity. Dodge projectiles away from the group." },
        },
      },
    },
  },
  {
    key = "ruby-life-pools",
    name = "Ruby Life Pools",
    short = "RLP",
    instanceIDs = { 2521 },
    nameMatches = { "Ruby Life Pools" },
    kicks = {
      { caster = "Flashfrost Chillweaver", spell = "Ice Shield", priority = "High", note = "Stop the shield before it completes." },
      { caster = "Melidrussa Chillworn", spell = "Frigid Shard", priority = "Critical", note = "Kick the tank hit when the boss is not behind Frost Overload. Break the shield if it is up." },
      { caster = "Blazebound Destroyer", spell = "Fiery Blast", priority = "Critical", note = "High-priority fire cast." },
      { caster = "Blazebound Firestorm", spell = "Blaze Volley", priority = "Critical", note = "Kick the add's volley and kill it quickly." },
    },
    extras = {
      "Dispel Cold Claws, Rolling Thunder, and Stormslam (tank hit + dispel).",
      "Purge or soothe Blaze of Glory and Stormcloud Barrier.",
      "Living Bomb circles no longer damage enemies in Season 2 — keep them off the group.",
    },
    bosses = {
      {
        name = "Melidrussa Chillworn",
        notes = {
          general = { "Kick Frigid Shard when she is not shielded; break Frost Overload otherwise.", "Chillstorm: avoid the center pull and do not get knocked into Hailbombs." },
          tank = { "Mitigate Frigid Shard if a kick is late." },
          healer = { "Dispel Cold Claws from whelps. Hailbomb hits are the wipe risk." },
          dps = { "Kick Frigid Shard. Break the shield. Stay out of Hailbombs." },
        },
      },
      {
        name = "Kokia Blazehoof",
        notes = {
          general = { "Kick Blaze Volley on summoned Blazebound Firestorms and kill them.", "Searing Blows is a repeated tank hit — plan a defensive." },
          tank = { "Defensive for Searing Blows. Help point adds for kicks." },
          healer = { "Support the tank through Searing Blows." },
          dps = { "Swap to Firestorms and kick Blaze Volley." },
        },
      },
      {
        name = "Erkhart Stormvein",
        notes = {
          general = { "Dispel Stormslam (critical). Handle wind / lightning room mechanics from the journal." },
          tank = { "Mitigate Stormslam; call for the dispel." },
          healer = { "Stormslam is a critical dispel and a tank defensive check." },
          dps = { "Avoid storms and help with any assigned soaks." },
        },
      },
    },
  },
  {
    key = "kings-rest",
    name = "Kings' Rest",
    short = "KR",
    instanceIDs = { 1762 },
    nameMatches = { "Kings' Rest", "Kings' Rest" },
    kicks = {
      { caster = "Risen Hexer", spell = "Hex Volley", priority = "Critical", note = "Critical group cast." },
      { caster = "Queen Wasi", spell = "Bind Soul", priority = "High", note = "Kick every cast." },
      { caster = "Seneschal M'bara", spell = "Unholy Mending", priority = "Critical", note = "Stop the heal. Purge if it completes." },
      { caster = "Half-Finished Mummy", spell = "Wretched Discharge", priority = "High", note = "Kick on sight." },
      { caster = "Phantom Hex Priest", spell = "Hex", priority = "High", note = "Kick the CC. Dispel if it lands." },
      { caster = "Zanazal the Wise", spell = "Poison Nova", priority = "Critical", note = "Large group-wide poison. Reserve a kick." },
      { caster = "Reban", spell = "Deathly Roar", priority = "Critical", note = "Kick before the group-wide fear lands." },
    },
    extras = {
      "Destroy Healing Tide Totems immediately.",
      "Purge Bound by Shadow (can instantly kill the Minion), Ancestral Fury, Bestial Berserk, and Captain's Bulwark.",
      "Mchimba constructs Entomb into the nearest coffin — stack by one coffin. Mchimba's own Entomb is still random.",
    },
    bosses = {
      {
        name = "The Golden Serpent",
        notes = {
          general = { "Standard first boss. Watch journal winds and soaks. UNVERIFIED vs any Season 2 retune." },
          tank = { "Face and move the serpent out of bad." },
          healer = { "Heal through periodic group hits." },
          dps = { "Dodge winds and puddles; keep priority damage on the boss." },
        },
      },
      {
        name = "Mchimba the Embalmer",
        notes = {
          general = { "Constructs Entomb victims into the nearest coffin — stack beside one coffin for a fast breakout.", "Mchimba's own Entomb still chooses a random coffin. Dispel Lingering Fluid / Putrid Seekers from fluids." },
          tank = { "Hold Mchimba so the assigned coffin is close." },
          healer = { "Top entombed players as they are broken out." },
          dps = { "Break the correct coffin immediately." },
        },
      },
      {
        name = "The Council of Tribes",
        notes = {
          general = { "Kick Zanazal's Poison Nova. Kick Reban's Deathly Roar (group fear).", "Dispel T'zala's Savage Maul (critical tank debuff)." },
          tank = { "Call Savage Maul for a dispel. Face Reban away if needed." },
          healer = { "Savage Maul is a critical dispel. Fear and Poison Nova are the wipe checks." },
          dps = { "Assign kicks to Zanazal and Reban. Do not let Deathly Roar finish." },
        },
      },
      {
        name = "King Dazar",
        notes = {
          general = { "Dazar leaps to the farthest player first. Keep the room clean of leftover totems and adds.", "Community: a well-timed target-drop while he is airborne may cancel remaining jumps (hotfix-sensitive)." },
          tank = { "Handle the leap and blade mechanics from the journal." },
          healer = { "Leaps and ramps of damage are the check." },
          dps = { "Do not stand farthest unless you are assigned to bait the first leap." },
        },
      },
    },
  },
  {
    key = "temple-of-sethraliss",
    name = "Temple of Sethraliss",
    short = "Sethraliss",
    instanceIDs = { 1877 },
    nameMatches = { "Temple of Sethraliss" },
    kicks = {
      { caster = "Shrouded Fang", spell = "Poisoned Cheap Shot", priority = "High", note = "Kick; cleanse the poison if it lands." },
      { caster = "Faithless Subjugator", spell = "Addle Mind", priority = "High", note = "Kick; dispel if it lands." },
      { caster = "Merektha", spell = "Poison Spit", priority = "High", note = "Kick the boss cast; cleanse after a miss." },
      { caster = "Temple Disruptor", spell = "Essence Disruption", priority = "Critical", note = "Stop the channel, especially while carrying the Eye. CC if needed." },
      { caster = "Twisted Hexxer", spell = "Flame Shock", priority = "High", note = "Kick through this section, including near the last boss." },
    },
    extras = {
      "Dispel Cytotoxin and Imbued Conduction.",
      "Purge or soothe Accumulate Charge (and community: purge storm elemental empowerment on higher keys).",
      "A Knot of Snakes (Merektha): CC the snakes to free the stunned player.",
    },
    bosses = {
      {
        name = "Adderis and Aspix",
        notes = {
          general = { "Swap or move when they share energy / lightning as in the journal. Kick trash habits on the way in." },
          tank = { "Separate or stack as the assigned plan requires when they charge up." },
          healer = { "Damage spikes when a charge or gale goes off." },
          dps = { "Stop DPS on shielded or unassigned targets if the journal still requires it." },
        },
      },
      {
        name = "Merektha",
        notes = {
          general = { "Kick Poison Spit. CC Knot of Snakes to free the stunned player." },
          tank = { "Face Merektha so spits and pulls are predictable." },
          healer = { "Cleanse Poison Spit if a kick is missed. Top the snared player." },
          dps = { "Kick Poison Spit. CC snakes immediately." },
        },
      },
      {
        name = "Galvazzt",
        notes = {
          general = { "Soak or dodge beams per the journal so the boss does not overcharge. UNVERIFIED vs Season 2 retune." },
          tank = { "Move Galvazzt so beam soaks are convenient." },
          healer = { "Beam mistakes cause heavy group damage." },
          dps = { "Soak or avoid beams as assigned." },
        },
      },
      {
        name = "Avatar of Sethraliss",
        notes = {
          general = { "After the guardian dies, DPS soak the purple Corrupted Lifeforce zones; the soak changes healing and physical damage taken.", "Kick Essence Disruption and Flame Shock on the approach and during the gauntlet." },
          tank = { "Pick up remaining enemies around the Avatar." },
          healer = { "Healing is affected by Corrupted Lifeforce soaks — watch who soaked." },
          dps = { "Soak purple zones after the guardian dies. Keep kicking Disruptors." },
        },
      },
    },
  },
}

local function NamesEqual(a, b)
  if not a or not b then
    return false
  end
  a = string.lower((a:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")))
  b = string.lower((b:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")))
  return a == b or a:find(b, 1, true) or b:find(a, 1, true)
end

function ns.FindDungeonByInstanceID(instanceID)
  if not instanceID then
    return nil
  end
  for _, dungeon in ipairs(ns.DUNGEONS) do
    for _, id in ipairs(dungeon.instanceIDs or {}) do
      if id == instanceID then
        return dungeon
      end
    end
  end
  return nil
end

function ns.FindDungeonByName(name)
  if type(name) ~= "string" or name == "" then
    return nil
  end
  for _, dungeon in ipairs(ns.DUNGEONS) do
    if NamesEqual(dungeon.name, name) then
      return dungeon
    end
    for _, alias in ipairs(dungeon.nameMatches or {}) do
      if NamesEqual(alias, name) then
        return dungeon
      end
    end
  end
  return nil
end

function ns.GetCurrentDungeon()
  local instanceID, instanceName = ns.GetInstanceMapID()
  local found = ns.FindDungeonByInstanceID(instanceID)
  if found then
    return found, instanceID, instanceName
  end
  found = ns.FindDungeonByName(instanceName)
  if found then
    return found, instanceID, instanceName
  end
  -- Active keystone map name, when a Season 2 key is running.
  if C_ChallengeMode and C_ChallengeMode.GetMapUIInfo then
    local mapID
    if C_ChallengeMode.GetActiveKeystoneInfo then
      local info = ns.PlainCall(C_ChallengeMode.GetActiveKeystoneInfo)
      if type(info) == "table" then
        mapID = info.mapID or info.challengeMapID
      else
        mapID = info
      end
    end
    if type(mapID) == "number" and mapID > 0 then
      local mapName = ns.PlainCall(C_ChallengeMode.GetMapUIInfo, mapID)
      found = ns.FindDungeonByName(mapName)
      if found then
        return found, instanceID, mapName
      end
    end
  end
  return nil, instanceID, instanceName
end
