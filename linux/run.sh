#!/usr/bin/env bash
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
    inner_dir="$(find "$tmp_extract" -mindepth 1 -maxdepth 1 -type d | head -1)"
    cp -r "$inner_dir"/. "$INSTALL_DIR"/
    rm -rf "$tmp_zip" "$tmp_extract"
fi

if ! grep -q '"\*gdiplus"="native"' "$WINEPREFIX/user.reg" 2>/dev/null; then
    echo "Installing native gdiplus.dll into the Wine prefix (one-time)..."
    winetricks_bin="$(command -v winetricks || echo "$HOME/.local/share/osuconfig/winetricks")"
    "$winetricks_bin" -q gdiplus
fi

if ! grep -q 'Software\\\\Classes\\\\\.osz\]' "$WINEPREFIX/user.reg" "$WINEPREFIX/system.reg" 2>/dev/null; then
    echo "Registering .osz/.osz2/.osk file associations in the Wine prefix (one-time)..."
    tmp_reg="$(mktemp --suffix .reg)"
    cat > "$tmp_reg" <<'EOF'
REGEDIT4

[HKEY_CLASSES_ROOT\.osz]
@="osustable.File.osz"

[HKEY_CLASSES_ROOT\.osz2]
@="osustable.File.osz2"

[HKEY_CLASSES_ROOT\.osk]
@="osustable.File.osk"
EOF
    "$WINE" regedit "$tmp_reg"
    rm -f "$tmp_reg"
fi

cd "$INSTALL_DIR"
exec "$WINE" osu-trainer.exe "$@"
