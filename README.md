# Windows Wallpaper Scheduler
Changes the windows desktop wallpaper based on the current period of the day (dawn, day, dusk, night).

# Install
1. Download the files and extract them into a folder
2. Run `install.bat` as Adminstrator (`Right-Click` -> `Run as administrator`)
3. Enter your desired wallpaper location (e.g. `C:\Users\<your username>\Pictures\Wallpapers`)
4. Enter the desired period between wallpaper refreshes (in minutes)

From now on, Windows will refresh your desktop background wallpaper periodically.
The period is aligned to full hours, i.e. a 10 minute period leads to refreshes at 10:00, 10:10, 10:20 etc.

# Managing wallpapers
* after installing, populate the subfolders `dawn`, `day`, `dusk`, `night` inside the wallpapers folder (specified during installation).
* wallpapers need to be in `JPEG` format with `*.jpg` extension
* on each refresh, a random wallpaper will be selected from the subfolder corresponding to the current day period

# Uninstall
Run `uninstall.bat` as Administrator (`Right-Click` -> `Run as administrator`)
