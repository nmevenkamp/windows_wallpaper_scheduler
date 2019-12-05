@echo off

:: Run wallpaper scheduler cleanup via powershell
CALL :NORMALIZEPATH "%0\..\powershell_scripts\cleanup.ps1"
SET PS_CLEANUP_PATH=%RETVAL%
powershell -ExecutionPolicy ByPass -File %PS_CLEANUP_PATH%

:: Remove scheduled tasks
SET TASK_NAME="WallpaperRefresh_LOGON_%USERNAME%"
SchTasks /Delete /TN %TASK_NAME% /F

SET TASK_NAME="WallpaperRefesh_Period_%USERNAME%"
SchTasks /Delete /TN %TASK_NAME% /F

SET TASK_NAME="WallpaperRefreshDawnDusk_LOGON_%USERNAME%"
SchTasks /Delete /TN %TASK_NAME% /F


ECHO.
ECHO Uninstallation complete.
ECHO.
ECHO.
SET /p FOO="Press any key to continue..."


:: Delete the program folder
start /b "" cmd /c rd /s /q "%~dp0"


:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B