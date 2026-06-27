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
# Clone the repository
git clone https://github.com/Innomen/GenPass.git
cd GenPass

# Run the installer (no root needed; installs for the current user)
./install.sh
```

The installer is self-locating — run it from wherever you cloned the repo. It:

- installs a `genpass` command to `~/.local/bin/` (works in bash/zsh/fish)
- adds a "GenPass" entry to your application menu
- warns you if `~/.local/bin` isn't on your `PATH`, or if no clipboard tool is installed

To remove everything it added:

```bash
./uninstall.sh
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
