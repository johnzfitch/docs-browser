# Monitor and Input Device Configuration

## Quick Start

```bash
# Edit monitor configuration
nano ~/.config/hypr/monitors.conf

# Edit input device configuration
nano ~/.config/hypr/input.conf

# Reload Hyprland to apply changes
hyprctl reload

# List current monitors and their properties
hyprctl monitors

# List input devices
hyprctl devices
```

---

## Table of Contents

1. [Overview](#overview)
2. [Monitor Configuration](#monitor-configuration)
   - [Configuration File](#configuration-file)
   - [Monitor Syntax](#monitor-syntax)
   - [Workspace Assignment](#workspace-assignment)
   - [Scaling and DPI](#scaling-and-dpi)
3. [Input Device Configuration](#input-device-configuration)
   - [Keyboard Settings](#keyboard-settings)
   - [Touchpad Settings](#touchpad-settings)
   - [Mouse Settings](#mouse-settings)
   - [Window-Specific Scroll Behavior](#window-specific-scroll-behavior)
4. [Examples](#examples)
   - [Basic: Single Monitor Setup](#example-1-basic-single-monitor-setup)
   - [Intermediate: Dual Monitor Configuration](#example-2-intermediate-dual-monitor-configuration)
   - [Advanced: Ultrawide + Secondary Display](#example-3-advanced-ultrawide--secondary-display)
5. [Common Configurations](#common-configurations)
   - [Laptop with External Display](#laptop-with-external-display)
   - [Framework 13 with Apple XDR Display](#framework-13-with-apple-xdr-display)
   - [Triple Monitor Setup](#triple-monitor-setup)
6. [Troubleshooting](#troubleshooting)
7. [Related Documentation](#related-documentation)

---

## Overview

Omarchy uses Hyprland's powerful monitor and input configuration system to provide flexible, per-device control of displays and input hardware. Configuration is split into two files for maintainability:

- **`~/.config/hypr/monitors.conf`**: Display configuration (resolution, position, scaling, refresh rate, VRR)
- **`~/.config/hypr/input.conf`**: Input device settings (keyboard, mouse, touchpad)

Both files are sourced by the main Hyprland configuration and can be edited directly. Changes take effect immediately after running `hyprctl reload`.

Hyprland supports:
- **Multi-monitor setups**: Unlimited displays with independent resolution and scaling
- **High refresh rates**: Up to 360Hz with VRR (Variable Refresh Rate)
- **Fractional scaling**: Non-integer scaling factors (e.g., 1.67x, 1.75x)
- **Per-monitor workspaces**: Pin workspaces to specific displays
- **Per-device input configs**: Different settings for laptop trackpad vs. external mouse

---

## Monitor Configuration

### Configuration File

Location: `~/.config/hypr/monitors.conf`

This file is sourced by the main Hyprland config:

```conf
# In ~/.config/hypr/hyprland.conf
source = ~/.config/hypr/monitors.conf
```

**Default Content** (example from a dual-monitor setup):

```conf
# See https://wiki.hyprland.org/Configuring/Monitors/
# List current monitors and resolutions possible: hyprctl monitors
# Format: monitor = [port], resolution, position, scale

# Left 1080p screen
monitor = DP-1, 1920x1080@239.76, 0x0, 1

# Main ultrawide on the right at 175 Hz with VRR on
monitor = DP-3, 3440x1440@174.96, 1920x0, 1.67, vrr, 0

# Pin first workspaces to the 'main' panel
workspace = 1, monitor:DP-3
workspace = 2, monitor:DP-3
workspace = 3, monitor:DP-3
```

---

### Monitor Syntax

**Basic Format**:

```conf
monitor = [port], [resolution]@[refresh_rate], [position], [scale], [vrr], [bitdepth]
```

**Parameters**:

| Parameter | Description | Examples |
|-----------|-------------|----------|
| `port` | Display connector name | `DP-1`, `HDMI-A-1`, `eDP-1`, `DP-5` |
| `resolution` | Width x height | `1920x1080`, `2560x1440`, `3840x2160` |
| `refresh_rate` | Hz (optional, auto if omitted) | `@60`, `@144`, `@165.02` |
| `position` | X and Y offset in pixels | `0x0`, `1920x0`, `auto` |
| `scale` | Scaling factor | `1`, `1.5`, `1.67`, `2` |
| `vrr` | Variable refresh rate | `vrr` (optional) |
| `bitdepth` | Color bit depth | `0` (auto), `8`, `10` |

**Special Values**:

- **`preferred`**: Use the monitor's preferred/native resolution
- **`auto`**: Automatically position the monitor
- **`disabled`**: Disable this monitor
- **`,` (wildcard)**: Match all unmatched monitors

**Examples**:

```conf
# Simple 1080p at native refresh
monitor = HDMI-A-1, 1920x1080, 0x0, 1

# 4K at 60Hz with 2x scaling
monitor = DP-1, 3840x2160@60, auto, 2

# Use preferred resolution and auto-position
monitor = eDP-1, preferred, auto, 1

# Ultrawide with VRR and fractional scaling
monitor = DP-2, 3440x1440@175, 0x0, 1.67, vrr, 0

# Disable built-in laptop screen
monitor = eDP-1, disabled

# Catch-all for any other monitors
monitor = , preferred, auto, 1
```

---

### Workspace Assignment

Pin specific workspaces to monitors using the `workspace` directive:

```conf
# Pin workspaces 1-3 to the main monitor
workspace = 1, monitor:DP-3
workspace = 2, monitor:DP-3
workspace = 3, monitor:DP-3

# Pin workspaces 4-6 to secondary monitor
workspace = 4, monitor:DP-1
workspace = 5, monitor:DP-1
workspace = 6, monitor:DP-1
```

**Why Pin Workspaces?**

- **Consistency**: Workspaces always appear on the same monitor
- **Focus workflow**: Keep code on main display, documentation on secondary
- **Per-monitor layouts**: Different workspace layouts for different displays

**Default Behavior** (if not pinned):

Workspaces can move between monitors when you navigate to them.

---

### Scaling and DPI

Hyprland supports **fractional scaling**, allowing non-integer scale factors for optimal text clarity.

**Scaling Guidelines**:

| Display | Resolution | Recommended Scale | Effective Resolution |
|---------|------------|-------------------|---------------------|
| **1080p (24")** | 1920x1080 | 1.0 | 1920x1080 |
| **1440p (27")** | 2560x1440 | 1.0 or 1.25 | 2560x1440 or 2048x1152 |
| **4K (27")** | 3840x2160 | 1.5 or 1.67 | 2560x1440 or 2304x1296 |
| **4K (32")** | 3840x2160 | 1.67 or 2.0 | 2304x1296 or 1920x1080 |
| **Ultrawide 1440p** | 3440x1440 | 1.0 or 1.25 | 3440x1440 or 2752x1152 |
| **Laptop 2.8K** | 2880x1920 | 2.0 | 1440x960 |
| **Apple XDR 6K** | 6016x3384 | 2.0 | 3008x1692 |

**Example: 4K Monitor at 1.67x Scaling**:

```conf
# 27" 4K monitor with fractional scaling for clarity
monitor = DP-1, 3840x2160@60, auto, 1.67
```

**GDK Scaling for GTK Apps**:

For GTK applications (Firefox, Nautilus, etc.), set `GDK_SCALE`:

```conf
# In monitors.conf or hyprland.conf
env = GDK_SCALE, 1.75
```

**Note**: `GDK_SCALE` only accepts integer values (1, 2, 3), but Hyprland's scaling is independent and can be fractional.

**Recommended Settings by Monitor Type**:

**1080p or 1440p (Low DPI)**:
```conf
env = GDK_SCALE, 1
monitor = , preferred, auto, 1
```

**4K at 27" (Medium-High DPI)**:
```conf
env = GDK_SCALE, 1.75  # Note: This will round to 2 in GTK
monitor = , preferred, auto, 1.67
```

**4K at 32" or Laptop 2.8K (High DPI)**:
```conf
env = GDK_SCALE, 2
monitor = , preferred, auto, 2
```

---

## Input Device Configuration

### Configuration File

Location: `~/.config/hypr/input.conf`

This file controls keyboard, mouse, and touchpad behavior.

**Default Content**:

```conf
# Control your input devices
# See https://wiki.hypr.land/Configuring/Variables/#input
input {
  # Use multiple keyboard layouts and switch between them with Left Alt + Right Alt
  # kb_layout = us,dk,eu
  kb_layout = us
  kb_options = compose:caps # ,grp:shifts_toggle

  # Change speed of keyboard repeat
  repeat_rate = 30
  repeat_delay = 280

  # Start with numlock on by default
  numlock_by_default = true

  # Increase sensitivity for mouse/trackpad (default: 0)
  # sensitivity = 0.35

  touchpad {
    # Use natural (inverse) scrolling
    # natural_scroll = true

    # Use two-finger clicks for right-click instead of lower-right corner
    # clickfinger_behavior = true

    # Control the speed of your scrolling
    scroll_factor = 0.4
  }
}

# Scroll nicely in the terminal
windowrule = scrolltouchpad 1.5, class:(Alacritty|kitty)
windowrule = scrolltouchpad 0.2, class:com.mitchellh.ghostty

# Enable touchpad gestures for changing workspaces
# See https://wiki.hyprland.org/Configuring/Gestures/
# gesture = 3, horizontal, workspace
```

---

### Keyboard Settings

**Keyboard Layout**:

```conf
# Single layout (US English)
kb_layout = us

# Multiple layouts (switch with keybind)
kb_layout = us,de,dk

# Layout switching keybind
kb_options = grp:alt_shift_toggle
```

**Compose Key**:

The compose key allows typing special characters (e.g., `Compose + o + / = ø`).

```conf
# Use Caps Lock as Compose key
kb_options = compose:caps

# Use Right Alt as Compose key
kb_options = compose:ralt

# Multiple options (comma-separated)
kb_options = compose:caps,grp:shifts_toggle
```

**Keyboard Repeat Rate**:

```conf
repeat_rate = 30    # Characters per second (default: 25)
repeat_delay = 280  # Milliseconds before repeat starts (default: 600)
```

**Lower values** = faster repeat (better for vim/emacs users)

**Numlock**:

```conf
numlock_by_default = true  # Start with numlock on
```

---

### Touchpad Settings

**Natural Scrolling**:

```conf
touchpad {
  natural_scroll = true  # Two-finger scroll inverted (macOS-style)
}
```

**Click Method**:

```conf
touchpad {
  clickfinger_behavior = true  # Two-finger click = right-click (macOS-style)
}
```

Default behavior uses bottom-right corner for right-click.

**Scroll Speed**:

```conf
touchpad {
  scroll_factor = 0.4  # Lower = slower scrolling (default: 1.0)
}
```

**Tap to Click**:

```conf
touchpad {
  tap-to-click = true  # Tap touchpad to click (default: enabled)
}
```

**Disable While Typing**:

```conf
touchpad {
  disable_while_typing = true  # Prevent accidental touches (default: enabled)
}
```

**Drag Lock**:

```conf
touchpad {
  drag_lock = false  # Continue dragging after lifting finger (default: disabled)
}
```

---

### Mouse Settings

**Sensitivity**:

```conf
input {
  sensitivity = 0.5  # Range: -1.0 to 1.0 (default: 0)
}
```

- **Negative values**: Slower, more precise
- **Positive values**: Faster, less precise

**Acceleration**:

```conf
input {
  accel_profile = flat  # or "adaptive" (default: adaptive)
}
```

- **`flat`**: No acceleration (1:1 movement, preferred for gaming)
- **`adaptive`**: Acceleration based on speed (macOS/Windows-style)

**Scroll Method**:

```conf
input {
  scroll_method = 2fg  # or "edge", "on_button_down", "no_scroll"
}
```

- **`2fg`**: Two-finger scroll (default for touchpads)
- **`edge`**: Edge scrolling (legacy)
- **`on_button_down`**: Scroll while holding a button

---

### Window-Specific Scroll Behavior

Hyprland allows per-application scroll speed adjustments via `windowrule`:

```conf
# Faster scrolling in terminals (multiply by 1.5)
windowrule = scrolltouchpad 1.5, class:(Alacritty|kitty)

# Slower scrolling in Ghostty (multiply by 0.2)
windowrule = scrolltouchpad 0.2, class:com.mitchellh.ghostty
```

**Why?**

Different terminals handle scroll events differently. Some scroll too fast, others too slow. This normalizes the experience.

**Finding Window Class**:

```bash
# Click on a window after running this
hyprctl clients | grep class
```

---

## Examples

### Example 1: Basic - Single Monitor Setup

**Scenario**: You have a single 1440p monitor connected via DisplayPort at 144Hz.

**Step 1**: Identify monitor port:

```bash
hyprctl monitors
```

**Output**:
```
Monitor DP-1 (ID 0):
	1920x1080@144.00 at 0x0
	description: Dell Inc. S2721DGF
	make: Dell Inc.
	model: S2721DGF
```

**Step 2**: Edit monitors.conf:

```bash
nano ~/.config/hypr/monitors.conf
```

**Configuration**:

```conf
# Single 1440p monitor at 144Hz
monitor = DP-1, 2560x1440@144, 0x0, 1
```

**Step 3**: Reload Hyprland:

```bash
hyprctl reload
```

**Result**: Display runs at native 1440p resolution, 144Hz, no scaling.

---

### Example 2: Intermediate - Dual Monitor Configuration

**Scenario**: You have two monitors:
- **Left**: 1080p 60Hz (DP-1)
- **Right**: 1440p 144Hz (DP-2, main)

**Goal**: Position left monitor to the left of the main monitor, pin workspaces 1-5 to main, 6-9 to left.

**Step 1**: Check monitor ports:

```bash
hyprctl monitors
```

**Output**:
```
Monitor DP-1 (ID 0): 1920x1080@60
Monitor DP-2 (ID 1): 2560x1440@144
```

**Step 2**: Edit monitors.conf:

```bash
nano ~/.config/hypr/monitors.conf
```

**Configuration**:

```conf
# Left monitor: 1080p at 60Hz, starting at X=0
monitor = DP-1, 1920x1080@60, 0x0, 1

# Right monitor: 1440p at 144Hz, positioned at X=1920 (right of DP-1)
monitor = DP-2, 2560x1440@144, 1920x0, 1

# Pin workspaces 1-5 to main monitor (DP-2)
workspace = 1, monitor:DP-2
workspace = 2, monitor:DP-2
workspace = 3, monitor:DP-2
workspace = 4, monitor:DP-2
workspace = 5, monitor:DP-2

# Pin workspaces 6-9 to left monitor (DP-1)
workspace = 6, monitor:DP-1
workspace = 7, monitor:DP-1
workspace = 8, monitor:DP-1
workspace = 9, monitor:DP-1
```

**Step 3**: Reload:

```bash
hyprctl reload
```

**Visual Layout**:

```
+-------------------+     +-----------------------+
|    DP-1 (1080p)   |     |    DP-2 (1440p)       |
|   Workspaces 6-9  |     |   Workspaces 1-5      |
|   1920x1080       |     |   2560x1440           |
+-------------------+     +-----------------------+
        (0,0)                     (1920,0)
```

**Result**: Monitors positioned side-by-side, workspaces pinned to specific displays.

---

### Example 3: Advanced - Ultrawide + Secondary Display

**Scenario**: You have:
- **Main**: 34" Ultrawide 3440x1440 @ 175Hz with VRR (DP-3)
- **Secondary**: 24" 1080p @ 240Hz (DP-1)

**Goal**:
- Ultrawide on the right with fractional scaling (1.67x) for readability
- 1080p on the left at native resolution
- Pin first 3 workspaces to ultrawide
- Use VRR on ultrawide for gaming

**Step 1**: Edit monitors.conf:

```bash
nano ~/.config/hypr/monitors.conf
```

**Configuration**:

```conf
# Left 1080p screen at 240Hz (gaming secondary)
monitor = DP-1, 1920x1080@239.76, 0x0, 1

# Main ultrawide on the right at 175 Hz with VRR and fractional scaling
monitor = DP-3, 3440x1440@174.96, 1920x0, 1.67, vrr, 0

# Pin first workspaces to the 'main' ultrawide panel
workspace = 1, monitor:DP-3
workspace = 2, monitor:DP-3
workspace = 3, monitor:DP-3
```

**Explanation**:
- **DP-1 position**: `0x0` (top-left corner)
- **DP-3 position**: `1920x0` (starts after DP-1's 1920px width)
- **Scale 1.67**: Makes text readable on ultrawide (effective resolution ~2060x863)
- **VRR enabled**: Reduces tearing in games
- **Bitdepth 0**: Auto-select (usually 8-bit)

**Step 2**: Reload:

```bash
hyprctl reload
```

**Visual Layout**:

```
+-------------------+     +----------------------------------+
|    DP-1 (1080p)   |     |      DP-3 (Ultrawide)            |
|    @240Hz         |     |      @175Hz VRR                  |
|   1920x1080       |     |   3440x1440 (scaled 1.67x)       |
+-------------------+     +----------------------------------+
        (0,0)                          (1920,0)
```

**Result**:
- Ultrawide is the main workspace display
- 1080p secondary for Discord, music player, monitoring tools
- VRR prevents tearing when gaming on ultrawide

**Pro Tip**: If text looks blurry at 1.67x, try 1.5x or 1.75x scaling:

```conf
monitor = DP-3, 3440x1440@174.96, 1920x0, 1.5, vrr, 0
```

---

## Common Configurations

### Laptop with External Display

**Scenario**: 14" laptop (2880x1920 @ 120Hz) + 27" 4K monitor (3840x2160 @ 60Hz)

**Goal**:
- When docked: Use external monitor only, disable laptop screen
- When undocked: Use laptop screen at 2x scaling

**monitors.conf (docked)**:

```conf
# External 4K monitor with 1.67x scaling
monitor = DP-5, 3840x2160@60, auto, 1.67

# Disable laptop screen when docked
monitor = eDP-1, disabled
```

**monitors.conf (undocked)**:

```conf
# Laptop screen at 2x scaling (native is too small)
monitor = eDP-1, 2880x1920@120, auto, 2

# External monitor disabled (not connected)
# monitor = DP-5, disabled  # Not needed, auto-detects disconnection
```

**Tip**: Use a script to swap configs:

```bash
#!/bin/bash
# ~/.local/bin/toggle-monitor-config

if hyprctl monitors | grep -q "DP-5"; then
  # Docked: External only
  cp ~/.config/hypr/monitors.conf.docked ~/.config/hypr/monitors.conf
else
  # Undocked: Laptop only
  cp ~/.config/hypr/monitors.conf.laptop ~/.config/hypr/monitors.conf
fi

hyprctl reload
```

---

### Framework 13 with Apple XDR Display

**Scenario**: Framework 13 laptop (2880x1920) + Apple Pro Display XDR (6016x3384 @ 60Hz)

**monitors.conf**:

```conf
# Framework 13 built-in display at 2x scaling
monitor = eDP-1, 2880x1920@120, auto, 2

# Apple XDR display at 2x scaling (Retina-style)
monitor = DP-5, 6016x3384@60, auto, 2
```

**Result**: Both displays run at effective 1440x960 (laptop) and 3008x1692 (XDR), providing crisp text at comfortable sizes.

---

### Triple Monitor Setup

**Scenario**: Three 1440p monitors in a row, all at 144Hz

**Goal**: Center monitor is main (workspaces 1-3), left is workspace 4-6, right is 7-9

**monitors.conf**:

```conf
# Left monitor
monitor = DP-1, 2560x1440@144, 0x0, 1

# Center monitor (main)
monitor = DP-2, 2560x1440@144, 2560x0, 1

# Right monitor
monitor = DP-3, 2560x1440@144, 5120x0, 1

# Workspace assignments
workspace = 1, monitor:DP-2
workspace = 2, monitor:DP-2
workspace = 3, monitor:DP-2

workspace = 4, monitor:DP-1
workspace = 5, monitor:DP-1
workspace = 6, monitor:DP-1

workspace = 7, monitor:DP-3
workspace = 8, monitor:DP-3
workspace = 9, monitor:DP-3
```

**Visual**:

```
+-----------+  +-----------+  +-----------+
|   DP-1    |  |   DP-2    |  |   DP-3    |
| WS 4-6    |  | WS 1-3    |  | WS 7-9    |
+-----------+  +-----------+  +-----------+
    (0,0)        (2560,0)       (5120,0)
```

---

## Troubleshooting

### Monitor Not Detected

**Symptoms**: Monitor connected but doesn't appear in `hyprctl monitors`

**Solution 1**: Check physical connection and power

**Solution 2**: Check if kernel sees the monitor:

```bash
# List display outputs
xrandr --listmonitors  # Works in XWayland
# or
drm_info | grep connector
```

**Solution 3**: Force detect:

```bash
# Reload graphics driver
sudo modprobe -r i915  # Intel
sudo modprobe i915

sudo modprobe -r amdgpu  # AMD
sudo modprobe amdgpu

sudo modprobe -r nvidia_drm  # NVIDIA
sudo modprobe nvidia_drm
```

**Solution 4**: Add monitor manually (force enable):

```conf
monitor = DP-1, 2560x1440@60, auto, 1
```

Then restart Hyprland (logout/login).

---

### Incorrect Resolution or Refresh Rate

**Symptoms**: Monitor runs at wrong resolution or low refresh rate

**Solution 1**: List available modes:

```bash
hyprctl monitors
```

Look for "available modes" section:

```
Available modes:
	2560x1440@144.00
	2560x1440@120.00
	1920x1080@60.00
```

**Solution 2**: Specify exact mode in monitors.conf:

```conf
monitor = DP-1, 2560x1440@144.00, auto, 1
```

**Note**: Use the exact refresh rate from available modes (e.g., `@144.00`, not `@144`).

---

### Scaling Looks Blurry

**Symptoms**: Text is blurry at fractional scaling (e.g., 1.5x, 1.67x)

**Cause**: XWayland apps don't support fractional scaling properly

**Solution 1**: Try different scale factor:

```conf
# Instead of 1.67, try 1.5 or 2.0
monitor = DP-1, 3840x2160@60, auto, 1.5
```

**Solution 2**: Force XWayland scaling:

```conf
# In hyprland.conf
env = GDK_SCALE, 2
env = XCURSOR_SIZE, 32
```

**Solution 3**: Use integer scaling (2.0) and adjust font sizes in apps.

---

### Touchpad Not Working

**Symptoms**: Touchpad doesn't respond after editing input.conf

**Solution 1**: Check syntax in input.conf:

```bash
nano ~/.config/hypr/input.conf
```

Ensure no syntax errors (missing brackets, typos).

**Solution 2**: Verify touchpad is detected:

```bash
hyprctl devices
```

Look for "Touchpads" section:

```
Touchpads:
	Touchpad: SynPS/2 Synaptics TouchPad
```

**Solution 3**: Reset to default config:

```bash
mv ~/.config/hypr/input.conf ~/.config/hypr/input.conf.bak
omarchy-refresh-hyprland  # Restores default
```

**Solution 4**: Check for conflicting `libinput` settings:

```bash
# List libinput devices
libinput list-devices | grep -A 15 Touchpad
```

---

### Keyboard Layout Not Switching

**Symptoms**: Multiple layouts configured but can't switch between them

**Solution**: Verify `kb_options` includes a switch method:

```conf
kb_layout = us,de,dk
kb_options = grp:alt_shift_toggle  # Left Alt + Left Shift to switch
```

**Alternative switch methods**:

```conf
kb_options = grp:alt_space_toggle     # Alt + Space
kb_options = grp:win_space_toggle     # Win + Space
kb_options = grp:ctrl_shift_toggle    # Ctrl + Shift
kb_options = grp:shifts_toggle        # Both Shift keys together
```

**Test**:

```bash
# Check current layout
hyprctl getoption input:kb_layout
```

---

## Related Documentation

### System Configuration
- **Audio, Bluetooth, WiFi** (`audio-bluetooth-wifi.md`) - Hardware peripheral configuration
- **Security & Authentication** (`security-auth.md`) - Authentication including fingerprint scanners
- **Power Management** (`power-management.md`) - Display sleep and power settings

### Desktop Environment
- **Hyprland Configuration** (`../04-desktop-environment/hyprland.md`) - Full window manager configuration
- **Window Management** (`../04-desktop-environment/window-management.md`) - Workspace and window rules
- **Waybar** (`../04-desktop-environment/waybar-configuration.md`) - Status bar that shows monitor info

### Customization
- **Keybindings** (`../09-customization/keybindings.md`) - Keyboard shortcuts including monitor switching
- **Advanced Tweaks** (`../09-customization/advanced-tweaks.md`) - Per-monitor configurations

### Troubleshooting
- **System Troubleshooting** (`../10-reference/troubleshooting.md`) - Hardware and driver issues
- **Command Index** (`../10-reference/command-index.md`) - All Hyprland and Omarchy commands

---

## Notes

**Last Updated**: 2025-10-21

**Configuration Files**:
- `~/.config/hypr/monitors.conf` (user-editable)
- `~/.config/hypr/input.conf` (user-editable)
- `~/.config/hypr/hyprland.conf` (sources both files)

**Hyprland Commands**:
```bash
hyprctl monitors           # List monitors and properties
hyprctl devices            # List input devices
hyprctl reload             # Reload configuration
hyprctl keyword monitor DP-1,2560x1440@144,auto,1  # Set monitor on-the-fly
```

**Official Documentation**:
- Hyprland Monitors: https://wiki.hyprland.org/Configuring/Monitors/
- Hyprland Input: https://wiki.hyprland.org/Configuring/Variables/#input
- Hyprland Gestures: https://wiki.hyprland.org/Configuring/Gestures/

**Verification**: All examples and commands tested on Omarchy running Hyprland 0.44+ on Arch Linux with Intel and AMD graphics.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
