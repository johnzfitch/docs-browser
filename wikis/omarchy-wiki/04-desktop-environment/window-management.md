# Window Management

## Quick Start

```bash
# Window operations
Super + W              # Close active window
Ctrl + Alt + Delete    # Close ALL windows

# Tiling modes
Super + T              # Toggle floating
Super + F              # Fullscreen
Super + J              # Toggle split direction

# Focus windows
Super + Arrow Keys     # Move focus (left, right, up, down)
Alt + Tab              # Cycle windows on workspace

# Workspaces
Super + [1-9,0]        # Switch to workspace
Super + Shift + [1-9]  # Move window to workspace
Super + Tab            # Next workspace
```

---

## Table of Contents

1. [Overview](#overview)
2. [Tiling, Floating, and Fullscreen](#tiling-floating-and-fullscreen)
3. [Window Dispatchers](#window-dispatchers)
4. [Workspace Management](#workspace-management)
5. [Window Rules](#window-rules)
6. [Examples](#examples)
   - [Basic: Daily Window Operations](#example-1-basic-daily-window-operations)
   - [Intermediate: Workspace Workflows](#example-2-intermediate-workspace-workflows)
   - [Advanced: Multi-Monitor Setup](#example-3-advanced-multi-monitor-setup)
7. [Multi-Monitor Workflows](#multi-monitor-workflows)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Related Documentation](#related-documentation)

---

## Overview

Window management in Omarchy is powered by Hyprland's dynamic tiling system. Unlike traditional floating window managers, Hyprland automatically organizes windows into a tiling layout while allowing you to easily toggle floating mode for individual windows. This provides the efficiency of tiling with the flexibility of floating when needed.

Omarchy's window management uses Hyprland's **dwindle** layout algorithm, which recursively splits the screen. Each new window splits the active window's space, creating a binary tree of windows. You control split direction, resize windows, toggle floating mode, and move windows between workspaces with simple keyboard shortcuts.

The system includes intelligent defaults for common applications: browsers tile automatically, dialogs float, Steam opens in floating mode, and Picture-in-Picture windows pin to the top-right corner. These rules are defined in Hyprland's configuration and can be customized or overridden.

---

## Tiling, Floating, and Fullscreen

### Tiling Mode (Default)

When you open a new window, it tiles automatically:

```
┌─────────────────────┐
│                     │
│    Window 1         │
│                     │
└─────────────────────┘

Open Window 2:

┌──────────┬──────────┐
│          │          │
│ Window 1 │ Window 2 │
│          │          │
└──────────┴──────────┘

Open Window 3 (splits Window 2's space):

┌──────────┬──────────┐
│          │ Window 2 │
│ Window 1 ├──────────┤
│          │ Window 3 │
└──────────┴──────────┘
```

**Characteristics:**
- Windows automatically tile
- No overlapping (except floating windows)
- Efficient use of screen space
- Keyboard-driven workflow

**Keybindings:**
- `Super + J` - Toggle split direction (horizontal/vertical)
- `Super + P` - Toggle pseudo-tiling (master-stack layout)
- `Super + -` - Shrink active window
- `Super + =` - Expand active window

### Floating Mode

Toggle any window to float above tiled windows:

```bash
# Toggle active window floating
Super + T
```

**Floating window features:**
- Overlaps tiled windows
- Can be moved with mouse (Super + drag)
- Can be resized (Super + right-click drag)
- Centered by default (if configured)

**Common floating windows:**
- File picker dialogs
- Calculators
- Password managers (1Password, Bitwarden)
- Steam client
- Floating terminals

### Fullscreen Modes

Hyprland provides three fullscreen modes:

#### 1. Force Fullscreen (`Super + F`)

Fullscreen that hides everything (Waybar, gaps, borders):

```bash
Super + F    # Toggle force fullscreen
```

**Use cases:**
- Videos and movies
- Games
- Presentations

#### 2. Tiled Fullscreen (`Super + Ctrl + F`)

Maximizes window within tiling layout (keeps Waybar):

```bash
Super + Ctrl + F    # Toggle tiled fullscreen
```

**Use cases:**
- Maximize browser while keeping status bar
- Focus on single application
- Temporary full-screen work

#### 3. Full Width (`Super + Alt + F`)

Window takes full width but keeps height:

```bash
Super + Alt + F    # Toggle full width
```

**Use cases:**
- Code editors (wide code, keep vertical space for stacking)
- Browsers (wide content)
- Terminals (long command output)

### Comparison Table

| Mode | Waybar | Gaps | Borders | Use Case |
|------|--------|------|---------|----------|
| Tiled | ✓ | ✓ | ✓ | Normal workflow |
| Floating | ✓ | ✓ | ✓ | Dialogs, temporary windows |
| Force Fullscreen | ✗ | ✗ | ✗ | Media, games, presentations |
| Tiled Fullscreen | ✓ | ✗ | ✗ | Focused work with status bar |
| Full Width | ✓ | ✓ | ✓ | Wide content |

---

## Window Dispatchers

Dispatchers are Hyprland commands that control windows and workspaces. Omarchy uses them extensively in scripts and keybindings.

### Focus Dispatchers

```bash
# Move focus by direction
Super + Left         # movefocus l (left)
Super + Right        # movefocus r (right)
Super + Up           # movefocus u (up)
Super + Down         # movefocus d (down)

# Cycle through windows
Alt + Tab            # cyclenext (next window)
Alt + Shift + Tab    # cyclenext prev (previous window)
```

**Practical usage:**

```bash
# From command line (hyprctl)
hyprctl dispatch movefocus l    # Focus left window
hyprctl dispatch cyclenext       # Cycle to next window
```

### Window Manipulation Dispatchers

```bash
# Close windows
Super + W                  # killactive (close active window)
Ctrl + Alt + Delete        # Execute: omarchy-cmd-close-all-windows

# Move/swap windows
Super + Shift + Left       # swapwindow l (swap left)
Super + Shift + Right      # swapwindow r (swap right)
Super + Shift + Up         # swapwindow u (swap up)
Super + Shift + Down       # swapwindow d (swap down)

# Resize windows
Super + -                  # resizeactive -100 0 (shrink width)
Super + =                  # resizeactive 100 0 (expand width)
Super + Shift + -          # resizeactive 0 -100 (shrink height)
Super + Shift + =          # resizeactive 0 100 (expand height)

# Layout control
Super + J                  # togglesplit (toggle split direction)
Super + P                  # pseudo (toggle pseudo-tiling)
Super + T                  # togglefloating
Super + F                  # fullscreen 0 (force fullscreen)
```

**From scripts:**

```bash
# Close specific window
hyprctl dispatch closewindow address:0x5643a8b2c3f0

# Toggle floating for active window
hyprctl dispatch togglefloating

# Move window to specific workspace
hyprctl dispatch movetoworkspace 3

# Move window to workspace and follow
hyprctl dispatch movetoworkspacesilent 5
hyprctl dispatch workspace 5
```

### Workspace Dispatchers

```bash
# Switch workspaces
Super + 1-9              # workspace 1-9
Super + 0                # workspace 10

# Move windows to workspaces
Super + Shift + 1-9      # movetoworkspace 1-9

# Navigate workspaces
Super + Tab              # workspace e+1 (next workspace)
Super + Shift + Tab      # workspace e-1 (previous workspace)
Super + Ctrl + Tab       # workspace previous (last workspace)

# Scroll workspaces
Super + Mouse Wheel Up   # workspace e+1
Super + Mouse Wheel Down # workspace e-1
```

### Group Dispatchers (Window Grouping/Tabs)

Group windows into tabbed containers:

```bash
# Create/manage groups
Super + G                # togglegroup (create or toggle)
Super + Alt + G          # moveoutofgroup (remove from group)

# Join groups (move window into adjacent group)
Super + Alt + Left       # moveintogroup l
Super + Alt + Right      # moveintogroup r
Super + Alt + Up         # moveintogroup u
Super + Alt + Down       # moveintogroup d

# Navigate grouped windows
Super + Alt + Tab        # changegroupactive f (forward)
Super + Alt + Shift + Tab  # changegroupactive b (backward)
Super + Alt + 1-5        # changegroupactive 1-5 (by number)
```

**Group workflow:**

```
1. Open multiple terminals
2. Press Super + G on first terminal (creates group)
3. Focus second terminal, press Super + Alt + Left (join group)
4. Windows are now tabbed together
5. Press Super + Alt + Tab to switch between tabs
```

### Mouse Dispatchers

```bash
# Move window (hold Super + left-click + drag)
Super + Mouse Left       # movewindow

# Resize window (hold Super + right-click + drag)
Super + Mouse Right      # resizewindow
```

---

## Workspace Management

### Workspace Concept

Omarchy configures 10 persistent workspaces (1-10). Each workspace is an independent desktop with its own windows. Workspaces persist even when empty, allowing consistent organization.

**Default workspace configuration:**
- **Workspace 1**: General use (browser, terminal, etc.)
- **Workspace 2**: Development (editors, terminals)
- **Workspace 3**: Communication (chat, email)
- **Workspace 4**: Media (music, videos)
- **Workspace 5**: Miscellaneous
- **Workspaces 6-10**: Available for custom use

You can organize differently based on workflow.

### Switching Workspaces

```bash
# Direct switching
Super + 1    # Workspace 1
Super + 2    # Workspace 2
Super + 3    # Workspace 3
# ... up to 0 (workspace 10)

# Sequential switching
Super + Tab        # Next workspace (1→2→3...)
Super + Shift + Tab  # Previous workspace (3→2→1...)

# Jump to last workspace
Super + Ctrl + Tab  # Toggle between current and last workspace
```

**Scroll switching:**

```bash
# Hold Super and scroll mouse wheel
Super + Wheel Up    # Next workspace
Super + Wheel Down  # Previous workspace
```

### Moving Windows Between Workspaces

```bash
# Move active window to workspace (stay on current workspace)
Super + Shift + 1    # Move to workspace 1
Super + Shift + 2    # Move to workspace 2
# ... up to 9

# Move and follow (scripted approach)
hyprctl dispatch movetoworkspace 3
hyprctl dispatch workspace 3
```

### Workspace-Specific Window Rules

You can configure windows to always open on specific workspaces:

```conf
# In ~/.config/hypr/hyprland.conf

# Firefox always opens on workspace 2
windowrulev2 = workspace 2, class:^(firefox)$

# Spotify always opens on workspace 4
windowrulev2 = workspace 4, class:^(Spotify)$

# Discord always opens on workspace 3
windowrulev2 = workspace 3, class:^(discord)$

# VS Code always opens on workspace 2
windowrulev2 = workspace 2, class:^(code)$
```

---

## Window Rules

Window rules automatically configure windows based on their class, title, or other properties.

### Finding Window Information

```bash
# List all open windows with details
hyprctl clients

# Example output:
Window 5643a8b2c3f0 -> firefox:
  class: firefox
  title: Mozilla Firefox
  workspace: 2 (2)
  floating: false
  fullscreen: false
```

### Rule Syntax

Omarchy uses `windowrulev2` (newer, more flexible syntax):

```conf
windowrulev2 = RULE, CONDITION

# Examples:
windowrulev2 = float, class:^(Steam)$
windowrulev2 = workspace 2, class:^(firefox)$
windowrulev2 = size 80% 80%, class:^(Spotify)$, title:^(Spotify)$
```

### Common Window Rules

#### Floating Rules

```conf
# File picker dialogs
windowrule = tag +floating-window, class:(blueberry.py|Impala|Wiremix|org.gnome.NautilusPreviewer)
windowrule = float, tag:floating-window
windowrule = center, tag:floating-window
windowrule = size 800 600, tag:floating-window

# Password managers (no screenshare)
windowrule = noscreenshare, class:^(Bitwarden|1Password)$

# Calculator
windowrule = float, class:org.gnome.Calculator
```

#### Browser Rules

```conf
# Force browsers to tile
windowrule = tag +chromium-based-browser, class:((google-)?[cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge)
windowrule = tag +firefox-based-browser, class:([fF]irefox|zen|librewolf)
windowrule = tile, tag:chromium-based-browser

# Adjust browser opacity
windowrule = opacity 1 0.97, tag:chromium-based-browser
windowrule = opacity 1 0.97, tag:firefox-based-browser
```

#### Picture-in-Picture

```conf
# Floating, pinned, top-right corner
windowrule = tag +pip, title:(Picture.{0,1}in.{0,1}[Pp]icture)
windowrule = float, tag:pip
windowrule = pin, tag:pip
windowrule = size 600 338, tag:pip
windowrule = keepaspectratio, tag:pip
windowrule = noborder, tag:pip
windowrule = move 100%-w-40 4%, tag:pip
```

#### Steam

```conf
windowrule = float, class:steam
windowrule = center, class:steam, title:Steam
windowrule = opacity 1 1, class:steam
windowrule = size 1100 700, class:steam, title:Steam
windowrule = size 460 800, class:steam, title:Friends List
windowrule = idleinhibit fullscreen, class:steam
```

#### JetBrains IDEs

```conf
# Floating splash screens
windowrule = size 50% 50%, class:(.*jetbrains.*)$, title:^$,floating:1

# Don't focus empty popups
windowrule = noinitialfocus, class:^(.*jetbrains.*)$, title:^\\s$
windowrule = nofocus, class:^(.*jetbrains.*)$, title:^\\s$
```

#### Terminal Windows

```conf
# Tag terminals for easy grouping
windowrule = tag +terminal, class:(Alacritty|kitty|com.mitchellh.ghostty)
```

### Available Rule Types

| Rule | Description | Example |
|------|-------------|---------|
| `float` | Make window floating | `float, class:^(Steam)$` |
| `tile` | Force window to tile | `tile, class:^(firefox)$` |
| `fullscreen` | Start in fullscreen | `fullscreen, class:^(mpv)$` |
| `workspace N` | Open on workspace N | `workspace 2, class:^(code)$` |
| `size W H` | Set window size | `size 800 600, class:^(Steam)$` |
| `center` | Center window | `center, class:^(Steam)$` |
| `move X Y` | Position window | `move 100 100, class:^(calculator)$` |
| `opacity ACTIVE INACTIVE` | Set transparency | `opacity 0.9 0.8, class:^(kitty)$` |
| `animation STYLE` | Custom animation | `animation popin, class:^(Steam)$` |
| `pin` | Pin (visible on all workspaces) | `pin, tag:pip` |
| `noborder` | Remove border | `noborder, tag:pip` |
| `nofocus` | Don't focus when opened | `nofocus, class:^(Steam)$, title:^\\s$` |
| `noinitialfocus` | Don't focus initially | `noinitialfocus, class:^(Steam)$` |
| `noscreenshare` | Exclude from screenshare | `noscreenshare, class:^(1Password)$` |
| `idleinhibit MODE` | Prevent screen idle | `idleinhibit fullscreen, class:^(mpv)$` |
| `tag +NAME` | Assign tag for grouping | `tag +terminal, class:^(kitty)$` |

---

## Examples

### Example 1: Basic - Daily Window Operations

**Scenario:** You're working on a project and need to manage multiple windows efficiently.

**Workflow:**

```bash
# 1. Open terminal (Super + Return)
Super + Return

# 2. Open browser (Super + Shift + B)
Super + Shift + B

# Now you have two tiled windows side-by-side

# 3. Focus terminal (left window)
Super + Left

# 4. Open another terminal
Super + Return

# Now you have:
# ┌──────────┬──────────┐
# │          │          │
# │ Browser  │ Terminal │
# │          ├──────────┤
# │          │ Terminal │
# └──────────┴──────────┘

# 5. Make browser fullscreen for reading
Super + Left        # Focus browser
Super + Ctrl + F    # Tiled fullscreen (keeps Waybar)

# 6. Exit fullscreen when done
Super + Ctrl + F    # Toggle back

# 7. Close a terminal
Super + Right       # Focus terminal
Super + Down        # Focus bottom terminal
Super + W           # Close it

# 8. Make calculator float
# Open calculator
Super + Space       # Open Walker
calc                # Type "calc"
Return              # Launch calculator
Super + T           # Toggle floating (calculator floats above)
```

**Key lessons:**
- Tiling happens automatically
- Focus with arrow keys
- Toggle modes with simple shortcuts
- Floating windows overlay tiled windows

---

### Example 2: Intermediate - Workspace Workflows

**Scenario:** You want to organize your work across multiple workspaces for different tasks.

**Setup:**

```bash
# Workspace 1: General browsing and notes
Super + 1
Super + Shift + B    # Open browser
Super + Return       # Open terminal

# Workspace 2: Development
Super + 2
Super + N            # Open editor (Neovim/VS Code)
Super + Return       # Open terminal for git commands
Super + Return       # Open second terminal for running app

# Workspace 3: Communication
Super + 3
Super + Shift + G    # Open Signal
# Open Discord, Slack, etc.

# Workspace 4: Media
Super + 4
Super + Shift + M    # Open Spotify
```

**Daily workflow:**

```bash
# Start on workspace 1 (general)
Super + 1

# Need to code? Jump to workspace 2
Super + 2

# Got a message? Quick check workspace 3
Super + 3

# Read message, return to coding
Super + Ctrl + Tab    # Jump back to previous workspace (2)

# Cycle through workspaces
Super + Tab           # Next workspace
Super + Shift + Tab   # Previous workspace
```

**Moving windows between workspaces:**

```bash
# Oops, opened browser on workspace 2, should be on 1
Super + 2             # Go to workspace 2
# Focus browser (if not already focused)
Super + Shift + 1     # Move browser to workspace 1
Super + 1             # Switch to workspace 1 to verify
```

**Persistent workspace rules:**

Add to `~/.config/hypr/hyprland.conf`:

```conf
# Always open apps on specific workspaces
windowrulev2 = workspace 2, class:^(code|neovim)$
windowrulev2 = workspace 3, class:^(signal|discord|Slack)$
windowrulev2 = workspace 4, class:^(Spotify|vlc|mpv)$
```

Now apps automatically open on their designated workspaces.

---

### Example 3: Advanced - Multi-Monitor Setup

**Scenario:** You have two monitors and want to optimize window management across both.

**Monitor configuration:**

Edit `~/.config/hypr/monitors.conf`:

```conf
# Main monitor (1440p, 144Hz, left)
monitor = DP-1, 2560x1440@144, 0x0, 1

# Secondary monitor (1080p, 60Hz, right)
monitor = HDMI-A-1, 1920x1080@60, 2560x0, 1
```

**Workspace assignment:**

```conf
# In ~/.config/hypr/hyprland.conf

# Workspaces 1-5 on main monitor (DP-1)
workspace = 1, monitor:DP-1
workspace = 2, monitor:DP-1
workspace = 3, monitor:DP-1
workspace = 4, monitor:DP-1
workspace = 5, monitor:DP-1

# Workspaces 6-10 on secondary monitor (HDMI-A-1)
workspace = 6, monitor:HDMI-A-1
workspace = 7, monitor:HDMI-A-1
workspace = 8, monitor:HDMI-A-1
workspace = 9, monitor:HDMI-A-1
workspace = 10, monitor:HDMI-A-1
```

**Usage workflow:**

```bash
# Main monitor (left): Code and terminal
Super + 1              # Workspace 1 on DP-1
Super + N              # Open editor

# Secondary monitor (right): Documentation and communication
Super + 6              # Workspace 6 on HDMI-A-1
Super + Shift + B      # Open browser (docs)

# Now working on both monitors:
# - Main: Editor on workspace 1
# - Secondary: Browser on workspace 6

# Switch workspaces on main monitor
Super + 2              # Workspace 2 on DP-1 (switches main monitor only)

# Switch workspaces on secondary monitor
Super + 7              # Workspace 7 on HDMI-A-1 (switches secondary only)
```

**Moving windows between monitors:**

```bash
# Method 1: Move via workspace
# On main monitor, want to move browser to secondary
Super + Shift + 6      # Move to workspace 6 (secondary monitor)

# Method 2: Using dispatcher
hyprctl dispatch movewindow mon:HDMI-A-1
```

**Per-monitor Waybar:**

Edit `~/.config/waybar/config.jsonc`:

```jsonc
{
  // Waybar on main monitor only
  "output": "DP-1",
  // ... rest of config
}
```

Or run two Waybar instances:

```bash
# In autostart
waybar -c ~/.config/waybar/config-main.jsonc &
waybar -c ~/.config/waybar/config-secondary.jsonc &
```

---

## Multi-Monitor Workflows

### Workspace Per Monitor

Assign workspaces to specific monitors:

```conf
# 5 workspaces per monitor
workspace = 1, monitor:DP-1, default:true
workspace = 2, monitor:DP-1
workspace = 3, monitor:DP-1
workspace = 4, monitor:DP-1
workspace = 5, monitor:DP-1

workspace = 6, monitor:HDMI-A-1, default:true
workspace = 7, monitor:HDMI-A-1
workspace = 8, monitor:HDMI-A-1
workspace = 9, monitor:HDMI-A-1
workspace = 10, monitor:HDMI-A-1
```

**Keybinding workflow:**

```bash
# Main monitor workspaces
Super + 1-5    # Switch between workspaces on main monitor

# Secondary monitor workspaces
Super + 6-0    # Switch between workspaces on secondary monitor
```

### Focus Across Monitors

```bash
# Method 1: Focus window by direction (crosses monitors)
Super + Left    # Focus left (can jump to other monitor)
Super + Right   # Focus right (can jump to other monitor)

# Method 2: Use mouse
# Click on window on other monitor

# Method 3: Cycle windows globally
Alt + Tab       # Cycles windows across all monitors
```

### Moving Windows Between Monitors

```bash
# Move to specific monitor using dispatcher
hyprctl dispatch movewindow mon:DP-1
hyprctl dispatch movewindow mon:HDMI-A-1

# Or move via workspace (workspace tied to monitor)
Super + Shift + 6    # Move to workspace 6 (secondary monitor)
```

### Monitor-Specific Window Rules

```conf
# Always open specific apps on secondary monitor
windowrulev2 = workspace 6, class:^(Spotify)$    # Workspace 6 = secondary monitor
windowrulev2 = workspace 7, class:^(discord)$    # Workspace 7 = secondary monitor

# Always open on main monitor
windowrulev2 = workspace 2, class:^(code)$       # Workspace 2 = main monitor
```

### Vertical Monitor (Portrait Mode)

```conf
# Rotate monitor to portrait (90° clockwise)
monitor = HDMI-A-1, 1920x1080@60, 2560x0, 1, transform, 1

# Transform values:
# 0 = normal
# 1 = 90° clockwise
# 2 = 180°
# 3 = 270° clockwise (90° counter-clockwise)
```

**Use cases for portrait monitor:**
- Code editors (more vertical lines visible)
- Chat applications (long message history)
- Document reading (PDF, articles)
- Social media (vertical scrolling)

---

## Troubleshooting

### Windows Not Tiling

**Problem:** New windows open floating instead of tiling.

**Solutions:**

```bash
# 1. Check if window class has float rule
hyprctl clients | grep -A10 "Your App"

# 2. Remove or override float rule
# In ~/.config/hypr/hyprland.conf:
windowrulev2 = tile, class:^(yourapp)$

# 3. Manually tile floating window
Super + T    # Toggle floating off

# 4. Check default tile setting
# In ~/.config/hypr/looknfeel.conf:
general {
  # Ensure no global float setting
}
```

### Can't Close Window

**Problem:** `Super + W` doesn't close window.

**Solutions:**

```bash
# 1. Try alternative close methods
Alt + F4

# 2. Kill window via dispatcher
hyprctl dispatch killactive

# 3. Force kill the application
pkill application-name

# 4. Close all windows and start fresh
Ctrl + Alt + Delete    # omarchy-cmd-close-all-windows
```

### Window Stuck Between Monitors

**Problem:** Window appears partially on two monitors.

**Solutions:**

```bash
# 1. Move window to specific monitor
hyprctl dispatch movewindow mon:DP-1

# 2. Reset window position
Super + T    # Float
Super + T    # Tile again (resets position)

# 3. Move to workspace on specific monitor
Super + Shift + 1    # Move to workspace 1 (main monitor)
```

### Workspace Switching Slow

**Problem:** Switching workspaces feels laggy.

**Solutions:**

```bash
# Reduce animation time
# Edit ~/.config/hypr/looknfeel.conf:

animations {
  animation = workspaces, 1, 2, default    # Faster (was 4)
}

# Or disable workspace animations
animations {
  animation = workspaces, 0    # Disabled
}

# Reload Hyprland
hyprctl reload
```

### Window Rules Not Applied

**Problem:** Custom window rules don't work.

**Solutions:**

```bash
# 1. Verify window class
hyprctl clients | grep -B2 -A8 "YourApp"

# 2. Use correct syntax (windowrulev2)
windowrulev2 = float, class:^(exact-class)$

# 3. Use regex if class varies
windowrulev2 = float, class:^(Steam).*$

# 4. Reload Hyprland
hyprctl reload

# 5. Restart application (rules apply on window creation)
```

---

## Best Practices

### 1. Use Workspaces for Context

Organize by task, not by application:

```
Workspace 1: Writing (editor, browser for research)
Workspace 2: Coding (IDE, terminals, browser with docs)
Workspace 3: Communication (chat apps, email)
Workspace 4: Media (music, videos)
Workspace 5: Miscellaneous (temp work)
```

### 2. Learn Keyboard Shortcuts

Avoid using mouse for window management:

```bash
# Essential shortcuts to memorize:
Super + Arrow Keys         # Focus windows
Super + Shift + Arrow Keys # Move/swap windows
Super + 1-9                # Switch workspaces
Super + Shift + 1-9        # Move window to workspace
Super + T                  # Toggle floating
Super + F                  # Fullscreen
Super + W                  # Close window
Alt + Tab                  # Cycle windows
```

### 3. Use Window Groups for Related Windows

Group related terminals together:

```bash
# Open 3 terminals
Super + Return
Super + Return
Super + Return

# Create group
Super + G              # Toggle group on first terminal

# Add others to group
# Focus second terminal
Super + Alt + Left     # Move into group on left

# Focus third terminal
Super + Alt + Left     # Move into group on left

# Navigate grouped terminals
Super + Alt + Tab      # Cycle through tabs
```

### 4. Define Application-Specific Rules

Make common apps behave consistently:

```conf
# Browsers always tile
windowrulev2 = tile, class:^(firefox|chrome|brave)$

# Dialogs always float and center
windowrulev2 = float, title:^(Open File|Save File).*$
windowrulev2 = center, title:^(Open File|Save File).*$

# Password managers never screenshare
windowrulev2 = noscreenshare, class:^(1Password|Bitwarden)$

# Media players full opacity
windowrulev2 = opacity 1 1, class:^(mpv|vlc)$
```

### 5. Use Pseudo-Tiling for Master-Stack

When you want one main window:

```bash
Super + P    # Toggle pseudo-tiling

# Layout changes to:
# ┌─────────────┬───┐
# │             │   │
# │   Master    │ 2 │
# │             ├───┤
# │             │ 3 │
# └─────────────┴───┘
```

### 6. Clean Up Workspaces Regularly

```bash
# Close all windows on current workspace
Ctrl + Alt + Delete

# Or close windows one by one
Super + W    # Close active window (repeat)
```

### 7. Use Floating for Temporary Windows

Keep tiling for main workflow, float for temporary:

```bash
# Calculator: float
# File picker: float
# Settings dialogs: float
# Password manager: float

# Main apps: tiled
# Browser, terminal, editor: tiled
```

---

## Related Documentation

### Omarchy Documentation
- [Hyprland Integration](/home/zack/dev/lib/omarchy-archive/04-desktop-environment/hyprland-integration.md) - Detailed Hyprland configuration
- [Waybar Configuration](/home/zack/dev/lib/omarchy-archive/04-desktop-environment/waybar-configuration.md) - Status bar showing workspaces
- [Walker & Elephant](/home/zack/dev/lib/omarchy-archive/04-desktop-environment/walker-elephant.md) - Application launcher

### Hyprland Archive
For comprehensive window management details, see:
**`/home/zack/dev/lib/hyprland-archive/`**

Key sections:
- Tiling layouts and algorithms
- Advanced window rules
- Dispatcher reference
- Workspace configuration
- Multi-monitor setup

### External Resources
- [Hyprland Wiki - Master Tutorial](https://wiki.hyprland.org/Getting-Started/Master-Tutorial/) - Window management basics
- [Hyprland Wiki - Dispatchers](https://wiki.hyprland.org/Configuring/Dispatchers/) - Complete dispatcher list
- [Hyprland Wiki - Window Rules](https://wiki.hyprland.org/Configuring/Window-Rules/) - Rule syntax and examples

---

**Last Updated:** 2025-10-21
**Omarchy Version:** Latest
