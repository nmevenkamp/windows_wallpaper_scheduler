@echo off

:: Set absolute powershell script paths
CALL :NORMALIZEPATH "%0\..\powershell_scripts\cleanup.ps1"
SET PS_CLEANUP_PATH=%RETVAL%

:: Run wallpaper scheduler cleanup via powershell
powershell -ExecutionPolicy ByPass -File "%PS_CLEANUP_PATH"

:: Remove scheduled tasks
SET TASK_NAME="WallpaperRefresh_LOGON_%USERNAME%"
SchTasks /Delete /TN %TASK_NAME% /F

SET TASK_NAME="WallpaperRefesh_Period_%USERNAME%"
SchTasks /Delete /TN %TASK_NAME% /F

SET TASK_NAME="WallpaperRefreshDawnDusk_LOGON_%USERNAME%"
SchTasks /Delete /TN %TASK_NAME% /F

:: Delete the program folder
start /b "" cmd /c rd /s /q "%~dp0"


:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B