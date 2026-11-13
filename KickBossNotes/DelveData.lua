--[[
  Midnight delve end-boss notes. Format is general plus solo / small-group
  tips. The Midnight companion is Valeera Sanguinar (not Brann).

  Includes every regular Season 2 delve, story-variant end bosses listed in
  public databases, the Season 1 Nemesis (Nullaeus), the Season 2 Nemesis
  (Azta'rec), and the 12.1.5 megadelve boss (Kindo'jan).

  Season 3 Nemesis (Astalor Bloodsworn) is not released and is omitted.

  Sources (researched November 13, 2026):
  - Wowhead Midnight delves guide (updated 2026-08-19), Azta'rec Nemesis
    guide (2026-08-11), Labyrinth of Kindo'jan guide (2026-10-21)
  - midnighthelper.com/guides/delves (last checked 2026-10-03)
  - Community databases for story-variant end-boss names

  UNVERIFIED:
  - Instance map IDs. Delves are matched by instance name and by target or
    encounter name when those names are readable (they are often secret
    inside instances).
  - Several story-variant bosses are name-confirmed but lack a public
    ability script; those entries are flagged unverified.
  - Which Grudge Pit boss is the "default" varies by source (Brightthorn
    vs Mycomight).
]]

local ADDON, ns = ...

ns.DELVES = {
  {
    key = "atalaman",
    name = "Atal'Aman",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Atal'Aman", "Atalaman" },
    zone = "Vaults of Atal'Utek / Coiled Isle",
    bosses = {
      {
        name = "Spiritflayer Jin'Ma",
        primary = true,
        encounterNames = { "Jin'Ma", "Spiritflayer Jin'Ma" },
        notes = {
          general = {
            "Atal'Aman end boss (common Wowhead tip). Flaying Knife splits a spirit; run over the shreds for a damage buff.",
            "Use totems in the delve for extra buffs before the pull when they are up.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Run over every spirit shred after Flaying Knife — the damage buff is a large part of the burn.",
            "Do not stand on leftover shreds if they sit in a puddle or frontal; grab them as you dodge.",
            "Valeera as Healer is comfortable if you are tanking or DPSing; set her to DPS if you are healing.",
          },
        },
      },
      {
        name = "Xel'anegh the Many",
        unverified = true,
        encounterNames = { "Xel'anegh" },
        notes = {
          general = {
            "Story-variant end boss of Atal'Aman.",
            "UNVERIFIED: public tip lists are thin. Watch for split or multi-body mechanics that match the 'Many' name, and clear extra bodies before they overwhelm you.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
      {
        name = "Disciple of Vashnik",
        unverified = true,
        notes = {
          general = {
            "Story-variant end boss. Also appears in some Shadowguard Point stories.",
            "UNVERIFIED: treat this like other void-disciple fights — interrupt dangerous casts, dodge frontals, and do not linger in pools.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
    },
  },
  {
    key = "collegiate-calamity",
    name = "Collegiate Calamity",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Collegiate Calamity" },
    bosses = {
      {
        name = "Voidscorned Vagrant",
        primary = true,
        notes = {
          general = {
            "Common Collegiate Calamity end boss. The Vagrant kills nearby elves — stand in their circles to keep them alive.",
            "Books and scrolls in this delve grant extra spells or shields. Pick them up before the boss if they are still available.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Prioritize standing in elf circles over a greedy extra hit. Lost elves usually make the rest of the fight much harder.",
            "Clear any leftover trash in the room so circles are easy to see.",
            "Valeera can be DPS if you are comfortable soaking circles yourself; Healer if the ticks are high for your spec.",
          },
        },
      },
      {
        name = "Hydrangea",
        unverified = true,
        notes = {
          general = {
            "Story-variant end boss of Collegiate Calamity.",
            "UNVERIFIED: plant or pollen themes are likely — dodge ground blooms and do not stand in lingering greenery.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
      {
        name = "Infiltrator Garand",
        unverified = true,
        notes = {
          general = {
            "Story-variant end boss of Collegiate Calamity.",
            "UNVERIFIED: infiltrator kit often includes stealth adds or targeted casts. Kick what you can and keep Valeera on the add if one spawns.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
    },
  },
  {
    -- New in Season 2
    key = "gnarldor-isle",
    name = "Gnarldor Isle",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Gnarldor Isle" },
    seasonAdded = 2,
    bosses = {
      {
        name = "Gralka Snake-Eater",
        primary = true,
        encounterNames = { "Gralka", "Snake-Eater" },
        notes = {
          general = {
            "Season 2 Gnarldor Isle end boss. Snake Eater applies stacks that increase damage taken by about 15% per stack, but each stack also splashes a poison puddle.",
            "Take the damage buff, but immediately move out of the poison puddles you create. Standing in puddles wipes the value of the stacks.",
            "Scrolls in this delve grant extra abilities — use them before or during the pull if they are up.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Play the stacks greedily only if you can keep the floor clean. Drop puddles at the edge of the room and kite Gralka out of them.",
            "If puddles close the arena, stop taking new stacks until you have space.",
            "Valeera as Healer helps if you are carrying many Snake Eater stacks.",
          },
        },
      },
      {
        name = "Osseous Amalgamation",
        unverified = true,
        notes = {
          general = {
            "Story-variant end boss of Gnarldor Isle.",
            "UNVERIFIED: bone amalgam fights usually spawn pieces or adds. Cleave them and kite the boss out of bone piles.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
    },
  },
  {
    key = "parhelion-plaza",
    name = "Parhelion Plaza",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Parhelion Plaza" },
    bosses = {
      {
        name = "Gladius Slaurna",
        primary = true,
        encounterNames = { "Gladius", "Slaurna" },
        notes = {
          general = {
            "Parhelion Plaza end boss. Devouring Nova knocks players back — do not get knocked off the platform.",
            "Nearby Voidwalkers are consumed to buff him. Kill or CC the Voidwalkers before he Devours them, and keep your back to solid ground when Nova goes out.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Position near the center or with a wall at your back before Devouring Nova so the knockback cannot yeet you off.",
            "Swap to Voidwalkers immediately. A buffed Gladius plus a knockoff is the usual death.",
            "Valeera as Tank can hold walkers if you are a squishy DPS; otherwise keep her on healing.",
          },
        },
      },
      {
        name = "Replicating Venomborne",
        unverified = true,
        notes = {
          general = {
            "Seasonal / story-variant end boss. Also appears in The Darkway, The Grudge Pit, Twilight Crypts, and some other Season 2 stories.",
            "UNVERIFIED: 'Replicating' usually means copies or splits. Kill extra bodies quickly and dodge poison ground they leave behind.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Focus extra copies before they fill the room. Keep Valeera on an add if one runs at you.",
            "Kite out of poison; do not fight in a growing puddle.",
            "If this is not your end boss, target the real one or pick it from the dropdown.",
          },
        },
      },
    },
  },
  {
    key = "shadowguard-point",
    name = "Shadowguard Point",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Shadowguard Point" },
    bosses = {
      {
        name = "Chief-Arcanist Patram",
        primary = true,
        encounterNames = { "Patram", "Chief Arcanist Patram" },
        notes = {
          general = {
            "Shadowguard Point end boss. He summons an image of The Harbinger — kill the image before that cast finishes.",
            "If the image completes, expect a large hit or a much harder boss. Interrupt or burn is the whole fight.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Save a burst and a kick for the Harbinger image. Ping Valeera onto the image as soon as it spawns.",
            "Do not spend your interrupt on filler if the image cast is coming.",
            "Valeera as DPS helps the image die in time; as Healer if you can solo the burn yourself.",
          },
        },
      },
      {
        name = "Disciple of Vashnik",
        unverified = true,
        notes = {
          general = {
            "Story-variant end boss. Also appears in some Atal'Aman stories.",
            "UNVERIFIED: interrupt dangerous casts, dodge frontals, and stay out of void pools.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
    },
  },
  {
    key = "sunkiller-sanctum",
    name = "Sunkiller Sanctum",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Sunkiller Sanctum" },
    bosses = {
      {
        name = "Esuritus",
        primary = true,
        notes = {
          general = {
            "Sunkiller Sanctum end boss. Spawns Voidcallers — kill them before he Gorges them for a damage buff.",
            "A Gorge that goes through makes the rest of the fight much harder. Swap immediately.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Ping Valeera onto Voidcallers and cleave them down before Gorge.",
            "Hold a stun or kick for Gorge if the add is still alive.",
            "Valeera as DPS is strong here if you can heal yourself; otherwise Healer and you handle the adds.",
          },
        },
      },
      {
        name = "Devouring Host",
        unverified = true,
        notes = {
          general = {
            "Story-variant end boss of Sunkiller Sanctum.",
            "UNVERIFIED: devour or absorb kits usually buff the boss if adds live. Kill extras first.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
    },
  },
  {
    key = "the-darkway",
    name = "The Darkway",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "The Darkway", "Darkway" },
    bosses = {
      {
        name = "Infiltrator Gulkat",
        primary = true,
        encounterNames = { "Gulkat" },
        notes = {
          general = {
            "The Darkway end boss. During Illusory Deceit, keep moving or the illusions will damage you.",
            "Standing still is the wipe. Dodge leftover ground and do not try to plant through the illusion window.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Strafe or kite the entire Illusory Deceit window. A short pause is enough for the illusions to clip you.",
            "Keep Valeera moving with you; if she plants she can die and leave you without heals or kicks.",
            "Healer Valeera is comfortable; you focus on movement.",
          },
        },
      },
      {
        name = "Replicating Venomborne",
        unverified = true,
        notes = {
          general = {
            "Seasonal / story-variant end boss. Also appears in other Season 2 delves.",
            "UNVERIFIED: kill extra copies quickly and dodge poison ground.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Focus copies before they fill the room. Kite out of poison.",
            "Ping Valeera onto a split if one runs at you.",
          },
        },
      },
      {
        name = "Twilight's Blade",
        unverified = true,
        encounterNames = { "Twilights Blade", "Twilight's Blade" },
        notes = {
          general = {
            "Story-variant end boss of The Darkway.",
            "UNVERIFIED: blade or assassin kits usually include a frontal or a fixate. Face it away and keep moving.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
    },
  },
  {
    -- Wowhead lists Brightthorn as the tip boss; other databases also list Mycomight and Gyrospore as story ends.
    key = "the-grudge-pit",
    name = "The Grudge Pit",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "The Grudge Pit", "Grudge Pit" },
    bosses = {
      {
        name = "Brightthorn",
        primary = true,
        notes = {
          general = {
            "Wowhead's listed Grudge Pit boss. Solar Charge knocks you up and leaves puddles.",
            "Do not get knocked into a puddle or off a ledge. Move out as soon as the puddle drops.",
            "Which boss you actually get depends on the story variant — also check Mycomight and Gyrospore below.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Plant just far enough that the knockup does not throw you into yesterday's puddle. Drop new puddles toward already-used space.",
            "Valeera as Healer helps if you eat a Charge; keep her out of the puddles too.",
          },
        },
      },
      {
        name = "Mycomight",
        unverified = true,
        notes = {
          general = {
            "Story-variant Grudge Pit end boss (listed in some databases as a primary end).",
            "UNVERIFIED: mushroom or spore kits usually leave exploding ground. Kite out of blooms and do not fight in spores.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
      {
        name = "Gyrospore",
        unverified = true,
        notes = {
          general = {
            "Story-variant Grudge Pit end boss.",
            "UNVERIFIED: expect spores or spinning ground effects. Keep moving and kill any spore adds before they detonate.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
      {
        name = "Replicating Venomborne",
        unverified = true,
        notes = {
          general = {
            "Seasonal / story-variant end boss. Also appears in other Season 2 delves.",
            "UNVERIFIED: kill extra copies quickly and dodge poison ground.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Focus copies before they fill the room. Kite out of poison.",
          },
        },
      },
    },
  },
  {
    key = "the-gulf-of-memory",
    name = "The Gulf of Memory",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "The Gulf of Memory", "Gulf of Memory" },
    bosses = {
      {
        name = "Lumenia",
        primary = true,
        notes = {
          general = {
            "Gulf of Memory end boss. Radiant Command summons fixated enemies — kite them, do not stand still and eat every hit.",
            "Ceiling plants in this delve can grab you; green ground circles mark them. Watch the floor on the way in and during the fight if the room uses the same tell.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Kite Command adds in a wide circle and cleave them when they clump. Do not let them pin you against a wall.",
            "Avoid green grab circles. Valeera as Healer or Tank is comfortable if many adds spawn at once.",
          },
        },
      },
      {
        name = "Mul'tha'ul",
        unverified = true,
        encounterNames = { "Multhaul", "Mul'tha'ul" },
        notes = {
          general = {
            "Story-variant end boss of The Gulf of Memory.",
            "UNVERIFIED: public tips are thin. Kick obvious casts, kite out of ground effects, and keep Valeera up.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
    },
  },
  {
    -- New in Season 2
    key = "the-ring-of-glory",
    name = "The Ring of Glory",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "The Ring of Glory", "Ring of Glory" },
    seasonAdded = 2,
    bosses = {
      {
        name = "Drakta",
        primary = true,
        notes = {
          general = {
            "Season 2 Ring of Glory end boss. Soul Cleave leaves a ground damage circle — move the boss out of it.",
            "Pillar veils in this delve teleport you across the instance; they are for traversal, not for the boss unless a later hotfix uses them.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "As soon as Soul Cleave drops, drag Drakta out of the circle and keep fighting in the clean space.",
            "Do not let stacked circles close the ring. Drop each one toward the last.",
            "Valeera as DPS is fine if you can heal the Cleave; otherwise Healer.",
          },
        },
      },
      {
        name = "Gnok",
        unverified = true,
        notes = {
          general = {
            "Story-variant end boss of The Ring of Glory.",
            "UNVERIFIED: public tips are thin. Kick obvious casts, dodge frontals, and use the room's space.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
    },
  },
  {
    key = "the-shadow-enclave",
    name = "The Shadow Enclave",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "The Shadow Enclave", "Shadow Enclave" },
    bosses = {
      {
        name = "Lord Antenorian",
        primary = true,
        encounterNames = { "Antenorian" },
        notes = {
          general = {
            "Shadow Enclave end boss. During Shadowveil Annihilation he is immune — destroy the shadow orbs to break the shield and stop the cast.",
            "Standing idle too long in this delve can spawn a Hungry Grue. Keep moving between pulls and during long immune windows.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "As soon as Annihilation starts, swap fully to the orbs. The immune window is wasted damage if you stay on the boss.",
            "Ping Valeera onto orbs. If you cannot break them in time, be ready to defensive the finished cast.",
            "Do not AFK in the room — Hungry Grues are a real wipe on a late boss.",
          },
        },
      },
      {
        name = "Abominable Blunder",
        unverified = true,
        notes = {
          general = {
            "Story-variant end boss of The Shadow Enclave.",
            "UNVERIFIED: name suggests a clumsy construct — dodge slams and kill or kite extra bits if they split off.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "This is a story-variant end boss for this delve. Public guides listed the name but not a full ability script — treat the bullets as a starting point (UNVERIFIED vs the current journal).",
            "Use the usual delve rules: kick dangerous casts, drop pools away from the arena, and keep Valeera alive. A dead companion is a wipe on higher tiers.",
            "If this variant is not the boss you got, browse the other end bosses under this delve or target the mob to auto-open the matching note.",
          },
        },
      },
    },
  },
  {
    key = "twilight-crypts",
    name = "Twilight Crypts",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Twilight Crypts" },
    bosses = {
      {
        name = "Blademaster Darza",
        primary = true,
        encounterNames = { "Darza", "Blademaster Darza" },
        notes = {
          general = {
            "Twilight Crypts end boss. Avoid the frontal Shade Cleave — it deals damage and applies a slow.",
            "Spear traps and wall masks in this delve give buffs; grab masks before the pull when you can.",
            "Some 12.1 stories (including 'Why'd it have to be snakes?') end on Replicating Venomborne instead.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Stay to Darza's flank or rear. A slowed player in a follow-up Cleave often dies.",
            "If you get slowed, use a freedom or kite until it drops before re-entering melee.",
            "Valeera as Tank can hold him while you stay out of the frontal if your spec is squishy.",
          },
        },
      },
      {
        name = "Replicating Venomborne",
        unverified = true,
        notes = {
          general = {
            "Seasonal / story-variant end boss (including some 12.1 snake stories).",
            "UNVERIFIED: kill extra copies quickly and dodge poison ground.",
            "Midnight delve companion is Valeera Sanguinar (not Brann). Set her role before the pull: Tank, Healer, or DPS. Ping her for targets. Her curios and poisons matter on harder tiers and Nemesis fights.",
          },
          solo = {
            "Focus copies before they fill the crypt. Kite out of poison.",
          },
        },
      },
    },
  },
  {
    -- Season 2 Nemesis delve
    key = "venomfall-deeps",
    name = "Venomfall Deeps",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Venomfall Deeps" },
    nemesis = true,
    season = 2,
    bosses = {
      {
        name = "Azta'rec",
        encounterNames = { "Aztarec", "Azta'rec" },
        notes = {
          general = {
            "Season 2 Nemesis boss in Venomfall Deeps. Fought on ? and ?? difficulties. Door unlock: complete a Tier 7 (for ?) or higher (??) delve with lives left, plus the intro quest (Come with me / Valeera's chain). UNVERIFIED exact ?? door requirement if it was hotfix-changed.",
            "Main phase: dodge Noxious Bile (frontal that leaves puddles), interrupt Soul Extinction (can deal massive damage), dispel or have Valeera dispel Void Toxin (high tick and 40% damage reduction).",
            "Venom Storm sends waves or globs across the floor — dodge them. Face Bile toward the stairs or the edge so puddles do not cover mid.",
            "Intermissions at 90%, 60%, and 30%: Sermon of Ula'tek telegraphs three-quadrant detonations (remember the safe quadrant order), then Echo of Ula'tek repeats the same pattern with no telegraph. Players hit receive Ula'tek's Mark.",
            "?? (and reportedly later ? intermissions as well — UNVERIFIED vs hotfix): the sequence lengthens each intermission (about 5/6/7 on ??). ?? also spawns Echo of Azta'rec, a clone that uses main-phase abilities and must die before the memory game ends.",
            "Suggested ilvl around 290 for ? and 309 for ?? (community / Wowhead advice, not a hard lock).",
          },
          solo = {
            "Valeera: Healer for almost every tank or DPS spec (she dispels Void Toxin). DPS Valeera only if you are healing. Do not set her to Tank here.",
            "Accursed Poison from the Corrosive Codex can auto-interrupt Soul Extinction and is widely recommended. Curios commonly used: Corrosive Bilespear and Soul-Cracking Dreamcatcher.",
            "Tank him at the edge, facing outward, so Bile puddles stay off the center. Before 91/61/31%, move toward mid so you can reach the first safe quadrant. If Venom Storm globs are still crossing mid, stop damage until they clear.",
            "Mark the four quadrants (avoid green markers — the floor is green). Remember or write the safe-quadrant order, then repeat it during the Echo. You can run through the boss; the puddle graphic is not always a hard block.",
            "On ??, kill the Echo during the memory game. If boss and Echo Soul Extinction overlap, you need a second interrupt, a CC, or Accursed Poison. Auto-attacks hit very hard for non-tanks — he outruns a kite.",
            "Tanks take Serpent's Strike as a tank buster (community reports of heavy hits — rotate defensives). Non-tanks must also survive hard melees in the main phase.",
          },
        },
      },
    },
  },
  {
    -- Season 1 Nemesis delve — still present in Season 2
    key = "torments-rise",
    name = "Torment's Rise",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Torment's Rise", "Torments Rise" },
    nemesis = true,
    season = 1,
    bosses = {
      {
        name = "Nullaeus",
        encounterNames = { "Nulleus", "Nullaeus" },
        notes = {
          general = {
            "Season 1 Nemesis boss in Torment's Rise. The delve still exists; some Season 1 exclusive rewards may no longer be earnable.",
            "Always interrupt Emptiness of the Void — it is room-wide and can one-shot.",
            "Dispel Devouring Essence (or have Valeera do it as Healer). Tanks defensive Imploding Strike.",
            "At 75%, 50%, and 25% he becomes immune in an Oblivion Shell. Kill the adds: 2 Razorshell Ravagers at 75% (bleed), 7 Spitting Ticks at 50% (AoE), and 1 Enslaved Voidcaster at 25%. Interrupt the Voidcaster at most once so your kick is ready for the next Emptiness.",
            "After 75% void goo covers the floor. After 50% a Gravity Well pulls you. After 25% Umbral Rage is a stacking damage buff on him — save major cooldowns for this last push.",
          },
          solo = {
            "If you tank or DPS, set Valeera to Healer so she dispels Devouring Essence. If you heal, set her to DPS so she can kick Emptiness of the Void.",
            "Never spend your last kick on a filler or on a second Voidcaster interrupt if Emptiness is due.",
            "Clear the 75/50/25% add waves completely during the shell. Leaving ticks or ravagers into the next main phase is a wipe.",
            "Watch your feet after 75% (goo) and resist or run against the 50% Gravity Well. Pop damage cooldowns after 25% to beat Umbral Rage.",
          },
        },
      },
    },
  },
  {
    -- Patch 12.1.5 megadelve / Labyrinth. Always bountiful. Separate Labyrinth Journey.
    key = "labyrinth-of-kindojan",
    name = "The Labyrinth of Kindo'jan",
    kind = "delve",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "The Labyrinth of Kindo'jan", "Labyrinth of Kindo'jan", "Kindo'jan's Labyrinth" },
    megadelve = true,
    season = 2,
    bosses = {
      {
        name = "Kindo'jan",
        encounterNames = { "Kindojan", "Kindo'jan", "The First Hash'ey" },
        notes = {
          general = {
            "Megadelve end boss in the Speaker's Chamber (Akil'zon's Roost). Available on Tier 8+. First unlock: clear all nine chambers in a single run. Later runs only need a route to Akil'zon's Roost after that first unlock.",
            "Patience fight, not a strict DPS check, but he enrages after about 10 minutes. The real failure is Disgraceful Display: each avoidable hit grants a stack, and 3 stacks within 5 minutes is an instant death (tanks included).",
            "His kit, in order at first: Eruption of Mojo (dodge circles; each cast also drops Erratic Mojo where you stand — do not linger), Hash'ey's Command (four Amani Headhunter spirits; their Axe Barrage circles can be tanked occasionally without a Display stack), Whirling Axes (four arc-paths of axes — dodge them), Crushing Blow (melee slam plus an Amani Juggernaut in the center).",
            "Juggernauts cannot be stunned or CC'd. They Phalanx Charge (knockback) and try to cast Amani Aegis (damage reduction for allies). Interrupt Aegis and treat Juggernauts as top priority.",
            "Loa intermission, in order: De Rising Storm (Akil'zon avatar pushes you back — stand in the small safe spots), Gambit in de Shadows (four Shadows of Halazzi stun Valeera; stand in the real targeting line so the circle moves off her — the real shadow paws the ground, or walk lines until the circle leaves Valeera), Ursine Rampage (Nalorakk images charge across; find the gap or you are knocked off), Cleansing Flame (stand in the loa sigil as it expires; Valeera pings which of the two she will soak). Later, Kindo'jan can recast these randomly, sometimes overlapping, and can teleport to a corner that telegraphs the next loa ability.",
          },
          solo = {
            "Loot Mislaid Treasures, Curios, and all three Hexmasks before pulling — boons persist into the boss room and make a large difference. A Spectral Altar of Corrosion and a waystone sit just past the door.",
            "Valeera as DPS is strong if you can interrupt Amani Aegis and survive; Healer if Display mistakes or Rampage knockbacks are hurting you. If Valeera is already dead, Gambit in de Shadows is skipped (not a plan you should rely on).",
            "For Gambit: move from line to line until the white targeting circle leaves Valeera and appears under you, then stand still. If the circle stays on her, she is incapacitated.",
            "For Cleansing Flame, trust Valeera's ping and stand in that sigil. When Kindo'jan recasts it, a Juggernaut immediately Phalanx Charges — you only have a moment after the knock to reach the sigil.",
            "Drop Mojo pools toward already-used space. Lust and burst early if your boons are high enough to kill him before the first Rising Storm; otherwise play clean and beat the 10-minute enrage.",
            "Pets can get you knocked off during Ursine Rampage (community BM Hunter reports). Watch your own gap, not your pet's.",
          },
        },
      },
    },
  },
}

function ns.FindDelveByName(name)
  if type(name) ~= "string" or name == "" then
    return nil
  end
  for _, delve in ipairs(ns.DELVES) do
    if ns.NamesEqual and ns.NamesEqual(delve.name, name) then
      return delve
    end
    for _, alias in ipairs(delve.nameMatches or {}) do
      if ns.NamesEqual and ns.NamesEqual(alias, name) then
        return delve
      end
    end
  end
  return nil
end

function ns.GetCurrentDelve()
  local instanceID, instanceName = nil, nil
  if ns.GetInstanceMapID then
    instanceID, instanceName = ns.GetInstanceMapID()
  else
    local ok, name = pcall(GetInstanceInfo)
    if ok then
      instanceName = name
    end
  end
  local found = ns.FindDelveByName(instanceName)
  if found then
    return found, instanceID, instanceName
  end
  return nil, instanceID, instanceName
end
