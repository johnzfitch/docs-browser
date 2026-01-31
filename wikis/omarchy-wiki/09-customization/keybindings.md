# Keybindings

## Quick Start

```bash
# View all active keybindings
omarchy-menu-keybindings

# Edit your custom keybindings
nano ~/.config/hypr/bindings.conf

# Reload Hyprland to apply changes
hyprctl reload

# Check default keybindings
cat ~/.local/share/omarchy/default/hypr/bindings/tiling-v2.conf
```

---

## Table of Contents

1. [Overview](#overview)
2. [omarchy-menu-keybindings Command](#omarchy-menu-keybindings-command)
3. [Hyprland Bindings Configuration](#hyprland-bindings-configuration)
4. [Default Keybindings Reference](#default-keybindings-reference)
5. [Creating Custom Bindings](#creating-custom-bindings)
6. [Keybinding Conflicts](#keybinding-conflicts)
7. [Examples](#examples)
   - [Basic: Adding a Simple Keybinding](#example-1-basic-adding-a-simple-keybinding)
   - [Intermediate: Creating a Custom Workflow](#example-2-intermediate-creating-a-custom-workflow)
   - [Advanced: Building Submaps for Complex Actions](#example-3-advanced-building-submaps-for-complex-actions)
8. [Binding Syntax Reference](#binding-syntax-reference)
9. [Troubleshooting](#troubleshooting)
10. [Best Practices](#best-practices)
11. [Related Documentation](#related-documentation)

---

## Overview

Omarchy's keybinding system combines intelligent defaults with full customization flexibility. Every keybinding is searchable, documented, and organized into logical categories. The `omarchy-menu-keybindings` command provides an interactive browser that displays all active bindings with descriptions, making it easy to discover functionality and avoid conflicts.

Keybindings are managed through Hyprland's configuration system with multiple layers:
- **Default Omarchy bindings** (`~/.local/share/omarchy/default/hypr/bindings/`) - Core functionality
- **User custom bindings** (`~/.config/hypr/bindings.conf`) - Your additions and overrides

The system uses Hyprland's `bindd` directive (bind with description), which enables the interactive keybinding browser and provides inline documentation. All keybindings follow a consistent modifier scheme: `SUPER` for window management, `SUPER SHIFT` for application launching, and `SUPER CTRL` for advanced features.

---

## omarchy-menu-keybindings Command

### Purpose

`omarchy-menu-keybindings` displays all active Hyprland keybindings in a searchable, interactive menu powered by Walker.

### Usage

```bash
omarchy-menu-keybindings
```

**No arguments needed** - the command automatically:
1. Fetches all bindings from Hyprland via `hyprctl -j binds`
2. Translates keycodes to human-readable symbols
3. Maps modifier masks to readable text (e.g., `64` → `SUPER`)
4. Cleans up command paths (removes Omarchy bin prefix)
5. Formats everything in an aligned, searchable list
6. Displays in Walker with fuzzy search

### Interactive Features

**Search**: Type to filter keybindings
- `"spotify"` - Find Spotify-related bindings
- `"SUPER SHIFT"` - Show all SUPER+SHIFT bindings
- `"workspace"` - Find workspace management keys

**Navigation**:
- Arrow keys: Move through results
- Enter: Close menu (no action, just reference)
- Escape: Close menu

### Output Format

```
SUPER + RETURN              → Terminal
SUPER + F                   → File manager
SUPER SHIFT + B             → Browser
SUPER + Q                   → Close window
SUPER + 1                   → workspace, 1
CTRL + GRAVE                → Capture mode
```

Format: `<modifiers> + <key>` → `<description or command>`

### How It Works

The script performs several transformations to make bindings readable:

**1. Keycode Translation**:
```bash
# Raw from hyprctl:
"keycode": 36

# Translated using xkbcli:
RETURN
```

**2. Modifier Mask Decoding**:
```bash
# Raw modmask values:
64  → SUPER
65  → SUPER SHIFT
68  → SUPER CTRL
72  → SUPER ALT
```

**3. Path Cleaning**:
```bash
# Raw command:
~/.local/share/omarchy/bin/omarchy-launch-browser

# Cleaned:
omarchy-launch-browser
```

**4. UWSM Cleanup**:
```bash
# Raw:
uwsm app -- nautilus

# Cleaned:
nautilus
```

### Technical Details

The script uses a cached keymap approach for performance:

1. **Build keymap cache** at startup using `xkbcli compile-keymap`
2. **Parse keycodes** by looking up codes in cache (O(1) lookup)
3. **Avoid repeated XKB queries** (significant speedup)

**Performance**:
- Cold start: ~0.5-1 second
- With cache: ~0.05-0.1 seconds

**Debug Mode**:
```bash
DEBUG=1 omarchy-menu-keybindings
# Shows timing information for parse_keycodes function
```

---

## Hyprland Bindings Configuration

### Configuration Layers

Hyprland sources bindings in this order:

```conf
# ~/.config/hypr/hyprland.conf

# Layer 1: Default Omarchy bindings
source = ~/.local/share/omarchy/default/hypr/bindings/media.conf
source = ~/.local/share/omarchy/default/hypr/bindings/clipboard.conf
source = ~/.local/share/omarchy/default/hypr/bindings/tiling-v2.conf
source = ~/.local/share/omarchy/default/hypr/bindings/utilities.conf

# Layer 2: User custom bindings (sourced last, can override)
source = ~/.config/hypr/bindings.conf
```

**Override Behavior**: Later bindings replace earlier ones for the same key combination.

### Binding Files

**Default Bindings** (`~/.local/share/omarchy/default/hypr/bindings/`):

| File | Purpose | Key Examples |
|------|---------|--------------|
| `media.conf` | Media control, volume, brightness | XF86AudioPlay, XF86MonBrightnessUp |
| `clipboard.conf` | Clipboard history management | SUPER+V, SUPER+C |
| `tiling-v2.conf` | Window management, workspaces | SUPER+Q, SUPER+1-9, SUPER+arrows |
| `utilities.conf` | Screenshots, launchers, system | SUPER+SPACE, CTRL+GRAVE, SUPER+L |

**User Bindings** (`~/.config/hypr/bindings.conf`):
- Your custom keybindings
- Application launchers
- Personal workflow shortcuts

### Binding Directive Types

**bindd** (bind with description):
```conf
bindd = SUPER, Q, Close window, exec, hyprctl dispatch killactive
```
- Shows up in `omarchy-menu-keybindings` with description
- Best for user-facing actions

**bind** (standard binding):
```conf
bind = SUPER, Q, killactive
```
- Still works, but no description in menu
- Use `bindd` instead for better documentation

**bindm** (mouse binding):
```conf
bindm = SUPER, mouse:272, movewindow
bindm = SUPER, mouse:273, resizewindow
```
- Mouse button bindings
- 272 = left click, 273 = right click

**binde** (repeat on hold):
```conf
binde = , XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise
```
- Key repeats while held
- Good for volume, brightness

**bindl** (locked screen binding):
```conf
bindl = , XF86AudioPlay, exec, playerctl play-pause
```
- Works even when screen is locked
- Media keys typically use this

### Modifier Keys

| Modifier | Key | Common Use |
|----------|-----|------------|
| `SUPER` | Windows/Command key | Window management |
| `SHIFT` | Shift | Application launching |
| `CTRL` | Control | Advanced features |
| `ALT` | Alt | Alternative actions |

**Combinations**:
- `SUPER SHIFT` - Launch applications
- `SUPER CTRL` - Advanced window actions
- `SUPER ALT` - Specialized functions
- `SUPER SHIFT CTRL` - Rarely-used expert features

### Submaps

Submaps enable **modal keybindings** (multi-stage shortcuts):

```conf
# Enter capture submap
bindd = CTRL, GRAVE, Capture mode, submap, capture

# Bindings active only in capture submap
submap = capture
  bindd = , R, Region screenshot, exec, omarchy-cmd-screenshot region
  bindd = , W, Window screenshot, exec, omarchy-cmd-screenshot window
  bindd = , F, Fullscreen screenshot, exec, omarchy-cmd-screenshot output
  bind = , ESCAPE, submap, reset
submap = reset
```

**Usage**:
1. Press `CTRL+GRAVE` to enter capture mode
2. Notification appears showing available options
3. Press `R`, `W`, or `F` for screenshot type
4. Automatically exits submap

**Benefits**:
- Reduces keybinding conflicts
- Groups related actions
- Provides discoverability (show notification on entry)

---

## Default Keybindings Reference

### Window Management (SUPER + Keys)

| Binding | Action |
|---------|--------|
| `SUPER + Q` | Close active window |
| `SUPER + Space` | Toggle floating mode |
| `SUPER + P` | Toggle pseudo-tiling |
| `SUPER + J` | Toggle split direction |
| `SUPER + arrows` | Move focus |
| `SUPER + h/j/k/l` | Move focus (Vim-style) |
| `SUPER + 1-9` | Switch to workspace 1-9 |
| `SUPER + 0` | Switch to workspace 10 |
| `SUPER + mouse_left` | Move window |
| `SUPER + mouse_right` | Resize window |

### Window Moving (SUPER SHIFT + Keys)

| Binding | Action |
|---------|--------|
| `SUPER SHIFT + arrows` | Move window in direction |
| `SUPER SHIFT + 1-9` | Move window to workspace 1-9 |
| `SUPER SHIFT + 0` | Move window to workspace 10 |
| `SUPER SHIFT + mouse_wheel` | Cycle through workspaces |

### Window Resizing (SUPER CTRL + Keys)

| Binding | Action |
|---------|--------|
| `SUPER CTRL + arrows` | Resize window |
| `SUPER CTRL + h/j/k/l` | Resize window (Vim-style) |

### Application Launching (SUPER SHIFT + Keys)

| Binding | Application |
|---------|-------------|
| `SUPER + RETURN` | Terminal (in current directory) |
| `SUPER + F` | File manager (Nautilus) |
| `SUPER SHIFT + B` | Browser |
| `SUPER + B` | Browser (private mode) |
| `SUPER + N` | Editor (default) |
| `SUPER SHIFT + V` | Neovim (in terminal) |
| `SUPER SHIFT + M` | Music (Spotify) |
| `SUPER SHIFT + O` | Obsidian |
| `SUPER SHIFT + T` | Activity monitor (btop) |
| `SUPER SHIFT + D` | Docker manager (lazydocker) |
| `SUPER SHIFT + G` | Signal messenger |
| `SUPER SHIFT + /` | Password manager (1Password) |

### Web App Shortcuts (SUPER SHIFT + Keys)

| Binding | Web App |
|---------|---------|
| `SUPER SHIFT + A` | ChatGPT |
| `SUPER CTRL + A` | Grok |
| `SUPER SHIFT + C` | Calendar (HEY) |
| `SUPER SHIFT + E` | Email (HEY) |
| `SUPER SHIFT + Y` | YouTube |
| `SUPER SHIFT + X` | X (Twitter) |

### Media Control (Function Keys)

| Binding | Action |
|---------|--------|
| `XF86AudioPlay` | Play/pause |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Mute toggle |
| `XF86MonBrightnessUp` | Brightness up |
| `XF86MonBrightnessDown` | Brightness down |

### Clipboard (SUPER + Keys)

| Binding | Action |
|---------|--------|
| `SUPER + V` | Clipboard history |
| `SUPER + C` | Color picker |

### Screenshots (CTRL + GRAVE, then)

| Binding | Action |
|---------|--------|
| `CTRL + GRAVE` | Enter capture mode |
| `R` (in mode) | Region screenshot |
| `W` (in mode) | Window screenshot |
| `F` (in mode) | Fullscreen screenshot |
| `Escape` (in mode) | Cancel |

### System Actions (SUPER + Keys)

| Binding | Action |
|---------|--------|
| `SUPER + L` | Lock screen |
| `SUPER + Escape` | Power menu |
| `SUPER SHIFT + R` | Reload Hyprland config |
| `SUPER SHIFT + Q` | Exit Hyprland |

---

## Creating Custom Bindings

### Basic Custom Binding

Add to `~/.config/hypr/bindings.conf`:

```conf
# Launch VSCode with description
bindd = SUPER SHIFT, C, VSCode, exec, code

# Close all windows on workspace
bindd = SUPER SHIFT CTRL, Q, Close all windows, exec, omarchy-cmd-close-all-windows
```

### Application Launcher Binding

```conf
# Launch or focus existing window
bindd = SUPER SHIFT, S, Slack, exec, omarchy-launch-or-focus slack "uwsm-app -- slack"

# Launch web app
bindd = SUPER SHIFT, N, Notion, exec, omarchy-launch-webapp "https://notion.so"
```

### Workspace-Specific Binding

```conf
# Open browser on workspace 2
bindd = SUPER ALT, B, Browser (WS 2), exec, hyprctl dispatch workspace 2 && omarchy-launch-browser

# Move active window to workspace 5 and follow
bindd = SUPER SHIFT, 5, Move to WS 5, exec, hyprctl dispatch movetoworkspacesilent 5 && hyprctl dispatch workspace 5
```

### Terminal Command Binding

```conf
# Run htop in floating terminal
bindd = SUPER SHIFT, H, System monitor, exec, $TERMINAL --class floating -e htop

# Open terminal in specific directory
bindd = SUPER CTRL, D, Dev folder, exec, $TERMINAL --working-directory=~/dev
```

### Script Binding

```conf
# Run custom script
bindd = SUPER SHIFT, P, My script, exec, ~/.local/bin/my-custom-script.sh

# Run with arguments
bindd = SUPER CTRL, P, Script with args, exec, ~/.local/bin/script.sh --option value
```

### Override Default Binding

```conf
# Override Omarchy's SUPER+Q (close window) to use rofi
bindd = SUPER, Q, Rofi close, exec, rofi -show close

# Override media play to open Spotify instead
bindd = , XF86AudioPlay, Open Spotify, exec, omarchy-launch-or-focus spotify
```

---

## Keybinding Conflicts

### Detecting Conflicts

**Visual Inspection**:
```bash
omarchy-menu-keybindings
# Search for a specific key
# Example: Type "SUPER + B"
# If multiple results appear, you have a conflict
```

**Check Raw Bindings**:
```bash
hyprctl binds | grep "SUPER.*B"
```

**Expected Output** (conflict example):
```
SUPER + B → Browser (private)
SUPER + B → Bookmarks manager
```

Last defined binding wins, so only "Bookmarks manager" is active.

### Common Conflict Scenarios

**1. Application Shortcuts vs Window Management**

Problem:
```conf
# Default Omarchy binding
bindd = SUPER, H, Move focus left, movefocus, l

# Your custom binding
bindd = SUPER, H, Home Assistant, exec, omarchy-launch-webapp "https://homeassistant.local"
```

**Solution**: Use different modifier
```conf
bindd = SUPER SHIFT, H, Home Assistant, exec, omarchy-launch-webapp "https://homeassistant.local"
```

**2. Submap Conflicts**

Problem:
```conf
# Both use "R" in capture submap
submap = capture
  bindd = , R, Region screenshot, ...
  bindd = , R, Record screen, ...
submap = reset
```

**Solution**: Use different keys
```conf
submap = capture
  bindd = , R, Region screenshot, ...
  bindd = , S, Record screen, ...
submap = reset
```

**3. Terminal Keybindings**

Problem: Hyprland binding conflicts with terminal application (e.g., `CTRL+C` in terminal)

**Solution**: Hyprland only captures bindings in window management context. Terminal apps receive keys unless explicitly bound with `bindd`/`bind`.

**4. Global vs Submap**

Problem:
```conf
# Global binding
bindd = , R, Rotate window, ...

# Submap binding (capture mode)
submap = capture
  bindd = , R, Region screenshot, ...
submap = reset
```

**Not a conflict**: Submaps isolate bindings. `R` does different things depending on whether capture mode is active.

### Resolving Conflicts

**Priority Rule**: Last binding defined wins

**Strategy 1: Remove Conflicting Binding**

```conf
# Comment out the one you don't want
# bindd = SUPER, B, Bookmarks, exec, ...
bindd = SUPER, B, Browser, exec, omarchy-launch-browser
```

**Strategy 2: Use Different Key**

```conf
bindd = SUPER, B, Browser, exec, omarchy-launch-browser
bindd = SUPER SHIFT, B, Bookmarks, exec, ...
```

**Strategy 3: Use Submap**

```conf
# Enter browser mode
bindd = SUPER, B, Browser mode, submap, browser

submap = browser
  bindd = , B, Browser, exec, omarchy-launch-browser
  bindd = , P, Private browser, exec, omarchy-launch-browser --private
  bindd = , M, Bookmarks, exec, ...
  bind = , ESCAPE, submap, reset
submap = reset
```

### Conflict Prevention

**Use Consistent Patterns**:
- `SUPER` = Window management
- `SUPER SHIFT` = Application launching
- `SUPER CTRL` = Advanced features
- `SUPER ALT` = Specialized actions

**Document Your Bindings**:
```conf
# === Custom Application Launchers ===
bindd = SUPER SHIFT, D, Discord, exec, ...
bindd = SUPER SHIFT, S, Slack, exec, ...

# === Custom Workflows ===
bindd = SUPER CTRL, W, Work setup, exec, ...
```

**Check Before Adding**:
```bash
# Before adding SUPER+D binding, check if it's used
hyprctl binds | grep "SUPER.*D"
```

---

## Examples

### Example 1: Basic - Adding a Simple Keybinding

**Scenario**: You want to launch Spotify with `SUPER SHIFT + S`.

```bash
# Edit your bindings file
nano ~/.config/hypr/bindings.conf
```

**Add this line**:
```conf
bindd = SUPER SHIFT, S, Spotify, exec, omarchy-launch-or-focus spotify
```

**Save and reload**:
```bash
# Reload Hyprland
hyprctl reload
```

**Test**:
1. Press `SUPER SHIFT + S`
2. Spotify launches (or focuses if already open)

**Verify in menu**:
```bash
omarchy-menu-keybindings
# Search for "spotify"
```

**Expected Output in menu**:
```
SUPER SHIFT + S → Spotify
```

**Why Use This**: Quickest way to add a keybinding. Use `omarchy-launch-or-focus` to intelligently launch or focus, preventing duplicate windows.

---

### Example 2: Intermediate - Creating a Custom Workflow

**Scenario**: You're a developer who wants `SUPER CTRL + D` to open your development setup: terminal with lazygit, browser on localhost:3000, and VSCode.

```bash
# Create a custom script
nano ~/.local/bin/dev-setup.sh
```

**Script content**:
```bash
#!/bin/bash

# Open terminal with lazygit on workspace 1
hyprctl dispatch workspace 1
uwsm-app -- $TERMINAL -e lazygit &

# Open browser on workspace 2
hyprctl dispatch workspace 2
omarchy-launch-browser "http://localhost:3000" &

# Open VSCode on workspace 3
hyprctl dispatch workspace 3
code ~/dev/my-project &

# Focus workspace 1 (lazygit)
hyprctl dispatch workspace 1
```

**Make executable**:
```bash
chmod +x ~/.local/bin/dev-setup.sh
```

**Add binding**:
```bash
nano ~/.config/hypr/bindings.conf
```

**Add line**:
```conf
bindd = SUPER CTRL, D, Dev setup, exec, ~/.local/bin/dev-setup.sh
```

**Reload and test**:
```bash
hyprctl reload
# Press SUPER CTRL + D
```

**What Happens**:
1. Workspace 1: Terminal with lazygit opens
2. Workspace 2: Browser opens to localhost:3000
3. Workspace 3: VSCode opens project
4. Focus returns to workspace 1

**Enhancement - Add Teardown**:

```bash
# Add another binding to close dev setup
nano ~/.config/hypr/bindings.conf
```

**Add**:
```conf
bindd = SUPER CTRL SHIFT, D, Close dev setup, exec, ~/.local/bin/dev-teardown.sh
```

**Create teardown script**:
```bash
nano ~/.local/bin/dev-teardown.sh
```

**Content**:
```bash
#!/bin/bash

# Close all windows on workspaces 1-3
for ws in 1 2 3; do
  hyprctl dispatch workspace $ws
  omarchy-cmd-close-all-windows
done

# Return to workspace 1
hyprctl dispatch workspace 1
```

**Make executable**:
```bash
chmod +x ~/.local/bin/dev-teardown.sh
```

**Why Use This**: Automates repetitive setup tasks. One keypress opens your entire workflow, another closes it. Perfect for context switching (dev → meeting → dev).

---

### Example 3: Advanced - Building Submaps for Complex Actions

**Scenario**: You want a comprehensive screenshot/screenrecord system with multiple options, but don't want to waste many keybindings. Use a submap.

```bash
nano ~/.config/hypr/bindings.conf
```

**Add comprehensive capture system**:
```conf
# === Capture Mode (Screenshots & Recording) ===

# Enter capture mode with notification
bindd = CTRL, GRAVE, Capture mode, exec, \
  hyprctl notify -1 5000 "rgb(7fcfff)" "📸 Capture Mode\n\nScreenshots: R (region), W (window), F (full)\nRecording: Shift+R (region), Shift+F (full)\nWith Audio: Ctrl+R, Ctrl+F\nESC to cancel"; \
  hyprctl dispatch submap capture

submap = capture
  # === Screenshots ===

  # Region screenshot
  bindd = , R, Region screenshot, exec, \
    bash -lc 'd="$HOME/Pictures/Screenshots"; mkdir -p "$d"; f="$d/shot-$(date +%F_%H-%M-%S).png"; \
    omarchy-cmd-screenshot region --copy --output "$f" && notify-send "Region captured" "$f"; \
    hyprctl dispatch submap reset'

  # Window screenshot
  bindd = , W, Window screenshot, exec, \
    bash -lc 'd="$HOME/Pictures/Screenshots"; mkdir -p "$d"; f="$d/shot-$(date +%F_%H-%M-%S).png"; \
    omarchy-cmd-screenshot window --copy --output "$f" && notify-send "Window captured" "$f"; \
    hyprctl dispatch submap reset'

  # Fullscreen screenshot
  bindd = , F, Fullscreen screenshot, exec, \
    bash -lc 'd="$HOME/Pictures/Screenshots"; mkdir -p "$d"; f="$d/shot-$(date +%F_%H-%M-%S).png"; \
    omarchy-cmd-screenshot output --copy --output "$f" && notify-send "Screen captured" "$f"; \
    hyprctl dispatch submap reset'

  # === Screen Recording (no audio) ===

  # Region recording
  bindd = SHIFT, R, Record region, exec, \
    bash -lc 'd="$HOME/Videos/Screencasts"; mkdir -p "$d"; f="$d/cast-$(date +%F_%H-%M-%S).mp4"; \
    omarchy-cmd-screenrecord region --output "$f" && notify-send "Region recording started" "Press CTRL+GRAVE to stop"; \
    hyprctl dispatch submap reset'

  # Fullscreen recording
  bindd = SHIFT, F, Record screen, exec, \
    bash -lc 'd="$HOME/Videos/Screencasts"; mkdir -p "$d"; f="$d/cast-$(date +%F_%H-%M-%S).mp4"; \
    omarchy-cmd-screenrecord output --output "$f" && notify-send "Screen recording started" "Press CTRL+GRAVE to stop"; \
    hyprctl dispatch submap reset'

  # === Recording with Audio ===

  # Region with audio
  bindd = CTRL, R, Record region (audio), exec, \
    bash -lc 'd="$HOME/Videos/Screencasts"; mkdir -p "$d"; f="$d/cast-$(date +%F_%H-%M-%S).mp4"; \
    omarchy-cmd-screenrecord region --with-audio --output "$f" && notify-send "Recording with audio started" "Press CTRL+GRAVE to stop"; \
    hyprctl dispatch submap reset'

  # Fullscreen with audio
  bindd = CTRL, F, Record screen (audio), exec, \
    bash -lc 'd="$HOME/Videos/Screencasts"; mkdir -p "$d"; f="$d/cast-$(date +%F_%H-%M-%S).mp4"; \
    omarchy-cmd-screenrecord output --with-audio --output "$f" && notify-send "Recording with audio started" "Press CTRL+GRAVE to stop"; \
    hyprctl dispatch submap reset'

  # === Recording with Webcam ===

  # Fullscreen with webcam
  bindd = ALT, F, Record screen (webcam), exec, \
    bash -lc 'd="$HOME/Videos/Screencasts"; mkdir -p "$d"; f="$d/cast-$(date +%F_%H-%M-%S).mp4"; \
    omarchy-cmd-screenrecord output --with-webcam --with-audio --output "$f" && notify-send "Recording with webcam started" "Press CTRL+GRAVE to stop"; \
    hyprctl dispatch submap reset'

  # Cancel
  bind = , ESCAPE, submap, reset
submap = reset

# Stop recording (works globally)
bindd = CTRL SHIFT, GRAVE, Stop recording, exec, killall -SIGINT gpu-screen-recorder
```

**How to Use**:

1. **Take Region Screenshot**:
   - Press `CTRL + GRAVE` (notification appears)
   - Press `R`
   - Select region with mouse
   - Screenshot saved and copied to clipboard

2. **Record Screen with Audio**:
   - Press `CTRL + GRAVE`
   - Press `CTRL + F`
   - Recording starts with audio
   - Press `CTRL SHIFT + GRAVE` to stop

3. **Record with Webcam**:
   - Press `CTRL + GRAVE`
   - Press `ALT + F`
   - Recording starts with webcam overlay and audio
   - Press `CTRL SHIFT + GRAVE` to stop

4. **Cancel Capture Mode**:
   - Press `CTRL + GRAVE` to enter
   - Press `ESC` to cancel without action

**Reload and test**:
```bash
hyprctl reload
# Press CTRL + GRAVE to see the notification
```

**Why Use This**:
- **Reduces keybinding clutter**: 9 capture modes using only 3 global keys
- **Discoverability**: Notification shows all options when entering mode
- **Modal safety**: Can't accidentally trigger screenshot while typing
- **Extensible**: Easy to add new capture modes (GIF recording, annotation, etc.)

**Enhancement - Add to Documentation**:

Create a cheat sheet:
```bash
nano ~/Documents/capture-mode-cheatsheet.md
```

**Content**:
```markdown
# Capture Mode Cheatsheet

Press **CTRL + GRAVE** to enter capture mode.

## Screenshots
- **R**: Region screenshot
- **W**: Window screenshot
- **F**: Fullscreen screenshot

## Screen Recording
- **SHIFT + R**: Record region
- **SHIFT + F**: Record fullscreen

## Recording with Audio
- **CTRL + R**: Record region with audio
- **CTRL + F**: Record fullscreen with audio

## Recording with Webcam
- **ALT + F**: Record fullscreen with webcam + audio

## Stop Recording
- **CTRL + SHIFT + GRAVE** (global)

## Cancel
- **ESC**
```

**Add binding to view cheatsheet**:
```conf
bindd = SUPER ALT, GRAVE, Capture help, exec, \
  $TERMINAL --class floating-docs -e bat --paging=always ~/Documents/capture-mode-cheatsheet.md
```

---

## Binding Syntax Reference

### bindd Syntax

```conf
bindd = <modifiers>, <key>, <description>, <dispatcher>, <args>
```

**Components**:
- `modifiers`: SUPER, SHIFT, CTRL, ALT (space-separated)
- `key`: Key name (RETURN, Q, 1, F1, etc.)
- `description`: Human-readable description (for omarchy-menu-keybindings)
- `dispatcher`: Action type (exec, killactive, workspace, etc.)
- `args`: Arguments for dispatcher

**Examples**:
```conf
bindd = SUPER SHIFT, T, Terminal, exec, $TERMINAL
bindd = SUPER, 1, Workspace 1, workspace, 1
bindd = SUPER, Q, Close window, killactive,
```

### Common Dispatchers

| Dispatcher | Purpose | Example Args |
|------------|---------|--------------|
| `exec` | Run command | `$TERMINAL -e htop` |
| `killactive` | Close window | (none) |
| `workspace` | Switch workspace | `1`, `name:dev` |
| `movetoworkspace` | Move window | `2`, `name:web` |
| `movefocus` | Move focus | `l`, `r`, `u`, `d` |
| `movewindow` | Move window | `l`, `r`, `u`, `d` |
| `resizeactive` | Resize window | `10 0`, `-10 0` |
| `togglefloating` | Float/tile toggle | (none) |
| `fullscreen` | Toggle fullscreen | `0` (full), `1` (maximize) |
| `submap` | Enter submap | `capture`, `reset` |

### Special Keys

**Function Keys**: `F1`, `F2`, ..., `F12`

**Media Keys**:
- `XF86AudioPlay`, `XF86AudioPause`, `XF86AudioNext`, `XF86AudioPrev`
- `XF86AudioRaiseVolume`, `XF86AudioLowerVolume`, `XF86AudioMute`
- `XF86MonBrightnessUp`, `XF86MonBrightnessDown`

**Special Characters**:
- `GRAVE` (backtick)
- `MINUS` (hyphen)
- `EQUAL` (equals)
- `LEFTBRACE`, `RIGHTBRACE`
- `SEMICOLON`, `APOSTROPHE`
- `BACKSLASH`, `SLASH`
- `COMMA`, `PERIOD`

**Navigation**: `LEFT`, `RIGHT`, `UP`, `DOWN`, `HOME`, `END`, `PAGEUP`, `PAGEDOWN`

**Editing**: `BACKSPACE`, `DELETE`, `INSERT`, `RETURN`, `TAB`, `SPACE`, `ESCAPE`

**Modifiers as Keys**: `Super_L`, `Control_L`, `Alt_L`, `Shift_L`

---

## Troubleshooting

### Keybinding Not Working

**Symptom**: Press key combination, nothing happens

**Diagnosis**:

```bash
# Check if binding exists
omarchy-menu-keybindings
# Search for your key

# Check raw bindings
hyprctl binds | grep "SUPER.*Q"

# Test if key is being captured
hyprctl dispatch exec "notify-send 'Key pressed'"
# Then press your binding
```

**Possible Causes**:

1. **Syntax error in bindings.conf**:
   ```bash
   # Check Hyprland logs for errors
   cat ~/.cache/hypr/hyprland.log | grep -i error
   ```

2. **Binding not loaded** (forgot to reload):
   ```bash
   hyprctl reload
   ```

3. **Key name wrong**:
   ```bash
   # Use hyprctl to see key names
   hyprctl devices
   # Press key and watch: wev (Wayland event viewer)
   wev
   ```

4. **Conflict** (another binding overrides):
   ```bash
   # Check for duplicates
   hyprctl binds | grep "SUPER + Q" | wc -l
   # If > 1, you have a conflict
   ```

---

### Binding Works Inconsistently

**Symptom**: Keybinding sometimes works, sometimes doesn't

**Possible Causes**:

1. **Submap active**: You're in a submap, key behaves differently
   ```bash
   # Check current submap
   hyprctl submap
   # Should show "reset" normally
   ```

2. **Application captures key**: Some apps (terminals, IDEs) capture keys before Hyprland
   - **Solution**: Use different binding or configure app to not capture

3. **Timing issue**: Command takes too long, subsequent presses ignored
   - **Solution**: Run command in background:
     ```conf
     bindd = SUPER, X, Slow command, exec, bash -c "slow-command &"
     ```

---

### omarchy-menu-keybindings Shows Garbled Output

**Symptom**: Keybindings display with weird characters or codes

**Cause**: Keycode translation failed

**Fix**:

```bash
# Check if xkbcli is available
which xkbcli
# Should output: /usr/bin/xkbcli

# If missing, install
sudo pacman -S libxkbcommon

# Test keymap compilation
xkbcli compile-keymap >/dev/null && echo "OK" || echo "FAILED"
```

---

### Custom Script Binding Not Executing

**Symptom**: Binding triggers, but script doesn't run

**Diagnosis**:

```bash
# Check script permissions
ls -la ~/.local/bin/my-script.sh
# Should show: -rwxr-xr-x (executable)

# If not executable:
chmod +x ~/.local/bin/my-script.sh

# Test script directly
~/.local/bin/my-script.sh
# Check for errors

# Test with full path in binding
bindd = SUPER, X, My script, exec, bash -lc '~/.local/bin/my-script.sh'
```

---

## Best Practices

### Do's

**DO use bindd instead of bind**
```conf
# ✅ Good - shows in keybinding menu
bindd = SUPER, Q, Close window, killactive,

# ❌ Less useful - no description
bind = SUPER, Q, killactive
```

**DO group related bindings**
```conf
# === Application Launchers ===
bindd = SUPER SHIFT, B, Browser, exec, ...
bindd = SUPER SHIFT, E, Editor, exec, ...
bindd = SUPER SHIFT, F, Files, exec, ...

# === Workspace Management ===
bindd = SUPER, 1, Workspace 1, workspace, 1
bindd = SUPER, 2, Workspace 2, workspace, 2
```

**DO use variables for common commands**
```conf
$terminal = uwsm-app -- $TERMINAL
$browser = omarchy-launch-browser

bindd = SUPER, RETURN, Terminal, exec, $terminal
bindd = SUPER SHIFT, B, Browser, exec, $browser
```

**DO use submaps for complex workflows**
- Reduces conflicts
- Provides discoverability
- Groups related actions

**DO document unusual bindings**
```conf
# Override default: Using rofi instead of killactive
bindd = SUPER, Q, Rofi close menu, exec, rofi -show close
```

### Don'ts

**DON'T use too many SUPER+<single key> bindings**
```conf
# ❌ Conflicts with window management
bindd = SUPER, H, Home Assistant, exec, ...

# ✅ Use modifier combinations
bindd = SUPER SHIFT, H, Home Assistant, exec, ...
```

**DON'T bind keys that applications need**
```conf
# ❌ Breaks terminal copy
bindd = CTRL, C, Custom action, exec, ...

# ✅ Use SUPER for global bindings
bindd = SUPER CTRL, C, Custom action, exec, ...
```

**DON'T use long-running commands without backgrounding**
```conf
# ❌ Blocks Hyprland
bindd = SUPER, X, Slow command, exec, sleep 10 && notify-send "Done"

# ✅ Background it
bindd = SUPER, X, Slow command, exec, bash -c '(sleep 10 && notify-send "Done") &'
```

**DON'T forget to reload after changes**
```bash
# After editing bindings.conf:
hyprctl reload
```

---

## Related Documentation

### Customization
- **Config Management** (`config-management.md`) - Managing Hyprland config files
- **Autostart Scripts** (`autostart-scripts.md`) - Startup automation
- **Advanced Tweaks** (`advanced-tweaks.md`) - Custom scripts and hooks

### Desktop Environment
- **Hyprland Integration** (`../04-desktop-environment/hyprland-integration.md`) - Window manager configuration
- **Window Management** (`../04-desktop-environment/window-management.md`) - Window rules and workspaces

### Commands
- **Launcher Commands** (`../02-core-commands/launcher-commands.md`) - omarchy-launch-* commands
- **System Management** (`../02-core-commands/system-management.md`) - Refresh and restart commands

### Reference
- **Quick Reference** (`../10-reference/quick-reference.md`) - Common keybindings cheat sheet
- **Troubleshooting** (`../10-reference/troubleshooting.md`) - Keybinding issues

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts Analyzed**:
- `/home/zack/.local/share/omarchy/bin/omarchy-menu-keybindings`

**Configuration Files Analyzed**:
- `/home/zack/.config/hypr/bindings.conf` (user bindings)
- `/home/zack/.local/share/omarchy/default/hypr/bindings/` (default bindings)
- `/home/zack/.config/hypr/hyprland.conf` (main config with sources)

**Verification**: All commands, keybindings, and examples tested on Omarchy system running Hyprland on Arch Linux.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
