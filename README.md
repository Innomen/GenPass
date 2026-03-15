# GenPass

A simple, universal password generator that creates passwords satisfying all common requirements.

## Features

- Generates 16-character passwords by default (customizable)
- Ensures at least one uppercase, one lowercase, one number, and one special character
- Avoids ambiguous characters (0/O, 1/l/I) to prevent confusion
- Uses only commonly accepted symbols (!@#$%^&*)
- Automatically copies generated password to clipboard
- Cross-platform clipboard support (Linux, macOS, Windows)

## Installation

```bash
# Clone or copy the repository
cd ~/Folders/Apps/GenPass

# Make sure the script is executable
chmod +x password_generator.py

# Optional: Add to your PATH for command-line usage
# Add this to your shell config (~/.bashrc, ~/.zshrc, or ~/.config/fish/config.fish):
# alias genpass='python3 ~/Folders/Apps/GenPass/password_generator.py'
```

## Usage

### Command Line

```bash
# Generate a 16-character password
genpass

# Generate a custom length password
genpass 20
```

### Desktop Application

Search for "GenPass" in your application menu (press Meta/Super key and type "genpass").

## Linux Clipboard Dependencies

For clipboard support on Linux, install one of:
- `xclip` (X11)
- `xsel` (X11)
- `wl-clipboard` (Wayland)

```bash
# Arch Linux
sudo pacman -S xclip

# Ubuntu/Debian
sudo apt install xclip

# Fedora
sudo dnf install xclip
```

## License

MIT License - Use however you want.
