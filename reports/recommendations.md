# Recommendations: Galaxy F14 5G (supported settings only)

Each item has an ID. Items with an ID are applied by `optimize.bat <ID>` only after you approve them. Items marked MANUAL are things you tap on the phone yourself.

## 1. Storage (the #1 performance problem: 97% full, 4.3 GB free)

Flash storage slows down a lot when it's nearly full. That hurts app loading, FF map loading and RAM Plus. **Target: at least 15 GB free.**

You choose what to delete. I don't delete personal files.

| What | Size | Suggestion |
|---|---|---|
| /sdcard/Download | 4.3 GB | Move to PC / OneDrive, then delete |
| /sdcard/DCIM (camera) | 3.0 GB | Back up to Google Photos/OneDrive/PC |
| /sdcard/Movies | 2.1 GB | Move to PC |
| PocketGPT (AI model data) | 2.9 GB | Delete the model inside the app if unused |
| Clash of Clans | 1.8 GB (958 MB cache) | Clearing its cache is safe |
| Minecraft | 1.4 GB | Uninstall if not played |
| Office / Docs / Sheets | 1.4 + 0.9 + 0.65 GB | Clear downloaded files in-app |
| Google TTS voices | 1.2 GB | Settings → Text-to-speech: remove extra voices |
| RAM Plus swap | up to 6 GB | MANUAL: set RAM Plus to Off or 2 GB |
| All app caches | ~1.2 GB | **C1** (asks you to type YES) |

## 2. Unused features and background apps ("pure performance")

- **B1**: disable 24 SAFE preloads (Facebook stubs, AppCloud, AR Emoji, Samsung Shop, Dynamic lock screen, Kids, Watch stub, Meet, Game Booster extra plugins…). The full list is in `bloatware-analysis.md` section A.
- **B2**: disable OPTIONAL preloads you pick (Routines, Digital Wellbeing, Samsung Pay, Smart Switch, Edge panels, Android Auto, Bixby voice wake-up…). Un-comment them in `optimization/disable-optional.txt`.
- **R1**: block background running for **all your installed apps** except FF, keyboard, launcher, VPN/firewall and authenticators. They still open normally when you tap them, but stay asleep otherwise. **Messengers and banking apps won't notify you.** Use **R1M** instead to keep Telegram/Signal/Session/Discord/Instagram/Gmail working.
- **A2**: turn off "always scanning" for Wi-Fi and Bluetooth (location scanning).
- MANUAL: turn off Bluetooth, NFC, Hotspot and Nearby Share when you're not using them. Location is already off.

## 3. Animations / UI speed

- **A1**: window, transition and animator scale 1.0 → 0.5. The UI feels faster, and app switching back to FF is quicker.

## 4. Display / refresh rate / touch

- **D1**: Motion smoothness → Standard 60 Hz. FF runs at 60 FPS, and a 90 Hz screen makes frames arrive at uneven 11 ms and 22 ms gaps (measured). 60 Hz gives perfectly even 16.7 ms frames. The trade-off is that menus and scrolling become 60 Hz too. Undo it with restore.bat, or Settings → Display → Motion smoothness → High.
- Touch: Samsung has no supported touch-sampling setting. Fake "touch boost" props don't work without root, so they're not included. Turn on Display → **Touch sensitivity** only if you use a screen protector.
- **S1** (optional): screen timeout 30 min → 1 min. Saves battery and heat; doesn't affect gaming.

## 5. Network (low ping)

Measured: **5 GHz Wi-Fi, −62 dBm, 351 Mbps; ping 11–14 ms, 0% loss.** That's already very good. Honest limits:

- **In-game ping depends mostly on the distance to Garena's server and your ISP route (Airtel).** No phone setting or ADB command lowers it below that. Apps and scripts that promise "ping boost" are fake or are VPNs that usually make it worse.
- What the phone *can* do is avoid **spikes**:
  - **A3**: stop auto-switching to a "better" Wi-Fi network mid-match. You have 2 saved networks.
  - **A2**: no background Wi-Fi scans (scans cause short latency spikes).
  - **R1**: no background app downloads or syncs eating bandwidth during a match.
  - MANUAL: Settings → Connections → Wi-Fi → ⋮ → Intelligent Wi-Fi → turn off **"Switch to mobile data"**, so it doesn't jump to mobile data mid-fight.
  - MANUAL: **don't run Cloudflare WARP / NetGuard / Turbo VPN while gaming.** A VPN adds a hop and extra ping.
  - MANUAL: stay on **5 GHz**. Sit closer to the router (−62 dBm is OK; −50 or better is ideal). Don't let others download or stream on the same Wi-Fi during matches.
- Private DNS (currently "Automatic") **does not** change in-game ping. It only affects website lookups, so I'm leaving it.

## 6. Battery and thermal

- Thermal status was **3 (Severe)** in both samples (skin about 41.5 °C), once while charging. **Don't game while charging.** Take the case off for long sessions.
- **G2** (optional): Battery → Enhanced processing ON. Faster app/CPU response, but more heat and battery drain. Test it with the benchmark: if AP temperature goes up and FPS doesn't, undo it.
- Keep: Adaptive battery, Device care, Game Optimizing Service and all thermal limits. **Not touched.**

## 7. Game Booster

- **G1**: No interruptions during games, lock auto-brightness, swipe twice for the nav bar.
- MANUAL: Game performance → Performance (see `freefire-gaming-profile.md`).

## 8. Privacy and security (no changes, notes only)

- **Security patch is from Feb 2025.** Check Settings → Software update. Updates often include GPU driver fixes too.
- Sideloaded or risky apps found: ReVanced manager, a modded YouTube/microG (com.gold.*), SAI, WPS tester, a Kali helper and Turbo VPN. Uninstall the ones you don't use. That's your call; I won't remove anything.
- Play Protect, Knox, Secure Folder and Auto Blocker: **not touched**. If you turned Auto Blocker off to connect ADB, turn it back on after optimizing (ADB will stop working while it's on).
