@echo off

:: Run wallpaper scheduler initialization via powershell
CALL :NORMALIZEPATH "%0\..\powershell_scripts\init.ps1"
SET PS_INIT_PATH=%RETVAL%
powershell -ExecutionPolicy ByPass -File %PS_INIT_PATH%

:: Set absolute powershell script paths
CALL :NORMALIZEPATH "%0\..\powershell_scripts\refresh_wallpaper.ps1"
SET PS_WP_REFRESH_PATH=%RETVAL%

CALL :NORMALIZEPATH "%0\..\powershell_scripts\refresh_dawn_dusk_times.ps1"
SET PS_DD_REFRESH_PATH=%RETVAL%

:: Add wallpaper refresh task (on logon)
SET TASK_NAME="WallpaperRefresh_LOGON_%USERNAME%"
SchTasks /Create /RU %USERNAME% /IT /SC ONLOGON /TN %TASK_NAME% /TR "powershell -ExecutionPolicy ByPass -WindowStyle hidden -File \"%PS_WP_REFRESH_PATH%\""

:: Add wallpaper refresh task (periodically)
SET /p INTERVAL="Enter desired number of minutes between each wallpaper refresh (between 1 and 1439): "
SET TASK_NAME="WallpaperRefesh_Period_%USERNAME%"
SchTasks /Create /RU %USERNAME% /IT /SC MINUTE /MO %INTERVAL% /TN %TASK_NAME% /TR "powershell -ExecutionPolicy ByPass -WindowStyle hidden -File \"%PS_WP_REFRESH_PATH%\"" /ST 09:00

:: Add dawn dusk time refresh task (on logon)
SET TASK_NAME="WallpaperRefreshDawnDusk_LOGON_%USERNAME%"
SchTasks /Create /RU %USERNAME% /IT /SC ONLOGON /TN %TASK_NAME% /TR "powershell -ExecutionPolicy ByPass -WindowStyle hidden -File \"%PS_DD_REFRESH_PATH%\""


:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B