@setlocal enableextensions
@cd /d "%~dp0"
SET _JAVA_OPTIONS=
SET PZ_CLASSPATH=./;projectzomboid.jar

if not exist ".crashes-tracking" mkdir ".crashes-tracking"
if not exist ".crashes-tracking\dumps" mkdir ".crashes-tracking\dumps"

REM Gera timestamp via PowerShell (locale-independent)
for /f %%i in ('powershell -NoProfile -Command Get-Date -Format yyyy-MM-dd_HH-mm-ss') do set "TS=%%i"
set "LOGFILE=.crashes-tracking\lwjgl_%TS%.log"
set "HSFILE=.crashes-tracking\hs_err_%TS%.log"
set "GCFILE=.crashes-tracking\gc_%TS%.log"

REM Configura Windows Error Reporting dump em HKCU (nao requer admin)
reg add "HKCU\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\java.exe" /v DumpFolder /t REG_EXPAND_SZ /d "%~dp0.crashes-tracking\dumps" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\java.exe" /v DumpType /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\java.exe" /v DumpCount /t REG_DWORD /d 5 /f >nul 2>&1

echo [TRACKING] Log: %LOGFILE%
echo [TRACKING] GC Log: %GCFILE%
echo [TRACKING] Dumps: .crashes-tracking\dumps
echo [TRACKING] Starting game...

".\jre64\bin\java.exe" ^
  -Djava.awt.headless=true ^
  -Dorg.lwjgl.system.allocator=system ^
  -Dorg.lwjgl.util.DebugAll=true ^
  -Dzomboid.steam=1 ^
  -Dzomboid.znetlog=1 ^
  -XX:+CreateCoredumpOnCrash ^
  -XX:ErrorFile="%HSFILE%" ^
  -XX:-OmitStackTraceInFastThrow ^
  -XX:+UseZGC ^
  -Xlog:gc*:file="%GCFILE%":time,uptime,pid,tid,level,tags ^
  -Xmx3072m ^
  -Djava.library.path=./win64/;./ ^
  -cp %PZ_CLASSPATH% zombie.gameStates.MainScreenState %1 %2 > "%LOGFILE%" 2>&1

set EXIT=%ERRORLEVEL%

echo [TRACKING] Game exited with code: %EXIT%

IF %EXIT% NEQ 0 (
    echo. >> "%LOGFILE%"
    echo [CRASH DETECTED] Exit code: %EXIT% >> "%LOGFILE%"
    echo Timestamp: %TS% >> "%LOGFILE%"
    echo Check .crashes-tracking\dumps for Windows minidump >> "%LOGFILE%"
    echo [TRACKING] CRASH DETECTED - Exit code: %EXIT%
    echo [TRACKING] Check .crashes-tracking\dumps for minidump
)

PAUSE
