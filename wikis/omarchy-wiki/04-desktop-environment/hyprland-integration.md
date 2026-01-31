# Hyprland Integration

## Quick Start

```bash
# Refresh Hyprland configuration
omarchy-refresh-hyprland

# Reload Hyprland configuration
hyprctl reload

# View active Hyprland configuration
cat ~/.config/hypr/hyprland.conf

# See all window rules
hyprctl clients
```

---

## Table of Contents

1. [Overview](#overview)
2. [Configuration Structure](#configuration-structure)
3. [Default vs User Configs](#default-vs-user-configs)
4. [Commands Reference](#commands-reference)
5. [Examples](#examples)
   - [Basic: Understanding the Configuration](#example-1-basic-understanding-the-configuration)
   - [Intermediate: Adding Custom Window Rules](#example-2-intermediate-adding-custom-window-rules)
   - [Advanced: Override Default Settings](#example-3-advanced-override-default-settings)
6. [Key Hyprland Features Omarchy Uses](#key-hyprland-features-omarchy-uses)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)
9. [Related Documentation](#related-documentation)

---

## Overview

Hyprland is the Wayland compositor that powers the Omarchy desktop environment. Omarchy provides a carefully curated Hyprland configuration with sensible defaults, window rules for common applications, and a clean separation between system defaults and user customizations.

The integration follows a layered approach: Omarchy provides default configurations that work out of the box, while allowing users to override any setting in their personal config files. This design ensures that Omarchy updates don't overwrite your customizations while still giving you access to improved defaults.

Hyprland configuration in Omarchy is split across multiple files for maintainability. The main configuration file (`~/.config/hypr/hyprland.conf`) sources both default Omarchy configs and your personal overrides, creating a flexible system that scales from beginner to advanced users.

---

## Configuration Structure

### Directory Layout

```
~/.config/hypr/                          # Your personal Hyprland configs
├── hyprland.conf                        # Main config (sources everything)
├── monitors.conf                        # Monitor configuration
├── input.conf                           # Input devices (keyboard, mouse, touchpad)
├── bindings.conf                        # Custom keybindings
├── envs.conf                            # Environment variables
├── looknfeel.conf                       # Appearance settings
├── autostart.conf                       # Apps to launch at startup
└── scripts/                             # Custom scripts

~/.local/share/omarchy/default/hypr/     # Omarchy default configs (don't edit!)
├── autostart.conf                       # Default startup programs
├── envs.conf                            # Default environment variables
├── input.conf                           # Default input configuration
├── looknfeel.conf                       # Default appearance settings
├── windows.conf                         # Default window rules
├── bindings/                            # Default keybindings
│   ├── tiling-v2.conf                   # Window management bindings
│   ├── utilities.conf                   # Utility shortcuts
│   ├── media.conf                       # Media controls
│   └── clipboard.conf                   # Clipboard bindings
└── apps/                                # Per-app window rules
    ├── browser.conf                     # Browser-specific rules
    ├── terminals.conf                   # Terminal window rules
    ├── steam.conf                       # Steam window rules
    ├── jetbrains.conf                   # JetBrains IDE rules
    └── pip.conf                         # Picture-in-picture rules

~/.config/omarchy/current/theme/         # Active theme (symlink)
└── hyprland.conf                        # Theme-specific Hyprland settings
```

### Main Configuration File

The main `~/.config/hypr/hyprland.conf` file orchestrates the loading order:

```conf
# 1. Load Omarchy defaults first
source = ~/.local/share/omarchy/default/hypr/autostart.conf
source = ~/.local/share/omarchy/default/hypr/bindings/media.conf
source = ~/.local/share/omarchy/default/hypr/bindings/clipboard.conf
source = ~/.local/share/omarchy/default/hypr/bindings/tiling-v2.conf
source = ~/.local/share/omarchy/default/hypr/bindings/utilities.conf
source = ~/.local/share/omarchy/default/hypr/envs.conf
source = ~/.local/share/omarchy/default/hypr/looknfeel.conf
source = ~/.local/share/omarchy/default/hypr/input.conf
source = ~/.local/share/omarchy/default/hypr/windows.conf
source = ~/.config/omarchy/current/theme/hyprland.conf

# 2. Load user overrides (these take precedence!)
source = ~/.config/hypr/monitors.conf
source = ~/.config/hypr/input.conf
source = ~/.config/hypr/bindings.conf
source = ~/.config/hypr/envs.conf
source = ~/.config/hypr/looknfeel.conf
source = ~/.config/hypr/autostart.conf

# 3. Add custom configuration below
```

User configs are loaded **after** defaults, so they override any conflicting settings.

---

## Default vs User Configs

### Default Configs (Read-Only)

Located in `~/.local/share/omarchy/default/hypr/`, these files are managed by Omarchy and should **not** be edited directly. They will be overwritten during Omarchy updates.

**What defaults provide:**
- Window rules for 30+ common applications
- Optimized input configuration (keyboard, mouse, touchpad)
- Complete keybinding scheme for window management
- Media keys and clipboard integration
- Startup services (Waybar, notifications, etc.)
- Sensible appearance defaults (borders, gaps, animations)

### User Configs (Your Customizations)

Located in `~/.config/hypr/`, these are **your** files. Edit them freely - they will never be overwritten by Omarchy.

**Common customizations:**
- **monitors.conf** - Monitor layout, resolution, refresh rate
- **input.conf** - Keyboard layout, mouse sensitivity, touchpad gestures
- **bindings.conf** - Application launchers, custom shortcuts
- **envs.conf** - Environment variables (NVIDIA settings, etc.)
- **looknfeel.conf** - Gaps, borders, animation speeds
- **autostart.conf** - Personal startup applications

### The Override Pattern

Because user configs are sourced after defaults, any setting you define in your personal files will override the default:

```conf
# In ~/.local/share/omarchy/default/hypr/looknfeel.conf (default)
general {
    gaps_in = 4
    gaps_out = 8
}

# In ~/.config/hypr/looknfeel.conf (your override)
general {
    gaps_in = 10    # This value takes precedence
    gaps_out = 20   # This value takes precedence
}
```

---

## Commands Reference

### omarchy-refresh-hyprland

Refreshes your personal Hyprland configuration files from templates. This is safe to run - it only creates files that don't exist and won't overwrite your customizations.

```bash
# Refresh config files (creates missing files only)
omarchy-refresh-hyprland
```

**What it does:**
- Ensures all personal config files exist in `~/.config/hypr/`
- Creates files from templates if they're missing
- Does **not** overwrite existing files
- Safe to run after Omarchy updates

**When to use:**
- After fresh installation
- After Omarchy adds new config files
- When you accidentally delete a config file

### Other Useful Commands

```bash
# Reload Hyprland configuration without restarting
hyprctl reload

# View all active window rules
hyprctl clients

# List active monitors
hyprctl monitors

# List all keybindings
hyprctl binds

# View current Hyprland configuration
hyprctl getoption all

# Close specific window by address
hyprctl dispatch closewindow address:0x...

# Move window to workspace
hyprctl dispatch movetoworkspace 3
```

---

## Examples

### Example 1: Basic - Understanding the Configuration

**Scenario:** You want to understand how Hyprland is configured in Omarchy.

**Solution:**

```bash
# 1. View your main configuration file
cat ~/.config/hypr/hyprland.conf

# 2. See what keybindings are active
hyprctl binds | grep -i "super"

# 3. Check window rules for your current windows
hyprctl clients

# 4. View monitor configuration
cat ~/.config/hypr/monitors.conf
```

**What this teaches:**
- The main config sources multiple files
- Defaults come from Omarchy, customizations from your files
- You can inspect active configuration using hyprctl

---

### Example 2: Intermediate - Adding Custom Window Rules

**Scenario:** You want Firefox to always open on workspace 2, floating, at 80% size.

**Solution:**

Add to `~/.config/hypr/hyprland.conf` (at the bottom):

```conf
# Custom Firefox rules
windowrulev2 = workspace 2, class:^(firefox)$
windowrulev2 = float, class:^(firefox)$
windowrulev2 = size 80% 80%, class:^(firefox)$
windowrulev2 = center, class:^(firefox)$
```

Then reload:

```bash
hyprctl reload
```

**Window Rule Parameters:**
- `workspace N` - Open on specific workspace
- `float` - Make window floating
- `tile` - Force window to tile
- `size W H` - Set window size (pixels or %)
- `center` - Center window on screen
- `opacity VALUE INACTIVE_VALUE` - Set window transparency
- `animation STYLE` - Custom animation (popin, slide, fade)
- `fullscreen` - Start in fullscreen
- `pin` - Pin window (visible on all workspaces)
- `nofocus` - Don't focus when opened

**Finding window class:**

```bash
# Click on a window to see its class
hyprctl clients | grep -A10 "class:"
```

---

### Example 3: Advanced - Override Default Settings

**Scenario:** You want different animation speeds and larger gaps than Omarchy defaults.

**Solution:**

Edit `~/.config/hypr/looknfeel.conf`:

```conf
# Override gaps
general {
    gaps_in = 12
    gaps_out = 24
    border_size = 3
}

# Override animation speeds
animations {
    enabled = true
    bezier = myBezier, 0.05, 0.9, 0.1, 1.0

    animation = windows, 1, 4, myBezier
    animation = windowsOut, 1, 4, default, popin 80%
    animation = fade, 1, 5, default
    animation = workspaces, 1, 4, default
}
```

**Reload configuration:**

```bash
hyprctl reload
```

**What this demonstrates:**
- User config files override defaults completely
- You can redefine entire sections
- Changes take effect immediately with `hyprctl reload`

**Common appearance overrides:**

```conf
# In ~/.config/hypr/looknfeel.conf

general {
    gaps_in = 5              # Inner gaps between windows
    gaps_out = 10            # Outer gaps to screen edges
    border_size = 2          # Window border thickness
    col.active_border = rgb(8aadf4)   # Active border color
    col.inactive_border = rgb(24273a) # Inactive border color
}

decoration {
    rounding = 8             # Corner radius
    blur {
        enabled = true
        size = 5
        passes = 2
    }
    drop_shadow = true
    shadow_range = 20
}
```

---

## Key Hyprland Features Omarchy Uses

### 1. Dynamic Tiling

Omarchy uses Hyprland's **dwindle** layout with intelligent window management:

- **Automatic tiling** - Windows tile automatically
- **Manual splits** - `Super + J` to toggle split direction
- **Pseudo-tiling** - `Super + P` for master-stack layout
- **Floating mode** - `Super + T` to toggle floating

### 2. Window Rules (windowrulev2)

Omarchy ships with rules for 30+ applications in `~/.local/share/omarchy/default/hypr/apps/`:

**Browser rules** (`apps/browser.conf`):
```conf
# Force browsers to tile and adjust opacity
windowrule = tile, tag:chromium-based-browser
windowrule = opacity 1 0.97, tag:chromium-based-browser
```

**Picture-in-Picture** (`apps/pip.conf`):
```conf
windowrule = float, tag:pip
windowrule = pin, tag:pip
windowrule = size 600 338, tag:pip
windowrule = move 100%-w-40 4%, tag:pip
```

**Steam** (`apps/steam.conf`):
```conf
windowrule = float, class:steam
windowrule = center, class:steam, title:Steam
windowrule = size 1100 700, class:steam, title:Steam
```

### 3. Workspace Management

Omarchy configures 10 persistent workspaces with intelligent switching:

**Keybindings:**
- `Super + [1-9,0]` - Switch to workspace
- `Super + Shift + [1-9,0]` - Move window to workspace
- `Super + Tab` - Next workspace
- `Super + Shift + Tab` - Previous workspace
- `Super + Ctrl + Tab` - Last workspace

**Workspace features:**
- Windows remember their workspaces
- Empty workspaces stay available
- Waybar shows workspace status
- Per-monitor workspace support

### 4. Submaps (Modal Keybindings)

Omarchy uses submaps for complex operations like screenshots:

```conf
# Ctrl + ` enters capture mode
bind = CTRL, GRAVE, exec, hyprctl dispatch submap capture

submap = capture
  bind = , R, exec, omarchy-cmd-screenshot region  # Region
  bind = , W, exec, omarchy-cmd-screenshot window  # Window
  bind = , F, exec, omarchy-cmd-screenshot fullscreen # Full
  bind = , ESCAPE, submap, reset  # Cancel
submap = reset
```

**Usage:**
1. Press `Ctrl + \``
2. Get notification: "Capture Mode - press R, W, or F"
3. Press `R` for region, `W` for window, or `F` for fullscreen
4. Screenshot captured and copied to clipboard

### 5. Window Grouping

Group windows together in tabs:

- `Super + G` - Create/toggle group
- `Super + Alt + G` - Remove from group
- `Super + Alt + Arrow` - Add window to adjacent group
- `Super + Alt + Tab` - Cycle through grouped windows

### 6. Dispatcher Integration

Omarchy scripts use Hyprland dispatchers extensively:

```bash
# Close all windows (omarchy-cmd-close-all-windows)
hyprctl clients -j | jq -r ".[].address" | \
  xargs -I{} hyprctl dispatch closewindow address:{}

# Move to workspace 1
hyprctl dispatch workspace 1

# Focus window by direction
hyprctl dispatch movefocus l  # left

# Toggle floating
hyprctl dispatch togglefloating
```

---

## Troubleshooting

### Configuration Not Loading

**Problem:** Changes to config files don't take effect.

**Solutions:**

```bash
# 1. Reload Hyprland
hyprctl reload

# 2. Check for syntax errors
cat ~/.config/hypr/hyprland.conf

# 3. View Hyprland logs
journalctl --user -u hyprland.service -n 50

# 4. Test specific setting
hyprctl getoption general:gaps_in
```

### Window Rules Not Working

**Problem:** Custom window rules don't apply to applications.

**Solutions:**

```bash
# 1. Find the correct window class
hyprctl clients | grep -B2 -A8 "YourApp"

# 2. Check if rule is loaded
hyprctl clients

# 3. Use windowrulev2 (more flexible)
windowrulev2 = float, class:^(yourapp)$, title:^(Window Title)$

# 4. Reload after changes
hyprctl reload
```

### Keybindings Conflict

**Problem:** Custom keybinding doesn't work.

**Solutions:**

```bash
# 1. Check if binding is registered
hyprctl binds | grep "SUPER"

# 2. User bindings override defaults (make sure yours are loaded last)
# Edit ~/.config/hypr/bindings.conf

# 3. Use different modifier
# Instead of: bind = SUPER, T, ...
# Try: bind = SUPER SHIFT, T, ...
```

### Performance Issues

**Problem:** Animations are laggy or system feels slow.

**Solutions:**

Edit `~/.config/hypr/looknfeel.conf`:

```conf
# Reduce animation complexity
animations {
    enabled = true
    animation = windows, 1, 3, default     # Faster
    animation = workspaces, 1, 2, default  # Much faster
}

# Reduce blur
decoration {
    blur {
        enabled = false  # Disable for performance
    }
}

# Reduce shadow rendering
decoration {
    drop_shadow = false
}
```

---

## Best Practices

### 1. Never Edit Default Configs

**Don't do this:**
```bash
# BAD - will be overwritten by updates!
nvim ~/.local/share/omarchy/default/hypr/looknfeel.conf
```

**Do this instead:**
```bash
# GOOD - your personal config
nvim ~/.config/hypr/looknfeel.conf
```

### 2. Use Specific Window Rules

**Prefer:**
```conf
# Specific match
windowrulev2 = float, class:^(firefox)$, title:^(Picture-in-Picture)$
```

**Over:**
```conf
# Too broad - matches everything
windowrulev2 = float, class:.*
```

### 3. Test Changes Incrementally

```bash
# 1. Make small change
nvim ~/.config/hypr/looknfeel.conf

# 2. Reload immediately
hyprctl reload

# 3. Test the change

# 4. If broken, revert and reload again
```

### 4. Document Your Customizations

```conf
# In ~/.config/hypr/hyprland.conf

# Custom Firefox setup for development workflow
# Opens on workspace 2, 80% size, centered
windowrulev2 = workspace 2, class:^(firefox)$
windowrulev2 = size 80% 80%, class:^(firefox)$
windowrulev2 = center, class:^(firefox)$
```

### 5. Use Comments Liberally

```conf
# === MONITORS ===
# Main display: 2560x1440@144Hz
monitor = DP-1, 2560x1440@144, 0x0, 1

# Secondary: 1920x1080@60Hz, portrait mode
monitor = HDMI-A-1, 1920x1080@60, 2560x0, 1, transform, 1
```

### 6. Keep Backups

```bash
# Before major changes
cp ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.backup

# Restore if needed
mv ~/.config/hypr/hyprland.conf.backup ~/.config/hypr/hyprland.conf
```

---

## Related Documentation

### Omarchy Documentation
- [Theme System](/home/zack/dev/lib/omarchy-archive/03-theming/theme-system.md) - How themes integrate with Hyprland
- [Waybar Configuration](/home/zack/dev/lib/omarchy-archive/04-desktop-environment/waybar-configuration.md) - Status bar setup
- [Window Management](/home/zack/dev/lib/omarchy-archive/04-desktop-environment/window-management.md) - Tiling and workspace workflows
- [Walker Launcher](/home/zack/dev/lib/omarchy-archive/04-desktop-environment/walker-elephant.md) - Application launcher

### Hyprland Archive
For comprehensive Hyprland documentation, see the Hyprland Archive at:
**`/home/zack/dev/lib/hyprland-archive/`**

Key references:
- Configuration guide
- Window rules reference
- Dispatcher documentation
- Animation system
- Plugin development

### External Resources
- [Hyprland Wiki](https://wiki.hyprland.org/) - Official documentation
- [Hyprland GitHub](https://github.com/hyprwm/Hyprland) - Source code and issues

---

**Last Updated:** 2025-10-21
**Omarchy Version:** Latest
