@echo off

:: Run wallpaper scheduler initialization via powershell
powershell -ExecutionPolicy ByPass -File init.ps1

:: Set absolute powershell script paths
CALL :NORMALIZEPATH "%0\..\powershell_scripts\refresh_wallpaper.ps1"
SET PS_WP_REFRESH_PATH=%RETVAL%

CALL :NORMALIZEPATH "%0\..\powershell_scripts\refresh_dawn_dusk_times.ps1"
SET PS_DD_REFRESH_PATH=%RETVAL%

:: Add wallpaper refresh task (each logon)
SchTasks /Create /RU %USERNAME% /IT /SC ONLOGON /TN "WallpaperScheduler: refresh WP (logon)" /TR "powershell -ExecutionPolicy ByPass -WindowStyle hidden -File \"%PS_WP_REFRESH_PATH%\""

:: Add wallpaper refresh task (every 30 min.)
SchTasks /Create /RU %USERNAME% /IT /SC MINUTE /MO 1 /TN "WallpaperScheduler: refresh WP (periodically)" /TR "powershell -ExecutionPolicy ByPass -WindowStyle hidden -File \"%PS_WP_REFRESH_PATH%\"" /ST 09:00

:: Add dawn dusk time refresh task (each logon)
SchTasks /Create /RU %USERNAME% /IT /SC ONLOGON /TN "WallpaperScheduler: refresh dawn & dusk times (logon)" /TR "powershell -ExecutionPolicy ByPass -WindowStyle hidden -File \"%PS_DD_REFRESH_PATH%\""


:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B