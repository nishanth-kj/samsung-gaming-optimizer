# System report: Samsung Galaxy F14 5G

Audit date: 2026-11-13 02:20 (IST). Read-only: nothing on the phone was changed.
Raw data is in this folder. Original settings are backed up in `../backup/20261113-022037/`.

## Device (verified via getprop, not assumed)

| Item | Value |
|---|---|
| Model | Samsung Galaxy F14 5G, **SM-E146B** (codename m14x), India (CSC INS) |
| Android / One UI | Android 14 (SDK 34) / One UI 6.1 |
| Build | E146BXXS7CYB1 (UP1A.231005.007) |
| Security patch | 2025-02-01 (old, about 21 months; check Software update) |
| SoC | Samsung Exynos 1330 (s5e8535), 5 nm |
| CPU | 8 cores: 2× Cortex-A78 @ 2.4 GHz + 6× Cortex-A55 @ 2.0 GHz |
| GPU | Mali-G68 MP2 (Vulkan driver `mali`, OpenGL ES 3.2) |
| RAM | 5.6 GB usable (6 GB); **RAM Plus = 6 GB** of virtual RAM on storage |
| Storage | 110 GB /data, **105 GB used, 4.3 GB free (97% full)** |
| Display | 1080×2408 LCD, 450 dpi; modes **60 Hz and 90 Hz only** |
| Motion smoothness | `refresh_rate_mode=1` (High / 90 Hz is already selected) |
| Knox warranty bit | 0 (intact); verified boot state green |
| Users | Main user 0, plus **Secure Folder (user 150) running** |

## Key findings (worst first)

1. **Storage is 97% full (4.3 GB free).** This is the single biggest cause of stutter and slow app loads. Flash storage gets slow when nearly full, and RAM Plus (swap) also lives on it. Biggest items: Downloads 4.3 GB, DCIM 3.0 GB, Movies 2.1 GB, PocketGPT 2.9 GB (an AI model), Clash of Clans 1.8 GB, Minecraft 1.4 GB, Office 1.4 GB, Google TTS voices 1.2 GB, Opera 1.2 GB, Glassdoor 0.98 GB. App caches total about 1.2 GB.
2. **Thermal status 3 (SEVERE) at audit time**, with a skin temperature of 41.1 °C and AP at 39 °C. The phone was **charging** (AC, 44%). When status is SEVERE, the system throttles the CPU and GPU, so FPS drops. Don't game while charging on this phone.
3. **Too many background apps.** 244 third-party apps are installed, and many keep processes alive: YouTube (modded "gold") 408 MB, Gmail, Opera, Twitter/X, Clash of Clans, Play Store, OneDrive, Samsung Pay mini, Google app ×3. Background RAM pressure causes FF reloads and frame drops.
4. **RAM Plus = 6 GB** on a phone that is 97% full. That swap writes to storage that is already nearly full.
5. **Display**: 90 Hz is the maximum. Free Fire MAX can't go above 60 FPS on this chip's tier anyway (see the gaming profile).
6. **Animations** are at 1.0× (default). Setting them to 0.5× makes the UI feel faster.
7. **Network is good**: 5 GHz Wi-Fi (5785 MHz, Wi-Fi 5), RSSI −62 dBm, 351 Mbps link. Ping to 8.8.8.8 was avg 14 ms (min 9, max 23, jitter 3.6, 0% loss) and to 1.1.1.1 avg 11 ms. Private DNS is "Automatic". "Switch to better Wi-Fi" and Wi-Fi scanning are on (these can cause short hiccups mid-game).
8. **Game Booster**: installed and working (`gos`, `gametools`, `gamehome`). "No interruptions" is OFF, "auto temperature control" is OFF, and the touchscreen lock is off.
9. **Location is OFF** (`location_mode=0`). Good for battery.
10. **Free Fire MAX** `com.dts.freefiremax`, version 2.133.1, installed 2026-11-11. Its data folder is 562 MB. Free Fire (normal) is **not** installed.
11. **WhatsApp is not installed on the main profile.** It may be inside Secure Folder (ADB can't see that profile). Calls and SMS use the Samsung Phone and Samsung Messages apps.

## Measurements that ADB can't do accurately here

- Real in-game FPS without launching the game. You asked me not to run apps, so I haven't launched FF. The FPS benchmark needs you to play one match while `benchmark.bat` records (see README).
- Touch latency and touch sampling rate. There's no supported ADB readout on Samsung.
- CPU temperature per core. The shell can't read thermal zones; only the AP, SKIN and battery sensors from thermalservice are available.
- Battery health %. One UI hides it; `mSavedBatteryAsoc: 100` is reported but isn't reliable on this model.
