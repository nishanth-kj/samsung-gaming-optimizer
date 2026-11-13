# Before vs after: Free Fire MAX on Galaxy F14 5G

Real measurements from SurfaceFlinger timestats, thermalservice and ping. Nothing here is estimated.

| Metric | Before (02:26, 30 s) | After (02:37, 60 s, in a match) |
|---|---|---|
| Average FPS | 59.4 | 51.7 |
| Frame pacing | uneven: 22 ms ×863 / 11 ms ×750 (90 Hz screen) | **even: 16 ms ×2708** (60 Hz screen) |
| Stutters ≥33 ms | 18 (1.0%) | 171 (5.9%) |
| Big stutters ≥50 ms | 3 | 43 |
| Thermal status | 3 (Severe) | 2 (Moderate) |
| AP / skin / battery °C | 41.9 / 41.7 / 33.7 | 43.1 / 41.7 / 34.0 |
| Free RAM (incl. cache) | 2.71 GB | 2.29 GB (FF in a match uses more) |
| Ping 8.8.8.8 avg / jitter | 14.3 / 3.6 ms | 12.4 / 2.0 ms |
| Ping 1.1.1.1 avg / jitter | 11.2 / 3.5 ms | 6.8 / 1.0 ms |
| Touch latency | can't be measured by ADB | can't be measured by ADB |

## Why this isn't a fair FPS comparison yet

- The **before** sample was 30 s and probably in the lobby, which is lighter. The **after** sample was 60 s in a real match, which is much heavier.
- RAM Plus was still 6 GB because the phone hadn't been restarted.
- At 60 Hz, a frame that misses its slot waits a full 33 ms. At 90 Hz it only waits 22 ms. So when the GPU can't hold 60 FPS in fights, 60 Hz shows more "33 ms" stutters.

**What's clearly better:** smoother frame pacing when FPS holds, lower thermal status, and lower, steadier ping.
**What's not proven yet:** whether 60 Hz or 90 Hz feels better *in matches*. That needs an A/B test with D1 off vs on, same match mode.

## A/B test in the same match (02:38 vs 02:40): 60 Hz vs 90 Hz

| Metric | 60 Hz (D1 on) | **90 Hz (D1 off)** |
|---|---|---|
| Average FPS | 51.7 | **60.1** |
| Stutters ≥33 ms | 171 (5.9%) | **21 (0.59%)** |
| Big stutters ≥50 ms | 43 | **1** |
| Thermal status / AP | 2 / 43.1 °C | **2 / 41.2 °C** |

**Result: 90 Hz is clearly better on this phone.** The 11/22 ms alternation at 90 Hz is far less noticeable than the 33 ms drops at 60 Hz. **D1 is reverted. Keep Motion smoothness on High (90 Hz).**
