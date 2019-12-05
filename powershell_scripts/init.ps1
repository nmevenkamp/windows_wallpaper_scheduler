# Load WallpaperScheduler module
$script_dir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
. "$script_dir\wallpaper_scheduler.ps1"

# Parse command line arguments
$wallpaper_base_dir = "C:\MicroSD\Pictures\Desktop Wallpapers"
$input_valid = $true
while (-Not $input_valid) {
    $wallpaper_base_dir = Read-Host -Prompt "Specify your desired wallpaper base directory"
    
    # remove enclosing quotes in case the user specified such
    $wallpaper_base_dir = $wallpaper_base_dir.Replace("'", "").Replace('"', '')

    try {
        New-Item -ItemType Directory -Force -Path $wallpaper_base_dir | Out-Null

        if ($(Test-Path $wallpaper_base_Dir -PathType Container)) {
            $input_valid = $true
        }
    } catch {
        $input_valid = $false
    }
}

# Invoke init
Wallpaper-Scheduler-Init $wallpaper_base_dir