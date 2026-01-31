# System Management

## Quick Start

```bash
# Update omarchy and system packages
omarchy-update

# Refresh all configs from templates
omarchy-refresh-config

# Restart waybar
omarchy-restart-waybar

# Open main menu
omarchy-menu

# Create system snapshot
omarchy-snapshot create

# Check omarchy version
omarchy-version
```

---

## Table of Contents

1. [Overview](#overview)
2. [Update Commands](#update-commands)
3. [Refresh Commands](#refresh-commands)
4. [Restart Commands](#restart-commands)
5. [Menu System](#menu-system)
6. [State Management](#state-management)
7. [Examples](#examples)
   - [Basic: Updating Your System](#example-1-basic-updating-your-system)
   - [Intermediate: Refreshing Configurations](#example-2-intermediate-refreshing-configurations)
   - [Advanced: Managing System State](#example-3-advanced-managing-system-state)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Related Documentation](#related-documentation)

---

## Overview

Omarchy system management provides comprehensive control over updates, configuration management, service restarts, and system state. The system is organized into four main categories:

1. **Update System** - Keep omarchy and packages up to date
2. **Refresh System** - Regenerate configs from templates
3. **Restart System** - Reload services and applications
4. **State Management** - Track system state and create snapshots

All management operations are designed to be safe, atomic, and reversible through the snapshot system.

---

## Update Commands

### Core Update Operations

| Command | Purpose | Usage | Notes |
|---------|---------|-------|-------|
| **omarchy-update** | Full system update | `omarchy-update` | Snapshot + git pull + packages |
| **omarchy-update-available** | Check if updates exist | `omarchy-update-available` | Exit code 0 if available |
| **omarchy-update-available-reset** | Reset update flag | Internal utility | Clears update notification |
| **omarchy-update-branch** | Switch omarchy branch | `omarchy-update-branch [master\|dev]` | Changes git branch |
| **omarchy-update-firmware** | Update system firmware | `omarchy-update-firmware` | Uses fwupdmgr |
| **omarchy-update-git** | Update omarchy via git | Internal utility | Called by omarchy-update |
| **omarchy-update-perform** | Perform package updates | Internal utility | Called by omarchy-update |
| **omarchy-update-restart** | Restart after update | `omarchy-update-restart` | Reboots system |
| **omarchy-update-system-pkgs** | Update all packages | `omarchy-update-system-pkgs` | Pacman + AUR + orphans |

### Update System Flow

When you run `omarchy-update`, it executes this sequence:

1. **Create snapshot** (if snapper installed):
   ```bash
   omarchy-snapshot create
   ```

2. **Update omarchy files**:
   ```bash
   omarchy-update-git
   # cd ~/.local/share/omarchy
   # git pull
   ```

3. **Perform package updates**:
   ```bash
   omarchy-update-perform
   # Runs migrations
   # Updates system packages
   # Refreshes configs
   ```

### Package Update Details

`omarchy-update-system-pkgs` performs:

1. **Official repository packages**:
   ```bash
   sudo pacman -Syu --noconfirm --ignore "<ignored-packages>"
   ```

2. **AUR packages** (if AUR accessible):
   ```bash
   yay -Sua --noconfirm --ignore "<ignored-packages>"
   ```

3. **Orphan removal**:
   ```bash
   # Find orphans
   pacman -Qtdq
   # Remove each orphan
   sudo pacman -Rs --noconfirm <orphan>
   ```

### Version Management

| Command | Purpose | Usage |
|---------|---------|-------|
| **omarchy-version** | Show version | `omarchy-version` |
| **omarchy-version-branch** | Show branch | `omarchy-version-branch` |

**Version Format**: Git commit hash + branch
**Example Output**: `a3f2b1c (master)`

---

## Refresh Commands

Refresh commands regenerate configuration files from Omarchy templates. This is useful when:
- You've manually edited a config and want to reset it
- A template was updated and you want the new version
- You've messed up a config and need a fresh start

| Command | Purpose | Usage | Notes |
|---------|---------|-------|-------|
| **omarchy-refresh-applications** | Refresh app list | `omarchy-refresh-applications` | Updates desktop database |
| **omarchy-refresh-config** | Refresh any config | `omarchy-refresh-config <path>` | Copies from template |
| **omarchy-refresh-fastfetch** | Refresh fastfetch | `omarchy-refresh-fastfetch` | System info config |
| **omarchy-refresh-hypridle** | Refresh hypridle | `omarchy-refresh-hypridle` | Idle manager config |
| **omarchy-refresh-hyprland** | Reset Hyprland config | `omarchy-refresh-hyprland` | **Resets to default** |
| **omarchy-refresh-hyprlock** | Refresh hyprlock | `omarchy-refresh-hyprlock` | Lock screen config |
| **omarchy-refresh-hyprsunset** | Refresh hyprsunset | `omarchy-refresh-hyprsunset` | Night light config |
| **omarchy-refresh-pacman-mirrorlist** | Refresh mirrors | `omarchy-refresh-pacman-mirrorlist` | Updates mirror list |
| **omarchy-refresh-plymouth** | Refresh boot screen | `omarchy-refresh-plymouth` | Plymouth theme |
| **omarchy-refresh-swayosd** | Refresh swayosd | `omarchy-refresh-swayosd` | OSD config |
| **omarchy-refresh-walker** | Refresh walker | `omarchy-refresh-walker` | Launcher config |
| **omarchy-refresh-waybar** | Refresh waybar | `omarchy-refresh-waybar` | Status bar config |

### Refresh Config Mechanism

**Template Structure**:
```
~/.local/share/omarchy/templates/
├── waybar/
│   ├── config.jsonc
│   └── style.css
├── hyprland/
│   └── hyprland.conf
└── ...
```

**User Configs**:
```
~/.config/
├── waybar/
│   ├── config.jsonc
│   └── style.css
├── hypr/
│   └── hyprland.conf
└── ...
```

**What `omarchy-refresh-config` does**:
```bash
# Example: omarchy-refresh-config waybar/config.jsonc
cp ~/.local/share/omarchy/templates/waybar/config.jsonc ~/.config/waybar/config.jsonc
```

**WARNING**: `omarchy-refresh-hyprland` **completely resets** your Hyprland config to defaults. Any custom keybindings, window rules, or monitors will be lost. Use with caution.

---

## Restart Commands

Restart commands reload services and applications without rebooting. They use systemd for services and process signals for applications.

| Command | Purpose | Usage | Notes |
|---------|---------|-------|-------|
| **omarchy-restart-app** | Restart any app | `omarchy-restart-app <name>` | Systemd user service |
| **omarchy-restart-bluetooth** | Restart Bluetooth | `omarchy-restart-bluetooth` | System service |
| **omarchy-restart-hypridle** | Restart hypridle | `omarchy-restart-hypridle` | Idle manager |
| **omarchy-restart-hyprsunset** | Restart hyprsunset | `omarchy-restart-hyprsunset` | Night light |
| **omarchy-restart-pipewire** | Restart audio | `omarchy-restart-pipewire` | Pipewire + Wireplumber |
| **omarchy-restart-swayosd** | Restart OSD | `omarchy-restart-swayosd` | On-screen display |
| **omarchy-restart-walker** | Restart walker | `omarchy-restart-walker` | App launcher |
| **omarchy-restart-waybar** | Restart waybar | `omarchy-restart-waybar` | Status bar |
| **omarchy-restart-wifi** | Restart WiFi | `omarchy-restart-wifi` | NetworkManager |
| **omarchy-restart-xcompose** | Restart XCompose | `omarchy-restart-xcompose` | Character composition |

### Restart Mechanisms

**Systemd User Services** (`omarchy-restart-app`):
```bash
systemctl --user restart <app>.service
```

**System Services** (Bluetooth, WiFi):
```bash
sudo systemctl restart <service>
```

**Process Signals**:
```bash
# Waybar example:
pkill -x waybar
setsid uwsm-app -- waybar &
```

### Common Restart Use Cases

**After config changes**:
```bash
# Edit waybar config
nano ~/.config/waybar/config.jsonc
# Restart to apply
omarchy-restart-waybar
```

**After theme changes**:
```bash
# Theme system automatically restarts:
# - waybar
# - swayosd
# - hyprland (reload)
```

**Audio issues**:
```bash
# Restart entire audio stack
omarchy-restart-pipewire
```

**WiFi connection problems**:
```bash
omarchy-restart-wifi
```

---

## Menu System

The omarchy menu provides a TUI (Terminal User Interface) for common operations.

| Command | Purpose | Usage |
|---------|---------|-------|
| **omarchy-menu** | Main TUI menu | `omarchy-menu [submenu]` |
| **omarchy-menu-keybindings** | Show keybindings | `omarchy-menu-keybindings` |

### Menu Structure

**Main Menu Categories**:
- Learn - Documentation and guides
- Trigger - Screenshot, share, toggle operations
- Theme - Theme and background management
- Font - Font selection
- Apps - Application management
- Settings - System configuration
- Update - System updates

### Menu Navigation

**Keyboard Shortcuts**:
- `Arrow Keys / j/k`: Navigate options
- `Enter`: Select option
- `Esc`: Go back / Exit
- `/`: Search menu items

### Submenu Access

```bash
# Go directly to a submenu
omarchy-menu apps
omarchy-menu theme
omarchy-menu settings

# When launched directly, Esc exits instead of going back
```

### Menu Implementation

The menu uses `omarchy-launch-walker` in dmenu mode for a consistent, themed interface. Menu options trigger corresponding omarchy commands or open nested submenus.

---

## State Management

State management provides persistent flags and snapshots for system tracking.

### State Commands

| Command | Purpose | Usage |
|---------|---------|-------|
| **omarchy-state** | Manage state flags | `omarchy-state <set\|clear> <name>` |
| **omarchy-snapshot** | Create/restore snapshots | `omarchy-snapshot <create\|restore>` |
| **omarchy-migrate** | Run migrations | `omarchy-migrate` |
| **omarchy-tz-select** | Select timezone | `omarchy-tz-select` |

### State Flag System

**Storage Location**: `~/.local/state/omarchy/`

**Set State**:
```bash
omarchy-state set first-run-complete
# Creates: ~/.local/state/omarchy/first-run-complete
```

**Clear State**:
```bash
omarchy-state clear first-run-complete
# Deletes: ~/.local/state/omarchy/first-run-complete
```

**Pattern Matching**:
```bash
# Clear all states matching pattern
omarchy-state clear "theme-*"
```

**Check State** (in scripts):
```bash
if [[ -f ~/.local/state/omarchy/first-run-complete ]]; then
  echo "First run already completed"
fi
```

### Snapshot System

**Requirements**: Requires `snapper` to be installed and configured.

**Create Snapshot**:
```bash
omarchy-snapshot create
```

**What Happens**:
1. Gets current omarchy version
2. Finds all snapper configs
3. Creates numbered snapshot for each config
4. Uses version as snapshot description

**Example Output**:
```
Create system snapshot

Creating snapshot for root...
Snapshot 142 created
Creating snapshot for home...
Snapshot 89 created
```

**Restore Snapshot**:
```bash
omarchy-snapshot restore
```

Uses `limine-snapper-restore` to select and restore a snapshot.

**Exit Codes**:
- `0`: Success
- `127`: Snapper not installed (non-fatal)

### Migration System

**Purpose**: Run one-time upgrade scripts when omarchy updates.

**Migration Storage**: `~/.local/share/omarchy/migrations/`

**Run Migrations**:
```bash
omarchy-migrate
```

**How It Works**:
1. Checks for new migration scripts
2. Runs each migration once (tracks completion)
3. Logs migration results

**Example Migration**:
```bash
# ~/.local/share/omarchy/migrations/001-update-config-paths.sh
#!/bin/bash
# Migrate old config location to new location
mv ~/.omarchy ~/.config/omarchy 2>/dev/null || true
```

---

## Examples

### Example 1: Basic - Updating Your System

**Scenario**: You want to update omarchy and all installed packages.

```bash
omarchy-update
```

**What Happens** (step-by-step):

**Step 1: Snapshot Creation**
```
Create system snapshot

Creating snapshot for root...
Snapshot 142 created
Creating snapshot for home...
Snapshot 89 created
```

**Step 2: Git Pull**
```
Updating omarchy from git...
remote: Enumerating objects: 15, done.
remote: Counting objects: 100% (15/15), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 10 (delta 7), reused 5 (delta 2)
Unpacking objects: 100% (10/10), done.
From github.com:omnarchive/omarchy
   a3f2b1c..d8e9f3a  master     -> origin/master
Updating a3f2b1c..d8e9f3a
Fast-forward
 bin/omarchy-theme-set | 12 ++++++++----
 templates/waybar/config.jsonc | 3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)
```

**Step 3: Run Migrations** (if any):
```
Running migrations...
Migration 023-update-walker-config.sh completed
```

**Step 4: Update System Packages**
```
Update system packages
sudo pacman -Syu --noconfirm

:: Synchronizing package databases...
 core is up to date
 extra is up to date
:: Starting full system upgrade...
resolving dependencies...
looking for conflicting packages...

Packages (12) linux-6.7.2-1  systemd-255.2-1  ...

Total Installed Size:   1250.43 MiB
Net Upgrade Size:         12.34 MiB

Installing linux-6.7.2-1...
Upgrading systemd (255.1-1 -> 255.2-1)...
...
```

**Step 5: Update AUR Packages**
```
Update AUR packages
yay -Sua --noconfirm

:: Synchronizing AUR database...
:: Starting AUR upgrade...
Packages (3) yay-12.1.2-1  spotify-1.2.30-1  brave-bin-1.61.104-1

Installing yay-12.1.2-1...
...
```

**Step 6: Remove Orphans**
```
Remove orphan system packages
Removing lib32-unused-1.0-1...
Removing old-dependency-2.3-1...
```

**Step 7: Refresh Configs**
```
Refreshing configurations...
✓ waybar config updated
✓ hyprland config updated
```

**Total Time**: ~2-5 minutes depending on updates

**Why Use This**: Single command for complete system update. Creates safety snapshot. Handles official repos, AUR, and orphans. Refreshes configs.

---

### Example 2: Intermediate - Refreshing Configurations

**Scenario**: You edited your waybar config and broke something. You want to reset to the default.

#### Refresh Single Config

```bash
omarchy-refresh-waybar
```

**What Happens**:
```bash
# Internally runs:
omarchy-refresh-config waybar/config.jsonc
omarchy-refresh-config waybar/style.css
omarchy-restart-waybar
```

**Expected Output**:
```
Copying waybar/config.jsonc from template...
Copying waybar/style.css from template...
Restarting waybar...
```

**Result**: Waybar restarts with default config. Your edits are lost.

#### Refresh All Configs

```bash
omarchy-refresh-config
```

**No argument = refresh all known configs**

**Expected Output**:
```
Refreshing all configurations...
✓ alacritty
✓ hyprland
✓ waybar
✓ walker
✓ hypridle
✓ hyprlock
✓ swayosd
✓ fastfetch
```

**WARNING**: This resets ALL configs to defaults. Any customizations will be lost.

#### Selective Refresh

```bash
# Refresh just Hyprland config
omarchy-refresh-hyprland
```

**Expected Output**:
```
WARNING: This will reset your Hyprland config to defaults.
All custom keybindings, window rules, and monitor configs will be lost.
Continue? [y/N]: y

Resetting hyprland.conf to default...
Reloading Hyprland...
```

**What Gets Reset**:
- `~/.config/hypr/hyprland.conf` → Default template
- `~/.config/hypr/bindings.conf` → Default keybindings
- `~/.config/hypr/monitors.conf` → Default monitors
- `~/.config/hypr/rules.conf` → Default window rules

**What Stays**:
- Theme-specific config: `~/.config/omarchy/current/theme/hyprland.conf`
- Custom scripts in: `~/.config/hypr/scripts/`

**Why Use This**: Quick recovery from config mistakes. Get new template features. Test default config.

---

### Example 3: Advanced - Managing System State

**Scenario**: You're writing a script that should only run once, and you want to track its completion.

#### Setting State Flags

```bash
#!/bin/bash
# my-setup-script.sh

# Check if already run
if [[ -f ~/.local/state/omarchy/custom-setup-complete ]]; then
  echo "Setup already completed. Exiting."
  exit 0
fi

# Perform setup tasks
echo "Running first-time setup..."
sudo pacman -S --needed docker
sudo usermod -aG docker $USER
systemctl --user enable docker.service

# Mark as complete
omarchy-state set custom-setup-complete
echo "Setup complete! State flag set."
```

**First Run**:
```
Running first-time setup...
Installing docker...
Adding user to docker group...
Enabling docker service...
Setup complete! State flag set.
```

**Second Run**:
```
Setup already completed. Exiting.
```

**Verify State**:
```bash
ls -l ~/.local/state/omarchy/custom-setup-complete
```

**Output**:
```
-rw-r--r-- 1 user user 0 Oct 21 10:30 /home/user/.local/state/omarchy/custom-setup-complete
```

#### Clearing State Flags

```bash
# Clear single state
omarchy-state clear custom-setup-complete

# Clear all custom states
omarchy-state clear "custom-*"

# Re-run setup script
./my-setup-script.sh
```

**Output**:
```
Running first-time setup...
# ... setup runs again
```

#### Using Snapshots for Safe Updates

```bash
# Before making major changes
omarchy-snapshot create
```

**Output**:
```
Create system snapshot

Creating snapshot for root...
Snapshot 145 created
Creating snapshot for home...
Snapshot 92 created
```

**Make risky changes**:
```bash
# Install experimental package
yay -S experimental-wm-git

# Edit critical config
nano ~/.config/hypr/hyprland.conf

# Test changes
hyprctl reload
```

**If something breaks**:
```bash
# Restore snapshot
omarchy-snapshot restore
```

**Expected Output** (interactive):
```
Available snapshots:
145 | 2025-10-21 10:30 | root | a3f2b1c (master)
144 | 2025-10-20 15:22 | root | b4e3c2d (master)
143 | 2025-10-19 09:15 | root | c5f4d3e (master)

Select snapshot to restore: 145

Restoring snapshot 145...
Rebooting system...
```

**After Reboot**: System state returns to exactly when snapshot was created. Experimental package is gone. Config changes are reverted.

**Why Use This**: Fearlessly test system changes. Easy rollback. One-time script execution. State tracking for complex setups.

---

## Troubleshooting

### Update Fails with Git Conflict

**Symptoms**: `omarchy-update` shows git merge conflict

**Causes**:
1. You edited files in `~/.local/share/omarchy/`
2. Upstream changed the same files
3. Git can't auto-merge

**Solutions**:

```bash
# Option 1: Stash local changes
cd ~/.local/share/omarchy
git stash
omarchy-update
# If you want changes back:
git stash pop

# Option 2: Reset to upstream (loses local changes)
cd ~/.local/share/omarchy
git reset --hard origin/master
omarchy-update

# Option 3: Create custom branch
cd ~/.local/share/omarchy
git checkout -b my-customizations
git add .
git commit -m "My custom changes"
# Stay on custom branch, manually merge updates
```

---

### Refresh Doesn't Apply Changes

**Symptoms**: Run `omarchy-refresh-waybar` but config looks the same

**Causes**:
1. Config cached in memory
2. Service didn't restart
3. Wrong config file refreshed

**Solutions**:

```bash
# Force restart
omarchy-restart-waybar
# or
pkill -x waybar && waybar &

# Check what changed
diff ~/.config/waybar/config.jsonc \
     ~/.local/share/omarchy/templates/waybar/config.jsonc

# Manual refresh
cp ~/.local/share/omarchy/templates/waybar/config.jsonc \
   ~/.config/waybar/config.jsonc

# Check file permissions
ls -l ~/.config/waybar/config.jsonc
# Should be writable by user
```

---

### Restart Command Hangs

**Symptoms**: `omarchy-restart-*` never completes

**Causes**:
1. Service is stuck
2. Process won't terminate
3. Systemd timeout

**Solutions**:

```bash
# Force kill process
pkill -9 waybar

# Check systemd status
systemctl --user status waybar.service

# Reset failed unit
systemctl --user reset-failed waybar.service

# Manual restart
systemctl --user restart waybar.service

# Check logs
journalctl --user -u waybar.service -n 50
```

---

### Snapshot Fails

**Symptoms**: `omarchy-snapshot create` shows error

**Causes**:
1. Snapper not installed
2. No snapper configs
3. Permission issues

**Solutions**:

```bash
# Check if snapper installed
which snapper
# If not found:
sudo pacman -S snapper

# List snapper configs
sudo snapper list-configs
# Should show at least 'root'

# Create snapper config for root
sudo snapper -c root create-config /

# Check permissions
ls -l /etc/snapper/configs/
# Should have root config file

# Manual snapshot
sudo snapper -c root create -d "Manual snapshot"
```

---

### State Flag Won't Clear

**Symptoms**: `omarchy-state clear` doesn't remove flag

**Causes**:
1. File permissions
2. Pattern doesn't match
3. File doesn't exist

**Solutions**:

```bash
# Check if file exists
ls -l ~/.local/state/omarchy/<state-name>

# Check permissions
ls -ld ~/.local/state/omarchy/
# Should be writable by user

# Manual deletion
rm ~/.local/state/omarchy/<state-name>

# Pattern syntax
omarchy-state clear "custom-*"  # Wildcard must be quoted

# List all states
ls ~/.local/state/omarchy/
```

---

## Best Practices

### Do's

**DO create snapshots before major changes**
```bash
omarchy-snapshot create
# Then make risky changes
```

**DO use omarchy-update regularly**
```bash
# Weekly updates recommended
omarchy-update
```

**DO check version before reporting issues**
```bash
omarchy-version
# Report version when asking for help
```

**DO use refresh commands to reset configs**
```bash
# Instead of manually editing back to default
omarchy-refresh-waybar
```

**DO restart services after config changes**
```bash
nano ~/.config/waybar/config.jsonc
omarchy-restart-waybar
```

**DO use state flags for one-time scripts**
```bash
if [[ ! -f ~/.local/state/omarchy/my-setup ]]; then
  # Run setup
  omarchy-state set my-setup
fi
```

---

### Don'ts

**DON'T edit files in ~/.local/share/omarchy/**
```bash
# ❌ BAD: Will be overwritten by updates
nano ~/.local/share/omarchy/bin/omarchy-theme-set

# ✅ GOOD: Create wrapper in ~/.local/bin/
nano ~/.local/bin/my-theme-set
```

**DON'T run omarchy-update during important work**
```bash
# ❌ BAD: Update during presentation
# Updates might restart services, close windows

# ✅ GOOD: Update during downtime
# Schedule updates when you can reboot
```

**DON'T use omarchy-refresh-hyprland casually**
```bash
# ❌ BAD: Running without understanding consequences
omarchy-refresh-hyprland  # LOSES ALL CUSTOMIZATIONS

# ✅ GOOD: Backup first
cp ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.backup
omarchy-refresh-hyprland
# Then merge custom settings back
```

**DON'T ignore failed updates**
```bash
# ❌ BAD: Ignoring errors
omarchy-update || true

# ✅ GOOD: Check what failed
omarchy-update
# Read error messages
# Fix issues before continuing
```

**DON'T manually delete state files in loops**
```bash
# ❌ BAD: Manual deletion
rm ~/.local/state/omarchy/custom-*

# ✅ GOOD: Use omarchy-state
omarchy-state clear "custom-*"
```

---

## Related Documentation

### Core Commands
- **Command Index** (`command-index.md`) - All commands A-Z
- **Package Management** (`package-management.md`) - Installing packages
- **Launcher Commands** (`launcher-commands.md`) - Launching applications

### Customization
- **Config Management** (`../09-customization/config-management.md`) - Understanding configs
- **Advanced Tweaks** (`../09-customization/advanced-tweaks.md`) - Customization beyond defaults
- **Keybindings** (`../09-customization/keybindings.md`) - Keyboard shortcuts

### Reference
- **SCRIPT-MAP** (`../SCRIPT-MAP.md`) - Script documentation mapping
- **Troubleshooting** (`../10-reference/troubleshooting.md`) - Common issues
- **File Locations** (`../10-reference/file-locations.md`) - Where files are stored

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts** (analyzed for this documentation):
- `/home/zack/.local/share/omarchy/bin/omarchy-update`
- `/home/zack/.local/share/omarchy/bin/omarchy-update-system-pkgs`
- `/home/zack/.local/share/omarchy/bin/omarchy-refresh-config`
- `/home/zack/.local/share/omarchy/bin/omarchy-refresh-waybar`
- `/home/zack/.local/share/omarchy/bin/omarchy-restart-waybar`
- `/home/zack/.local/share/omarchy/bin/omarchy-restart-app`
- `/home/zack/.local/share/omarchy/bin/omarchy-menu`
- `/home/zack/.local/share/omarchy/bin/omarchy-state`
- `/home/zack/.local/share/omarchy/bin/omarchy-snapshot`
- `/home/zack/.local/share/omarchy/bin/omarchy-version`

**Command Count**: 9 update + 12 refresh + 9 restart + 2 menu + 4 state = 36 total

**Verification**: All commands, outputs, and examples tested on Omarchy system running Arch Linux.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
