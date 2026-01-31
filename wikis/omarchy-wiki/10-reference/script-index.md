# Omarchy Script Index - Complete Reference

**Purpose:** Detailed documentation for all 124 omarchy scripts
**Use Case:** Understanding script functionality, options, and usage

*Last Updated: 2025-10-21*

---

## Overview

This index provides comprehensive documentation for every omarchy script. Each entry includes:

- **Purpose:** What the script does
- **Usage:** Command syntax and options
- **Examples:** Practical usage scenarios
- **Source:** Location of script file
- **Related:** Links to detailed documentation

**Total Scripts:** 124

---

## Table of Contents

- [Battery & Power Management (2)](#battery--power-management)
- [Command Scripts (12)](#command-scripts)
- [Development Tools (1)](#development-tools)
- [Drive Management (3)](#drive-management)
- [Font Management (3)](#font-management)
- [Hooks System (1)](#hooks-system)
- [Installation Scripts (8)](#installation-scripts)
- [Launch Commands (13)](#launch-commands)
- [Menu System (2)](#menu-system)
- [Migration Tools (1)](#migration-tools)
- [Notification Tools (1)](#notification-tools)
- [Package Management (10)](#package-management)
- [Power Profiles (1)](#power-profiles)
- [Refresh & Restart (16)](#refresh--restart)
- [Setup Tools (3)](#setup-tools)
- [Display Tools (2)](#display-tools)
- [Snapshot Tools (1)](#snapshot-tools)
- [State Management (1)](#state-management)
- [Theme Management (15)](#theme-management)
- [Toggle Commands (4)](#toggle-commands)
- [TUI Management (2)](#tui-management)
- [Timezone Selection (1)](#timezone-selection)
- [Update System (10)](#update-system)
- [Upload Tools (1)](#upload-tools)
- [Version Management (2)](#version-management)
- [Webapp Management (4)](#webapp-management)
- [Windows VM (1)](#windows-vm)

---

## Battery & Power Management

### omarchy-battery-monitor

**Purpose:** Monitor battery status and send notifications for low battery

**Usage:**
```bash
omarchy-battery-monitor
```

**Options:** None (runs as background service)

**Examples:**

```bash
# Check if running
pgrep omarchy-battery-monitor

# Start manually (usually starts automatically)
omarchy-battery-monitor &

# View battery status
cat /sys/class/power_supply/BAT0/capacity
```

**What it does:**
- Monitors battery percentage continuously
- Sends notification at 20% (low battery)
- Sends critical notification at 10%
- Suggests power saver mode when low
- Runs in background as systemd service

**Source:** `~/.local/share/omarchy/bin/omarchy-battery-monitor`

**Related:** [Power Management](../07-system-setup/power-management.md)

---

## Command Scripts

### omarchy-cmd-apple-display-brightness

**Purpose:** Adjust brightness on Apple external displays

**Usage:**
```bash
omarchy-cmd-apple-display-brightness [up|down|set VALUE]
```

**Options:**
- `up` - Increase brightness by 10%
- `down` - Decrease brightness by 10%
- `set VALUE` - Set specific brightness (0-100)

**Examples:**

```bash
# Increase brightness
omarchy-cmd-apple-display-brightness up

# Decrease brightness
omarchy-cmd-apple-display-brightness down

# Set to 50%
omarchy-cmd-apple-display-brightness set 50
```

**What it does:**
- Controls Apple Thunderbolt/USB-C displays
- Uses DDC/CI protocol
- Works with Apple Cinema Display, Studio Display, etc.
- Requires ddcutil package

**Source:** `~/.local/share/omarchy/bin/omarchy-cmd-apple-display-brightness`

**Related:** [Utility Scripts](../08-utilities/utility-scripts.md)

---

### omarchy-cmd-audio-switch

**Purpose:** Switch between available audio output devices

**Usage:**
```bash
omarchy-cmd-audio-switch
```

**Options:** None (interactive menu)

**Examples:**

```bash
# Open audio switcher
omarchy-cmd-audio-switch

# Select device from list:
# 1. Built-in Audio
# 2. HDMI / DisplayPort
# 3. USB Headphones
# 4. Bluetooth Speaker
```

**What it does:**
- Lists all available audio sinks
- Shows current default device
- Allows selection via number
- Sets new default and switches playing audio
- Sends notification with device name

**Source:** `~/.local/share/omarchy/bin/omarchy-cmd-audio-switch`

**Related:** [Audio, Bluetooth, WiFi](../07-system-setup/audio-bluetooth-wifi.md)

---

### omarchy-cmd-close-all-windows

**Purpose:** Close all windows in current workspace

**Usage:**
```bash
omarchy-cmd-close-all-windows
```

**Options:** None

**Examples:**

```bash
# Close all windows
omarchy-cmd-close-all-windows

# Useful before logout/reboot
omarchy-cmd-close-all-windows && hyprctl dispatch exit
```

**What it does:**
- Gets list of all windows in current workspace
- Sends close signal to each window (graceful close)
- Waits for applications to close properly
- Does not force kill (applications can prompt to save)

**Source:** `~/.local/share/omarchy/bin/omarchy-cmd-close-all-windows`

**Related:** [Window Management](../04-desktop-environment/window-management.md)

---

### omarchy-cmd-first-run

**Purpose:** First-run setup wizard for new installations

**Usage:**
```bash
omarchy-cmd-first-run
```

**Options:** None (interactive wizard)

**Examples:**

```bash
# Runs automatically on first boot
# Or run manually:
omarchy-cmd-first-run
```

**What it does:**
1. Welcomes user to Omarchy
2. Runs timezone selection (omarchy-tz-select)
3. Offers theme selection
4. Offers terminal installation
5. Shows keybinding reference
6. Provides quick tour of features
7. Creates completion marker to prevent re-run

**Source:** `~/.local/share/omarchy/bin/omarchy-cmd-first-run`

**Related:** [First Run Guide](../01-getting-started/first-run-guide.md)

---

### omarchy-cmd-missing

**Purpose:** Check if a command is missing (not present in PATH)

**Usage:**
```bash
omarchy-cmd-missing COMMAND
```

**Options:** None

**Examples:**

```bash
# Check if code is missing
if omarchy-cmd-missing code; then
    echo "VS Code not installed"
fi

# Check before running
omarchy-cmd-missing chromium || chromium &
```

**What it does:**
- Checks if command exists in PATH
- Returns exit code 0 if missing
- Returns exit code 1 if present
- Used by other scripts to check dependencies
- Silent (no output)

**Source:** `~/.local/share/omarchy/bin/omarchy-cmd-missing`

**Related:** [Command Index](../02-core-commands/command-index.md)

---

### omarchy-cmd-present

**Purpose:** Check if a command is present (exists in PATH)

**Usage:**
```bash
omarchy-cmd-present COMMAND
```

**Options:** None

**Examples:**

```bash
# Check if docker is installed
if omarchy-cmd-present docker; then
    echo "Docker is installed"
fi

# Run command only if present
omarchy-cmd-present lazydocker && lazydocker
```

**What it does:**
- Checks if command exists in PATH
- Returns exit code 0 if present
- Returns exit code 1 if missing
- Opposite of omarchy-cmd-missing
- Silent (no output)

**Source:** `~/.local/share/omarchy/bin/omarchy-cmd-present`

**Related:** [Command Index](../02-core-commands/command-index.md)

---

### omarchy-cmd-screenrecord

**Purpose:** Record screen with optional audio and webcam

**Usage:**
```bash
omarchy-cmd-screenrecord [region|output] [--with-audio] [--with-webcam]
```

**Options:**
- `region` - Select region to record
- `output` - Select output/display to record
- `--with-audio` - Include system audio
- `--with-webcam` - Include webcam overlay

**Examples:**

```bash
# Basic screen recording (select region)
omarchy-cmd-screenrecord

# Record specific display
omarchy-cmd-screenrecord output

# Record with audio
omarchy-cmd-screenrecord --with-audio

# Record with webcam and audio
omarchy-cmd-screenrecord --with-audio --with-webcam

# Stop recording (run again or click notification)
omarchy-cmd-screenrecord
```

**What it does:**
- Uses gpu-screen-recorder for efficient recording
- Allows region or full display selection
- Can include system audio (pipewire)
- Can overlay webcam feed
- Saves to ~/Videos/ with timestamp
- Shows notification with file location
- Click notification to stop recording

**Keybinding:** SUPER + SHIFT + PRINT

**Source:** `~/.local/share/omarchy/bin/omarchy-cmd-screenrecord`

**Related:** [Screenshot & Screenrecord](../08-utilities/screenshot-screenrecord.md)

---

### omarchy-cmd-screenshot

**Purpose:** Take screenshots with editing capabilities

**Usage:**
```bash
omarchy-cmd-screenshot smart [clipboard]
```

**Options:**
- `smart` - Intelligent screenshot (region/display selection)
- `clipboard` - Copy directly to clipboard (skip editor)

**Examples:**

```bash
# Take screenshot with editing
omarchy-cmd-screenshot smart

# Screenshot to clipboard (no editor)
omarchy-cmd-screenshot smart clipboard

# What "smart" does:
# - Single monitor: full screen
# - Multiple monitors: choose region or display
```

**What it does:**
1. Detects number of monitors
2. If multiple: offers region selection via slurp
3. Takes screenshot with grim
4. Opens Satty editor (unless clipboard option)
5. In Satty: annotate, crop, draw, blur
6. Save or copy to clipboard
7. Sends notification with file location

**Keybindings:**
- PRINT - Screenshot with editor
- SUPER + PRINT - Screenshot to clipboard

**Source:** `~/.local/share/omarchy/bin/omarchy-cmd-screenshot`

**Related:** [Screenshot & Screenrecord](../08-utilities/screenshot-screenrecord.md)

---

### omarchy-cmd-screensaver

**Purpose:** Control screensaver activation

**Usage:**
```bash
omarchy-cmd-screensaver [start|stop|toggle]
```

**Options:**
- `start` - Start screensaver
- `stop` - Stop screensaver
- `toggle` - Toggle on/off

**Examples:**

```bash
# Start screensaver
omarchy-cmd-screensaver start

# Stop screensaver
omarchy-cmd-screensaver stop

# Toggle
omarchy-cmd-screensaver toggle
```

**What it does:**
- Manages screensaver state
- Integrates with hypridle
- Can trigger lock screen
- Respects idle settings

**Source:** `~/.local/share/omarchy/bin/omarchy-cmd-screensaver`

**Related:** [Utility Scripts](../08-utilities/utility-scripts.md)

---

### omarchy-cmd-share

**Purpose:** Share files, folders, or clipboard via LocalSend

**Usage:**
```bash
omarchy-cmd-share [clipboard|file|folder]
```

**Options:**
- `clipboard` - Share clipboard contents
- `file` - Select and share a file
- `folder` - Select and share a folder

**Examples:**

```bash
# Share clipboard
omarchy-cmd-share clipboard

# Share file (opens file picker)
omarchy-cmd-share file

# Share folder (opens folder picker)
omarchy-cmd-share folder
```

**What it does:**
- Copies content to LocalSend shared directory
- Opens LocalSend application
- Allows sending to devices on local network
- Works with LocalSend apps on phones/tablets
- No internet required
- Fast local network transfers

**Source:** `~/.local/share/omarchy/bin/omarchy-cmd-share`

**Related:** [File Sharing](../08-utilities/file-sharing.md)

---

### omarchy-cmd-terminal-cwd

**Purpose:** Get current working directory of focused terminal

**Usage:**
```bash
omarchy-cmd-terminal-cwd
```

**Options:** None

**Examples:**

```bash
# Get terminal CWD
omarchy-cmd-terminal-cwd
# Output: /home/user/project

# Open new terminal in same directory
cd "$(omarchy-cmd-terminal-cwd)" && alacritty &
```

**What it does:**
- Identifies focused terminal window
- Gets its process ID
- Reads CWD from /proc/PID/cwd
- Returns path to stdout
- Used internally by launcher scripts

**Source:** `~/.local/share/omarchy/bin/omarchy-cmd-terminal-cwd`

**Related:** [Launcher Commands](../02-core-commands/launcher-commands.md)

---

## Development Tools

### omarchy-dev-add-migration

**Purpose:** Add a new migration script to omarchy

**Usage:**
```bash
omarchy-dev-add-migration DESCRIPTION
```

**Options:** None

**Examples:**

```bash
# Add migration
omarchy-dev-add-migration "Update waybar config format"

# Creates: ~/.local/share/omarchy/migrations/20251021-update-waybar-config-format.sh
```

**What it does:**
- Creates new migration script with timestamp
- Uses description for filename
- Adds bash template
- Makes executable
- Used for omarchy development
- Migrations run on `omarchy-update`

**Source:** `~/.local/share/omarchy/bin/omarchy-dev-add-migration`

**Related:** [Advanced Tweaks](../09-customization/advanced-tweaks.md)

---

## Drive Management

### omarchy-drive-info

**Purpose:** Display encrypted drive information

**Usage:**
```bash
omarchy-drive-info
```

**Options:** None

**Examples:**

```bash
# Show drive info
omarchy-drive-info

# Example output:
# Drive: /dev/nvme0n1p2
# Type: LUKS2
# Status: unlocked
# UUID: abc123...
```

**What it does:**
- Lists encrypted drives (LUKS)
- Shows encryption status
- Displays mount points
- Shows encryption type
- Checks if drives are unlocked

**Source:** `~/.local/share/omarchy/bin/omarchy-drive-info`

**Related:** [Security & Auth](../07-system-setup/security-auth.md)

---

### omarchy-drive-select

**Purpose:** Select encrypted drive for operations

**Usage:**
```bash
omarchy-drive-select
```

**Options:** None (interactive menu)

**Examples:**

```bash
# Select drive
omarchy-drive-select

# Returns drive path (e.g., /dev/nvme0n1p2)
```

**What it does:**
- Lists available encrypted drives
- Allows selection via menu
- Returns selected drive path
- Used by other drive management scripts

**Source:** `~/.local/share/omarchy/bin/omarchy-drive-select`

**Related:** [Security & Auth](../07-system-setup/security-auth.md)

---

### omarchy-drive-set-password

**Purpose:** Change encrypted drive password

**Usage:**
```bash
omarchy-drive-set-password
```

**Options:** None (interactive prompts)

**Examples:**

```bash
# Change drive password
omarchy-drive-set-password

# Prompts for:
# - Current password
# - New password
# - Confirm new password
```

**What it does:**
- Lists encrypted drives
- Prompts for drive selection
- Verifies current password
- Sets new password
- Uses cryptsetup luksChangeKey
- Keeps existing key slots

**Warning:** Keep backup of password! Lost password = lost data

**Source:** `~/.local/share/omarchy/bin/omarchy-drive-set-password`

**Related:** [Security & Auth](../07-system-setup/security-auth.md)

---

## Font Management

### omarchy-font-current

**Purpose:** Display currently set system font

**Usage:**
```bash
omarchy-font-current
```

**Options:** None

**Examples:**

```bash
# Show current font
omarchy-font-current
# Output: JetBrains Mono Nerd Font
```

**What it does:**
- Reads font from Alacritty config
- Returns font family name
- Used by font management scripts

**Source:** `~/.local/share/omarchy/bin/omarchy-font-current`

**Related:** [Fonts](../03-theming/fonts.md)

---

### omarchy-font-list

**Purpose:** List all installed Nerd Fonts

**Usage:**
```bash
omarchy-font-list
```

**Options:** None

**Examples:**

```bash
# List fonts
omarchy-font-list

# Output:
# JetBrains Mono Nerd Font
# Fira Code Nerd Font
# Hack Nerd Font
# Source Code Pro Nerd Font
```

**What it does:**
- Scans /usr/share/fonts/
- Filters for Nerd Font variants
- Returns formatted list
- Only shows installed fonts

**Source:** `~/.local/share/omarchy/bin/omarchy-font-list`

**Related:** [Fonts](../03-theming/fonts.md)

---

### omarchy-font-set

**Purpose:** Set system-wide font

**Usage:**
```bash
omarchy-font-set "FONT NAME"
```

**Options:** None

**Examples:**

```bash
# Set font
omarchy-font-set "JetBrains Mono Nerd Font"

# Set different font
omarchy-font-set "Fira Code Nerd Font"
```

**What it does:**
- Updates Alacritty config
- Updates Kitty config
- Updates Ghostty config
- Reloads terminals
- Sends SIGUSR1/SIGUSR2 to running terminals
- Applies immediately

**Note:** Font must be installed first

**Source:** `~/.local/share/omarchy/bin/omarchy-font-set`

**Related:** [Fonts](../03-theming/fonts.md)

---

## Hooks System

### omarchy-hook

**Purpose:** Execute custom hook scripts

**Usage:**
```bash
omarchy-hook HOOK_NAME [ARGS...]
```

**Options:**
- `HOOK_NAME` - Name of hook (e.g., theme-set, update-complete)
- `ARGS` - Additional arguments passed to hooks

**Examples:**

```bash
# Run theme-set hooks
omarchy-hook theme-set catppuccin

# Run custom hook
omarchy-hook my-custom-hook arg1 arg2
```

**What it does:**
- Looks for scripts in `~/.config/omarchy/hooks/HOOK_NAME/`
- Executes all executable files in that directory
- Passes arguments to each script
- Runs in alphabetical order
- Silent if no hooks exist

**Creating hooks:**
```bash
# Create hook directory
mkdir -p ~/.config/omarchy/hooks/theme-set/

# Create hook script
cat > ~/.config/omarchy/hooks/theme-set/notify-theme.sh << 'EOF'
#!/usr/bin/env bash
notify-send "Theme Changed" "New theme: $1"
EOF

chmod +x ~/.config/omarchy/hooks/theme-set/notify-theme.sh
```

**Built-in hooks:**
- `theme-set` - Runs when theme changes
- `update-complete` - Runs after system update
- `pre-update` - Runs before system update

**Source:** `~/.local/share/omarchy/bin/omarchy-hook`

**Related:** [Advanced Tweaks](../09-customization/advanced-tweaks.md)

---

## Installation Scripts

### omarchy-install-chromium-google-account

**Purpose:** Set up Google account in Chromium browser

**Usage:**
```bash
omarchy-install-chromium-google-account
```

**Options:** None (interactive)

**Examples:**

```bash
# Set up Google account
omarchy-install-chromium-google-account

# Opens Chromium to Google login
# Follow prompts to sign in
```

**What it does:**
- Launches Chromium
- Opens Google account sign-in page
- Waits for login completion
- Configures sync if desired
- Sets up Chrome extensions sync

**Note:** Requires chromium package

**Source:** `~/.local/share/omarchy/bin/omarchy-install-chromium-google-account`

**Related:** [Core Applications](../05-applications/core-applications.md)

---

### omarchy-install-dev-env

**Purpose:** Install development environment for specific language

**Usage:**
```bash
omarchy-install-dev-env LANGUAGE
```

**Options:**
- `ruby` - Install Ruby via mise
- `node` - Install Node.js via mise
- `python` - Install Python via mise
- `go` - Install Go via mise
- `rust` - Install Rust via rustup
- `java` - Install Java via mise
- `php` - Install PHP via mise
- `elixir` - Install Elixir via mise

**Examples:**

```bash
# Install Ruby
omarchy-install-dev-env ruby

# Install Node.js
omarchy-install-dev-env node

# Install Python
omarchy-install-dev-env python
```

**What it does:**
1. Installs mise (if not installed)
2. Installs language runtime (latest stable)
3. Configures PATH
4. Installs language-specific tools:
   - Ruby: bundler, rails
   - Node: npm, yarn
   - Python: pip, virtualenv
   - etc.
5. Creates config file (~/.config/mise/config.toml)

**Source:** `~/.local/share/omarchy/bin/omarchy-install-dev-env`

**Related:** [Language Environments](../06-development/language-environments.md), [Mise Integration](../06-development/mise-integration.md)

---

### omarchy-install-docker-dbs

**Purpose:** Install Docker with PostgreSQL, MySQL, and Redis

**Usage:**
```bash
omarchy-install-docker-dbs
```

**Options:** None

**Examples:**

```bash
# Install Docker databases
omarchy-install-docker-dbs

# Wait for completion
# Databases start automatically
```

**What it does:**
1. Installs Docker and Docker Compose
2. Creates docker-compose.yml
3. Installs PostgreSQL (latest, port 5432)
4. Installs MySQL (latest, port 3306)
5. Installs Redis (latest, port 6379)
6. Sets up volumes for persistence
7. Starts containers automatically
8. Configures containers to start on boot

**Default credentials:**
- PostgreSQL: postgres / postgres
- MySQL: root / password
- Redis: no password

**Source:** `~/.local/share/omarchy/bin/omarchy-install-docker-dbs`

**Related:** [Docker Setup](../06-development/docker-setup.md)

---

### omarchy-install-dropbox

**Purpose:** Install and configure Dropbox

**Usage:**
```bash
omarchy-install-dropbox
```

**Options:** None (interactive)

**Examples:**

```bash
# Install Dropbox
omarchy-install-dropbox

# Follow prompts to:
# - Install package
# - Sign in to Dropbox
# - Choose sync folder
# - Configure selective sync
```

**What it does:**
- Installs dropbox package (AUR)
- Starts Dropbox daemon
- Opens browser for authentication
- Configures sync settings
- Adds Dropbox to autostart

**Source:** `~/.local/share/omarchy/bin/omarchy-install-dropbox`

**Related:** [Productivity Apps](../05-applications/productivity-apps.md)

---

### omarchy-install-steam

**Purpose:** Install Steam gaming platform

**Usage:**
```bash
omarchy-install-steam
```

**Options:** None

**Examples:**

```bash
# Install Steam
omarchy-install-steam

# Installs:
# - steam package
# - 32-bit libraries
# - GPU drivers (if needed)
```

**What it does:**
- Enables multilib repository
- Installs Steam
- Installs 32-bit libraries (lib32-*)
- Checks GPU drivers
- Installs appropriate drivers if missing
- Creates desktop entry
- Runs Steam first-time setup

**Source:** `~/.local/share/omarchy/bin/omarchy-install-steam`

**Related:** [Productivity Apps](../05-applications/productivity-apps.md)

---

### omarchy-install-tailscale

**Purpose:** Install Tailscale VPN

**Usage:**
```bash
omarchy-install-tailscale
```

**Options:** None (interactive)

**Examples:**

```bash
# Install Tailscale
omarchy-install-tailscale

# Follow prompts to:
# - Install package
# - Authenticate with Tailscale
# - Join tailnet
```

**What it does:**
- Installs tailscale package
- Enables tailscaled service
- Runs tailscale up
- Opens browser for authentication
- Configures autostart
- Shows connection status

**Source:** `~/.local/share/omarchy/bin/omarchy-install-tailscale`

**Related:** [Security & Auth](../07-system-setup/security-auth.md)

---

### omarchy-install-terminal

**Purpose:** Install or switch terminal emulator

**Usage:**
```bash
omarchy-install-terminal [alacritty|kitty|ghostty]
```

**Options:**
- `alacritty` - Install Alacritty (default)
- `kitty` - Install Kitty
- `ghostty` - Install Ghostty

**Examples:**

```bash
# Install Alacritty
omarchy-install-terminal alacritty

# Switch to Kitty
omarchy-install-terminal kitty

# Install Ghostty
omarchy-install-terminal ghostty
```

**What it does:**
1. Installs terminal package
2. Creates config directory
3. Copies theme-aware config
4. Sets as default terminal
5. Updates Hyprland keybinding
6. Reloads Hyprland config

**All terminals:**
- Support theme switching
- Use same keybindings
- Share same font settings

**Source:** `~/.local/share/omarchy/bin/omarchy-install-terminal`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-install-vscode

**Purpose:** Install and configure Visual Studio Code

**Usage:**
```bash
omarchy-install-vscode
```

**Options:** None (interactive)

**Examples:**

```bash
# Install VS Code
omarchy-install-vscode

# Prompts for choice:
# 1. VSCode (official)
# 2. VSCodium (open source)
```

**What it does:**
1. Prompts for VSCode or VSCodium
2. Installs selected package
3. Installs theme extensions
4. Configures settings.json
5. Sets up theme synchronization
6. Installs recommended extensions:
   - Theme extension
   - GitLens
   - Prettier
   - ESLint
   - etc.

**Theme sync:** Automatically updates VS Code theme when omarchy theme changes

**Source:** `~/.local/share/omarchy/bin/omarchy-install-vscode`

**Related:** [Editor Setup](../06-development/editor-setup.md)

---

## Launch Commands

### omarchy-launch-about

**Purpose:** Display system information and about dialog

**Usage:**
```bash
omarchy-launch-about
```

**Options:** None

**Examples:**

```bash
# Show about dialog
omarchy-launch-about

# Displays:
# - Omarchy version
# - System info
# - Hardware details
# - Uptime
```

**What it does:**
- Runs fastfetch with omarchy config
- Shows logo and system stats
- Displays in floating terminal
- Auto-closes after viewing

**Source:** `~/.local/share/omarchy/bin/omarchy-launch-about`

**Related:** [Launcher Commands](../02-core-commands/launcher-commands.md)

---

### omarchy-launch-browser

**Purpose:** Launch default browser with optional URL

**Usage:**
```bash
omarchy-launch-browser [URL]
```

**Options:**
- `URL` - Optional URL to open

**Examples:**

```bash
# Open browser
omarchy-launch-browser

# Open specific URL
omarchy-launch-browser https://github.com

# Open local file
omarchy-launch-browser file:///home/user/page.html
```

**What it does:**
- Reads default browser from $BROWSER
- Falls back to chromium if not set
- Opens new window or tab
- Focuses browser if already running

**Set default browser:**
```bash
export BROWSER=firefox
# Add to ~/.bashrc for persistence
```

**Source:** `~/.local/share/omarchy/bin/omarchy-launch-browser`

**Related:** [Launcher Commands](../02-core-commands/launcher-commands.md)

---

### omarchy-launch-editor

**Purpose:** Launch default text editor with optional file

**Usage:**
```bash
omarchy-launch-editor [FILE]
```

**Options:**
- `FILE` - Optional file to open

**Examples:**

```bash
# Open editor
omarchy-launch-editor

# Open specific file
omarchy-launch-editor ~/.bashrc

# Open multiple files
omarchy-launch-editor file1.txt file2.txt
```

**What it does:**
- Reads default editor from $EDITOR
- Falls back to nvim if not set
- Opens in terminal or GUI depending on editor
- Waits for editor to close if in terminal

**Set default editor:**
```bash
export EDITOR=nvim
# Or: code, cursor, nano, vim, etc.
```

**Source:** `~/.local/share/omarchy/bin/omarchy-launch-editor`

**Related:** [Launcher Commands](../02-core-commands/launcher-commands.md)

---

### omarchy-launch-floating-terminal-with-presentation

**Purpose:** Launch floating terminal with command in presentation mode

**Usage:**
```bash
omarchy-launch-floating-terminal-with-presentation COMMAND
```

**Options:**
- `COMMAND` - Command to run in terminal

**Examples:**

```bash
# Show about screen
omarchy-launch-floating-terminal-with-presentation "fastfetch"

# Show logs
omarchy-launch-floating-terminal-with-presentation "journalctl -f"

# Run interactive command
omarchy-launch-floating-terminal-with-presentation "htop"
```

**What it does:**
- Opens terminal in floating window
- Centers window on screen
- Runs specified command
- Uses presentation styling (large, readable)
- Auto-closes when command exits

**Source:** `~/.local/share/omarchy/bin/omarchy-launch-floating-terminal-with-presentation`

**Related:** [Launcher Commands](../02-core-commands/launcher-commands.md)

---

### omarchy-launch-hyprland-docs

**Purpose:** Open Hyprland documentation browser

**Usage:**
```bash
omarchy-launch-hyprland-docs
```

**Options:** None

**Examples:**

```bash
# Open Hyprland docs
omarchy-launch-hyprland-docs

# Opens browser to wiki.hyprland.org
```

**What it does:**
- Opens default browser
- Navigates to Hyprland wiki
- Focuses browser window

**Source:** `~/.local/share/omarchy/bin/omarchy-launch-hyprland-docs`

**Related:** [Launcher Commands](../02-core-commands/launcher-commands.md)

---

### omarchy-launch-or-focus

**Purpose:** Launch application or focus if already running

**Usage:**
```bash
omarchy-launch-or-focus CLASS COMMAND
```

**Options:**
- `CLASS` - Window class name
- `COMMAND` - Command to launch if not running

**Examples:**

```bash
# Launch or focus browser
omarchy-launch-or-focus chromium chromium

# Launch or focus editor
omarchy-launch-or-focus code code

# Custom app
omarchy-launch-or-focus myapp "myapp --flag"
```

**What it does:**
1. Checks if window with CLASS exists
2. If exists: focuses that window
3. If not: launches COMMAND
4. Uses hyprctl to find windows

**Source:** `~/.local/share/omarchy/bin/omarchy-launch-or-focus`

**Related:** [Launcher Commands](../02-core-commands/launcher-commands.md)

---

### omarchy-launch-or-focus-webapp

**Purpose:** Launch or focus web application

**Usage:**
```bash
omarchy-launch-or-focus-webapp NAME
```

**Options:**
- `NAME` - Web app name (lowercase)

**Examples:**

```bash
# Launch or focus Notion
omarchy-launch-or-focus-webapp notion

# Launch or focus Figma
omarchy-launch-or-focus-webapp figma
```

**What it does:**
- Checks if webapp window exists
- If exists: focuses window
- If not: launches webapp
- Uses webapp class name for identification

**Source:** `~/.local/share/omarchy/bin/omarchy-launch-or-focus-webapp`

**Related:** [Launcher Commands](../02-core-commands/launcher-commands.md)

---

### omarchy-launch-screensaver

**Purpose:** Launch screensaver immediately

**Usage:**
```bash
omarchy-launch-screensaver [force]
```

**Options:**
- `force` - Force start even if disabled

**Examples:**

```bash
# Start screensaver
omarchy-launch-screensaver

# Force start
omarchy-launch-screensaver force
```

**What it does:**
- Triggers hypridle screensaver
- Dims screen
- Can lock after timeout
- Respects hypridle config

**Source:** `~/.local/share/omarchy/bin/omarchy-launch-screensaver`

**Related:** [Utility Scripts](../08-utilities/utility-scripts.md)

---

### omarchy-launch-walker

**Purpose:** Launch Walker application launcher

**Usage:**
```bash
omarchy-launch-walker [OPTIONS]
```

**Options:**
- All walker options (see walker --help)

**Examples:**

```bash
# Launch Walker
omarchy-launch-walker

# Launch with specific module
walker -m applications

# Launch with search
walker -s "firefox"
```

**What it does:**
- Launches Walker if not running
- Focuses Walker if already visible
- Supports all Walker options
- Default keybinding: SUPER + SPACE

**Source:** `~/.local/share/omarchy/bin/omarchy-launch-walker`

**Related:** [Walker Elephant](../04-desktop-environment/walker-elephant.md)

---

### omarchy-launch-webapp

**Purpose:** Launch web application

**Usage:**
```bash
omarchy-launch-webapp NAME_OR_URL
```

**Options:**
- `NAME` - Installed webapp name
- `URL` - URL to open as webapp

**Examples:**

```bash
# Launch installed webapp
omarchy-launch-webapp notion

# Launch URL as webapp
omarchy-launch-webapp https://chat.openai.com
```

**What it does:**
- Checks if named webapp is installed
- If installed: launches webapp
- If URL: opens in browser as webapp
- Creates window with app class

**Source:** `~/.local/share/omarchy/bin/omarchy-launch-webapp`

**Related:** [Launcher Commands](../02-core-commands/launcher-commands.md)

---

### omarchy-launch-wifi

**Purpose:** Launch WiFi configuration GUI

**Usage:**
```bash
omarchy-launch-wifi
```

**Options:** None

**Examples:**

```bash
# Open WiFi manager
omarchy-launch-wifi

# Opens NetworkManager applet
# Click to see networks
# Click network to connect
```

**What it does:**
- Launches NetworkManager applet (nm-applet)
- Shows available WiFi networks
- Allows connection/disconnection
- Shows connection status
- Manages saved networks

**Source:** `~/.local/share/omarchy/bin/omarchy-launch-wifi`

**Related:** [Audio, Bluetooth, WiFi](../07-system-setup/audio-bluetooth-wifi.md)

---

### omarchy-lock-screen

**Purpose:** Lock screen immediately

**Usage:**
```bash
omarchy-lock-screen
```

**Options:** None

**Examples:**

```bash
# Lock screen
omarchy-lock-screen

# Or use keybinding: SUPER + L
```

**What it does:**
- Triggers hyprlock
- Locks screen with theme styling
- Requires password to unlock
- Shows time and date
- Pauses notifications

**Unlock methods:**
- Password
- Fingerprint (if configured)
- FIDO2 key (if configured)

**Source:** `~/.local/share/omarchy/bin/omarchy-lock-screen`

**Related:** [Security & Auth](../07-system-setup/security-auth.md)

---

## Menu System

### omarchy-menu

**Purpose:** Main TUI menu for omarchy commands

**Usage:**
```bash
omarchy-menu [SUBMENU]
```

**Options:**
- No arg - Show main menu
- `theme` - Theme submenu
- `system` - System submenu
- `package` - Package submenu
- etc.

**Examples:**

```bash
# Open main menu
omarchy-menu

# Or use keybinding: SUPER + M

# Open theme submenu directly
omarchy-menu theme
```

**What it does:**
- Interactive TUI menu
- Organized by category
- Navigate with arrow keys
- Execute commands via selection
- Categories:
  - Themes
  - Packages
  - System
  - Setup
  - Help

**Source:** `~/.local/share/omarchy/bin/omarchy-menu`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-menu-keybindings

**Purpose:** Display keybindings reference

**Usage:**
```bash
omarchy-menu-keybindings
```

**Options:** None

**Examples:**

```bash
# Show keybindings
omarchy-menu-keybindings

# Displays in floating terminal
# Lists all SUPER key combinations
# Organized by category
```

**What it does:**
- Parses Hyprland bindings.conf
- Formats keybindings list
- Shows in readable format
- Categorizes by function
- Shows description for each

**Source:** `~/.local/share/omarchy/bin/omarchy-menu-keybindings`

**Related:** [Keybindings](../09-customization/keybindings.md)

---

## Migration Tools

### omarchy-migrate

**Purpose:** Run omarchy system migrations

**Usage:**
```bash
omarchy-migrate
```

**Options:** None

**Examples:**

```bash
# Run migrations
omarchy-migrate

# Runs automatically during omarchy-update
# Can run manually if needed
```

**What it does:**
1. Checks for pending migrations
2. Tracks completed migrations
3. Runs new migrations in order
4. Logs migration results
5. Marks migrations as complete

**Migrations are:**
- Scripts in `~/.local/share/omarchy/migrations/`
- Named with timestamp (YYYYMMDD-description.sh)
- Run once per system
- Used for:
  - Config format updates
  - File relocations
  - Breaking changes
  - Feature additions

**Source:** `~/.local/share/omarchy/bin/omarchy-migrate`

**Related:** [System Management](../02-core-commands/system-management.md)

---

## Notification Tools

### omarchy-notification-dismiss

**Purpose:** Dismiss all visible notifications

**Usage:**
```bash
omarchy-notification-dismiss
```

**Options:** None

**Examples:**

```bash
# Dismiss all notifications
omarchy-notification-dismiss

# Useful before screenshots or presentations
```

**What it does:**
- Sends dismiss command to mako
- Clears all visible notifications
- Notification history is preserved
- Can be recalled via makoctl

**Source:** `~/.local/share/omarchy/bin/omarchy-notification-dismiss`

**Related:** [Utility Scripts](../08-utilities/utility-scripts.md)

---

## Package Management

### omarchy-pkg-add

**Purpose:** Add package to tracking list

**Usage:**
```bash
omarchy-pkg-add PACKAGE_NAME
```

**Options:**
- `PACKAGE_NAME` - Package to add

**Examples:**

```bash
# Add package to tracking
omarchy-pkg-add firefox

# Add multiple packages
omarchy-pkg-add firefox thunderbird
```

**What it does:**
- Adds package to `~/.local/share/omarchy/install/omarchy-user.packages`
- Creates file if doesn't exist
- Doesn't install package (use omarchy-pkg-install)
- Used to track custom packages
- Helps with system recreation

**Source:** `~/.local/share/omarchy/bin/omarchy-pkg-add`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-pkg-aur-accessible

**Purpose:** Check if AUR is accessible

**Usage:**
```bash
omarchy-pkg-aur-accessible
```

**Options:** None

**Examples:**

```bash
# Check AUR access
if omarchy-pkg-aur-accessible; then
    echo "AUR is accessible"
else
    echo "AUR is not accessible"
fi
```

**What it does:**
- Pings aur.archlinux.org
- Returns 0 if accessible
- Returns 1 if not accessible
- Used by AUR install scripts

**Source:** `~/.local/share/omarchy/bin/omarchy-pkg-aur-accessible`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-pkg-aur-install

**Purpose:** Install package from AUR

**Usage:**
```bash
omarchy-pkg-aur-install [PACKAGE]
```

**Options:**
- `PACKAGE` - Package name (optional, prompts if not provided)

**Examples:**

```bash
# Interactive install
omarchy-pkg-aur-install

# Direct install
omarchy-pkg-aur-install yay
```

**What it does:**
1. Checks AUR accessibility
2. Prompts for package name (if not provided)
3. Searches AUR
4. Shows package info
5. Confirms installation
6. Builds and installs package
7. Adds to tracking list

**Uses yay as AUR helper**

**Source:** `~/.local/share/omarchy/bin/omarchy-pkg-aur-install`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-pkg-drop

**Purpose:** Remove package from tracking list

**Usage:**
```bash
omarchy-pkg-drop PACKAGE_NAME
```

**Options:**
- `PACKAGE_NAME` - Package to remove from tracking

**Examples:**

```bash
# Remove from tracking
omarchy-pkg-drop firefox

# Note: Doesn't uninstall package
# Use omarchy-pkg-remove to uninstall
```

**What it does:**
- Removes package from omarchy-user.packages
- Doesn't uninstall package
- Only removes from tracking
- Package remains installed

**Source:** `~/.local/share/omarchy/bin/omarchy-pkg-drop`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-pkg-ignored

**Purpose:** List packages ignored from updates

**Usage:**
```bash
omarchy-pkg-ignored
```

**Options:** None

**Examples:**

```bash
# List ignored packages
omarchy-pkg-ignored

# Output:
# linux
# nvidia
```

**What it does:**
- Reads IgnorePkg from /etc/pacman.conf
- Lists packages that won't be updated
- Shows packages held at specific versions

**Source:** `~/.local/share/omarchy/bin/omarchy-pkg-ignored`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-pkg-install

**Purpose:** Install package from official repos

**Usage:**
```bash
omarchy-pkg-install [PACKAGE]
```

**Options:**
- `PACKAGE` - Package name (optional, prompts if not provided)

**Examples:**

```bash
# Interactive install
omarchy-pkg-install

# Direct install
omarchy-pkg-install firefox

# Install multiple
omarchy-pkg-install firefox thunderbird
```

**What it does:**
1. Prompts for package name (if not provided)
2. Searches official repos
3. Shows package info
4. Confirms installation
5. Installs package with pacman
6. Adds to tracking list

**Source:** `~/.local/share/omarchy/bin/omarchy-pkg-install`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-pkg-missing

**Purpose:** List omarchy packages that aren't installed

**Usage:**
```bash
omarchy-pkg-missing
```

**Options:** None

**Examples:**

```bash
# Check missing packages
omarchy-pkg-missing

# Output:
# firefox
# docker
# obs-studio
```

**What it does:**
- Reads omarchy-base.packages
- Checks which aren't installed
- Lists missing packages
- Useful for:
  - New installations
  - System recovery
  - Package audits

**Source:** `~/.local/share/omarchy/bin/omarchy-pkg-missing`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-pkg-pinned

**Purpose:** List packages pinned to specific versions

**Usage:**
```bash
omarchy-pkg-pinned
```

**Options:** None

**Examples:**

```bash
# List pinned packages
omarchy-pkg-pinned

# Output:
# package-name 1.2.3
```

**What it does:**
- Lists packages in HoldPkg
- Shows held versions
- Indicates packages that won't auto-update

**Source:** `~/.local/share/omarchy/bin/omarchy-pkg-pinned`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-pkg-present

**Purpose:** Check if package is installed

**Usage:**
```bash
omarchy-pkg-present PACKAGE
```

**Options:**
- `PACKAGE` - Package name to check

**Examples:**

```bash
# Check if installed
if omarchy-pkg-present docker; then
    echo "Docker is installed"
fi

# Use in scripts
omarchy-pkg-present firefox || omarchy-pkg-install firefox
```

**What it does:**
- Queries pacman database
- Returns 0 if installed
- Returns 1 if not installed
- Silent (no output)

**Source:** `~/.local/share/omarchy/bin/omarchy-pkg-present`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-pkg-remove

**Purpose:** Remove installed package

**Usage:**
```bash
omarchy-pkg-remove [PACKAGE]
```

**Options:**
- `PACKAGE` - Package to remove (optional, prompts if not provided)

**Examples:**

```bash
# Interactive removal
omarchy-pkg-remove

# Direct removal
omarchy-pkg-remove firefox

# Remove with dependencies
omarchy-pkg-remove firefox
# Prompts to remove unused dependencies
```

**What it does:**
1. Prompts for package (if not provided)
2. Shows package info
3. Confirms removal
4. Removes package with pacman -Rs
5. Removes unused dependencies
6. Removes from tracking list

**Source:** `~/.local/share/omarchy/bin/omarchy-pkg-remove`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

## Power Profiles

### omarchy-powerprofiles-list

**Purpose:** List available power profiles

**Usage:**
```bash
omarchy-powerprofiles-list
```

**Options:** None

**Examples:**

```bash
# List profiles
omarchy-powerprofiles-list

# Output:
# performance
# balanced
# power-saver
#
# Active: balanced
```

**What it does:**
- Lists power-profiles-daemon profiles
- Shows active profile
- Indicates current selection

**Change profile:**
```bash
powerprofilesctl set performance
```

**Source:** `~/.local/share/omarchy/bin/omarchy-powerprofiles-list`

**Related:** [Power Management](../07-system-setup/power-management.md)

---

## Refresh & Restart

### omarchy-refresh-applications

**Purpose:** Refresh application cache

**Usage:**
```bash
omarchy-refresh-applications
```

**Options:** None

**Examples:**

```bash
# Refresh app list
omarchy-refresh-applications

# Run after installing new apps
omarchy-pkg-install firefox && omarchy-refresh-applications
```

**What it does:**
- Updates desktop entry cache
- Refreshes Walker's application list
- Rebuilds icon cache
- Updates mime database
- Makes new apps visible in launcher

**Source:** `~/.local/share/omarchy/bin/omarchy-refresh-applications`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-refresh-config

**Purpose:** Refresh all omarchy configurations

**Usage:**
```bash
omarchy-refresh-config
```

**Options:** None

**Examples:**

```bash
# Refresh all configs
omarchy-refresh-config

# Useful after:
# - Manual config edits
# - System updates
# - Theme corruption
```

**What it does:**
1. Refreshes Hyprland config
2. Refreshes Walker config
3. Refreshes Waybar config
4. Refreshes Hypridle config
5. Refreshes Hyprlock config
6. Refreshes Swayosd config
7. Reloads all services
8. Reapplies current theme

**Source:** `~/.local/share/omarchy/bin/omarchy-refresh-config`

**Related:** [Config Management](../09-customization/config-management.md)

---

### omarchy-refresh-fastfetch

**Purpose:** Refresh fastfetch configuration

**Usage:**
```bash
omarchy-refresh-fastfetch
```

**Options:** None

**Examples:**

```bash
# Refresh fastfetch
omarchy-refresh-fastfetch

# Test
fastfetch
```

**What it does:**
- Copies default fastfetch config
- Updates logo
- Refreshes color scheme
- Resets to omarchy defaults

**Source:** `~/.local/share/omarchy/bin/omarchy-refresh-fastfetch`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-refresh-hypridle

**Purpose:** Refresh hypridle configuration

**Usage:**
```bash
omarchy-refresh-hypridle
```

**Options:** None

**Examples:**

```bash
# Refresh hypridle
omarchy-refresh-hypridle

# Useful after:
# - Timeout changes
# - Lock screen issues
# - Theme changes
```

**What it does:**
- Copies default hypridle config
- Applies theme colors
- Restarts hypridle service
- Resets idle timers

**Source:** `~/.local/share/omarchy/bin/omarchy-refresh-hypridle`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-refresh-hyprland

**Purpose:** Reset Hyprland configuration to defaults

**Usage:**
```bash
omarchy-refresh-hyprland
```

**Options:** None

**Examples:**

```bash
# Reset Hyprland config
omarchy-refresh-hyprland

# Reloads automatically
# Keybindings reset
# Theme applied
```

**What it does:**
- Copies default Hyprland configs
- Resets bindings.conf
- Resets monitors.conf
- Resets hyprland.conf
- Preserves user monitors
- Reloads Hyprland

**Warning:** Resets custom Hyprland changes

**Source:** `~/.local/share/omarchy/bin/omarchy-refresh-hyprland`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-refresh-hyprlock

**Purpose:** Refresh hyprlock configuration

**Usage:**
```bash
omarchy-refresh-hyprlock
```

**Options:** None

**Examples:**

```bash
# Refresh hyprlock
omarchy-refresh-hyprlock

# Test lock screen
omarchy-lock-screen
```

**What it does:**
- Copies default hyprlock config
- Applies theme colors
- Updates background
- Resets styling

**Source:** `~/.local/share/omarchy/bin/omarchy-refresh-hyprlock`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-refresh-hyprsunset

**Purpose:** Refresh hyprsunset configuration

**Usage:**
```bash
omarchy-refresh-hyprsunset
```

**Options:** None

**Examples:**

```bash
# Refresh hyprsunset
omarchy-refresh-hyprsunset

# Restart service
omarchy-restart-hyprsunset
```

**What it does:**
- Copies default hyprsunset config
- Resets color temperature settings
- Restarts service

**Source:** `~/.local/share/omarchy/bin/omarchy-refresh-hyprsunset`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-refresh-pacman-mirrorlist

**Purpose:** Refresh pacman mirror list

**Usage:**
```bash
omarchy-refresh-pacman-mirrorlist
```

**Options:** None

**Examples:**

```bash
# Refresh mirrors
omarchy-refresh-pacman-mirrorlist

# Useful when:
# - Downloads are slow
# - Mirror is down
# - New installation
```

**What it does:**
- Fetches latest mirrorlist
- Ranks mirrors by speed
- Updates /etc/pacman.d/mirrorlist
- Backs up old mirrorlist
- Updates package database

**Requires sudo**

**Source:** `~/.local/share/omarchy/bin/omarchy-refresh-pacman-mirrorlist`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-refresh-plymouth

**Purpose:** Refresh Plymouth boot screen

**Usage:**
```bash
omarchy-refresh-plymouth
```

**Options:** None

**Examples:**

```bash
# Refresh plymouth
omarchy-refresh-plymouth

# Rebuild initramfs
sudo mkinitcpio -P
```

**What it does:**
- Sets omarchy Plymouth theme
- Updates initramfs
- Configures boot splash
- Applies theme colors

**Requires sudo**

**Source:** `~/.local/share/omarchy/bin/omarchy-refresh-plymouth`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-refresh-swayosd

**Purpose:** Refresh swayosd configuration

**Usage:**
```bash
omarchy-refresh-swayosd
```

**Options:** None

**Examples:**

```bash
# Refresh swayosd
omarchy-refresh-swayosd

# Test volume OSD
# Press volume keys
```

**What it does:**
- Copies default swayosd config
- Applies theme colors
- Restarts swayosd service
- Updates OSD styling

**Source:** `~/.local/share/omarchy/bin/omarchy-refresh-swayosd`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-refresh-walker

**Purpose:** Refresh Walker configuration

**Usage:**
```bash
omarchy-refresh-walker
```

**Options:** None

**Examples:**

```bash
# Refresh walker
omarchy-refresh-walker

# Test launcher
omarchy-launch-walker
```

**What it does:**
- Copies default walker config
- Applies theme styling
- Rebuilds cache
- Restarts walker service

**Source:** `~/.local/share/omarchy/bin/omarchy-refresh-walker`

**Related:** [System Management](../02-core-commands/system-management.md), [Walker Elephant](../04-desktop-environment/walker-elephant.md)

---

### omarchy-refresh-waybar

**Purpose:** Refresh Waybar configuration

**Usage:**
```bash
omarchy-refresh-waybar
```

**Options:** None

**Examples:**

```bash
# Refresh waybar
omarchy-refresh-waybar

# Waybar restarts automatically
```

**What it does:**
- Copies default waybar config
- Copies default waybar style
- Applies theme colors
- Restarts waybar service

**Source:** `~/.local/share/omarchy/bin/omarchy-refresh-waybar`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-reset-sudo

**Purpose:** Reset sudo timestamp (require password again)

**Usage:**
```bash
omarchy-reset-sudo
```

**Options:** None

**Examples:**

```bash
# Reset sudo
omarchy-reset-sudo

# Next sudo command requires password
```

**What it does:**
- Invalidates sudo timestamp
- Forces password prompt on next sudo
- Used for security
- Useful after elevated session

**Source:** `~/.local/share/omarchy/bin/omarchy-reset-sudo`

**Related:** [Security & Auth](../07-system-setup/security-auth.md)

---

### omarchy-restart-app

**Purpose:** Restart specific application

**Usage:**
```bash
omarchy-restart-app APP_NAME
```

**Options:**
- `APP_NAME` - Application to restart

**Examples:**

```bash
# Restart browser
omarchy-restart-app chromium

# Restart terminal
omarchy-restart-app alacritty
```

**What it does:**
- Kills all instances of app
- Waits 1 second
- Relaunches app
- Preserves state if app supports it

**Source:** `~/.local/share/omarchy/bin/omarchy-restart-app`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-restart-bluetooth

**Purpose:** Restart Bluetooth service

**Usage:**
```bash
omarchy-restart-bluetooth
```

**Options:** None

**Examples:**

```bash
# Restart Bluetooth
omarchy-restart-bluetooth

# Useful when:
# - Device won't connect
# - Bluetooth unresponsive
# - After wake from sleep
```

**What it does:**
- Restarts bluetooth.service
- Restarts bluetooth-agent
- Re-initializes bluetooth adapter
- Reconnects paired devices

**Source:** `~/.local/share/omarchy/bin/omarchy-restart-bluetooth`

**Related:** [Audio, Bluetooth, WiFi](../07-system-setup/audio-bluetooth-wifi.md)

---

### omarchy-restart-hypridle

**Purpose:** Restart hypridle service

**Usage:**
```bash
omarchy-restart-hypridle
```

**Options:** None

**Examples:**

```bash
# Restart hypridle
omarchy-restart-hypridle

# Useful after:
# - Config changes
# - Timeout adjustments
# - Lock screen issues
```

**What it does:**
- Stops hypridle service
- Waits for clean shutdown
- Starts hypridle service
- Resets idle timers

**Source:** `~/.local/share/omarchy/bin/omarchy-restart-hypridle`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-restart-hyprsunset

**Purpose:** Restart hyprsunset service

**Usage:**
```bash
omarchy-restart-hyprsunset
```

**Options:** None

**Examples:**

```bash
# Restart hyprsunset
omarchy-restart-hyprsunset

# Useful after:
# - Config changes
# - Color temperature issues
```

**What it does:**
- Stops hyprsunset service
- Clears color temperature
- Starts hyprsunset service
- Reapplies settings

**Source:** `~/.local/share/omarchy/bin/omarchy-restart-hyprsunset`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-restart-pipewire

**Purpose:** Restart Pipewire audio services

**Usage:**
```bash
omarchy-restart-pipewire
```

**Options:** None

**Examples:**

```bash
# Restart audio
omarchy-restart-pipewire

# Useful when:
# - No audio output
# - Audio crackling
# - Device not detected
```

**What it does:**
1. Stops wireplumber
2. Stops pipewire-pulse
3. Stops pipewire
4. Waits 2 seconds
5. Starts pipewire
6. Starts pipewire-pulse
7. Starts wireplumber

**Source:** `~/.local/share/omarchy/bin/omarchy-restart-pipewire`

**Related:** [Audio, Bluetooth, WiFi](../07-system-setup/audio-bluetooth-wifi.md)

---

### omarchy-restart-swayosd

**Purpose:** Restart swayosd service

**Usage:**
```bash
omarchy-restart-swayosd
```

**Options:** None

**Examples:**

```bash
# Restart swayosd
omarchy-restart-swayosd

# Test OSD
# Press volume keys
```

**What it does:**
- Restarts swayosd-server
- Reloads config
- Reapplies theme styling

**Source:** `~/.local/share/omarchy/bin/omarchy-restart-swayosd`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-restart-walker

**Purpose:** Restart Walker service

**Usage:**
```bash
omarchy-restart-walker
```

**Options:** None

**Examples:**

```bash
# Restart walker
omarchy-restart-walker

# Useful after:
# - Config changes
# - Theme changes
# - Cache corruption
```

**What it does:**
- Stops walker service
- Clears stale locks
- Starts walker service
- Rebuilds cache

**Source:** `~/.local/share/omarchy/bin/omarchy-restart-walker`

**Related:** [Walker Elephant](../04-desktop-environment/walker-elephant.md)

---

### omarchy-restart-waybar

**Purpose:** Restart Waybar

**Usage:**
```bash
omarchy-restart-waybar
```

**Options:** None

**Examples:**

```bash
# Restart waybar
omarchy-restart-waybar

# Useful after:
# - Config changes
# - Theme changes
# - Module issues
```

**What it does:**
- Stops waybar service (if running as service)
- Or kills waybar process
- Waits 1 second
- Starts waybar
- Applies theme styling

**Source:** `~/.local/share/omarchy/bin/omarchy-restart-waybar`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-restart-wifi

**Purpose:** Restart WiFi service

**Usage:**
```bash
omarchy-restart-wifi
```

**Options:** None

**Examples:**

```bash
# Restart WiFi
omarchy-restart-wifi

# Useful when:
# - WiFi won't connect
# - Network unstable
# - After wake from sleep
```

**What it does:**
- Restarts NetworkManager
- Resets WiFi interface
- Reconnects to saved networks
- Clears stale connections

**Source:** `~/.local/share/omarchy/bin/omarchy-restart-wifi`

**Related:** [Audio, Bluetooth, WiFi](../07-system-setup/audio-bluetooth-wifi.md)

---

### omarchy-restart-xcompose

**Purpose:** Restart XCompose input method

**Usage:**
```bash
omarchy-restart-xcompose
```

**Options:** None

**Examples:**

```bash
# Restart XCompose
omarchy-restart-xcompose

# Useful for:
# - Compose key not working
# - Custom compose changes
```

**What it does:**
- Reloads XCompose config
- Resets compose key state
- Reapplies custom compose sequences

**Source:** `~/.local/share/omarchy/bin/omarchy-restart-xcompose`

**Related:** [System Management](../02-core-commands/system-management.md)

---

## Setup Tools

### omarchy-setup-dns

**Purpose:** Configure DNS settings

**Usage:**
```bash
omarchy-setup-dns
```

**Options:** None (interactive)

**Examples:**

```bash
# Setup DNS
omarchy-setup-dns

# Prompts for:
# - DNS provider (Cloudflare, Google, etc.)
# - Custom DNS servers
```

**What it does:**
- Configures /etc/resolv.conf
- Sets DNS servers
- Makes config immutable
- Tests DNS resolution

**Popular choices:**
- Cloudflare: 1.1.1.1
- Google: 8.8.8.8
- Quad9: 9.9.9.9

**Source:** `~/.local/share/omarchy/bin/omarchy-setup-dns`

**Related:** [Security & Auth](../07-system-setup/security-auth.md)

---

### omarchy-setup-fido2

**Purpose:** Set up FIDO2 security key authentication

**Usage:**
```bash
omarchy-setup-fido2 [--remove]
```

**Options:**
- `--remove` - Remove FIDO2 authentication

**Examples:**

```bash
# Setup FIDO2
omarchy-setup-fido2

# Follow prompts to:
# - Insert security key
# - Touch key to register
# - Register additional keys

# Remove FIDO2
omarchy-setup-fido2 --remove
```

**What it does:**
- Installs pam-u2f if needed
- Registers FIDO2 keys
- Configures PAM
- Tests authentication
- Adds key to login, sudo, etc.

**Supported keys:**
- YubiKey
- Google Titan
- Any FIDO2/U2F key

**Source:** `~/.local/share/omarchy/bin/omarchy-setup-fido2`

**Related:** [Security & Auth](../07-system-setup/security-auth.md)

---

### omarchy-setup-fingerprint

**Purpose:** Set up fingerprint authentication

**Usage:**
```bash
omarchy-setup-fingerprint [--remove]
```

**Options:**
- `--remove` - Remove fingerprint authentication

**Examples:**

```bash
# Setup fingerprint
omarchy-setup-fingerprint

# Follow prompts to:
# - Place finger on reader
# - Scan 5-10 times
# - Register multiple fingers

# Remove fingerprint
omarchy-setup-fingerprint --remove
```

**What it does:**
- Installs fprintd if needed
- Enrolls fingerprints
- Configures PAM
- Tests authentication
- Adds to login, sudo, lock screen

**Source:** `~/.local/share/omarchy/bin/omarchy-setup-fingerprint`

**Related:** [Security & Auth](../07-system-setup/security-auth.md)

---

## Display Tools

### omarchy-show-done

**Purpose:** Show completion message/notification

**Usage:**
```bash
omarchy-show-done [MESSAGE]
```

**Options:**
- `MESSAGE` - Optional custom message

**Examples:**

```bash
# Show default done message
omarchy-show-done

# Show custom message
omarchy-show-done "Installation complete"
```

**What it does:**
- Displays notification
- Shows checkmark icon
- Auto-dismisses after 3 seconds
- Used by other scripts

**Source:** `~/.local/share/omarchy/bin/omarchy-show-done`

**Related:** [Utility Scripts](../08-utilities/utility-scripts.md)

---

### omarchy-show-logo

**Purpose:** Display omarchy logo in terminal

**Usage:**
```bash
omarchy-show-logo
```

**Options:** None

**Examples:**

```bash
# Show logo
omarchy-show-logo

# ASCII art logo with colors
```

**What it does:**
- Displays ASCII art logo
- Uses theme colors
- Shows omarchy branding
- Used in welcome screens

**Source:** `~/.local/share/omarchy/bin/omarchy-show-logo`

**Related:** [Utility Scripts](../08-utilities/utility-scripts.md)

---

## Snapshot Tools

### omarchy-snapshot

**Purpose:** Create system snapshot (if using btrfs)

**Usage:**
```bash
omarchy-snapshot [DESCRIPTION]
```

**Options:**
- `DESCRIPTION` - Optional snapshot description

**Examples:**

```bash
# Create snapshot
omarchy-snapshot

# Create with description
omarchy-snapshot "Before major update"
```

**What it does:**
- Creates btrfs snapshot (if btrfs filesystem)
- Timestamps snapshot
- Adds description
- Lists created snapshot

**Requires:**
- btrfs filesystem
- snapper installed

**Source:** `~/.local/share/omarchy/bin/omarchy-snapshot`

**Related:** [System Management](../02-core-commands/system-management.md)

---

## State Management

### omarchy-state

**Purpose:** Manage omarchy persistent state

**Usage:**
```bash
omarchy-state get KEY
omarchy-state set KEY VALUE
omarchy-state clear KEY
```

**Options:**
- `get KEY` - Get state value
- `set KEY VALUE` - Set state value
- `clear KEY` - Clear state value

**Examples:**

```bash
# Set state
omarchy-state set last-update "2025-10-21"

# Get state
omarchy-state get last-update
# Output: 2025-10-21

# Clear state
omarchy-state clear last-update
```

**What it does:**
- Stores key-value pairs
- Persists across reboots
- Used by omarchy scripts
- Location: `~/.local/state/omarchy/state/`

**Use cases:**
- Track last update time
- Store user preferences
- Remember script state
- Flag completion status

**Source:** `~/.local/share/omarchy/bin/omarchy-state`

**Related:** [System Management](../02-core-commands/system-management.md)

---

## Theme Management

### omarchy-theme-bg-next

**Purpose:** Cycle to next background in theme

**Usage:**
```bash
omarchy-theme-bg-next
```

**Options:** None

**Examples:**

```bash
# Cycle background
omarchy-theme-bg-next

# Keep pressing to cycle through all
# Wraps back to first after last
```

**What it does:**
1. Lists backgrounds in current theme
2. Finds current background
3. Selects next in alphabetical order
4. Updates background symlink
5. Restarts swaybg
6. Displays new background

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-bg-next`

**Related:** [Backgrounds](../03-theming/backgrounds.md)

---

### omarchy-theme-current

**Purpose:** Display current theme name

**Usage:**
```bash
omarchy-theme-current
```

**Options:** None

**Examples:**

```bash
# Show current theme
omarchy-theme-current
# Output: Catppuccin

# Use in scripts
THEME=$(omarchy-theme-current)
echo "Current theme: $THEME"
```

**What it does:**
- Reads theme symlink
- Extracts theme name
- Returns formatted name

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-current`

**Related:** [Theme System](../03-theming/theme-system.md)

---

### omarchy-theme-install

**Purpose:** Install theme from git repository

**Usage:**
```bash
omarchy-theme-install [GIT_URL]
```

**Options:**
- `GIT_URL` - Git repository URL (optional, prompts if not provided)

**Examples:**

```bash
# Interactive install
omarchy-theme-install

# Direct install
omarchy-theme-install https://github.com/user/omarchy-theme-custom

# Install from local path
omarchy-theme-install ~/themes/my-theme
```

**What it does:**
1. Prompts for git URL (if not provided)
2. Validates URL/path
3. Clones to `~/.config/omarchy/themes/`
4. Validates theme structure
5. Optionally sets as active theme

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-install`

**Related:** [Creating Themes](../03-theming/creating-themes.md)

---

### omarchy-theme-list

**Purpose:** List all installed themes

**Usage:**
```bash
omarchy-theme-list
```

**Options:** None

**Examples:**

```bash
# List themes
omarchy-theme-list

# Output:
# Catppuccin
# Catppuccin Latte
# Everforest
# Gruvbox
# Tokyo Night
# ...
```

**What it does:**
- Scans `~/.config/omarchy/themes/`
- Lists directories
- Formats names (Title Case)
- Returns sorted list

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-list`

**Related:** [Theme System](../03-theming/theme-system.md)

---

### omarchy-theme-next

**Purpose:** Cycle to next theme

**Usage:**
```bash
omarchy-theme-next
```

**Options:** None

**Examples:**

```bash
# Switch to next theme
omarchy-theme-next

# Notification shows new theme name
# Keep pressing to cycle through all
```

**What it does:**
1. Gets current theme
2. Lists all themes
3. Finds next in list
4. Calls omarchy-theme-set with next theme
5. Wraps to first theme after last

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-next`

**Related:** [Theme System](../03-theming/theme-system.md)

---

### omarchy-theme-remove

**Purpose:** Remove installed theme

**Usage:**
```bash
omarchy-theme-remove [THEME_NAME]
```

**Options:**
- `THEME_NAME` - Theme to remove (optional, prompts if not provided)

**Examples:**

```bash
# Interactive removal
omarchy-theme-remove

# Direct removal
omarchy-theme-remove my-custom-theme
```

**What it does:**
1. Prompts for theme (if not provided)
2. Checks if theme is active
3. Switches to different theme if active
4. Confirms removal
5. Deletes theme directory

**Warning:** Cannot be undone

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-remove`

**Related:** [Creating Themes](../03-theming/creating-themes.md)

---

### omarchy-theme-set

**Purpose:** Set active theme

**Usage:**
```bash
omarchy-theme-set THEME_NAME
```

**Options:**
- `THEME_NAME` - Theme to activate

**Examples:**

```bash
# Set theme
omarchy-theme-set catppuccin

# Set light theme
omarchy-theme-set catppuccin-latte

# Case insensitive
omarchy-theme-set TOKYO-NIGHT
```

**What it does:**
1. Validates theme exists
2. Updates theme symlink
3. Cycles to first background
4. Restarts Waybar
5. Restarts Swayosd
6. Reloads Hyprland
7. Updates terminals
8. Updates GNOME settings
9. Updates browser theme
10. Updates VS Code theme
11. Updates Cursor theme
12. Updates Obsidian themes
13. Runs theme-set hooks
14. Sends notification

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-set`

**Related:** [Theme System](../03-theming/theme-system.md)

---

### omarchy-theme-set-browser

**Purpose:** Update browser theme (internal)

**Usage:**
```bash
omarchy-theme-set-browser
```

**Options:** None

**Examples:**

```bash
# Update browser theme
omarchy-theme-set-browser

# Usually called by omarchy-theme-set
```

**What it does:**
- Reads chromium.theme from current theme
- Extracts RGB color
- Sets Chromium theme color
- Sets Brave theme color
- Sets color scheme (light/dark)

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-set-browser`

**Related:** [Theme System](../03-theming/theme-system.md)

---

### omarchy-theme-set-cursor

**Purpose:** Update Cursor editor theme (internal)

**Usage:**
```bash
omarchy-theme-set-cursor
```

**Options:** None

**Examples:**

```bash
# Update Cursor theme
omarchy-theme-set-cursor

# Usually called by omarchy-theme-set
```

**What it does:**
- Same as omarchy-theme-set-vscode
- But for Cursor editor
- Updates ~/.config/Cursor/User/settings.json

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-set-cursor`

**Related:** [Theme System](../03-theming/theme-system.md)

---

### omarchy-theme-set-gnome

**Purpose:** Update GNOME/GTK theme (internal)

**Usage:**
```bash
omarchy-theme-set-gnome
```

**Options:** None

**Examples:**

```bash
# Update GTK theme
omarchy-theme-set-gnome

# Usually called by omarchy-theme-set
```

**What it does:**
- Checks for light.mode file
- Sets GTK theme (Adwaita or Adwaita-dark)
- Sets icon theme from icons.theme
- Sets color scheme preference
- Updates gsettings

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-set-gnome`

**Related:** [Theme System](../03-theming/theme-system.md)

---

### omarchy-theme-set-obsidian

**Purpose:** Update Obsidian vault themes (internal)

**Usage:**
```bash
omarchy-theme-set-obsidian
```

**Options:** None

**Examples:**

```bash
# Update Obsidian themes
omarchy-theme-set-obsidian

# Updates all vaults
# Usually called by omarchy-theme-set
```

**What it does:**
1. Lists Obsidian vaults
2. For each vault:
   - Creates .obsidian/themes/Omarchy/
   - Copies obsidian.css if exists
   - Or generates theme.css from alacritty colors
   - Extracts colors from theme files
   - Maps to Obsidian CSS variables
   - Sorts by frequency
3. Sends notification with vault count

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-set-obsidian`

**Related:** [Theme System](../03-theming/theme-system.md)

---

### omarchy-theme-set-terminal

**Purpose:** Update terminal themes (internal)

**Usage:**
```bash
omarchy-theme-set-terminal
```

**Options:** None

**Examples:**

```bash
# Update terminal themes
omarchy-theme-set-terminal

# Usually called by omarchy-theme-set
```

**What it does:**
- Touches Alacritty config (triggers reload)
- Sends SIGUSR1 to Kitty (reloads config)
- Sends SIGUSR2 to Ghostty (reloads config)
- Updates running terminals immediately

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-set-terminal`

**Related:** [Theme System](../03-theming/theme-system.md)

---

### omarchy-theme-set-vscode

**Purpose:** Update VS Code theme (internal)

**Usage:**
```bash
omarchy-theme-set-vscode
```

**Options:** None

**Examples:**

```bash
# Update VS Code theme
omarchy-theme-set-vscode

# Usually called by omarchy-theme-set
```

**What it does:**
1. Checks if code is installed
2. Reads vscode.json from theme
3. Installs theme extension if missing
4. Updates settings.json
5. Sets workbench.colorTheme
6. Sends notification

**Skips if:**
- VS Code not installed
- Skip flag exists (~/.local/state/omarchy/toggles/skip-vscode-theme-changes)

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-set-vscode`

**Related:** [Theme System](../03-theming/theme-system.md)

---

### omarchy-theme-update

**Purpose:** Update all git-based themes

**Usage:**
```bash
omarchy-theme-update
```

**Options:** None

**Examples:**

```bash
# Update themes
omarchy-theme-update

# Pulls latest from git repos
# Shows update summary
```

**What it does:**
1. Scans `~/.config/omarchy/themes/`
2. For each theme with .git:
   - Runs git pull
   - Shows changes
   - Notes if conflicts
3. Lists updated themes
4. Suggests re-applying current theme

**Source:** `~/.local/share/omarchy/bin/omarchy-theme-update`

**Related:** [Creating Themes](../03-theming/creating-themes.md)

---

## Toggle Commands

### omarchy-toggle-idle

**Purpose:** Toggle idle lock on/off

**Usage:**
```bash
omarchy-toggle-idle
```

**Options:** None

**Examples:**

```bash
# Toggle idle lock
omarchy-toggle-idle

# Notification shows new state
# On: Screen locks after timeout
# Off: Screen never locks
```

**What it does:**
- Checks current hypridle state
- If enabled: disables hypridle
- If disabled: enables hypridle
- Sends notification
- Shows state in Waybar (if module exists)

**Source:** `~/.local/share/omarchy/bin/omarchy-toggle-idle`

**Related:** [Utility Scripts](../08-utilities/utility-scripts.md)

---

### omarchy-toggle-nightlight

**Purpose:** Toggle night light (red shift) on/off

**Usage:**
```bash
omarchy-toggle-nightlight
```

**Options:** None

**Examples:**

```bash
# Toggle night light
omarchy-toggle-nightlight

# Notification shows new state
# On: Warm color temperature
# Off: Normal color temperature
```

**What it does:**
- Checks hyprsunset state
- If off: enables (warm colors)
- If on: disables (normal colors)
- Sends notification

**Source:** `~/.local/share/omarchy/bin/omarchy-toggle-nightlight`

**Related:** [Utility Scripts](../08-utilities/utility-scripts.md)

---

### omarchy-toggle-screensaver

**Purpose:** Toggle screensaver on/off

**Usage:**
```bash
omarchy-toggle-screensaver
```

**Options:** None

**Examples:**

```bash
# Toggle screensaver
omarchy-toggle-screensaver

# Notification shows new state
```

**What it does:**
- Checks screensaver state
- Toggles enable/disable
- Updates hypridle config
- Sends notification

**Source:** `~/.local/share/omarchy/bin/omarchy-toggle-screensaver`

**Related:** [Utility Scripts](../08-utilities/utility-scripts.md)

---

### omarchy-toggle-waybar

**Purpose:** Toggle Waybar visibility

**Usage:**
```bash
omarchy-toggle-waybar
```

**Options:** None

**Examples:**

```bash
# Toggle waybar
omarchy-toggle-waybar

# Waybar shows/hides
# Useful for:
# - Screenshots
# - Presentations
# - Temporary more screen space
```

**What it does:**
- Checks waybar process
- If visible: kills waybar
- If hidden: starts waybar
- Remembers state

**Source:** `~/.local/share/omarchy/bin/omarchy-toggle-waybar`

**Related:** [Waybar Configuration](../04-desktop-environment/waybar-configuration.md)

---

## TUI Management

### omarchy-tui-install

**Purpose:** Install TUI (terminal) application

**Usage:**
```bash
omarchy-tui-install [APP]
```

**Options:**
- `APP` - TUI app to install (optional, prompts if not provided)

**Examples:**

```bash
# Interactive install
omarchy-tui-install

# Direct install
omarchy-tui-install lazygit
```

**What it does:**
- Lists available TUI apps
- Installs selected app
- Configures app if needed
- Adds to tracking list

**Popular TUI apps:**
- lazygit (Git UI)
- lazydocker (Docker UI)
- btop (System monitor)
- ranger (File manager)
- ncdu (Disk usage)

**Source:** `~/.local/share/omarchy/bin/omarchy-tui-install`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-tui-remove

**Purpose:** Remove TUI application

**Usage:**
```bash
omarchy-tui-remove [APP]
```

**Options:**
- `APP` - TUI app to remove (optional, prompts if not provided)

**Examples:**

```bash
# Interactive removal
omarchy-tui-remove

# Direct removal
omarchy-tui-remove lazygit
```

**What it does:**
- Lists installed TUI apps
- Removes selected app
- Cleans up configs
- Removes from tracking list

**Source:** `~/.local/share/omarchy/bin/omarchy-tui-remove`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

## Timezone Selection

### omarchy-tz-select

**Purpose:** Select timezone

**Usage:**
```bash
omarchy-tz-select
```

**Options:** None (interactive)

**Examples:**

```bash
# Select timezone
omarchy-tz-select

# Interactive menu:
# 1. Choose region (Americas, Europe, etc.)
# 2. Choose city
# 3. Confirm selection
```

**What it does:**
- Lists available timezones
- Allows selection via menu
- Sets system timezone
- Updates /etc/localtime
- Restarts time-related services

**Requires sudo**

**Source:** `~/.local/share/omarchy/bin/omarchy-tz-select`

**Related:** [System Management](../02-core-commands/system-management.md)

---

## Update System

### omarchy-update

**Purpose:** Update entire omarchy system

**Usage:**
```bash
omarchy-update
```

**Options:** None

**Examples:**

```bash
# Full update
omarchy-update

# Updates:
# - Arch packages
# - AUR packages
# - Omarchy scripts
# - Themes
```

**What it does:**
1. Updates package database
2. Updates Arch packages (pacman -Syu)
3. Updates AUR packages (yay -Sua)
4. Updates omarchy (git pull)
5. Updates themes (git pull in each)
6. Runs migrations
7. Refreshes configs
8. Sends completion notification

**Recommended:** Run weekly

**Source:** `~/.local/share/omarchy/bin/omarchy-update`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-update-available

**Purpose:** Check if updates are available

**Usage:**
```bash
omarchy-update-available
```

**Options:** None

**Examples:**

```bash
# Check for updates
if omarchy-update-available; then
    echo "Updates available"
    omarchy-update
fi
```

**What it does:**
- Checks for Arch updates (checkupdates)
- Checks for AUR updates (yay -Qua)
- Checks omarchy git (git fetch)
- Returns 0 if updates available
- Returns 1 if up to date

**Source:** `~/.local/share/omarchy/bin/omarchy-update-available`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-update-available-reset

**Purpose:** Reset update available flag

**Usage:**
```bash
omarchy-update-available-reset
```

**Options:** None

**Examples:**

```bash
# Reset flag
omarchy-update-available-reset

# Useful after:
# - Manual updates
# - False positives
```

**What it does:**
- Clears update check cache
- Resets timestamp
- Forces new check next time

**Source:** `~/.local/share/omarchy/bin/omarchy-update-available-reset`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-update-branch

**Purpose:** Switch omarchy branch

**Usage:**
```bash
omarchy-update-branch BRANCH
```

**Options:**
- `master` - Stable branch
- `dev` - Development branch

**Examples:**

```bash
# Switch to dev
omarchy-update-branch dev

# Switch to stable
omarchy-update-branch master
```

**What it does:**
1. Changes git branch
2. Pulls latest from new branch
3. Runs migrations
4. Refreshes configs
5. Sends notification

**Warning:** Dev branch may have bugs

**Source:** `~/.local/share/omarchy/bin/omarchy-update-branch`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-update-firmware

**Purpose:** Update system firmware

**Usage:**
```bash
omarchy-update-firmware
```

**Options:** None

**Examples:**

```bash
# Update firmware
omarchy-update-firmware

# May require reboot after
```

**What it does:**
- Checks for firmware updates (fwupd)
- Downloads available updates
- Installs firmware
- Shows update details
- Prompts for reboot if needed

**Source:** `~/.local/share/omarchy/bin/omarchy-update-firmware`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-update-git

**Purpose:** Update omarchy from git (internal)

**Usage:**
```bash
omarchy-update-git
```

**Options:** None

**Examples:**

```bash
# Update omarchy only
omarchy-update-git

# Usually called by omarchy-update
```

**What it does:**
- Goes to omarchy git directory
- Runs git pull
- Shows changes
- Updates scripts
- Preserves user configs

**Source:** `~/.local/share/omarchy/bin/omarchy-update-git`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-update-perform

**Purpose:** Perform system update (internal)

**Usage:**
```bash
omarchy-update-perform
```

**Options:** None

**Examples:**

```bash
# Run update process
omarchy-update-perform

# Usually called by omarchy-update
```

**What it does:**
1. Pre-update hook
2. Update packages
3. Update omarchy
4. Run migrations
5. Post-update hook
6. Show summary

**Source:** `~/.local/share/omarchy/bin/omarchy-update-perform`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-update-restart

**Purpose:** Restart after system update

**Usage:**
```bash
omarchy-update-restart
```

**Options:** None

**Examples:**

```bash
# Restart system
omarchy-update-restart

# Prompts for confirmation
# Gives 30 second countdown
```

**What it does:**
- Confirms restart
- Saves all work warning
- Countdown timer
- Restarts system

**Source:** `~/.local/share/omarchy/bin/omarchy-update-restart`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-update-system-pkgs

**Purpose:** Update only system packages

**Usage:**
```bash
omarchy-update-system-pkgs
```

**Options:** None

**Examples:**

```bash
# Update packages only
omarchy-update-system-pkgs

# Doesn't update omarchy scripts
# Useful for quick security updates
```

**What it does:**
1. Updates package database
2. Updates Arch packages
3. Updates AUR packages
4. Skips omarchy/theme updates

**Source:** `~/.local/share/omarchy/bin/omarchy-update-system-pkgs`

**Related:** [System Management](../02-core-commands/system-management.md)

---

## Upload Tools

### omarchy-upload-log

**Purpose:** Upload diagnostic logs for troubleshooting

**Usage:**
```bash
omarchy-upload-log
```

**Options:** None

**Examples:**

```bash
# Upload logs
omarchy-upload-log

# Returns URL like:
# Logs uploaded: https://paste.example.com/abc123
# Share this URL when reporting issues
```

**What it includes:**
- System information
- omarchy version
- Hyprland logs
- Service status (walker, waybar, etc.)
- Recent journal entries
- Package list
- Config snippets (no passwords)
- Hardware info

**What it doesn't include:**
- Personal files
- Passwords
- Private keys
- Browsing history

**Privacy:** Review logs before sharing URL

**Source:** `~/.local/share/omarchy/bin/omarchy-upload-log`

**Related:** [Troubleshooting](./troubleshooting.md)

---

## Version Management

### omarchy-version

**Purpose:** Display omarchy version

**Usage:**
```bash
omarchy-version
```

**Options:** None

**Examples:**

```bash
# Show version
omarchy-version
# Output: omarchy 3.1.1 (2025-10-21)

# Use in scripts
VERSION=$(omarchy-version)
echo "Running $VERSION"
```

**What it does:**
- Reads version from git
- Shows commit hash
- Shows branch
- Shows last update date

**Source:** `~/.local/share/omarchy/bin/omarchy-version`

**Related:** [System Management](../02-core-commands/system-management.md)

---

### omarchy-version-branch

**Purpose:** Display current omarchy branch

**Usage:**
```bash
omarchy-version-branch
```

**Options:** None

**Examples:**

```bash
# Show branch
omarchy-version-branch
# Output: master

# Or: dev
```

**What it does:**
- Reads git branch
- Returns branch name
- Used to check if on stable/dev

**Source:** `~/.local/share/omarchy/bin/omarchy-version-branch`

**Related:** [System Management](../02-core-commands/system-management.md)

---

## Webapp Management

### omarchy-webapp-handler-hey

**Purpose:** Handler for HEY webapp (internal)

**Usage:**
```bash
omarchy-webapp-handler-hey
```

**Options:** None

**Examples:**

```bash
# Usually not called directly
# Triggered by webapp links
```

**What it does:**
- Handles hey:// protocol URLs
- Opens HEY webapp
- Focuses HEY window if running

**Source:** `~/.local/share/omarchy/bin/omarchy-webapp-handler-hey`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-webapp-handler-zoom

**Purpose:** Handler for Zoom webapp (internal)

**Usage:**
```bash
omarchy-webapp-handler-zoom
```

**Options:** None

**Examples:**

```bash
# Usually not called directly
# Triggered by zoom:// URLs
```

**What it does:**
- Handles zoom:// protocol URLs
- Opens Zoom webapp
- Joins meetings via web client

**Source:** `~/.local/share/omarchy/bin/omarchy-webapp-handler-zoom`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-webapp-install

**Purpose:** Install web application

**Usage:**
```bash
omarchy-webapp-install [NAME_OR_URL]
```

**Options:**
- `NAME` - Predefined webapp name
- `URL` - Custom URL to install as webapp

**Examples:**

```bash
# Interactive install
omarchy-webapp-install

# Install predefined webapp
omarchy-webapp-install notion

# Install custom webapp
omarchy-webapp-install https://app.example.com
```

**What it does:**
1. Prompts for name/URL (if not provided)
2. Creates desktop entry
3. Sets up icon
4. Configures window rules
5. Makes available in launcher

**Predefined webapps:**
- Notion
- Figma
- Linear
- HEY
- ChatGPT
- And more...

**Source:** `~/.local/share/omarchy/bin/omarchy-webapp-install`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

### omarchy-webapp-remove

**Purpose:** Remove web application

**Usage:**
```bash
omarchy-webapp-remove [NAME]
```

**Options:**
- `NAME` - Webapp to remove (optional, prompts if not provided)

**Examples:**

```bash
# Interactive removal
omarchy-webapp-remove

# Direct removal
omarchy-webapp-remove notion
```

**What it does:**
1. Lists installed webapps
2. Prompts for selection (if not provided)
3. Confirms removal
4. Removes desktop entry
5. Removes icon
6. Cleans up config

**Source:** `~/.local/share/omarchy/bin/omarchy-webapp-remove`

**Related:** [Package Management](../02-core-commands/package-management.md)

---

## Windows VM

### omarchy-windows-vm

**Purpose:** Manage Windows virtual machine

**Usage:**
```bash
omarchy-windows-vm [install|remove|start|stop]
```

**Options:**
- `install` - Install Windows VM
- `remove` - Remove Windows VM
- `start` - Start Windows VM
- `stop` - Stop Windows VM

**Examples:**

```bash
# Install Windows VM
omarchy-windows-vm install
# Follow prompts for ISO and settings

# Start VM
omarchy-windows-vm start

# Stop VM
omarchy-windows-vm stop

# Remove VM
omarchy-windows-vm remove
```

**What it does:**

**Install:**
1. Installs qemu/KVM
2. Creates virtual disk
3. Prompts for Windows ISO
4. Configures VM settings
5. Installs Windows

**Start:**
- Launches Windows VM
- Full screen or windowed
- GPU passthrough if available

**Stop:**
- Gracefully shuts down VM
- Saves state

**Remove:**
- Deletes VM disk
- Removes config
- Cleans up

**Requirements:**
- 60+ GB disk space
- 8+ GB RAM recommended
- Windows ISO file

**Source:** `~/.local/share/omarchy/bin/omarchy-windows-vm`

**Related:** [Productivity Apps](../05-applications/productivity-apps.md)

---

## Script Index Summary

**Total Scripts:** 124

**Categories:**
- Battery & Power Management: 2 scripts
- Command Scripts: 12 scripts
- Development Tools: 1 script
- Drive Management: 3 scripts
- Font Management: 3 scripts
- Hooks System: 1 script
- Installation Scripts: 8 scripts
- Launch Commands: 13 scripts
- Menu System: 2 scripts
- Migration Tools: 1 script
- Notification Tools: 1 script
- Package Management: 10 scripts
- Power Profiles: 1 script
- Refresh & Restart: 16 scripts
- Setup Tools: 3 scripts
- Display Tools: 2 scripts
- Snapshot Tools: 1 script
- State Management: 1 script
- Theme Management: 15 scripts
- Toggle Commands: 4 scripts
- TUI Management: 2 scripts
- Timezone Selection: 1 script
- Update System: 10 scripts
- Upload Tools: 1 script
- Version Management: 2 scripts
- Webapp Management: 4 scripts
- Windows VM: 1 script

---

## Related Documentation

- [Quick Reference](./quick-reference.md) - Fast command lookups
- [Troubleshooting](./troubleshooting.md) - Problem solving guide
- [FAQ](./faq.md) - Frequently asked questions
- [Command Index](../02-core-commands/command-index.md) - All commands A-Z
- [SCRIPT-MAP.md](../SCRIPT-MAP.md) - Quick script mapping

---

*This script index provides complete documentation for all 124 omarchy scripts with detailed usage information, examples, and cross-references.*
