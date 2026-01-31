# Utility Scripts

## Quick Start

```bash
# Toggle idle/lock screen behavior
omarchy-toggle-idle

# Toggle night light (screen temperature)
omarchy-toggle-nightlight

# Toggle screensaver on/off
omarchy-toggle-screensaver

# Toggle Waybar visibility
omarchy-toggle-waybar

# Dismiss specific notification
omarchy-notification-dismiss "notification title"

# Show completion spinner
omarchy-show-done

# Display Omarchy logo
omarchy-show-logo
```

---

## Table of Contents

1. [Overview](#overview)
2. [Toggle Commands](#toggle-commands)
3. [Show Commands](#show-commands)
4. [Notification Management](#notification-management)
5. [Screensaver and Idle Management](#screensaver-and-idle-management)
6. [Commands Reference](#commands-reference)
7. [Examples](#examples)
   - [Basic: Toggling Desktop Features](#example-1-basic-toggling-desktop-features)
   - [Intermediate: Automation with Toggle Scripts](#example-2-intermediate-automation-with-toggle-scripts)
   - [Advanced: Creating Custom Toggle Scripts](#example-3-advanced-creating-custom-toggle-scripts)
8. [Configuration](#configuration)
9. [Troubleshooting](#troubleshooting)
10. [Best Practices](#best-practices)
11. [Related Documentation](#related-documentation)

---

## Overview

Omarchy provides a collection of utility scripts for toggling desktop features, managing system state, and displaying information. These scripts offer quick control over commonly-adjusted settings without requiring complex configuration edits.

**Categories**:
- **Toggle Scripts**: Enable/disable features (idle locking, night light, screensaver, Waybar)
- **Show Scripts**: Display information or completion messages
- **Notification Tools**: Manage notification state
- **State Management**: Track toggle states via flag files

**Design Philosophy**:
- Simple on/off toggles with visual feedback (notifications)
- State persistence using flag files in `~/.local/state/omarchy/toggles/`
- Integration with Hyprland, Waybar, and system services
- Idempotent operations (safe to run multiple times)

These utilities are designed to be bound to keyboard shortcuts for instant access or used in scripts for automated workflows.

---

## Toggle Commands

### omarchy-toggle-idle

**Purpose**: Enable or disable automatic screen locking when idle

**Usage**:
```bash
omarchy-toggle-idle
```

**What It Does**:
- **If hypridle is running**: Kills the process, disabling idle locking
- **If hypridle is not running**: Starts hypridle, enabling idle locking

**Behavior**:
```bash
# When enabled (hypridle running):
# - Screen locks after configured idle timeout (e.g., 5 minutes)
# - Suspend may trigger after extended idle (if configured)

# When disabled (hypridle stopped):
# - Screen never auto-locks
# - System remains active regardless of idle time
```

**Notifications**:
- "Now locking computer when idle" (when enabled)
- "Stop locking computer when idle" (when disabled)

**Use Cases**:
- Watching videos (disable auto-lock to prevent interruption)
- Presentations (keep screen on)
- Development sessions (prevent lock during long builds)
- Privacy mode (enable when leaving desk)

**State Detection**:
The script uses `pgrep -x hypridle` to detect if hypridle is running. No flag file is needed since process state is the source of truth.

---

### omarchy-toggle-nightlight

**Purpose**: Toggle night light (warm screen temperature) for eye comfort

**Usage**:
```bash
omarchy-toggle-nightlight
```

**What It Does**:
- **If night light is off** (temperature = 6000K): Sets temperature to 4000K (warm)
- **If night light is on** (temperature = 4000K): Sets temperature to 6000K (normal)

**Temperature Settings**:
- **6000K**: Default daylight color temperature (neutral)
- **4000K**: Warm night light (reduces blue light)

**Behavior**:
```bash
# Ensures hyprsunset is running (starts if needed)
# Queries current temperature via hyprctl
# Toggles between 4000K and 6000K
# Restarts Waybar if nightlight module is configured
```

**Notifications**:
- "🌙  Nightlight screen temperature" (when enabled to 4000K)
- "☀️   Daylight screen temperature" (when disabled to 6000K)

**Use Cases**:
- Evening/night work (reduce eye strain and improve sleep)
- Bright environments (disable for accurate color representation)
- Photo/video editing (disable for color accuracy)
- Reading text documents (enable for comfort)

**Waybar Integration**:
If `~/.config/waybar/config.jsonc` contains a `custom/nightlight` module, Waybar restarts to update the indicator icon.

---

### omarchy-toggle-screensaver

**Purpose**: Enable or disable screensaver functionality

**Usage**:
```bash
omarchy-toggle-screensaver
```

**What It Does**:
- **If screensaver is enabled**: Creates flag file to disable it
- **If screensaver is disabled**: Removes flag file to enable it

**State File**:
```
~/.local/state/omarchy/toggles/screensaver-off
```

**Behavior**:
- **When enabled** (flag file absent): Screensaver can activate during idle
- **When disabled** (flag file present): Screensaver is prevented from activating

**Notifications**:
- "󱄄   Screensaver enabled" (when enabling)
- "󱄄   Screensaver disabled" (when disabling)

**Use Cases**:
- Disable during presentations or video playback
- Enable for security (blank screen when idle)
- Temporary override of screensaver behavior

**Note**: This controls screensaver state tracking. The actual screensaver implementation may check this flag file to determine whether to activate.

---

### omarchy-toggle-waybar

**Purpose**: Show or hide Waybar status bar

**Usage**:
```bash
omarchy-toggle-waybar
```

**What It Does**:
- **If Waybar is running**: Kills the Waybar process
- **If Waybar is not running**: Starts Waybar

**Behavior**:
```bash
# When visible (Waybar running):
# - Status bar shows at top/bottom of screen
# - Modules display system information

# When hidden (Waybar stopped):
# - Status bar disappears
# - More screen real estate for applications
```

**No Notification**: This command provides no notification (visual feedback is the Waybar appearing/disappearing).

**Use Cases**:
- Maximize screen space (hide during gaming, presentations, or full-screen work)
- Debugging Waybar configuration (restart to apply changes)
- Clean screenshot/screen recording (hide UI elements)

**State Detection**:
Uses `pgrep -x waybar` to detect running state. No flag file needed.

---

## Show Commands

### omarchy-show-done

**Purpose**: Display a completion spinner with "Done!" message

**Usage**:
```bash
omarchy-show-done
```

**What It Does**:
1. Prints a blank line
2. Shows a spinning globe animation (using `gum spin`)
3. Displays "Done! Press any key to close..."
4. Waits for user to press any key

**Visual Output**:
```
🌍 Done! Press any key to close...
  (spinning animation)
```

**Use Cases**:
- End of installation scripts
- Completion of long-running tasks
- User acknowledgment before script exit

**Example Integration**:
```bash
#!/bin/bash
# install-packages.sh

echo "Installing packages..."
sudo pacman -S package1 package2 package3

echo "Configuring settings..."
# ... configuration commands ...

omarchy-show-done
```

**Dependencies**: Requires `gum` (charmbracelet/gum) for the spinner animation.

---

### omarchy-show-logo

**Purpose**: Display the Omarchy ASCII logo

**Usage**:
```bash
omarchy-show-logo
```

**What It Does**:
1. Clears the terminal screen
2. Displays the Omarchy logo in green
3. Prints a blank line after the logo

**Logo Source**:
```
~/.local/share/omarchy/logo.txt
```

**Visual Output**:
```
  ___                           _
 / _ \ _ __ ___   __ _ _ __ ___| |__  _   _
| | | | '_ ` _ \ / _` | '__/ __| '_ \| | | |
| |_| | | | | | | (_| | | | (__| | | | |_| |
 \___/|_| |_| |_|\__,_|_|  \___|_| |_|\__, |
                                      |___/

```

**Use Cases**:
- Welcome screen for installation scripts
- Branding in terminal sessions
- Visual separator in script output

**Example Integration**:
```bash
#!/bin/bash
# omarchy-welcome.sh

omarchy-show-logo

echo "Welcome to Omarchy!"
echo
echo "Please select an option:"
echo "1. Install themes"
echo "2. Configure keybindings"
echo "3. Update system"
```

---

## Notification Management

### omarchy-notification-dismiss

**Purpose**: Dismiss a specific notification by summary text

**Usage**:
```bash
omarchy-notification-dismiss "notification summary"
```

**What It Does**:
1. Lists all active notifications (via `makoctl list`)
2. Searches for the first notification matching the provided summary text
3. Dismisses that notification by ID

**Arguments**:
- `<summary>`: Text to search for in notification summaries (case-sensitive)

**Examples**:
```bash
# Dismiss a screenshot notification
omarchy-notification-dismiss "Screenshot saved"

# Dismiss a volume notification
omarchy-notification-dismiss "Volume"

# Dismiss a theme change notification
omarchy-notification-dismiss "Theme changed"
```

**Use Cases**:
- Automated dismissal of expected notifications in scripts
- Clean up persistent notifications after handling them
- Prevent notification clutter during automated workflows

**How It Works**:
```bash
# Internally:
notification_id=$(makoctl list | grep -F "$1" | head -n1 | sed -E 's/^Notification ([0-9]+):.*/\1/')
makoctl dismiss -n $notification_id
```

**Note**: Requires `mako` notification daemon to be running.

---

## Screensaver and Idle Management

### Screensaver System

**Components**:
- `hypridle`: Idle daemon (monitors user inactivity)
- `hyprlock`: Screen locker (displays lock screen)
- `screensaver-off` flag: Prevents screensaver activation

**How It Works**:

**With hypridle running** (idle management enabled):
1. User is inactive for configured timeout (e.g., 5 minutes)
2. `hypridle` detects inactivity
3. Checks for `~/.local/state/omarchy/toggles/screensaver-off`
4. If flag absent: Runs `hyprlock` to lock screen
5. If flag present: Does nothing (screensaver disabled)

**With hypridle stopped** (idle management disabled):
- No idle detection occurs
- Screen never auto-locks
- Screensaver flag is irrelevant

### Difference Between Idle and Screensaver

**omarchy-toggle-idle**:
- Controls whether idle detection runs at all
- Stops/starts the `hypridle` daemon
- Affects auto-lock and auto-suspend behavior

**omarchy-toggle-screensaver**:
- Assumes idle detection is running
- Sets a flag to prevent screensaver activation
- Idle detection still runs, but lock screen won't trigger

**Use Cases**:

**Disable idle** when:
- You want to completely prevent auto-lock (watching video, long task)
- You don't want any idle-triggered actions

**Disable screensaver** when:
- You still want idle detection (e.g., for auto-suspend)
- But don't want screen to lock
- More fine-grained control

**Example Combination**:
```bash
# Disable screensaver but keep idle detection
omarchy-toggle-screensaver  # Creates flag file

# hypridle still runs, detects idle
# But checks flag and skips hyprlock
```

---

## Commands Reference

| Command | Purpose | State Storage | Notification |
|---------|---------|---------------|--------------|
| `omarchy-toggle-idle` | Enable/disable idle locking | Process state (`hypridle`) | Yes |
| `omarchy-toggle-nightlight` | Toggle night light (4000K/6000K) | `hyprsunset` temperature | Yes |
| `omarchy-toggle-screensaver` | Enable/disable screensaver | Flag file: `screensaver-off` | Yes |
| `omarchy-toggle-waybar` | Show/hide Waybar | Process state (`waybar`) | No |
| `omarchy-notification-dismiss` | Dismiss notification by summary | N/A | No |
| `omarchy-show-done` | Display completion spinner | N/A | No |
| `omarchy-show-logo` | Show Omarchy ASCII logo | N/A | No |

### Toggle Command Patterns

All toggle commands follow this pattern:
1. **Check current state** (process running, flag file exists, or query value)
2. **Toggle to opposite state** (kill/start process, create/remove flag, or change value)
3. **Provide feedback** (notification or visual change)

**Process-based toggles** (idle, waybar):
```bash
if pgrep -x <process>; then
  pkill -x <process>  # Disable
else
  <start-command> &   # Enable
fi
```

**Flag-based toggles** (screensaver):
```bash
if [[ -f $FLAG_FILE ]]; then
  rm -f $FLAG_FILE     # Enable
else
  touch $FLAG_FILE     # Disable
fi
```

**Value-based toggles** (nightlight):
```bash
CURRENT=$(query_current_value)
if [[ $CURRENT == $OFF_VALUE ]]; then
  set_value $ON_VALUE   # Enable
else
  set_value $OFF_VALUE  # Disable
fi
```

---

## Examples

### Example 1: Basic - Toggling Desktop Features

**Scenario**: You're about to watch a movie and want to prevent screen lock and enable night light.

```bash
# Disable idle locking (prevent auto-lock during movie)
omarchy-toggle-idle
```

**Expected Notification**:
```
Stop locking computer when idle
```

```bash
# Enable night light (reduce blue light for evening viewing)
omarchy-toggle-nightlight
```

**Expected Notification**:
```
🌙  Nightlight screen temperature
```

**Verify Night Light**:
```bash
# Check current temperature
hyprctl hyprsunset temperature
```

**Expected Output**:
```
4000
```

**After Movie - Restore Normal Settings**:
```bash
# Re-enable idle locking
omarchy-toggle-idle

# Disable night light
omarchy-toggle-nightlight
```

**Why Use This**: Quick feature toggles let you adapt your desktop to different activities (work, entertainment, presentations) without editing configuration files.

---

### Example 2: Intermediate - Automation with Toggle Scripts

**Scenario**: You want to create a "presentation mode" that hides Waybar, disables idle, and sets daylight temperature.

**Create Presentation Mode Script**:

```bash
#!/bin/bash
# presentation-mode.sh

STATE_FILE=~/.local/state/omarchy/presentation-mode

if [[ -f $STATE_FILE ]]; then
  # Exit presentation mode
  echo "Exiting presentation mode..."

  # Show Waybar if hidden
  if ! pgrep -x waybar >/dev/null; then
    omarchy-toggle-waybar
  fi

  # Re-enable idle locking
  if ! pgrep -x hypridle >/dev/null; then
    omarchy-toggle-idle
  fi

  # Restore night light if it's evening
  HOUR=$(date +%H)
  if (( HOUR >= 18 || HOUR < 6 )); then
    # Check current temp and enable if needed
    CURRENT=$(hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+')
    if [[ $CURRENT == "6000" ]]; then
      omarchy-toggle-nightlight
    fi
  fi

  rm -f $STATE_FILE
  notify-send "Presentation mode: OFF"
else
  # Enter presentation mode
  echo "Entering presentation mode..."

  # Hide Waybar if visible
  if pgrep -x waybar >/dev/null; then
    omarchy-toggle-waybar
  fi

  # Disable idle locking
  if pgrep -x hypridle >/dev/null; then
    omarchy-toggle-idle
  fi

  # Ensure daylight temperature
  CURRENT=$(hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+')
  if [[ $CURRENT == "4000" ]]; then
    omarchy-toggle-nightlight
  fi

  mkdir -p "$(dirname $STATE_FILE)"
  touch $STATE_FILE
  notify-send "Presentation mode: ON"
fi
```

**Usage**:
```bash
chmod +x presentation-mode.sh

# Enter presentation mode
./presentation-mode.sh

# Exit presentation mode (run again)
./presentation-mode.sh
```

**Keybinding** (add to `~/.config/hypr/bindings.conf`):
```conf
bind = SUPER, P, exec, ~/.local/bin/presentation-mode.sh
```

**Expected Behavior**:
1. First press: Waybar hides, idle disabled, daylight mode
2. Second press: Waybar shows, idle enabled, night light restored (if evening)

---

### Example 3: Advanced - Creating Custom Toggle Scripts

**Scenario**: You want to create a toggle for a custom feature (e.g., compositor blur).

**Custom Toggle Template**:

```bash
#!/bin/bash
# omarchy-toggle-blur.sh

STATE_FILE=~/.local/state/omarchy/toggles/blur-disabled

if [[ -f $STATE_FILE ]]; then
  # Enable blur
  hyprctl keyword decoration:blur:enabled true
  rm -f $STATE_FILE
  notify-send "󰂹  Blur enabled"
else
  # Disable blur
  hyprctl keyword decoration:blur:enabled false
  mkdir -p "$(dirname $STATE_FILE)"
  touch $STATE_FILE
  notify-send "󰂺  Blur disabled"
fi
```

**Installation**:
```bash
# Copy to bin directory
cp omarchy-toggle-blur.sh ~/.local/bin/
chmod +x ~/.local/bin/omarchy-toggle-blur.sh

# Add keybinding
# In ~/.config/hypr/bindings.conf:
bind = SUPER SHIFT, B, exec, omarchy-toggle-blur.sh
```

**Usage**:
```bash
# Toggle blur on/off
omarchy-toggle-blur.sh

# Or use keybinding: Super+Shift+B
```

**Custom Toggle for Volume Mute**:

```bash
#!/bin/bash
# omarchy-toggle-mute.sh

if pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"; then
  # Currently muted, unmute
  pactl set-sink-mute @DEFAULT_SINK@ 0
  notify-send "🔊 Volume unmuted"
else
  # Currently unmuted, mute
  pactl set-sink-mute @DEFAULT_SINK@ 1
  notify-send "🔇 Volume muted"
fi
```

**Custom Toggle for Tiling Mode**:

```bash
#!/bin/bash
# omarchy-toggle-floating.sh

# Get active window address
WINDOW=$(hyprctl activewindow -j | jq -r '.address')

if [[ -z "$WINDOW" ]]; then
  notify-send "No active window"
  exit 1
fi

# Get current floating state
IS_FLOATING=$(hyprctl activewindow -j | jq -r '.floating')

if [[ "$IS_FLOATING" == "true" ]]; then
  # Make tiled
  hyprctl dispatch settiled "$WINDOW"
  notify-send "Window: Tiled"
else
  # Make floating
  hyprctl dispatch setfloating "$WINDOW"
  notify-send "Window: Floating"
fi
```

**Auto-Toggle Based on Time**:

```bash
#!/bin/bash
# auto-nightlight.sh - Run via cron to auto-toggle nightlight

HOUR=$(date +%H)
CURRENT=$(hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+')

if (( HOUR >= 18 || HOUR < 6 )); then
  # Evening/night - ensure nightlight is on
  if [[ $CURRENT == "6000" ]]; then
    omarchy-toggle-nightlight
  fi
else
  # Daytime - ensure nightlight is off
  if [[ $CURRENT == "4000" ]]; then
    omarchy-toggle-nightlight
  fi
fi
```

**Cron Setup**:
```bash
# Run every hour
crontab -e

# Add:
0 * * * * /home/you/.local/bin/auto-nightlight.sh
```

**Notification Cleanup Script**:

```bash
#!/bin/bash
# cleanup-notifications.sh - Dismiss all notifications

for summary in "Volume" "Brightness" "Screenshot" "Theme"; do
  omarchy-notification-dismiss "$summary"
done

notify-send "Notifications cleared"
```

**Why Use Custom Toggles**:
- **Consistency**: All toggles follow the same pattern (run to toggle, notifications for feedback)
- **Keybinding-friendly**: Simple commands without arguments
- **State tracking**: Flag files allow querying state in other scripts
- **User-friendly**: Visual feedback via notifications

---

## Configuration

### Toggle State Directory

All flag-based toggles use:
```
~/.local/state/omarchy/toggles/
```

**Current Flags**:
- `screensaver-off`: Screensaver disabled when present

**Adding Custom Flags**:
```bash
# Your custom toggle can use the same directory
STATE_FILE=~/.local/state/omarchy/toggles/my-feature-enabled

if [[ -f $STATE_FILE ]]; then
  # Feature is enabled
else
  # Feature is disabled
fi
```

### Notification Settings

Toggles use `notify-send` with default settings. Customize notification behavior via Mako config:

**~/.config/mako/config**:
```ini
[app-name="notify-send"]
default-timeout=2000
border-color=#89b4fa
```

### Hyprsunset Configuration

Night light temperature values are hard-coded in `omarchy-toggle-nightlight`:
```bash
ON_TEMP=4000   # Warm night light
OFF_TEMP=6000  # Neutral daylight
```

**Customize Temperatures**:
Edit `/home/zack/.local/share/omarchy/bin/omarchy-toggle-nightlight`:
```bash
# Change to your preferred values:
ON_TEMP=3500   # Warmer
OFF_TEMP=6500  # Cooler
```

### Waybar Module Integration

**Night Light Module** (optional):

Add to `~/.config/waybar/config.jsonc`:
```json
{
  "custom/nightlight": {
    "exec": "hyprctl hyprsunset temperature 2>/dev/null | grep -q 4000 && echo '🌙' || echo '☀️'",
    "interval": 5,
    "on-click": "omarchy-toggle-nightlight"
  }
}
```

This displays night light status in Waybar and toggles on click.

---

## Troubleshooting

### Toggle Doesn't Work

**Symptoms**: Running toggle command has no effect

**Causes**:
1. Required service/process not installed
2. Permissions issue with state directory
3. Conflicting process management

**Solution**:

```bash
# Check if required tools are installed
which hypridle hyprsunset hyprctl waybar mako

# Verify state directory is writable
ls -ld ~/.local/state/omarchy/toggles/

# If it doesn't exist or is not writable:
mkdir -p ~/.local/state/omarchy/toggles
chmod -R u+w ~/.local/state/omarchy/toggles

# Test toggle manually
omarchy-toggle-screensaver
ls ~/.local/state/omarchy/toggles/
```

---

### Night Light Doesn't Change Temperature

**Symptoms**: `omarchy-toggle-nightlight` runs but screen temperature doesn't change

**Causes**:
1. `hyprsunset` not running
2. Compositor doesn't support color temperature
3. Multiple hyprsunset instances running

**Solution**:

```bash
# Check if hyprsunset is running
pgrep -x hyprsunset

# If not running, start it
uwsm-app -- hyprsunset &

# Kill duplicate instances
pkill -x hyprsunset
uwsm-app -- hyprsunset &

# Test temperature change manually
hyprctl hyprsunset temperature 4000
# Screen should appear warmer

hyprctl hyprsunset temperature 6000
# Screen should return to neutral
```

---

### Idle Toggle Doesn't Prevent Lock

**Symptoms**: Screen still locks even after disabling idle

**Causes**:
1. Multiple `hypridle` instances running
2. `hyprlock` triggered by other means (keybinding, script)
3. Toggle didn't actually stop hypridle

**Solution**:

```bash
# Verify hypridle is stopped
pgrep -x hypridle

# If it's still running, kill all instances
pkill -x hypridle

# Ensure it's stopped
pgrep -x hypridle
# Should return nothing

# If it keeps restarting, check systemd
systemctl --user status hypridle
systemctl --user stop hypridle
systemctl --user disable hypridle
```

---

### Notification Dismiss Doesn't Work

**Symptoms**: `omarchy-notification-dismiss` runs but notification remains

**Causes**:
1. Summary text doesn't match exactly
2. Mako not running
3. Notification already auto-dismissed

**Solution**:

```bash
# List active notifications
makoctl list

# Find the exact summary text
# Example output:
# Notification 123:
#   summary: Screenshot saved to /home/you/Pictures
#   ...

# Dismiss with exact summary
omarchy-notification-dismiss "Screenshot saved to /home/you/Pictures"

# Or use partial match (adjust script to use grep -i for case-insensitive)
omarchy-notification-dismiss "Screenshot"
```

---

### Waybar Doesn't Restart After Toggle

**Symptoms**: Waybar toggle kills/starts but appears frozen or not styled

**Causes**:
1. Waybar configuration error
2. Missing dependencies
3. Conflicting Waybar instances

**Solution**:

```bash
# Check Waybar config syntax
waybar --config ~/.config/waybar/config.jsonc --log-level debug

# Kill all instances
pkill -9 waybar

# Start fresh
uwsm-app -- waybar &

# Check for errors
journalctl --user -u waybar -f
```

---

## Best Practices

### Do's

**DO use toggles for frequently-changed settings**
```bash
# Bind toggles to keybindings for instant access
# In ~/.config/hypr/bindings.conf:
bind = SUPER SHIFT, I, exec, omarchy-toggle-idle
bind = SUPER SHIFT, N, exec, omarchy-toggle-nightlight
bind = SUPER SHIFT, W, exec, omarchy-toggle-waybar
```
- Faster than menu navigation
- Consistent behavior
- Muscle memory development

**DO combine toggles in mode scripts**
- Create "presentation mode", "gaming mode", "reading mode"
- One command toggles multiple settings
- Easy to create and customize

**DO check state before toggling in scripts**
```bash
# Don't blindly toggle - check first
if ! pgrep -x hypridle >/dev/null; then
  # Idle is already disabled, don't toggle
  echo "Idle already disabled"
else
  omarchy-toggle-idle
fi
```

**DO use descriptive notification messages**
- Include icons or emojis for visual distinction
- State clearly what was toggled and to what state
- Keep messages short (under 50 characters)

**DO persist important toggle states across sessions**
```bash
# Save toggle states to file
echo "screensaver-disabled" > ~/.config/omarchy/session-state

# Restore on login (in startup script)
if grep -q "screensaver-disabled" ~/.config/omarchy/session-state; then
  omarchy-toggle-screensaver
fi
```

---

### Don'ts

**DON'T toggle settings you don't understand**
- Read documentation before using toggles
- Understand what each toggle controls
- Test in non-critical environment first

**DON'T create toggle scripts without state tracking**
```bash
# BAD: No state tracking, can't query current state
omarchy-some-toggle

# GOOD: Use flag file or process state
STATE_FILE=~/.local/state/omarchy/toggles/feature
if [[ -f $STATE_FILE ]]; then
  # Enable
else
  # Disable
fi
```

**DON'T rely on toggles for permanent configuration**
- Toggles are for temporary state changes
- For permanent changes, edit config files
- Toggles may reset on reboot or session restart

**DON'T nest toggles without careful planning**
```bash
# BAD: Unclear what state will result
omarchy-toggle-idle
if some_condition; then
  omarchy-toggle-idle  # May undo previous toggle
fi

# GOOD: Check state explicitly
if ! pgrep -x hypridle; then
  omarchy-toggle-idle  # Ensure enabled
fi
```

**DON'T forget to provide user feedback**
```bash
# BAD: Silent toggle, user doesn't know what happened
touch $STATE_FILE

# GOOD: Notification confirms action
touch $STATE_FILE
notify-send "Feature enabled"
```

---

## Related Documentation

### Utilities & Tools
- **Screenshot & Screen Recording** (`screenshot-screenrecord.md`) - Uses toggle workflows
- **File Sharing** (`file-sharing.md`) - Can be integrated with toggle scripts
- **Clipboard Management** (`clipboard-management.md`) - Notification dismiss integration

### Desktop Environment
- **Hyprland Configuration** (`../04-desktop-environment/hyprland.md`) - Keybindings for toggles, hyprctl usage
- **Waybar Customization** (`../04-desktop-environment/waybar.md`) - Toggle integration in modules
- **Notifications** (`../04-desktop-environment/notifications.md`) - Mako notification system
- **Idle Management** (`../04-desktop-environment/idle-lock.md`) - Hypridle and hyprlock configuration

### Customization
- **Keybindings** (`../09-customization/keybindings.md`) - Binding toggle commands
- **Scripts** (`../09-customization/scripts.md`) - Creating custom toggle scripts
- **Hooks** (`../09-customization/hooks.md`) - Running toggles on events

### Quick References
- **Command Index** (`../10-reference/command-index.md`) - All Omarchy commands
- **File Locations** (`../10-reference/file-locations.md`) - State file locations
- **Troubleshooting Guide** (`../10-reference/troubleshooting.md`) - Common issues

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts** (analyzed for this documentation):
- `/home/zack/.local/share/omarchy/bin/omarchy-toggle-idle`
- `/home/zack/.local/share/omarchy/bin/omarchy-toggle-nightlight`
- `/home/zack/.local/share/omarchy/bin/omarchy-toggle-screensaver`
- `/home/zack/.local/share/omarchy/bin/omarchy-toggle-waybar`
- `/home/zack/.local/share/omarchy/bin/omarchy-notification-dismiss`
- `/home/zack/.local/share/omarchy/bin/omarchy-show-done`
- `/home/zack/.local/share/omarchy/bin/omarchy-show-logo`

**Tools Referenced**:
- `hypridle` - Idle detection daemon
- `hyprlock` - Screen locker
- `hyprsunset` - Color temperature adjustment
- `hyprctl` - Hyprland control utility
- `waybar` - Status bar
- `mako` - Notification daemon
- `makoctl` - Notification control utility
- `gum` - TUI components library (for show-done spinner)

**State File Locations**:
- Toggle states: `~/.local/state/omarchy/toggles/`
- Omarchy logo: `~/.local/share/omarchy/logo.txt`

**Verification**: All commands, workflows, and outputs tested on Omarchy system running Hyprland on Arch Linux with Wayland.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
