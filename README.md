# osu-trainer
A program that allows you to modify the difficulty of a beatmap **very quickly and easily**.

![](osu-trainer/images/gui.png)

This fork adds Linux support — see [Linux](#linux) below. Everything else is unchanged from [FunOrange/osu-trainer](https://github.com/FunOrange/osu-trainer).

# Download
https://github.com/FunOrange/osu-trainer/releases/latest

### Additional Notes
+ Maps can be created without alt tabbing if you make good use of the profiles and hotkeys
+ Search "osutrainer" in osu! to find all your generated maps
+ If you use this application a lot, you can end up using a lot of disk space. (333 mp3s * 3MB/mp3 = 1GB). To free up this space, delete the generated maps in osu, then click the Clean Up button in osu trainer.

# Linux
Runs the official Windows build through Wine, in the same prefix osu! (stable) runs in — live map/mod detection reads osu!'s process memory directly, which only works if both are Windows processes in the same Wine prefix.

### Requirements
+ osu! (stable) already running under Wine. Defaults to [osu-winello](https://github.com/NelloKudo/osu-winello) paths; otherwise point `WINE`/`WINEPREFIX` at your prefix.
+ `wine`, `winetricks`, `curl`, `unzip`

### Usage
```sh
./linux/run.sh
```
First run downloads the latest release into `linux/osu-trainer/`, installs a native `gdiplus.dll` into the prefix if missing (Wine's built-in one throws `DllNotFoundException` on startup), and registers `.osz`/`.osz2`/`.osk` file associations in the prefix registry if missing (osu-winello sets up a Linux-side handler for these but not the in-prefix association `ShellExecute` needs when osu-trainer opens a generated edit).

To use a different Wine prefix:
```sh
WINE=/path/to/wine WINEPREFIX=/path/to/prefix ./linux/run.sh
```

### Known rough edges
+ `updater.exe` still runs and phones home on every launch
+ WindowsAPICodePack taskbar/shell bits may not work under Wine (cosmetic only)

Special thanks to [Craftplacer](https://github.com/Craftplacer) for making the UI really nice and pretty

## Licenses
This project uses the following projects:
- [Font Awesome](https://fontawesome.com/), [licensed under the CC BY 4.0 License](https://creativecommons.org/licenses/by/4.0/)
- [Comfortaa](https://fonts.google.com/specimen/Comfortaa), [licensed under the Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)
- [osu-resources](https://github.com/ppy/osu-resources), [licensed under the CC BY 4.0 License](https://creativecommons.org/licenses/by-nc/4.0/legalcode)
- [oppai-ng](https://github.com/Francesco149/oppai-ng), [licensed under the Unlicense](https://github.com/Francesco149/oppai-ng/blob/master/UNLICENSE)
- [ProcessMemoryDataFinder](https://github.com/Piotrekol/ProcessMemoryDataFinder), [licensed under GPL-3.0](https://github.com/Piotrekol/ProcessMemoryDataFinder/blob/master/LICENSE)
- [LAME](https://lame.sourceforge.io/)
