Clayton's Kick & Boss Notes  v1.0.0
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
   - Short Tank / Healer / DPS + general notes for every boss of The
     Venomous Abyss, including The Coiled Altar (Zul'jan and Malacrass
     Phase 3 bonus health, separate pools, berserk if one dies first).
   - Brief notes and a kick-priority list for every Midnight Season 2
     Mythic+ dungeon. The list appears when you are in that dungeon.
   - The notes panel can pop up at encounter start, or when you target the
     boss (when the game still lets addons read the name). You can always
     browse any boss by hand and type your own note, which is saved.


How group sync works
--------------------
Installations talk to each other with addon messages (prefix KBNKICK) on
PARTY, RAID, or INSTANCE_CHAT, whichever matches your group.

Each shared order has a sequence number. The highest number wins, so a
newer share replaces an older one. Joining a group or reloading requests
a sync. The roster shows who has the addon and which version they are on.

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
- NPC names and IDs are often secret inside dungeons and raids, so the
  notes panel may not open from targeting mid-instance. Use the dropdown
  or wait for ENCOUNTER_START when the encounter name is available.
- Other players' cooldowns are not readable in those same situations.
- Addon messages cannot be sent during an encounter or a key. There is
  no legal way around that; we queue and flush afterwards.


Unverified items
----------------
- Instance map IDs for the five Midnight-original Season 2 dungeons were
  not on the public InstanceID list, so those dungeons are matched by
  instance name (and by the active keystone map name). Legacy IDs for
  Ruby Life Pools (2521), Kings' Rest (1762), and Temple of Sethraliss
  (1877) are from Warcraft Wiki and should be solid.
- Encounter IDs for Venomous Abyss bosses were not listed in the Wowhead
  guides; notes match on encounter or boss name when that name is not
  secret.
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
/kbn config              Options (scale, lock, auto-show notes)
/kbn notes               Show or hide the notes panel
/kbn bar                 Show or hide the kick bar
/kbn lock                Lock or unlock movable frames
/kbn share               Share the kick order (when comms are allowed)
/kbn reset               Reset window positions

Minimap button: left-click opens the window, right-click toggles the bar.
