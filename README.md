# Windows Wallpaper Scheduler
Periodically changes the windows desktop wallpaper based on the current period of the day (dawn, day, dusk, night).

# Install
1. Download the files and extract them into a folder
2. Run `install.bat` as Adminstrator (`Right-Click` -> `Run as administrator`)
3. Enter your desired wallpaper location (e.g. `C:\Users\<your username>\Pictures\Wallpapers`)
4. Enter the desired period between wallpaper refreshes (in minutes)

From now on, Windows will refresh your desktop background wallpaper periodically.
The period is aligned to full hours, i.e. a 10 minute period leads to refreshes at 10:00, 10:10, 10:20 etc.

On each login, Windows will also try to update your local dawn and dusk times.

# Managing wallpapers
* after installing, populate the subfolders `dawn`, `day`, `dusk`, `night` inside the wallpapers folder (specified during installation)
* wallpapers need to be in `JPEG` format with `*.jpg` extension
* on each refresh, a random wallpaper will be selected from the subfolder corresponding to the current day period

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
