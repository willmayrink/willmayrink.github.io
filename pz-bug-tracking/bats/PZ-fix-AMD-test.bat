@echo off
REM Project Zomboid - Patch de teste (ATI meminfo skip)
REM Autor: Will - Bug Tracking Community
REM Data: 02/07/2026
REM
REM Este batch usa o projectzomboid.jar modificado (pula query ATI que causa crash no driver AMD)
REM + allocator=system (evita amplificacao do jemalloc)

set "PZ_DIR=D:\SteamLibrary\steamapps\common\ProjectZomboid"
set "JAVA=%PZ_DIR%\jre64\bin\java.exe"

echo Iniciando Project Zomboid com patch de crash AMD...
echo.
echo Fixes aplicados:
echo   [1] GameWindow.InitDisplay - query ATI meminfo pulada (buffer overrun AMD)
echo   [2] LWJGL allocator=system (jemalloc desabilitado)
echo   [3] Debug logging ativado
echo.
echo Logs em: %PZ_DIR%\.crashes-tracking\
echo.

"%JAVA%" ^
    -Djava.awt.headless=true ^
    -Dorg.lwjgl.system.allocator=system ^
    -Dorg.lwjgl.util.DebugAll=true ^
    -Dzomboid.steam=1 ^
    -Dzomboid.znetlog=1 ^
    -XX:+UseZGC ^
    -Xmx3072m ^
    -Djava.library.path="%PZ_DIR%\win64\";"%PZ_DIR%" ^
    -cp "%PZ_DIR%\projectzomboid.jar";"%PZ_DIR%" ^
    zombie.gameStates.MainScreenState

echo.
echo Codigo de saida: %errorlevel%
pause
