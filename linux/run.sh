#!/usr/bin/env bash
# Runs the official Windows build of osu-trainer through Wine, in the same
# Wine prefix osu! (stable) itself runs in. osu-trainer's live map/mod
# detection reads osu!'s process memory directly, so both programs must be
# Windows processes inside the *same* Wine prefix for that to work.
#
# Defaults below match osu-winello (https://github.com/NelloKudo/osu-winello),
# the most common way to run osu! stable on Linux. Override WINE/WINEPREFIX
# if you use a different Wine setup (Lutris, a manual prefix, etc.) — just
# point them at whatever prefix your osu! is installed in.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$SCRIPT_DIR/osu-trainer"
RELEASE_API="https://api.github.com/repos/FunOrange/osu-trainer/releases/latest"

: "${WINEPREFIX:=$HOME/.local/share/wineprefixes/osu-wineprefix}"
: "${WINE:=$HOME/.local/share/osuconfig/wine-osu/bin/wine}"
export WINEPREFIX WINE
export WINESERVER="${WINE}server"

if [ ! -x "$WINE" ]; then
    echo "error: no wine binary at $WINE" >&2
    echo "Set WINE and WINEPREFIX to point at the Wine prefix your osu! install runs in." >&2
    exit 1
fi

# Fetch the official prebuilt release the first time (or if it's missing) —
# this is a WinForms/.NET Framework 4.8 app, not worth cross-compiling.
if [ ! -f "$INSTALL_DIR/osu-trainer.exe" ]; then
    echo "osu-trainer.exe not found, downloading latest release..."
    mkdir -p "$INSTALL_DIR"
    download_url=$(curl -sL "$RELEASE_API" | grep -oE '"browser_download_url": *"[^"]+\.zip"' | grep -oE 'https://[^"]+')
    if [ -z "$download_url" ]; then
        echo "error: couldn't find a release zip on GitHub" >&2
        exit 1
    fi
    tmp_zip="$(mktemp --suffix .zip)"
    curl -sL -o "$tmp_zip" "$download_url"
    tmp_extract="$(mktemp -d)"
    unzip -q "$tmp_zip" -d "$tmp_extract"
    # release zip contains a single top-level "osu-trainer-vX.Y.Z" folder
    inner_dir="$(find "$tmp_extract" -mindepth 1 -maxdepth 1 -type d | head -1)"
    cp -r "$inner_dir"/. "$INSTALL_DIR"/
    rm -rf "$tmp_zip" "$tmp_extract"
fi

# WinForms needs a real gdiplus.dll; Wine's built-in one is incomplete and
# throws DllNotFoundException on startup. Install the native one once.
if ! grep -q '"gdiplus"="native"' "$WINEPREFIX/user.reg" 2>/dev/null; then
    echo "Installing native gdiplus.dll into the Wine prefix (one-time)..."
    winetricks_bin="$(command -v winetricks || echo "$HOME/.local/share/osuconfig/winetricks")"
    "$winetricks_bin" -q gdiplus
fi

cd "$INSTALL_DIR"
exec "$WINE" osu-trainer.exe "$@"
