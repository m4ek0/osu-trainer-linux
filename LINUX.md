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

First run downloads the latest release into `linux/osu-trainer/` and
installs a native `gdiplus.dll` into the prefix if missing (Wine's built-in
one throws `DllNotFoundException` on startup).

```sh
WINE=/path/to/wine WINEPREFIX=/path/to/prefix ./linux/run.sh
```

## Rough edges

- `updater.exe` still runs and phones home on every launch
- WindowsAPICodePack taskbar/shell bits may not work under Wine (cosmetic only)
