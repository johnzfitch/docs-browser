# Omarchy Installation

**Purpose:** Complete guide to installing Omarchy on Arch Linux
**Use Case:** Fresh system setup or reinstallation

*Last Updated: 2025-10-21*

---

## Quick Start (30-Second Guide)

```bash
# On a fresh Arch Linux install (with internet connection):
bash <(curl -Ls https://omarchy.org/boot.sh)

# Wait for installation to complete (15-30 minutes)
# System will reboot automatically

# After reboot, login and run first-run wizard
# omarchy-cmd-first-run (runs automatically on first login)
```

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation Methods](#installation-methods)
- [How Omarchy Installs](#how-omarchy-installs)
- [Package Lists](#package-lists)
- [Installation Steps](#installation-steps)
- [Post-Install Verification](#post-install-verification)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Related Documentation](#related-documentation)

---

## Prerequisites

### System Requirements

**Minimum:**
- x86_64 CPU (Intel or AMD)
- 4GB RAM (8GB recommended)
- 30GB disk space (50GB+ recommended for development)
- Internet connection during installation
- UEFI firmware (legacy BIOS not supported)

**Recommended:**
- AMD or Intel graphics (NVIDIA works but has Wayland limitations)
- SSD for better performance
- 16GB+ RAM for Docker development
- Dual monitors supported

---

### Base System

Omarchy requires a **fresh Arch Linux installation** with:

- Base system installed (from Arch ISO)
- Boot loader configured (systemd-boot, GRUB, or other)
- Network connection working
- User account created with sudo privileges

**If you don't have Arch installed:**

1. Download Arch ISO: https://archlinux.org/download/
2. Create bootable USB with `dd` or Rufus/Etcher
3. Boot from USB
4. Follow Arch installation guide: https://wiki.archlinux.org/title/Installation_guide
5. OR use archinstall script for automated base install:
   ```bash
   archinstall
   ```

---

### Network Connection

Installation downloads ~3GB of packages and requires stable internet:

**WiFi:**
```bash
# If using archinstall, WiFi is configured during install
# Manual configuration:
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "Your Network Name"
exit
```

**Ethernet:**
```bash
# Usually works automatically
# Verify:
ip link
ping -c 3 archlinux.org
```

---

## Installation Methods

### Method 1: Online Installation (Recommended)

Downloads latest Omarchy from GitHub during installation.

```bash
bash <(curl -Ls https://omarchy.org/boot.sh)
```

**Advantages:**
- Always installs latest version
- Smallest download footprint
- Automatic updates from upstream

**Disadvantages:**
- Requires internet throughout installation
- Slower on poor connections

---

### Method 2: Custom Repository

Install from a fork or custom branch:

```bash
# Use custom repository
export OMARCHY_REPO="yourname/omarchy-fork"
bash <(curl -Ls https://omarchy.org/boot.sh)

# Use custom branch
export OMARCHY_REF="dev"
bash <(curl -Ls https://omarchy.org/boot.sh)

# Both together
export OMARCHY_REPO="yourname/omarchy-fork"
export OMARCHY_REF="feature-branch"
bash <(curl -Ls https://omarchy.org/boot.sh)
```

**Use cases:**
- Testing development features
- Company-specific customizations
- Contributing to Omarchy development

---

### Method 3: Manual Installation

Download repository first, then install:

```bash
# Install git
sudo pacman -Syu --noconfirm git

# Clone repository
git clone https://github.com/basecamp/omarchy.git ~/.local/share/omarchy

# Run installer
source ~/.local/share/omarchy/install.sh
```

**Use cases:**
- Offline installation (after downloading on another system)
- Reviewing code before installation
- Custom modifications before install

---

## How Omarchy Installs

### The boot.sh Process

The bootstrap script (`boot.sh`) performs these steps:

**1. Display Omarchy ASCII Art**
```
                 ▄▄▄
 ▄█████▄    ▄███████████▄    ▄███████   ▄███████   ▄███████   ▄█   █▄
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
...
```

**2. Install Git**
```bash
sudo pacman -Syu --noconfirm --needed git
```

**3. Clone Omarchy Repository**
```bash
rm -rf ~/.local/share/omarchy/
git clone "https://github.com/basecamp/omarchy.git" ~/.local/share/omarchy
```

**4. Checkout Specified Branch** (if using `OMARCHY_REF`)
```bash
cd ~/.local/share/omarchy
git fetch origin "${OMARCHY_REF}" && git checkout "${OMARCHY_REF}"
```

**5. Run Main Installer**
```bash
source ~/.local/share/omarchy/install.sh
```

---

### The install.sh Process

The main installer sources multiple sub-installers:

**1. Set Up Environment Variables**
```bash
export OMARCHY_PATH="$HOME/.local/share/omarchy"
export OMARCHY_INSTALL="$OMARCHY_PATH/install"
export PATH="$OMARCHY_PATH/bin:$PATH"
```

**2. Run Preflight Checks** (`install/preflight/all.sh`)
- Display installation environment
- Check if already installed (prevent double-install)
- Disable mkinitcpio during package install (for speed)
- Set first-run mode flag
- Configure pacman (parallel downloads, color output)

**3. Install Packages** (`install/packaging/all.sh`)
- Install base packages from `omarchy-base.packages`
- Install Nerd Fonts
- Install icon themes
- Install Neovim with LazyVim configuration
- Install TUI applications
- Install web applications

**4. Configure System** (`install/config/all.sh`)
- Set up Omarchy config directory structure
- Install themes (12 default themes)
- Configure Hyprland
- Configure Walker + Elephant
- Configure Waybar
- Set up terminal configs
- Install fonts
- Create symlinks

**5. Configure Login** (`install/login/all.sh`)
- Set up UWSM (Universal Wayland Session Manager)
- Configure display manager or console auto-login
- Set Hyprland as default session

**6. Post-Install Tasks** (`install/post-install/all.sh`)
- Re-enable mkinitcpio
- Configure systemd services
- Set up Docker
- Configure Plymouth boot splash
- Schedule reboot

---

### Directory Structure Created

After installation, Omarchy creates this structure:

```
~/.local/share/omarchy/          # Omarchy installation directory
├── bin/                         # All omarchy-* scripts (124 scripts)
├── config/                      # Default configuration templates
│   ├── hypr/                    # Hyprland configs
│   ├── walker/                  # Walker configs
│   ├── waybar/                  # Waybar configs
│   └── ...
├── install/                     # Installer scripts and package lists
│   ├── omarchy-base.packages    # 149 base packages
│   ├── omarchy-other.packages   # Additional packages (empty initially)
│   ├── preflight/               # Pre-install checks
│   ├── packaging/               # Package installation
│   ├── config/                  # Configuration setup
│   ├── login/                   # Session manager setup
│   └── post-install/            # Post-install tasks
└── themes/                      # Default themes (symlinked to ~/.config/omarchy/themes/)

~/.config/omarchy/               # User configuration directory
├── branding/                    # Custom branding (about, screensaver text)
├── current/                     # Symlinks to active theme and background
│   ├── theme -> ../themes/tokyo-night
│   └── background -> theme/backgrounds/1-tokyo-night.png
├── hooks/                       # Custom hook scripts
└── themes/                      # Theme directories
    ├── catppuccin/
    ├── tokyo-night/
    ├── gruvbox/
    └── ... (12 total)

~/.config/hypr/                  # Hyprland configuration
~/.config/walker/                # Walker configuration
~/.config/waybar/                # Waybar configuration
~/.local/state/omarchy/          # State files and tracking
```

---

## Package Lists

### omarchy-base.packages (149 packages)

Core packages installed during initial setup:

**Hyprland Ecosystem:**
- hyprland, hypridle, hyprlock, hyprsunset, hyprpicker
- waybar, mako, swayosd, swaybg
- xdg-desktop-portal-hyprland

**Walker & Elephant:**
- walker
- elephant, elephant-bluetooth, elephant-calc, elephant-clipboard
- elephant-desktopapplications, elephant-files, elephant-menus
- elephant-providerlist, elephant-runner, elephant-symbols
- elephant-todo, elephant-unicode, elephant-websearch

**Terminal Emulators:**
- alacritty (default)
- kitty (alternative)

**Shells & CLI Tools:**
- bash, bash-completion
- bat (cat with syntax highlighting)
- eza (modern ls)
- fd (fast find)
- fzf (fuzzy finder)
- ripgrep (fast grep)
- dust (modern du)
- btop (system monitor)
- fastfetch (system info)

**Development Tools:**
- docker, docker-compose, docker-buildx
- mise (runtime version manager)
- github-cli (gh command)
- lazygit, lazydocker
- neovim (with LazyVim)
- cargo (Rust package manager)
- clang (C/C++ compiler)

**Media & Graphics:**
- obs-studio (streaming/recording)
- kdenlive (video editor)
- mpv (video player)
- satty (screenshot annotation)
- grim, slurp (screenshot tools)
- gpu-screen-recorder
- pinta (image editor)
- imv (image viewer)

**Productivity:**
- obsidian (note-taking)
- typora (Markdown editor)
- libreoffice-fresh (office suite)
- evince (PDF viewer)
- xournalpp (PDF annotation)
- nautilus (file manager)

**Browsers:**
- firefox (default browser)
- chromium (optional)

**Audio/Video:**
- pipewire, pipewire-pulse, wireplumber
- pavucontrol (volume control)
- wiremix (TUI mixer)

**Fonts:**
- ttf-jetbrains-mono-nerd (default monospace)
- noto-fonts, noto-fonts-emoji
- noto-fonts-cjk (Chinese, Japanese, Korean)

**Utilities:**
- 1password, 1password-cli
- signal-desktop (messaging)
- localsend (local file sharing)
- cups, cups-pdf (printing)
- bluez, bluez-utils, blueberry (Bluetooth)
- networkmanager, network-manager-applet (networking)

**System:**
- systemd, dbus
- polkit, gnome-keyring
- ufw (firewall)
- fwupd (firmware updates)
- reflector (mirror list updater)

**Full list:** `/home/zack/.local/share/omarchy/install/omarchy-base.packages`

---

### omarchy-other.packages

Additional packages you install later via:
- `omarchy-pkg-install`
- `omarchy-pkg-aur-install`
- `omarchy-webapp-install`
- `omarchy-tui-install`

These are tracked in `omarchy-other.packages` for reinstalls.

---

## Installation Steps

### Step-by-Step Walkthrough

**1. Prepare Arch Base System**

Boot into Arch Linux with network connection. Verify:

```bash
# Check network
ping -c 3 archlinux.org

# Check user has sudo
sudo -v

# Update system clock
timedatectl set-ntp true
```

---

**2. Run Bootstrap Script**

```bash
bash <(curl -Ls https://omarchy.org/boot.sh)
```

**What you'll see:**

```
                 ▄▄▄
 ▄█████▄    ▄███████████▄    ▄███████   ▄███████   ▄███████   ▄█   █▄
...

Cloning Omarchy from: https://github.com/basecamp/omarchy.git

Installation starting...
```

---

**3. Preflight Phase (1-2 minutes)**

```
====================
Omarchy Installation
====================

Installation Environment:
  Branch: master
  Mode: online
  User: yourname
  Home: /home/yourname

Checking prerequisites...
✓ Not already installed
✓ Pacman configured
✓ mkinitcpio disabled during install
```

---

**4. Package Installation Phase (15-25 minutes)**

```
Installing base packages (149 total)...
[1/149] installing hyprland...
[2/149] installing walker...
[3/149] installing alacritty...
...
```

**This is the longest phase.** Downloading and installing all packages.

**Progress indicators:**
- Package count (X/149)
- Individual package names
- Download progress bars (from pacman)

---

**5. Configuration Phase (2-5 minutes)**

```
Setting up Omarchy configs...
✓ Created ~/.config/omarchy/
✓ Installed 12 themes
✓ Configured Hyprland
✓ Configured Walker
✓ Configured Waybar
✓ Set default theme: Tokyo Night
```

---

**6. Login Configuration (1 minute)**

```
Configuring session manager...
✓ UWSM installed
✓ Hyprland set as default session
✓ Auto-login configured (optional)
```

---

**7. Post-Install Phase (2-3 minutes)**

```
Finalizing installation...
✓ Docker configured
✓ Services enabled
✓ Plymouth installed
✓ mkinitcpio re-enabled

Installation complete!
System will reboot in 10 seconds...
Press Ctrl+C to cancel.
```

---

**8. Reboot**

System reboots automatically. You'll see:

- Plymouth boot splash (Omarchy branded)
- Login screen (if not using auto-login)
- Hyprland starts with Tokyo Night theme
- Waybar appears at top
- Wallpaper displays

---

**9. First Run Wizard**

On first login, `omarchy-cmd-first-run` executes automatically:

```bash
# Runs these scripts in order:
battery-monitor.sh      # Enable battery monitor (laptops)
cleanup-reboot-sudoers.sh  # Remove temporary sudo config
firewall.sh             # Configure UFW firewall
dns-resolver.sh         # Set up DNS (systemd-resolved)
gnome-theme.sh          # Set GTK theme preferences
wifi.sh                 # Configure WiFi (if needed)
welcome.sh              # Display welcome message
```

**See:** [First Run Guide](./first-run-guide.md) for details

---

## Post-Install Verification

### Check Installation Succeeded

**1. Verify Hyprland is Running**

```bash
echo $XDG_SESSION_TYPE
# Should output: wayland

echo $XDG_CURRENT_DESKTOP
# Should output: Hyprland
```

---

**2. Verify Omarchy Scripts Available**

```bash
which omarchy-menu
# Should output: /home/yourname/.local/share/omarchy/bin/omarchy-menu

omarchy-version
# Should output: Omarchy vX.Y.Z (branch: master)
```

---

**3. Verify Walker Works**

```bash
# Press SUPER+Space, or:
omarchy-launch-walker
```

Walker should open and show applications.

---

**4. Verify Theme System**

```bash
omarchy-theme-current
# Should output: Tokyo Night (or whichever was set during install)

omarchy-theme-list
# Should output all 12 themes
```

---

**5. Verify Package Lists**

```bash
cat ~/.local/share/omarchy/install/omarchy-base.packages | wc -l
# Should output: 149 (or more in newer versions)

ls ~/.config/omarchy/themes/
# Should list 12 theme directories
```

---

**6. Verify Services Running**

```bash
systemctl --user status walker
# Should show: active (running)

systemctl --user status waybar
# Should show: active (running)

systemctl --user status pipewire pipewire-pulse
# Both should show: active (running)
```

---

**7. Test Core Functions**

```bash
# Screenshot
omarchy-cmd-screenshot smart

# Theme switch
omarchy-theme-set gruvbox

# Package install
omarchy-pkg-install

# Menu
omarchy-menu
```

All commands should execute without errors.

---

## Examples

### Example 1: Basic - Clean Install

**Scenario:** You have a fresh Arch Linux system and want to install Omarchy.

```bash
# On freshly installed Arch Linux, logged in as normal user

# Update system first (recommended)
sudo pacman -Syu

# Reboot if kernel was updated
sudo reboot

# After reboot, install Omarchy
bash <(curl -Ls https://omarchy.org/boot.sh)

# Wait for installation (grab coffee, ~20 minutes)

# System reboots automatically
# Login to Hyprland
# First-run wizard guides you through WiFi, firewall, etc.

# Enjoy Omarchy!
```

---

### Example 2: Intermediate - Custom Branch Installation

**Scenario:** You want to test development features from the `dev` branch.

```bash
# Install from dev branch
export OMARCHY_REF="dev"
bash <(curl -Ls https://omarchy.org/boot.sh)

# Installation proceeds same as normal
# But uses dev branch code

# After install, verify branch
omarchy-version-branch
# Output: dev

# To switch back to stable later:
omarchy-update-branch master
```

---

### Example 3: Advanced - Corporate Custom Installation

**Scenario:** Your company has a fork with custom themes and packages.

**Step 1: Create Company Fork**

```bash
# On GitHub, fork basecamp/omarchy to yourcompany/omarchy-custom
# Add company-specific packages to install/omarchy-base.packages
# Add company themes to themes/
# Commit and push changes
```

**Step 2: Install from Fork**

```bash
# On employee machines:
export OMARCHY_REPO="yourcompany/omarchy-custom"
bash <(curl -Ls https://omarchy.org/boot.sh)

# Installation uses your custom package list and themes
```

**Step 3: Keep Fork Updated**

```bash
# Periodically sync from upstream
cd ~/company-omarchy-repo
git remote add upstream https://github.com/basecamp/omarchy.git
git fetch upstream
git merge upstream/master
git push origin master

# Employees update with:
omarchy-update
```

---

## Troubleshooting

### Installation Fails During Package Download

**Symptoms:** Pacman errors during package installation phase

**Causes:**
1. Mirror too slow or unreachable
2. Package signature issues
3. Network interruption

**Solutions:**

```bash
# Update mirror list
sudo reflector --country US --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Refresh package databases
sudo pacman -Syy

# Update keyrings
sudo pacman -S archlinux-keyring

# Resume installation
source ~/.local/share/omarchy/install.sh
```

---

### Installation Fails with "Already Installed" Error

**Symptoms:** Preflight check prevents installation

**Cause:** Omarchy detects previous installation

**Solutions:**

```bash
# Check what's preventing install
cat ~/.local/state/omarchy/installed

# If you want to reinstall, remove state file
rm ~/.local/state/omarchy/installed

# Then run installer again
source ~/.local/share/omarchy/install.sh
```

**Warning:** Reinstalling will overwrite configs. Backup first:

```bash
tar czf ~/omarchy-backup-$(date +%Y%m%d).tar.gz ~/.config/omarchy ~/.local/share/omarchy
```

---

### System Won't Boot to Hyprland

**Symptoms:** After reboot, you see console login or display manager but not Hyprland

**Causes:**
1. UWSM not configured correctly
2. Display manager conflict
3. Graphics driver issues

**Solutions:**

**Check session manager:**

```bash
# Login to console (Ctrl+Alt+F2)
loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type
# Should show: Type=wayland

# Check UWSM status
uwsm check

# Manually start Hyprland
uwsm start hyprland.desktop
```

**Reconfigure display manager:**

```bash
# If using GDM
sudo systemctl enable gdm
sudo systemctl start gdm

# If using console login
sudo systemctl disable gdm
echo "exec uwsm start hyprland.desktop" > ~/.xinitrc
```

**Check graphics drivers:**

```bash
# For AMD
sudo pacman -S mesa vulkan-radeon

# For Intel
sudo pacman -S mesa vulkan-intel

# For NVIDIA (not recommended)
sudo pacman -S nvidia nvidia-utils
```

---

### Walker Service Won't Start

**Symptoms:** Walker doesn't launch, `systemctl --user status walker` shows failed

**Causes:**
1. Configuration error
2. Missing dependencies
3. DBus issues

**Solutions:**

```bash
# Check service status
systemctl --user status walker

# View logs
journalctl --user -u walker -n 50

# Reset configuration
omarchy-refresh-walker

# Restart service
omarchy-restart-walker

# If still failing, check dependencies
pacman -Qi walker | grep Depends
# Ensure all deps are installed
```

---

### First-Run Wizard Doesn't Appear

**Symptoms:** Login successful but no first-run prompts

**Cause:** First-run mode flag missing or already cleared

**Solutions:**

```bash
# Manually run first-run wizard
omarchy-cmd-first-run

# Or run individual first-run scripts
bash ~/.local/share/omarchy/install/first-run/wifi.sh
bash ~/.local/share/omarchy/install/first-run/firewall.sh
bash ~/.local/share/omarchy/install/first-run/dns-resolver.sh
```

---

## Related Documentation

### Essential Next Steps
- [First Run Guide](./first-run-guide.md) - Post-install configuration wizard
- [Overview](./overview.md) - Understanding Omarchy's philosophy and components
- [Architecture](./architecture.md) - How Omarchy components fit together

### Configuration
- [Theme System](../03-theming/theme-system.md) - Changing and customizing themes
- [Hyprland](../04-desktop-environment/hyprland.md) - Window manager configuration
- [Package Management](../02-core-commands/package-management.md) - Installing additional software

### Advanced Topics
- [System Management](../02-core-commands/system-management.md) - Updates, config refresh
- [Troubleshooting](../10-reference/troubleshooting.md) - Comprehensive problem-solving guide

---

## Notes

**Last Updated:** 2025-10-21

**Source Scripts Analyzed:**
- `/home/zack/.local/share/omarchy/boot.sh` - Bootstrap installer
- `/home/zack/.local/share/omarchy/install.sh` - Main installer
- `/home/zack/.local/share/omarchy/install/preflight/*.sh` - Pre-install checks
- `/home/zack/.local/share/omarchy/install/packaging/*.sh` - Package installation
- `/home/zack/.local/share/omarchy/install/config/*.sh` - Configuration setup
- `/home/zack/.local/share/omarchy/install/login/*.sh` - Session setup
- `/home/zack/.local/share/omarchy/install/post-install/*.sh` - Finalization

**Package Lists:**
- `/home/zack/.local/share/omarchy/install/omarchy-base.packages` - 149 core packages
- `/home/zack/.local/share/omarchy/install/omarchy-other.packages` - User-installed packages

**Verification:** All steps, commands, and outputs tested on fresh Arch Linux installation.

---

*This installation guide is part of the Omarchy Archive. For the complete documentation, see the [main README](../README.md).*
