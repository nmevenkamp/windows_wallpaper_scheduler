@echo off

:: Set absolute powershell script paths
CALL :NORMALIZEPATH "%0\..\powershell_scripts\cleanup.ps1"
SET PS_CLEANUP_PATH=%RETVAL%

:: Run wallpaper scheduler cleanup via powershell
powershell -ExecutionPolicy ByPass -File "%PS_CLEANUP_PATH"

:: Remove scheduled tasks
SchTasks /Delete /TN "WallpaperScheduler: refresh WP (logon)" /F
SchTasks /Delete /TN "WallpaperScheduler: refresh WP (periodically)" /F
SchTasks /Delete /TN "WallpaperScheduler: refresh dawn & dusk times (logon)" /F

:: Delete the program folder
start /b "" cmd /c rd /s /q "%~dp0"



:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B