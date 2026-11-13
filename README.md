# wow-addons

Kardgaz's World of Warcraft retail addons.

| Addon | Version | Description |
| --- | --- | --- |
| Alt Vault Checklist | 2.1.1 | Account-wide Mythic+ key, Great Vault, weekly, and BiS gear checklists, plus a party key board. Registers each character you log in on. |
| Kardgaz's Kick & Boss Notes | 1.2.0 | Party and raid interrupt assignments, plus role-aware raid, dungeon, and delve boss notes. Display only. |

## Install

Quit the game, then copy each addon folder into:

`World of Warcraft\_retail_\Interface\AddOns`

The folder name must match its `.toc` file (`AltVaultChecklist`, `KickBossNotes`). Enable the addon at character select, or type `/reload` if you are already in game.

## KickBossNotes

Kardgaz's Kick & Boss Notes v1.2.0 is a display-only interrupt order assigner synced across the party or raid via addon messages, plus role-aware boss notes for Midnight raids, dungeons, and delves. Slash commands are `/kbn`, `/kicknotes`, and `/kbn help`. Install by copying the `KickBossNotes` folder into `World of Warcraft/_retail_/Interface/AddOns`.

### Changelog

#### 1.2.0

- Kick list auto-clears and resyncs when the group or raid disbands (Options toggle, default on). Party-to-raid conversion doesn't clear it.
- Members who leave are pruned from the rotation, and a sync is requested on joining a group.
- Fixed the main window subtitle overlapping the Assign/Notes/Options tabs.
