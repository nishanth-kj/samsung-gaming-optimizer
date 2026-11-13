@echo off
rem READ-ONLY audit. Changes nothing on the phone. Output: audit\run-TIMESTAMP\
setlocal EnableDelayedExpansion
cd /d "%~dp0"
set ADB=C:\Users\Admin\AppData\Local\Android\Sdk\platform-tools\adb.exe
set SERIAL=RZCW41AYWZF
set EXPECT_MODEL=SM-E146B
%ADB% devices -l
set STATE=
for /f "delims=" %%s in ('%ADB% -s %SERIAL% get-state 2^>nul') do set STATE=%%s
if not "!STATE!"=="device" (echo [ERROR] Phone %SERIAL% not connected/authorized. & exit /b 1)
set MODEL=
for /f "delims=" %%m in ('%ADB% -s %SERIAL% shell getprop ro.product.model') do set MODEL=%%m
if /i not "!MODEL!"=="%EXPECT_MODEL%" (echo [ERROR] Wrong phone: "!MODEL!" & exit /b 1)
for /f %%t in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set TS=%%t
set D=audit\run-%TS%
mkdir "%D%"
set FAILS=0
call :grab getprop.txt getprop
call :grab packages-user0.txt pm list packages -f --user 0
call :grab packages-3p.txt pm list packages -3 --user 0
call :grab packages-disabled.txt pm list packages -d --user 0
call :grab meminfo.txt dumpsys meminfo
call :grab cpuinfo.txt dumpsys cpuinfo
call :grab top.txt top -b -n 1 -m 25
call :grab processes.txt ps -A
call :grab battery.txt dumpsys battery
call :grab thermal.txt dumpsys thermalservice
call :grab display.txt dumpsys display
call :grab surfaceflinger.txt dumpsys SurfaceFlinger
call :grab df.txt df -h
call :grab diskstats.txt dumpsys diskstats
call :grab settings-global.txt settings list global
call :grab settings-system.txt settings list system
call :grab settings-secure.txt settings list secure
call :grab connectivity.txt dumpsys connectivity
call :grab game.txt dumpsys game
call :grab ping.txt ping -c 20 -i 0.3 8.8.8.8
echo Audit saved to %D%  (failed commands: %FAILS%)
exit /b %FAILS%

:grab
set OUT=%1
shift
set CMDL=
:gl
if "%~1"=="" goto :gr
set CMDL=!CMDL! %1
shift
goto :gl
:gr
%ADB% -s %SERIAL% shell!CMDL! > "%D%\%OUT%" 2>&1
if errorlevel 1 (echo   [FAIL] !CMDL! & set /a FAILS+=1) else (echo   [OK] !CMDL!)
exit /b 0
