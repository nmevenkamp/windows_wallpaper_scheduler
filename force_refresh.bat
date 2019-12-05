@ECHO OFF

:: Run wallpaper refresh via powershell
CALL :NORMALIZEPATH %0\..\powershell_scripts\refresh_wallpaper.ps1
SET PS_REFRESH_WP_PATH=%RETVAL%
powershell -ExecutionPolicy ByPass -File %PS_REFRESH_WP_PATH%


ECHO.
ECHO.
SET /p FOO="Press any key to continue..."


:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B