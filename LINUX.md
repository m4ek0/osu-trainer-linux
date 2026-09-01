# Linux

Runs the official Windows build through Wine, in the same prefix osu!
(stable) runs in — live map/mod detection reads osu!'s process memory
directly, which only works if both are Windows processes in the same
Wine prefix.

Requires osu! (stable) already running under Wine. Defaults to
[osu-winello](https://github.com/NelloKudo/osu-winello) paths; otherwise
point `WINE`/`WINEPREFIX` at your prefix.

```sh
./linux/run.sh
```

First run downloads the latest release into `linux/osu-trainer/`, installs a
native `gdiplus.dll` into the prefix if missing (Wine's built-in one throws
`DllNotFoundException` on startup), and registers `.osz`/`.osz2`/`.osk` file
associations in the prefix registry if missing (osu-winello sets up a
Linux-side handler for these but not the in-prefix association that
`ShellExecute` needs when osu-trainer opens a generated edit).

```sh
WINE=/path/to/wine WINEPREFIX=/path/to/prefix ./linux/run.sh
```

## Rough edges

- `updater.exe` still runs and phones home on every launch
- WindowsAPICodePack taskbar/shell bits may not work under Wine (cosmetic only)
