Alt Vault Checklist 2.1.0
=========================
A public testing build of an account-wide World of Warcraft retail addon
for Midnight Season 2 (Interface 120105, patch 12.1.5).

Log in on a character and the addon records them automatically: class,
spec, item level, current Mythic keystone, weekly best, M+ rating, Great
Vault progress, and a recommended BiS / gearing list for that spec. Switch
specs (or log another alt) and it updates.


Install
-------
1. Quit World of Warcraft if it is running.
2. Copy the AltVaultChecklist folder into:

     World of Warcraft\_retail_\Interface\AddOns\

   You should have:

     Interface\AddOns\AltVaultChecklist\AltVaultChecklist.toc

3. At the character-select screen, open the AddOn list and enable
   "Alt Vault Checklist".
4. If you installed it while already in the game, type /reload.

No other addon is required. Saved data is stored account-wide as
AltVaultChecklistDB (WTH account, this install only — it is not synced
across computers).


Slash commands
--------------
  /altcheck           Open or close the window
  /avc                Same as /altcheck
  /altvault           Same as /altcheck
  /altcheck keys      Open the Party Keys tab
  /altcheck help      Print a short in-game help summary
  /altcheck scan      Rescan the character you are on
  /altcheck minimap   Show the minimap button if you hid it
  /altcheck resetpos  Reset the window to the center of the screen

There is also a minimap button (drag to move, right-click to hide) and an
entry in the retail Addon Compartment menu. A Help button in the window
prints the same command list to chat.


How to use it
-------------
Play each alt once so the addon can scan bags, equipped gear, the key, and
the vault. The top of the window is a table of those characters:

  name, item level, current key, weekly best, M+ rating,
  Great Vault dungeon / raid / world-delve slots (level and reward item
  level when the API provides them), and whether a vault reward is unclaimed.

Click a row for that character's Weekly and Gear / BiS tabs. The Party
Keys tab (or /altcheck keys) shows your current 5-player party's keys.


Checkboxes
  Left-click to set a manual override.
  Right-click to clear the override and return to automatic tracking.

Weekly tab
  Defaults: vault M+ 1/4/8, raid slots, world/delve slots, and weekly
  profession quests. Vault rows fill in from C_WeeklyRewards.GetActivities
  when you log in on that character. Profession quests are manual.
  Add your own weekly items at the bottom; remove custom rows with the X.

Gear / BiS tab
  One row per recommended slot: item name, source, whether you have it
  equipped or in bags, your item level versus the season target, and a
  checkbox. Catalyst / tier-set targets are noted. After you catalyze, the
  resulting tier piece may use a different item ID — if the box does not
  auto-tick, check it manually.

Party Keys tab
  Lists each member of your current party (up to 5): name (class-colored),
  role icon, item level, M+ rating, and their Mythic keystone (dungeon and
  level). The highest key in the group is highlighted.
  Your own key comes from C_MythicPlus.GetOwnedKeystoneChallengeMapID /
  GetOwnedKeystoneLevel. Other players' keys are shared only if they also
  have Alt Vault Checklist 2.1 or later (addon prefix AVCKEYS). Friends
  without the addon show as "no addon" and their key as "unknown".
  If a member is running Astral Keys and that addon broadcasts a simple
  updateV8 message the board can read, their key may still appear and the
  source column will say "Astral Keys". Details! / LibOpenRaid messages
  are not parsed (they are compressed and not a safe, simple format).
  Item level for members who are not sharing it is requested with
  NotifyInspect, throttled, and only while you are out of combat.
  "Post keys to party" sends one summary to party chat, and only when
  you click the button. Refresh re-requests keys and inspects.

Hide or remove an alt
  On the detail pane: Hide (keeps data, hides the row; use "Show hidden"
  or Unhide to bring it back) and Remove (deletes stored data for that
  character). Remove asks you to click Confirm. Logging in on a removed
  character will register them again. The character you are currently
  playing always stays visible in the table.


Spec coverage (Midnight Season 2 / 12.1.5)
------------------------------------------
BiS lists are bundled for all 40 live retail specializations, including
Devourer Demon Hunter (spec ID 1480). Lists are keyed by spec ID so they
still load on non-English clients.

  Death Knight    Blood, Frost, Unholy
  Demon Hunter    Devourer, Havoc, Vengeance
  Druid           Balance, Feral, Guardian, Restoration
  Evoker          Augmentation, Devastation, Preservation
  Hunter          Beast Mastery, Marksmanship, Survival
  Mage            Arcane, Fire, Frost
  Monk            Brewmaster, Mistweaver, Windwalker
  Paladin         Holy, Protection, Retribution
  Priest          Discipline, Holy, Shadow
  Rogue           Assassination, Outlaw, Subtlety
  Shaman          Elemental, Enhancement, Restoration
  Warlock         Affliction, Demonology, Destruction
  Warrior         Arms, Fury, Protection

If a future spec has no list, key / vault / rating / weekly tracking still
work; the Gear tab will say that no list is bundled.


How the BiS lists were built
----------------------------
Compiled 2026-11-12.

  - Slot lists come from each spec's Method.gg overall Best-in-Slot table
    for Midnight Season 2 / 12.1.5.
  - The hero talent noted on each list is the most popular tree in
    MaxWoW's top-50 Mythic+ sample for that spec (week of 2026-11-12).
    Evoker pages on MaxWoW did not include a hydrated hero name, so those
    three use Method's published M+ talent recommendation instead:
      Augmentation  Chronowarden (high keys / raid)
      Devastation   Scalecommander
      Preservation  Flameshaper
  - Close M+ samples (called out in the in-game list notes):
      Devourer Demon Hunter  Annihilator 26/50
      Frost Mage             Frostfire 26/50
      Assassination Rogue    Fatebound 26/50
  - Every numeric item ID was verified against the Wowhead tooltip API
    (nether.wowhead.com/tooltip/item/<id>?dataEnv=1&locale=0). Display
    names are the tooltip-verified names. No item ID was invented.
  - Feral Druid: Method leaves four slots as "Any 334". Those rows have
    no item ID on purpose; the addon ticks them if the equipped piece is
    item level 334 or higher.
  - Outlaw Rogue chest (Chosen Bloodslayer's Banded Poncho) had no Method
    wowhead link; the ID 271513 was confirmed on Wowhead and then verified
    with the tooltip API.
  - Target item levels: 344 for Mythic raid-track pieces, 331 for crafted
    pieces (season goals, not guarantees).

Sim your own character (Raidbots) before spending crests or sparks. Lists
change during a season and should be re-checked after a major loot or
balance patch.


Caveats
-------
- Great Vault column labels are resolved from
  Enum.WeeklyRewardChestThresholdType when it exists, with a numeric
  fallback from current warcraft.wiki.gg documentation. If a column looks
  swapped after a patch, please report it.
- Vault reward item levels come from C_WeeklyRewards.GetItemHyperlink or
  GetExampleRewardItemHyperlinks and may be examples, or missing until
  the vault has generated rewards.
- The current key is only accurate on the character that holds it.
- Item matching is by item ID (plus listed alternates). Bonus IDs and
  upgrade track are not part of the match; owned item level is shown next
  to the target instead.
- Catalyzed tier pieces may use a different item ID than the catalyst
  source listed in the Method table.
- US weekly reset is Tuesday 15:00 UTC (10:00 AM America/New_York while
  EST). The countdown uses C_DateAndTime.GetSecondsUntilWeeklyReset for
  your region. Weekly best, vault progress, key, and weekly checkboxes
  clear at reset; gear ownership and manual gear checks are kept.
- Party key sharing needs the other player to have this addon (or a
  simple Astral Keys broadcast the board can read). It does not automate
  gameplay, and it never posts keys to chat unless you click the button.
- The addon does not buy, craft, queue, or automate anything.


How to report bugs
------------------
When you report a problem, please include:

  1. Addon version (2.1.0) and game build / patch, if you know it.
  2. What you were doing (/altcheck, logging in, swapping specs, etc.).
  3. Character class, spec, and (if relevant) hero talent.
  4. What you expected, and what happened instead.
  5. Any Lua errors (BugGrabber / !BugSack text, or the red error popup).
  6. For a wrong or missing BiS row: item name, slot, and item ID if you
     have one. Please do not send account credentials or screenshots of
     real payment information.

Known limitations worth checking before you file a bug are listed under
Caveats above.


Files
-----
  AltVaultChecklist.toc   Load order, Interface 120105, SavedVariables
  Core.lua                SavedVariables, events, slash, minimap, compartment
  GearData.lua            Weekly defaults and all-spec BiS lists
  Collector.lua           Key, vault, rating, and bag/equip scans
  PartyKeys.lua           Party key sharing (AVCKEYS) and inspect
  UI.lua                  Movable window, including the Party Keys tab
  README.txt              This file
