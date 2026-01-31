# Omarchy FAQ (Frequently Asked Questions)

**Purpose:** Quick answers to common omarchy questions
**Use Case:** "What is..." and "How do I..." questions

*Last Updated: 2025-10-21*

---

## Table of Contents

- [General Questions](#general-questions)
- [Installation & Setup](#installation--setup)
- [Theming & Appearance](#theming--appearance)
- [Package Management](#package-management)
- [Hardware & System](#hardware--system)
- [Development & Workflow](#development--workflow)
- [Advanced Usage](#advanced-usage)

---

## General Questions

### What is Omarchy?

**Answer:** Omarchy is an opinionated Arch Linux + Hyprland desktop environment created by DHH and 37signals. It's a complete, curated system featuring:

- Hyprland (Wayland compositor)
- Walker (application launcher)
- Waybar (status bar)
- 124 utility scripts
- 12 pre-configured themes
- 203 carefully selected packages

It's designed for developers who want a beautiful, efficient, keyboard-driven desktop without spending weeks configuring everything from scratch.

**Learn more:** [Getting Started](../01-getting-started/overview.md)

---

### What does "Omarchy" mean?

**Answer:** Omarchy is a portmanteau of "DHH" (Om) + "Anarchy" (archy). It represents the philosophy of structured freedom - an opinionated setup that gives you power without chaos.

---

### Is Omarchy suitable for beginners?

**Answer:** Omarchy requires some Linux familiarity but is designed to be beginner-friendly for its target audience (developers). You should:

- Be comfortable with command line basics
- Understand Linux file systems
- Know how to read error messages
- Be willing to learn keyboard-driven workflows

If you're coming from Windows/Mac and new to Linux, consider starting with a more traditional desktop environment (GNOME, KDE) first, then switching to Omarchy later.

**Starting point:** [First Run Guide](../01-getting-started/first-run-guide.md)

---

### What's the difference between Omarchy and vanilla Arch?

**Answer:** Omarchy is Arch Linux with:

**Pre-configured:**
- Hyprland window manager (instead of GNOME/KDE/etc)
- 124 utility scripts (omarchy-* commands)
- 203 packages carefully selected for developer workflow
- 12 themes with synchronized app configurations
- Optimized keybindings and settings

**Arch Linux itself:**
- Rolling release distribution
- DIY philosophy (you install what you want)
- Pacman package manager
- AUR (Arch User Repository) access

Omarchy saves you months of configuration while maintaining Arch's flexibility and rolling release benefits.

---

### Can I use Omarchy alongside other desktop environments?

**Answer:** Yes! Omarchy (Hyprland) can coexist with other desktop environments. At login, you can choose which environment to use.

**To switch:**
```bash
# At login screen, select session
# Choose: Hyprland (Omarchy) or other DE
```

**Considerations:**
- Different DEs have separate configs (~/.config/gnome vs ~/.config/hypr)
- Some packages may overlap (multiple file managers, terminals, etc.)
- Disk space increases with multiple DEs

**Best practice:** Try Omarchy exclusively for 2 weeks before deciding to keep alternatives.

---

### How often should I update Omarchy?

**Answer:** Recommended: **Weekly**

```bash
# Full update
omarchy-update
```

**Why weekly:**
- Arch is rolling release (always getting updates)
- Security patches come frequently
- Bug fixes arrive continuously
- Weekly prevents overwhelming update sizes

**Before major work:** Update before starting important projects, not during.

**Read news first:** Check [Arch Linux News](https://archlinux.org/news/) for breaking changes.

**Learn more:** [System Management](../02-core-commands/system-management.md)

---

### What if I don't like the opinionated choices?

**Answer:** Omarchy is customizable! You can:

**Change terminal:**
```bash
omarchy-install-terminal kitty    # Switch to Kitty
omarchy-install-terminal ghostty  # Or Ghostty
```

**Change editor:**
```bash
# Set default editor
export EDITOR=nvim
# Or: code, cursor, helix, etc.
```

**Modify configs:**
```bash
# Hyprland
$EDITOR ~/.config/hypr/hyprland.conf

# Walker
$EDITOR ~/.config/walker/config.toml

# Waybar
$EDITOR ~/.config/waybar/config.jsonc
```

**Philosophy:** Omarchy provides great defaults but doesn't lock you in.

**Learn more:** [Customization](../09-customization/)

---

### How do I get help with Omarchy issues?

**Answer:**

1. **Check documentation:**
```bash
grep -r "your issue" /home/zack/dev/lib/omarchy-archive/
```

2. **Check troubleshooting guide:**
- [Troubleshooting](./troubleshooting.md)

3. **Upload diagnostic logs:**
```bash
omarchy-upload-log
# Returns URL to share
```

4. **Ask community:**
- GitHub Issues: [basecamp/omarchy](https://github.com/basecamp/omarchy/issues)
- Include: omarchy-version, error logs, steps to reproduce

5. **Check related docs:**
- [Quick Reference](./quick-reference.md)
- [Command Index](../02-core-commands/command-index.md)

---

### Can I run Omarchy in a VM for testing?

**Answer:** Yes! Omarchy works well in VMs.

**Recommended VM setup:**
- 4+ CPU cores
- 8+ GB RAM
- 60+ GB disk space
- Enable 3D acceleration (VirtualBox: Settings → Display → Enable 3D Acceleration)
- Use UEFI boot mode (not BIOS)

**Limitations in VMs:**
- Performance slower than bare metal
- Some GPU features may not work (VRR, advanced rendering)
- Hardware-specific scripts won't work (battery, fingerprint, etc.)

**Best for:** Testing themes, learning commands, trying workflows

---

### What's the difference between omarchy-* commands and regular commands?

**Answer:**

**omarchy-* commands:**
- Custom scripts created for Omarchy
- Located in `~/.local/share/omarchy/bin/`
- Simplify complex operations
- Follow consistent naming patterns
- Documented in this archive

**Regular commands:**
- System utilities (pacman, systemctl, etc.)
- Arch Linux packages
- Standard Linux tools

**Example:**
```bash
# omarchy command (simplified)
omarchy-theme-set catppuccin

# vs equivalent manual process (complex)
ln -sf ~/.config/omarchy/themes/catppuccin ~/.config/omarchy/current/theme
omarchy-theme-bg-next
hyprctl reload
omarchy-restart-waybar
omarchy-theme-set-terminal
omarchy-theme-set-browser
# ... 10+ more steps
```

**Learn all scripts:** [Script Index](./script-index.md)

---

## Installation & Setup

### How do I install Omarchy?

**Answer:** Omarchy is installed during Arch Linux installation using the omarchy installer.

**High-level steps:**
1. Boot Arch Linux installer USB
2. Follow installation prompts
3. Select omarchy option when available
4. Complete installation
5. First boot runs `omarchy-cmd-first-run`

**Note:** This archive assumes you already have Omarchy installed. For installation instructions, see the official Omarchy website.

---

### What should I do on first boot?

**Answer:** On first boot, `omarchy-cmd-first-run` automatically runs and guides you through:

1. **Time zone selection**
```bash
omarchy-tz-select
```

2. **Theme selection**
```bash
omarchy-theme-set <chosen-theme>
```

3. **Terminal selection**
```bash
omarchy-install-terminal alacritty  # or kitty, ghostty
```

4. **Optional setups:**
- WiFi configuration: `omarchy-launch-wifi`
- Fingerprint auth: `omarchy-setup-fingerprint`
- Development environments: `omarchy-install-dev-env`

**After first run:**
```bash
# Update system
omarchy-update

# Explore documentation
SUPER + O
```

**Learn more:** [First Run Guide](../01-getting-started/first-run-guide.md)

---

### How do I set up WiFi?

**Answer:**

**Via GUI:**
```bash
omarchy-launch-wifi
# Opens NetworkManager applet
# Click network name
# Enter password
```

**Via command line:**
```bash
# List networks
nmcli device wifi list

# Connect to network
nmcli device wifi connect "Network-Name" password "your-password"

# Check connection
ping -c 3 8.8.8.8
```

**Troubleshooting:**
```bash
# WiFi blocked
rfkill unblock wifi

# Restart WiFi
omarchy-restart-wifi
```

**Learn more:** [Audio, Bluetooth, WiFi](../07-system-setup/audio-bluetooth-wifi.md)

---

### How do I set up monitors/displays?

**Answer:** Edit monitor configuration:

```bash
# Edit monitor config
$EDITOR ~/.config/hypr/monitors.conf
```

**Syntax:**
```conf
# monitor = NAME, RESOLUTION@REFRESH, POSITION, SCALE
monitor = DP-1, 2560x1440@144, 0x0, 1
monitor = HDMI-A-1, 1920x1080@60, 2560x0, 1

# Auto-detect
monitor = , preferred, auto, 1
```

**Find monitor names:**
```bash
hyprctl monitors
```

**Apply changes:**
```bash
hyprctl reload
```

**Learn more:** [System Setup](../07-system-setup/)

---

### How do I configure fingerprint authentication?

**Answer:**

**Setup fingerprint:**
```bash
omarchy-setup-fingerprint
# Follow prompts to scan finger (5+ times)
```

**Test:**
```bash
# Lock screen and test unlock
omarchy-lock-screen
# Use fingerprint to unlock
```

**Remove fingerprint:**
```bash
omarchy-setup-fingerprint --remove
```

**Requirements:**
- Fingerprint reader hardware
- fprintd package (included in omarchy)
- Compatible reader (most laptop readers work)

**Learn more:** [Security & Auth](../07-system-setup/security-auth.md)

---

### How do I set up FIDO2 security key?

**Answer:**

**Setup FIDO2:**
```bash
omarchy-setup-fido2
# Follow prompts to register key
```

**Requirements:**
- FIDO2 compatible security key (YubiKey, etc.)
- pam-u2f package (included)
- USB port

**Best practice:**
- Register 2-3 keys (backup keys)
- Keep backup key in safe location
- Test key before relying on it

**Remove FIDO2:**
```bash
omarchy-setup-fido2 --remove
```

**Learn more:** [Security & Auth](../07-system-setup/security-auth.md)

---

### How do I import my SSH keys?

**Answer:**

**Copy existing keys:**
```bash
# From backup location
cp ~/backup/.ssh/id_rsa ~/.ssh/
cp ~/backup/.ssh/id_rsa.pub ~/.ssh/

# Set correct permissions
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

**Or generate new keys:**
```bash
# Generate Ed25519 key (recommended)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Or RSA key
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

**Add to SSH agent:**
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

**Add to GitHub/GitLab:**
```bash
# Copy public key
cat ~/.ssh/id_rsa.pub | wl-copy

# Paste into GitHub/GitLab SSH settings
```

---

### How do I set up development environments?

**Answer:** Omarchy uses mise (formerly rtx) for language version management.

**Install language runtime:**
```bash
# Ruby
omarchy-install-dev-env ruby

# Node.js
omarchy-install-dev-env node

# Python
omarchy-install-dev-env python

# Go
omarchy-install-dev-env go

# Rust
omarchy-install-dev-env rust
```

**What this does:**
- Installs mise
- Installs specified language runtime
- Configures PATH
- Sets up tools (bundler for Ruby, npm for Node, etc.)

**Use mise directly:**
```bash
# Install specific version
mise install ruby@3.2.0

# Use globally
mise use -g ruby@3.2.0

# Use in project
cd ~/project
mise use ruby@3.2.0
```

**Learn more:** [Development Setup](../06-development/language-environments.md), [Mise Integration](../06-development/mise-integration.md)

---

## Theming & Appearance

### How do I change themes?

**Answer:**

**List available themes:**
```bash
omarchy-theme-list
```

**Set specific theme:**
```bash
omarchy-theme-set catppuccin
```

**Cycle through themes:**
```bash
omarchy-theme-next
```

**What changes:**
- Terminal colors (all terminals)
- Window borders (Hyprland)
- Status bar (Waybar)
- Editor theme (VS Code, Neovim)
- Browser accent color
- GTK/GNOME theme
- All UI components

**Learn more:** [Theme System](../03-theming/theme-system.md)

---

### How do I change wallpapers?

**Answer:**

**Cycle theme backgrounds:**
```bash
omarchy-theme-bg-next
```

**Add your own wallpapers:**
```bash
# Copy images to theme backgrounds directory
cp ~/Pictures/wallpaper.png ~/.config/omarchy/current/theme/backgrounds/

# Name with numeric prefix for ordering
cp ~/Pictures/morning.png ~/.config/omarchy/current/theme/backgrounds/1-morning.png
cp ~/Pictures/evening.png ~/.config/omarchy/current/theme/backgrounds/2-evening.png

# Cycle to new background
omarchy-theme-bg-next
```

**Use solid color:**
```bash
# Remove all backgrounds (swaybg falls back to black)
rm ~/.config/omarchy/current/theme/backgrounds/*
```

**Learn more:** [Backgrounds](../03-theming/backgrounds.md)

---

### How do I create my own theme?

**Answer:**

**1. Copy existing theme:**
```bash
cp -r ~/.config/omarchy/themes/catppuccin ~/.config/omarchy/themes/my-theme
```

**2. Edit theme files:**
```bash
cd ~/.config/omarchy/themes/my-theme

# Edit colors
$EDITOR alacritty.toml
$EDITOR hyprland.conf
$EDITOR waybar.css
$EDITOR vscode.json

# Add backgrounds
cp ~/Pictures/wallpaper.png backgrounds/1-my-wallpaper.png
```

**3. Activate theme:**
```bash
omarchy-theme-set my-theme
```

**Minimum required files:**
- `alacritty.toml` (terminal colors)
- `backgrounds/` directory (can be empty)

**Learn more:** [Creating Themes](../03-theming/creating-themes.md)

---

### How do I change fonts?

**Answer:**

**List available fonts:**
```bash
omarchy-font-list
```

**Set font:**
```bash
omarchy-font-set "JetBrains Mono Nerd Font"
```

**See current font:**
```bash
omarchy-font-current
```

**Install new fonts:**
```bash
# System-wide
sudo pacman -S ttf-font-name

# User-only
mkdir -p ~/.local/share/fonts
cp font.ttf ~/.local/share/fonts/
fc-cache -fv
```

**Popular fonts included:**
- JetBrains Mono Nerd Font (default)
- Fira Code Nerd Font
- Hack Nerd Font
- Source Code Pro

**Learn more:** [Fonts](../03-theming/fonts.md)

---

### Can I use light themes?

**Answer:** Yes! Omarchy includes light themes:

**Light themes:**
- Catppuccin Latte
- Flexoki Light

**Set light theme:**
```bash
omarchy-theme-set catppuccin-latte
```

**What changes:**
- GTK theme switches to Adwaita (not Adwaita-dark)
- Browser color scheme set to light
- Applications that respect system theme switch to light mode

**Create custom light theme:**
```bash
# Copy theme
cp -r ~/.config/omarchy/themes/catppuccin-latte ~/.config/omarchy/themes/my-light-theme

# Edit colors
# Create light.mode file to indicate light theme
touch ~/.config/omarchy/themes/my-light-theme/light.mode
```

---

### How do I customize keybindings?

**Answer:**

**Edit keybindings:**
```bash
$EDITOR ~/.config/hypr/bindings.conf
```

**Syntax:**
```conf
# bind = MODIFIERS, KEY, ACTION, PARAMS
bind = SUPER, T, exec, alacritty
bind = SUPER SHIFT, Q, killactive,
bind = SUPER, F, fullscreen, 1
```

**Common modifiers:**
- `SUPER` (Windows/Command key)
- `SHIFT`
- `CTRL`
- `ALT`

**Apply changes:**
```bash
hyprctl reload
```

**View current bindings:**
```bash
# Interactive reference
omarchy-menu-keybindings

# Or check config
hyprctl binds
```

**Learn more:** [Keybindings](../09-customization/keybindings.md)

---

### How do I change the cursor theme?

**Answer:**

Cursor theme is set per-theme in each theme's configuration.

**Change cursor theme:**
```bash
# Edit GNOME settings (affects cursor)
gsettings set org.gnome.desktop.interface cursor-theme "Yaru"

# Available cursor themes
ls /usr/share/icons/ | grep cursor
```

**Make persistent:**
```bash
# Edit theme's cursor config
$EDITOR ~/.config/omarchy/current/theme/icons.theme

# Change cursor theme name
# Will apply when you set this theme
```

**Install new cursor themes:**
```bash
# From repos
sudo pacman -S xcursor-themes

# From user directory
mkdir -p ~/.local/share/icons
cp -r cursor-theme ~/.local/share/icons/
```

---

## Package Management

### How do I install software?

**Answer:**

**From official repos:**
```bash
omarchy-pkg-install
# Search and select package
```

**From AUR:**
```bash
omarchy-pkg-aur-install
# Search and select package
```

**Web applications:**
```bash
omarchy-webapp-install
# Installs web apps like Figma, Notion, etc.
```

**Development environments:**
```bash
omarchy-install-dev-env ruby
```

**Direct with pacman:**
```bash
sudo pacman -S package-name
```

**Learn more:** [Package Management](../02-core-commands/package-management.md)

---

### How do I remove software?

**Answer:**

**Via omarchy:**
```bash
omarchy-pkg-remove
# Select package to remove
```

**Remove package and dependencies:**
```bash
sudo pacman -Rs package-name
```

**Remove package only:**
```bash
sudo pacman -R package-name
```

**Remove web application:**
```bash
omarchy-webapp-remove
```

**Remove TUI application:**
```bash
omarchy-tui-remove
```

---

### What packages are included in Omarchy?

**Answer:** Omarchy includes 149 base packages + 54 optional packages.

**Categories:**

**Core Desktop (30 packages):**
- Hyprland, Waybar, Walker, Mako
- Hypridle, Hyprlock, Hyprsunset
- Alacritty, Kitty (terminals)

**Development (25 packages):**
- Docker, Docker Compose
- Mise (version manager)
- Git, GitHub CLI
- Lazygit, Lazydocker
- Neovim

**Media (15 packages):**
- OBS Studio
- mpv (video player)
- Satty (screenshot editor)
- gpu-screen-recorder

**Productivity (20 packages):**
- Chromium (browser)
- Obsidian (notes)
- LibreOffice
- Nautilus (file manager)

**Utilities (35 packages):**
- bat, eza, fd, fzf, ripgrep
- btop (system monitor)
- LocalSend (file sharing)
- Signal Desktop

**System (24 packages):**
- Pipewire (audio)
- NetworkManager (networking)
- fwupd (firmware updates)
- systemd

**Full list:**
```bash
cat ~/.local/share/omarchy/install/omarchy-base.packages
cat ~/.local/share/omarchy/install/omarchy-extra.packages
```

**Learn more:** [Core Applications](../05-applications/core-applications.md)

---

### How do I update all packages?

**Answer:**

**Update everything:**
```bash
omarchy-update
```

**What it does:**
1. Updates Arch Linux packages (pacman -Syu)
2. Updates AUR packages (yay -Sua)
3. Updates omarchy scripts (git pull)
4. Updates themes (git pull in theme directories)
5. Runs migrations if needed
6. Refreshes configs

**Update only system packages:**
```bash
omarchy-update-system-pkgs
```

**Update only omarchy:**
```bash
omarchy-update-git
```

**Learn more:** [System Management](../02-core-commands/system-management.md)

---

### How do I track which packages I've added?

**Answer:** Omarchy tracks packages in package lists.

**Add package to tracking:**
```bash
omarchy-pkg-add package-name
```

**Remove from tracking:**
```bash
omarchy-pkg-drop package-name
```

**List tracked packages:**
```bash
cat ~/.local/share/omarchy/install/omarchy-base.packages
cat ~/.local/share/omarchy/install/omarchy-user.packages
```

**Check missing packages:**
```bash
omarchy-pkg-missing
```

**Why track packages:**
- Know what you've installed
- Reinstall on new system
- Share package list with others
- Document your setup

---

### How do I install Docker databases?

**Answer:**

**Install PostgreSQL, MySQL, Redis:**
```bash
omarchy-install-docker-dbs
```

**What this installs:**
- Docker and Docker Compose
- PostgreSQL (latest) on port 5432
- MySQL (latest) on port 3306
- Redis (latest) on port 6379

**Start databases:**
```bash
# All databases start automatically

# Check status
docker ps

# Stop all
docker stop $(docker ps -aq)

# Start specific database
docker start postgres
docker start mysql
docker start redis
```

**Connect to databases:**
```bash
# PostgreSQL
psql -h localhost -U postgres

# MySQL
mysql -h localhost -u root -p

# Redis
redis-cli
```

**Learn more:** [Docker Setup](../06-development/docker-setup.md)

---

## Hardware & System

### How do I adjust volume?

**Answer:**

**Keyboard shortcuts:**
```bash
XF86AudioRaiseVolume    # Volume up
XF86AudioLowerVolume    # Volume down
XF86AudioMute           # Mute toggle
```

**Via GUI:**
```bash
# Open audio mixer
wiremix
```

**Via command line:**
```bash
# Increase volume
pactl set-sink-volume @DEFAULT_SINK@ +5%

# Decrease volume
pactl set-sink-volume @DEFAULT_SINK@ -5%

# Mute
pactl set-sink-mute @DEFAULT_SINK@ toggle
```

---

### How do I change audio output device?

**Answer:**

**Via omarchy:**
```bash
omarchy-cmd-audio-switch
```

**Via GUI:**
```bash
wiremix
# Click output device dropdown
# Select desired device
```

**Via command line:**
```bash
# List devices
pactl list sinks short

# Set default (replace INDEX)
pactl set-default-sink INDEX
```

---

### How do I connect Bluetooth devices?

**Answer:**

**Via GUI:**
```bash
# Open Bluetooth manager
blueberry
```

**Via command line:**
```bash
# Start bluetoothctl
bluetoothctl

# In bluetoothctl:
power on
agent on
default-agent
scan on
# Wait for device to appear
pair AA:BB:CC:DD:EE:FF
trust AA:BB:CC:DD:EE:FF
connect AA:BB:CC:DD:EE:FF
```

**Restart Bluetooth:**
```bash
omarchy-restart-bluetooth
```

**Learn more:** [Audio, Bluetooth, WiFi](../07-system-setup/audio-bluetooth-wifi.md)

---

### How do I manage power settings?

**Answer:**

**Check current power profile:**
```bash
powerprofilesctl get
```

**Change power profile:**
```bash
# Performance (max CPU)
powerprofilesctl set performance

# Balanced (default)
powerprofilesctl set balanced

# Power saver (battery life)
powerprofilesctl set power-saver
```

**List available profiles:**
```bash
omarchy-powerprofiles-list
```

**Configure auto-suspend:**
```bash
# Edit hypridle config
$EDITOR ~/.config/hypr/hypridle.conf

# Restart hypridle
omarchy-restart-hypridle
```

**Learn more:** [Power Management](../07-system-setup/power-management.md)

---

### How do I check battery status?

**Answer:**

**Via Waybar:**
- Battery module shows in status bar
- Hover for percentage and time remaining

**Via command line:**
```bash
# Battery percentage
cat /sys/class/power_supply/BAT0/capacity

# Battery status (Charging/Discharging)
cat /sys/class/power_supply/BAT0/status

# Detailed info
upower -i /org/freedesktop/UPower/devices/battery_BAT0
```

**Battery monitor service:**
```bash
# Check if running
pgrep omarchy-battery-monitor

# View notifications for low battery (automatic)
```

---

### How do I update firmware?

**Answer:**

```bash
omarchy-update-firmware
```

**What it does:**
- Checks for firmware updates (fwupd)
- Downloads available updates
- Installs firmware updates
- May require reboot

**Check for updates without installing:**
```bash
fwupdmgr get-updates
```

**View installed firmware:**
```bash
fwupdmgr get-devices
```

**Why update firmware:**
- Fix hardware bugs
- Improve performance
- Security patches
- Add features

---

### How do I configure DNS?

**Answer:**

**Via omarchy:**
```bash
omarchy-setup-dns
```

**Manual configuration:**
```bash
# Edit resolv.conf
sudo $EDITOR /etc/resolv.conf

# Add DNS servers
nameserver 1.1.1.1
nameserver 1.0.0.1

# Make immutable (prevent overwrite)
sudo chattr +i /etc/resolv.conf
```

**Popular DNS servers:**
- Cloudflare: 1.1.1.1, 1.0.0.1
- Google: 8.8.8.8, 8.8.4.4
- Quad9: 9.9.9.9
- OpenDNS: 208.67.222.222, 208.67.220.220

**Test DNS:**
```bash
nslookup google.com
```

---

## Development & Workflow

### How do I take screenshots?

**Answer:**

**With editing (recommended):**
```bash
omarchy-cmd-screenshot smart
# Or press: PRINT key
```

**To clipboard:**
```bash
omarchy-cmd-screenshot smart clipboard
# Or press: SUPER + PRINT
```

**What "smart" does:**
- If multiple monitors: choose region or display
- Opens Satty editor after capture
- Can annotate, crop, draw
- Save or copy to clipboard

**Learn more:** [Screenshot & Screenrecord](../08-utilities/screenshot-screenrecord.md)

---

### How do I record my screen?

**Answer:**

**Basic recording:**
```bash
omarchy-cmd-screenrecord
# Or press: SUPER + SHIFT + PRINT
```

**With audio:**
```bash
omarchy-cmd-screenrecord --with-audio
```

**With webcam:**
```bash
omarchy-cmd-screenrecord --with-webcam
```

**Select region:**
```bash
omarchy-cmd-screenrecord region
```

**Stop recording:**
```bash
# Press SUPER + SHIFT + PRINT again
# Or click notification to stop
```

**Recordings saved to:**
```bash
~/Videos/
```

**Learn more:** [Screenshot & Screenrecord](../08-utilities/screenshot-screenrecord.md)

---

### How do I share files?

**Answer:**

**Share via LocalSend:**
```bash
# Share clipboard
omarchy-cmd-share clipboard

# Share file
omarchy-cmd-share file

# Share folder
omarchy-cmd-share folder
```

**What LocalSend does:**
- Sends files over local network
- No internet required
- Works with LocalSend apps on phone/tablet
- Fast transfers

**Alternative methods:**
```bash
# Copy to clipboard
wl-copy < file.txt
cat file.txt | wl-copy

# HTTP server (quick share)
python -m http.server 8000
# Access at http://your-ip:8000
```

**Learn more:** [File Sharing](../08-utilities/file-sharing.md)

---

### How do I use clipboard history?

**Answer:**

**Access clipboard:**
```bash
# Via Walker
omarchy-launch-walker
# Type: clipboard history
```

**Copy to clipboard:**
```bash
# From command
echo "text" | wl-copy

# From file
wl-copy < file.txt

# Image
wl-copy < image.png
```

**Paste from clipboard:**
```bash
# Via keyboard
CTRL + V

# To terminal
wl-paste

# To file
wl-paste > file.txt
```

**Clear clipboard:**
```bash
wl-copy --clear
```

---

### How do I open documentation?

**Answer:**

**Omarchy docs:**
```bash
# Via keybinding
SUPER + O

# Or via menu
omarchy-menu
# Select "Docs"
```

**Hyprland docs:**
```bash
omarchy-launch-hyprland-docs
```

**Man pages:**
```bash
man command-name

# Or with better formatting
batman command-name  # If bat installed
```

**This archive:**
```bash
cd /home/zack/dev/lib/omarchy-archive
bat README.md

# Search docs
grep -r "keyword" /home/zack/dev/lib/omarchy-archive/ --include="*.md"
```

---

### How do I set up Git?

**Answer:**

**Configure Git:**
```bash
# Set name and email
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Set default editor
git config --global core.editor nvim

# Set default branch name
git config --global init.defaultBranch main
```

**GitHub CLI:**
```bash
# Login to GitHub
gh auth login

# Follow prompts
```

**SSH keys for Git:**
```bash
# Generate key
ssh-keygen -t ed25519 -C "your@email.com"

# Add to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub | wl-copy

# Add to GitHub: Settings → SSH Keys → New SSH Key
```

**Lazygit (TUI for Git):**
```bash
# Open in any git repo
lazygit
```

---

### How do I set up VS Code?

**Answer:**

**Install VS Code:**
```bash
omarchy-install-vscode
```

**What this does:**
- Installs VSCode or VSCodium
- Configures theme synchronization
- Installs extensions
- Sets up settings

**Launch VS Code:**
```bash
# From command line
code .

# Or via Walker
SUPER + SPACE
# Type: code
```

**Theme sync:**
- Themes auto-sync when you run `omarchy-theme-set`
- VS Code theme matches system theme

**Disable theme sync:**
```bash
# Create skip flag
mkdir -p ~/.local/state/omarchy/toggles/
touch ~/.local/state/omarchy/toggles/skip-vscode-theme-changes
```

**Learn more:** [Editor Setup](../06-development/editor-setup.md)

---

## Advanced Usage

### How do I create custom scripts?

**Answer:**

**Create script:**
```bash
# Create in PATH
$EDITOR ~/.local/bin/my-script

# Make executable
chmod +x ~/.local/bin/my-script
```

**Example script:**
```bash
#!/usr/bin/env bash
# my-script - Does something useful

set -euo pipefail

main() {
    echo "Hello from my script!"
    # Your code here
}

main "$@"
```

**Add to PATH:**
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"
```

**Use omarchy hooks:**
```bash
# Create hook for theme change
mkdir -p ~/.config/omarchy/hooks/theme-set/
$EDITOR ~/.config/omarchy/hooks/theme-set/my-hook.sh
chmod +x ~/.config/omarchy/hooks/theme-set/my-hook.sh

# Hook runs when theme changes
```

**Learn more:** [Advanced Tweaks](../09-customization/advanced-tweaks.md)

---

### How do I create custom keybindings?

**Answer:**

**Edit bindings:**
```bash
$EDITOR ~/.config/hypr/bindings.conf
```

**Add custom binding:**
```conf
# Launch custom app
bind = SUPER, X, exec, my-app

# Run script
bind = SUPER SHIFT, X, exec, ~/.local/bin/my-script

# Chain commands
bind = SUPER CTRL, X, exec, command1 && command2
```

**Special actions:**
```conf
# Kill active window
bind = SUPER, Q, killactive,

# Toggle fullscreen
bind = SUPER, F, fullscreen, 1

# Move to workspace
bind = SUPER, 1, workspace, 1

# Execute script with arguments
bind = SUPER, T, exec, alacritty -e nvim
```

**Apply changes:**
```bash
hyprctl reload
```

**Learn more:** [Keybindings](../09-customization/keybindings.md)

---

### How do I switch between Omarchy branches?

**Answer:**

**Check current branch:**
```bash
omarchy-version-branch
```

**Switch branch:**
```bash
# Switch to development branch
omarchy-update-branch dev

# Switch back to stable
omarchy-update-branch master
```

**Branches:**
- `master` - Stable release (recommended)
- `dev` - Development (bleeding edge, may have bugs)

**After switching:**
```bash
# Update to latest on new branch
omarchy-update
```

---

### How do I contribute to Omarchy?

**Answer:**

**Find source code:**
- Omarchy scripts: `~/.local/share/omarchy/bin/`
- Configurations: `~/.config/omarchy/`
- Themes: `~/.config/omarchy/themes/`

**Report bugs:**
1. Upload diagnostic log: `omarchy-upload-log`
2. Create GitHub issue with:
   - omarchy-version
   - Steps to reproduce
   - Expected vs actual behavior
   - Log URL

**Suggest features:**
- GitHub issues with "feature request" label
- Describe use case and benefit

**Submit themes:**
- Create theme following structure
- Test thoroughly
- Submit pull request to omarchy-themes repo

**Documentation:**
- This archive is community-maintained
- Corrections and additions welcome
- Follow existing format

---

### How do I backup my Omarchy setup?

**Answer:**

**What to backup:**

1. **Configs:**
```bash
# Hyprland, Walker, Waybar, etc.
tar czf omarchy-configs-$(date +%F).tar.gz ~/.config/hypr ~/.config/walker ~/.config/waybar ~/.config/omarchy
```

2. **Scripts (if customized):**
```bash
tar czf omarchy-scripts-$(date +%F).tar.gz ~/.local/share/omarchy/
```

3. **SSH keys:**
```bash
tar czf ssh-keys-$(date +%F).tar.gz ~/.ssh/
```

4. **Package lists:**
```bash
# Installed packages
pacman -Qe > packages-explicit-$(date +%F).txt
pacman -Qm > packages-aur-$(date +%F).txt
```

5. **Dotfiles:**
```bash
tar czf dotfiles-$(date +%F).tar.gz ~/.bashrc ~/.zshrc ~/.gitconfig ~/.local/bin/
```

**Automated backup:**
```bash
# Create backup script
cat > ~/.local/bin/backup-omarchy << 'EOF'
#!/usr/bin/env bash
BACKUP_DIR=~/Backups/omarchy-$(date +%F)
mkdir -p "$BACKUP_DIR"

tar czf "$BACKUP_DIR/configs.tar.gz" ~/.config/{hypr,walker,waybar,omarchy}
tar czf "$BACKUP_DIR/ssh.tar.gz" ~/.ssh/
pacman -Qe > "$BACKUP_DIR/packages.txt"

echo "Backup saved to: $BACKUP_DIR"
EOF

chmod +x ~/.local/bin/backup-omarchy

# Run backup
backup-omarchy
```

---

### How do I restore from backup?

**Answer:**

**Restore configs:**
```bash
# Extract to home directory
tar xzf omarchy-configs-*.tar.gz -C ~/

# Reload configs
omarchy-refresh-config
hyprctl reload
```

**Restore packages:**
```bash
# Install from package list
cat packages-explicit-*.txt | xargs sudo pacman -S --needed
```

**Restore SSH keys:**
```bash
tar xzf ssh-keys-*.tar.gz -C ~/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
```

---

### How do I reset to default configuration?

**Answer:**

**Reset all configs:**
```bash
omarchy-refresh-config
```

**Reset specific component:**
```bash
# Hyprland
omarchy-refresh-hyprland

# Walker
omarchy-refresh-walker

# Waybar
omarchy-refresh-waybar

# Theme
omarchy-theme-set $(omarchy-theme-current)
```

**Complete reset:**
```bash
# Backup first!
cp -r ~/.config/hypr ~/.config/hypr.backup

# Remove customizations
rm -rf ~/.config/hypr ~/.config/walker ~/.config/waybar

# Reinstall omarchy
# (Follow official reinstall guide)
```

---

## Related Documentation

- [Quick Reference](./quick-reference.md) - Fast command lookups
- [Troubleshooting](./troubleshooting.md) - Problem solving guide
- [Script Index](./script-index.md) - All 124 scripts documented
- [Command Index](../02-core-commands/command-index.md) - Complete command reference

---

*This FAQ covers 30+ frequently asked questions across all categories. For detailed information on specific topics, see the related documentation links.*
