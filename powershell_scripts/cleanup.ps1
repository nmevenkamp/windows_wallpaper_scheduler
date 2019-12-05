# Load WallpaperScheduler module
$script_dir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. "$script_dir\wallpaper_scheduler.ps1"

# Invoke cleanup
Wallpaper-Scheduler-Cleanup