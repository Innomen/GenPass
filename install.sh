#!/usr/bin/env bash
# GenPass installer — sets up both the CLI command and the desktop menu entry.
# Self-locating: works wherever you cloned the repo. No hardcoded paths.
set -euo pipefail

# Resolve the directory this script lives in (the repo root), following symlinks.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
REPO_DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
SCRIPT="$REPO_DIR/password_generator.py"

if [ ! -f "$SCRIPT" ]; then
    echo "Error: password_generator.py not found next to this installer." >&2
    exit 1
fi

BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"
LAUNCHER="$BIN_DIR/genpass"
DESKTOP="$APP_DIR/genpass.desktop"

mkdir -p "$BIN_DIR" "$APP_DIR"

# --- CLI launcher --------------------------------------------------------
# A tiny wrapper rather than an alias, so it works in any shell (bash/zsh/fish)
# and from anywhere. Passes all arguments through (e.g. `genpass 20`).
cat > "$LAUNCHER" <<EOF
#!/usr/bin/env bash
exec python3 "$SCRIPT" "\$@"
EOF
chmod +x "$LAUNCHER"
echo "Installed CLI launcher: $LAUNCHER"

# --- Desktop menu entry --------------------------------------------------
# Generate from the template, filling in the real path on THIS machine.
if [ -f "$REPO_DIR/genpass.desktop" ]; then
    sed "s|__EXEC__|python3 \"$SCRIPT\"|" "$REPO_DIR/genpass.desktop" > "$DESKTOP"
else
    # Fallback if the template is missing.
    cat > "$DESKTOP" <<EOF
[Desktop Entry]
Name=GenPass
Comment=Universal Password Generator
Exec=python3 "$SCRIPT"
Type=Application
Terminal=true
Icon=dialog-password
Categories=Utility;Security;
Keywords=password;generator;security;clipboard;
Name[en_US]=GenPass
EOF
fi
chmod +x "$DESKTOP"
echo "Installed desktop entry: $DESKTOP"

# Refresh the menu database if the tool is available.
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true
    echo "Refreshed application menu database."
fi

# --- Friendly post-install checks ---------------------------------------
# Warn if ~/.local/bin isn't on PATH (the CLI won't be found otherwise).
case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *) echo
       echo "Note: $BIN_DIR is not on your PATH."
       echo "  bash/zsh: add  export PATH=\"\$HOME/.local/bin:\$PATH\"  to your shell rc"
       echo "  fish:     run  fish_add_path \$HOME/.local/bin" ;;
esac

# Warn if no clipboard tool is present (clipboard copy will silently no-op).
if ! command -v xclip >/dev/null 2>&1 \
   && ! command -v xsel >/dev/null 2>&1 \
   && ! command -v wl-copy >/dev/null 2>&1; then
    echo
    echo "Note: no clipboard tool found. For auto-copy, install one of:"
    echo "  xclip / xsel (X11)  or  wl-clipboard (Wayland)"
fi

echo
echo "Done. Run 'genpass' in a terminal, or search 'GenPass' in your app menu."
