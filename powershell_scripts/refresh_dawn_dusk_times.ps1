# Load WallpaperScheduler module
$script_dir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. "$script_dir\wallpaper_scheduler.ps1"

# Invoke dawn and dusk time refresh
Wallpaper-Scheduler-Refresh-Dawn-Dusk-Times