Function Wallpaper-Scheduler-Init($wallpaper_base_dir) {
    ECHO "Initializing wallpaper scheduler..."

    $config_filename = [WallpaperScheduler]::get_config_filename()
    
    # create wallpaper base and sub dirs
    New-Item -ItemType Directory -Force -Path $wallpaper_base_dir | Out-Null
    ECHO "Created wallpaper base directory '$wallpaper_base_dir'."
    $day_sections = "dawn", "day", "dusk", "night"
    foreach ($day_section in $day_sections) {
        $wallpaper_dir = Join-Path -Path $wallpaper_base_dir -ChildPath $day_section
        New-Item -ItemType Directory -Force -Path $wallpaper_dir | Out-Null
        ECHO "Created wallpaper sub directory '$wallpaper_dir'."
    }

    # create app data directory
    $app_dir = [WallpaperScheduler]::get_app_dir()
    New-Item -ItemType Directory -Force -Path $app_dir | Out-Null
    ECHO "Created app data directory '$app_dir'."

    # fetch local weather information from wttr
    ECHO "Fetching local weather information..."
    $wttr_output = [TimeManager]::fetch_wttr_output()
    ECHO "Fetching local weather information: done."

    # parse dawn and dusk times
    $t_dawn = [TimeManager]::get_local_day_section_time($wttr_output, "dawn")
    $t_dusk = [TimeManager]::get_local_day_section_time($wttr_output, "dusk")
    $t_cur = Get-Date -Format "HH:mm"
    ECHO "Parsed current local dawn and dusk times."
    ECHO "Dawn time:    $t_dawn"
    ECHO "Dusk time:    $t_dusk"
    ECHO "Current time: $t_cur"

    $config = [ordered]@{
        wallpaper_base_dir = $wallpaper_base_dir
        t_dawn = $t_dawn
        t_dusk = $t_dusk
    }

    $config | ConvertTo-Json -depth 100 | Out-File $config_filename
    ECHO "Config written to '$config_filename'."

    ECHO "Initializing wallpaper scheduler: done."
}


Function Wallpaper-Scheduler-Cleanup {
    ECHO "Cleaning up..."
    
    # remove app data directory
    $app_dir = [WallpaperScheduler]::get_app_dir()
    Remove-Item -Recurse -Force $app_dir
    ECHO "Removed app data directory '$app_dir'."

    # check if parent directory (related to author) is now empty. If so, delete it as well
    $author_dir = [WallpaperScheduler]::get_author_dir()
    if ((Get-ChildItem $author_dir | Measure-Object).count -eq 0) {
        Remove-Item $author_dir
        ECHO "Removed author directory '$author_dir'."
    }

    ECHO "Cleaning up: done."
}


Function Wallpaper-Scheduler-Refresh-Wallpaper {
    ECHO "Refreshing wallpaper..."

    # determine current day section (dawn, day, dusk, night)
    $current_day_section = [WallpaperScheduler]::get_current_day_section()
    ECHO "Current day section: $current_day_section"    

    # determine wallpaper directory based on current day section
    $wallpaper_dir = Join-Path -Path $([WallpaperScheduler]::get_wallpaper_base_dir()) -ChildPath $current_day_section
    ECHO "Wallpaper directory: '$wallpaper_dir'"

    # randomly select a .jpg from the specified wallpaper folder
    $wallpaper_filename = (Get-ChildItem $wallpaper_dir -R -File -Include "*.jpg" | Get-Random).FullName
    ECHO "Selected wallpaper: $wallpaper_filename"

    # set the selected wallpaper as desktop background
    [WallpaperScheduler]::set_wallpaper($wallpaper_filename)
    ECHO "Wallpaper set."

    ECHO "Refreshing wallpaper: done."
}


Function Wallpaper-Scheduler-Refresh-Dawn-Dusk-Times {
    ECHO "Refreshing dawn and dusk times..."

    # fetch local weather information from wttr
    $wttr_output = [TimeManager]::fetch_wttr_output()
    ECHO "Fetched local weather information."

    # parse dawn and dusk times
    $t_dawn = [TimeManager]::get_local_day_section_time($wttr_output, "dawn")
    $t_dusk = [TimeManager]::get_local_day_section_time($wttr_output, "dusk")
    $t_cur = Get-Date -Format "HH:mm"
    ECHO "Parsed current local dawn and dusk times."
    ECHO "Dawn time:    $t_dawn"
    ECHO "Dusk time:    $t_dusk"
    ECHO "Current time: $t_cur"

    # read config
    $config_filename = [WallpaperScheduler]::get_config_filename()
    $config = Get-Content $config_filename | ConvertFrom-Json
    ECHO "Config read."

    # update dawn and dusk times
    $config.t_dawn = $t_dawn
    $config.t_dusk = $t_dusk
    ECHO "Dawn and dusk times overwritten."

    # write config to disk
    $config | ConvertTo-Json -depth 100 | Set-Content $config_filename
    ECHO "Updated config saved to '$config_filename'."

    ECHO "Refreshing dawn and dusk times: done."
}


class WallpaperScheduler {
    static [String] $author   = "nmevenkamp"
    static [String] $app_name = "wallpaper_scheduler"

    static [int] $dawn_dusk_delta_minutes = 45

    static set_wallpaper([String] $filename) {
        Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value $filename
        for ($i=0; $i -lt 5; $i++) {
            rundll32.exe user32.dll, UpdatePerUserSystemParameters
        }
    }

    static [String] get_author_dir() {
        return Join-Path $env:LOCALAPPDATA -ChildPath $([WallpaperScheduler]::author)
    }

    static [String] get_app_dir() {
        return $([WallpaperScheduler]::get_author_dir()) | Join-Path -ChildPath $([WallpaperScheduler]::app_name)
    }

    static [String] get_config_filename() {
        return Join-Path -Path $([WallpaperScheduler]::get_app_dir()) -ChildPath "config.json"
    }
    
    static [String] get_wallpaper_base_dir() {
        $config = Get-Content $([WallpaperScheduler]::get_config_filename()) | ConvertFrom-Json
        return $config.wallpaper_base_dir
    }

    static [String] get_current_day_section() {
        # fetch current time (HH:mm)
        $t_cur = Get-Date -Format "HH:mm"

        # read config
        $config = Get-Content $([WallpaperScheduler]::get_config_filename()) | ConvertFrom-Json

        return [TimeManager]::get_day_section($t_cur, $config.t_dawn, $config.t_dusk, $([WallpaperScheduler]::dawn_dusk_delta_minutes))
    }
}

class TimeManager {
    static [String] get_local_day_section_time($wttr_output, $day_section) {
        $pattern = "$day_section[^0]*0m[\ ]*[0-9][0-9]:[0-9][0-9]"
        $res = $wttr_output | Select-String -Pattern $pattern | foreach {$_.Matches}
        return $res.value.Substring($res.length - 5)
    }

    static [String] fetch_wttr_output() {
        return $wttr_output = (curl http://wttr.in/?format=v2 -UserAgent "curl" -UseBasicParsing).Content
    }

    static [String] get_day_section([String] $t_cur, [String] $t_dawn, [String] $t_dusk, [int] $m_delta) {
        $m_tot_dawn = [TimeManager]::convert_clock_time_to_minutes($t_dawn)
        $m_tot_dusk = [TimeManager]::convert_clock_time_to_minutes($t_dusk)

        $m_tot_dawn_min = $m_tot_dawn - $m_delta
        $m_tot_dawn_max = $m_tot_dawn + $m_delta
    
        $m_tot_dusk_min = $m_tot_dusk - $m_delta
        $m_tot_dusk_max = $m_tot_dusk + $m_delta

        $m_tot_cur = [TimeManager]::convert_clock_time_to_minutes($t_cur)

        $day_section = "day"
        if ($m_tot_cur -ge $m_tot_dawn_min -and $m_tot_cur -le $m_tot_dawn_max) {
            $day_section = "dawn"
        } elseif ($m_tot_cur -ge $m_tot_dusk_min -and $m_tot_cur -le $m_tot_dusk_max) {
            $day_section = "dusk"
        } elseif ($m_tot_cur -ge $m_tot_dawn_max -and $m_tot_cur -lt $m_tot_dusk_min) {
            $day_section = "day"
        } else {
            $day_section = "night"
        }

        return $day_section
    }

    static [int] convert_clock_time_to_minutes([String] $clock_time) {
        $parts = $clock_time.Split(":")

        $h = [convert]::ToInt32($parts[0], 10)
        $m = [convert]::ToInt32($parts[1], 10)

        $m_tot = $h * 60 + $m

        return $m_tot
    }
}

ECHO "Wallpaper Scheduler loaded."