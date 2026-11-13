@echo off
rem Undoes every change optimize.bat made, using the original values it recorded.
setlocal EnableDelayedExpansion
cd /d "%~dp0"
set ADB=C:\Users\Admin\AppData\Local\Android\Sdk\platform-tools\adb.exe
set SERIAL=RZCW41AYWZF
set EXPECT_MODEL=SM-E146B
set RST=%~dp0restore\restore-commands.txt
set BGR=%~dp0restore\bg-restore.sh

set STATE=
for /f "delims=" %%s in ('%ADB% -s %SERIAL% get-state 2^>nul') do set STATE=%%s
if not "!STATE!"=="device" (echo [ERROR] Phone %SERIAL% not connected/authorized. & exit /b 1)
set MODEL=
for /f "delims=" %%m in ('%ADB% -s %SERIAL% shell getprop ro.product.model') do set MODEL=%%m
if /i not "!MODEL!"=="%EXPECT_MODEL%" (echo [ERROR] Wrong phone: "!MODEL!" & exit /b 1)

for /f %%t in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd-HHmmss"') do set TS=%%t
set FAILS=0

if exist "%RST%" (
  echo Restoring settings and re-enabling apps...
  for /f "usebackq delims=" %%L in ("%RST%") do (
    %ADB% -s %SERIAL% shell %%L
    if errorlevel 1 (echo   [FAIL] %%L & set /a FAILS+=1) else (echo   [OK] %%L)
  )
  ren "%RST%" "restore-commands.done-!TS!.txt"
) else (echo No settings/app changes recorded.)

if exist "%BGR%" (
  echo Restoring background state of apps...
  %ADB% -s %SERIAL% push "%BGR%" /data/local/tmp/bg-restore.sh >nul
  %ADB% -s %SERIAL% shell sh /data/local/tmp/bg-restore.sh
  if errorlevel 1 (echo   [WARN] some apps could not be restored ^(maybe uninstalled^) & set /a FAILS+=1)
  %ADB% -s %SERIAL% shell rm -f /data/local/tmp/bg-restore.sh /data/local/tmp/bg-restrict.sh /data/local/tmp/bg-keep.txt /data/local/tmp/bg-keep.clean
  ren "%BGR%" "bg-restore.done-!TS!.sh"
) else (echo No background restrictions recorded.)

>>"%~dp0optimization\changes.log" echo [%date% %time%] RESTORE run, failures=!FAILS!
echo Done. Failures: !FAILS!. Manual changes (RAM Plus, Game Booster per-game, in-game FF settings) must be undone on the phone.
exit /b !FAILS!
