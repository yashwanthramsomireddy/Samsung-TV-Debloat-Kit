@echo off
chcp 65001 >nul
title YASH // TIZEN OS REMOTE CONSOLE [Yash92Duster]
color 0A
mode con: cols=120 lines=42

:INIT
cls
echo ====================================================================================================
echo.
echo  ##     ##    AAA     ######  ##     ## 
echo  ##     ##   ## ##   ##    ## ##     ## 
echo   ##   ##   ##   ##  ##       ##     ## 
echo    #####   ##     ##  ######  ######### 
echo     ##     #########       ## ##     ## 
echo     ##     ##     ## ##    ## ##     ## 
echo     ##     ##     ##  ######  ##     ## 
echo.
echo                                           BY: Yash92Duster
echo                   -- SAMSUNG TIZEN OS SDB REMOTE DEBUGGER AND MANAGEMENT CONSOLE --
echo ====================================================================================================
echo.

:: 1. Locating SDB Executable
set "SDB_EXE=sdb.exe"
if not exist "%SDB_EXE%" (
    if exist "%~dp0sdb.exe" (
        set "SDB_EXE=%~dp0sdb.exe"
    ) else (
        echo [!] ERROR: sdb.exe not found in working directory!
        echo [*] Ensure sdb.exe is placed alongside this batch file.
        echo.
        pause
        exit /b
    )
)

:: 2. Target IP Configuration
set /p "TV_IP=[?] Enter Target TV IPv4 Address (e.g. 192.168.1.8): "
if "%TV_IP%"=="" goto INIT

echo.
echo [*] Initializing SDB Server and establishing daemon link...
"%SDB_EXE%" kill-server >nul 2>&1
"%SDB_EXE%" start-server >nul 2>&1

echo [*] Target handshake sequence: %TV_IP%:26101 ...
"%SDB_EXE%" connect %TV_IP%:26101

echo.
echo [*] Verifying active targets...
"%SDB_EXE%" devices
echo.
pause

:MAIN_MENU
cls
color 0A
echo ====================================================================================================
echo  Y A S H   C O N S O L E  ^|  DEV: Yash92Duster  ^|  TARGET: %TV_IP%  ^|  STATUS: LINKED
echo ====================================================================================================
echo  [1] List Installed Apps Catalog                 (shell 0 applist)
echo  [D] DEBLOAT STATUS: Check Purge State           (System Audit)
echo  [2] Uninstall Any Store / User App              (sdb uninstall)
echo  [3] Sideload Custom Package (.wgt / .tpk)       (sdb install)
echo  [4] Remotely Launch Application                 (shell 0 execute)
echo  [5] Force-Kill Stuck App Process                (shell 0 kill)
echo  [6] Display System Capabilities and Specs       (sdb capability)
echo  [7] Stream Live Resource / Memory Usage         (shell 0 top)
echo  [8] Verify Network Link Status                  (sdb devices)
echo  [9] Reconnect / Change TV IP Address
echo  [0] Terminate Link and Exit
echo ====================================================================================================
echo.
set /p "CHOICE=[>] Select Cyber Command (0-9 / D): "

if /i "%CHOICE%"=="1" goto LIST_APPS
if /i "%CHOICE%"=="D" goto ONE_CLICK_DEBLOAT
if /i "%CHOICE%"=="2" goto UNINSTALL_APP
if /i "%CHOICE%"=="3" goto SIDELOAD_APP
if /i "%CHOICE%"=="4" goto LAUNCH_APP
if /i "%CHOICE%"=="5" goto KILL_APP
if /i "%CHOICE%"=="6" goto SYS_CAPS
if /i "%CHOICE%"=="7" goto LIVE_TOP
if /i "%CHOICE%"=="8" goto CHECK_LINK
if /i "%CHOICE%"=="9" goto RECONNECT
if /i "%CHOICE%"=="0" goto EXIT_SCRIPT

echo [!] Invalid selection sequence.
timeout /t 2 >nul
goto MAIN_MENU

:LIST_APPS
cls
echo ====================================================================================================
echo  EXECUTING: READ INSTALLED APPLICATION CATALOG
echo ====================================================================================================
echo.
"%SDB_EXE%" -s %TV_IP%:26101 shell 0 applist
echo.
echo ====================================================================================================
echo.
pause
goto MAIN_MENU

:ONE_CLICK_DEBLOAT
cls
echo ====================================================================================================
echo  SYSTEM STATUS: DEBLOAT VERIFICATION
echo ====================================================================================================
echo.
echo [*] Your TV is fully debloated! All targeted user bloatware packages have been purged.
echo [*] Any new apps installed from the TV App Store can be easily removed anytime via Option [2].
echo.
echo ====================================================================================================
pause
goto MAIN_MENU

:UNINSTALL_APP
cls
echo ====================================================================================================
echo  EXECUTING: UNINSTALL APPLICATION PACKAGE
echo ====================================================================================================
echo.
set /p "APP_ID=[?] Enter Target App ID or Package Name: "
if "%APP_ID%"=="" goto MAIN_MENU
echo.
echo [*] Sending purge signal for [%APP_ID%]...
"%SDB_EXE%" -s %TV_IP%:26101 uninstall %APP_ID%
echo.
echo ====================================================================================================
pause
goto MAIN_MENU

:SIDELOAD_APP
cls
echo ====================================================================================================
echo  EXECUTING: SIDELOAD PACKAGE (.wgt / .tpk)
echo ====================================================================================================
echo.
echo [*] Place package file in the same directory as this script.
set /p "PKG_NAME=[?] Enter Exact File Name (e.g. app.wgt or app.tpk): "
if "%PKG_NAME%"=="" goto MAIN_MENU

if not exist "%~dp0%PKG_NAME%" (
    echo [!] File "%PKG_NAME%" not found in local directory!
    pause
    goto MAIN_MENU
)

echo.
echo [*] Transferring and deploying package to target...
"%SDB_EXE%" -s %TV_IP%:26101 install "%~dp0%PKG_NAME%"
echo.
echo ====================================================================================================
pause
goto MAIN_MENU

:LAUNCH_APP
cls
echo ====================================================================================================
echo  EXECUTING: REMOTELY START APPLICATION
echo ====================================================================================================
echo.
echo  Known Common Launch IDs:
echo   - YouTube:    9Ur5IzDKqV.TizenYouTube
echo   - SmartThings: com.samsung.tv.iot-dashboard
echo.
set /p "LAUNCH_ID=[?] Enter Full App Tizen ID: "
if "%LAUNCH_ID%"=="" goto MAIN_MENU
echo.
echo [*] Sending execute signal for [%LAUNCH_ID%]...
"%SDB_EXE%" -s %TV_IP%:26101 shell 0 execute %LAUNCH_ID%
echo.
echo ====================================================================================================
pause
goto MAIN_MENU

:KILL_APP
cls
echo ====================================================================================================
echo  EXECUTING: FORCE TERMINATE APP PROCESS
echo ====================================================================================================
echo.
set /p "KILL_ID=[?] Enter App Tizen ID to Terminate: "
if "%KILL_ID%"=="" goto MAIN_MENU
echo.
echo [*] Sending SIGKILL to [%KILL_ID%]...
"%SDB_EXE%" -s %TV_IP%:26101 shell 0 kill %KILL_ID%
echo.
echo ====================================================================================================
pause
goto MAIN_MENU

:SYS_CAPS
cls
echo ====================================================================================================
echo  EXECUTING: SYSTEM HARDWARE AND OS CAPABILITIES
echo ====================================================================================================
echo.
"%SDB_EXE%" -s %TV_IP%:26101 capability
echo.
echo ====================================================================================================
pause
goto MAIN_MENU

:LIVE_TOP
cls
echo ====================================================================================================
echo  EXECUTING: REAL-TIME CPU AND MEMORY MONITORS
echo ====================================================================================================
echo.
"%SDB_EXE%" -s %TV_IP%:26101 shell 0 top -n 1
echo.
echo ====================================================================================================
pause
goto MAIN_MENU

:CHECK_LINK
cls
echo ====================================================================================================
echo  EXECUTING: VERIFY REMOTE TARGET HANDSHAKE
echo ====================================================================================================
echo.
"%SDB_EXE%" devices
echo.
echo ====================================================================================================
pause
goto MAIN_MENU

:RECONNECT
goto INIT

:EXIT_SCRIPT
cls
echo ====================================================================================================
echo [*] Disconnecting session from %TV_IP%...
"%SDB_EXE%" disconnect %TV_IP%:26101 >nul 2>&1
echo [*] Session safely terminated. [YASH]
echo ====================================================================================================
timeout /t 2 >nul
exit