#!/usr/bin/env bash
# GenPass uninstaller — removes what install.sh added. Leaves the repo itself.
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"
LAUNCHER="$BIN_DIR/genpass"
DESKTOP="$APP_DIR/genpass.desktop"

removed=0
if [ -f "$LAUNCHER" ]; then
    rm -f "$LAUNCHER"
    echo "Removed CLI launcher: $LAUNCHER"
    removed=1
fi
if [ -f "$DESKTOP" ]; then
    rm -f "$DESKTOP"
    echo "Removed desktop entry: $DESKTOP"
    removed=1
fi

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true
fi

if [ "$removed" -eq 0 ]; then
    echo "Nothing to remove (GenPass was not installed for this user)."
else
    echo "Done. The repository itself was left untouched."
fi
