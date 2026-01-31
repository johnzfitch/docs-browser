# Configuration Management

## Quick Start

```bash
# View current config structure
ls -la ~/.config/omarchy/

# Reset a specific config to default
omarchy-refresh-config hypr/hyprlock.conf

# View default configs
ls -la ~/.local/share/omarchy/config/

# Check what a reset would do
diff ~/.config/hypr/hyprlock.conf ~/.local/share/omarchy/config/hypr/hyprlock.conf
```

---

## Table of Contents

1. [Overview](#overview)
2. [Configuration Architecture](#configuration-architecture)
3. [omarchy-refresh-config Command](#omarchy-refresh-config-command)
4. [Config Directory Structure](#config-directory-structure)
5. [Default vs Current Configs](#default-vs-current-configs)
6. [Symlink System](#symlink-system)
7. [Examples](#examples)
   - [Basic: Resetting a Single Config](#example-1-basic-resetting-a-single-config)
   - [Intermediate: Backing Up and Restoring](#example-2-intermediate-backing-up-and-restoring-customizations)
   - [Advanced: Understanding the Config System](#example-3-advanced-understanding-the-config-system)
8. [Backup and Restore Strategy](#backup-and-restore-strategy)
9. [Troubleshooting](#troubleshooting)
10. [Best Practices](#best-practices)
11. [Related Documentation](#related-documentation)

---

## Overview

Omarchy's configuration management system provides a clean separation between default configurations and user customizations. This architecture allows you to safely experiment with settings while maintaining the ability to quickly reset to known-good defaults.

The system uses a dual-layer approach:
- **Default configs** stored in `~/.local/share/omarchy/config/` (read-only, updated with Omarchy)
- **Current configs** in `~/.config/` (user-editable, your active settings)

The `omarchy-refresh-config` command bridges these two layers, allowing selective restoration of defaults while preserving your customizations elsewhere. When you refresh a config, Omarchy creates timestamped backups automatically, ensuring you never lose work.

---

## Configuration Architecture

### Directory Structure Overview

```
~/.local/share/omarchy/
├── bin/                      # Omarchy scripts (124 commands)
├── config/                   # Default configurations
│   ├── alacritty/
│   ├── hypr/
│   ├── waybar/
│   └── ...                   # Configs for all components
└── default/
    └── hypr/                 # Additional Hyprland defaults
        └── bindings/         # Default keybinding files

~/.config/
├── omarchy/
│   ├── current/              # Symlinks to active settings
│   │   ├── theme -> ../themes/tokyo-night
│   │   └── background -> theme/backgrounds/1.png
│   ├── themes/               # Theme definitions
│   ├── hooks/                # Custom hook scripts
│   └── branding/             # Logo customizations
├── hypr/                     # User Hyprland configs
├── waybar/                   # User Waybar configs
└── ...                       # Other application configs
```

### Configuration Layers

Omarchy uses a **layered configuration system** where defaults are sourced first, then user configs override specific settings:

**Hyprland Example**:
```conf
# ~/.config/hypr/hyprland.conf

# Layer 1: Source Omarchy defaults (maintained by updates)
source = ~/.local/share/omarchy/default/hypr/autostart.conf
source = ~/.local/share/omarchy/default/hypr/bindings/media.conf
source = ~/.local/share/omarchy/default/hypr/looknfeel.conf
source = ~/.config/omarchy/current/theme/hyprland.conf

# Layer 2: Source user customizations (your edits)
source = ~/.config/hypr/monitors.conf
source = ~/.config/hypr/input.conf
source = ~/.config/hypr/bindings.conf
source = ~/.config/hypr/autostart.conf
```

This means:
- Omarchy provides sensible defaults for all settings
- You only need to specify what you want to **change** in user configs
- Your customizations take precedence (sourced last)
- You can reset individual files without affecting others

---

## omarchy-refresh-config Command

### Purpose

`omarchy-refresh-config` replaces a user config file with the corresponding default from Omarchy, creating a backup of your current file.

### Syntax

```bash
omarchy-refresh-config <config_file_path>
```

### Parameters

- `config_file_path`: Path relative to `~/.config/` (e.g., `hypr/hyprlock.conf`)

### Behavior

1. **Backup Creation**: Copies current file to `<filename>.bak.<timestamp>`
2. **File Replacement**: Copies default from `~/.local/share/omarchy/config/` to `~/.config/`
3. **Comparison**: Runs `diff` to show what changed
4. **Cleanup**: Removes backup if files are identical (no changes)

### What Gets Backed Up

Backups are timestamped to prevent conflicts:

```bash
~/.config/hypr/hyprlock.conf.bak.1753817951
```

Timestamp format: Unix epoch seconds (output of `date +%s`)

### Return Behavior

**Silent Success**: If the file didn't exist or was already using defaults, no output.

**Changes Detected**: Shows colored diff:
- Red: Your customizations being replaced
- Green: Default settings being restored

---

## Config Directory Structure

### Default Configs Location

All Omarchy default configurations live in:

```
~/.local/share/omarchy/config/
```

**Available Configs**:

```bash
$ ls ~/.local/share/omarchy/config/
alacritty/      # Terminal emulator configs
btop/           # Resource monitor theme
chromium/       # Browser policies
elephant/       # Clipboard/history provider
environment.d/  # Environment variables
fastfetch/      # System info display
fcitx5/         # Input method framework
fontconfig/     # Font configuration
ghostty/        # Ghostty terminal config
hypr/           # Hyprland window manager
kitty/          # Kitty terminal config
lazygit/        # Git TUI config
omarchy/        # Omarchy-specific settings
swayosd/        # On-screen display
systemd/        # User services
Typora/         # Markdown editor theme
uwsm/           # Wayland session manager
walker/         # Application launcher
waybar/         # Status bar
```

### Current Configs Location

Your active configurations are in standard XDG locations:

```
~/.config/<application>/
```

### Special Omarchy Configs

```
~/.config/omarchy/
├── current/
│   ├── theme         # Symlink to active theme directory
│   └── background    # Symlink to current wallpaper
├── themes/           # Installed themes
├── hooks/            # Custom scripts triggered by events
└── branding/         # Custom logos for fastfetch, etc.
```

---

## Default vs Current Configs

### Philosophy

**Defaults** (in `~/.local/share/omarchy/config/`):
- Maintained by Omarchy updates
- Represent tested, working configurations
- Should **never be edited directly**
- Serve as reset points and documentation

**Current** (in `~/.config/`):
- Your active settings
- Safe to edit and customize
- Overwrite defaults when sourced
- Persist across Omarchy updates

### Which Configs to Customize

**Recommended for User Editing**:
- `~/.config/hypr/bindings.conf` - Your keybindings
- `~/.config/hypr/autostart.conf` - Your startup apps
- `~/.config/hypr/monitors.conf` - Your monitor setup
- `~/.config/hypr/input.conf` - Your input device settings
- `~/.config/hypr/envs.conf` - Your environment variables
- `~/.config/hypr/looknfeel.conf` - Your visual preferences

**Avoid Editing** (use Omarchy commands instead):
- Theme files (use `omarchy-theme-set`)
- Font configs (use `omarchy-font-set`)
- Default Omarchy scripts (create hooks instead)

### Update Behavior

When Omarchy updates:
- **Defaults are updated**: New features, bug fixes, improvements
- **Your configs remain untouched**: Your customizations persist
- **New defaults don't auto-apply**: You must manually refresh configs to get updates

This prevents Omarchy from overwriting your work, but means you might miss improvements. Check release notes and selectively refresh configs after updates.

---

## Symlink System

### Current Theme Symlink

Omarchy uses symlinks for dynamic configuration switching:

```bash
~/.config/omarchy/current/theme -> ../themes/tokyo-night
```

**Why Symlinks?**
- Applications reference a single path: `~/.config/omarchy/current/theme/`
- Theme can be changed instantly by updating the symlink
- No need to rewrite every config file when switching themes

**How It Works**:

```bash
# Hyprland sources the current theme
source = ~/.config/omarchy/current/theme/hyprland.conf

# When you run: omarchy-theme-set gruvbox
# Omarchy updates the symlink:
ln -nsf ~/.config/omarchy/themes/gruvbox ~/.config/omarchy/current/theme

# Now Hyprland automatically loads gruvbox colors on next reload
```

### Current Background Symlink

```bash
~/.config/omarchy/current/background -> theme/backgrounds/1-tokyo-night.png
```

**Purpose**: Single reference point for wallpaper, updated when cycling backgrounds

**Used By**:
- `swaybg` (wallpaper daemon)
- `hyprlock` (lock screen background)
- `plymouth` (boot splash screen)

### Verifying Symlinks

```bash
# Check current theme
readlink ~/.config/omarchy/current/theme
# → /home/you/.config/omarchy/themes/tokyo-night

# Check current background
readlink ~/.config/omarchy/current/background
# → /home/you/.config/omarchy/themes/tokyo-night/backgrounds/1-tokyo-night.png

# List all symlinks in current/
ls -la ~/.config/omarchy/current/
```

### Manual Symlink Management

**Do**:
```bash
# Use Omarchy commands
omarchy-theme-set catppuccin
omarchy-theme-bg-next
```

**Don't**:
```bash
# Manual symlink changes skip important updates
ln -sf ~/.config/omarchy/themes/gruvbox ~/.config/omarchy/current/theme  # ❌
```

Manual symlink changes bypass:
- Component restarts (Waybar, Hyprland, etc.)
- Application theme updates (VS Code, browsers, etc.)
- Hook execution (custom scripts)

---

## Examples

### Example 1: Basic - Resetting a Single Config

**Scenario**: You've customized `hyprlock.conf` for your lock screen, but something broke and you want to start fresh.

```bash
# Check what you changed
diff ~/.config/hypr/hyprlock.conf ~/.local/share/omarchy/config/hypr/hyprlock.conf
```

**Expected Output**:
```diff
< background {
<     color = rgb(FF0000)  # Your custom red background
< }
---
> background {
>     color = rgb(1e1e2e)  # Default dark background
> }
```

```bash
# Reset to default
omarchy-refresh-config hypr/hyprlock.conf
```

**Expected Output**:
```
Replaced /home/you/.config/hypr/hyprlock.conf with new Omarchy default.
Saved backup as /home/you/.config/hypr/hyprlock.conf.bak.1753817951.

Changes:
< background {
<     color = rgb(FF0000)
< }
---
> background {
>     color = rgb(1e1e2e)
> }
```

**What Happened**:
1. Your current `hyprlock.conf` was backed up with timestamp
2. Default `hyprlock.conf` was copied from `~/.local/share/omarchy/config/`
3. Diff shows your red background was replaced with default dark theme color
4. Backup is preserved at `hyprlock.conf.bak.1753817951`

**Verify the Change**:
```bash
# Lock screen to see new default
hyprctl dispatch exec hyprlock

# Or compare directly
cat ~/.config/hypr/hyprlock.conf
```

**Restore Your Backup** (if you change your mind):
```bash
cp ~/.config/hypr/hyprlock.conf.bak.1753817951 ~/.config/hypr/hyprlock.conf
```

**Why Use This**: Quick recovery from broken configs. Safer than manual editing when you just want defaults back.

---

### Example 2: Intermediate - Backing Up and Restoring Customizations

**Scenario**: You're about to experiment with Hyprland window rules and want to ensure you can revert all changes.

**Step 1: Create Full Backup**

```bash
# Backup entire Hyprland config directory
cp -r ~/.config/hypr ~/.config/hypr.backup.$(date +%Y-%m-%d)
```

**Expected Output**: (silent, but creates directory)

**Verify**:
```bash
ls -d ~/.config/hypr.backup.*
# → /home/you/.config/hypr.backup.2025-10-21
```

**Step 2: Experiment with Window Rules**

```bash
# Edit window rules
nano ~/.config/hypr/hyprland.conf

# Add experimental rules at bottom:
windowrulev2 = opacity 0.8 0.8, class:^(Alacritty)$
windowrulev2 = animation slide, class:^(nautilus)$
windowrulev2 = workspace 5, class:^(Signal)$

# Reload to test
hyprctl reload
```

**Step 3: Something Breaks - Selective Reset**

```bash
# Maybe window rules broke animations
# Reset just the main config
omarchy-refresh-config hypr/hyprland.conf
```

**Expected Output**:
```
Replaced /home/you/.config/hypr/hyprland.conf with new Omarchy default.
Saved backup as /home/you/.config/hypr/hyprland.conf.bak.1753818123.
```

**Notice**: Other files in `~/.config/hypr/` are unchanged:
- `bindings.conf` - Your keybindings still intact
- `monitors.conf` - Monitor setup unchanged
- `autostart.conf` - Startup apps preserved

**Step 4: Restore Full Backup** (if needed)

```bash
# Complete restoration
rm -rf ~/.config/hypr
cp -r ~/.config/hypr.backup.2025-10-21 ~/.config/hypr

# Reload Hyprland
hyprctl reload
```

**Step 5: Clean Up**

```bash
# If experiments successful, remove backup
rm -rf ~/.config/hypr.backup.2025-10-21

# Or keep it for future safety
mv ~/.config/hypr.backup.2025-10-21 ~/.config/hypr.known-good
```

**Why Use This**: Enables fearless experimentation. You can try aggressive changes knowing you have multiple restore points (Omarchy's auto-backups + your manual snapshot).

---

### Example 3: Advanced - Understanding the Config System

**Scenario**: You want to understand how Omarchy's layered config system works, so you can customize effectively without breaking anything.

**Investigation 1: Trace Config Sources**

```bash
# Look at main Hyprland config
cat ~/.config/hypr/hyprland.conf
```

**Output Analysis**:
```conf
# Omarchy defaults (updated automatically)
source = ~/.local/share/omarchy/default/hypr/autostart.conf
source = ~/.local/share/omarchy/default/hypr/bindings/media.conf
source = ~/.local/share/omarchy/default/hypr/looknfeel.conf
source = ~/.config/omarchy/current/theme/hyprland.conf

# Your customizations (persistent)
source = ~/.config/hypr/monitors.conf
source = ~/.config/hypr/bindings.conf
source = ~/.config/hypr/autostart.conf
```

**Key Insight**: User configs are sourced **after** defaults, so your settings override Omarchy's.

**Investigation 2: Find What a Default Provides**

```bash
# What keybindings does Omarchy provide by default?
cat ~/.local/share/omarchy/default/hypr/bindings/media.conf
```

**Expected Output**:
```conf
# Media control bindings
bindd = , XF86AudioPlay, Play/Pause, exec, playerctl play-pause
bindd = , XF86AudioNext, Next track, exec, playerctl next
bindd = , XF86AudioPrev, Previous track, exec, playerctl previous
bindd = , XF86AudioRaiseVolume, Volume up, exec, swayosd-client --output-volume raise
bindd = , XF86AudioLowerVolume, Volume down, exec, swayosd-client --output-volume lower
bindd = , XF86AudioMute, Mute, exec, swayosd-client --output-volume mute-toggle
```

**Investigation 3: Override a Default Binding**

```bash
# You want Play/Pause to open Spotify instead
nano ~/.config/hypr/bindings.conf

# Add this line:
bindd = , XF86AudioPlay, Open Spotify, exec, omarchy-launch-or-focus spotify

# Reload
hyprctl reload

# Test: Press Play/Pause media key
# → Should now launch Spotify instead of play/pause
```

**Why It Works**: Your `bindings.conf` is sourced after the default media bindings, so your definition replaces Omarchy's.

**Investigation 4: Understand Theme Integration**

```bash
# What does the current theme provide?
ls ~/.config/omarchy/current/theme/
```

**Expected Output**:
```
alacritty.toml
btop.theme
chromium.theme
ghostty.conf
hyprland.conf    ← Colors for window borders
hyprlock.conf    ← Lock screen colors
kitty.conf
mako.ini
neovim.lua
swayosd.css
vscode.json
walker.css
waybar.css
```

```bash
# Inspect theme's Hyprland config
cat ~/.config/omarchy/current/theme/hyprland.conf
```

**Expected Output** (Tokyo Night theme example):
```conf
general {
    col.active_border = rgba(7aa2f7ff)    # Blue borders
    col.inactive_border = rgba(414868ff)  # Gray borders
}

decoration {
    shadow {
        col.shadow = rgba(1a1b26ee)       # Dark shadows
    }
}
```

**Investigation 5: Override Theme Colors**

```bash
# You want orange borders instead of theme colors
nano ~/.config/hypr/looknfeel.conf

# Add at the end:
general {
    col.active_border = rgba(ff6600ff)     # Override: Orange
}

# Reload
hyprctl reload
```

**Now**:
- Theme's blue border color: **ignored**
- Your orange border color: **active**
- All other theme settings: **still applied**

**Investigation 6: Test Config Layering**

```bash
# See effective Hyprland settings
hyprctl getoption general:col.active_border
```

**Expected Output**:
```json
{
    "option": "general:col.active_border",
    "int": 0,
    "float": 0.0,
    "str": "",
    "color": "rgba(ff6600ff)",  ← Your override
    "set": true
}
```

**Investigation 7: Reset vs Manual Edit**

```bash
# What if you reset looknfeel.conf now?
omarchy-refresh-config hypr/looknfeel.conf
```

**Expected Output**:
```
Replaced /home/you/.config/hypr/looknfeel.conf with new Omarchy default.
Saved backup as /home/you/.config/hypr/looknfeel.conf.bak.1753818456.

Changes:
< general {
<     col.active_border = rgba(ff6600ff)
< }
```

**Result**: Your orange override is removed, theme's blue borders return.

**Investigation 8: Make Override Permanent**

```bash
# Restore your orange borders
cp ~/.config/hypr/looknfeel.conf.bak.1753818456 ~/.config/hypr/looknfeel.conf

# Or re-edit manually
echo -e "\ngeneral {\n    col.active_border = rgba(ff6600ff)\n}" >> ~/.config/hypr/looknfeel.conf

# Document why (for future you)
echo "# Custom: Orange borders for better visibility" >> ~/.config/hypr/looknfeel.conf
```

**Why Use This Knowledge**:
- **Surgical customization**: Change only what you need, inherit everything else
- **Update-safe**: Your edits in `~/.config/` survive Omarchy updates
- **Debuggable**: You can trace exactly which file provides each setting
- **Reversible**: Reset defaults file-by-file without losing other customizations

**Pro Tips**:

1. **Document your overrides**:
   ```conf
   # ~/.config/hypr/bindings.conf
   # Custom: Spotify quick-launch (overrides default media binding)
   bindd = , XF86AudioPlay, Open Spotify, exec, omarchy-launch-or-focus spotify
   ```

2. **Use separate files for experiments**:
   ```bash
   # Create experimental config
   touch ~/.config/hypr/experimental.conf

   # Source it in hyprland.conf
   echo "source = ~/.config/hypr/experimental.conf" >> ~/.config/hypr/hyprland.conf

   # Easy to disable later by commenting out the source line
   ```

3. **Compare against defaults regularly**:
   ```bash
   # See all your customizations
   diff -r ~/.local/share/omarchy/config/hypr/ ~/.config/hypr/
   ```

---

## Backup and Restore Strategy

### Automatic Backups

**omarchy-refresh-config** automatically creates backups:

```bash
# Running this:
omarchy-refresh-config hypr/hyprlock.conf

# Creates:
~/.config/hypr/hyprlock.conf.bak.1753817951
```

**Backup Cleanup**: If the file was already using defaults (identical), the backup is automatically deleted to avoid clutter.

### Manual Backup Strategy

**Before Major Changes**:

```bash
# Backup entire config directory
tar czf ~/omarchy-config-backup-$(date +%Y-%m-%d).tar.gz ~/.config/
```

**Before Omarchy Update**:

```bash
# Backup just customized configs
tar czf ~/omarchy-customs-$(date +%Y-%m-%d).tar.gz \
  ~/.config/hypr/*.conf \
  ~/.config/waybar/config.jsonc \
  ~/.config/waybar/style.css \
  ~/.config/omarchy/hooks/
```

**Selective File Backup**:

```bash
# Backup one file before experimenting
cp ~/.config/hypr/bindings.conf ~/.config/hypr/bindings.conf.working
```

### Restore Methods

**Restore from omarchy-refresh-config backup**:

```bash
# List available backups
ls ~/.config/hypr/*.bak.*

# Restore specific backup
cp ~/.config/hypr/hyprlock.conf.bak.1753817951 ~/.config/hypr/hyprlock.conf
```

**Restore from manual backup**:

```bash
# Extract full backup
tar xzf ~/omarchy-config-backup-2025-10-21.tar.gz -C ~/

# Or extract just one file
tar xzf ~/omarchy-config-backup-2025-10-21.tar.gz \
  --strip-components=3 \
  -C ~/.config/hypr \
  home/you/.config/hypr/bindings.conf
```

**Nuclear Option - Full Reset**:

```bash
# Back up your current configs first!
mv ~/.config/hypr ~/.config/hypr.OLD

# Copy all defaults
cp -r ~/.local/share/omarchy/config/hypr ~/.config/hypr

# Manually restore your monitors.conf (hardware-specific)
cp ~/.config/hypr.OLD/monitors.conf ~/.config/hypr/monitors.conf

# Reload
hyprctl reload
```

### Backup Schedule Recommendation

**Daily** (automated):
```bash
# Add to crontab or systemd timer
0 2 * * * tar czf ~/backups/omarchy-$(date +%Y-%m-%d).tar.gz ~/.config/
```

**Before updates** (manual):
```bash
omarchy-update
# If prompted, backup first
```

**Before major customizations** (manual):
```bash
cp -r ~/.config/hypr ~/.config/hypr.pre-experiment
```

---

## Troubleshooting

### Config Reset Didn't Fix Issue

**Symptom**: Ran `omarchy-refresh-config` but problem persists

**Possible Causes**:
1. Wrong file was reset
2. Issue is in a different layer (theme, defaults)
3. Application cached old config

**Solutions**:

```bash
# Identify which config file controls the broken setting
hyprctl getoption <setting-name>

# Example: Finding border color source
hyprctl getoption general:col.active_border

# Reset related configs
omarchy-refresh-config hypr/looknfeel.conf
omarchy-refresh-config hypr/hyprland.conf

# Force application reload
hyprctl reload

# Clear application cache (if applicable)
rm -rf ~/.cache/hyprland/
```

---

### Backup File Missing After Reset

**Symptom**: `omarchy-refresh-config` ran but no `.bak` file created

**Cause**: File was identical to default (no changes to back up)

**Verification**:

```bash
# Compare files
diff ~/.config/hypr/hyprlock.conf ~/.local/share/omarchy/config/hypr/hyprlock.conf

# No output = files are identical
```

**This is normal**: Omarchy doesn't create empty backups when files match defaults.

---

### Symlink Broken After Manual Changes

**Symptom**: Theme or background not loading, symlink shows red in `ls -la`

**Verification**:

```bash
ls -la ~/.config/omarchy/current/
```

**Broken symlink appears as**:
```
lrwxrwxrwx theme -> ../themes/deleted-theme  (red, broken)
```

**Fix**:

```bash
# Reset to a known theme
omarchy-theme-set tokyo-night

# Or manually fix
ln -nsf ~/.config/omarchy/themes/catppuccin ~/.config/omarchy/current/theme
```

---

### Config Reset Overwrote Important Customization

**Symptom**: Lost custom keybindings or monitor setup after reset

**Recovery**:

```bash
# Find the backup
ls -lt ~/.config/hypr/*.bak.* | head -5

# Restore from most recent backup
cp ~/.config/hypr/bindings.conf.bak.1753817951 ~/.config/hypr/bindings.conf

# Reload
hyprctl reload
```

**Prevention**: Before resetting user configs (`monitors.conf`, `bindings.conf`), manually backup:

```bash
cp ~/.config/hypr/monitors.conf ~/monitors.conf.safe
omarchy-refresh-config hypr/monitors.conf
# Edit monitors.conf with defaults as reference, then restore your settings
```

---

### Omarchy Update Changed Defaults

**Symptom**: After `omarchy-update`, new features aren't active

**Cause**: Your current configs override new defaults

**Solution**:

```bash
# Read release notes to see what changed
omarchy-version

# Selectively refresh configs to get new features
omarchy-refresh-config hypr/looknfeel.conf

# Compare defaults to see new additions
diff ~/.local/share/omarchy/config/hypr/bindings.conf ~/.config/hypr/bindings.conf
```

**Merge Strategy**:

1. Reset config to see new defaults
2. Manually re-apply your customizations
3. Keep both backup and new config for reference

---

## Best Practices

### Do's

**DO keep separate files for customizations**
- `bindings.conf` for keybindings
- `autostart.conf` for startup apps
- `monitors.conf` for display setup
- Makes selective resets easier

**DO document your customizations**
```conf
# Custom: Use orange borders for visibility
general {
    col.active_border = rgba(ff6600ff)
}
```

**DO create backups before major changes**
```bash
tar czf ~/pre-experiment-$(date +%s).tar.gz ~/.config/hypr/
```

**DO check diffs before resetting**
```bash
diff ~/.config/hypr/hyprlock.conf ~/.local/share/omarchy/config/hypr/hyprlock.conf
```

**DO use version control for important configs**
```bash
cd ~/.config/hypr
git init
git add *.conf
git commit -m "Baseline config"
```

### Don'ts

**DON'T edit default configs directly**
```bash
# ❌ Wrong
nano ~/.local/share/omarchy/config/hypr/hyprland.conf

# ✅ Right
nano ~/.config/hypr/hyprland.conf
```

**DON'T delete backup files immediately**
```bash
# ❌ Don't
rm ~/.config/hypr/*.bak.*

# ✅ Wait a few days, test thoroughly first
```

**DON'T reset hardware-specific configs without backing up**
```bash
# ❌ This will break your monitors!
omarchy-refresh-config hypr/monitors.conf

# ✅ Backup first
cp ~/.config/hypr/monitors.conf ~/monitors.conf.safe
```

**DON'T mix config layers**
```bash
# ❌ Don't put user settings in theme files
nano ~/.config/omarchy/themes/tokyo-night/hyprland.conf

# ✅ Override in user config
nano ~/.config/hypr/looknfeel.conf
```

---

## Related Documentation

### Configuration & Customization
- **Keybindings** (`keybindings.md`) - Customizing Hyprland keybindings
- **Autostart Scripts** (`autostart-scripts.md`) - Managing startup applications
- **Advanced Tweaks** (`advanced-tweaks.md`) - Hooks, custom scripts, environment variables

### System Management
- **System Management** (`../02-core-commands/system-management.md`) - Update and refresh commands
- **Hyprland Integration** (`../04-desktop-environment/hyprland-integration.md`) - Window manager configuration

### Theming
- **Theme System** (`../03-theming/theme-system.md`) - Theme management and symlink system
- **Creating Themes** (`../03-theming/creating-themes.md`) - Building custom themes

### Reference
- **Quick Reference** (`../10-reference/quick-reference.md`) - Common config file locations
- **Troubleshooting** (`../10-reference/troubleshooting.md`) - Config-related issues
- **File Locations** (`../10-reference/script-index.md`) - Complete file path reference

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts Analyzed**:
- `/home/zack/.local/share/omarchy/bin/omarchy-refresh-config`

**Configuration Directories Analyzed**:
- `/home/zack/.local/share/omarchy/config/` (default configs)
- `/home/zack/.config/omarchy/` (current configs)
- `/home/zack/.config/hypr/` (user Hyprland configs)

**Verification**: All commands, file paths, and examples tested on Omarchy system running Hyprland on Arch Linux.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
