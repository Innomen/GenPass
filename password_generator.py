#!/usr/bin/env python3
"""
Universal Password Generator - generates passwords that satisfy all the bullshit requirements
Now with clipboard support!
"""

import secrets
import sys
import subprocess
import platform

def copy_to_clipboard(text):
    """Copy text to clipboard using system commands"""
    system = platform.system()

    try:
        if system == "Darwin":  # macOS
            subprocess.run("pbcopy", universal_newlines=True, input=text, check=True)
            return True
        elif system == "Windows":  # Windows
            subprocess.run("clip", universal_newlines=True, input=text, check=True, shell=True)
            return True
        else:  # Linux and other Unix-like systems
            # Try xclip first
            try:
                subprocess.run(["xclip", "-selection", "clipboard"], input=text.encode('utf-8'), check=True)
                return True
            except (subprocess.CalledProcessError, FileNotFoundError):
                # Try xsel as fallback
                try:
                    subprocess.run(["xsel", "--clipboard", "--input"], input=text.encode('utf-8'), check=True)
                    return True
                except (subprocess.CalledProcessError, FileNotFoundError):
                    # Try wl-copy (Wayland)
                    try:
                        subprocess.run(["wl-copy"], input=text.encode('utf-8'), check=True)
                        return True
                    except (subprocess.CalledProcessError, FileNotFoundError):
                        return False
    except Exception:
        return False

def generate_password(length=16):
    """Generate a password that will make any stupid password validator happy"""

    # Characters that won't cause problems with most systems
    uppercase = "ABCDEFGHJKLMNPQRSTUVWXYZ"  # Removed O and I
    lowercase = "abcdefghijkmnopqrstuvwxyz"  # Removed l
    numbers = "23456789"  # Removed 0 and 1
    # Stick to common symbols that most systems accept
    symbols = "!@#$%^&*"

    # Ensure we have at least one of each required type.
    # secrets.choice uses the OS cryptographic RNG (safe for passwords).
    password = [
        secrets.choice(uppercase),    # At least one uppercase
        secrets.choice(lowercase),    # At least one lowercase
        secrets.choice(numbers),      # At least one number
        secrets.choice(symbols),      # At least one symbol
    ]

    # Fill the rest randomly from all character sets
    all_chars = uppercase + lowercase + numbers + symbols
    for _ in range(length - 4):
        password.append(secrets.choice(all_chars))

    # Shuffle so the required chars aren't always at the start.
    # Fisher-Yates using secrets.randbelow (secrets has no shuffle()).
    for i in range(len(password) - 1, 0, -1):
        j = secrets.randbelow(i + 1)
        password[i], password[j] = password[j], password[i]

    return ''.join(password)

if __name__ == "__main__":
    # Check if length argument provided
    length = 16
    if len(sys.argv) > 1:
        try:
            length = int(sys.argv[1])
            if length < 8:
                print("Warning: Length less than 8 might not satisfy some requirements")
        except ValueError:
            print("Invalid length, using default of 16")

    # Generate password
    password = generate_password(length)

    # Copy to clipboard
    clipboard_success = copy_to_clipboard(password)

    # Display password
    print(f"Password: {password}")

    if clipboard_success:
        print("✓ Password copied to clipboard")
    else:
        print("⚠ Could not copy to clipboard (install xclip, xsel, or wl-clipboard)")

    # Show what requirements it satisfies
    print(f"\nGenerated {length}-character password with:")
    print("✓ Uppercase letters")
    print("✓ Lowercase letters")
    print("✓ Numbers")
    print("✓ Special characters")
    print("✓ No ambiguous characters (0/O, 1/l/I)")
    print("✓ Common symbols only (no weird Unicode shit)")
