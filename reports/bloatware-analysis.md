# Bloatware analysis: Galaxy F14 5G (One UI 6.1)

The method is always **disable, never uninstall**: `adb shell pm disable-user --user 0 <pkg>`
Undo any one: `adb shell pm enable --user 0 <pkg>`. `restore.bat` undoes all of them.
Disabling keeps the app's data and survives reboots, and an OTA update won't break it. Nothing has been disabled yet.

Ratings:
- **SAFE**: not needed for calls, SMS, security, games or the UI. Disabling only removes that one feature.
- **OPTIONAL**: safe to disable, but you lose a feature you might use. You decide.
- **DO NOT TOUCH**: system, security, Knox, game performance or thermal parts, or not clearly known. Disabling these can cause bootloops, a locked phone or broken features.

"Impact" is based on what this audit saw: whether it runs in the background, its RAM use, and whether it's on the battery-exempt list.

## A. Samsung / preloaded: SAFE to disable

| Package | What it is | Essential? | Impact | Depends on it |
|---|---|---|---|---|
| com.aura.oobe.samsung | "AppCloud" India app-suggestion installer | No | Pushes junk app installs | Nothing |
| com.facebook.appmanager | Facebook preload updater | No | Background jobs; FB exempt from battery limits | Only Facebook apps (none installed) |
| com.facebook.services | Facebook services | No | Battery-exempt; wakes the phone | Same |
| com.facebook.system | Facebook App Installer | No | Low | Same |
| com.opera.max.oem | Opera Max data saver preload | No | Low/medium | Nothing |
| com.samsung.ecomm.global.in | Samsung Shop India | No | Ads/notifications | Nothing |
| com.samsung.android.dynamiclock | Dynamic lock screen (rotating wallpapers) | No | Downloads wallpapers | Lock screen still works without it |
| com.samsung.android.arzone | AR Zone | No | Low | AR Emoji |
| com.samsung.android.aremoji | AR Emoji | No | Low | Avatar stickers |
| com.samsung.android.aremojieditor | AR Emoji editor | No | Low | AR Emoji |
| com.sec.android.mimage.avatarstickers | AR Emoji stickers | No | Low | Keyboard sticker tab |
| com.samsung.android.app.parentalcare | Parental controls / Samsung Kids | No | Battery-exempt | Samsung Kids |
| com.samsung.android.kidsinstaller | Samsung Kids installer | No | Low | Same |
| com.samsung.android.app.watchmanagerstub | Galaxy Watch stub | No (no watch) | Low | Galaxy Wearable |
| com.samsung.storyservice | Gallery "Stories" builder | No | Scans photos in background | Gallery stories only |
| com.sec.android.autodoodle.service | Auto-doodle (AR) | No | Low | Camera AR doodle |
| com.samsung.android.ipsgeofence | Visit-in / place geofence | No | Location wakeups | Routines location triggers |
| com.snap.camerakit.plugin.v1 | Snapchat camera filter plugin | No | Low | Camera "fun" mode |
| com.sec.android.app.chromecustomizations | Chrome bookmarks preload | No | None | Nothing |
| com.samsung.android.widget.pictureframe | Picture frame widget | No | Low | That widget |
| com.google.android.apps.tachyon | Google Meet (preload) | No | Background sync | Meet calls |
| com.samsung.android.game.gameclock | Game Booster plugin: clock | No | Low | Nothing |
| com.samsung.android.game.gifcreator | Game Booster plugin: GIF | No | Low | Nothing |
| com.samsung.android.gamesightplugin | Game Booster plugin: insight | No | Low | Nothing |

## B. OPTIONAL: you decide

| Package | What it is | You lose | Impact |
|---|---|---|---|
| com.samsung.android.rubin.app | Customization Service (learns usage, suggestions) | Smart suggestions | Battery-exempt, background |
| com.samsung.android.dqagent | Device Quality agent (telemetry) | Nothing visible | Background |
| com.samsung.android.da.daagent | Dual Messenger agent | **Dual Messenger** (2nd WhatsApp etc.), if you use it | Low |
| com.sec.android.diagmonagent | Samsung diagnostics uploader | Crash reports to Samsung | Background |
| com.samsung.android.app.routines | Modes & Routines | Modes/routines (Sleep, Driving) | Battery-exempt |
| com.samsung.android.forest | Digital Wellbeing | Screen-time stats, Bedtime mode | Battery-exempt, background |
| com.samsung.android.intellivoiceservice | Voice wake-up | "Hi Bixby" | Mic listener |
| com.samsung.android.callassistant | Bixby text call | Text call | Low |
| com.samsung.android.smartface | Smart stay | Screen on while looking | Camera use |
| com.samsung.android.spaymini | Samsung Wallet (mini) | Samsung Pay / Wallet | **86 MB RAM**, background |
| com.samsung.android.scloud | Samsung Cloud | Samsung cloud backup | Background sync |
| com.samsung.android.app.updatecenter | Update center | Samsung app auto-updates | Low |
| com.samsung.android.themestore | Galaxy Themes store | Theme store (themes stay) | Low |
| com.sec.android.app.billing | Samsung checkout | Galaxy Store purchases | Low |
| com.samsung.android.beaconmanager | BLE beacon/accessory scan | Galaxy Buds popup | BT scans |
| com.samsung.android.service.peoplestripe | Edge "People" | Edge contacts panel | Battery-exempt |
| com.samsung.android.app.clipboardedge / taskedge / appsedge | Edge panels | Those edge panels | Low |
| com.samsung.android.stickercenter | Sticker center | Keyboard stickers | Low |
| com.samsung.android.app.dressroom | Wallpaper dress room | Wallpaper picker extras | Low |
| com.samsung.android.app.reminder | Samsung Reminder | Reminders app | Background |
| com.samsung.attribution | Galaxy Store install attribution | Nothing visible | Low |
| com.samsung.android.setupindiaservicestnc | India services T&C | Nothing after setup | None |
| com.samsung.discover / com.samsung.discover.sep | Samsung Discover feed | Discover content | Background |
| com.samsung.android.smartswitchassistant / com.sec.android.easyMover / .Agent | Smart Switch | Phone transfer (re-enable when you switch phones) | Low |
| com.samsung.android.game.gameboosterplus | Game Plugins host | Game Plugins (Game Booster itself stays) | Low |
| com.google.android.projection.gearhead | Android Auto | Car connection | Notification listener, background |
| com.microsoft.appmanager | Link to Windows | PC link | Background |
| com.microsoft.skydrive | OneDrive | OneDrive sync (**you use OneDrive**) | 55 MB RAM |
| com.hiya.star | Hiya caller-ID/spam (Samsung Smart Call) | **Spam-call warnings** | Calls: keep if you get spam calls |
| com.google.android.apps.turbo | Device Health Services | Battery predictions | Low |

## C. DO NOT TOUCH (never disable these)

| Package(s) | Why |
|---|---|
| com.samsung.android.game.gos, com.samsung.android.game.gametools, com.samsung.android.game.gamehome, com.sec.android.smartfpsadjuster, com.sec.android.sdhms | **Game Optimizing Service, Game Booster, FPS and thermal manager.** Disabling these makes gaming *worse* and removes thermal protection. |
| com.samsung.android.kgclient | **Knox Guard.** Disabling it can lock the phone. |
| com.samsung.android.knox.*, com.sec.enterprise.*, com.samsung.knox.securefolder, com.knox.vpn.proxyhandler, com.samsung.klmsagent, com.samsung.android.bbc.bbcagent, com.samsung.android.dsms, com.samsung.android.rampart | Knox/security. Your Secure Folder is in use. |
| com.samsung.android.lool, com.samsung.android.sm.devicesecurity, com.samsung.sait.sohservice | Device care, battery health, security scan |
| com.samsung.android.privacydashboard, com.google.android.permissioncontroller, com.google.android.gms, com.android.vending, com.google.android.gsf | Play Protect / permissions / Play services |
| com.samsung.android.dialer, com.samsung.android.incallui, com.android.phone, com.sec.phone, com.sec.imsservice, com.sec.epdg, com.sec.unifiedwfc, com.samsung.android.messaging, com.android.mms.service, com.android.providers.telephony, com.samsung.android.providers.contacts, com.samsung.android.app.contacts | **Calls, VoLTE/WiFi calling, SMS, contacts** |
| com.samsung.android.honeyboard, com.google.android.inputmethod.latin | Keyboards (Gboard is your default) |
| com.android.systemui, com.sec.android.app.launcher, bitpit.launcher (your launcher), com.samsung.android.app.cocktailbarservice, com.samsung.android.mdx.kit, com.samsung.android.mdx.quickboard, com.samsung.android.app.smartcapture | UI, quick panel, screenshots |
| com.samsung.android.app.omcagent, com.samsung.sec.android.application.csc, com.wssyncmldm, com.sec.android.soagent | Carrier config and **software updates** |
| com.samsung.android.scs, com.samsung.android.scpm, com.samsung.android.uds, com.samsung.android.svcagent, com.samsung.android.mfi, com.samsung.android.alive.service, com.samsung.crane, com.samsung.android.container, com.samsung.android.aware.service, com.samsung.android.app.sharelive | Core services, or packages whose role isn't clearly known. Kept on purpose. |
| com.samsung.gpuwatchapp | GPUWatch. **Keep it**: it's the FPS meter used for benchmarking. |
| All factory/test apps (com.sec.android.app.hwmoduletest, factorykeystring, servicemodeapp, wlantest, RilServiceModeApp, com.sec.facatfunction, com.sec.factory.camera, com.sec.android.app.DataCreate) | Only run from a dialer code; no background impact, so there's no benefit to disabling them |
| com.sec.android.app.samsungapps | Galaxy Store: Game Booster and Samsung app updates |

## D. Your own installed apps: background restriction, not disable

You asked for no unwanted app to run in the background. For your own 244 apps, the plan is to **block background running** (the same as Settings → Battery → Background usage limits → "Deep sleeping"/Restricted), not to disable or uninstall them. The apps stay installed with all their data. They just can't run or sync until you open them.

`adb shell cmd appops set <pkg> RUN_ANY_IN_BACKGROUND ignore` plus `am set-standby-bucket <pkg> restricted`

**Kept running** (never restricted): Free Fire MAX, Gboard (keyboard), Bitpit launcher (your home screen), the Nova and Minimalist launchers, Cloudflare WARP and NetGuard (VPN/firewall; restricting a VPN app can cut off internet), Google/Microsoft Authenticator, and Samsung Phone/Messages (those are system apps, so they're untouched anyway).

**Side effects:** restricted apps send **no notifications** until you open them. That includes Telegram, Signal, Session, Discord, Instagram, Gmail and banking/UPI apps (PayPal, MobiKwik, Super.money, Razorpay). You said notifications don't matter. Messengers are a separate on/off choice in proposed-changes.md if you want to keep them.

Original state for each app is saved in `backup/20261113-022037/bg-state-3p.txt` (53 apps were already restricted).

### Biggest background users seen in this audit
com.gold.android.youtube (408 MB), com.google.android.gm (129 MB), com.opera.browser (103 MB), com.twitter.android (95 MB), com.supercell.clashofclans (74 MB), com.microsoft.skydrive (55 MB), Google app (106 + 64 + 40 MB, system; it can only be limited, not restricted).

### Notes
- **com.gold.android.youtube + com.gold.android.gms** are modded YouTube/microG builds, not the official app. I won't touch them. It's your choice to keep them.
- **app.revanced.manager.flutter, com.aefyr.sai, com.tester.wpswpatester, lifegoal.helpinghands.kalilinux, free.vpn.unblock.proxy.turbovpn**: sideloaded or riskier apps. They don't affect FF, but uninstalling ones you don't use is good for security. Your call; I won't remove anything.
