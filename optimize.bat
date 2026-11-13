@echo off
rem Applies ONLY the item IDs you pass, e.g.:  optimize.bat A1 A2 G1
rem Every change records its original value in restore\restore-commands.txt first.
setlocal EnableDelayedExpansion
set "BASE=%~dp0"
set "SELF=%~f0"
cd /d "%BASE%"
set ADB=C:\Users\Admin\AppData\Local\Android\Sdk\platform-tools\adb.exe
set SERIAL=RZCW41AYWZF
set EXPECT_MODEL=SM-E146B
set LOG=%BASE%optimization\changes.log
set RST=%BASE%restore\restore-commands.txt
if not exist optimization mkdir optimization
if not exist restore mkdir restore

if "%~1"=="" goto :usage
call :checkdevice || exit /b 1

set FAILS=0
:nextarg
if "%~1"=="" goto :done
set ID=%~1
findstr /b /i /c:":item_%ID%" "%SELF%" >nul || (echo [SKIP] Unknown item %ID% & shift & goto :nextarg)
echo.
echo ===== Item %ID% =====
call :item_%ID%
if errorlevel 1 (echo [FAIL] Item %ID% & set /a FAILS+=1) else (echo [OK] Item %ID%)
shift
goto :nextarg

:done
echo.
echo Finished. Failed items: %FAILS%.  Log: optimization\changes.log
echo Undo everything: restore.bat
exit /b %FAILS%

rem ================= ITEMS =================
:item_A1
rem Animations 0.5x (Developer options values)
call :setkv global window_animation_scale 0.5 || exit /b 1
call :setkv global transition_animation_scale 0.5 || exit /b 1
call :setkv global animator_duration_scale 0.5 || exit /b 1
exit /b 0

:item_A2
rem Stop always-on Wi-Fi / Bluetooth scanning (Location scanning settings)
call :setkv global wifi_scan_always_enabled 0 || exit /b 1
call :setkv global ble_scan_always_enabled 0 || exit /b 1
exit /b 0

:item_A3
rem Don't auto-switch Wi-Fi networks mid-match
call :setkv global sem_wifi_switch_to_better_wifi_enabled 0 || exit /b 1
exit /b 0

:item_G1
rem Game Booster: block notifications, lock auto-brightness, swipe twice for nav bar
call :setkv system game_no_interruption 1 || exit /b 1
call :setkv secure game_autobrightness_lock 1 || exit /b 1
call :setkv secure game_double_swipe_enable 1 || exit /b 1
exit /b 0

:item_G2
rem Battery > More battery settings > Enhanced processing (more heat/battery)
call :setkv global sem_enhanced_cpu_responsiveness 1 || exit /b 1
exit /b 0

:item_D1
rem Motion smoothness = Standard (60 Hz). Gives even frame pacing for FF at 60 FPS (now 11/22 ms judder).
call :setkv secure refresh_rate_mode 0 || exit /b 1
exit /b 0

:item_S1
rem Screen timeout 1 minute (was 30 minutes)
call :setkv system screen_off_timeout 60000 || exit /b 1
exit /b 0

:item_B1
call :disablelist "%BASE%optimization\disable-safe.txt"
exit /b %errorlevel%

:item_B2
call :disablelist "%BASE%optimization\disable-optional.txt"
exit /b %errorlevel%

:item_R1
rem Restrict background for user apps except optimization\bg-keep.txt
call :bgrestrict "%BASE%optimization\bg-keep.txt"
exit /b %errorlevel%

:item_R1M
rem Same as R1 but messengers keep running (bg-keep + bg-keep-messengers)
copy /y /b "%BASE%optimization\bg-keep.txt" + "%BASE%optimization\bg-keep-messengers.txt" "%TEMP%\bg-keep-combined.txt" >nul
call :bgrestrict "%TEMP%\bg-keep-combined.txt"
exit /b %errorlevel%

:item_C1
rem Clear ALL app caches (cache only, not app data). Cannot be "restored" - caches rebuild by themselves.
set /p OKC=Type YES to clear all app caches (about 1.2 GB):
if /i not "!OKC!"=="YES" (echo Cancelled. & exit /b 0)
%ADB% -s %SERIAL% shell pm trim-caches 999G || exit /b 1
call :log "C1 pm trim-caches 999G (not reversible, cache only)"
exit /b 0

rem ================= HELPERS =================
:checkdevice
set STATE=
for /f "delims=" %%s in ('%ADB% -s %SERIAL% get-state 2^>nul') do set STATE=%%s
if not "!STATE!"=="device" (echo [ERROR] Phone %SERIAL% not connected or not authorized. Check adb devices. & exit /b 1)
set MODEL=
for /f "delims=" %%m in ('%ADB% -s %SERIAL% shell getprop ro.product.model') do set MODEL=%%m
if /i not "!MODEL!"=="%EXPECT_MODEL%" (echo [ERROR] Wrong phone: "!MODEL!" expected %EXPECT_MODEL%. & exit /b 1)
echo Device OK: %SERIAL% !MODEL!
exit /b 0

:setkv
rem %1=namespace %2=key %3=new value
set ORIG=
for /f "delims=" %%v in ('%ADB% -s %SERIAL% shell settings get %1 %2') do set ORIG=%%v
if "!ORIG!"=="" (echo [ERROR] could not read %1 %2 & exit /b 1)
findstr /b /c:"settings put %1 %2 " /c:"settings delete %1 %2" "%RST%" >nul 2>&1
if errorlevel 1 (
  if "!ORIG!"=="null" (>>"%RST%" echo settings delete %1 %2) else (>>"%RST%" echo settings put %1 %2 !ORIG!)
)
%ADB% -s %SERIAL% shell settings put %1 %2 %3 || exit /b 1
set NEWV=
for /f "delims=" %%v in ('%ADB% -s %SERIAL% shell settings get %1 %2') do set NEWV=%%v
if not "!NEWV!"=="%3" (echo [ERROR] verify failed %1 %2 = !NEWV! & exit /b 1)
echo   %1 %2: !ORIG! -^> !NEWV!
call :log "settings %1 %2: !ORIG! -> !NEWV!"
exit /b 0

:disablelist
set DF=0
for /f "usebackq eol=# tokens=1" %%p in (%1) do (
  call :disableone %%p || set DF=1
)
exit /b !DF!

:disableone
set R=
for /f "delims=" %%r in ('%ADB% -s %SERIAL% shell "if pm list packages -d --user 0 | grep -qx package:%1; then echo DIS; elif pm list packages --user 0 | grep -qx package:%1; then echo EN; else echo NONE; fi"') do set R=%%r
if "!R!"=="NONE" (echo   not installed: %1 & exit /b 0)
if "!R!"=="DIS" (echo   already disabled: %1 & exit /b 0)
if not "!R!"=="EN" (echo   [ERROR] could not check %1 & exit /b 1)
%ADB% -s %SERIAL% shell pm disable-user --user 0 %1 | findstr /c:"disabled-user" >nul
if errorlevel 1 (echo   [FAIL] could not disable %1 ^(protected by system^) & exit /b 1)
>>"%RST%" echo pm enable --user 0 %1
echo   disabled: %1
call :log "disabled %1"
exit /b 0

:bgrestrict
%ADB% -s %SERIAL% push "%BASE%optimization\bg-restrict.sh" /data/local/tmp/bg-restrict.sh >nul || exit /b 1
%ADB% -s %SERIAL% push %1 /data/local/tmp/bg-keep.txt >nul || exit /b 1
%ADB% -s %SERIAL% shell sh /data/local/tmp/bg-restrict.sh /data/local/tmp/bg-keep.txt > "%BASE%optimization\bg-restrict-output.txt"
set RES=
for /f "delims=" %%l in ('findstr /b "RESULT" "%BASE%optimization\bg-restrict-output.txt"') do set RES=%%l
if "!RES!"=="" (echo   [ERROR] script did not finish & exit /b 1)
echo   !RES!
if not exist "%BASE%restore\bg-restore.sh" (
  %ADB% -s %SERIAL% pull /data/local/tmp/bg-restore.sh "%BASE%restore\bg-restore.sh" >nul || (echo   [ERROR] could not save restore file & exit /b 1)
)
call :log "background restriction: !RES!"
echo !RES! | findstr /c:"failed=0" >nul || exit /b 1
exit /b 0

:log
set "MSG=%~1"
>>"%LOG%" echo [%date% %time%] !MSG!
exit /b 0

:usage
echo Usage: optimize.bat ITEM [ITEM...]
echo   A1  animations 0.5x            A2  Wi-Fi/BT scanning off
echo   A3  no auto Wi-Fi switching    G1  Game Booster: no notifications, brightness lock, double-swipe nav
echo   G2  Enhanced processing ON     S1  screen timeout 1 min
echo   D1  Motion smoothness 60 Hz (even frame pacing in FF)
echo   B1  disable SAFE preloads      B2  disable OPTIONAL preloads you un-commented
echo   R1  restrict ALL user apps in background (except bg-keep.txt)
echo   R1M same as R1 but messengers keep working
echo   C1  clear all app caches (asks YES)
echo See reports\proposed-changes.md
exit /b 1
