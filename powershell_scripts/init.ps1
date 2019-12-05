# Parse command line arguments
#param(
#    [Parameter(Mandatory=$true)][string]$wallpaper_base_dir
#)
$wallpaper_base_dir = "C:\MicroSD\Pictures\Desktop Wallpapers" 

# Load WallpaperScheduler module
$script_dir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. "$script_dir\wallpaper_scheduler.ps1"

# Invoke init
Wallpaper-Scheduler-Init $wallpaper_base_dir

# Refresh wallpaper
Wallpaper-Scheduler-Refresh-Wallpaper