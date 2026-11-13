Kardgaz's Kick & Boss Notes  v1.2.0
===================================

Display-only World of Warcraft addon for Midnight (patch 12.1.5, interface
120105). It never casts spells, clicks your action bars, or automates
combat. It shows a kick assignment bar and short boss notes.

Install
-------
Put the KickBossNotes folder in:

  World of Warcraft\_retail_\Interface\AddOns\KickBossNotes

Reload the UI (/reload). Commands: /kbn   /kicknotes   /kbn help


What you get
------------
1) Dungeon / raid interrupt assigner
   - Detects each party or raid member's class (and spec when known) and
     their interrupt spell and base cooldown, including Devourer DH (Disrupt).
   - Build a kick order with Up / Down / Add / Remove. In a 5-player party
     anyone can edit; use Auto-fill party to add every kicker at once.
   - In a raid, the leader or an assistant is in charge. You can make up to
     three kick groups (A / B / C) and tag each with a raid marker
     (Skull, Cross, Star, and so on) so each group has a target or add.
   - Share order sends the list to everyone else who has the addon.
   - Post kick order to party/raid posts one or more chat lines, but only
     when you click the button.
   - The movable kick bar shows the order, who is next, and cooldown
     information when the game allows it.
   - Click I Kicked after you interrupt to advance the rotation. That is
     how the "next" pointer moves — the addon cannot see other players'
     kicks for you.

2) Boss notes
   - Role-aware Tank / Healer / DPS + general notes (usually 3–6 bullets)
     for every Midnight raid released through Season 2 / 12.1.5:
     The Venomous Abyss, The Unbinding of Kith'ix, The Tidebound Grotto
     (lair raid, not a 5-man), The Voidspire, The Dreamrift, March on
     Quel'Danas, and Sporefall. Dummy Dome and unreleased Season 3 raids
     are not included. Coiled Altar Phase 3 bonus-health numbers are
     unchanged from v1.0.0.
   - The same format for every Midnight dungeon (including leveling /
     non-M+ ones) plus the three legacy dungeons in the current Season 2
     Mythic+ pool. Season 2 M+ dungeons keep their Orboro kick-priority
     lists. Season 1-only legacy dungeons are not included.
   - Delve notes (general + solo / small-group tips) for every Midnight
     delve end boss, story-variant ends, both Nemesis bosses (Nullaeus
     and Azta'rec), and the Labyrinth of Kindo'jan megadelve. The
     Midnight companion is Valeera Sanguinar, not Brann.
   - The browse dropdown is organized Raid > raid > boss, Dungeon >
     dungeon > boss, and Delve > delve > boss, and it scrolls.
   - Notes can pop up at ENCOUNTER_START, or when you target a matching
     name (when the game still lets addons read it). Delves also match
     the instance name when that is readable. You can always browse by
     hand. Your custom notes are still saved in KickBossNotesDB under
     the same boss keys as v1.0.0.


How group sync works
--------------------
Installations talk to each other with addon messages (prefix KBNKICK) on
PARTY, RAID, or INSTANCE_CHAT, whichever matches your group.

Each shared order has a sequence number. The highest number wins, so a
newer share replaces an older one. Joining a group or reloading requests
a sync. The leader (or whoever holds the newest order) replies. The roster
shows who has the addon and which version they are on.

When the group or raid disbands, or you leave or are removed, the kick
list and raid groups A/B/C are cleared automatically, the rotation pointer
and sync sequence are reset, and any queued addon messages are dropped.
Converting a party to a raid, or moving between a home group and an
instance group, does not clear the list. Members who leave a still-active
group are pruned from the rotation; if you are the leader or an assistant,
the updated order is shared. This auto-clear is on by default and can be
toggled in /kbn config ("Auto-clear kick list when the group disbands").
Boss notes and window settings are not affected.

Blizzard blocks addon messages — and often regular chat — during a boss
encounter and during a Mythic+ run (and in PvP matches). This addon does
not try to work around that. If you share or click I Kicked while
messages are blocked, the update is queued and sent when the lock ends.
Until then, everyone still sees their local bar; click I Kicked on each
machine to keep the pointer moving in the moment.

Your own interrupt cooldown can still be drawn as a swirl. The remaining
time as a number is shown only when Blizzard is not hiding cooldown
values. Other players' timers are estimates based on I Kicked plus the
spell's base cooldown, not a live read of their bars.


What Midnight does not allow
----------------------------
These limits come from Blizzard's Midnight addon API (secret values and
chat lockdown), not from a missing feature in this addon:

- Addons may not register COMBAT_LOG_EVENT_UNFILTERED. This addon never
  tries. It cannot automatically detect that someone landed a kick.
- Enemy cast names and whether a cast is interruptible are secret during
  restricted combat, so the bar cannot highlight "kick this now" for you.
- NPC names and IDs are often secret inside dungeons, raids, and delves,
  so the notes panel may not open from targeting mid-instance. Use the
  dropdown, wait for ENCOUNTER_START, or (in delves) rely on the instance
  name when it is readable.
- Other players' cooldowns are not readable in those same situations.
- Addon messages cannot be sent during an encounter or a key. There is
  no legal way around that; we queue and flush afterwards.


Unverified items
----------------
- Instance map IDs for Midnight-original raids, dungeons, and delves were
  not on the public InstanceID list, so those are matched by instance
  name (and, for M+ dungeons, by the active keystone map name). Legacy
  IDs for Ruby Life Pools (2521), Kings' Rest (1762), and Temple of
  Sethraliss (1877) are from Warcraft Wiki and should be solid.
- Encounter IDs are generally unpublished; notes match on encounter,
  boss, or alias name when that name is not secret.
- Crown of the Cosmos stage script was thin on Wowhead; those bullets
  are marked UNVERIFIED.
- Several dungeon bosses still have thin public scripts (notably Xathuux,
  Taz'Rah, Nalorakk, Lothraxion) and several delve story-variant bosses
  are name-confirmed only. The browse list tags those as unverified.
- Which Grudge Pit end boss is the "default" varies by source
  (Brightthorn vs Mycomight).
- Restoration Druid is treated as having no baseline kick. A talent may
  grant Skull Bash (unverified for 12.1.5).
- Devourer's specialization ID has been reported as 1473 or 1480. All
  Demon Hunter specs use Disrupt, so either is fine.
- Some Heroic/Mythic-only details and dungeon boss notes may have been
  hotfixed after the August–October 2026 guide dates. Treat them as a
  starting point.


Commands
--------
/kbn  or  /kicknotes     Toggle the main window
/kbn help                Command list
/kbn config              Options (scale, lock, auto-show notes,
                         auto-clear on disband)
/kbn notes               Show or hide the notes panel
/kbn bar                 Show or hide the kick bar
/kbn lock                Lock or unlock movable frames
/kbn share               Share the kick order (when comms are allowed)
/kbn reset               Reset window positions

Minimap button: left-click opens the window, right-click toggles the bar.
