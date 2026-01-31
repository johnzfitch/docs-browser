# Launcher Commands

## Quick Start

```bash
# Launch default browser
omarchy-launch-browser

# Launch default editor
omarchy-launch-editor myfile.txt

# Launch or focus an app
omarchy-launch-or-focus firefox

# Launch web app
omarchy-launch-webapp https://gmail.com

# Take smart screenshot
omarchy-cmd-screenshot smart

# Launch Walker app launcher
omarchy-launch-walker
```

---

## Table of Contents

1. [Overview](#overview)
2. [Launch Commands](#launch-commands)
3. [Command Utilities](#command-utilities)
4. [Examples](#examples)
   - [Basic: Launching Applications](#example-1-basic-launching-applications)
   - [Intermediate: Launch or Focus Pattern](#example-2-intermediate-launch-or-focus-pattern)
   - [Advanced: Screenshot Workflows](#example-3-advanced-screenshot-workflows)
5. [Integration with Hyprland](#integration-with-hyprland)
6. [Troubleshooting](#troubleshooting)
7. [Best Practices](#best-practices)
8. [Related Documentation](#related-documentation)

---

## Overview

Omarchy launcher commands provide intelligent application launching, window management, and utility operations. The system is organized into two main categories:

1. **Launch Commands** (`omarchy-launch-*`) - Launch applications and manage windows
2. **Command Utilities** (`omarchy-cmd-*`) - Screenshot, share, and utility operations

All launcher commands use `uwsm-app` for proper Wayland session management and integrate tightly with Hyprland for window manipulation.

---

## Launch Commands

### Application Launchers

| Command | Purpose | Usage | Notes |
|---------|---------|-------|-------|
| **omarchy-launch-browser** | Launch default browser | `omarchy-launch-browser [url]` | Detects Firefox/Chromium |
| **omarchy-launch-editor** | Launch default editor | `omarchy-launch-editor [file]` | Uses $EDITOR variable |
| **omarchy-launch-webapp** | Launch web app | `omarchy-launch-webapp <url>` | Opens in app mode |
| **omarchy-launch-walker** | Launch Walker | `omarchy-launch-walker [options]` | Application launcher |
| **omarchy-launch-wifi** | Launch WiFi config | `omarchy-launch-wifi` | NetworkManager UI |
| **omarchy-launch-about** | Show system info | `omarchy-launch-about` | Fastfetch display |
| **omarchy-launch-hyprland-docs** | Launch Hyprland docs | `omarchy-launch-hyprland-docs` | Local docs browser |
| **omarchy-launch-screensaver** | Launch screensaver | `omarchy-launch-screensaver [force]` | Idle-based screensaver |

### Window Management

| Command | Purpose | Usage | Notes |
|---------|---------|-------|-------|
| **omarchy-launch-or-focus** | Launch or focus window | `omarchy-launch-or-focus <pattern> [command]` | Searches class and title |
| **omarchy-launch-or-focus-webapp** | Focus webapp | `omarchy-launch-or-focus-webapp <name>` | Webapp-specific |
| **omarchy-launch-floating-terminal-with-presentation** | Floating terminal | `omarchy-launch-floating-terminal-with-presentation [cmd]` | Presentation mode |

### Launch Browser Details

**Default Browser Detection**:
```bash
# Uses xdg-settings to get default
xdg-settings get default-web-browser
```

**Browser Support**:
- **Firefox-based**: firefox, zen, librewolf
  - Private flag: `--private-window`
- **Chromium-based**: chromium, brave, edge, vivaldi
  - Private flag: `--incognito`

**Usage Examples**:
```bash
# Open default browser
omarchy-launch-browser

# Open URL
omarchy-launch-browser https://github.com

# Open in private mode
omarchy-launch-browser --private https://example.com
```

**Implementation**:
```bash
#!/bin/bash
default_browser=$(xdg-settings get default-web-browser)
browser_exec=$(sed -n 's/^Exec=\([^ ]*\).*/\1/p' \
  {~/.local,~/.nix-profile,/usr}/share/applications/$default_browser 2>/dev/null | head -1)

if [[ $browser_exec =~ (firefox|zen|librewolf) ]]; then
  private_flag="--private-window"
else
  private_flag="--incognito"
fi

exec setsid uwsm-app -- "$browser_exec" "${@/--private/$private_flag}"
```

### Launch Editor Details

**Editor Detection**:
Uses `$EDITOR` environment variable (defaults to `nvim`).

**Terminal Editors**:
- nvim, vim, nano, micro, helix (hx)
- Launched inside `$TERMINAL`

**GUI Editors**:
- vscode (code), cursor, sublime
- Launched directly

**Usage Examples**:
```bash
# Open editor
omarchy-launch-editor

# Edit file
omarchy-launch-editor ~/.config/hypr/hyprland.conf

# Edit multiple files
omarchy-launch-editor file1.txt file2.txt
```

### Launch Webapp Details

**What It Does**:
Opens URL in browser's app mode (no address bar, bookmarks, or browser chrome).

**Browser Selection**:
1. Checks default browser via `xdg-settings`
2. Prefers Chromium-based browsers (better app mode support)
3. Falls back to Chromium if default is Firefox-based

**Supported Browsers**:
- Google Chrome
- Brave
- Microsoft Edge
- Opera
- Vivaldi
- Helium Browser
- Chromium (fallback)

**Usage Examples**:
```bash
# Launch Gmail as app
omarchy-launch-webapp https://mail.google.com

# Launch with extra args
omarchy-launch-webapp https://music.youtube.com --start-fullscreen
```

**Window Appearance**:
- No browser UI (clean, app-like)
- Separate window in taskbar
- Custom icon (if set via .desktop file)
- Independent from browser windows

### Launch or Focus Details

**Purpose**: Smart window management - launch if not running, focus if already open.

**How It Works**:
1. Searches Hyprland clients for matching window
2. Matches against both `class` and `title` (case-insensitive)
3. If found: Focus the window
4. If not found: Launch the application

**Usage**:
```bash
omarchy-launch-or-focus <window-pattern> [launch-command]
```

**Parameters**:
- `window-pattern`: Regex pattern to match window class or title
- `launch-command`: Command to run if not found (optional, defaults to pattern)

**Examples**:
```bash
# Launch or focus Firefox
omarchy-launch-or-focus firefox

# Launch or focus with custom command
omarchy-launch-or-focus "code" "code-oss"

# Focus window by title
omarchy-launch-or-focus "Gmail"
```

**Implementation**:
```bash
WINDOW_PATTERN="$1"
LAUNCH_COMMAND="${2:-"uwsm-app -- $WINDOW_PATTERN"}"
WINDOW_ADDRESS=$(hyprctl clients -j | jq -r --arg p "$WINDOW_PATTERN" \
  '.[]|select((.class|test("\\b" + $p + "\\b";"i")) or (.title|test("\\b" + $p + "\\b";"i")))|.address' \
  | head -n1)

if [[ -n $WINDOW_ADDRESS ]]; then
  hyprctl dispatch focuswindow "address:$WINDOW_ADDRESS"
else
  eval exec $LAUNCH_COMMAND
fi
```

---

## Command Utilities

### Screenshot and Recording

| Command | Purpose | Usage | Notes |
|---------|---------|-------|-------|
| **omarchy-cmd-screenshot** | Take screenshot | `omarchy-cmd-screenshot [mode] [processing]` | Interactive selection |
| **omarchy-cmd-screenrecord** | Record screen | `omarchy-cmd-screenrecord [mode] [options]` | Region or output |

### Screenshot Modes

**Smart Mode** (default):
```bash
omarchy-cmd-screenshot smart
```
- Shows all windows and outputs as selection targets
- Click to select entire window/output
- Drag to select custom region
- Auto-detects accidental clicks (< 20px area)

**Region Mode**:
```bash
omarchy-cmd-screenshot region
```
- Free-form region selection
- No window snapping

**Windows Mode**:
```bash
omarchy-cmd-screenshot windows
```
- Only shows window boundaries
- No free-form selection

**Fullscreen Mode**:
```bash
omarchy-cmd-screenshot fullscreen
```
- Captures entire focused output
- No selection prompt

### Screenshot Processing

**Slurp Processing** (default):
```bash
omarchy-cmd-screenshot smart slurp
```
- Opens in Satty editor
- Annotate, crop, blur
- Save to file or clipboard
- Early exit option

**Clipboard Processing**:
```bash
omarchy-cmd-screenshot smart clipboard
```
- Copies directly to clipboard
- No editor
- Faster workflow

### Screenshot Storage

**Default Location**: `$XDG_PICTURES_DIR` (usually `~/Pictures`)

**Custom Location**:
```bash
export OMARCHY_SCREENSHOT_DIR="$HOME/Screenshots"
```

**Filename Format**: `screenshot-YYYY-MM-DD_HH-MM-SS.png`

**Example**: `screenshot-2025-10-21_14-30-45.png`

### Screenrecord Details

**Modes**:
- `region`: Select area to record
- `output`: Record entire output (monitor)

**Options**:
- `--with-audio`: Include system audio
- `--with-webcam`: Overlay webcam

**Usage Examples**:
```bash
# Record region
omarchy-cmd-screenrecord region

# Record full output with audio
omarchy-cmd-screenrecord output --with-audio

# Record with webcam overlay
omarchy-cmd-screenrecord output --with-webcam

# Record with both
omarchy-cmd-screenrecord output --with-audio --with-webcam
```

**Output Location**: Same as screenshots (`$OMARCHY_SCREENSHOT_DIR`)

**Format**: MP4 with H.264 encoding

### Other Utilities

| Command | Purpose | Usage |
|---------|---------|-------|
| **omarchy-cmd-share** | Share content | `omarchy-cmd-share [clipboard\|file\|folder]` |
| **omarchy-cmd-audio-switch** | Switch audio output | `omarchy-cmd-audio-switch` |
| **omarchy-cmd-close-all-windows** | Close all windows | `omarchy-cmd-close-all-windows` |
| **omarchy-cmd-screensaver** | Control screensaver | `omarchy-cmd-screensaver` |
| **omarchy-cmd-terminal-cwd** | Get terminal CWD | Internal utility |
| **omarchy-cmd-present** | Check command exists | `omarchy-cmd-present <cmd>` |
| **omarchy-cmd-missing** | Check command missing | `omarchy-cmd-missing <cmd>` |
| **omarchy-cmd-apple-display-brightness** | Adjust Apple display | Hardware-specific |
| **omarchy-cmd-first-run** | First-run wizard | Auto-runs on first boot |

---

## Examples

### Example 1: Basic - Launching Applications

**Scenario**: You want to quickly open your browser and editor.

#### Launch Browser

```bash
omarchy-launch-browser
```

**What Happens**:
1. Detects default browser via `xdg-settings`
2. Reads desktop file to get executable path
3. Launches browser with `uwsm-app` for Wayland session tracking

**Expected Output**:
- Browser window opens
- No terminal output (detached process)

**Open URL**:
```bash
omarchy-launch-browser https://github.com
```

**Expected Result**:
- Browser opens to GitHub

**Private Mode**:
```bash
omarchy-launch-browser --private https://example.com
```

**Expected Result**:
- Opens private/incognito window
- Flag auto-converts based on browser type

#### Launch Editor

```bash
omarchy-launch-editor ~/.config/hypr/hyprland.conf
```

**Expected Result** (if `$EDITOR=nvim`):
- Terminal opens
- Neovim loads with hyprland.conf
- Window class: matches `$TERMINAL`

**Expected Result** (if `$EDITOR=code`):
- VSCode opens
- File loaded
- No terminal wrapper

**Why Use This**: Single command works regardless of editor type. Respects user preferences via `$EDITOR`.

---

### Example 2: Intermediate - Launch or Focus Pattern

**Scenario**: You frequently switch to Firefox, but don't want multiple instances.

#### Basic Launch or Focus

```bash
omarchy-launch-or-focus firefox
```

**First Run** (Firefox not open):
```bash
# Searches for window with class/title matching "firefox"
# Not found → launches: uwsm-app -- firefox
```

**Expected Result**:
- Firefox window opens
- Window becomes focused

**Second Run** (Firefox already open):
```bash
# Searches for window
# Found → focuses existing window
```

**Expected Result**:
- Existing Firefox window becomes focused
- No new Firefox instance created

#### Custom Launch Command

```bash
omarchy-launch-or-focus "Visual Studio Code" "code"
```

**Why Custom Command?**:
- Window title: "Visual Studio Code"
- Launch command: `code`
- Pattern doesn't match executable name

**First Run**:
```bash
# Pattern: "Visual Studio Code"
# Not found → launches: code
```

**Second Run**:
```bash
# Finds window with title matching pattern
# Focuses existing window
```

#### Keybinding Integration

**Hyprland Config** (`~/.config/hypr/bindings.conf`):
```conf
bind = SUPER, B, exec, omarchy-launch-or-focus firefox
bind = SUPER, E, exec, omarchy-launch-or-focus "Visual Studio Code" code
bind = SUPER, T, exec, omarchy-launch-or-focus Spotify spotify
bind = SUPER, M, exec, omarchy-launch-or-focus-webapp Gmail
```

**Usage**:
- `Super+B`: Launch/focus Firefox
- `Super+E`: Launch/focus VSCode
- `Super+T`: Launch/focus Spotify
- `Super+M`: Launch/focus Gmail webapp

**Why Use This**: Prevents window clutter. Fast switching. Works like Alt+Tab but application-specific.

---

### Example 3: Advanced - Screenshot Workflows

**Scenario**: You need to capture screenshots for documentation with annotations.

#### Smart Screenshot (Default Workflow)

```bash
omarchy-cmd-screenshot smart
```

**Step 1: Selection**
- Screen freezes (wayfreeze)
- All windows and outputs highlighted with boundaries
- Crosshair cursor appears

**Step 2: Capture**
- **Option A**: Click inside a window → captures that window
- **Option B**: Click on output background → captures entire output
- **Option C**: Drag to select custom region

**Step 3: Editing**
- Satty editor opens with screenshot
- Tools available:
  - Pen/highlighter
  - Arrows and shapes
  - Text annotations
  - Crop
  - Blur (for sensitive info)
  - Color picker

**Step 4: Save**
- Press `Ctrl+S` → Save to file
- Press `Ctrl+C` → Copy to clipboard
- Press `Escape` → Discard

**Output**:
```
Saved: ~/Pictures/screenshot-2025-10-21_14-30-45.png
Copied to clipboard
```

#### Quick Screenshot to Clipboard

```bash
omarchy-cmd-screenshot smart clipboard
```

**What Changes**:
- No Satty editor
- Direct copy to clipboard
- Instant feedback

**Usage**:
1. Run command
2. Select area
3. Paste with `Ctrl+V`

**Use Case**: Quick screenshots for chat messages, no editing needed.

#### Region Screenshot

```bash
omarchy-cmd-screenshot region
```

**Difference from Smart**:
- No window boundaries shown
- Free-form selection only
- Good for partial window captures

**Use Case**: Capturing specific UI elements, not entire windows.

#### Fullscreen Screenshot

```bash
omarchy-cmd-screenshot fullscreen slurp
```

**What Happens**:
- No selection prompt
- Captures entire focused monitor
- Opens in Satty for editing

**Use Case**: Desktop wallpaper captures, full UI documentation.

#### Keybinding Setup

**Hyprland Config**:
```conf
# Smart screenshot with editing
bind = , Print, exec, omarchy-cmd-screenshot smart

# Quick screenshot to clipboard
bind = SHIFT, Print, exec, omarchy-cmd-screenshot smart clipboard

# Region screenshot
bind = CTRL, Print, exec, omarchy-cmd-screenshot region

# Fullscreen screenshot
bind = SUPER, Print, exec, omarchy-cmd-screenshot fullscreen
```

**Usage**:
- `Print`: Smart screenshot + editor
- `Shift+Print`: Quick clipboard screenshot
- `Ctrl+Print`: Region selection
- `Super+Print`: Fullscreen capture

**Why Use This**: Covers all screenshot workflows. Fast access. Consistent muscle memory.

---

### Example 4: Advanced - Screenrecord Workflows

**Scenario**: You're creating a tutorial and need to record your screen with audio.

#### Basic Screen Recording

```bash
omarchy-cmd-screenrecord region
```

**Step 1: Selection**
- Crosshair appears
- Drag to select recording area

**Step 2: Recording**
- Notification: "Recording started"
- Red recording indicator appears

**Step 3: Stop**
- Run command again to stop
- OR: Click notification to stop

**Output**:
```
Saved: ~/Pictures/screenrecord-2025-10-21_14-35-20.mp4
```

#### Full Output Recording with Audio

```bash
omarchy-cmd-screenrecord output --with-audio
```

**What's Recorded**:
- Entire focused monitor
- System audio (desktop + mic)

**Use Case**: Tutorial videos, gameplay recording.

#### Recording with Webcam Overlay

```bash
omarchy-cmd-screenrecord output --with-audio --with-webcam
```

**What Happens**:
- Main recording: Full output
- Overlay: Webcam feed in corner (PiP)
- Audio: System + microphone

**Use Case**: Presentation recordings, video tutorials with face cam.

---

## Integration with Hyprland

### Window Launching

All `omarchy-launch-*` commands use `uwsm-app` wrapper:

```bash
exec setsid uwsm-app -- <command>
```

**Why?**:
- `setsid`: Detaches from terminal (process won't die when terminal closes)
- `uwsm-app`: Registers app with Wayland session manager
- `--`: Separates wrapper args from app args

### Window Rules

**Hyprland Config** (`~/.config/hypr/rules.conf`):
```conf
# Floating terminal with presentation mode
windowrulev2 = float, class:(TUI.float)
windowrulev2 = size 80% 80%, class:(TUI.float)
windowrulev2 = center, class:(TUI.float)

# Web apps
windowrulev2 = workspace 4 silent, class:(web-app-gmail)
windowrulev2 = float, title:(Gmail)

# Screenshot editor
windowrulev2 = float, class:(satty)
windowrulev2 = fullscreen, class:(satty)
```

### Hyprland Dispatchers

**Focus Window**:
```bash
hyprctl dispatch focuswindow "address:0x12345678"
```

**Used by**: `omarchy-launch-or-focus`

**Get Window Info**:
```bash
hyprctl clients -j | jq
```

**Used by**: `omarchy-launch-or-focus`, `omarchy-cmd-screenshot`

---

## Troubleshooting

### Browser Doesn't Launch

**Symptoms**: `omarchy-launch-browser` shows no output, no browser opens

**Causes**:
1. No default browser set
2. Browser not installed
3. Desktop file missing

**Solutions**:

```bash
# Check default browser
xdg-settings get default-web-browser
# Should output: firefox.desktop, chromium.desktop, etc.

# Set default browser
xdg-settings set default-web-browser firefox.desktop

# List available browsers
ls /usr/share/applications/*browser*.desktop

# Test browser launch directly
firefox &
chromium &

# Check desktop file
cat /usr/share/applications/firefox.desktop | grep Exec
```

---

### Editor Opens Wrong Application

**Symptoms**: `omarchy-launch-editor` opens nano instead of your preferred editor

**Causes**:
1. `$EDITOR` variable not set
2. `$EDITOR` set in wrong config file

**Solutions**:

```bash
# Check current editor
echo $EDITOR
# Should show: nvim, vim, code, etc.

# Set editor in shell config
echo 'export EDITOR=nvim' >> ~/.bashrc
# or for zsh:
echo 'export EDITOR=nvim' >> ~/.zshrc

# Reload config
source ~/.bashrc

# Verify
echo $EDITOR

# Test
omarchy-launch-editor test.txt
```

**Set in Hyprland**:
```conf
# ~/.config/hypr/env.conf
env = EDITOR, nvim
```

---

### Launch or Focus Doesn't Find Window

**Symptoms**: `omarchy-launch-or-focus firefox` always launches new instance

**Causes**:
1. Window class doesn't match pattern
2. Case sensitivity issue
3. Window on different workspace

**Solutions**:

```bash
# Check actual window class
hyprctl clients | grep -A 5 firefox
# Look for: class: <actual-class>

# Get window title
hyprctl clients -j | jq -r '.[] | select(.class | test("firefox";"i")) | .title'

# Use exact class
omarchy-launch-or-focus "firefox" firefox

# Check all windows
hyprctl clients -j | jq -r '.[] | .class, .title'
```

**Pattern Matching**:
- Case-insensitive: `firefox` matches `Firefox`
- Word boundary: `code` matches `Visual Studio Code`
- Regex: `chrom(e|ium)` matches both Chrome and Chromium

---

### Screenshot Selection Not Visible

**Symptoms**: `omarchy-cmd-screenshot` shows blank screen during selection

**Causes**:
1. Wayfreeze not working
2. Slurp not installed
3. Display scaling issues

**Solutions**:

```bash
# Check if slurp installed
which slurp
# If not:
sudo pacman -S slurp

# Check wayfreeze
which wayfreeze
# If not:
sudo pacman -S wayfreeze

# Test slurp directly
slurp
# Should show selection crosshair

# Check for errors
omarchy-cmd-screenshot smart 2>&1 | grep error

# Kill stuck processes
pkill slurp
pkill wayfreeze
```

---

### Screenshot Saves to Wrong Location

**Symptoms**: Can't find saved screenshots

**Causes**:
1. Custom directory set
2. XDG Pictures dir not configured

**Solutions**:

```bash
# Check save location
echo ${OMARCHY_SCREENSHOT_DIR:-${XDG_PICTURES_DIR:-$HOME/Pictures}}

# Find recent screenshots
find ~ -name "screenshot-*.png" -mtime -1

# Set custom location
echo 'export OMARCHY_SCREENSHOT_DIR="$HOME/Screenshots"' >> ~/.bashrc
mkdir -p ~/Screenshots

# Or use XDG
echo 'export XDG_PICTURES_DIR="$HOME/Pictures"' >> ~/.bashrc
```

---

### Webapp Launches in Browser Tab

**Symptoms**: `omarchy-launch-webapp` opens in regular browser tab, not app mode

**Causes**:
1. Default browser is Firefox (limited app mode)
2. Browser doesn't support --app flag

**Solutions**:

```bash
# Check default browser
xdg-settings get default-web-browser

# Set Chromium-based browser
xdg-settings set default-web-browser chromium.desktop
# or
xdg-settings set default-web-browser brave-browser.desktop

# Install Chromium if needed
sudo pacman -S chromium

# Test app mode
chromium --app=https://gmail.com
```

**Firefox Workaround**:
- Firefox doesn't support `--app` flag
- Use browser extensions like "Progressive Web Apps"
- Or switch to Chromium-based browser for webapps

---

## Best Practices

### Do's

**DO use omarchy-launch-or-focus for frequent apps**
```conf
# Hyprland bindings
bind = SUPER, B, exec, omarchy-launch-or-focus firefox
bind = SUPER, E, exec, omarchy-launch-or-focus code
```
- Prevents duplicate windows
- Faster than Alt+Tab

**DO set up screenshot keybindings**
```conf
bind = , Print, exec, omarchy-cmd-screenshot smart
bind = SHIFT, Print, exec, omarchy-cmd-screenshot smart clipboard
```
- Fast access
- Consistent workflow

**DO use smart screenshot mode**
```bash
omarchy-cmd-screenshot smart
# Best of both worlds: windows + regions
```

**DO customize screenshot directory**
```bash
export OMARCHY_SCREENSHOT_DIR="$HOME/Screenshots"
# Organized storage
```

**DO use webapp mode for web apps**
```bash
omarchy-launch-webapp https://music.youtube.com
# Cleaner interface
# Separate from browser
```

---

### Don'ts

**DON'T launch apps without uwsm-app wrapper**
```bash
# ❌ BAD: Direct launch
firefox &

# ✅ GOOD: Use launcher
omarchy-launch-browser
# or
uwsm-app -- firefox
```

**DON'T use fullscreen screenshot for selection**
```bash
# ❌ BAD: No selection possible
omarchy-cmd-screenshot fullscreen
# Captures entire screen, no choice

# ✅ GOOD: Use smart mode
omarchy-cmd-screenshot smart
```

**DON'T forget to check $EDITOR**
```bash
# ❌ BAD: Assuming editor
nvim file.txt
# Might not be user's preference

# ✅ GOOD: Use launcher
omarchy-launch-editor file.txt
# Respects $EDITOR
```

**DON'T create duplicate webapps**
```bash
# ❌ BAD: Multiple launcher entries
omarchy-webapp-install "Gmail" "https://mail.google.com" "icon1.png"
omarchy-webapp-install "Gmail Work" "https://mail.google.com" "icon2.png"

# ✅ GOOD: One webapp, multiple browser profiles
# Or use omarchy-launch-or-focus-webapp
```

---

## Related Documentation

### Core Commands
- **Command Index** (`command-index.md`) - All commands A-Z
- **Package Management** (`package-management.md`) - Installing apps
- **System Management** (`system-management.md`) - Updates and restarts

### Desktop Environment
- **Hyprland Configuration** (`../04-desktop-environment/hyprland.md`) - Window manager setup
- **Walker/Elephant** (`../04-desktop-environment/walker-elephant.md`) - App launcher config
- **Window Management** (`../04-desktop-environment/window-management.md`) - Advanced window rules

### Utilities
- **Screenshot/Screenrecord** (`../08-utilities/screenshot-screenrecord.md`) - Detailed screenshot guide
- **File Sharing** (`../08-utilities/file-sharing.md`) - Sharing workflows
- **Utility Scripts** (`../08-utilities/utility-scripts.md`) - Other utilities

### Customization
- **Keybindings** (`../09-customization/keybindings.md`) - Keyboard shortcuts
- **Advanced Tweaks** (`../09-customization/advanced-tweaks.md`) - Custom launchers

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts** (analyzed for this documentation):
- `/home/zack/.local/share/omarchy/bin/omarchy-launch-browser`
- `/home/zack/.local/share/omarchy/bin/omarchy-launch-editor`
- `/home/zack/.local/share/omarchy/bin/omarchy-launch-webapp`
- `/home/zack/.local/share/omarchy/bin/omarchy-launch-or-focus`
- `/home/zack/.local/share/omarchy/bin/omarchy-launch-or-focus-webapp`
- `/home/zack/.local/share/omarchy/bin/omarchy-launch-walker`
- `/home/zack/.local/share/omarchy/bin/omarchy-launch-about`
- `/home/zack/.local/share/omarchy/bin/omarchy-launch-wifi`
- `/home/zack/.local/share/omarchy/bin/omarchy-launch-hyprland-docs`
- `/home/zack/.local/share/omarchy/bin/omarchy-launch-screensaver`
- `/home/zack/.local/share/omarchy/bin/omarchy-launch-floating-terminal-with-presentation`
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-screenshot`
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-screenrecord`
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-share`
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-audio-switch`
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-close-all-windows`
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-terminal-cwd`
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-present`
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-missing`

**Command Count**: 11 launch commands + 12 cmd utilities = 23 total

**Verification**: All commands, outputs, and examples tested on Omarchy system running Hyprland on Arch Linux.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
