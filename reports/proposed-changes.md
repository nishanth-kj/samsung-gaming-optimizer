# Proposed changes: waiting for your approval

**Nothing has been changed on the phone yet.** Reply with the IDs you approve, for example: "A1 A2 A3 G1 D1 B1 R1".
Every ADB change records its original value first. `restore.bat` undoes all of them.

| ID | Change | Benefit | Risk / side effect | Undo |
|---|---|---|---|---|
| **A1** | Animations 1.0 → 0.5 | Snappier UI and app switching | None | restore.bat |
| **A2** | Wi-Fi + Bluetooth always-scanning off | Fewer ping spikes, less battery | Location may be slightly less accurate | restore.bat |
| **A3** | Don't auto-switch to "better" Wi-Fi | No disconnect mid-match | Won't jump to a stronger saved network by itself | restore.bat |
| **G1** | Game Booster: no notifications, brightness lock, swipe twice for nav | No popups or accidental exits in FF | No notifications while gaming (calls still ring) | restore.bat |
| ~~D1~~ (tested, rejected: 90 Hz is smoother, see benchmarks/comparison.md) | Motion smoothness 90 Hz → 60 Hz | **Even frame pacing in FF** (fixes the measured 11/22 ms judder) | Menus/scrolling at 60 Hz | restore.bat |
| **B1** | Disable 24 SAFE preloads (list in bloatware-analysis.md §A) | Less background activity and fewer wakeups | Lose AR Emoji, Samsung Shop, Kids, Meet, Dynamic lock screen, etc. | restore.bat (pm enable) |
| **B2** | Disable OPTIONAL preloads **you pick** (§B) | More of the same | Depends on which ones you pick | restore.bat |
| **R1** | Block background running for **all** your apps except FF, keyboard, launcher, VPN, authenticators | **Maximum free RAM / CPU for FF**, no background data | **No notifications** from Telegram, Signal, Discord, Instagram, Gmail, banking/UPI apps until you open them. Apps also force-stopped now. | restore.bat (exact original state saved) |
| **R1M** | Same as R1 but messengers keep running | Almost the same gain | Messengers use a bit of RAM | restore.bat |
| **G2** | Enhanced processing ON | Faster CPU response | More heat and battery; test with the benchmark | restore.bat |
| **S1** | Screen timeout 30 min → 1 min | Less heat and battery when idle | Screen turns off sooner | restore.bat |
| **C1** | Clear all app caches (~1.2 GB) | Frees storage | Apps load a bit slower once while caches rebuild. **Can't be "undone"**, but no data or logins are lost. | n/a |

### Manual steps for you (on the phone, not ADB)

1. **Free up storage to 15 GB+** (see recommendations §1). This is the biggest win.
2. **RAM Plus → Off or 2 GB** (Battery & device care → Memory), then restart.
3. Game Booster → Game performance → **Performance**.
4. FF MAX graphics: **Smooth + High FPS on + Shadows off** (freefire-gaming-profile.md).
5. Intelligent Wi-Fi → **Switch to mobile data: off**. Don't use a VPN while gaming.
6. Check **Software update** (patch is Feb 2025).
7. Don't play while charging.

### My suggestion for "super performance" with no background apps

`A1 A2 A3 G1 D1 B1 R1` + C1 + the manual steps.
Choose **R1M** instead of R1 if you want Telegram/Signal/Discord messages to still come in.

### After applying

`benchmark.bat after` (play the same match mode as before) gives a real before/after table. I won't make up numbers.
