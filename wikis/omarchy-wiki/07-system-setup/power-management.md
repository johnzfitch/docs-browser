# Power Management

## Quick Start

```bash
# Monitor battery status (runs automatically)
omarchy-battery-monitor

# List available power profiles
omarchy-powerprofiles-list

# Set power profile (via GUI or CLI)
powerprofilesctl set power-saver
powerprofilesctl set balanced
powerprofilesctl set performance

# Check current power profile
powerprofilesctl get

# Configure idle and suspend timers
nano ~/.config/hypr/hypridle.conf

# Restart idle daemon to apply changes
omarchy-restart-hypridle
```

---

## Table of Contents

1. [Overview](#overview)
2. [Battery Monitoring](#battery-monitoring)
   - [Automatic Monitoring](#automatic-monitoring)
   - [Battery Status Display](#battery-status-display)
3. [Power Profiles](#power-profiles)
   - [Available Profiles](#available-profiles)
   - [Switching Profiles](#switching-profiles)
   - [Profile Comparison](#profile-comparison)
4. [Idle and Suspend Management](#idle-and-suspend-management)
   - [Hypridle Configuration](#hypridle-configuration)
   - [Suspend Behavior](#suspend-behavior)
   - [Hibernation](#hibernation)
5. [Examples](#examples)
   - [Basic: Switching Power Profiles for Battery Life](#example-1-basic-switching-power-profiles-for-battery-life)
   - [Intermediate: Custom Idle Timers](#example-2-intermediate-custom-idle-timers)
   - [Advanced: Battery Optimization Workflow](#example-3-advanced-battery-optimization-workflow)
6. [Power Optimization Tips](#power-optimization-tips)
7. [Troubleshooting](#troubleshooting)
8. [Related Documentation](#related-documentation)

---

## Overview

Omarchy provides comprehensive power management for laptops and desktops, integrating Linux power subsystems with desktop environment controls. The power management stack includes:

- **Battery monitoring**: Automatic low-battery warnings via systemd timer
- **Power profiles**: CPU governor and performance tuning via `power-profiles-daemon`
- **Idle management**: Automatic screen lock, screensaver, and display sleep via `hypridle`
- **Suspend/hibernate**: System sleep with pre-sleep hooks for locking

**Key Components**:

| Component | Purpose | Configuration |
|-----------|---------|---------------|
| `omarchy-battery-monitor` | Low battery alerts | Systemd timer (30s interval) |
| `power-profiles-daemon` | CPU/GPU power profiles | System service |
| `hypridle` | Idle detection and actions | `~/.config/hypr/hypridle.conf` |
| `systemd-logind` | Suspend/hibernate triggers | `/etc/systemd/logind.conf` |

**Power Management Flow**:

1. **Active use**: System runs at selected power profile (performance/balanced/power-saver)
2. **2.5 min idle**: Screensaver launches (Matrix rain)
3. **5 min idle**: Screen locks (hyprlock)
4. **5.5 min idle**: Displays turn off (DPMS)
5. **Lid close / low battery**: System suspends to RAM
6. **Critical battery**: System hibernates to disk (optional)

---

## Battery Monitoring

### Automatic Monitoring

#### omarchy-battery-monitor

Monitors battery level and sends critical notifications when low.

**Purpose**: Alert user before laptop dies unexpectedly

**Usage**: Runs automatically via systemd timer (no manual execution needed)

**Configuration**:

The script runs every 30 seconds via:

```bash
systemctl --user status omarchy-battery-monitor.timer
```

**Script Behavior**:

```bash
#!/bin/bash

# Designed to be run by systemd timer every 30 seconds and alerts if battery is low

BATTERY_THRESHOLD=10
NOTIFICATION_FLAG="/run/user/$UID/omarchy_battery_notified"

get_battery_percentage() {
  upower -i "$(upower -e | grep 'BAT')" \
  | awk -F: '/percentage/ {
      gsub(/[%[:space:]]/, "", $2);
      val=$2;
      printf("%d\n", (val+0.5))
      exit
    }'
}

get_battery_state() {
  upower -i $(upower -e | grep 'BAT') | grep -E "state" | awk '{print $2}'
}

send_notification() {
  notify-send -u critical "󱐋 Time to recharge!" "Battery is down to ${1}%" -i battery-caution -t 30000
}

BATTERY_LEVEL=$(get_battery_percentage)
BATTERY_STATE=$(get_battery_state)

if [[ "$BATTERY_STATE" == "discharging" && "$BATTERY_LEVEL" -le "$BATTERY_THRESHOLD" ]]; then
  if [[ ! -f "$NOTIFICATION_FLAG" ]]; then
    send_notification "$BATTERY_LEVEL"
    touch "$NOTIFICATION_FLAG"
  fi
else
  rm -f "$NOTIFICATION_FLAG"
fi
```

**How It Works**:

1. **Check battery every 30s**: Systemd timer triggers script
2. **Get battery level**: Uses `upower` to query battery percentage
3. **Check state**: Only alert if discharging (not charging/full)
4. **Threshold check**: Alert if ≤10% battery remaining
5. **Send notification**: Critical notification with 30-second timeout
6. **Prevent spam**: Use flag file to only notify once until recharged

**Customizing Alert Threshold**:

Edit the script:

```bash
sudo nano /home/zack/.local/share/omarchy/bin/omarchy-battery-monitor
```

Change threshold:

```bash
BATTERY_THRESHOLD=15  # Alert at 15% instead of 10%
```

**Restart timer**:

```bash
systemctl --user restart omarchy-battery-monitor.timer
```

**Disabling Battery Monitoring** (desktop users):

```bash
systemctl --user disable omarchy-battery-monitor.timer
systemctl --user stop omarchy-battery-monitor.timer
```

---

### Battery Status Display

Battery status is shown in Waybar (status bar) and system tray.

**Waybar Battery Module**:

Located in `~/.config/waybar/config.jsonc`:

```json
"battery": {
  "states": {
    "warning": 30,
    "critical": 15
  },
  "format": "{icon} {capacity}%",
  "format-charging": " {capacity}%",
  "format-plugged": " {capacity}%",
  "format-icons": ["", "", "", "", ""]
}
```

**Visual Indicators**:

| Battery Level | Icon | Color |
|---------------|------|-------|
| 80-100% | 󰁹 | Normal |
| 60-79% | 󰂀 | Normal |
| 40-59% | 󰁾 | Normal |
| 15-39% | 󰁼 | Yellow (warning) |
| 0-14% | 󰁺 | Red (critical) |
| Charging | 󰂄 | Green |

**Checking Battery Info Manually**:

```bash
# Detailed battery info
upower -i $(upower -e | grep BAT)

# Quick percentage
upower -i $(upower -e | grep BAT) | grep percentage

# Battery state (charging/discharging/full)
upower -i $(upower -e | grep BAT) | grep state

# Time remaining
upower -i $(upower -e | grep BAT) | grep "time to"
```

**Example Output**:

```
native-path:          BAT0
vendor:               SMP
model:                01AV448
serial:               4171
power supply:         yes
updated:              Mon 21 Oct 2025 02:30:15 PM PDT (5 seconds ago)
has history:          yes
has statistics:       yes
battery
  present:             yes
  rechargeable:        yes
  state:               discharging
  warning-level:       none
  energy:              22.68 Wh
  energy-empty:        0 Wh
  energy-full:         45.36 Wh
  energy-full-design:  48.96 Wh
  energy-rate:         8.505 W
  voltage:             11.82 V
  time to empty:       2.7 hours
  percentage:          50%
  capacity:            92.6471%
  technology:          lithium-polymer
```

---

## Power Profiles

### Available Profiles

Omarchy uses `power-profiles-daemon` to manage system power states via CPU governors and device power policies.

#### omarchy-powerprofiles-list

Lists available power profiles in reverse order (performance first).

**Usage**:
```bash
omarchy-powerprofiles-list
```

**Expected Output**:
```
performance
balanced
power-saver
```

**Script**:

```bash
#!/bin/bash

powerprofilesctl list |
  awk '/^\s*[* ]\s*[a-zA-Z0-9\-]+:$/ { gsub(/^[*[:space:]]+|:$/,""); print }' |
  tac
```

**What It Does**:
- Runs `powerprofilesctl list`
- Parses profile names
- Reverses order (most aggressive first)

---

### Switching Profiles

Use `powerprofilesctl` to change power profiles:

```bash
# Set power profile
powerprofilesctl set performance
powerprofilesctl set balanced
powerprofilesctl set power-saver

# Get current profile
powerprofilesctl get
```

**GUI Method**:

Power profiles can also be changed via the Waybar system tray or GNOME Settings (if installed).

---

### Profile Comparison

| Profile | CPU Governor | CPU Frequency | GPU Power | Use Case | Battery Impact |
|---------|--------------|---------------|-----------|----------|----------------|
| **Performance** | `performance` | Max frequency (turbo enabled) | High performance | Gaming, video editing, compiling | -40% battery life |
| **Balanced** | `powersave` | Dynamic (on-demand scaling) | Balanced | General use, web browsing | Baseline |
| **Power Saver** | `powersave` | Capped frequency (turbo disabled) | Minimal | Travel, light tasks | +25% battery life |

**Detailed Behavior**:

**Performance Mode**:
- **CPU**: Always runs at maximum frequency (e.g., 4.5 GHz turbo)
- **GPU**: Full performance mode, no power gating
- **Devices**: USB, PCIe, SATA run at full speed
- **Fans**: May spin up more frequently
- **Screen**: No brightness reduction

**Use when**:
- Gaming (high FPS)
- Video rendering
- Compiling large projects
- Plugged into AC power

**Balanced Mode** (default):
- **CPU**: Scales frequency based on load (1.2 GHz idle → 4.5 GHz under load)
- **GPU**: Power gating enabled, scales with usage
- **Devices**: USB auto-suspend after 2s idle
- **Fans**: Balanced curve
- **Screen**: Normal brightness

**Use when**:
- General desktop use
- Web browsing
- Coding (non-intensive)
- Watching videos

**Power Saver Mode**:
- **CPU**: Capped at base frequency (e.g., 2.8 GHz, no turbo)
- **GPU**: Aggressive power gating, reduced clocks
- **Devices**: Aggressive USB/PCIe power management
- **Fans**: Reduced fan speed (quieter)
- **Screen**: May dim slightly (configurable)

**Use when**:
- Traveling without charger
- Low battery (<30%)
- Background tasks only
- Reducing heat/noise

---

**Checking Current Profile**:

```bash
powerprofilesctl get
```

**Example Output**:
```
balanced
```

**Automatically Switch on AC/Battery**:

You can create a script to auto-switch profiles based on power state:

```bash
#!/bin/bash
# ~/.local/bin/auto-power-profile

if upower -i $(upower -e | grep BAT) | grep -q "state: *discharging"; then
  powerprofilesctl set power-saver
else
  powerprofilesctl set balanced
fi
```

**Run on AC plug/unplug** via udev rule or systemd-logind hook.

---

## Idle and Suspend Management

### Hypridle Configuration

Hypridle manages idle detection and triggers actions like screensaver, lock, and display sleep.

**Configuration File**: `~/.config/hypr/hypridle.conf`

**Default Configuration**:

```conf
general {
    lock_cmd = omarchy-lock-screen                         # lock screen and 1password
    before_sleep_cmd = loginctl lock-session               # lock before suspend.
    after_sleep_cmd = hyprctl dispatch dpms on             # to avoid having to press a key twice to turn on the display.
    inhibit_sleep = 3                                      # wait until screen is locked
}

listener {
    timeout = 150                                             # 2.5min
    on-timeout = pidof hyprlock || omarchy-launch-screensaver # start screensaver (if we haven't locked already)
}

listener {
    timeout = 300                      # 5min
    on-timeout = loginctl lock-session # lock screen when timeout has passed
}

listener {
    timeout = 330                                            # 5.5min
    on-timeout = hyprctl dispatch dpms off                   # screen off when timeout has passed
    on-resume = hyprctl dispatch dpms on && brightnessctl -r # screen on when activity is detected
}
```

**Timeline Breakdown**:

| Time | Action | Command |
|------|--------|---------|
| **0 min** | Active use | - |
| **2.5 min** | Screensaver starts | `omarchy-launch-screensaver` |
| **5 min** | Screen locks | `omarchy-lock-screen` |
| **5.5 min** | Displays turn off | `hyprctl dispatch dpms off` |
| **On activity** | Displays turn on | `hyprctl dispatch dpms on` + restore brightness |

**Customizing Timers**:

Edit `~/.config/hypr/hypridle.conf`:

```bash
nano ~/.config/hypr/hypridle.conf
```

**Example: Faster lock (3 minutes)**:

```conf
listener {
    timeout = 180  # 3 min instead of 5 min
    on-timeout = loginctl lock-session
}

listener {
    timeout = 210  # 3.5 min instead of 5.5 min
    on-timeout = hyprctl dispatch dpms off
    on-resume = hyprctl dispatch dpms on && brightnessctl -r
}
```

**Restart hypridle**:

```bash
omarchy-restart-hypridle
```

**Disable Screensaver Only** (keep lock/sleep):

Comment out the screensaver listener:

```conf
# listener {
#     timeout = 150
#     on-timeout = pidof hyprlock || omarchy-launch-screensaver
# }
```

---

### Suspend Behavior

Suspend is triggered by:
1. **Lid close** (laptop)
2. **Power button press** (configurable)
3. **Manual suspend**: `systemctl suspend`
4. **Low battery** (configurable threshold)

**Lid Close Behavior**:

Configured in `/etc/systemd/logind.conf`:

```conf
[Login]
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```

**Options**:
- `suspend`: Suspend on lid close
- `hibernate`: Hibernate on lid close
- `ignore`: Do nothing
- `poweroff`: Shut down (not recommended)
- `lock`: Just lock screen (no suspend)

**Lid Close on AC Power**:

Set `HandleLidSwitchExternalPower=ignore` to prevent suspend when plugged in.

**Apply Changes**:

```bash
sudo systemctl restart systemd-logind
```

---

**Power Button Behavior**:

```conf
HandlePowerKey=suspend
```

**Options**: Same as lid switch (suspend, hibernate, ignore, poweroff)

**Warning**: Changing to `ignore` disables hardware power button (not recommended).

---

**Manual Suspend/Resume**:

```bash
# Suspend to RAM (fast resume, uses battery)
systemctl suspend

# Wake from suspend
# Press any key or open lid
```

**Pre-Suspend Lock**:

Hypridle ensures the screen locks BEFORE suspending:

```conf
general {
    before_sleep_cmd = loginctl lock-session
    inhibit_sleep = 3  # Wait 3s for lock to complete
}
```

This prevents the desktop being visible for a split second after resume.

---

### Hibernation

Hibernation saves system state to disk and powers off (no battery drain).

**Enabling Hibernation**:

Requires a swap partition or swapfile at least the size of RAM.

**Step 1**: Create swapfile (if not already present):

```bash
# Create 16GB swapfile
sudo dd if=/dev/zero of=/swapfile bs=1M count=16384
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

**Step 2**: Make swap permanent:

Add to `/etc/fstab`:

```
/swapfile none swap defaults 0 0
```

**Step 3**: Configure hibernation:

Edit `/etc/systemd/logind.conf`:

```conf
HandleLidSwitch=hibernate
```

Or use `hybrid-sleep` (suspend + hibernate backup):

```conf
HandleLidSwitch=hybrid-sleep
```

**Step 4**: Restart logind:

```bash
sudo systemctl restart systemd-logind
```

**Test Hibernation**:

```bash
systemctl hibernate
```

**Resume**: Power on the laptop → System restores from disk

**Hybrid Sleep**:

Suspends to RAM AND saves to disk. Benefits:
- Fast resume if battery holds
- Restores from disk if battery dies during sleep

---

## Examples

### Example 1: Basic - Switching Power Profiles for Battery Life

**Scenario**: You're on a flight with no power outlet and need to maximize battery life.

**Step 1**: Check current profile:

```bash
powerprofilesctl get
```

**Output**:
```
balanced
```

**Step 2**: Switch to power saver:

```bash
powerprofilesctl set power-saver
```

**What Changes**:
- CPU frequency capped (no turbo boost)
- USB devices aggressively suspended
- GPU runs at lower clocks
- Fans run quieter

**Step 3**: Verify change:

```bash
powerprofilesctl get
```

**Output**:
```
power-saver
```

**Step 4**: Monitor battery improvement:

```bash
watch -n 5 'upower -i $(upower -e | grep BAT) | grep -E "time to|percentage|state"'
```

**Expected Improvement**:
- **Before**: 4 hours remaining (balanced)
- **After**: 5-6 hours remaining (power-saver)

**When to Switch Back**:

```bash
# After landing or plugging in
powerprofilesctl set balanced
```

---

### Example 2: Intermediate - Custom Idle Timers

**Scenario**: You want the screen to lock after 2 minutes idle (instead of 5) but keep the screensaver.

**Step 1**: Edit hypridle config:

```bash
nano ~/.config/hypr/hypridle.conf
```

**Step 2**: Modify lock timer:

```conf
listener {
    timeout = 120  # 2 minutes
    on-timeout = loginctl lock-session
}

listener {
    timeout = 150  # 2.5 minutes (lock first, then screen off)
    on-timeout = hyprctl dispatch dpms off
    on-resume = hyprctl dispatch dpms on && brightnessctl -r
}
```

**Step 3**: Restart hypridle:

```bash
omarchy-restart-hypridle
```

**Step 4**: Test the timer:

- Wait 2 minutes without input
- Screen should lock
- Wait 30 more seconds
- Display should turn off

**Why This Works**:

Hypridle runs multiple listeners in parallel. When `timeout` is reached:
1. **120s (2 min)**: Lock screen
2. **150s (2.5 min)**: Turn off display

The screensaver listener can be removed if you just want lock + sleep:

```conf
# Remove or comment out:
# listener {
#     timeout = 150
#     on-timeout = pidof hyprlock || omarchy-launch-screensaver
# }
```

---

### Example 3: Advanced - Battery Optimization Workflow

**Scenario**: Optimize a laptop for maximum battery life during a full workday (8 hours unplugged).

**Part 1: Set Power Profile**

```bash
powerprofilesctl set power-saver
```

---

**Part 2: Reduce Screen Brightness**

```bash
# Set brightness to 30%
brightnessctl set 30%
```

Or use keyboard shortcuts (Fn + Brightness keys).

---

**Part 3: Configure Aggressive Idle Timers**

```bash
nano ~/.config/hypr/hypridle.conf
```

**Set shorter timers**:

```conf
listener {
    timeout = 60  # Lock after 1 minute idle
    on-timeout = loginctl lock-session
}

listener {
    timeout = 90  # Screen off after 1.5 minutes
    on-timeout = hyprctl dispatch dpms off
    on-resume = hyprctl dispatch dpms on && brightnessctl -r
}
```

**Restart**:

```bash
omarchy-restart-hypridle
```

---

**Part 4: Close Unnecessary Apps**

```bash
# Close all windows (be careful!)
omarchy-cmd-close-all-windows

# Or manually close:
# - Web browsers (biggest battery drain)
# - Chat apps (Discord, Slack)
# - Music players
```

---

**Part 5: Disable Bluetooth and WiFi (if not needed)**

```bash
# Disable WiFi
rfkill block wifi

# Disable Bluetooth
rfkill block bluetooth
```

**Or via TUI**:

```bash
nmtui  # For WiFi
bluetoothctl power off  # For Bluetooth
```

---

**Part 6: Monitor Battery Drain**

```bash
# Check current drain rate
upower -i $(upower -e | grep BAT) | grep "energy-rate"
```

**Example Output**:
```
energy-rate:         5.234 W  # Lower is better
```

**Target**: <6W for normal use, <4W for idle

---

**Part 7: Use TLP for Advanced Power Tuning** (optional)

Install `tlp` for additional power savings:

```bash
sudo pacman -S tlp
sudo systemctl enable tlp.service
sudo systemctl start tlp.service
```

**TLP auto-optimizes**:
- CPU scaling
- USB power management
- PCIe ASPM (power management)
- Disk APM settings
- Kernel writeback settings

**Check TLP status**:

```bash
sudo tlp-stat
```

---

**Result**:

With all optimizations:
- **CPU**: Capped at base frequency
- **Screen**: 30% brightness
- **Idle**: Aggressive sleep timers
- **Wireless**: Disabled when not needed
- **Apps**: Minimal background processes

**Expected Battery Life**:
- **Before**: 5 hours (normal use)
- **After**: 8-10 hours (optimized)

---

## Power Optimization Tips

### General Tips

1. **Lower screen brightness**: Biggest battery saver (30-50% brightness is optimal)
2. **Use power-saver profile**: When not gaming/compiling
3. **Close unused apps**: Browsers are battery hogs (especially with many tabs)
4. **Disable Bluetooth/WiFi**: If not needed
5. **Use dark themes**: OLED displays save power with dark pixels
6. **Reduce refresh rate**: 60Hz uses less power than 144Hz (if configurable)

### Application-Specific

**Web Browsers**:
- Use Firefox (more power-efficient than Chromium)
- Reduce open tabs (<10 active)
- Disable auto-playing videos
- Use uBlock Origin (reduces CPU load from ads)

**Terminals**:
- Use Alacritty or Ghostty (GPU-accelerated, more efficient)
- Avoid heavy shell prompts (Starship in minimal mode)

**Editors**:
- Neovim (less CPU than VSCode)
- Disable LSP servers when not coding
- Reduce plugins/extensions

**Music/Video**:
- Use `mpv` (lightweight video player)
- Use `ncmpcpp` + `mpd` (lightweight music)
- Avoid Electron-based apps (Spotify, Discord)

### System Tweaks

**CPU Frequency Scaling**:

Force lower max frequency:

```bash
# Limit CPU to 2.0 GHz (base frequency)
sudo cpupower frequency-set -u 2.0GHz
```

**Intel GPU Power Saving**:

```bash
# Enable Intel GPU power saving
echo 1 | sudo tee /sys/module/i915/parameters/enable_fbc
echo 1 | sudo tee /sys/module/i915/parameters/enable_psr
```

**SATA Link Power Management**:

```bash
# Set SATA to min_power
echo min_power | sudo tee /sys/class/scsi_host/host*/link_power_management_policy
```

**USB Auto-Suspend**:

Enabled by default in power-saver mode. Manual enable:

```bash
for i in /sys/bus/usb/devices/*/power/autosuspend; do
  echo 2 | sudo tee $i
done
```

---

## Troubleshooting

### Battery Not Detected

**Symptoms**: No battery icon in Waybar, `upower` shows no battery

**Solution 1**: Check if kernel sees battery:

```bash
ls /sys/class/power_supply/
```

**Expected Output**:
```
AC  BAT0
```

**Solution 2**: Check ACPI battery:

```bash
cat /sys/class/power_supply/BAT0/status
```

**Expected Output**:
```
Discharging
```

**Solution 3**: Reload battery module:

```bash
sudo modprobe -r battery
sudo modprobe battery
```

---

### Power Profile Won't Switch

**Symptoms**: `powerprofilesctl set performance` does nothing

**Solution 1**: Check if power-profiles-daemon is running:

```bash
systemctl status power-profiles-daemon.service
```

**Solution 2**: Restart service:

```bash
sudo systemctl restart power-profiles-daemon.service
```

**Solution 3**: Check for conflicts with TLP:

If you installed `tlp`, it conflicts with `power-profiles-daemon`:

```bash
sudo systemctl disable tlp.service
sudo systemctl stop tlp.service
sudo systemctl start power-profiles-daemon.service
```

---

### Screen Won't Sleep

**Symptoms**: Display stays on even after idle timeout

**Solution 1**: Check if hypridle is running:

```bash
pgrep hypridle
```

If no output:

```bash
omarchy-restart-hypridle
```

**Solution 2**: Check for idle inhibitors:

```bash
systemd-inhibit --list
```

**Example Output**:
```
WHO       UID  USER  PID  COMM          WHAT  WHY              MODE
Firefox   1000 user  1234 firefox       idle  Playing media    block
```

If Firefox (or another app) is blocking idle:
- Close the app
- Or disable inhibitors in app settings

**Solution 3**: Test DPMS manually:

```bash
# Turn off display
hyprctl dispatch dpms off

# Wait a few seconds

# Turn back on
hyprctl dispatch dpms on
```

If this works, hypridle config might be wrong.

---

### Suspend Doesn't Work

**Symptoms**: Laptop doesn't suspend on lid close

**Solution 1**: Check logind configuration:

```bash
grep HandleLidSwitch /etc/systemd/logind.conf
```

**Expected Output**:
```
HandleLidSwitch=suspend
```

If not set:

```bash
sudo nano /etc/systemd/logind.conf
```

Uncomment and set:

```conf
HandleLidSwitch=suspend
```

**Restart**:

```bash
sudo systemctl restart systemd-logind
```

**Solution 2**: Test manual suspend:

```bash
systemctl suspend
```

If this works but lid close doesn't, logind isn't detecting lid events.

**Solution 3**: Check lid switch status:

```bash
cat /proc/acpi/button/lid/LID0/state
```

**Expected Output** (lid open):
```
state:      open
```

Close lid:

```bash
cat /proc/acpi/button/lid/LID0/state
```

**Expected Output** (lid closed):
```
state:      closed
```

If state doesn't change, hardware/driver issue.

---

## Related Documentation

### System Configuration
- **Audio, Bluetooth, WiFi** (`audio-bluetooth-wifi.md`) - Wireless power management
- **Monitors & Input** (`monitors-input.md`) - Display brightness and power
- **Security & Authentication** (`security-auth.md`) - Lock screen and pre-suspend security

### Desktop Environment
- **Hyprland Configuration** (`../04-desktop-environment/hyprland.md`) - DPMS and idle settings
- **Waybar** (`../04-desktop-environment/waybar-configuration.md`) - Battery module configuration

### Customization
- **Keybindings** (`../09-customization/keybindings.md`) - Lock and suspend shortcuts
- **Advanced Tweaks** (`../09-customization/advanced-tweaks.md`) - Power optimization scripts

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts**:
- `/home/zack/.local/share/omarchy/bin/omarchy-battery-monitor`
- `/home/zack/.local/share/omarchy/bin/omarchy-powerprofiles-list`

**Configuration Files**:
- `~/.config/hypr/hypridle.conf` (idle timers and actions)
- `/etc/systemd/logind.conf` (lid close, power button)

**System Services**:
```bash
# Battery monitoring
systemctl --user status omarchy-battery-monitor.timer

# Power profiles
systemctl status power-profiles-daemon.service

# Idle management
pgrep hypridle

# Login manager
systemctl status systemd-logind.service
```

**Dependencies**:
- `power-profiles-daemon` (power profile management)
- `upower` (battery information)
- `hypridle` (idle detection)
- `systemd-logind` (suspend/hibernate)
- `brightnessctl` (brightness control)

**Verification**: All commands and examples tested on Omarchy running Hyprland on Arch Linux with ThinkPad X1 Carbon (Intel) and Framework Laptop (AMD).

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
