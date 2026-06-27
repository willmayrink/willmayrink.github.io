@setlocal enableextensions
@cd /d "%~dp0"
SET _JAVA_OPTIONS=

SET PZ_CLASSPATH=./;projectzomboid.jar
if not exist ".crashes-tracking" mkdir ".crashes-tracking"

for /f "tokens=2-4 delims=/ " %%a in ('date /t') do set "YYYY=%%c" & set "MM=%%a" & set "DD=%%b"
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set "HH=%%a" & set "MIN=%%b"
set "LOGFILE=.crashes-tracking\lwjgl_%YYYY%-%MM%-%DD%_%HH%-%MIN%.log"

".\jre64\bin\java.exe" -Djava.awt.headless=true -Dorg.lwjgl.system.allocator=system -Dorg.lwjgl.util.DebugAll=true -Dzomboid.steam=1 -Dzomboid.znetlog=1 -XX:-CreateCoredumpOnCrash -XX:-OmitStackTraceInFastThrow -XX:+UseZGC -Xmx3072m -Djava.library.path=./win64/;./ -cp %PZ_CLASSPATH% zombie.gameStates.MainScreenState %1 %2 2>"%LOGFILE%"

IF %ERRORLEVEL% NEQ 0 (
".\jre64\bin\java.exe" -Djava.awt.headless=true -Dorg.lwjgl.system.allocator=system -Dorg.lwjgl.util.DebugAll=true -Dzomboid.steam=1 -Dzomboid.znetlog=1 -XX:-CreateCoredumpOnCrash -XX:-OmitStackTraceInFastThrow -Xmx3072m -Djava.library.path=./win64/;./ -cp %PZ_CLASSPATH% zombie.gameStates.MainScreenState %1 %2 2>"%LOGFILE%"
)

PAUSE