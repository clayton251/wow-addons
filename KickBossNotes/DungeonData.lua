--[[
  Midnight dungeon interrupt-priority casts and role-aware boss notes.

  Includes every Midnight dungeon (Season 2 M+ and leveling / non-M+),
  plus the three legacy dungeons in the current Season 2 Mythic+ pool.
  Season 1-only legacy dungeons (Algeth'ar Academy, Pit of Saron,
  Seat of the Triumvirate, Skyreach) are omitted.

  Sources (researched November 13, 2026; patch 12.1.5 / Season 2):
  - Blizzard: "Midnight Season 2 is Now Live!"
  - Wowhead Midnight dungeon overview (updated 2026-10-16) and M+ overview
  - Method.gg dungeon guides (Magisters' Terrace, Maisara Caverns, and others)
  - Interrupt priorities for the Season 2 M+ pool: Orboro cheat sheet
    (updated 2026-08-24)
  - Legacy instance map IDs from Warcraft Wiki InstanceID:
    Ruby Life Pools 2521, Kings' Rest 1762, Temple of Sethraliss 1877.

  UNVERIFIED:
  - Instance map IDs for Midnight-original dungeons were not published on
    Warcraft Wiki's InstanceID list at the time of writing. Those dungeons
    are matched by instance name from GetInstanceInfo() (and by
    challenge-mode map name when a key is active).
  - Leveling / non-M+ dungeons have no Orboro interrupt sheet; kick lists
    there are thin or empty and boss notes are condensed from Method /
    Wowhead overviews.
  - Some Midnight boss notes remain abbreviated or flagged UNVERIFIED
    where public cheat sheets were thin (Xathuux, Taz'Rah, Nalorakk, and
    a few others).
]]

local ADDON, ns = ...

ns.DUNGEONS = {
  {
    key = "altar-of-fangs",
    name = "Altar of Fangs",
    short = "Altar",
    kind = "dungeon",
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
          general = {
            "Avoid Rav'i's poison cone. Jump onto the boss platform; the surrounding ground is poison.",
            "Dispel Regurgitate if it lands, or use a movement-clear / freedom to break it.",
            "Keep the room path back to the platform clear so a knock or puddle does not strand you.",
          },
          tank = {
            "Face the cone away from the group at all times.",
            "Hold Rav'i on the platform so melee are not standing in poison to reach him.",
            "Call if you have to move and the cone will sweep the party.",
          },
          healer = {
            "Dispel Regurgitate quickly — it is the main targetable failure.",
            "Players who stand in the cone or off-platform poison will spike.",
            "Stay on the platform unless you must drop a puddle elsewhere.",
          },
          dps = {
            "Stay out of the cone and off-platform poison.",
            "Do not drop movement abilities before a cone if you will need them to get back on the platform.",
            "Help call Regurgitate if the healer is moving.",
          },
        },
      },
      {
        name = "The Writhing Coil",
        notes = {
          general = {
            "Kick Toxic Atrophy — the boss casts it three times in sequence. It reduces speed and damage. Dispel if a kick is missed.",
            "Death Rattle: the whole group must run far enough to break the cast and uncoil the boss.",
            "Hold a kick rotation that covers all three Atrophy casts; do not blow every kick on the first one.",
          },
          tank = {
            "Hold the boss still so kicks can land, then be ready to move together for Death Rattle.",
            "Do not drag the Coil through the group during the three-cast sequence.",
            "Call when Death Rattle starts so melee drop and run.",
          },
          healer = {
            "Dispel Toxic Atrophy if a kick is missed, especially mid-sequence.",
            "Death Rattle is a movement check — be already moving with the group.",
            "Watch stacks if two Atrophies land in a row.",
          },
          dps = {
            "Save kicks for every Toxic Atrophy in the three-cast sequence.",
            "Run out on Death Rattle; staying in melee to finish a cast will fail it.",
            "Stop the boss with a CC only if your plan calls for it — kicks come first.",
          },
        },
      },
      {
        name = "Zul'jan",
        notes = {
          general = {
            "Final boss of Altar of Fangs. Soak beams as assigned.",
            "Community reports: do not immune the physical frontal used to clear beam-soak stacks, or the stacks may remain. UNVERIFIED / hotfix-sensitive.",
            "If your immunities eat the clear, call it and find another way to drop stacks (another frontal or a wait, per the current journal).",
          },
          tank = {
            "Aim the physical frontal as assigned so soak stacks can be cleared.",
            "Hold Zul'jan so beam soakers have a short, clean path.",
            "If a soaker immuned the clear, be ready to frontal again.",
          },
          healer = {
            "Watch soak damage and any leftover stack after a missed or immuned frontal.",
            "Pad the raid when several beams overlap.",
            "Call leftover stacks so the tank can clear them.",
          },
          dps = {
            "Soak beams as assigned. Avoid immuning the stack-clear frontal.",
            "Drop stacks before the next beam wave if you still have them.",
            "Do not stand in unassigned beams.",
          },
        },
      },
    },
  },
  {
    key = "murder-row",
    name = "Murder Row",
    short = "Murder Row",
    kind = "dungeon",
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
          general = {
            "Kystia and Nibbles share the encounter. Kick Felstorm on the mirror images and burn them before pulsing damage ramps.",
            "Dispel Corroding Spittle on either target.",
            "Images are the wipe if they are left free to Felstorm — swap immediately.",
          },
          tank = {
            "Keep the pair controllable and in kick range.",
            "Help collapse images onto the bosses for cleave once they are kicked.",
            "Face any frontals away from the group.",
          },
          healer = {
            "Dispel Corroding Spittle on either Kystia or Nibbles (and the group if it spreads).",
            "Image Felstorms that go off are a raid spike — pad if a kick is late.",
            "Watch both health bars; they can desync if cleave is uneven.",
          },
          dps = {
            "Swap to images and kick Felstorm every time.",
            "Cleave back onto Kystia and Nibbles once the image is dead or locked down.",
            "Do not ignore Nibbles if you were assigned to it.",
          },
        },
      },
      {
        name = "Zaen Bladesorrow",
        notes = {
          general = {
            "Dispel Heartstop Poison immediately so it does not stack.",
            "Murder in a Row: keep freight intact and line-of-sight the shot behind it.",
            "Do not break every crate or crate-like object in the room before this mechanic — you need cover.",
          },
          tank = {
            "Face dangerous shots so the group can LoS behind freight.",
            "Hold Zaen near intact cover without standing in the shot yourself.",
            "Call Murder in a Row so the group plants behind freight in time.",
          },
          healer = {
            "Heartstop Poison is a critical dispel — do not let it stack.",
            "Players who fail to LoS Murder in a Row take a massive hit.",
            "Stand behind freight with the group; healing from the open can get you killed.",
          },
          dps = {
            "Do not break all freight before Murder in a Row.",
            "LoS the shot. Come out only when it is safe to resume damage.",
            "Help call if cover is already destroyed.",
          },
        },
      },
      {
        name = "Xathuux the Annihilator",
        unverified = true,
        notes = {
          general = {
            "Third boss of Murder Row. No interrupt row was listed on the Orboro Season 2 sheet.",
            "UNVERIFIED: use the dungeon journal and watch for new kick targets, frontals, and soak zones. Community cheat sheets were thin at the time of writing.",
            "Play conservatively — treat large circles as soaks or dodges until your group has a confirmed plan.",
          },
          tank = {
            "Handle journal frontals and tank busters as they appear.",
            "Hold Xathuux in an open space so new zones are easy to read.",
            "Call anything that looks like a swap or a soak.",
          },
          healer = {
            "Expect heavy burst until you learn the damage pattern.",
            "Confirm dispels in the journal; do not guess on a poison or curse you have not seen.",
            "Pad when a large circle or annihilate-style cast goes out.",
          },
          dps = {
            "Stay out of clearly telegraphed zones.",
            "Kick anything the journal or your timer addon marks as interruptible.",
            "Hold a personal for surprise burst until the fight is familiar.",
          },
        },
      },
      {
        name = "Lithiel Cinderfury",
        notes = {
          general = {
            "Kick every Chaos Bolt — critical, no fallback if it lands.",
            "Assign a dedicated kick rotation just for this cast if your group is kick-light.",
            "After a missed Bolt, the targeted player needs an immediate defensive and a top.",
          },
          tank = {
            "Hold Lithiel in kick range for the whole fight.",
            "Do not drag her out of melee kick radius to dodge a minor zone.",
            "Mitigate if a Chaos Bolt is aimed at you and the kick is late.",
          },
          healer = {
            "Chaos Bolt that lands is a major hit; be ready to top the target.",
            "Pre-load a HoT on likely targets if kicks are looking late.",
            "Call for a defensive if the next Bolt has no kicker ready.",
          },
          dps = {
            "Assign a kick rotation solely around Chaos Bolt if needed.",
            "Do not spend your kick on filler when Bolt is due.",
            "If you miss, press a personal immediately.",
          },
        },
      },
    },
  },
  {
    key = "den-of-nalorakk",
    name = "Den of Nalorakk",
    short = "Nalorakk",
    kind = "dungeon",
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
          general = {
            "Dispel Toxic Spores promptly.",
            "Forceful Slam is a soak (Full Send / community). UNVERIFIED timing — be ready to help whenever the slam is telegraphed.",
            "Keep the room clear of leftover spore puddles so slams are easy to plant on.",
          },
          tank = {
            "Position so Forceful Slam soaks are easy to hit and not on top of spore puddles.",
            "Face slams or other frontals away if the journal shows a cone.",
            "Hold the Hoardmonger still for dispels and soaks.",
          },
          healer = {
            "Dispel Toxic Spores promptly.",
            "Pad the slam soak. A solo soak can spike the tank or the soak group.",
            "Watch DoT ticks if Spores are not getting dispelled in time.",
          },
          dps = {
            "Help soak Forceful Slam.",
            "Do not stand outside the soak because you wanted one more hit.",
            "Kill any extra hoard or add the journal marks, then return to the boss.",
          },
        },
      },
      {
        name = "Sentinel of Winter",
        notes = {
          general = {
            "Kick Shroud of Winter every time. Dispel Glacial Torment.",
            "Frozen Tempest: stand in the safe eye of the storm.",
            "Community tip: tank near a wall for cleave, but keep the boss off the snow or the fight may reset (hotfix-sensitive).",
          },
          tank = {
            "Hold near a wall for cleave, off the snow.",
            "Be ready to move into the Tempest eye with the group.",
            "Do not back the boss onto snow even if it is convenient for a kick.",
          },
          healer = {
            "Glacial Torment is a critical dispel.",
            "Heal through Tempest if anyone leaves the eye — that is the usual wipe.",
            "Stay in the eye yourself; do not stand out to 'get a better angle'.",
          },
          dps = {
            "Save a kick for Shroud of Winter.",
            "Stay in the eye during Frozen Tempest.",
            "Cleave from the wall position when the tank has the boss there.",
          },
        },
      },
      {
        name = "Nalorakk",
        unverified = true,
        notes = {
          general = {
            "Final boss of the den. Assign remaining kicks (Healing Breeze / Arc Lightning style casts still appear on leftover trash or adds).",
            "UNVERIFIED: confirm current journal soaks and intercepts. Fury of the War God is cited as an intercept in community notes.",
            "Play the journal's bear-god pattern conservatively until your group has a confirmed soak plan.",
          },
          tank = {
            "Handle intercepts and soaks as assigned. Face Nalorakk so the group can see incoming cones.",
            "Pick up leftover adds so kickers can reach Healing Breeze or Arc Lightning.",
            "Call Fury of the War God or any intercept so melee can help.",
          },
          healer = {
            "Plan for burst on intercepts and group hits.",
            "Pad when a called soak or intercept is late.",
            "Dispel whatever the journal lists; confirm once on a low key if you are unsure.",
          },
          dps = {
            "Help soaks and intercepts. Do not ignore assigned kicks on leftover casters.",
            "If Fury of the War God is an intercept, help catch it.",
            "Hold a personal for the final-phase burst until you know the timing.",
          },
        },
      },
    },
  },
  {
    key = "blinding-vale",
    name = "The Blinding Vale",
    short = "Blinding Vale",
    kind = "dungeon",
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
        encounterNames = { "Meittik", "Kezkitt", "Lightblossom Trinity" },
        notes = {
          general = {
            "First boss of The Blinding Vale. Wowhead overviews also name this encounter Meittik; the Orboro sheet uses Kezkitt as the kick target. This note matches all three names. The saved-note key stays 'lightblossom-trinity'.",
            "Kick Kezkitt's (or the trinity's) Light Bolt. It is a recurring high-priority kick.",
            "Soak Lightblossom Beam by stepping into the flower, not by standing in front of it.",
          },
          tank = {
            "Hold the trinity so the soak flower is easy to reach and Light Bolt kickers are in range.",
            "Do not drag the boss off the flower as a beam is going out.",
            "Face any cone away from the soak path.",
          },
          healer = {
            "Beam soaks and Light Bolt hits can spike the group — pad those windows.",
            "Players who stand in front of the flower instead of in it will take the beam wrong.",
            "Stay close enough to the flower to soak when it is your turn.",
          },
          dps = {
            "Assign a dedicated Light Bolt kick.",
            "Soak the flower correctly — step into it, not in front of it.",
            "Do not stand in an unassigned beam.",
          },
        },
      },
      {
        name = "Ikuzz the Light Hunter",
        notes = {
          general = {
            "Dispel Bloodthorn Roots or kill the roots quickly.",
            "Community: vanishing or a similar drop can shed a fixate and prevent its stack, but it does not clear the root.",
            "Do not ignore a rooted player — the next hunter mechanic often kills them.",
          },
          tank = {
            "Kite or hold as needed when fixates go out.",
            "Help collapse roots onto the boss if DPS needs a cleave target.",
            "Call fixates so the group does not drag them through the party.",
          },
          healer = {
            "Dispel roots when possible.",
            "Top fixated or rooted players; they often take a follow-up hit.",
            "If you cannot dispel, call for a root kill immediately.",
          },
          dps = {
            "Swap to roots if they are not dispelled.",
            "Do not waste a vanish-style drop expecting it to also clear the root.",
            "Help kiting fixates away from the healer.",
          },
        },
      },
      {
        name = "Lightwarden Ruia",
        notes = {
          general = {
            "Kick Warden's Wrath every time — critical, no fallback if missed.",
            "Pulverizing Strikes: spread for the locked cones and stand still once targeted.",
            "Moving after the cone is locked will clip teammates or miss your own safe lane.",
          },
          tank = {
            "Give the group space to spread for cones.",
            "Hold Ruia in kick range in the center of that space.",
            "Do not jump the boss on top of a planted cone.",
          },
          healer = {
            "Cones and a missed Warden's Wrath are the big hits.",
            "Stand still in your own cone once targeted.",
            "Pad the raid if a Wrath kick is late.",
          },
          dps = {
            "Kick Warden's Wrath. Stand still in your cone.",
            "Spread early so cones do not overlap.",
            "Do not chase the boss through someone else's cone.",
          },
        },
      },
      {
        name = "Ziekket",
        notes = {
          general = {
            "Kick Lightspore Shot every cast.",
            "This is the final Blinding Vale boss — leftover Lightgorged Lasher shields on the approach still heal nearby enemies and should be focused if they are in the pull.",
            "After a missed Lightspore Shot, top the hit player immediately.",
          },
          tank = {
            "Hold Ziekket in kick range.",
            "Face any frontals away from the group.",
            "Call if you have to move out of kick radius.",
          },
          healer = {
            "Top the group if Lightspore Shot lands.",
            "Watch for leftover shield or spore damage from the approach.",
            "Stay in range of the kick stack.",
          },
          dps = {
            "Do not let Lightspore Shot finish.",
            "Kill leftover shielded lashers if they are still up, then return to Ziekket.",
            "Hold a personal if a Shot is going to land.",
          },
        },
      },
    },
  },
  {
    key = "voidscar-arena",
    name = "Voidscar Arena",
    short = "Voidscar",
    kind = "dungeon",
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
        unverified = true,
        notes = {
          general = {
            "First Voidscar Arena boss. UNVERIFIED: public M+ sheets were thin on this encounter specifically.",
            "Use the dungeon journal plus leftover trash kick rules on the approach (Demoralizing Shout, Shadowbolt Volley, Mad Shriek, Mending Void).",
            "Dodge clearly telegraphed zones and kick anything interruptible until your group has a confirmed plan.",
          },
          tank = {
            "Control positioning so group kicks can reach Taz'Rah and any leftover casters.",
            "Face frontals away.",
            "Pick up arena adds immediately.",
          },
          healer = {
            "Watch for group casts that escape the kick rotation.",
            "Pad until you know the damage pattern.",
            "Dispel whatever the journal lists once you have seen it once.",
          },
          dps = {
            "Keep kicking high-priority trash habits if those mobs are part of the pull.",
            "Stay out of telegraphed zones.",
            "Call new interruptible casts so the rotation can add them.",
          },
        },
      },
      {
        name = "Atroxus",
        notes = {
          general = {
            "Dispel Mind-Numbing Poison only after a failed mechanic (situational). Do not pre-dispel it.",
            "Do the mechanic correctly so the poison never needs a dispel and the healer can use that GCD elsewhere.",
            "Watch the journal for the associated failed-mechanic trigger if this is your first time.",
          },
          tank = {
            "Call when the associated mechanic is failed so the dispel happens.",
            "Hold Atroxus still enough that the group can see the mechanic tell.",
            "Face frontals away.",
          },
          healer = {
            "Do not pre-dispel Mind-Numbing Poison; wait for a failed mechanic.",
            "If nobody failed it, spend the GCD on healing instead.",
            "Be ready for a spike when a fail plus the poison overlap.",
          },
          dps = {
            "Do the mechanic so the poison does not need a dispel.",
            "Dodge and soak as assigned; a fail is what triggers the expensive dispel.",
            "Help call a fail immediately.",
          },
        },
      },
      {
        name = "Charonus",
        notes = {
          general = {
            "Gravitic Orbs: kite fixating orbs into an Unstable Singularity.",
            "The final targeted projectile sequence is a dodge, not a tank soak (Orboro / community, corroborated).",
            "A projectile eaten by the group, or an orb that never reaches a singularity, is the usual wipe.",
          },
          tank = {
            "Do not try to soak the targeted projectile sequence.",
            "Help herd orbs toward a singularity if a kiter is struggling.",
            "Hold Charonus in a place that leaves orb paths open.",
          },
          healer = {
            "Movement-heavy phase; keep people up through orb and projectile mistakes.",
            "Do not stand still to finish a cast if a projectile is targeted on you.",
            "Pad when several orbs are being kited at once.",
          },
          dps = {
            "Kite orbs into the singularity. Dodge projectiles away from the group.",
            "Do not bring a fixate through the melee stack.",
            "If you are targeted by the projectile sequence, move it out — do not stand on the tank.",
          },
        },
      },
    },
  },

  {
    key = "magisters-terrace",
    name = "Magisters' Terrace",
    short = "Magisters",
    kind = "dungeon",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Magisters' Terrace", "Magister's Terrace" },
    kicks = {
    },
    extras = {
      "Not in the current Season 2 Mythic+ pool — no Orboro interrupt sheet. Use the dungeon journal for kicks.",
      "Condensed from Method / Wowhead overviews (November 2026). Some timings may have been hotfixed.",
    },
    bosses = {
      {
        name = "Arcanotron Custos",
        encounterNames = { "Arcanotron Custos", "Arcanotron" },
        notes = {
          general = {
            "Spread Arcanotron's puddles so they do not stack under the group.",
            "Dispel shackles when they land.",
            "Intercept orbs before they reach the boss or their target, per the journal.",
          },
          tank = {
            "Hold Arcanotron in an open space so puddles can be dropped in a line, not a pile.",
            "Face any cone away from the intercept path.",
            "Call orbs if the group misses them.",
          },
          healer = {
            "Dispel shackles quickly.",
            "Puddle and orb mistakes spike the group — pad those windows.",
            "Do not stand in puddles to finish a cast.",
          },
          dps = {
            "Spread puddles. Intercept orbs.",
            "Help with shackles if you have a purge or a freedom for the shacked player.",
            "Come back to the boss as soon as the orb is handled.",
          },
        },
      },
      {
        name = "Seranel Sunlash",
        encounterNames = { "Seranel Sunlash", "Seranel" },
        notes = {
          general = {
            "Players with Runic Mark need to clear it in the Suppression Zone.",
            "Do not sit on a Mark outside the zone — it will punish the group.",
            "UNVERIFIED vs later hotfixes of the zone location or clear timing.",
          },
          tank = {
            "Hold Seranel so the Suppression Zone is a short run for marked players.",
            "Do not drag the boss into the zone if that would hide it from the group.",
            "Face frontals away from the zone entrance.",
          },
          healer = {
            "Marked players who are late to the zone will spike — top them and call them in.",
            "Stay close enough to cover both the boss and the zone.",
            "Dispel anything the journal lists once you have seen it.",
          },
          dps = {
            "If you have Runic Mark, run to the Suppression Zone and clear it immediately.",
            "Do not ignore a Mark to finish a cast.",
            "Help call unmarked players who are standing in the zone and blocking it.",
          },
        },
      },
      {
        name = "Gemellus",
        notes = {
          general = {
            "Kill Gemellus's clones. They split damage and can overwhelm the group if left up.",
            "Touch or run to linked players when the link is out, per the journal, so the link does not tick the raid down.",
            "UNVERIFIED exact link range and clone health; confirm once in the journal.",
          },
          tank = {
            "Pick up clones immediately and collapse them onto Gemellus for cleave.",
            "Hold the pack so linked players can touch without running through frontals.",
            "Call a clone that is still loose.",
          },
          healer = {
            "Links and leftover clones are the damage check.",
            "If a link is not broken, both players will need heavy healing.",
            "Stay in range of linked partners.",
          },
          dps = {
            "Swap to clones and cleave them down.",
            "If you are linked, touch your partner immediately.",
            "Do not tunnel Gemellus while a clone is still at full health.",
          },
        },
      },
      {
        name = "Degentrius",
        notes = {
          general = {
            "Final Magisters' Terrace boss. Split the group for Void Torrent so it does not hit the whole party.",
            "Soak essences as assigned.",
            "UNVERIFIED split counts and essence timers — confirm in the journal for your key or difficulty.",
          },
          tank = {
            "Hold Degentrius so both Torrent groups have space.",
            "Face any frontal away from both soak camps.",
            "Help soak an essence if the plan includes the tank.",
          },
          healer = {
            "Torrent and missed essences are the raid checks. Pad those windows.",
            "Know which split you belong to and be there before Torrent fires.",
            "Top soakers who took more than one essence.",
          },
          dps = {
            "Go to your assigned Void Torrent side. Soak essences as assigned.",
            "Do not stand mid and clip both groups.",
            "Hold a personal if you soak a late essence.",
          },
        },
      },
    },
  },
  {
    key = "windrunner-spire",
    name = "Windrunner Spire",
    short = "Spire",
    kind = "dungeon",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Windrunner Spire" },
    kicks = {
    },
    extras = {
      "Not in the current Season 2 Mythic+ pool — no Orboro interrupt sheet. Use the dungeon journal for kicks.",
      "Interrupt Kalis's Shriek and Latch's Yank on the Derelict Duo. Condensed from Wowhead / Method overviews.",
    },
    bosses = {
      {
        name = "Emberdawn",
        notes = {
          general = {
            "Avoid Emberdawn's updrafts and gales. They will knock you off a platform or into fire.",
            "Keep your back to solid ground when a knock goes out.",
            "UNVERIFIED vs later retunes of knock distance.",
          },
          tank = {
            "Hold Emberdawn away from the platform edge.",
            "Face any gale or frontal into a safe direction, not off the spire.",
            "Call updrafts so melee can plant.",
          },
          healer = {
            "Players who eat a gale or updraft will spike or fall — be ready to top or battle-rez.",
            "Do not stand on a lip to get a better angle.",
            "Pad when several winds overlap.",
          },
          dps = {
            "Avoid updrafts and gales. Stop a cast if you need to move.",
            "Keep your back to solid ground.",
            "Do not stand on the edge for 'one more hit'.",
          },
        },
      },
      {
        name = "Derelict Duo",
        encounterNames = { "Kalis", "Latch", "Derelict Duo", "Kalis and Latch" },
        notes = {
          general = {
            "Kalis and Latch. Interrupt Kalis's Shriek and Latch's Yank — these are the key stops.",
            "Keep damage reasonably even if the journal still punishes a health gap (confirm in the journal).",
            "UNVERIFIED exact health-link; kick the two named casts first.",
          },
          tank = {
            "Hold both so kickers can reach Shriek and Yank.",
            "Face frontals away. Collapse them for cleave if the plan allows.",
            "Call if one runs out of kick range.",
          },
          healer = {
            "A missed Shriek or Yank is the spike. Pad those windows.",
            "Dispel whatever lands after a missed kick.",
            "Watch both health bars if they need to stay even.",
          },
          dps = {
            "Kick Kalis's Shriek and Latch's Yank every time.",
            "Cleave both if they can be stacked; otherwise follow the assigned target.",
            "Do not let either cast finish because you were tunneling the other.",
          },
        },
      },
      {
        name = "Commander Kroluk",
        encounterNames = { "Commander Kroluk", "Kroluk" },
        notes = {
          general = {
            "Kill Kroluk's summoned warparty. The adds are the fight — leftover soldiers will overwhelm the group.",
            "Cleave back onto Kroluk only when the current wave is dead or assigned to a tank.",
            "UNVERIFIED wave timing; use the journal and your timer addon.",
          },
          tank = {
            "Pick up the warparty immediately and collapse it onto Kroluk for cleave.",
            "Face Kroluk's frontals away from the add pile if they are dangerous.",
            "Call a loose add.",
          },
          healer = {
            "Add waves plus boss damage are the check. Pad when a new warparty spawns.",
            "Players who get stuck on a loose add will spike.",
            "Stay in range of both the boss and the add pile.",
          },
          dps = {
            "Swap to the warparty and kill it, then return to Kroluk.",
            "Help with kicks or stuns on dangerous add casts if the journal lists any.",
            "Do not ignore a leftover soldier.",
          },
        },
      },
      {
        name = "The Restless Heart",
        encounterNames = { "The Restless Heart", "Restless Heart" },
        notes = {
          general = {
            "Avoid the Restless Heart's expanding wind rings. Step out as they grow; do not stand in the previous ring.",
            "This is a movement check more than a kick check. Leftover rings will fill the platform.",
            "UNVERIFIED ring count and speed — confirm in the journal.",
          },
          tank = {
            "Hold the Heart in the center or as assigned so rings expand predictably.",
            "Move the boss only between ring waves, not through a new ring.",
            "Face any frontal away.",
          },
          healer = {
            "Ring hits spike and can knock. Pad when several rings overlap a messy group.",
            "Stand in a safe gap yourself.",
            "Top players who get clipped at the edge of a ring.",
          },
          dps = {
            "Step out of expanding wind rings. Do not finish a cast inside a growing ring.",
            "Stay evenly around the boss so the group does not all stack in one shrinking gap.",
            "Hold a personal if you get clipped.",
          },
        },
      },
    },
  },
  {
    key = "maisara-caverns",
    name = "Maisara Caverns",
    short = "Maisara",
    kind = "dungeon",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Maisara Caverns" },
    kicks = {
    },
    extras = {
      "Not in the current Season 2 Mythic+ pool — no Orboro interrupt sheet. Use the dungeon journal for kicks.",
      "Condensed from Method / Wowhead overviews (November 2026).",
    },
    bosses = {
      {
        name = "Muro'jin and Nekraxx",
        encounterNames = { "Muro'jin", "Nekraxx", "Muro'jin and Nekraxx" },
        notes = {
          general = {
            "Kill Muro'jin and Nekraxx together. A large health gap usually empowers the survivor.",
            "Cleave both and assign a swap if one pulls ahead.",
            "UNVERIFIED exact link or enrage threshold — keep them within a close percent.",
          },
          tank = {
            "Hold both in a cleave stack if the plan allows, or split only as assigned.",
            "Face frontals away from each other and from the group.",
            "Call if one is running away and breaking the even-damage plan.",
          },
          healer = {
            "Damage ramps if one boss is left low while the other is healthy — pad that window and call the DPS swap.",
            "Watch both tanks if the bosses are split.",
            "Dispel whatever the journal lists.",
          },
          dps = {
            "Cleave both. If one is ahead, swap until they are even again.",
            "Do not tunnel your favorite target into a gap.",
            "Dodge each boss's zones; they can overlap when stacked.",
          },
        },
      },
      {
        name = "Vordaza",
        notes = {
          general = {
            "Kite Vordaza's phantoms into each other so they collapse or die, per the Method / Wowhead overview.",
            "Do not leave phantoms chasing individual players around the cavern.",
            "UNVERIFIED exact collapse range — drag them through one another until they break.",
          },
          tank = {
            "Hold Vordaza in a place that leaves room to kite phantoms through each other.",
            "Help intercept a phantom if a kiter is stuck.",
            "Face frontals away from the kite path.",
          },
          healer = {
            "Loose phantoms chewing on a player will spike them. Call for a kite, then top that player.",
            "Do not stand still if a phantom is on you — move it into another.",
            "Pad when several phantoms are up.",
          },
          dps = {
            "Kite phantoms into each other. That is the mechanic, not ignoring them for boss damage.",
            "Help collapse a stuck phantom.",
            "Return to Vordaza once the pair has collided.",
          },
        },
      },
      {
        name = "Rak'tul Vessel of Souls",
        encounterNames = { "Rak'tul", "Rak'tul Vessel of Souls", "Vessel of Souls" },
        notes = {
          general = {
            "Avoid Rak'tul's totems and the bridge gauntlet on the way. Totems usually need to be killed, kited, or stood out of.",
            "The bridge is a movement and add check — do not pull the boss into leftover gauntlet packs.",
            "UNVERIFIED exact totem effects; use the journal for whether they are kill or avoid.",
          },
          tank = {
            "Hold Rak'tul off the narrow bridge if you can, so the group has space to drop totems.",
            "Pick up leftover gauntlet adds before they reach the healer.",
            "Face frontals away from the bridge lip.",
          },
          healer = {
            "Bridge and totem mistakes spike the group. Pad those windows.",
            "Stay off the lip. Top players who stand in a totem.",
            "Watch the tank if adds from the gauntlet are still up.",
          },
          dps = {
            "Handle totems as the journal requires (kill or drop them out of the group).",
            "Do not fight on the bridge if the room beyond is open.",
            "Help clear leftover gauntlet adds, then return to Rak'tul.",
          },
        },
      },
    },
  },
  {
    key = "nexus-point-xenas",
    name = "Nexus-Point Xenas",
    short = "Xenas",
    kind = "dungeon",
    instanceIDs = {}, -- UNVERIFIED
    nameMatches = { "Nexus-Point Xenas", "Nexus Point Xenas" },
    kicks = {
    },
    extras = {
      "Not in the current Season 2 Mythic+ pool — no Orboro interrupt sheet. Use the dungeon journal for kicks.",
      "Condensed from Wowhead / Method overviews (November 2026). Some image / flare details are UNVERIFIED vs the current journal.",
    },
    bosses = {
      {
        name = "Chief Corewright Kasreth",
        encounterNames = { "Chief Corewright Kasreth", "Kasreth", "Corewright Kasreth" },
        notes = {
          general = {
            "Avoid Kasreth's detonations. Move out of the blast circles before they expire.",
            "Do not drop a detonation on the group or on leftover fire.",
            "UNVERIFIED exact fuse time — leave early rather than late.",
          },
          tank = {
            "Hold Kasreth in an open core or platform so detonations have a place to be dropped.",
            "Move the boss out of a planted detonation.",
            "Face frontals away from the group.",
          },
          healer = {
            "Detonation hits are the spike. Pad if several go off together.",
            "Do not stand in a circle to finish a heal.",
            "Top players who drop a detonation late.",
          },
          dps = {
            "Leave detonation circles immediately.",
            "Drop yours at the edge, not under melee.",
            "Hold a personal if you are still inside when it is about to blow.",
          },
        },
      },
      {
        name = "Corewarden Nysarra",
        encounterNames = { "Corewarden Nysarra", "Nysarra" },
        notes = {
          general = {
            "Avoid Nysarra's flares. They usually leave lingering fire or a blind — do not stand in them and do not bait them through the group.",
            "Move Nysarra (or yourself) out of lingering flares between waves.",
            "UNVERIFIED exact flare count and duration.",
          },
          tank = {
            "Hold Nysarra so flares can be dropped in already-burned space.",
            "Drag her out of a flare that lands on her hitbox.",
            "Face any beam or frontal away.",
          },
          healer = {
            "Flare hits and lingering fire spike the group. Pad those windows.",
            "Do not plant in a flare to finish a cast.",
            "Top players who get blinded or burned.",
          },
          dps = {
            "Dodge flares and do not bait them through melee.",
            "Move out of lingering fire.",
            "Hold a personal if a flare clips you.",
          },
        },
      },
      {
        name = "Lothraxion",
        unverified = true,
        notes = {
          general = {
            "Final Nexus-Point Xenas boss. Handle Lothraxion's image mechanics — images usually need to be killed, soaks, or avoided so the real boss cannot copy them.",
            "Wowhead overviews were thin on the exact image script. UNVERIFIED: use the dungeon journal for whether images are burn, ignore, or soak.",
            "Do not attack or stand in the wrong image if the journal marks a fake.",
          },
          tank = {
            "Pick up images that are attackable. Hold Lothraxion in a place that makes real versus fake obvious.",
            "Call the real target if images scatter.",
            "Face frontals away from image soaks.",
          },
          healer = {
            "Image waves plus boss damage are the check. Pad when images spawn.",
            "Players who hit or stand in the wrong image will spike.",
            "Stay where you can see both Lothraxion and the images.",
          },
          dps = {
            "Follow the journal: burn, ignore, or soak images as assigned.",
            "Do not tunnel Lothraxion through a wave that must be killed.",
            "If an image is a fake, leave it and call it.",
          },
        },
      },
    },
  },
  {
    key = "ruby-life-pools",
    name = "Ruby Life Pools",
    short = "RLP",
    kind = "dungeon",
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
          general = {
            "Kick Frigid Shard when she is not shielded; break Frost Overload otherwise. Frigid Shard is a tank hit if it lands.",
            "Chillstorm: avoid the center pull and do not get knocked into Hailbombs.",
            "Dispel Cold Claws from the whelps / afflicted players.",
          },
          tank = {
            "Mitigate Frigid Shard if a kick is late.",
            "Hold Melidrussa so the group can break Frost Overload without standing in Hailbombs.",
            "Be ready to move out of the Chillstorm center.",
          },
          healer = {
            "Dispel Cold Claws from whelps or players.",
            "Hailbomb hits are the wipe risk — top anyone knocked into them.",
            "Pad Chillstorm if people get pulled early.",
          },
          dps = {
            "Kick Frigid Shard. Break the Frost Overload shield.",
            "Stay out of Hailbombs and out of the Chillstorm center.",
            "Cleave whelps if they are up, then return to the boss.",
          },
        },
      },
      {
        name = "Kokia Blazehoof",
        notes = {
          general = {
            "Kick Blaze Volley on summoned Blazebound Firestorms and kill them quickly.",
            "Searing Blows is a repeated tank hit — the tank should plan a defensive.",
            "Living Bomb circles no longer damage enemies in Season 2 — keep them off the group, not on the boss, for damage.",
          },
          tank = {
            "Defensive for Searing Blows. Help point Firestorms so kickers can reach them.",
            "Do not drag Kokia through Living Bomb circles.",
            "Pick up Firestorms immediately.",
          },
          healer = {
            "Support the tank through Searing Blows.",
            "A Blaze Volley that goes off is a raid spike.",
            "Keep Living Bomb circles off the group.",
          },
          dps = {
            "Swap to Firestorms and kick Blaze Volley.",
            "Do not drop Living Bombs on the melee stack.",
            "Return to Kokia as soon as the add is dead.",
          },
        },
      },
      {
        name = "Erkhart Stormvein",
        notes = {
          general = {
            "Dispel Stormslam (critical) — it is a tank hit plus a dispel.",
            "Handle wind and lightning room mechanics from the journal (gusts, safe lanes, and storm zones).",
            "Purge or soothe Stormcloud Barrier when it is up.",
          },
          tank = {
            "Mitigate Stormslam and call for the dispel.",
            "Move Erkhart into safe wind lanes so the group is not fighting in lightning.",
            "Watch for a knock that would put you in a storm.",
          },
          healer = {
            "Stormslam is a critical dispel and a tank defensive check.",
            "Players clipped by wind or lightning spike — pad those windows.",
            "Stay in the safe lane yourself.",
          },
          dps = {
            "Avoid storms and help with any assigned soaks.",
            "Purge Stormcloud Barrier if you can.",
            "Do not stand in a gust just to finish a cast.",
          },
        },
      },
    },
  },
  {
    key = "kings-rest",
    name = "Kings' Rest",
    short = "KR",
    kind = "dungeon",
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
          general = {
            "First boss of Kings' Rest. Spits gold / anima that should not sit on the group; move the boss out of puddles.",
            "Watch journal winds and soaks. Adds or orbs (if present this season) should be handled before they reach the boss.",
            "UNVERIFIED vs any Season 2 retune of the original Battle for Azeroth script.",
          },
          tank = {
            "Face and move the serpent out of gold puddles and wind lanes.",
            "Pick up any adds immediately.",
            "Give the group a clean path around the room.",
          },
          healer = {
            "Heal through periodic group hits and puddle mistakes.",
            "Players standing in gold or winds will spike.",
            "Stay out of the spit yourself.",
          },
          dps = {
            "Dodge winds and puddles; keep priority damage on the boss.",
            "Swap to adds or orbs if they spawn.",
            "Do not stand in front of the serpent.",
          },
        },
      },
      {
        name = "Mchimba the Embalmer",
        notes = {
          general = {
            "Constructs Entomb victims into the nearest coffin — stack beside one coffin for a fast breakout.",
            "Mchimba's own Entomb still chooses a random coffin. Be ready to swap coffins.",
            "Dispel Lingering Fluid / Putrid Seekers from fluids. Kick Wretched Discharge on Half-Finished Mummies if they are up.",
          },
          tank = {
            "Hold Mchimba so the assigned coffin is close, but be ready for his random Entomb.",
            "Do not drag him so far that the nearest construct coffin is across the room.",
            "Pick up mummies.",
          },
          healer = {
            "Top entombed players as they are broken out.",
            "Dispel fluids when they apply Lingering Fluid or similar DoTs.",
            "A slow breakout is a death — call the coffin if DPS is late.",
          },
          dps = {
            "Break the correct coffin immediately.",
            "Stack at the agreed coffin for construct Entombs.",
            "Kick mummies and return to the coffin if someone is entombed.",
          },
        },
      },
      {
        name = "The Council of Tribes",
        notes = {
          general = {
            "Kick Zanazal's Poison Nova (large group-wide poison). Kick Reban's Deathly Roar (group fear).",
            "Dispel T'zala's Savage Maul (critical tank debuff).",
            "Destroy Healing Tide Totems immediately. The council is a kick-and-dispel check more than a movement check.",
          },
          tank = {
            "Call Savage Maul for a dispel. Face Reban away if needed.",
            "Hold the active council member in kick range.",
            "Move the pack off a Healing Tide Totem so DPS can kill it.",
          },
          healer = {
            "Savage Maul is a critical dispel. Fear and Poison Nova are the wipe checks.",
            "Be ready to mass-dispel or top after a missed Nova.",
            "Stand where you will not be feared into leftover zones.",
          },
          dps = {
            "Assign kicks to Zanazal and Reban. Do not let Deathly Roar or Poison Nova finish.",
            "Kill Healing Tide Totems instantly.",
            "Help with any assigned soaks when a council member is active.",
          },
        },
      },
      {
        name = "King Dazar",
        notes = {
          general = {
            "Dazar leaps to the farthest player first. Keep the room clean of leftover totems and adds.",
            "Do not be the farthest player unless you are assigned to bait the first leap.",
            "Community: a well-timed target-drop while he is airborne may cancel remaining jumps (hotfix-sensitive, UNVERIFIED if it still works in Season 2).",
          },
          tank = {
            "Handle the leap and blade mechanics from the journal.",
            "Pick Dazar up immediately after each leap.",
            "Keep him in an open space so leap targets have a path.",
          },
          healer = {
            "Leaps and ramps of damage are the check — pad the leap target and the landing zone.",
            "Stay mid-range so you are not accidentally farthest.",
            "Watch the tank after a blade or slam.",
          },
          dps = {
            "Do not stand farthest unless you are assigned to bait the first leap.",
            "Kill leftover totems and adds before they clutter the leap path.",
            "Move in after a leap so the next jump does not go to the healer.",
          },
        },
      },
    },
  },
  {
    key = "temple-of-sethraliss",
    name = "Temple of Sethraliss",
    short = "Sethraliss",
    kind = "dungeon",
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
          general = {
            "One boss is usually shielded by lightning or gale while the other is vulnerable — attack the unshielded one and be ready to swap.",
            "Side-step gusts and lightning. When they share energy or charge up, follow the journal's stack or spread call.",
            "UNVERIFIED vs any Season 2 retune of the original Battle for Azeroth script.",
          },
          tank = {
            "Separate or stack as the assigned plan requires when they charge up.",
            "Face each boss so gusts and lightning do not cut the group.",
            "Taunt or swap when the shield moves.",
          },
          healer = {
            "Damage spikes when a charge, gale, or lightning goes off.",
            "Stay out of gusts. Pad the swap window if the group clipped a shield.",
            "Watch both tanks if the bosses are split.",
          },
          dps = {
            "Stop DPS on the shielded boss and swap to the vulnerable one.",
            "Side-step gusts; do not tunnel during a charge.",
            "Kick leftover trash habits on the way in only — this is a two-target swap fight.",
          },
        },
      },
      {
        name = "Merektha",
        notes = {
          general = {
            "Kick Poison Spit; cleanse the poison if a kick is missed.",
            "A Knot of Snakes: CC the snakes immediately to free the stunned player.",
            "Do not let a knotted player sit — the next spit or puddle often kills them.",
          },
          tank = {
            "Face Merektha so spits and pulls are predictable.",
            "Move the boss out of poison puddles.",
            "Help CC or collapse snakes if you have a stun.",
          },
          healer = {
            "Cleanse Poison Spit if a kick is missed. Top the snared or knotted player.",
            "Be ready to follow a player who is being pulled.",
            "Stay out of spit puddles yourself.",
          },
          dps = {
            "Kick Poison Spit. CC snakes immediately.",
            "Do not ignore a Knot of Snakes to finish a cast.",
            "Move out of puddles as the tank repositions.",
          },
        },
      },
      {
        name = "Galvazzt",
        notes = {
          general = {
            "Soak Galvazzt's beams so the boss does not overcharge. Usually a small assigned soak group; leftover energy on the boss is a wipe.",
            "Dodge beams you are not assigned to soak.",
            "UNVERIFIED vs any Season 2 retune of soak counts or beam timing.",
          },
          tank = {
            "Move Galvazzt so beam soaks are convenient and not on top of leftover zones.",
            "Call if the boss is getting close to an overcharge.",
            "Face any leftover frontal away.",
          },
          healer = {
            "Beam mistakes cause heavy group damage. Pad soak windows.",
            "Top players who soaked more than their share.",
            "Stay available to soak if the plan needs a healer in the group.",
          },
          dps = {
            "Soak or avoid beams as assigned.",
            "If a soak is short, help rather than letting the boss overcharge.",
            "Do not stand in an unassigned beam to 'help' if the soak is already full.",
          },
        },
      },
      {
        name = "Avatar of Sethraliss",
        notes = {
          general = {
            "After the guardian dies, DPS soak the purple Corrupted Lifeforce zones; the soak changes healing and physical damage taken.",
            "Kick Essence Disruption (especially while carrying the Eye) and Flame Shock on the approach and during the gauntlet.",
            "The Avatar itself is a race plus a soak check — leftover zones that are not soaked stall the heal.",
          },
          tank = {
            "Pick up remaining enemies around the Avatar.",
            "Hold them off the soakers and off the healer.",
            "Help soak only if the plan says tanks also soak.",
          },
          healer = {
            "Healing is affected by Corrupted Lifeforce soaks — watch who soaked and adjust.",
            "The group will take more physical damage after certain soaks; pad those players.",
            "Stay safe during the gauntlet; a dead healer ends the race.",
          },
          dps = {
            "Soak purple zones after the guardian dies.",
            "Keep kicking Disruptors and Hexers on the approach.",
            "Do not ignore a zone because you wanted more boss damage — the Avatar needs those soaks.",
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
