# Windows Wallpaper Scheduler
Periodically changes the windows desktop wallpaper based on the current period of the day (dawn, day, dusk, night).

# Install
1. Download the files and extract them into a folder
2. Run `install.bat` as Adminstrator (`Right-Click` -> `Run as administrator`)
3. Enter your desired wallpaper location (e.g. `C:\Users\<your username>\Pictures\Wallpapers`)
4. Enter the desired refresh delay in minutes (e.g. `30`)

From now on, Windows will refresh your desktop background wallpaper periodically.
The period is aligned to full hours, i.e. a 10 minute period leads to refreshes at 10:00, 10:10, 10:20 etc.

On each login, Windows will also try to update your local dawn and dusk times.

# Managing wallpapers
* after installing, populate the subfolders `dawn`, `day`, `dusk`, `night` inside the wallpapers folder (specified during installation)
* wallpapers need to be in `JPEG` format with `*.jpg` extension
* on each refresh, a random wallpaper will be selected from the subfolder corresponding to your current day period

# Uninstall
Run `uninstall.bat` as Administrator (`Right-Click` -> `Run as administrator`)

# Configuration
The configuration file for this program is located at

```C:\Users\<your username>\AppData\Local\nmevenkamp\windows_wallpaper_scheduler\config.json```

It stores:
* wallpaper base directory
* last known dawn and dusk time for your location

You can manipulate the dawn and dusk times manually in case they are not up-to-date (e.g. no internet connection, fetch failed, ...).
If you modify the wallpaper base directory, you have to manually create the subfolders `dawn`, `day`, `dusk`, `night`.

The configuration file and directory are deleted when executing the `uninstall.bat`.

# Schedules
The periodic wallpaper refreshes and on login dawn & dusk time fetches are realized through schedules via Windows' `Task Scheduler`.
These are created by the `install.bat` batch file. You can view these schedules by starting the `Task Scheduler` app (e.g. via `Windows Search` in your `Taskbar`). In the top left corner of the app, click on `Task Scheduler Library`. Then you should see, among others, the following three tasks:
* `WallpaperRefresh_LOGON_<your username>`
* `WallpaperRefesh_Period_<your username>`
* `WallpaperRefreshDawnDusk_LOGON_<your username>`

These tasks execute the respective powershell scripts inside the `powershell_scripts` folder of this program.
You can force an immediate execution of each of these tasks via `Right-Click` -> `Run`.

These tasks are removed when executing the `uninstall.bat`.
