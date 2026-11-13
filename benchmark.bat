@echo off
rem Usage: benchmark.bat before   (or: benchmark.bat after)
rem Records RAM, temps, network ping, then measures Free Fire MAX frames while YOU play one match.
rem It does not open or touch the game. You open it yourself.
setlocal EnableDelayedExpansion
cd /d "%~dp0"
set ADB=C:\Users\Admin\AppData\Local\Android\Sdk\platform-tools\adb.exe
set SERIAL=RZCW41AYWZF
set EXPECT_MODEL=SM-E146B
set LABEL=%~1
if "%LABEL%"=="" set LABEL=run
set STATE=
for /f "delims=" %%s in ('%ADB% -s %SERIAL% get-state 2^>nul') do set STATE=%%s
if not "!STATE!"=="device" (echo [ERROR] Phone not connected/authorized. & exit /b 1)
set MODEL=
for /f "delims=" %%m in ('%ADB% -s %SERIAL% shell getprop ro.product.model') do set MODEL=%%m
if /i not "!MODEL!"=="%EXPECT_MODEL%" (echo [ERROR] Wrong phone: "!MODEL!" & exit /b 1)
for /f %%t in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set TS=%%t
set D=benchmarks\%LABEL%-%TS%
mkdir "%D%"

echo [1/4] Idle snapshot (RAM, temps, battery)...
%ADB% -s %SERIAL% shell dumpsys meminfo > "%D%\idle-meminfo.txt"
%ADB% -s %SERIAL% shell dumpsys thermalservice > "%D%\idle-thermal.txt"
%ADB% -s %SERIAL% shell dumpsys battery > "%D%\idle-battery.txt"
echo [2/4] Network: 50 pings to 8.8.8.8 and 1.1.1.1...
%ADB% -s %SERIAL% shell ping -c 50 -i 0.2 8.8.8.8 > "%D%\ping-google.txt"
%ADB% -s %SERIAL% shell ping -c 50 -i 0.2 1.1.1.1 > "%D%\ping-cloudflare.txt"

echo [3/4] Frame stats: starting SurfaceFlinger timestats...
%ADB% -s %SERIAL% shell dumpsys SurfaceFlinger --timestats -clear -enable > nul
echo.
echo   UNPLUG THE CHARGER if you can (cable only for ADB), open Free Fire MAX,
echo   play ONE full match (same mode every time, e.g. Clash Squad), then come back here.
echo.
pause
%ADB% -s %SERIAL% shell dumpsys SurfaceFlinger --timestats -dump > "%D%\timestats-raw.txt"
%ADB% -s %SERIAL% shell dumpsys SurfaceFlinger --timestats -disable > nul
%ADB% -s %SERIAL% shell dumpsys thermalservice > "%D%\after-game-thermal.txt"
%ADB% -s %SERIAL% shell dumpsys battery > "%D%\after-game-battery.txt"
%ADB% -s %SERIAL% shell dumpsys meminfo com.dts.freefiremax > "%D%\after-game-ff-meminfo.txt"

echo [4/4] Summary
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0benchmarks\summarize.ps1" -Dir "%D%"
exit /b 0
