@echo off


:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:-------------------------------------- 


:: Run wallpaper scheduler cleanup via powershell
CALL :NORMALIZEPATH %0\..\powershell_scripts\cleanup.ps1
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
ECHO Local app data removed.
ECHO Task Scheduler cleaned up.
ECHO.
ECHO.
SET /p FOO="Proceeding to delete program files. Press any key to continue..."


:: Delete the program folder
start /b "" cmd /c rd /s /q "%~dp0"


:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B