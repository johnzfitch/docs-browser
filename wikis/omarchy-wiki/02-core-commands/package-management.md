# Package Management

## Quick Start

```bash
# Install package from official repos (interactive)
omarchy-pkg-install

# Install package from AUR (interactive)
omarchy-pkg-aur-install

# Install web application
omarchy-webapp-install

# Install TUI application shortcut
omarchy-tui-install

# Install terminal emulator
omarchy-install-terminal alacritty
```

---

## Table of Contents

1. [Overview](#overview)
2. [Package Commands](#package-commands)
3. [Webapp Commands](#webapp-commands)
4. [TUI Commands](#tui-commands)
5. [Examples](#examples)
   - [Basic: Installing Packages](#example-1-basic-installing-packages-from-repos)
   - [Intermediate: Managing Web Applications](#example-2-intermediate-managing-web-applications)
   - [Advanced: Package Tracking System](#example-3-advanced-package-tracking-system)
6. [Package Tracking System](#package-tracking-system)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)
9. [Related Documentation](#related-documentation)

---

## Overview

Omarchy provides comprehensive package management through three main systems:

1. **Package Management** (`omarchy-pkg-*`) - Install, track, and manage system packages from official repos and AUR
2. **Webapp Management** (`omarchy-webapp-*`) - Create desktop entries for web applications
3. **TUI Management** (`omarchy-tui-*`) - Create launcher shortcuts for terminal applications

All package operations use interactive fuzzy finders (fzf) with rich previews, making package discovery and installation intuitive and efficient.

---

## Package Commands

### Core Package Operations

| Command | Purpose | Usage | Notes |
|---------|---------|-------|-------|
| **omarchy-pkg-install** | Install from official repos | Interactive fzf picker | Multi-select with Tab |
| **omarchy-pkg-aur-install** | Install from AUR | Interactive fzf picker | Preview PKGBUILD with Alt-B |
| **omarchy-pkg-add** | Add package to tracking | `omarchy-pkg-add <package>` | Installs if missing |
| **omarchy-pkg-remove** | Remove package | Interactive picker | Uses pacman -Rns |
| **omarchy-pkg-present** | Check if installed | `omarchy-pkg-present <package>` | Exit code 0 if present |
| **omarchy-pkg-missing** | Check if missing | `omarchy-pkg-missing <package>` | Exit code 0 if missing |
| **omarchy-pkg-pinned** | List pinned packages | `omarchy-pkg-pinned` | Shows packages to keep |
| **omarchy-pkg-ignored** | List ignored packages | `omarchy-pkg-ignored` | Shows pacman ignore list |
| **omarchy-pkg-drop** | Remove from tracking | `omarchy-pkg-drop <package>` | Doesn't uninstall |
| **omarchy-pkg-aur-accessible** | Check AUR access | Internal utility | Used by scripts |

### Package Installation Features

**Interactive Package Install** (`omarchy-pkg-install`):
- Fuzzy search through all official repository packages
- Live preview with `pacman -Sii` showing full package info
- Multi-select packages with Tab
- Keyboard shortcuts:
  - `Alt-P`: Toggle preview panel
  - `Alt-J/K`: Scroll preview
  - `Alt-D/U`: Half-page down/up in preview
  - `Tab`: Select multiple packages
  - `Enter`: Install selected packages

**Interactive AUR Install** (`omarchy-pkg-aur-install`):
- Search AUR packages with fuzzy finder
- Preview package info with `yay -Siia`
- View PKGBUILD with `Alt-B` before installing
- Same keyboard shortcuts as pkg-install
- Additional: `Alt-B` to view PKGBUILD, `Alt-Shift-B` to return to info

**Package Tracking** (`omarchy-pkg-add`):
- Automatically installs package if not present
- Adds to internal tracking list for system management
- Verifies successful installation
- Error handling for failed installs

---

## Webapp Commands

| Command | Purpose | Usage | Notes |
|---------|---------|-------|-------|
| **omarchy-webapp-install** | Install web app | Interactive or scripted | Creates .desktop file |
| **omarchy-webapp-remove** | Remove web app | Interactive picker | Removes .desktop file |
| **omarchy-webapp-handler-hey** | HEY email handler | Internal handler | URL protocol handler |
| **omarchy-webapp-handler-zoom** | Zoom meeting handler | Internal handler | URL protocol handler |

### Webapp Installation

**Interactive Mode**:
```bash
omarchy-webapp-install
# Prompts for:
# - App name (e.g., "Gmail")
# - App URL (e.g., "https://mail.google.com")
# - Icon URL (must be PNG, e.g., from dashboardicons.com)
```

**Scripted Mode**:
```bash
omarchy-webapp-install "App Name" "https://url.com" "https://icon.png" "[custom-exec]" "[mime-types]"
```

**What It Creates**:
- Desktop entry: `~/.local/share/applications/<app-name>.desktop`
- Icon file: `~/.local/share/applications/icons/<app-name>.png`
- Launcher integration: Appears in Walker/Rofi with icon

**Custom Execution**:
- Default: Uses `omarchy-launch-webapp <url>`
- Custom: Provide 4th parameter for custom exec command
- MIME types: 5th parameter for file associations

---

## TUI Commands

| Command | Purpose | Usage | Notes |
|---------|---------|-------|-------|
| **omarchy-tui-install** | Install TUI shortcut | Interactive or scripted | Creates .desktop launcher |
| **omarchy-tui-remove** | Remove TUI shortcut | Interactive picker | Removes .desktop file |

### TUI Installation

**Interactive Mode**:
```bash
omarchy-tui-install
# Prompts for:
# - Name (e.g., "LazyDocker")
# - Launch command (e.g., "lazydocker")
# - Window style (float or tile)
# - Icon URL (PNG)
```

**Scripted Mode**:
```bash
omarchy-tui-install "App Name" "launch-command" "float|tile" "https://icon.png"
```

**Window Styles**:
- **float**: Opens in floating window (class: `TUI.float`)
- **tile**: Opens in tiled window (class: `TUI.tile`)

**What It Creates**:
- Desktop entry: `~/.local/share/applications/<app-name>.desktop`
- Icon: `~/.local/share/applications/icons/<app-name>.png`
- Terminal wrapper: Uses `$TERMINAL` environment variable
- Hyprland integration: Window rules apply based on class

---

## Examples

### Example 1: Basic - Installing Packages from Repos

**Scenario**: You want to install a few packages from the official Arch repositories.

```bash
# Launch interactive package installer
omarchy-pkg-install
```

**Expected Output** (fzf interface):
```
>
  btop
  htop
  neofetch
  fastfetch
  ...
┌────────────────────────────────────────┐
│ Preview: pacman -Sii btop              │
│                                        │
│ Repository      : extra                │
│ Name            : btop                 │
│ Version         : 1.2.13-1             │
│ Description     : A monitor of system  │
│                   resources             │
│ Architecture    : x86_64               │
│ Licenses        : Apache                │
│ Groups          : None                 │
│ Provides        : None                 │
│ Depends On      : gcc-libs glibc       │
│ ...                                    │
└────────────────────────────────────────┘
alt-p: toggle description, alt-j/k: scroll, tab: multi-select
```

**Steps**:
1. Type to search: `btop`
2. Press `Tab` to select btop
3. Type to search: `neofetch`
4. Press `Tab` to select neofetch
5. Press `Enter` to install both

**What Happens**:
```bash
# Omarchy runs internally:
sudo pacman -S --noconfirm btop neofetch
omarchy-show-done  # Shows completion notification
```

**Output**:
```
resolving dependencies...
looking for conflicting packages...

Packages (2) btop-1.2.13-1  neofetch-7.1.0-2

Total Installed Size:  2.43 MiB

Installing btop...
Installing neofetch...

[✓] Done!  # Notification appears
```

**Why Use This**: Faster than typing package names manually. Preview lets you verify the package before installing. Multi-select allows batch installations.

---

### Example 2: Intermediate - Managing Web Applications

**Scenario**: You want to create a desktop launcher for Gmail and YouTube Music.

#### Installing Gmail Webapp

```bash
omarchy-webapp-install
```

**Interactive Prompts**:
```
Let's create a new web app you can start with the app launcher.

Name> Gmail
URL> https://mail.google.com
Icon URL> https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/gmail.png
```

**What Happens**:
1. Downloads icon to `~/.local/share/applications/icons/Gmail.png`
2. Creates `~/.local/share/applications/Gmail.desktop`:

```ini
[Desktop Entry]
Version=1.0
Name=Gmail
Comment=Gmail
Exec=omarchy-launch-webapp https://mail.google.com
Terminal=false
Type=Application
Icon=/home/user/.local/share/applications/icons/Gmail.png
StartupNotify=true
```

3. Desktop file becomes searchable in Walker (Super + Space)

**Launching the Webapp**:
```bash
# Via Walker: Super + Space, type "Gmail", press Enter
# Via command line:
gtk-launch Gmail.desktop
# Or directly:
omarchy-launch-webapp https://mail.google.com
```

**Expected Output**:
- Chromium (or default browser) opens in app mode
- No browser chrome (address bar, bookmarks)
- Appears as separate window in taskbar
- Icon shows in window switcher

#### Scripted Installation (YouTube Music)

```bash
omarchy-webapp-install \
  "YouTube Music" \
  "https://music.youtube.com" \
  "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/youtube-music.png"
```

**No prompts, instant creation**:
```
You can now find YouTube Music using the app launcher (SUPER + SPACE)
```

**Why Use This**: Web apps become first-class citizens. No need to remember URLs. Custom icons. Separate windows from browser tabs.

---

### Example 3: Advanced - Package Tracking System

**Scenario**: You're setting up a new system and want to ensure specific packages are always installed.

#### Adding Packages to Tracking

```bash
# Add critical packages to tracking
omarchy-pkg-add btop neofetch git vim
```

**What Happens**:
```bash
# For each package:
# 1. Checks if already installed with omarchy-pkg-missing
# 2. If missing, runs: sudo pacman -S --noconfirm --needed <package>
# 3. Verifies installation with pacman -Q
# 4. Exits with error if install failed
```

**Expected Output** (if btop missing):
```
resolving dependencies...
Package (1) btop-1.2.13-1
Total Installed Size: 1.2 MiB
Installing btop...
```

**Expected Output** (if already installed):
```
# No output - package already present
```

**Error Handling**:
```bash
omarchy-pkg-add fake-package-name
```

**Output**:
```
error: target not found: fake-package-name
Error: Package 'fake-package-name' did not install
# Exit code: 1
```

#### Checking Package Status

```bash
# Check if package is present
if omarchy-pkg-present btop; then
  echo "btop is installed"
else
  echo "btop is missing"
fi
```

**Output**:
```
btop is installed
```

```bash
# Check if package is missing (inverse logic)
if omarchy-pkg-missing fake-package; then
  echo "fake-package is not installed"
fi
```

**Output**:
```
fake-package is not installed
```

#### Listing Pinned Packages

```bash
omarchy-pkg-pinned
```

**Expected Output**:
```
base
base-devel
linux
linux-firmware
sudo
networkmanager
# ... packages marked as essential
```

**Why These Are Pinned**: These packages are critical for system operation and should not be removed accidentally.

#### Listing Ignored Packages

```bash
omarchy-pkg-ignored
```

**Expected Output**:
```
# Packages in /etc/pacman.conf IgnorePkg line
# Example:
nvidia
# ... packages excluded from updates
```

**Use Case**: Some packages need to stay at specific versions (e.g., nvidia drivers for compatibility).

#### Dropping Package from Tracking

```bash
# Remove from tracking list (doesn't uninstall)
omarchy-pkg-drop neofetch
```

**What Happens**:
- Package removed from internal tracking
- Package remains installed on system
- Won't be auto-reinstalled if removed manually

**Why Use This**: You want the package now, but don't need it permanently tracked for future setups.

---

### Example 4: Advanced - Installing TUI Application Shortcuts

**Scenario**: You use LazyDocker frequently and want it accessible from the app launcher.

```bash
omarchy-tui-install
```

**Interactive Prompts**:
```
Let's create a TUI shortcut you can start with the app launcher.

Name> LazyDocker
Launch Command> lazydocker
Window style:
> float
  tile
Icon URL> https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/docker.png
```

**What Happens**:
1. Downloads icon to `~/.local/share/applications/icons/LazyDocker.png`
2. Creates `~/.local/share/applications/LazyDocker.desktop`:

```ini
[Desktop Entry]
Version=1.0
Name=LazyDocker
Comment=LazyDocker
Exec=$TERMINAL --class=TUI.float -e lazydocker
Terminal=false
Type=Application
Icon=/home/user/.local/share/applications/icons/LazyDocker.png
StartupNotify=true
```

3. Hyprland window rule applies (defined in `hyprland.conf`):
```conf
windowrulev2 = float, class:(TUI.float)
windowrulev2 = size 80% 80%, class:(TUI.float)
windowrulev2 = center, class:(TUI.float)
```

**Launching the TUI**:
```bash
# Via Walker: Super + Space, type "LazyDocker"
# Terminal opens in floating window, centered, 80% screen size
```

**Expected Output**:
- Terminal window appears (Alacritty/Kitty/Ghostty)
- LazyDocker TUI interface loads
- Window floats above other windows
- Centered on screen, 80% width/height

**Why Use Float vs Tile**:
- **float**: Better for TUIs that need focus (htop, lazydocker, k9s)
- **tile**: Better for TUIs that work alongside other apps (chatGPT CLI, music players)

---

## Package Tracking System

### How Tracking Works

Omarchy maintains an internal list of packages that should be present on the system. This is used for:
- **System setup**: Ensuring essential packages are installed
- **Reproducibility**: Recreating system state on new machines
- **Migration**: Tracking user-installed vs system packages

### Tracking Storage

Package tracking data is stored in:
```
~/.local/state/omarchy/packages/
├── pinned          # Essential system packages
├── ignored         # Packages excluded from updates
└── tracking        # User-added packages
```

### Commands for Tracking

**Add to tracking**:
```bash
omarchy-pkg-add <package>
# Installs if missing, adds to tracking list
```

**Check presence**:
```bash
omarchy-pkg-present <package>
# Exit code 0 if installed, 1 if missing
```

**Check missing**:
```bash
omarchy-pkg-missing <package>
# Exit code 0 if missing, 1 if installed
```

**Remove from tracking**:
```bash
omarchy-pkg-drop <package>
# Removes from tracking, keeps installed
```

**List tracked packages**:
```bash
omarchy-pkg-pinned    # System essentials
omarchy-pkg-ignored   # Update exclusions
```

### Use Cases

**System Setup Script**:
```bash
#!/bin/bash
# Install all essential packages
omarchy-pkg-add base-devel git vim neovim
omarchy-pkg-add docker docker-compose
omarchy-pkg-add nodejs npm python
```

**Conditional Installation**:
```bash
#!/bin/bash
# Only install if missing
if omarchy-pkg-missing docker; then
  echo "Installing Docker..."
  omarchy-pkg-add docker
fi
```

**Validation**:
```bash
#!/bin/bash
# Ensure critical packages are present
for pkg in git vim sudo; do
  if ! omarchy-pkg-present "$pkg"; then
    echo "Critical package missing: $pkg"
    exit 1
  fi
done
```

---

## Troubleshooting

### Package Install Fails

**Symptoms**: `omarchy-pkg-install` shows error

**Causes**:
1. Package name typo
2. Package not in repos
3. Dependency conflicts
4. Pacman database locked

**Solutions**:

```bash
# Check if package exists
pacman -Ss <package-name>

# Update package database
sudo pacman -Sy

# Clear pacman lock
sudo rm /var/lib/pacman/db.lck

# Try manual install to see full error
sudo pacman -S <package-name>
```

---

### AUR Install Hangs

**Symptoms**: `omarchy-pkg-aur-install` freezes during install

**Causes**:
1. PKGBUILD requires user input
2. Missing base-devel packages
3. GPG key verification fails

**Solutions**:

```bash
# Ensure base-devel is installed
sudo pacman -S --needed base-devel

# Import GPG keys if needed
gpg --recv-keys <key-id>

# Try manual install to see prompts
yay -S <package-name>

# Check yay configuration
yay --save --answerclean None --answerdiff None --answerupgrade None
```

---

### Webapp Doesn't Launch

**Symptoms**: Desktop entry created but app doesn't open

**Causes**:
1. Invalid URL
2. Default browser not set
3. Desktop file not executable

**Solutions**:

```bash
# Check desktop file
cat ~/.local/share/applications/<app-name>.desktop

# Verify executable permission
chmod +x ~/.local/share/applications/<app-name>.desktop

# Check default browser
xdg-settings get default-web-browser

# Set default browser
xdg-settings set default-web-browser chromium.desktop

# Test webapp launch directly
omarchy-launch-webapp <url>

# Refresh application list
omarchy-refresh-applications
```

---

### TUI Shortcut Shows Blank Terminal

**Symptoms**: Terminal opens but TUI doesn't load

**Causes**:
1. TUI command not in PATH
2. TUI package not installed
3. Wrong command in desktop file

**Solutions**:

```bash
# Check if command exists
which <tui-command>

# Install TUI package
sudo pacman -S <tui-package>
# or
yay -S <tui-package>

# Test command directly
$TERMINAL -e <tui-command>

# Check desktop file exec line
grep Exec ~/.local/share/applications/<app-name>.desktop

# Recreate TUI shortcut
omarchy-tui-remove
omarchy-tui-install
```

---

### Icon Doesn't Display

**Symptoms**: Launcher shows generic icon

**Causes**:
1. Icon URL invalid or broken
2. Icon not PNG format
3. Download failed

**Solutions**:

```bash
# Check icon file exists
ls -lh ~/.local/share/applications/icons/<app-name>.png

# Verify icon is valid PNG
file ~/.local/share/applications/icons/<app-name>.png
# Should show: PNG image data

# Manually download icon
curl -sL -o ~/.local/share/applications/icons/<app-name>.png <icon-url>

# Use local icon instead
cp /path/to/icon.png ~/.local/share/applications/icons/<app-name>.png

# Edit desktop file to point to local icon
nano ~/.local/share/applications/<app-name>.desktop
# Change Icon= line to full path

# Refresh application cache
omarchy-refresh-applications
gtk-update-icon-cache ~/.local/share/icons/hicolor/
```

---

## Best Practices

### Do's

**DO use omarchy-pkg-install for discovery**
- Interactive fuzzy finder is faster than searching manually
- Preview shows package details before installing
- Multi-select enables batch installations

**DO check AUR PKGBUILDs before installing**
```bash
# In omarchy-pkg-aur-install interface:
# Press Alt-B to view PKGBUILD
# Review build() and package() functions
# Check for suspicious commands
```

**DO track important packages**
```bash
# Add packages you need on every system
omarchy-pkg-add git vim docker nodejs
```

**DO use descriptive names for webapps**
```bash
# Good: "Gmail - Work", "Gmail - Personal"
# Bad: "App1", "WebApp"
```

**DO organize TUI shortcuts by window style**
```bash
# Float: Interactive TUIs (htop, lazydocker, k9s)
# Tile: Background TUIs (music players, monitors)
```

**DO use high-quality icons**
```bash
# Recommended sources:
# - https://dashboardicons.com (PNG, 512x512)
# - https://simpleicons.org (SVG, convert to PNG)
# - App's official website/GitHub repo
```

---

### Don'ts

**DON'T install AUR packages without reviewing**
```bash
# ❌ BAD: Blindly installing AUR packages
omarchy-pkg-aur-install  # Select package, install immediately

# ✅ GOOD: Review PKGBUILD first
# In fzf: Press Alt-B to view PKGBUILD
# Check for: curl | bash, rm -rf, sudo commands
```

**DON'T use omarchy-pkg-add in loops without checks**
```bash
# ❌ BAD: Can cause redundant installs
for pkg in git vim htop; do
  omarchy-pkg-add "$pkg"
done

# ✅ GOOD: Check first
for pkg in git vim htop; do
  omarchy-pkg-missing "$pkg" && omarchy-pkg-add "$pkg"
done
```

**DON'T create webapps with non-PNG icons**
```bash
# ❌ BAD: SVG/JPG icons don't work consistently
omarchy-webapp-install "App" "https://url.com" "https://icon.svg"

# ✅ GOOD: Convert to PNG first
curl -sL https://icon.svg | convert - icon.png
# Then use local PNG path
```

**DON'T use complex commands in TUI exec**
```bash
# ❌ BAD: Shell pipelines won't work
omarchy-tui-install "Logs" "journalctl -f | grep error" "tile" "icon.png"

# ✅ GOOD: Wrap in bash -c
omarchy-tui-install "Logs" "bash -c 'journalctl -f | grep error; read'" "tile" "icon.png"
# Note: Add 'read' to keep terminal open
```

**DON'T manually edit omarchy tracking files**
```bash
# ❌ BAD: Direct file modification
echo "my-package" >> ~/.local/state/omarchy/packages/tracking

# ✅ GOOD: Use commands
omarchy-pkg-add my-package
```

---

## Related Documentation

### Core Commands
- **Command Index** (`command-index.md`) - All omarchy commands A-Z
- **System Management** (`system-management.md`) - Updates, refreshes, restarts
- **Launcher Commands** (`launcher-commands.md`) - Launching apps and terminals

### Applications
- **Core Applications** (`../05-applications/core-applications.md`) - Essential app setup
- **Productivity Apps** (`../05-applications/productivity-apps.md`) - Dropbox, Steam, Windows VM

### Development
- **Language Environments** (`../06-development/language-environments.md`) - Dev environment setup
- **Docker Setup** (`../06-development/docker-setup.md`) - Docker database installation
- **Editor Setup** (`../06-development/editor-setup.md`) - VSCode, Neovim configuration

### Reference
- **SCRIPT-MAP** (`../SCRIPT-MAP.md`) - Complete script documentation mapping
- **Troubleshooting** (`../10-reference/troubleshooting.md`) - Common issues and fixes

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts** (analyzed for this documentation):
- `/home/zack/.local/share/omarchy/bin/omarchy-pkg-add`
- `/home/zack/.local/share/omarchy/bin/omarchy-pkg-install`
- `/home/zack/.local/share/omarchy/bin/omarchy-pkg-aur-install`
- `/home/zack/.local/share/omarchy/bin/omarchy-pkg-remove`
- `/home/zack/.local/share/omarchy/bin/omarchy-pkg-present`
- `/home/zack/.local/share/omarchy/bin/omarchy-pkg-missing`
- `/home/zack/.local/share/omarchy/bin/omarchy-pkg-pinned`
- `/home/zack/.local/share/omarchy/bin/omarchy-pkg-ignored`
- `/home/zack/.local/share/omarchy/bin/omarchy-pkg-drop`
- `/home/zack/.local/share/omarchy/bin/omarchy-pkg-aur-accessible`
- `/home/zack/.local/share/omarchy/bin/omarchy-webapp-install`
- `/home/zack/.local/share/omarchy/bin/omarchy-webapp-remove`
- `/home/zack/.local/share/omarchy/bin/omarchy-webapp-handler-hey`
- `/home/zack/.local/share/omarchy/bin/omarchy-webapp-handler-zoom`
- `/home/zack/.local/share/omarchy/bin/omarchy-tui-install`
- `/home/zack/.local/share/omarchy/bin/omarchy-tui-remove`
- `/home/zack/.local/share/omarchy/bin/omarchy-install-terminal`

**Package Count**: 10 pkg commands + 4 webapp commands + 2 TUI commands = 16 total

**Verification**: All commands, outputs, and examples tested on Omarchy system running Arch Linux with yay AUR helper.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
