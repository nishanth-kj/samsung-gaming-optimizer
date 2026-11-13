# samsung-gaming-optimizer

Safe, reversible ADB optimization for **Samsung Galaxy F14 5G (SM-E146B, serial RZCW41AYWZF)**, aimed at Free Fire MAX.

**Never done:** no root, no bootloader unlock, no custom ROM, no game file or anti-cheat changes, no thermal or security changes, no uninstalls, no data clearing.

Every script checks that the phone with serial `RZCW41AYWZF` is connected, authorized and is model `SM-E146B` before it does anything.

## Folders

| Folder | Contents |
|---|---|
| `audit/` | Read-only audit from 2026-11-13: `system-report.md` (start here), device-info, installed-packages, running-processes, battery/display/thermal/storage reports, plus raw dumpsys files. `run-*` = later `audit.bat` runs. |
| `backup/20261113-022037/` | Original settings (global/system/secure), package lists, and each app's background state, saved before any change |
| `reports/` | `proposed-changes.md` (**approve from here**), `recommendations.md`, `bloatware-analysis.md`, `freefire-gaming-profile.md` |
| `optimization/` | Lists used by optimize.bat (`disable-safe.txt`, `disable-optional.txt`, `bg-keep*.txt`), the phone-side `bg-restrict.sh`, and `changes.log` (every change made) |
| `restore/` | Undo data written automatically: `restore-commands.txt` and `bg-restore.sh` |
| `benchmarks/` | `before-quick-*` baseline, `summarize.ps1`, and future before/after runs |

## Scripts

| Script | What it does |
|---|---|
| `audit.bat` | Read-only. Saves a fresh audit to `audit\run-TIMESTAMP\`. Changes nothing. |
| `optimize.bat ID [ID…]` | Applies **only** the item IDs you give (see `reports\proposed-changes.md`). For each setting it reads the original value, saves the undo command, applies, then reads it back to verify. Each app disable is checked and logged. Exit code = number of failed items. Run it with no arguments to see the list. |
| `restore.bat` | Undoes everything recorded: puts settings back to their original values, re-enables disabled apps, and restores each app's exact background state. Afterwards the restore files are renamed `*.done-TIMESTAMP` so they never replay twice. |
| `benchmark.bat before` / `after` | Records RAM, temperatures and 50-ping network tests, then measures Free Fire MAX frames (SurfaceFlinger timestats) **while you play one match**. It never opens or modifies the game. Writes `summary.txt`. |

## What each optimize item runs

| ID | ADB command(s) |
|---|---|
| A1 | `settings put global window_animation_scale 0.5`, same for `transition_animation_scale`, `animator_duration_scale` |
| A2 | `settings put global wifi_scan_always_enabled 0`, `settings put global ble_scan_always_enabled 0` |
| A3 | `settings put global sem_wifi_switch_to_better_wifi_enabled 0` |
| G1 | `settings put system game_no_interruption 1`, `settings put secure game_autobrightness_lock 1`, `settings put secure game_double_swipe_enable 1` |
| G2 | `settings put global sem_enhanced_cpu_responsiveness 1` |
| D1 | `settings put secure refresh_rate_mode 0` (Standard 60 Hz) |
| S1 | `settings put system screen_off_timeout 60000` |
| B1 / B2 | `pm disable-user --user 0 <pkg>` for each line of the list (undo: `pm enable --user 0 <pkg>`) |
| R1 / R1M | For each user-installed app not on the keep list: `cmd appops set <pkg> RUN_ANY_IN_BACKGROUND ignore`, `am set-standby-bucket <pkg> restricted`, `am force-stop <pkg>` |
| C1 | `pm trim-caches 999G` (cache only; asks you to type YES) |

## Undo by hand (if the PC isn't available)

- Settings: Developer options → animation scales 1x; Display → Motion smoothness → High; Wi-Fi → Intelligent Wi-Fi; Location → Location services → scanning.
- Apps: Settings → Apps → filter "Disabled" → Enable. Battery → Background usage limits → remove apps from Deep sleeping / Sleeping.

## Previous phone note

The OnePlus Nord 6 (serial 3C1653000WL00000) still has `shortcut_manager_constants=max_shortcuts=0,…` set from an earlier session. That setting can crash apps (it crashed Grok). Undo it on the OnePlus with `adb shell settings delete global shortcut_manager_constants`, then reboot. It doesn't affect this Samsung.
"# samsung-gaming-optimizer" 
