# Free Fire MAX gaming profile: Galaxy F14 5G

- Game: **Free Fire MAX** `com.dts.freefiremax` v2.133.1. Normal Free Fire isn't installed.
- No game files, memory, configs or anti-cheat get touched. Only phone settings and options inside the game's own menu are changed.

## What the hardware can really do (no fake promises)

- Exynos 1330 with a Mali-G68 MP2 GPU is an entry/mid-range chip.
- The screen supports **60 Hz and 90 Hz only**.
- Free Fire MAX decides its own FPS options per device. On this phone the game currently runs at **60 FPS** (measured).
- A 90 FPS option only appears if Garena whitelists this phone. If the menu doesn't show it, no ADB setting can safely unlock it. Forcing it would mean editing game files, which can get the account banned. **The realistic target is a locked, stable 60 FPS.**

## Baseline measured just now (FF open, 30 s, not charging)

| Metric | Value |
|---|---|
| Average FPS | **59.4** |
| Frame gaps | 22 ms ×863, 11 ms ×750: **uneven** (60 FPS on a 90 Hz screen alternates 1 and 2 refresh cycles) |
| Stutters ≥33 ms | 18 (1.0%); 3 of them ≥50 ms |
| Thermal status | **3 (Severe)**: AP 41.9 °C, skin 41.7 °C, battery 33.7 °C |
| Free RAM | 2.7 GB (incl. cache) |
| Ping | 8.8.8.8 avg 14 ms, 1.1.1.1 avg 11 ms, 0% loss |

**Why this matters:** 59.4 FPS sounds fine, but the frames show up at uneven 11 / 22 ms gaps. That feels like micro-stutter when you aim or drag. Setting the screen to **60 Hz** (item D1) makes every frame 16.7 ms apart. This is the main smoothness fix available on this phone.

## Phone setup (Game Booster, One UI 6.1)

Open Free Fire MAX, swipe up from the bottom to show the nav bar, and tap the **Game Booster** icon (bottom right) → gear icon:

| Setting | Set to | Why |
|---|---|---|
| Game performance / Game optimization (if your version shows it) | **Performance** (or "Standard" if the phone gets too hot) | Lets GOS use higher clocks |
| Block during game → **Navigation gestures** | On (or item G1: swipe twice) | Stops accidental exits |
| Block during game → **Auto brightness** | On (item G1) | Stops brightness changes mid-fight |
| Block during game → **Edge panels / Screenshots button** | On | Fewer accidental touches |
| **Do not disturb / No interruptions** | On (item G1) | You said notifications don't matter. Calls still ring on One UI unless you also turn on "Block calls". Leave that off. |
| Touch protection / Touch lock | Off | Only for watching videos |
| Auto temperature control | **Leave as is** (off) | Android's own thermal throttling still protects the phone |

**Settings → Display:**
- **Motion smoothness: Standard (60 Hz)**: item D1. Even frame pacing for 60 FPS.
- **Touch sensitivity**: turn it ON only if you use a screen protector.

**Settings → Battery & device care → Memory → RAM Plus: Off or 2 GB** (needs a restart; you do this one on the phone).
- RAM Plus is 6 GB of fake RAM written to storage that's 97% full. Physical RAM is what matters for FF.
- Turning it off frees about 6 GB of storage and stops swap writes.
- Background apps get closed sooner, which is what you want anyway.

## In-game settings (Free Fire MAX → Settings → Graphics)

| Setting | Recommendation |
|---|---|
| Graphics | **Smooth** for competitive play. Try **Standard** only if the benchmark shows <1% stutters and AP stays below about 42 °C. |
| High FPS / Frame rate | **On / the highest option the game offers** (60 on this device) |
| Shadows | **Off**. Big GPU cost, and enemies are easier to see without them. |
| Resolution (if shown) | Default / lower option |
| Ultra/HD textures, MAX-only extras | Off. Avoid downloading the HD resource pack: storage is 97% full. |
| Sensitivity | Start with General 90–100, Red Dot 85–95, 2x 80–90, 4x 70–80, AWM 40–60, Free look 70. Tune in Training ground for your thumbs/claw. These are starting points; there's no "pro" number. |
| HUD | Use 3- or 4-finger claw in Custom HUD. Put fire/scope/crouch where your fingers already rest. |
| Network | Use the in-game ping display. Play on **5 GHz Wi-Fi** (you are: −62 dBm, 351 Mbps, good). |

## During long sessions

- **Don't play while charging.** The audit caught the phone at thermal status 3 while on AC. Heat equals throttling equals FPS drops.
- Take the case off for long sessions, and keep the phone out of direct sun and off pillows/beds.
- Before a session: close recent apps (one tap: Close all). Item R1 then keeps them from coming back.
- When AP goes above about 45 °C or the game feels sluggish, take a 5-minute break. Don't disable any thermal protection.

## How to measure before/after yourself

`benchmark.bat before`, then play one Clash Squad match, then press a key. Apply the items you approved. `benchmark.bat after` with the same mode. Compare the `summary.txt` files. In Developer options you can also enable **GPUWatch** (Samsung's own FPS overlay) to see FPS live.
