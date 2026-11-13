--[[
  Midnight raid and lair boss notes, role-aware (general + Tank / Healer / DPS).

  Covers every Midnight raid released through patch 12.1.5 / Season 2:
  The Venomous Abyss, The Unbinding of Kith'ix, The Tidebound Grotto (lair),
  The Voidspire, The Dreamrift, March on Quel'Danas, and Sporefall.

  Dummy Dome (test raid) and unreleased Season 3 encounters are omitted.

  Sources (researched November 13, 2026):
  - Wowhead Midnight raids hub (updated 2026-11-09) and individual boss guides
  - Icy Veins / Method cheat sheets where Wowhead was thin (Chimaerus)
  - Warcraft Wiki encounter names

  UNVERIFIED:
  - Instance map IDs for Midnight-original raids were not on Warcraft Wiki's
    InstanceID list at the time of writing. Raids are matched by instance name
    from GetInstanceInfo() and by encounter name on ENCOUNTER_START.
  - Crown of the Cosmos stage script was thin on Wowhead; those bullets are
    marked UNVERIFIED and should be confirmed from the dungeon journal.
]]

local ADDON, ns = ...

ns.RAIDS = {
  {
    key = "venomous-abyss",
    name = "The Venomous Abyss",
    short = "Venomous Abyss",
    kind = "raid",
    season = 2,
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
  {
    key = "unbinding-of-kithix",
    name = "The Unbinding of Kith'ix",
    short = "Kith'ix",
    kind = "raid",
    season = 2,
    instanceIDs = {}, -- UNVERIFIED: no published InstanceID found
    nameMatches = { "The Unbinding of Kith'ix", "Unbinding of Kith'ix", "Kith'ix" },
    bosses = {
      {
        name = "Kith'ix",
        encounterNames = { "Kithix", "The Unbinding of Kith'ix" },
        notes = {
          general = {
            "Phase 1 cycles until Kith'ix reaches 100 energy: kill all adds before then. Adds near the boss take 50% less damage from Commanding Presence — keep the boss away from them.",
            "Add plan: cleave Venomous Hulk and Voidweaver together, kite Bomber Beetles, stagger their explosions (Digestive Juices stacks). All adds must be dead going into the intermission or they Dark Frenzy.",
            "Unspeakable Horrors: if you have the purple arrow, run out, then dispel Overwhelming Fear once you are clear (the scream is fall-off).",
            "Run through a Light's Embrace ball before Extinguish (the shockwave). Dodge Twisted Appendage slaps (3-second circles).",
            "Intermission: stand in Liadrin's Refulgent Bulwark (the light) until her energy hits 100%. Heroic: intercept Voidscar orbs so they do not reach Liadrin.",
            "Phase 2 at 25%: Last Light fully heals the raid and grants Luminous Grace (100% damage and healing). Lust and burn before Eightfold Eclipse (eight eclipses is a wipe). Spread for Null Gates, avoid Nullshards (4–6 Nullify stacks kill you).",
            "Soft enrage: Liadrin becomes Exhausted (her help weakens each cycle). Hard enrage: the eighth Eclipse.",
          },
          tank = {
            "One tank holds Kith'ix at the edge of the room, away from adds. The other holds the Venomous Hulk on top of the Voidweaver for cleave. Face Venom Roar away.",
            "Swap at 1 stack of Dark Devastation. The targeted tank runs the large circle to the edge, off the raid. Heroic: the swap also drops a Voidscar pool.",
            "During the intermission, keep your Dark Devastation circle as close as possible to the edge of Liadrin's bubble without leaving the light.",
            "Phase 2: swap on Negation and run through a Null Gate to remove it. The explosion when it expires or is removed hits a 15-yard circle — step out of the raid.",
          },
          healer = {
            "Dispel Overwhelming Fear only after the player has run out. Heal Abyssal Grasp absorbs quickly or the player is dragged into the darkness.",
            "Digestive Juices can stack from staggered beetle explosions — pad when several go off close together.",
            "Everyone needs Light's Embrace before Extinguish or the shockwave is massive. Phase 2 starts with a full heal; then heal through each Eclipse and Nullify ticks.",
          },
          dps = {
            "Kill every add before 100 energy. Cleave Hulk plus Voidweaver; kite beetles and do not pop them all at once. Kick or stop Nightfall pressure as assigned.",
            "Run out with Unspeakable Horrors. Grab a Light's Embrace ball. Dodge tentacle slaps.",
            "Heroic intermission: intercept Voidscar orbs heading to Liadrin. Phase 2: lust, plant for the 100% amp, spread Null Gates, and never eat Nullshards.",
          },
        },
      },
    },
  },
  {
    key = "tidebound-grotto",
    name = "The Tidebound Grotto",
    short = "Tidebound Grotto",
    kind = "raid",
    season = 2,
    instanceIDs = {}, -- UNVERIFIED: no published InstanceID found
    nameMatches = { "The Tidebound Grotto", "Tidebound Grotto" },
    lair = true, -- 15-40 player lair raid, not a dungeon
    flex = "World / Normal 30 / Heroic 30 / Mythic Flex 25",
    bosses = {
      {
        name = "Nymrissa Wavecaller",
        encounterNames = { "Nymrissa", "Wavecaller" },
        notes = {
          general = {
            "Tidebound Grotto is a 15–40 player LAIR raid (not a 5-man dungeon). Counts toward the raid row of the Great Vault. Flexible Mythic is available.",
            "Nymrissa forms an Alluring Bubble that lures Bubblefin murlocs. Kill them before they enter the bubble or they become Berserkers and pulse raid damage.",
            "Priority: Frostscales first (Mythic — Waterfog Shield makes nearby murlocs nearly immune), then Berserkers, then Shorerunners.",
            "Avoid Swirling Whirlpools; stand in the safe gap. Whirlpools later converge on the center.",
            "Chilling Frost drops Frost Orbs. Move slowly so orbs clump in the same place. Heroic: soak orbs before they Shatter, but do not soak too many at once (stacking DoT). Mythic: touching an orb also Frost Bursts.",
            "The bubble Pop! is a raid-wide hit and knockback if murlocs reached it. Lust on pull.",
          },
          tank = {
            "Point Water Jet (and Iceblade Flurry on Normal/Heroic) away from the group. Water Jet also washes away Lingering Frost patches.",
            "Each Water Jet hit stacks a 20% damage-taken debuff — taunt swap when stacks are high.",
            "Hold Nymrissa so the raid can see incoming murloc paths and whirlpool gaps.",
          },
          healer = {
            "Abyssal Rain is significant raid damage (Heroic also stacks Wavecaller's Might on the boss). Pad Rain and any Pop!.",
            "Frost Orb DoTs and Shatter are the other big hits — call if too many players soaked at once.",
            "Watch the tank during stacked Water Jet.",
          },
          dps = {
            "Kill incoming murlocs before they reach the bubble. Frostscale > Berserker > Shorerunner.",
            "If targeted by Chilling Frost, move slowly and drop orbs together. Help soak Heroic orbs without hoarding stacks.",
            "Stand in the whirlpool-free gap. Do not get knocked into a whirlpool by Pop!.",
          },
        },
      },
    },
  },
  {
    key = "the-voidspire",
    name = "The Voidspire",
    short = "Voidspire",
    kind = "raid",
    season = 1,
    instanceIDs = {}, -- UNVERIFIED: no published InstanceID found
    nameMatches = { "The Voidspire", "Voidspire" },
    bosses = {
      {
        name = "Imperator Averzian",
        notes = {
          general = {
            "Three add constructs start immune until they are hit by Umbral Collapse, a large group soak.",
            "After two constructs die, the third leaves a void portal. Do not let three adjacent portals form or March of the Endless wipes the raid.",
            "Plan which two constructs die each cycle so leftover portals are spaced apart.",
            "Bring assigned soaks and mobility for Collapse; missed soaks leave constructs immune and stall the fight.",
          },
          tank = {
            "Hold Averzian and help call which construct will eat the next Umbral Collapse.",
            "Keep leftover portals and the boss far enough from the next soak that the raid can plant together.",
            "Be ready to pick up constructs as they become attackable.",
          },
          healer = {
            "Umbral Collapse is a heavy group soak — pad the raid before it lands.",
            "Portal and add damage ramps if soaks are sloppy; save a cooldown for a messy Collapse.",
            "Watch soak groups for players who miss the circle.",
          },
          dps = {
            "Stack in Umbral Collapse so the assigned construct becomes attackable.",
            "Swap immediately to the vulnerable construct and finish the two assigned kills.",
            "Do not accidentally kill a third adjacent construct and close a three-portal setup.",
          },
        },
      },
      {
        name = "Vorasius",
        notes = {
          general = {
            "One repeating phase. Vorasius slams the floor and raises crystal walls that cut the room.",
            "Kite Blistercreep adds into the walls to shatter them. Breaking a wall opens a Void Breath safe zone.",
            "Damage and haste of the fight ramp with each wall set — clear quickly and do not leave adds idle.",
            "Stay in the current safe zone once Breath windows open; later sets leave less room.",
          },
          tank = {
            "Angle slams so new walls do not trap the raid against existing ones.",
            "Kite or drag Blistercreeps toward walls when DPS cannot immediately crash them.",
            "Hold the boss in the open safe zone after a wall breaks.",
          },
          healer = {
            "Raid damage ramps each wall cycle — plan cooldowns later in the fight.",
            "Players who miss a Void Breath safe zone take a large hit; be ready to top them.",
            "Watch tanks when they hold Blistercreeps through a wall break.",
          },
          dps = {
            "Priority: crash Blistercreeps into walls, then return to the boss.",
            "Do not tunnel the boss while a wall is still boxing the raid out of the next Breath zone.",
            "Move into the Void Breath safe zone as soon as the wall shatters.",
          },
        },
      },
      {
        name = "Fallen-King Salhadaar",
        encounterNames = { "Salhadaar", "Fallen King Salhadaar" },
        notes = {
          general = {
            "Void Convergence creates Concentrated Void orbs that must be killed before they reach Salhadaar.",
            "At 100 energy he casts Entropic Unraveling (beams). After the beams, he takes 25% increased damage for 20 seconds — this is the burn window.",
            "Assign orb soaks or killers so no orb reaches the boss; orbs that land empower him.",
            "Dodge Unraveling beams, then stack cooldowns in the 20-second amp.",
          },
          tank = {
            "Hold Salhadaar in a place that gives orb-killers a short path and leaves beam lanes open.",
            "Mitigate tank hits around energy 100 so you are not down as the burn starts.",
            "Help call when orbs are leaking toward the boss.",
          },
          healer = {
            "Entropic Unraveling is a heavy raid hit — pad before 100 energy.",
            "The 20-second amp is also a healing check if beams were messy.",
            "Watch orb-soakers who take ticks while finishing a late orb.",
          },
          dps = {
            "Kill Concentrated Void orbs before they reach the boss. Assign a small group if needed.",
            "Hold a major cooldown for the 20-second damage amp after Unraveling.",
            "Dodge beams; a death in the amp window loses the burn.",
          },
        },
      },
      {
        name = "Vaelgor and Ezzorak",
        encounterNames = { "Vaelgor", "Ezzorak", "Vaelgor & Ezzorak" },
        notes = {
          general = {
            "Keep damage even on Vaelgor and Ezzorak or Twilight Bond will punish the raid.",
            "Vaelgor's Dread Breath targets players — those players run the breath out of the group.",
            "Ezzorak's Gloom orbs should be soaked to shrink them before they become dangerous.",
            "Intermission: Lightblind Vanguard's Radiant Barrier appears in the center — stand in it.",
            "After the third intermission the fight enrages. Comment on Wowhead; confirm the exact enrage with your log or timer addon.",
            "Mythic Nullbeam soaks are stricter; below Mythic they are often tank-only.",
          },
          tank = {
            "Split the bosses as assigned and keep health even for Twilight Bond.",
            "Soak Nullbeam (often tank-only on Normal and Heroic). Do not leave it for the raid unless the plan says so.",
            "Bring both bosses to the center for the Radiant Barrier intermission, then split again.",
          },
          healer = {
            "Twilight Bond and Dread Breath mistakes spike the raid — pad when health gaps open.",
            "Gloom soaks and Nullbeam are the other big hits; watch the soaking tank.",
            "Stand in Radiant Barrier during the intermission and top the raid before the next split.",
          },
          dps = {
            "Balance damage on both bosses. Call if one is pulling ahead.",
            "If targeted by Dread Breath, run it out. Help soak Gloom orbs to shrink them.",
            "Stand in the center Radiant Barrier during the intermission. Plan a burn before the post-third-intermission enrage.",
          },
        },
      },
      {
        name = "Lightblinded Vanguard",
        encounterNames = { "Lightblood", "Bellamy", "Senn", "Lightblind Vanguard", "Lightblinded Vanguard" },
        notes = {
          general = {
            "Council of Lightblood, Bellamy, and Senn. At 100 energy one of them casts Aura of Wrath, Aura of Devotion, or Aura of Peace.",
            "Move the other two bosses out of the active aura or the raid is overwhelmed.",
            "Paladin toolkit matters here: Consecration, Divine Shield, and Execution Sentence are commonly assigned on the auras or on the marked target. Follow your raid's call.",
            "Watch which boss is targeting or being judged so taunts and swaps stay clean.",
          },
          tank = {
            "Each tank holds an assigned council member and is ready to drag them out of a new aura.",
            "Taunt after Judgments when the targeted tank is called. Do not leave two bosses stacked in an aura.",
            "Call which aura just went out so the third tank or offtank can adjust.",
          },
          healer = {
            "Aura windows are the raid-wide check — pad before 100 energy.",
            "Players who stay in the wrong aura take heavy ticks. Top them or call a defensive.",
            "Watch tanks after Judgment swaps.",
          },
          dps = {
            "Help move or focus the correct target when an aura goes out, per the assignment.",
            "Use assigned Paladin tools (Execution Sentence, Divine Shield, Consecration) when you have them.",
            "Do not cleave a boss that is being kited out of an aura if it would pull it back in.",
          },
        },
      },
      {
        name = "Crown of the Cosmos",
        unverified = true,
        encounterNames = { "Xal'atath", "Xalatath", "Crown of the Cosmos" },
        notes = {
          general = {
            "Final Voidspire encounter. Three stages with intermissions: several mini-bosses plus Xal'atath, with Turalyon, Arator, and Alleria appearing as allies.",
            "UNVERIFIED / thin public cheat-sheet: Wowhead's overview (checked 2026-11) did not list a full mechanic-by-mechanic script. Use the dungeon journal and your raid's assignment for soaks, beams, and add burns.",
            "Plan Bloodlust for the assigned burn stage (often a later stage). Confirm timing with your raid lead.",
            "Clear intermission adds before the next stage so raid-wides do not overlap leftover mechanics.",
            "If a name in the journal differs, this entry also matches Xal'atath.",
          },
          tank = {
            "UNVERIFIED details: pick up each stage's main target and any spawned mini-bosses immediately.",
            "Position so the raid can soak or dodge as the journal describes, and so allies are not standing in frontals.",
            "Call swaps if a stage applies a tank debuff — confirm in the journal.",
          },
          healer = {
            "UNVERIFIED details: expect heavy raid damage at stage transitions and during intermissions.",
            "Hold a major cooldown for each intermission until you have a feel for the damage pattern.",
            "Watch tanks when mini-bosses spawn together.",
          },
          dps = {
            "UNVERIFIED details: kill assigned mini-bosses or adds before returning to Xal'atath.",
            "Hold major cooldowns for the called burn stage.",
            "Dodge and soak as marked; do not skip intermission add work.",
          },
        },
      },
    },
  },
  {
    key = "the-dreamrift",
    name = "The Dreamrift",
    short = "Dreamrift",
    kind = "raid",
    season = 1,
    instanceIDs = {}, -- UNVERIFIED: no published InstanceID found
    nameMatches = { "The Dreamrift", "Dreamrift" },
    bosses = {
      {
        name = "Chimaerus",
        encounterNames = { "Chimaerus the Undreamt God", "The Undreamt God" },
        notes = {
          general = {
            "Only boss of The Dreamrift. Two stages that repeat until Chimaerus dies. Bring cleave.",
            "Split the raid: one group soaks Alndust Upheaval into the Rift, breaks add shields, and clears pools; the other stays in Reality and kills adds before they reach Chimaerus.",
            "Add priority: Colossal Horror first, interrupt Haunting Essence's Fearsome Cry, cleave Swarming Shades.",
            "At 100 energy, avoid Corrupted Devastation and kill the spawned adds before Ravenous Dive, then the cycle repeats.",
            "Mythic: Dissonance separates realms and Rift Madness can swap players between them. Assign stable Reality and Rift teams.",
          },
          tank = {
            "One tank typically holds Chimaerus in Reality; the other covers large adds (Colossal Horror) or the Rift team as assigned.",
            "Face frontals away from the soak group and keep the boss off freshly dropped pools.",
            "Help collapse add packs so Reality never lets a living add reach the boss.",
          },
          healer = {
            "Alndust Upheaval soaks and Corrupted Devastation are the big raid hits — pad those windows.",
            "Cover both realms on Mythic; a Rift team that falls behind needs external help.",
            "Top players who soak or who get caught in pools after a shield break.",
          },
          dps = {
            "Know whether you are Reality or Rift. Reality: kill adds instantly. Rift: soak Upheaval, break shields, clear pools.",
            "Kick Fearsome Cry on Haunting Essences. Prioritize Colossal Horror over small shades.",
            "At 100 energy, dodge Corrupted Devastation and burn the new adds before Ravenous Dive.",
          },
        },
      },
    },
  },
  {
    key = "march-on-queldanas",
    name = "March on Quel'Danas",
    short = "Quel'Danas",
    kind = "raid",
    season = 1,
    instanceIDs = {}, -- UNVERIFIED: no published InstanceID found
    nameMatches = { "March on Quel'Danas", "March on Quel'Danas", "Quel'Danas" },
    bosses = {
      {
        name = "Belo'ren",
        encounterNames = { "Beloren", "Belo'ren, Child of Al'ar", "Child of Al'ar" },
        notes = {
          general = {
            "The raid is split at the start into Light Feather and Void Feather teams. You can only interact with mechanics that match your feather color.",
            "Do not soak, pick up, or stand in the opposite color. Call if a player was given the wrong side for the assignment.",
            "When Belo'ren reaches 0 HP, a Rebirth egg appears in the center. The egg is the boss's real health.",
            "The fight repeats body and egg stages until the egg dies. Lust and major cooldowns on the egg.",
            "Stay in your color lane through every repeat so the egg burn is not delayed by a wipe on the body.",
          },
          tank = {
            "Hold Belo'ren so both color teams have a clean path to their own mechanics.",
            "Be ready to taunt or reposition as soon as the egg forms so DPS can plant.",
            "Do not drag the boss through the opposite color's soaks.",
          },
          healer = {
            "Heal your color's soaks; opposite-color hits are usually avoidable and very expensive.",
            "The egg spawn is a burn and a healing check if the last body phase was messy — top the raid as the egg forms.",
            "Watch feather teams independently if they split far apart.",
          },
          dps = {
            "Only interact with your feather color. Save Bloodlust and major cooldowns for the Rebirth egg.",
            "Plant on the egg as soon as it spawns; that is the true health bar.",
            "If you are the wrong color for a soak, do not 'help' — you cannot interact and will usually fail it.",
          },
        },
      },
      {
        name = "Midnight Falls",
        encounterNames = { "L'ura", "Lura", "Midnight Falls" },
        notes = {
          general = {
            "L'ura. Three phases, with an intermission between Phase 1 and Phase 2.",
            "Phase 1 includes a memory-style Death's Dirge pattern and dodging Heaven's Glaives.",
            "Dawn Crystals protect players from dark abilities — stand in or use them when those hits go out.",
            "Interrupt Safeguard Matrices. Burst Midnight Crystals when they spawn so they do not overwhelm the raid.",
            "Intermission and later phases repeat these rules with tighter timing. Follow the journal if a later-phase name differs.",
          },
          tank = {
            "Hold L'ura in a place that leaves the raid room to dodge Glaives and stand in Dawn Crystals.",
            "Pick up Matrix or crystal-related adds immediately so kickers can reach them.",
            "Be ready to move the boss after the intermission into the Phase 2 position.",
          },
          healer = {
            "Heaven's Glaives and missed Dirge patterns spike the raid. Pad those windows.",
            "Players outside Dawn Crystals during dark hits need instant help.",
            "The intermission is a good time to top the raid and reset cooldowns.",
          },
          dps = {
            "Kick Safeguard Matrices every time. Swap to Midnight Crystals and burn them.",
            "Watch Death's Dirge and repeat the safe pattern. Dodge Heaven's Glaives; do not bait them through the raid.",
            "Use Dawn Crystals when dark abilities are called.",
          },
        },
      },
    },
  },
  {
    key = "sporefall",
    name = "Sporefall",
    short = "Sporefall",
    kind = "raid",
    season = 1,
    instanceIDs = {}, -- UNVERIFIED: no published InstanceID found
    nameMatches = { "Sporefall" },
    flex = "Mythic Flex 15-25",
    bosses = {
      {
        name = "Rotmire",
        notes = {
          general = {
            "Only boss of Sporefall (Mythic Flex, 15–25). Awaken Fungi spawns minions — do not stand in their explode zones.",
            "At 100 energy, Fungal Bloom is huge raid damage, heals and enrages minions, and turns corpses into Bursting Shrooms. Kill or CC adds and clear corpses before Bloom.",
            "Festering Vines is followed by Writhing Vines puddles — move the boss and the raid out of the mess.",
            "Bursting Pustules apply stacking Rotting Pustules as a raid DoT. Plan healing and defensive windows around it.",
            "Mythic: if a Shroomling and a Fungling corpse die within 10 yards, Cross Fertilization creates a Doom Shroom. Separate those deaths.",
          },
          tank = {
            "Mitigate Putrid Fist. Face the boss away from vine puddles and leftover corpses.",
            "Help drag adds or the boss so Shroomling and Fungling corpses are not within 10 yards on Mythic.",
            "Call when energy is close to 100 so DPS can finish leftover minions before Bloom.",
          },
          healer = {
            "Fungal Bloom and Rotting Pustules are the major raid checks. Pre-load HoTs and a cooldown for Bloom.",
            "Players standing in explode zones or vine puddles will spike — call them out.",
            "Dispel or cleanse whatever the journal lists if a Pustule variant is dispellable; otherwise heal through the stack.",
          },
          dps = {
            "Cleave and CC minions. Corpses must be cleared before Fungal Bloom or they become Bursting Shrooms.",
            "Do not stand in explode circles or Writhing Vines. On Mythic, stagger Shroomling and Fungling deaths so they are not within 10 yards.",
            "Use a personal at Bloom if you are still dropping a late add.",
          },
        },
      },
    },
  },
}

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
  if type(instanceName) == "string" and instanceName ~= "" then
    for _, raid in ipairs(ns.RAIDS) do
      if ns.NamesEqual and ns.NamesEqual(raid.name, instanceName) then
        return raid
      end
      for _, alias in ipairs(raid.nameMatches or {}) do
        if ns.NamesEqual and ns.NamesEqual(alias, instanceName) then
          return raid
        end
      end
    end
  end
  return nil
end
