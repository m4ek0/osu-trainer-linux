# Running osu-trainer on Linux

osu-trainer is a .NET Framework 4.8 WinForms app with no Linux build, so this
fork doesn't rewrite it — it runs the official Windows binary through **Wine**,
in the *same Wine prefix* your osu! (stable) install already uses. That last
part matters: osu-trainer's live map/mod detection works by reading osu!'s
process memory directly, and that only works across two Windows processes
sitting inside the same Wine instance.

## Requirements

- osu! (stable) already running under Wine. Tested against
  [osu-winello](https://github.com/NelloKudo/osu-winello), which is also the
  default this script assumes. If you use a different Wine setup (Lutris, a
  hand-rolled prefix, etc.), just point the `WINE` and `WINEPREFIX`
  environment variables at wherever osu! lives.
- `wine`, `winetricks`, `curl`, `unzip` available.

## Usage

```sh
./linux/run.sh
```

First run downloads the latest official release from
[FunOrange/osu-trainer releases](https://github.com/FunOrange/osu-trainer/releases)
into `linux/osu-trainer/`, and installs a native `gdiplus.dll` into the Wine
prefix if it isn't already there (Wine's built-in one is incomplete and
WinForms apps throw `DllNotFoundException` on startup without it).

To use a different Wine prefix (e.g. not osu-winello):

```sh
WINE=/path/to/wine WINEPREFIX=/path/to/prefix ./linux/run.sh
```

## What was verified

- The unmodified v1.8.0 Windows release launches and shows its window under
  osu-winello's Wine prefix once `gdiplus` is installed natively — no source
  changes needed.
- Live osu! memory detection (the actual point of the app) depends on osu!
  running in the same prefix at the same time; verify this yourself by
  opening osu!, selecting a map, and checking the trainer window picks it up.

## Known rough edges

- The bundled `updater.exe` self-update step runs on every launch and talks
  to the internet; it's not Linux/Wine-specific but is worth knowing about.
- `Microsoft.WindowsAPICodePack` (taskbar/shell integration) may not fully
  work under Wine — cosmetic only, doesn't block core functionality.
