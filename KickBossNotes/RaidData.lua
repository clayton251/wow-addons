--[[
  Role-aware boss notes for the current Midnight Season 2 raid tier:
  The Venomous Abyss (patch 12.1 / 12.1.5).

  Sources (Wowhead strategy guides, fetched November 13, 2026):
  - Raid overview: https://www.wowhead.com/guide/midnight/raids/the-venomous-abyss-overview-location-rewards-bosses
  - Nek'zali: .../venomous-abyss-nekzali-the-soulcoiler-boss-strategy-abilities (updated 2026-08-24)
  - Entombed Sentinels: .../venomous-abyss-entombed-sentinels-boss-strategy-abilities (2026-08-18)
  - Lost Explorers: .../venomous-abyss-lost-explorers-boss-strategy-abilities (2026-08-18)
  - Vashnik: .../venomous-abyss-vashnik-the-malignant-boss-strategy-abilities (2026-08-18)
  - Sszorak: .../venomous-abyss-sszorak-boss-strategy-abilities (2026-08-26)
  - Twin Fangs: .../venomous-abyss-twin-fangs-boss-strategy-abilities (2026-08-18)
  - Coiled Altar: .../venomous-abyss-coiled-altar-boss-strategy-abilities (2026-08-20)
  - Ula'tek: .../venomous-abyss-ulatek-boss-strategy-abilities (2026-10-29)

  Coiled Altar Phase 3 bonus health (from the Wowhead hotfix article
  discussed with Clayton): Normal Zul'jan 120% / Malacrass 38%;
  Heroic 155% / 87%; Mythic 156% / 19% after the Race to World First
  nerf (was 160% / 35%). Separate health pools; if one dies first the
  other berserks (Soulbound / 500% damage increase).

  UNVERIFIED:
  - Encounter journal IDs for ENCOUNTER_START were not published in the
    guides above. Notes open from a non-secret encounter name, a target
    name when identity is not secret, or the manual dropdown.
  - Instance map ID for The Venomous Abyss was not confirmed on the
    InstanceID wiki list; the raid is also matched by instance name.
  - Minor Heroic/Mythic-only tweaks may have been hotfixed after the
    guide dates listed above.
]]

local ADDON, ns = ...

ns.RAIDS = {
  {
    key = "venomous-abyss",
    name = "The Venomous Abyss",
    short = "Venomous Abyss",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "The Venomous Abyss", "Venomous Abyss" },
    bosses = {
      {
        key = "nekzali",
        name = "Nek'zali the Soulcoiler",
        encounterNames = { "Nek'zali the Soulcoiler", "Nek'zali" },
        notes = {
          general = {
            "Stay away from the Soulcoil Well in the center. Adds or deaths in the well empower the boss (Soulcoil Rite).",
            "Lust on pull. Intermission at 50%: break Echo of Jawae / Tethers of Awakening to draw her back.",
            "Heroic+: burn add corpses with Hungering Pyre / Cremation so they cannot reanimate.",
            "If she reaches full energy she Uncoils (huge damage buff and immune to taunt).",
          },
          tank = {
            "Possession Barrage: run away from the boss until it impacts — damage drops with distance.",
            "Hollowing Strikes stacks a healing-received reduction; be ready to taunt swap.",
            "Help soak Hungering Pyre on add corpses in the intermission (melee and tanks).",
          },
          healer = {
            "Essence Rend: the player moves to the edge and calls for a dispel; a harmful puddle / Latent Cultist drops there.",
            "Soulcoil Ignition and Soulcoil Rite are heavy raid damage, worse if souls entered the well.",
            "Plan big healing for the intermission soaks and Stage Two Uncoiling pulsing damage.",
          },
          dps = {
            "Kill Restless Amani before they reach the well. Break their magic absorb so they can actually die.",
            "Essence Rend players drop a Latent Cultist — do not dispel them on the raid.",
            "Intermission: melee soak Hungering Pyre on corpses; finish remaining corpses with Cremation soaks on Heroic+.",
          },
        },
      },
      {
        key = "entombed-sentinels",
        name = "Entombed Sentinels",
        encounterNames = { "Entombed Sentinels", "Breath of Ula'tek", "Blood of Ula'tek" },
        notes = {
          general = {
            "Two groups: Breath (green/acid) and Blood (red). Tank the bosses at least 25–40 yards apart or Ula'tek's Dominance cuts their damage taken by 99%.",
            "Stay on your side so Mark of Acid / Mark of Blood do not stack from the other boss.",
            "Intermission (100 energy): Vitriolic Stasis — do not waste damage. Combine Helical Toxins with another player so your stacks total exactly 4, then it clears.",
          },
          tank = {
            "Hold 25+ yards apart. After the intermission, taunt-swap bosses and go to the opposite side.",
            "Breath: Empowering Slam ramps if it hits the same tank; swap. Watch Toxic Droplets in front.",
            "Blood: Bloodvenom Injection stacks — swap. Helical Toxins must land on exactly 4 combined stacks.",
          },
          healer = {
            "Dispel Blighted Blood as soon as possible.",
            "Contaminate from the big slime is heavy raid damage until the slime dies.",
            "Helical Toxins: call pairs so people meet at exactly 4 stacks; leftover stacks explode for huge damage.",
          },
          dps = {
            "Breath side: kill Venom Coagulation immediately (Contaminate pulses). Step on tiny Toxic Droplets before they explode; on Heroic dodge daggers from them.",
            "Blood side: soak Unstable Miasma at an edge. Heroic: drop Clinging Murk next to other blood after the soak.",
            "During stasis, only fix Helical Toxins — the bosses take 99% less damage and the weaker one is healing to even.",
          },
        },
      },
      {
        key = "lost-explorers",
        name = "The Lost Explorers",
        encounterNames = { "The Lost Explorers", "First Mate Nama", "Scrollsage Iku", "Trader Gebbo", "Mor'zahi" },
        notes = {
          general = {
            "Three possessed tortollans plus Mor'zahi. If Mor'zahi hits 100 energy / finishes Final Ascension, the raid wipes.",
            "Stack two bosses; Trader Gebbo wanders. Heroic+: only two can be together or they take 99% less damage.",
            "Feed a Disgusting Fish (from Gebbo's crates) to a tortollan once each to reset Mor'zahi's energy. Each boss can be fed only once, and feeding unlocks extra abilities.",
            "Three soak groups.",
          },
          tank = {
            "Hold Nama and Iku together when allowed. Watch Nama's Steady Strikes ramp (swap). Iku's Shredding Shards is a magic tank buster with a vulnerability — swap.",
            "Heroic+: keep the third boss (Gebbo) away so United Defense does not apply.",
            "Nama's Shell Spin is a frontal — face it away.",
          },
          healer = {
            "Blink Nova is a heavy hit; players farther from Iku's teleport take less.",
            "Kick or heal Icebound Flames; lingering elemental effects can be dispelled.",
            "Splinters comes from stomping Gebbo's crates — do not have the whole raid stomp at once.",
          },
          dps = {
            "Soak Throw Junk crates, find the Disgusting Fish, and feed the assigned boss before Final Ascension.",
            "After feeding: Nama gets split soaks, Iku gets Fire/Frost circles you clear by walking into the opposite element, Gebbo gets a bomb and a ring you bounce with mushrooms.",
            "Kill the three explorers before you run out of fish. Mighty Thud must be soaked.",
          },
        },
      },
      {
        key = "vashnik",
        name = "Vashnik the Malignant",
        encounterNames = { "Vashnik the Malignant", "Vashnik" },
        notes = {
          general = {
            "Arena is split into Blood (red), Shadow (purple), and Flame (orange) thirds. Lust on pull.",
            "Imbibe draws from the two closest fountains, summons living venoms, and stacks Infusion for 1.5 min. Rotate which third he is tanked in so one color does not stack too high.",
            "Kill living venoms before they reach the center cavity or Malignant Burst hits the raid.",
          },
          tank = {
            "Move Vashnik to a different third for every Imbibe so he drinks a new pair of fountains.",
            "Dripping Fangs is a stacking tank buster and physical-taken increase — taunt swap.",
          },
          healer = {
            "Imbibe is a raid-wide hit and adds a stacking Toxic Vapor.",
            "Siphoning Infection (blood): huge absorb, cannot self-heal normally — they must stand by allies and Siphon Blood.",
            "Exploding Infection (flame): stagger dispels; it AoEs when removed. Heroic+: soak Malignant Catalyst circles.",
          },
          dps = {
            "Purple adds: five slimes, AoE them; they drop swirlies. Orange: two CC-able slimes — stagger kills because of the stacking explode DoT (CC breaks after 60s).",
            "Red: a large CC-immune slime that splits into smaller slimes; AoE the splits.",
            "Plague Froth: spread and stand still so others can dodge the cardinal waves. Stygian Infection players drop void zones — move them out.",
          },
        },
      },
      {
        key = "sszorak",
        name = "Sszorak",
        encounterNames = { "Sszorak" },
        notes = {
          general = {
            "Lots of knockbacks. On pull, count tornadoes in each sector (1 to 3) — Howling Maelstrom later pushes from the 1-tornado side last to the 3-tornado side.",
            "Dig In during the maelstrom: Sszorak takes about 30% more damage for 25s around the 2-minute mark. Save cooldowns. Lust on pull or for Dig In as assigned.",
            "Assign three cyst poppers. Place a Viscous Cyst opposite the coming wind and pop it as each gale starts so the knockback fights the push.",
          },
          tank = {
            "Apex Predator: taunt so each tank takes one Ravage and one Mutilate.",
            "Ravage is a frontal — point it away from the group. Mutilate is a split soak — point it at the group. Heroic: two soak groups, each soaks one Mutilate. Need at least 5 soakers or it is lethal.",
            "Corroding Venom stacks physical damage taken — swap as needed.",
          },
          healer = {
            "Venomous Surge is raid-wide, weaker the farther you are from the targeted player.",
            "Raging Crosswinds DoTs, then knocks players the way their arrow points — they must pair arrows at each other to cancel Turbulent Gusts.",
            "Howling Maelstrom is a movement and damage check; keep people topped before each push.",
          },
          dps = {
            "Dodge Tempest tornados. Pair Raging Crosswinds arrows with a partner.",
            "Pop assigned cysts during Howling Maelstrom to knock the raid into the wind.",
            "Dump cooldowns when Dig In is up.",
          },
        },
      },
      {
        key = "twin-fangs",
        name = "The Twin Fangs",
        encounterNames = { "The Twin Fangs", "Vexhul", "Ithraz" },
        notes = {
          general = {
            "Two-target fight (Vexhul and Ithraz). Eternal Venom stacks throughout; at 9 stacks the player dies (Heroic/Mythic soaks have extra rules). Lust on pull.",
            "Ravenous Feast (Ithraz) is a group soak that removes 1 Eternal Venom per feast (not one per hit). Soak when your stacks are high. Heroic: three soak groups; Feasted prevents a second remove for a short time.",
            "If one serpent dies first, the other gains stacking Uncoiled Wrath — kill them close together.",
          },
          tank = {
            "Caustic Deluge is a long tank channel that spawns Caustic Globules near you — help the raid soak orbs so they do not explode on everyone.",
            "Stone Breaker: remember the order the three soaks appeared and stand in them in that order, or the raid takes the hit.",
            "Stay in range or you eat Clotted Bolt / Concentrated Spittle.",
          },
          healer = {
            "Eternal Venom is a stacking DoT that becomes a one-shot at 9. Call stacks so people use Ravenous Feast in time.",
            "Coiling Ichor shrinks and then drops Congealed Gore — those players must drop it at an edge.",
            "Raid damage ramps during Submerge, Vile Flood, and Sanguine Storm.",
          },
          dps = {
            "Soak Caustic Globules (each soak is +1 venom, but letting them explode is worse). Dodge Stir the Depths waves (+1 venom).",
            "Kill Venomous Emergence adds before Corrosive Spit applies more stacks.",
            "Soak Ravenous Feast to drop stacks. During Submerge, watch the orb ring and dodge the beam. Drop Coiling Ichor at the edge.",
          },
        },
      },
      {
        key = "coiled-altar",
        name = "The Coiled Altar",
        encounterNames = { "The Coiled Altar", "Zul'jan", "Hex Lord Malacrass", "Malacrass" },
        notes = {
          general = {
            "Three-phase fight: Zul'jan, then Hex Lord Malacrass, then Soulbinding brings Zul'jan back and both must die together.",
            "Phase 3 bonus health: Normal Zul'jan 120% / Malacrass 38%; Heroic 155% / 87%; Mythic 156% / 19% after the Race to World First nerf (was 160% / 35%).",
            "Separate health pools. If one dies first the other berserks (Soulbound — about 500% more damage). Lust in Phase 3. Assign orb collectors and, on Heroic, two soak groups.",
          },
          tank = {
            "Phase 1 Sever: aim the frontal at Coalesced Venom orbs on the assigned drop point.",
            "Phase 2 Soul Sever: aim the frontal at Manifestations of Dread and collect clones. Soul Sever applies Gravebound.",
            "Phase 3 both frontals happen together. Hold the bosses so the raid can even them for the kill.",
          },
          healer = {
            "Fangs / Defilement of the Coiled Altar are large raid hits with healing absorbs.",
            "Destroyed Coalesced Venom explodes into Venom Rupture. Venomfang and Gloombomb are heavy damage.",
            "Phase 3 overlaps both bosses' damage patterns — this is the check.",
          },
          dps = {
            "Phase 1: pick up Coalesced Venom and drop it at the assigned point. Heroic: each orb adds a stacking AoE DoT when it explodes. Stack Guillotine, then run; Heroic uses two alternating soak groups.",
            "Phase 2: walk under the boss to break Dreadmarch mind control. Look at Manifestations of Dread to freeze them, look away to move them to the drop point. Break Veil of Twilight to stop Eternal Nightfall. Heroic: kick and kill Spiritcackle adds. Focus Zul'jan during Ghastly Regeneration (he takes double damage). Step on Fragments of Malacrass, but not too many at once.",
            "Phase 3: both toolkits overlap. Even the two health bars and kill them together so the other does not berserk.",
          },
        },
      },
      {
        key = "ulatek",
        name = "Ula'tek",
        encounterNames = { "Ula'tek" },
        notes = {
          general = {
            "Three phases plus an intermission. Split the raid into two groups with a tank on each side before the pull. Lust in Phase 3.",
            "Eggs: pick them up and break them (Spectral Coil soaks or DPS the egg to 0) for a weakened add. If an egg touches venom or finishes its hatch, you get an empowered add instead.",
            "All parts of Ula'tek share health. Rage of the Shackled exposes her Heart, which takes double damage — burst it.",
          },
          tank = {
            "Phase 1: one tank on Ula'tek, one on the tail (Gore Rattle) at all times. Swap during Caustic Waves. If either is not tanked, the raid takes Rattler Slam / Unchecked Rage.",
            "Mother's Wrath: stay in melee after the knockback so it does not hit the raid. It also applies Stone Venom and a slow.",
            "Phase 2/3: pick up remaining adds as groups collapse back to the center or move platforms.",
          },
          healer = {
            "Each empowered hatch applies Putrid Membrane to the raid. Spectral Coils is a split soak.",
            "Heroic Spectral Coils applies Soul Constrictor — that player cannot soak the next one, so use two soak groups.",
            "Phase 3 Serpent's Bite must be soaked by allies or the target becomes a Calcified Corpse. After the soak, Volatile Purge: spread 5+ yards.",
          },
          dps = {
            "Phase 1: dodge Caustic Waves (the first waves come from the wing she pulls back, then the tail). Pickup eggs and soak Spectral Coils to break them. Burst the Heart during Rage of the Shackled.",
            "Phase 2: split sides, kill the Doomscale Warden (interrupt Malice, break tethers). Pick up small eggs first, then one player takes the Doomscale Egg to the cauldron (90s to pick it up, 20s to throw it in). Kick Anguished Cry on the Weakened Doomscale and AoE the adds in the center.",
            "Intermission: pick up falling eggs, soak coils, AoE weakened adds. Phase 3: break eggs, soak Serpent's Bite, dodge Caustic Waves by standing where there are no orbs, spread for Volatile Purge, then leave the platform on Circling Prey before it is destroyed.",
          },
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

function ns.FindRaidByInstance(instanceID, instanceName)
  if instanceID then
    for _, raid in ipairs(ns.RAIDS) do
      for _, id in ipairs(raid.instanceIDs or {}) do
        if id == instanceID then
          return raid
        end
      end
    end
  end
  if instanceName then
    for _, raid in ipairs(ns.RAIDS) do
      if NamesEqual(raid.name, instanceName) then
        return raid
      end
      for _, alias in ipairs(raid.nameMatches or {}) do
        if NamesEqual(alias, instanceName) then
          return raid
        end
      end
    end
  end
  return nil
end

function ns.FindBoss(name)
  if type(name) ~= "string" or name == "" then
    return nil, nil
  end
  for _, raid in ipairs(ns.RAIDS) do
    for _, boss in ipairs(raid.bosses or {}) do
      if NamesEqual(boss.name, name) then
        return boss, raid
      end
      for _, alias in ipairs(boss.encounterNames or {}) do
        if NamesEqual(alias, name) then
          return boss, raid
        end
      end
    end
  end
  -- Dungeon bosses
  for _, dungeon in ipairs(ns.DUNGEONS or {}) do
    for _, boss in ipairs(dungeon.bosses or {}) do
      if NamesEqual(boss.name, name) then
        return boss, dungeon
      end
    end
  end
  return nil, nil
end

function ns.AllBossEntries()
  local list = {}
  for _, raid in ipairs(ns.RAIDS or {}) do
    for _, boss in ipairs(raid.bosses or {}) do
      list[#list + 1] = { boss = boss, parent = raid, kind = "raid" }
    end
  end
  for _, dungeon in ipairs(ns.DUNGEONS or {}) do
    for _, boss in ipairs(dungeon.bosses or {}) do
      list[#list + 1] = { boss = boss, parent = dungeon, kind = "dungeon" }
    end
  end
  return list
end

function ns.BossKey(boss, parent)
  if not boss then
    return nil
  end
  local pk = parent and parent.key or "unknown"
  local bk = boss.key or (boss.name and boss.name:lower():gsub("%s+", "-")) or "boss"
  return pk .. ":" .. bk
end
