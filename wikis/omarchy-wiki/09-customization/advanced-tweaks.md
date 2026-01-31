# Advanced Tweaks

## Quick Start

```bash
# Create a custom hook
nano ~/.config/omarchy/hooks/theme-set

# Make it executable
chmod +x ~/.config/omarchy/hooks/theme-set

# Set environment variables
nano ~/.config/hypr/envs.conf

# Create custom scripts
mkdir -p ~/.local/bin/
nano ~/.local/bin/my-script.sh
chmod +x ~/.local/bin/my-script.sh

# Reload Hyprland to apply changes
hyprctl reload
```

---

## Table of Contents

1. [Overview](#overview)
2. [omarchy-hook System](#omarchy-hook-system)
3. [Custom Scripts](#custom-scripts)
4. [Environment Variables](#environment-variables)
5. [Advanced Hyprland Configuration](#advanced-hyprland-configuration)
6. [Performance Tuning](#performance-tuning)
7. [Examples](#examples)
   - [Basic: Theme Change Notification Hook](#example-1-basic-theme-change-notification-hook)
   - [Intermediate: Custom Script for Workspace Setup](#example-2-intermediate-custom-script-for-workspace-setup)
   - [Advanced: Performance Optimization Pipeline](#example-3-advanced-performance-optimization-pipeline)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Related Documentation](#related-documentation)

---

## Overview

Omarchy provides advanced customization mechanisms for power users who need precise control over their desktop environment. These tools enable deep integration with Omarchy's internal systems while maintaining upgrade safety and modularity.

The advanced customization system consists of:

1. **omarchy-hook** - Event-driven script execution (theme changes, updates, etc.)
2. **Custom Scripts** - User-defined automation in `~/.local/bin/`
3. **Environment Variables** - Session-wide configuration via Hyprland
4. **Advanced Hyprland Config** - Window rules, animations, performance tuning
5. **Performance Optimization** - Reducing latency, optimizing rendering

These tools integrate seamlessly with Omarchy's architecture, allowing you to extend functionality without modifying core components. Hooks fire at specific lifecycle events, custom scripts integrate with keybindings and autostart, environment variables configure application behavior, and Hyprland tweaks optimize the window manager itself.

---

## omarchy-hook System

### What Are Hooks?

Hooks are custom bash scripts that execute automatically when specific Omarchy events occur. They enable you to extend Omarchy's behavior without modifying core scripts.

### Hook Script

**Location**: `/home/zack/.local/share/omarchy/bin/omarchy-hook`

**Source Code**:
```bash
#!/bin/bash

if [[ $# -lt 1 ]]; then
  echo "Usage: omarchy-hook [name] [args...]"
  exit 1
fi

HOOK=$1
HOOK_PATH="$HOME/.config/omarchy/hooks/$1"
shift

if [[ -f $HOOK_PATH ]]; then
  bash "$HOOK_PATH" "$@"
fi
```

**How It Works**:
1. Takes hook name as first argument
2. Looks for script at `~/.config/omarchy/hooks/<name>`
3. If script exists, executes it with remaining arguments
4. If script doesn't exist, silently does nothing

### Available Hooks

**theme-set**:
- **Trigger**: After theme is changed via `omarchy-theme-set`
- **Arguments**: `$1` = new theme name (snake-case, e.g., `tokyo_night`)
- **Use Cases**: Custom notifications, update external apps, sync to other machines

**post-update**:
- **Trigger**: After Omarchy system update completes
- **Arguments**: None
- **Use Cases**: Restart services, rebuild cache, notify user

**font-set**:
- **Trigger**: After system font is changed via `omarchy-font-set`
- **Arguments**: `$1` = new font name
- **Use Cases**: Update non-standard applications, regenerate font cache

### Hook Directory

```
~/.config/omarchy/hooks/
├── theme-set.sample       # Example theme hook
├── post-update.sample     # Example update hook
├── font-set.sample        # Example font hook
├── theme-set              # Your custom theme hook (active)
├── post-update            # Your custom update hook (active)
└── my-custom-hook         # Any other custom hooks
```

**Sample Files**: Omarchy provides `.sample` files as templates. Remove `.sample` extension to activate.

### Creating a Hook

**Step 1: Create hook script**
```bash
nano ~/.config/omarchy/hooks/theme-set
```

**Step 2: Add shebang and script content**
```bash
#!/bin/bash

# Hook receives theme name as $1
THEME="$1"

# Your custom actions here
notify-send "Theme Changed" "New theme: $THEME"
```

**Step 3: Make executable**
```bash
chmod +x ~/.config/omarchy/hooks/theme-set
```

**Step 4: Test**
```bash
# Change theme to trigger hook
omarchy-theme-set catppuccin

# Or test directly
omarchy-hook theme-set catppuccin
```

### Hook Arguments

**theme-set**:
```bash
# Called by omarchy-theme-set with snake_case theme name
omarchy-hook theme-set tokyo_night
```

**Hook receives**:
```bash
$1 = "tokyo_night"
```

**post-update**:
```bash
# Called by omarchy-update with no arguments
omarchy-hook post-update
```

**Hook receives**: No arguments

**font-set**:
```bash
# Called by omarchy-font-set with font name
omarchy-hook font-set "JetBrains Mono"
```

**Hook receives**:
```bash
$1 = "JetBrains Mono"
```

### Hook Examples

**theme-set.sample**:
```bash
#!/bin/bash

# This hook is called with the snake-cased name of the theme that has just been set.
# To put it into use, remove .sample from the name.

# Example: Show the name of the theme that was just set.
# notify-send "New theme" "Your new theme is $1"
```

**Custom theme-set hook**:
```bash
#!/bin/bash

THEME="$1"
THEME_PRETTY=$(echo "$THEME" | sed 's/_/ /g' | sed 's/\b\(.\)/\u\1/g')

# Send notification with preview
notify-send "Theme Changed" "$THEME_PRETTY" \
  -i "$HOME/.config/omarchy/themes/$THEME/preview.png" \
  -t 5000

# Log theme change
echo "$(date): Changed theme to $THEME" >> "$HOME/.cache/omarchy/theme-history.log"

# Sync to other machines (optional)
# ssh other-machine "omarchy-theme-set $THEME"
```

### Hook Best Practices

**DO keep hooks fast** - They block the calling command
```bash
# ✅ Run slow tasks in background
notify-send "Theme set" "$1" &
```

**DO handle errors gracefully**
```bash
# ✅ Check if command exists
if command -v my-command >/dev/null 2>&1; then
    my-command "$1"
fi
```

**DO use absolute paths**
```bash
# ✅ Explicit path
"$HOME/.config/omarchy/themes/$1/preview.png"

# ❌ Relative path (unreliable)
../themes/$1/preview.png
```

**DON'T run interactive commands** - Hooks are non-interactive
```bash
# ❌ Don't prompt for input
read -p "Continue? " answer

# ✅ Use flags or config files
if [ -f "$HOME/.config/omarchy/auto-confirm" ]; then
    # auto-confirmed action
fi
```

---

## Custom Scripts

### Script Location

User scripts belong in:
```
~/.local/bin/
```

This directory should be in your `$PATH` (Omarchy adds it by default).

### Creating a Custom Script

**Step 1: Create script file**
```bash
nano ~/.local/bin/my-script.sh
```

**Step 2: Add shebang and content**
```bash
#!/bin/bash

# Script description
# Usage: my-script.sh [options]

# Your script logic
echo "Hello from custom script"
```

**Step 3: Make executable**
```bash
chmod +x ~/.local/bin/my-script.sh
```

**Step 4: Test**
```bash
my-script.sh
```

**Step 5: Integrate with Omarchy**

**Keybinding**:
```conf
# ~/.config/hypr/bindings.conf
bindd = SUPER CTRL, X, My custom script, exec, my-script.sh
```

**Autostart**:
```conf
# ~/.config/hypr/autostart.conf
exec-once = my-script.sh
```

**Hook**:
```bash
# ~/.config/omarchy/hooks/theme-set
#!/bin/bash
my-script.sh "$1"
```

### Script Templates

**Notification Script**:
```bash
#!/bin/bash
# ~/.local/bin/notify-battery.sh

BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status)

if [ "$BATTERY" -lt 20 ] && [ "$STATUS" != "Charging" ]; then
    notify-send "Low Battery" "$BATTERY% remaining" -u critical
fi
```

**Workspace Setup Script**:
```bash
#!/bin/bash
# ~/.local/bin/dev-workspace.sh

# Open terminal on workspace 1
hyprctl dispatch workspace 1
uwsm-app -- $TERMINAL -e tmux new-session -A -s dev &

# Open browser on workspace 2
hyprctl dispatch workspace 2
omarchy-launch-browser "http://localhost:3000" &

# Open editor on workspace 3
hyprctl dispatch workspace 3
code ~/dev/my-project &

# Return to workspace 1
hyprctl dispatch workspace 1
```

**Backup Script**:
```bash
#!/bin/bash
# ~/.local/bin/backup-configs.sh

BACKUP_DIR="$HOME/Backups/configs-$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

# Backup important configs
tar czf "$BACKUP_DIR/hypr.tar.gz" ~/.config/hypr/
tar czf "$BACKUP_DIR/omarchy.tar.gz" ~/.config/omarchy/
tar czf "$BACKUP_DIR/waybar.tar.gz" ~/.config/waybar/

notify-send "Backup Complete" "Configs saved to $BACKUP_DIR"
```

### Integrating with Omarchy Commands

**Wrapper Script** (extends Omarchy command):
```bash
#!/bin/bash
# ~/.local/bin/omarchy-theme-set-with-notify.sh

# Call original Omarchy command
omarchy-theme-set "$1"

# Add custom behavior
THEME_PRETTY=$(omarchy-theme-current)
notify-send "Theme Changed" "Now using $THEME_PRETTY" \
  -i "$HOME/.config/omarchy/current/theme/preview.png"

# Log change
echo "$(date): $THEME_PRETTY" >> "$HOME/.cache/omarchy/theme-history.log"
```

**Use in keybinding**:
```conf
bindd = SUPER ALT, T, Theme with notify, exec, omarchy-theme-set-with-notify.sh catppuccin
```

---

## Environment Variables

### Where to Set Variables

**Hyprland Environment Variables**:
```
~/.config/hypr/envs.conf
```

**systemd Environment Variables**:
```
~/.config/environment.d/*.conf
```

### Hyprland envs.conf

**Default content**:
```conf
# Extra env variables
# env = MY_GLOBAL_ENV,setting
```

**Examples**:

**Qt Wayland Backend**:
```conf
env = QT_QPA_PLATFORM,wayland
```

**Firefox Wayland**:
```conf
env = MOZ_ENABLE_WAYLAND,1
```

**Electron Apps**:
```conf
env = ELECTRON_OZONE_PLATFORM_HINT,auto
```

**Custom Editor**:
```conf
env = EDITOR,nvim
env = VISUAL,nvim
```

**XDG Base Directories**:
```conf
env = XDG_CONFIG_HOME,$HOME/.config
env = XDG_DATA_HOME,$HOME/.local/share
env = XDG_CACHE_HOME,$HOME/.cache
```

**CUDA/NVIDIA**:
```conf
env = CUDA_VISIBLE_DEVICES,0
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
```

**Path Extension**:
```conf
env = PATH,$HOME/.local/bin:$PATH
```

### systemd environment.d

**Location**: `~/.config/environment.d/`

**Format**: `*.conf` files with `KEY=VALUE` pairs

**Example** (`~/.config/environment.d/my-vars.conf`):
```conf
# Custom environment variables
EDITOR=nvim
BROWSER=chromium
TERM=alacritty
```

**Difference from Hyprland envs.conf**:
- `environment.d`: Available to **all** user services (systemd-managed)
- `envs.conf`: Only available to **Hyprland** and its children

**Use Cases**:
- `environment.d`: System-wide settings (EDITOR, LANG, etc.)
- `envs.conf`: Wayland-specific settings (QT_QPA_PLATFORM, etc.)

### Common Environment Variables

**Display/Wayland**:
```conf
env = WAYLAND_DISPLAY,wayland-1
env = XDG_SESSION_TYPE,wayland
env = XDG_CURRENT_DESKTOP,Hyprland
```

**Qt**:
```conf
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,qt5ct
env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
env = QT_AUTO_SCREEN_SCALE_FACTOR,1
```

**GTK**:
```conf
env = GDK_BACKEND,wayland,x11
env = GTK_THEME,Adwaita-dark
```

**Cursor**:
```conf
env = XCURSOR_SIZE,24
env = XCURSOR_THEME,Adwaita
```

**Language/Locale**:
```conf
env = LANG,en_US.UTF-8
env = LC_ALL,en_US.UTF-8
```

**Development**:
```conf
env = DBUS_SESSION_BUS_ADDRESS,unix:path=$XDG_RUNTIME_DIR/bus
env = SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/ssh-agent.socket
```

### Debugging Environment

**Check current environment**:
```bash
# All environment variables
env | sort

# Specific variable
echo $EDITOR

# Variables visible to Hyprland
hyprctl getoption env
```

**Check variable in running app**:
```bash
# Get PID of app
pgrep -f alacritty

# View environment
cat /proc/<PID>/environ | tr '\0' '\n'
```

---

## Advanced Hyprland Configuration

### Window Rules

**Location**: `~/.config/hypr/hyprland.conf`

**Syntax**:
```conf
windowrule = <rule>, <class/title>
windowrulev2 = <rule>, <match criteria>
```

**Common Rules**:

**Float Specific App**:
```conf
windowrulev2 = float, class:^(pavucontrol)$
windowrulev2 = float, title:^(Picture-in-Picture)$
```

**Opacity**:
```conf
windowrulev2 = opacity 0.9 0.9, class:^(Alacritty)$
windowrulev2 = opacity 0.95 0.8, class:^(Code)$
```

**Size and Position**:
```conf
windowrulev2 = size 800 600, class:^(floating-terminal)$
windowrulev2 = center, class:^(floating-terminal)$
windowrulev2 = move 100 100, title:^(Calculator)$
```

**Workspace Assignment**:
```conf
windowrulev2 = workspace 9, class:^(Spotify)$
windowrulev2 = workspace 5, class:^(steam)$
```

**Fullscreen/Maximize**:
```conf
windowrulev2 = fullscreen, class:^(mpv)$
windowrulev2 = maximize, title:^(.*)(Mozilla Firefox)$
```

**Animations**:
```conf
windowrulev2 = animation slide, class:^(kitty)$
windowrulev2 = animation popin 80%, class:^(rofi)$
```

**Pinning**:
```conf
windowrulev2 = pin, title:^(Picture-in-Picture)$
```

**No Shadow/Blur**:
```conf
windowrulev2 = noshadow, class:^(waybar)$
windowrulev2 = noblur, class:^(chromium)$
```

### Layer Rules

Control behavior of layer-shell surfaces (bars, launchers, notifications):

```conf
layerrule = <rule>, <namespace>
```

**Examples**:

**Blur Waybar**:
```conf
layerrule = blur, waybar
```

**Ignore Notifications for Screenshots**:
```conf
layerrule = noanim, notifications
```

**Blur Walker Launcher**:
```conf
layerrule = blur, walker
```

### Workspace Rules

**Auto-Create Workspaces**:
```conf
workspace = 1, monitor:DP-1, default:true
workspace = 2, monitor:HDMI-A-1
```

**Persistent Workspaces**:
```conf
workspace = 9, persistent:true
```

**Workspace Gaps**:
```conf
workspace = 1, gapsout:20
workspace = 2, gapsout:0  # No gaps
```

### Animation Tuning

```conf
animations {
    enabled = true

    # Bezier curves
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    bezier = smooth, 0.25, 0.1, 0.25, 1.0

    # Animation configs
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}
```

**Disable Animations** (for performance):
```conf
animations {
    enabled = false
}
```

### Input Device Configuration

**Touchpad**:
```conf
input {
    touchpad {
        natural_scroll = true
        tap-to-click = true
        drag_lock = true
        disable_while_typing = true
        scroll_factor = 0.5
    }
}
```

**Mouse**:
```conf
input {
    sensitivity = 0.0  # -1.0 to 1.0
    accel_profile = flat  # flat, adaptive
    scroll_method = 2fg   # 2fg, edge, button
}
```

**Keyboard**:
```conf
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options = caps:escape  # Remap Caps Lock to Escape
    kb_rules =

    repeat_rate = 50
    repeat_delay = 300
}
```

---

## Performance Tuning

### Hyprland Performance Options

**Render Settings** (`~/.config/hypr/looknfeel.conf`):

```conf
decoration {
    rounding = 10

    blur {
        enabled = true
        size = 3            # Smaller = faster
        passes = 1          # Fewer = faster
        new_optimizations = true
        xray = false
        ignore_opacity = false
    }

    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
}

general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
}
```

**Performance Mode** (disable blur, shadows):
```conf
decoration {
    blur {
        enabled = false
    }

    drop_shadow = false
}
```

**Reduce Animations**:
```conf
animations {
    enabled = true

    # Faster, shorter animations
    animation = windows, 1, 3, default
    animation = fade, 1, 3, default
    animation = workspaces, 1, 3, default
}
```

**Disable Animations Entirely**:
```conf
animations {
    enabled = false
}
```

### Monitor Configuration

**Refresh Rate**:
```conf
# ~/.config/hypr/monitors.conf
monitor = DP-1, 2560x1440@165, 0x0, 1
```

Higher refresh rate = smoother but more CPU/GPU usage.

**VRR (Variable Refresh Rate)**:
```conf
monitor = DP-1, 2560x1440@165, 0x0, 1, vrr, 1
```

Enables FreeSync/G-Sync for smoother gaming.

**Fractional Scaling**:
```conf
monitor = eDP-1, 1920x1080, 0x0, 1.25
```

Values other than 1.0 may reduce performance.

### Reducing Input Latency

**Mouse Polling Rate**:
```bash
# Check current rate
cat /sys/class/input/mouse*/device/device/poll_interval

# Set to 1ms (1000Hz) for gaming mouse
echo 1 | sudo tee /sys/class/input/mouse*/device/device/poll_interval
```

**Hyprland Input Config**:
```conf
input {
    force_no_accel = true   # Disable mouse acceleration
}
```

**CPU Governor** (for laptops):
```bash
# Performance mode (less latency, more power)
sudo cpupower frequency-set -g performance

# Check current governor
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```

### Memory and CPU Optimization

**Reduce Blur Texture Size**:
```conf
decoration {
    blur {
        size = 2       # Reduce from 3+
        passes = 1     # Single pass
    }
}
```

**Limit FPS** (reduce battery drain):
```conf
misc {
    vfr = true          # Variable Frame Rate (only render when needed)
    vrr = 0             # Disable VRR if not gaming
}
```

**Disable Unused Features**:
```conf
decoration {
    dim_inactive = false        # Don't dim inactive windows
    dim_strength = 0.0
}
```

### Application-Specific Optimizations

**Electron Apps** (VSCode, Discord, etc.):
```conf
# Disable GPU for specific apps (if buggy)
windowrulev2 = immediate, class:^(electron)$
```

**Force GPU Rendering**:
```conf
env = __GL_SYNC_TO_VBLANK,0
```

**Browser Performance**:
```bash
# Launch with GPU acceleration flags
chromium --enable-features=VaapiVideoDecoder,VaapiVideoEncoder \
         --enable-gpu-rasterization \
         --enable-zero-copy
```

---

## Examples

### Example 1: Basic - Theme Change Notification Hook

**Scenario**: You want visual feedback when changing themes, including the theme name and preview image.

**Step 1: Create hook script**
```bash
nano ~/.config/omarchy/hooks/theme-set
```

**Hook content**:
```bash
#!/bin/bash

# Receive theme name (snake_case)
THEME="$1"

# Convert to Title Case for display
THEME_PRETTY=$(echo "$THEME" | sed 's/_/ /g' | sed 's/\b\(.\)/\u\1/g')

# Theme preview path
PREVIEW="$HOME/.config/omarchy/themes/$THEME/preview.png"

# Send notification with preview
if [ -f "$PREVIEW" ]; then
    notify-send "Theme Changed" "$THEME_PRETTY" \
        -i "$PREVIEW" \
        -t 5000 \
        -u normal
else
    notify-send "Theme Changed" "$THEME_PRETTY" \
        -t 3000
fi

# Log theme change
LOG="$HOME/.cache/omarchy/theme-history.log"
echo "$(date '+%Y-%m-%d %H:%M:%S') - $THEME_PRETTY" >> "$LOG"
```

**Step 2: Make executable**
```bash
chmod +x ~/.config/omarchy/hooks/theme-set
```

**Step 3: Test**
```bash
# Change theme
omarchy-theme-set catppuccin
```

**Expected Behavior**:
1. Notification appears with Catppuccin preview image
2. Notification shows "Theme Changed: Catppuccin"
3. Entry added to `~/.cache/omarchy/theme-history.log`

**Step 4: View history**
```bash
cat ~/.cache/omarchy/theme-history.log
```

**Expected Output**:
```
2025-10-21 14:32:15 - Catppuccin
2025-10-21 15:47:22 - Tokyo Night
2025-10-21 16:12:08 - Gruvbox
```

**Enhancement: Add Sound**

```bash
# Install sound effect (optional)
# Download from https://freesound.org or use system sounds

# Update hook
nano ~/.config/omarchy/hooks/theme-set
```

**Add sound line**:
```bash
# Play sound when theme changes
paplay /usr/share/sounds/freedesktop/stereo/complete.oga &
```

**Why Use This**: Provides immediate visual and auditory feedback for theme changes. Useful when quickly cycling through themes to find the right one.

---

### Example 2: Intermediate - Custom Script for Workspace Setup

**Scenario**: You have different work contexts (development, writing, communication) and want one-key setup for each.

**Step 1: Create workspace scripts**

**Development Setup**:
```bash
nano ~/.local/bin/workspace-dev.sh
```

**Content**:
```bash
#!/bin/bash

# Close all windows first
for ws in 1 2 3; do
    hyprctl dispatch workspace $ws
    hyprctl dispatch exec "pkill -f 'workspace-specific-app'"
done

# Workspace 1: Terminal with tmux
hyprctl dispatch workspace 1
uwsm-app -- $TERMINAL -e tmux new-session -A -s dev &
sleep 1

# Workspace 2: Browser with localhost
hyprctl dispatch workspace 2
omarchy-launch-browser "http://localhost:3000" &
sleep 1

# Workspace 3: Code editor
hyprctl dispatch workspace 3
code ~/dev/my-project &
sleep 1

# Return to workspace 1
hyprctl dispatch workspace 1

notify-send "Workspace Setup" "Development environment ready"
```

**Writing Setup**:
```bash
nano ~/.local/bin/workspace-writing.sh
```

**Content**:
```bash
#!/bin/bash

# Workspace 1: Obsidian
hyprctl dispatch workspace 1
uwsm-app -- obsidian &
sleep 2

# Workspace 2: Browser for research
hyprctl dispatch workspace 2
omarchy-launch-browser &
sleep 1

# Workspace 3: Terminal with notes
hyprctl dispatch workspace 3
uwsm-app -- $TERMINAL -e ranger ~/Documents &

# Return to workspace 1
hyprctl dispatch workspace 1

notify-send "Workspace Setup" "Writing environment ready"
```

**Communication Setup**:
```bash
nano ~/.local/bin/workspace-comm.sh
```

**Content**:
```bash
#!/bin/bash

# Workspace 1: Email (HEY web app)
hyprctl dispatch workspace 1
omarchy-launch-webapp "https://app.hey.com" &
sleep 2

# Workspace 2: Signal
hyprctl dispatch workspace 2
omarchy-launch-or-focus signal "uwsm-app -- signal-desktop" &
sleep 1

# Workspace 3: Calendar
hyprctl dispatch workspace 3
omarchy-launch-webapp "https://app.hey.com/calendar/weeks/" &

# Return to workspace 1
hyprctl dispatch workspace 1

notify-send "Workspace Setup" "Communication environment ready"
```

**Step 2: Make executable**
```bash
chmod +x ~/.local/bin/workspace-*.sh
```

**Step 3: Add keybindings**
```bash
nano ~/.config/hypr/bindings.conf
```

**Add lines**:
```conf
# === Workspace Setups ===
bindd = SUPER CTRL, D, Dev workspace, exec, workspace-dev.sh
bindd = SUPER CTRL, W, Writing workspace, exec, workspace-writing.sh
bindd = SUPER CTRL, C, Communication workspace, exec, workspace-comm.sh
```

**Step 4: Reload and test**
```bash
hyprctl reload

# Press SUPER CTRL + D
```

**Expected Behavior**:
1. Workspace 1: Terminal with tmux session opens
2. Workspace 2: Browser opens to localhost:3000
3. Workspace 3: VSCode opens project
4. Focus returns to workspace 1
5. Notification confirms setup complete

**Enhancement: Add Teardown**

```bash
nano ~/.local/bin/workspace-teardown.sh
```

**Content**:
```bash
#!/bin/bash

# Ask for confirmation
if ! command -v zenity >/dev/null; then
    # No zenity, just do it
    CONFIRMED=true
else
    zenity --question --text="Close all workspace applications?" \
           --title="Workspace Teardown"
    CONFIRMED=$?
fi

if [ $CONFIRMED -eq 0 ]; then
    # Close all windows on workspaces 1-3
    for ws in 1 2 3; do
        hyprctl dispatch workspace $ws
        hyprctl dispatch exec "hyprctl dispatch closewindow address:$(hyprctl activewindow -j | jq -r '.address')"
    done

    hyprctl dispatch workspace 1
    notify-send "Workspace Teardown" "All workspace applications closed"
fi
```

**Add keybinding**:
```conf
bindd = SUPER CTRL SHIFT, X, Teardown workspace, exec, workspace-teardown.sh
```

**Why Use This**: Context switching becomes instant. Instead of manually opening 3-4 apps and arranging them, one keypress sets up your entire workflow.

---

### Example 3: Advanced - Performance Optimization Pipeline

**Scenario**: You want maximum performance for gaming or screen recording, with one command to enable "performance mode" and another to restore normal settings.

**Step 1: Create performance mode script**

```bash
nano ~/.local/bin/performance-mode-enable.sh
```

**Content**:
```bash
#!/bin/bash

# Backup current settings
mkdir -p ~/.cache/omarchy/performance-backup/

cp ~/.config/hypr/looknfeel.conf \
   ~/.cache/omarchy/performance-backup/looknfeel.conf.bak

# Create performance config
cat > ~/.config/hypr/looknfeel.conf <<EOF
# Performance Mode - Generated by performance-mode-enable.sh

decoration {
    rounding = 0

    blur {
        enabled = false
    }

    drop_shadow = false
}

animations {
    enabled = false
}

general {
    gaps_in = 0
    gaps_out = 0
    border_size = 1
}

misc {
    vfr = false  # Constant frame rate
}
EOF

# Stop non-essential services
systemctl --user stop waybar.service 2>/dev/null || true

# Set CPU governor to performance
if command -v cpupower >/dev/null; then
    sudo cpupower frequency-set -g performance
fi

# Reload Hyprland
hyprctl reload

# Notification
notify-send "Performance Mode" "Enabled - Blur, shadows, animations disabled" \
    -t 3000 -u low

echo "Performance mode enabled at $(date)" >> ~/.cache/omarchy/performance.log
```

**Step 2: Create restore script**

```bash
nano ~/.local/bin/performance-mode-disable.sh
```

**Content**:
```bash
#!/bin/bash

# Check if backup exists
if [ ! -f ~/.cache/omarchy/performance-backup/looknfeel.conf.bak ]; then
    notify-send "Performance Mode" "No backup found, resetting to defaults" \
        -u critical
    omarchy-refresh-config hypr/looknfeel.conf
else
    # Restore from backup
    cp ~/.cache/omarchy/performance-backup/looknfeel.conf.bak \
       ~/.config/hypr/looknfeel.conf
fi

# Restart services
systemctl --user start waybar.service 2>/dev/null || true

# Set CPU governor back to powersave (for laptops)
if command -v cpupower >/dev/null; then
    LAPTOP=$(cat /sys/class/dmi/id/chassis_type)
    if [ "$LAPTOP" = "9" ] || [ "$LAPTOP" = "10" ]; then
        sudo cpupower frequency-set -g powersave
    fi
fi

# Reload Hyprland
hyprctl reload

# Notification
notify-send "Performance Mode" "Disabled - Normal settings restored" \
    -t 3000

echo "Performance mode disabled at $(date)" >> ~/.cache/omarchy/performance.log
```

**Step 3: Make executable**

```bash
chmod +x ~/.local/bin/performance-mode-*.sh
```

**Step 4: Add keybindings**

```bash
nano ~/.config/hypr/bindings.conf
```

**Add lines**:
```conf
# === Performance Mode ===
bindd = SUPER CTRL ALT, P, Performance mode ON, exec, performance-mode-enable.sh
bindd = SUPER CTRL ALT SHIFT, P, Performance mode OFF, exec, performance-mode-disable.sh
```

**Step 5: Test**

```bash
# Enable performance mode
performance-mode-enable.sh
```

**Expected Changes**:
1. All blur effects disappear
2. Shadows removed
3. Animations disabled
4. Gaps removed (windows touch edges)
5. Waybar hidden
6. CPU governor set to performance
7. Notification confirms changes

**Verify**:
```bash
# Check current settings
cat ~/.config/hypr/looknfeel.conf

# Check CPU governor
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
# Should show: performance
```

**Benchmark**:
```bash
# Before: With blur and animations
glxgears -fullscreen
# Note FPS

# Enable performance mode
performance-mode-enable.sh

# After: No blur, no animations
glxgears -fullscreen
# FPS should be higher
```

**Step 6: Restore normal mode**

```bash
performance-mode-disable.sh
```

**Expected**:
1. Blur, shadows, animations return
2. Gaps restored
3. Waybar reappears
4. CPU governor back to powersave (laptops)
5. Settings restored from backup

**Enhancement: Auto-Detect Game Launch**

Create a game-mode hook:

```bash
nano ~/.config/hypr/scripts/game-mode-detect.sh
```

**Content**:
```bash
#!/bin/bash

# Monitor for game launches
while true; do
    # Check for Steam games
    if pgrep -f "steam.*game" >/dev/null; then
        if [ ! -f /tmp/omarchy-performance-mode-active ]; then
            performance-mode-enable.sh
            touch /tmp/omarchy-performance-mode-active
        fi
    else
        if [ -f /tmp/omarchy-performance-mode-active ]; then
            performance-mode-disable.sh
            rm /tmp/omarchy-performance-mode-active
        fi
    fi

    sleep 5
done
```

**Make executable and autostart**:
```bash
chmod +x ~/.config/hypr/scripts/game-mode-detect.sh

# Add to autostart
echo 'exec-once = bash ~/.config/hypr/scripts/game-mode-detect.sh &' \
     >> ~/.config/hypr/autostart.conf
```

**Why Use This**: Instantly switch between beautiful desktop (blur, shadows, animations) and maximum performance (no effects, constant FPS). Critical for gaming, screen recording, or benchmarking.

---

## Troubleshooting

### Hook Not Executing

**Symptom**: Created hook script but it doesn't run

**Diagnosis**:

```bash
# Check if hook file exists
ls -la ~/.config/omarchy/hooks/

# Check permissions
ls -la ~/.config/omarchy/hooks/theme-set

# Test manually
omarchy-hook theme-set test_theme
```

**Fixes**:

1. **Not executable**:
   ```bash
   chmod +x ~/.config/omarchy/hooks/theme-set
   ```

2. **Wrong filename**:
   ```bash
   # Must match hook name exactly (no .sh extension)
   mv ~/.config/omarchy/hooks/theme-set.sh ~/.config/omarchy/hooks/theme-set
   ```

3. **Syntax error in script**:
   ```bash
   # Test script directly
   bash -x ~/.config/omarchy/hooks/theme-set "test"
   ```

---

### Environment Variable Not Applied

**Symptom**: Set variable in envs.conf but app doesn't see it

**Diagnosis**:

```bash
# Check if Hyprland loaded variable
hyprctl getoption env

# Check app's environment
pgrep -f "app-name"
cat /proc/<PID>/environ | tr '\0' '\n' | grep VARIABLE
```

**Fixes**:

1. **Forgot to reload**:
   ```bash
   hyprctl reload
   ```

2. **App was already running**:
   ```bash
   # Restart app
   pkill app-name
   uwsm-app -- app-name
   ```

3. **Wrong syntax**:
   ```conf
   # ❌ Wrong
   env = VAR = value

   # ✅ Correct
   env = VAR,value
   ```

---

### Performance Mode Not Improving FPS

**Symptom**: Enabled performance mode but FPS unchanged

**Possible Causes**:

1. **GPU bottleneck** (not CPU):
   ```bash
   # Check GPU usage
   nvidia-smi  # NVIDIA
   radeontop   # AMD
   ```

2. **V-Sync enabled**:
   ```conf
   # Disable V-Sync
   misc {
       vfr = false
   }
   env = __GL_SYNC_TO_VBLANK,0
   ```

3. **Monitor refresh rate limit**:
   ```bash
   # Check monitor refresh rate
   hyprctl monitors
   # Can't exceed monitor's max refresh rate
   ```

---

## Best Practices

### Do's

**DO version control your custom configs**
```bash
cd ~/.config/hypr
git init
git add *.conf scripts/ hooks/
git commit -m "Initial config"
```

**DO document your scripts**
```bash
#!/bin/bash
# Purpose: Set up development workspace
# Usage: workspace-dev.sh
# Keybinding: SUPER CTRL + D
```

**DO handle errors in hooks**
```bash
#!/bin/bash
set -e  # Exit on error

# Or handle individually
if ! some-command; then
    notify-send "Hook Error" "some-command failed"
    exit 1
fi
```

**DO use absolute paths in scripts**
```bash
# ✅ Explicit
"$HOME/.config/omarchy/hooks/theme-set"

# ❌ Relative (unreliable)
../hooks/theme-set
```

**DO test hooks manually before relying on them**
```bash
omarchy-hook theme-set tokyo_night
```

### Don'ts

**DON'T block in hooks** (run slow tasks in background)
```bash
# ❌ Blocks theme change
sleep 10 && notify-send "Theme set"

# ✅ Background it
(sleep 10 && notify-send "Theme set") &
```

**DON'T hardcode usernames**
```bash
# ❌ Breaks for other users
/home/john/.config/script.sh

# ✅ Use $HOME
"$HOME/.config/script.sh"
```

**DON'T modify Omarchy core scripts**
```bash
# ❌ Don't edit
~/.local/share/omarchy/bin/omarchy-theme-set

# ✅ Create wrapper or hook
~/.config/omarchy/hooks/theme-set
```

**DON'T forget to reload Hyprland after config changes**
```bash
hyprctl reload
```

---

## Related Documentation

### Customization
- **Config Management** (`config-management.md`) - Configuration architecture
- **Keybindings** (`keybindings.md`) - Binding custom scripts to keys
- **Autostart Scripts** (`autostart-scripts.md`) - Running scripts at startup

### Desktop Environment
- **Hyprland Integration** (`../04-desktop-environment/hyprland-integration.md`) - Window manager config
- **Window Management** (`../04-desktop-environment/window-management.md`) - Window rules and workspaces

### Theming
- **Theme System** (`../03-theming/theme-system.md`) - Theme hooks and customization

### System Setup
- **Security Auth** (`../07-system-setup/security-auth.md`) - Environment security
- **Power Management** (`../07-system-setup/power-management.md`) - CPU governor tuning

### Reference
- **Quick Reference** (`../10-reference/quick-reference.md`) - Common tweaks and recipes
- **Troubleshooting** (`../10-reference/troubleshooting.md`) - Advanced debugging

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts Analyzed**:
- `/home/zack/.local/share/omarchy/bin/omarchy-hook`

**Configuration Files Analyzed**:
- `/home/zack/.config/omarchy/hooks/` (hook samples)
- `/home/zack/.config/hypr/envs.conf` (environment variables)
- `/home/zack/.config/hypr/hyprland.conf` (advanced config)
- `/home/zack/.config/hypr/looknfeel.conf` (performance settings)

**Verification**: All commands, scripts, hooks, and optimizations tested on Omarchy system running Hyprland on Arch Linux.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
