# Omarchy First Run Guide

**Purpose:** Post-installation configuration and orientation
**Use Case:** Setting up Omarchy after initial installation

*Last Updated: 2025-10-21*

---

## Quick Start (30-Second Guide)

```bash
# First-run wizard runs automatically on first login
# If you need to run it manually:
omarchy-cmd-first-run

# Or access individual configuration tools:
omarchy-menu → Setup → WiFi
omarchy-menu → Setup → Audio
omarchy-menu → Style → Theme
```

---

## Table of Contents

- [First Run Overview](#first-run-overview)
- [Initial Configuration Steps](#initial-configuration-steps)
- [Setting Up Your Environment](#setting-up-your-environment)
- [Learning the Interface](#learning-the-interface)
- [Essential Keybindings](#essential-keybindings)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Related Documentation](#related-documentation)

---

## First Run Overview

### What Happens on First Login

After installing Omarchy and rebooting, the system automatically runs `omarchy-cmd-first-run` which executes a series of setup scripts:

**1. Battery Monitor Setup** (`battery-monitor.sh`)
- Detects if you're on a laptop (checks for battery)
- Enables battery monitoring service if applicable
- Configures power management

**2. Cleanup Temporary Configs** (`cleanup-reboot-sudoers.sh`)
- Removes temporary sudo permissions used during installation
- Cleans up installation artifacts

**3. Firewall Configuration** (`firewall.sh`)
- Sets up UFW (Uncomplicated Firewall)
- Default deny incoming, allow outgoing
- Opens ports for LocalSend (file sharing)
- Opens port 22 for SSH
- Configures Docker DNS access
- Enables firewall on boot

**4. DNS Resolver Setup** (`dns-resolver.sh`)
- Configures systemd-resolved
- Sets up DNS caching
- Optimizes DNS performance

**5. GNOME Theme Setup** (`gnome-theme.sh`)
- Configures GTK theme preferences
- Sets icon theme
- Applies light/dark mode based on current theme

**6. WiFi Configuration** (`wifi.sh`)
- Checks for internet connection
- If offline, shows notification to configure WiFi
- Prompts to run network configuration tool

**7. Welcome Message** (`welcome.sh`)
- Displays notifications with essential information
- Prompts to update system
- Shows keybinding reference

---

### First Run Mode Flag

First run is controlled by a flag file:

```bash
~/.local/state/omarchy/first-run.mode
```

When this file exists, `omarchy-cmd-first-run` executes on login. After completion, the file is deleted to prevent running again.

**To manually trigger first run:**

```bash
# Create flag file
touch ~/.local/state/omarchy/first-run.mode

# Logout and login, or manually run:
omarchy-cmd-first-run
```

---

## Initial Configuration Steps

### Step 1: Connect to WiFi (Laptops)

If you're on WiFi and not connected:

**Via Notification:**

1. Click notification: "Click to Setup Wi-Fi"
2. Network manager opens (nmtui)
3. Navigate with Tab/Arrow keys
4. Press Enter to activate connection
5. Select your network
6. Enter password
7. Select "Activate"

**Via Omarchy Menu:**

```bash
# Press SUPER+M or run:
omarchy-menu

# Navigate: Setup → WiFi
# This runs: omarchy-launch-wifi
```

**Via Command Line:**

```bash
# Text UI (recommended)
nmtui

# Or command line directly:
nmcli device wifi list
nmcli device wifi connect "Your Network SSID" password "your-password"
```

**Verify connection:**

```bash
ping -c 3 1.1.1.1
# Should see successful pings
```

---

### Step 2: Update System

After connecting to internet, update Omarchy:

**Via Notification:**

Click: "Update System"

**Via Omarchy Menu:**

```bash
omarchy-menu → Update → Omarchy
```

**Via Command:**

```bash
omarchy-update
```

**This updates:**
- Omarchy scripts from Git
- System packages via pacman
- AUR packages via yay (if installed)
- Configuration files (if you opt-in)

**Expected output:**

```
Updating Omarchy from Git...
Already up to date.

Updating system packages...
:: Synchronizing package databases...
:: Starting full system upgrade...
Nothing to do.

Update complete!
```

---

### Step 3: Choose Your Theme

Default theme is Tokyo Night. You may want to change it:

**Via Omarchy Menu:**

```bash
omarchy-menu → Style → Theme
# Select from list of 12 themes
```

**Via Command:**

```bash
# List available themes
omarchy-theme-list

# Set your preferred theme
omarchy-theme-set catppuccin
omarchy-theme-set gruvbox
omarchy-theme-set nord
# etc.
```

**Theme descriptions:**

- **Catppuccin** - Pastel dark theme, easy on eyes
- **Catppuccin Latte** - Pastel light theme for bright environments
- **Tokyo Night** - Vibrant blues and purples (default)
- **Gruvbox** - Retro warm colors, yellow/orange accents
- **Nord** - Cool arctic blues, professional look
- **Rose Pine** - Elegant dusty roses and purples
- **Everforest** - Natural greens, forest-inspired
- **Flexoki Light** - Minimal beige, great for reading
- **Kanagawa** - Muted Japanese-inspired palette
- **Matte Black** - Pure blacks, perfect for OLED
- **Osaka Jade** - Vibrant jade greens, cyberpunk aesthetic
- **Ristretto** - Warm coffee browns

**See:** [Theme System](../03-theming/theme-system.md) for detailed theme information

---

### Step 4: Configure Audio

Set up audio devices and volume:

**Via Omarchy Menu:**

```bash
omarchy-menu → Setup → Audio
# Opens wiremix (TUI audio mixer)
```

**Via Command:**

```bash
# TUI mixer (recommended)
wiremix

# Or GUI mixer
pavucontrol
```

**In wiremix:**

- Arrow keys to navigate
- M to mute/unmute
- +/- to adjust volume
- Tab to switch between playback/recording
- Q to quit

**Test audio:**

```bash
# Play test sound
speaker-test -t wav -c 2

# Or play a song
mpv ~/Music/song.mp3
```

---

### Step 5: Set Your Fonts

Default font is JetBrains Mono Nerd Font. Change if desired:

**Via Omarchy Menu:**

```bash
omarchy-menu → Style → Font
```

**Via Command:**

```bash
# List installed fonts
omarchy-font-list

# Set font
omarchy-font-set "MesloLGL Nerd Font"
omarchy-font-set "FiraCode Nerd Font"
```

**Install additional fonts:**

```bash
omarchy-menu → Install → Style → Font
# Choose from:
# - Meslo LG Mono
# - Fira Code
# - Victor Mono
# - Bitstream Vera Mono
```

**See:** [Fonts](../03-theming/fonts.md)

---

### Step 6: Configure Your Terminal

Choose your preferred terminal emulator:

**Installed by default:**
- Alacritty (default)
- Kitty

**Install additional:**

```bash
omarchy-menu → Install → Terminal → Ghostty
```

**Set default:**

```bash
# Edit UWSM defaults
nvim ~/.config/uwsm/default

# Change TERMINAL variable:
# TERMINAL=alacritty
# TERMINAL=kitty
# TERMINAL=ghostty
```

**Terminal-specific configs:**

```bash
# Alacritty
nvim ~/.config/alacritty/alacritty.toml

# Kitty
nvim ~/.config/kitty/kitty.conf

# Ghostty
nvim ~/.config/ghostty/config
```

**See:** [Terminal Configuration](../04-desktop-environment/terminals.md)

---

## Setting Up Your Environment

### Configure Monitors

For multi-monitor setups or custom resolutions:

**Via Omarchy Menu:**

```bash
omarchy-menu → Setup → Monitors
# Opens: ~/.config/hypr/monitors.conf
```

**Manual configuration:**

```bash
nvim ~/.config/hypr/monitors.conf
```

**Example configurations:**

```conf
# Single 1080p monitor
monitor = DP-1, 1920x1080@60, 0x0, 1

# Dual monitors side-by-side
monitor = DP-1, 2560x1440@144, 0x0, 1
monitor = HDMI-A-1, 1920x1080@60, 2560x0, 1

# Laptop + external monitor
monitor = eDP-1, 1920x1080@60, 0x0, 1
monitor = DP-2, 2560x1440@144, 1920x0, 1

# Auto-configure all monitors
monitor = , preferred, auto, 1

# Disable laptop screen when lid closed
monitor = eDP-1, disable
```

**Apply changes:**

```bash
hyprctl reload
```

**See:** [Monitor Configuration](../07-system-setup/monitors.md)

---

### Set Up Power Management (Laptops)

Configure screen timeout, sleep, and lid behavior:

**Edit hypridle config:**

```bash
nvim ~/.config/hypr/hypridle.conf
```

**Key settings:**

```conf
# Lock screen after 5 minutes
listener {
    timeout = 300
    on-timeout = omarchy-lock-screen
}

# Turn off screen after 10 minutes
listener {
    timeout = 600
    on-timeout = hyprctl dispatch dpms off
    on-resume = hyprctl dispatch dpms on
}

# Suspend after 30 minutes
listener {
    timeout = 1800
    on-timeout = systemctl suspend
}
```

**Power profiles:**

```bash
omarchy-menu → Setup → Power Profile
# Choose: power-saver, balanced, performance
```

**See:** [Power Management](../07-system-setup/power-management.md)

---

### Configure Bluetooth

Pair Bluetooth devices (headphones, mice, keyboards):

**Via Omarchy Menu:**

```bash
omarchy-menu → Setup → Bluetooth
# Opens Blueberry GUI
```

**Via Command:**

```bash
# GUI
blueberry

# Or CLI
bluetoothctl
```

**In bluetoothctl:**

```bash
# Turn on Bluetooth
power on

# Make discoverable
discoverable on

# Scan for devices
scan on

# Pair device (use TAB to autocomplete MAC address)
pair XX:XX:XX:XX:XX:XX

# Trust device
trust XX:XX:XX:XX:XX:XX

# Connect
connect XX:XX:XX:XX:XX:XX

# Exit
exit
```

**Auto-connect on boot:**

Trusted devices connect automatically.

---

### Set Up Input Devices

Configure keyboard, mouse, touchpad:

**Via Omarchy Menu:**

```bash
omarchy-menu → Setup → Input
# Opens: ~/.config/hypr/input.conf
```

**Example settings:**

```conf
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options = caps:escape  # Caps Lock becomes Escape
    kb_rules =

    follow_mouse = 1
    natural_scroll = yes  # Reverse scroll direction

    touchpad {
        natural_scroll = yes
        tap-to-click = yes
        drag_lock = no
        disable_while_typing = yes
    }

    sensitivity = 0  # -1.0 to 1.0, 0 means no modification
    accel_profile = flat  # flat or adaptive
}
```

**Apply changes:**

```bash
hyprctl reload
```

**See:** [Input Configuration](../07-system-setup/input.md)

---

## Learning the Interface

### Omarchy Menu System

The Omarchy menu is your central hub:

**Access:**

```bash
# Keybinding
SUPER + M

# Or command
omarchy-menu
```

**Navigation:**

- **Arrow keys** or **j/k**: Move up/down
- **Enter**: Select
- **Escape**: Go back
- **Type**: Filter options

**Main sections:**

1. **Apps** - Launch applications (same as Walker)
2. **Learn** - Documentation, keybindings, tutorials
3. **Trigger** - Screenshots, screen recording, sharing
4. **Style** - Themes, fonts, backgrounds
5. **Setup** - Audio, WiFi, Bluetooth, monitors
6. **Install** - Add software and services
7. **Remove** - Uninstall packages and themes
8. **Update** - System updates and config refresh
9. **About** - System information
10. **System** - Lock, suspend, restart, shutdown

---

### Walker Launcher

Walker is your application launcher and more:

**Access:**

```bash
# Keybinding
SUPER + Space

# Or command
omarchy-launch-walker
```

**Modes:**

- **Applications**: Type app name to launch
- **Calculator**: Type math (e.g., "2+2", "sqrt(16)")
- **Clipboard**: Browse clipboard history
- **Files**: Recent files and file search
- **Web Search**: Search Google, DuckDuckGo, etc.
- **Unicode**: Find Unicode characters (e.g., "arrow", "heart")
- **Symbols**: Math symbols, Greek letters
- **Todo**: Quick todo list

**Usage:**

```bash
# Launch app
SUPER+Space
Type: "firefox"
Press Enter

# Calculator
SUPER+Space
Type: "15 * 8"
See result: 120

# Clipboard history
SUPER+Space
Type: "#" (or nothing, just browse)
Select previous copy

# File search
SUPER+Space
Type: "@myfile.txt"
Press Enter to open

# Web search
SUPER+Space
Type: "!g wayland compositor"
Press Enter to Google search
```

**See:** [Walker & Elephant](../04-desktop-environment/walker-elephant.md)

---

### Waybar Status Bar

Waybar shows system status at the top:

**Default modules (left to right):**

- **Workspaces**: Current workspace (1-9, 0)
- **Window title**: Active window name
- **Network**: WiFi/Ethernet status
- **Audio**: Volume level
- **Battery**: Charge level (laptops)
- **Clock**: Date and time

**Interactions:**

- **Click workspace number**: Switch to workspace
- **Click volume**: Open audio mixer
- **Click network**: Open network settings
- **Click battery**: Show power info
- **Click clock**: Open calendar (if configured)

**Customization:**

```bash
nvim ~/.config/waybar/config.jsonc
nvim ~/.config/waybar/style.css
```

**Reload after changes:**

```bash
omarchy-restart-waybar
```

**See:** [Waybar Customization](../04-desktop-environment/waybar.md)

---

## Essential Keybindings

### Core Shortcuts

```
SUPER + Space              → Walker (application launcher)
SUPER + Return             → Terminal
SUPER + Q                  → Close window
SUPER + M                  → Omarchy menu
SUPER + O                  → Omarchy documentation
SUPER + L                  → Lock screen
SUPER + K                  → Keybinding cheatsheet
```

---

### Window Management

```
SUPER + F                  → Toggle fullscreen
SUPER + V                  → Toggle floating
SUPER + S                  → Toggle pseudo-tiling
SUPER + P                  → Toggle split orientation

SUPER + Left/Right/Up/Down → Move focus
SUPER + H/J/K/L            → Move focus (Vim keys)

SUPER + SHIFT + Arrows     → Move window
SUPER + SHIFT + H/J/K/L    → Move window (Vim keys)
```

---

### Workspaces

```
SUPER + 1-9, 0             → Switch to workspace 1-10
SUPER + SHIFT + 1-9, 0     → Move window to workspace
SUPER + Mouse wheel        → Cycle workspaces
```

---

### Screenshots & Recording

```
Print Screen               → Screenshot with editing (Satty)
SUPER + Print              → Screenshot to clipboard
SHIFT + Print              → Screen region selection
SUPER + SHIFT + Print      → Screen recording
```

---

### Audio

```
XF86AudioRaiseVolume       → Volume up
XF86AudioLowerVolume       → Volume down
XF86AudioMute              → Mute toggle
XF86AudioPlay              → Play/pause media
```

---

### Custom Keybindings

Add your own in `~/.config/hypr/bindings.conf`:

```conf
# Example: SUPER+B for browser
bind = SUPER, B, exec, omarchy-launch-browser

# Example: SUPER+E for file manager
bind = SUPER, E, exec, nautilus

# Example: SUPER+N for notes
bind = SUPER, N, exec, obsidian
```

**See:** [Keybindings](../09-customization/keybindings.md) for complete reference

---

## Examples

### Example 1: Basic - Complete First-Run Setup

**Scenario:** You've just installed Omarchy and want to configure everything.

```bash
# System boots into Hyprland
# First-run wizard starts automatically

# Step 1: Notifications appear
# - "Click to Setup Wi-Fi" (if not connected)
# - "Update System"
# - "Learn Keybindings"

# Step 2: Connect WiFi
# Click WiFi notification
# Select network in nmtui
# Enter password
# Activate connection

# Step 3: Update system
# Press SUPER+M
# Navigate: Update → Omarchy
# Wait for update to complete

# Step 4: Choose theme
# Press SUPER+M
# Navigate: Style → Theme
# Select: Catppuccin
# Watch entire desktop change colors

# Step 5: Configure audio
# Press SUPER+M
# Navigate: Setup → Audio
# Use wiremix to set volume
# Test with music or video

# Step 6: Set up monitors (if multi-monitor)
# Press SUPER+M
# Navigate: Setup → Monitors
# Edit monitors.conf
# Save and hyprctl reload

# Step 7: Learn keybindings
# Press SUPER+K
# Review cheatsheet
# Practice: SUPER+Space, SUPER+Return, SUPER+Q

# You're ready to use Omarchy!
```

---

### Example 2: Intermediate - Developer Setup

**Scenario:** You're a developer and need your dev environment configured.

```bash
# After first-run wizard, install development tools

# Step 1: Install your language runtime
omarchy-menu → Install → Development → Ruby on Rails
# (or Node.js, Python, Go, etc.)

# Step 2: Install Docker databases
omarchy-menu → Install → Development → Docker DB
# Installs PostgreSQL, MySQL, Redis containers

# Step 3: Install editor
omarchy-menu → Install → Editor → VSCode
# Or Cursor, Zed, etc.

# Step 4: Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Step 5: Set up GitHub CLI
gh auth login
# Follow prompts to authenticate

# Step 6: Clone your projects
cd ~/Projects
gh repo clone yourname/project-name

# Step 7: Install project dependencies
cd project-name
bundle install  # Ruby
npm install     # Node
pip install -r requirements.txt  # Python

# Step 8: Start development
nvim .
# Or code .
# Or cursor .

# Development environment complete!
```

---

### Example 3: Advanced - Custom Environment

**Scenario:** You want to fully personalize Omarchy for your workflow.

```bash
# Step 1: Create custom theme
cp -r ~/.config/omarchy/themes/catppuccin ~/.config/omarchy/themes/my-theme
nvim ~/.config/omarchy/themes/my-theme/alacritty.toml
# Customize colors
omarchy-theme-set my-theme

# Step 2: Add custom keybindings
nvim ~/.config/hypr/bindings.conf
# Add:
# bind = SUPER, B, exec, firefox
# bind = SUPER, N, exec, obsidian
# bind = SUPER SHIFT, T, exec, omarchy-theme-next
hyprctl reload

# Step 3: Customize Waybar
nvim ~/.config/waybar/config.jsonc
# Add/remove modules
nvim ~/.config/waybar/style.css
# Customize appearance
omarchy-restart-waybar

# Step 4: Install additional packages
omarchy-pkg-install
# Add your frequently-used software

# Step 5: Set up web apps
omarchy-webapp-install
# Add Notion, Figma, etc. as desktop apps

# Step 6: Create custom scripts
mkdir ~/bin
nvim ~/bin/my-workflow
chmod +x ~/bin/my-workflow
# Add to PATH in ~/.bashrc

# Step 7: Version control your configs
cd ~/.config/omarchy
git init
git add .
git commit -m "My Omarchy setup"
gh repo create my-omarchy --private
git push -u origin master

# Your personalized Omarchy is complete!
```

---

## Troubleshooting

### First-Run Wizard Doesn't Start

**Symptoms:** Login successful but no first-run notifications

**Solutions:**

```bash
# Check if first-run mode flag exists
ls ~/.local/state/omarchy/first-run.mode

# If missing, create it
touch ~/.local/state/omarchy/first-run.mode

# Manually run wizard
omarchy-cmd-first-run
```

---

### WiFi Won't Connect

**Symptoms:** Network manager shows error, can't connect

**Solutions:**

```bash
# Unblock WiFi
rfkill unblock wifi

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Check WiFi status
nmcli radio wifi
# Should show: enabled

# List available networks
nmcli device wifi list

# Connect manually
nmcli device wifi connect "SSID" password "password"
```

---

### Audio Not Working

**Symptoms:** No sound from speakers/headphones

**Solutions:**

```bash
# Restart PipeWire
omarchy-restart-pipewire

# Check PipeWire status
systemctl --user status pipewire pipewire-pulse

# Open mixer to check mute/volume
wiremix

# Test audio
speaker-test -t wav -c 2
```

---

### Theme Doesn't Apply

**Symptoms:** Theme set but some apps still show old colors

**Solutions:**

```bash
# Re-apply theme
omarchy-theme-set $(omarchy-theme-current)

# Restart affected services
omarchy-restart-walker
omarchy-restart-waybar

# Reload terminal configs
omarchy-theme-set-terminal

# Reload Hyprland
hyprctl reload
```

---

### Keybindings Don't Work

**Symptoms:** SUPER+Space, SUPER+M, etc. don't respond

**Solutions:**

```bash
# Check Hyprland bindings
grep -A 5 "bind.*SUPER.*Space" ~/.config/hypr/bindings.conf

# Reload Hyprland config
hyprctl reload

# Check if Walker is running (needed for SUPER+Space)
pgrep walker

# Restart Walker if not running
omarchy-restart-walker
```

---

## Related Documentation

### Essential Next Steps
- [Overview](./overview.md) - Understanding Omarchy's philosophy
- [Installation](./installation.md) - How Omarchy was installed
- [Architecture](./architecture.md) - System component relationships

### Configuration Guides
- [Theme System](../03-theming/theme-system.md) - Detailed theming guide
- [Keybindings](../09-customization/keybindings.md) - Complete keybinding reference
- [Hyprland Configuration](../04-desktop-environment/hyprland.md) - Window manager setup

### Hardware Setup
- [Monitors](../07-system-setup/monitors.md) - Multi-monitor configuration
- [Audio](../07-system-setup/audio.md) - Sound system setup
- [Input Devices](../07-system-setup/input.md) - Keyboard, mouse, touchpad
- [Power Management](../07-system-setup/power-management.md) - Battery and sleep

### Daily Use
- [Quick Reference](../10-reference/quick-reference.md) - Common tasks
- [Package Management](../02-core-commands/package-management.md) - Installing software
- [Walker & Elephant](../04-desktop-environment/walker-elephant.md) - Using the launcher

### Support
- [Troubleshooting](../10-reference/troubleshooting.md) - Problem solving
- [FAQ](../10-reference/faq.md) - Common questions

---

## Notes

**Last Updated:** 2025-10-21

**Source Scripts Analyzed:**
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-first-run` - First-run orchestrator
- `/home/zack/.local/share/omarchy/install/first-run/battery-monitor.sh` - Battery setup
- `/home/zack/.local/share/omarchy/install/first-run/firewall.sh` - UFW configuration
- `/home/zack/.local/share/omarchy/install/first-run/dns-resolver.sh` - DNS setup
- `/home/zack/.local/share/omarchy/install/first-run/gnome-theme.sh` - GTK theme setup
- `/home/zack/.local/share/omarchy/install/first-run/wifi.sh` - WiFi detection
- `/home/zack/.local/share/omarchy/install/first-run/welcome.sh` - Welcome notifications

**Verification:** All steps, commands, and configurations tested on fresh Omarchy installation.

---

*This first-run guide is part of the Omarchy Archive. For the complete documentation, see the [main README](../README.md).*
