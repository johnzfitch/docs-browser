# Omarchy Quick Reference

**Purpose:** Fast answers for common tasks and commands
**Use Case:** "How do I..." questions

*Last Updated: 2025-10-21*

---

## Quick Start (30-Second Guide)

```bash
# Main menu
omarchy-menu

# Change theme
omarchy-theme-set catppuccin

# Install package
omarchy-pkg-install

# Take screenshot
omarchy-cmd-screenshot smart

# Update system
omarchy-update

# Search docs
grep -r "keyword" /home/zack/dev/lib/omarchy-archive/ --include="*.md"
```

---

## Table of Contents

- [Common Tasks](#common-tasks)
- [Essential Commands](#essential-commands)
- [Keyboard Shortcuts](#keyboard-shortcuts)
- [Configuration Files](#configuration-files)
- [Troubleshooting Quick Fixes](#troubleshooting-quick-fixes)
- [Package Lists](#package-lists)

---

## Common Tasks

### How Do I...

#### Change the Theme?
```bash
# List available themes
omarchy-theme-list

# Switch to specific theme
omarchy-theme-set catppuccin

# Cycle to next theme
omarchy-theme-next
```
**See:** [Theme System](../03-theming/theme-system.md)

#### Install Software?
```bash
# From official repos
omarchy-pkg-install

# From AUR
omarchy-pkg-aur-install

# Web applications
omarchy-webapp-install

# Development environments
omarchy-install-dev-env ruby
```
**See:** [Package Management](../02-core-commands/package-management.md)

#### Take Screenshots?
```bash
# With editing
omarchy-cmd-screenshot smart

# Direct to clipboard
omarchy-cmd-screenshot smart clipboard

# Screen recording
omarchy-cmd-screenrecord
```
**See:** [Screenshot & Screenrecord](../08-utilities/screenshot-screenrecord.md)

#### Change Fonts?
```bash
# List available fonts
omarchy-font-list

# Set font
omarchy-font-set "JetBrains Mono Nerd Font"
```
**See:** [Fonts](../03-theming/fonts.md)

#### Update Omarchy?
```bash
# Full system update
omarchy-update

# Update specific component
omarchy-refresh-config
```
**See:** [System Management](../02-core-commands/system-management.md)

#### Share Files?
```bash
# Share from clipboard
omarchy-cmd-share clipboard

# Share file
omarchy-cmd-share file

# Share folder
omarchy-cmd-share folder
```
**See:** [File Sharing](../08-utilities/file-sharing.md)

#### Lock Screen?
```bash
# Lock immediately
omarchy-lock-screen

# Or use keybinding: SUPER + L
```
**See:** [Security & Auth](../07-system-setup/security-auth.md)

#### Restart Services?
```bash
# Restart walker
omarchy-restart-walker

# Restart waybar
omarchy-restart-waybar

# Restart audio (pipewire)
omarchy-restart-pipewire
```
**See:** [System Management](../02-core-commands/system-management.md)

#### Configure Hardware?
```bash
# Audio
wiremix

# WiFi
omarchy-launch-wifi

# Bluetooth
blueberry

# Monitors
$EDITOR ~/.config/hypr/monitors.conf
```
**See:** [System Setup](../07-system-setup/)

#### Set Up Development Environment?
```bash
# Install language runtime
omarchy-install-dev-env ruby
omarchy-install-dev-env node
omarchy-install-dev-env python

# Install Docker databases
omarchy-install-docker-dbs
```
**See:** [Development](../06-development/)

---

## Essential Commands

### By Category

#### Theme Commands
```bash
omarchy-theme-list         # List themes
omarchy-theme-set <name>   # Set theme
omarchy-theme-next         # Next theme
omarchy-theme-current      # Show current
omarchy-theme-bg-next      # Next background
```

#### Package Commands
```bash
omarchy-pkg-install        # Install from repos
omarchy-pkg-aur-install    # Install from AUR
omarchy-pkg-remove         # Remove package
omarchy-webapp-install     # Install web app
omarchy-tui-install        # Install TUI app
```

#### Launch Commands
```bash
omarchy-launch-browser     # Open browser
omarchy-launch-editor      # Open editor
omarchy-launch-walker      # Open launcher
omarchy-menu               # Open main menu
```

#### Capture Commands
```bash
omarchy-cmd-screenshot smart          # Screenshot
omarchy-cmd-screenrecord              # Screen record
omarchy-cmd-screenrecord --with-audio  # With audio
hyprpicker -a                         # Color picker
```

#### System Commands
```bash
omarchy-update             # Update system
omarchy-refresh-config     # Refresh configs
omarchy-restart-walker     # Restart walker
omarchy-lock-screen        # Lock screen
```

---

## Keyboard Shortcuts

### MMO-Style Hotbar (Data-Driven, Left-Hand Ergonomic)

**Most Frequent Apps (SUPER + QWER/ASDF):**
```ini
SUPER + A                  → Terminal (#1 frequency, 20+/day)
SUPER + Q                  → Browser (private) (#3 frequency)
SUPER + E                  → Editor/Neovim (#2 frequency)
SUPER + R                  → File Manager (alt)
SUPER + S                  → Screenshot (frequent utility)
SUPER + F                  → File Manager (#4 frequency)

SUPER + RETURN             → Terminal (backup binding)
SHIFT + F1                 → Fullscreen toggle
```

**Window Operations (SUPER):**
```ini
SUPER + X                  → Close window (X=eXit, safe from CTRL+W accidents)
SUPER + SHIFT + X          → Close all windows in workspace
SUPER + SHIFT + Q          → Quit window (alternative close)
SUPER + T                  → Toggle floating
SUPER + G                  → Toggle grouping
SUPER + J                  → Toggle split
```

**MMO Navigation (ALT + WASD):**
```ini
ALT + W                    → Focus Up
ALT + A                    → Focus Left
ALT + S                    → Focus Down
ALT + D                    → Focus Right

ALT + SHIFT + W/A/S/D      → Swap window in direction

SUPER + arrows             → Focus movement (backup)
SUPER + SHIFT + arrows     → Swap windows (backup)
```

**Workspaces:**
```ini
SUPER + 1-9                → Switch workspace
SUPER + SHIFT + 1-9        → Move window to workspace
SUPER + TAB                → Next workspace
SUPER + SHIFT + TAB        → Previous workspace
```

**Screenshots:**
```ini
SUPER + S                  → Screenshot (MMO hotbar)
PRINT                      → Screenshot (traditional)
CTRL + `                   → Screenshot (alternative)
ALT + PRINT                → Screen record menu
```

**System:**
```ini
SUPER + SPACE              → Walker (app launcher)
SUPER + ESC                → Power menu
SUPER + K                  → Show all keybindings
SUPER + O                  → Omarchy docs
SUPER + H                  → Hyprland docs
```

**Full list:** `omarchy-menu-keybindings` or **SUPER + K**

**See:**
- [MMO Keyboard Layout Design](../omarchy_mmo_keyboard_layout.md)
- [Keybindings Customization](../09-customization/keybindings.md)

---

## Configuration Files

### Locations

```bash
# Omarchy configs
~/.config/omarchy/

# Current theme
~/.config/omarchy/current/theme/

# Hyprland
~/.config/hypr/hyprland.conf
~/.config/hypr/monitors.conf
~/.config/hypr/bindings.conf

# Walker
~/.config/walker/config.toml

# Waybar
~/.config/waybar/config.jsonc

# Terminal (varies)
~/.config/alacritty/alacritty.toml
~/.config/kitty/kitty.conf
~/.config/ghostty/config

# Editor
~/.config/nvim/
~/.config/Code/User/settings.json
```

**See:** [Config Management](../09-customization/config-management.md)

### Editing Configs

```bash
# Edit and auto-reload
omarchy-menu → Setup → Config

# Or directly
nvim ~/.config/hypr/hyprland.conf
hyprctl reload
```

---

## Troubleshooting Quick Fixes

### Common Issues

#### Theme Not Applying
```bash
# Refresh theme
omarchy-theme-set $(omarchy-theme-current)

# Restart affected services
omarchy-restart-walker
omarchy-restart-waybar
```

#### Walker Won't Launch
```bash
# Restart walker service
omarchy-restart-walker

# Check if running
pgrep walker

# View logs
journalctl --user -u walker -n 50
```

#### Audio Not Working
```bash
# Restart pipewire
omarchy-restart-pipewire

# Check status
systemctl --user status pipewire pipewire-pulse wireplumber

# Open mixer
wiremix
```

#### WiFi Not Connecting
```bash
# Unblock and restart
rfkill unblock wifi
omarchy-restart-wifi

# Open network manager
omarchy-launch-wifi
```

#### Screen Lock Not Working
```bash
# Restart hypridle
omarchy-restart-hypridle

# Check config
cat ~/.config/hypr/hypridle.conf
```

#### Update Failed
```bash
# Check for partial updates
omarchy-update-system-pkgs

# Check mirrors
omarchy-refresh-pacman-mirrorlist

# View update logs
omarchy-upload-log
```

**Full guide:** [Troubleshooting](./troubleshooting.md)

---

## Package Lists

### Base Packages (149 total)

**Core System:**
- hyprland, hypridle, hyprlock, hyprsunset, hyprpicker
- walker, waybar, mako, swayosd, swaybg
- alacritty, kitty (terminals)

**Development:**
- docker, docker-compose, docker-buildx
- mise, lazygit, lazydocker
- github-cli, nvim

**Media:**
- obs-studio, kdenlive, mpv
- satty, grim, slurp
- gpu-screen-recorder

**Productivity:**
- obsidian, typora, xournalpp
- libreoffice, evince
- nautilus, imv, pinta

**Utilities:**
- bat, eza, fd, fzf, ripgrep
- btop, dust, tldr
- localsend, signal-desktop

**See:** `/home/zack/.local/share/omarchy/install/omarchy-base.packages`

---

## Command Index by Prefix

### omarchy-cmd-*
```
apple-display-brightness   → Adjust Apple display
audio-switch              → Switch audio output
close-all-windows         → Close all windows
first-run                 → First-run wizard
screenrecord              → Record screen
screenshot                → Take screenshot
screensaver               → Control screensaver
share                     → Share files/clipboard
terminal-cwd              → Get terminal CWD
```

### omarchy-install-*
```
chromium-google-account   → Google account setup
dev-env                   → Dev environments
docker-dbs                → Docker databases
dropbox                   → Dropbox sync
steam                     → Steam gaming
tailscale                 → Tailscale VPN
terminal                  → Terminal emulator
vscode                    → VSCode editor
```

### omarchy-launch-*
```
about                     → System info
browser                   → Default browser
editor                    → Default editor
hyprland-docs             → Hyprland docs
walker                    → App launcher
webapp                    → Web application
wifi                      → WiFi manager
```

### omarchy-pkg-*
```
add                       → Track package
aur-install               → Install from AUR
drop                      → Untrack package
install                   → Install package
remove                    → Remove package
```

### omarchy-restart-*
```
app                       → Restart application
bluetooth                 → Restart Bluetooth
hypridle                  → Restart hypridle
hyprsunset                → Restart hyprsunset
pipewire                  → Restart audio
swayosd                   → Restart OSD
walker                    → Restart walker
waybar                    → Restart waybar
wifi                      → Restart WiFi
```

### omarchy-theme-*
```
bg-next                   → Next background
current                   → Show current theme
install                   → Install theme
list                      → List themes
next                      → Next theme
remove                    → Remove theme
set                       → Set theme
```

### omarchy-update-*
```
update                    → Update omarchy
branch                    → Switch branch
firmware                  → Update firmware
system-pkgs               → Update packages
```

**Complete index:** [Script Map](../SCRIPT-MAP.md)

---

## File Hierarchy

```
01-getting-started/      → New user orientation
02-core-commands/        → Command reference
03-theming/              → Visual customization
04-desktop-environment/  → Desktop components
05-applications/         → Software ecosystem
06-development/          → Dev environment
07-system-setup/         → Hardware & security
08-utilities/            → Tools & scripts
09-customization/        → Advanced config
10-reference/            → This + troubleshooting + FAQ
```

---

## Search the Archive

```bash
# Search everything
grep -r "keyword" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Search with context
grep -rn -C 3 "omarchy-theme-set" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Find files about topic
grep -rl "walker" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Look up script
grep "omarchy-cmd-screenshot" /home/zack/dev/lib/omarchy-archive/SCRIPT-MAP.md
```

**Full search guide:** [QUICK-SEARCH.md](../QUICK-SEARCH.md)

---

## Getting Help

### Documentation
- This file → Quick answers
- [Troubleshooting](./troubleshooting.md) → Problem solving
- [FAQ](./faq.md) → Common questions
- [Command Index](../02-core-commands/command-index.md) → All commands

### Interactive
```bash
# Omarchy menu
omarchy-menu

# Keybindings reference
omarchy-menu-keybindings

# Documentation browser
SUPER + O
```

### Community
- GitHub: [basecamp/omarchy](https://github.com/basecamp/omarchy)
- Website: [omarchy.org](https://omarchy.org)

---

## Related Documentation

- [Command Index](../02-core-commands/command-index.md) - Complete A-Z command list
- [Troubleshooting](./troubleshooting.md) - Detailed problem solving
- [FAQ](./faq.md) - Frequently asked questions
- [Script Map](../SCRIPT-MAP.md) - All 124 scripts indexed

---

*This quick reference covers 80% of common omarchy tasks. For detailed documentation, see category-specific files.*
