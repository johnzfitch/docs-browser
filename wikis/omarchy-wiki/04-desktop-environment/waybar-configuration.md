# Waybar Configuration

## Quick Start

```bash
# Toggle Waybar visibility
omarchy-toggle-waybar

# Restart Waybar
omarchy-restart-waybar

# Reload Waybar (apply config changes)
omarchy-refresh-waybar

# View configuration
cat ~/.local/share/omarchy/config/waybar/config.jsonc
```

---

## Table of Contents

1. [Overview](#overview)
2. [Configuration Structure](#configuration-structure)
3. [Commands Reference](#commands-reference)
4. [Examples](#examples)
   - [Basic: Understanding the Status Bar](#example-1-basic-understanding-the-status-bar)
   - [Intermediate: Adding Custom Modules](#example-2-intermediate-adding-custom-modules)
   - [Advanced: Custom Scripts and Indicators](#example-3-advanced-custom-scripts-and-indicators)
5. [Modules and Customization](#modules-and-customization)
6. [Theme Integration](#theme-integration)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)
9. [Related Documentation](#related-documentation)

---

## Overview

Waybar is the status bar in Omarchy's desktop environment. It displays workspace information, system status, notifications, and provides quick access to system controls. Waybar runs at the top of your screen and integrates seamlessly with Hyprland and the active Omarchy theme.

The Waybar implementation in Omarchy is minimal and functional. It shows essential information without clutter: workspaces, time, system resources, network, battery, and audio status. Each element is clickable, providing shortcuts to relevant system utilities.

Waybar configuration follows the same philosophy as other Omarchy components: sensible defaults that can be customized. The default configuration lives in Omarchy's shared config, while user customizations go in `~/.config/waybar/`, ensuring updates don't overwrite your changes.

---

## Configuration Structure

### Directory Layout

```
~/.local/share/omarchy/config/waybar/     # Omarchy default config
├── config.jsonc                          # Main configuration
└── style.css                             # Styling (imports theme)

~/.config/waybar/                         # User customizations (optional)
├── config.jsonc                          # Override default config
└── style.css                             # Custom styling

~/.config/omarchy/current/theme/          # Active theme (symlink)
└── waybar.css                            # Theme-specific colors
```

### Configuration Files

**config.jsonc** - Main configuration defining modules, their position, and behavior

**style.css** - Visual styling, imports theme colors

**waybar.css** (from theme) - Theme-specific colors and styles

---

## Configuration Structure (Detailed)

### Main Configuration (`config.jsonc`)

```jsonc
{
  "reload_style_on_change": true,   // Auto-reload on file changes
  "layer": "top",                    // Layer level (top, bottom, overlay)
  "position": "top",                 // Screen position
  "spacing": 0,                      // Module spacing
  "height": 26,                      // Bar height in pixels

  // Module layout
  "modules-left": ["custom/omarchy", "hyprland/workspaces"],
  "modules-center": ["clock", "custom/update", "custom/screenrecording-indicator"],
  "modules-right": [
    "group/tray-expander",
    "bluetooth",
    "network",
    "pulseaudio",
    "cpu",
    "battery"
  ],

  // Module configurations below...
}
```

### Module Layout

**Left side:**
- Omarchy menu icon (launches `omarchy-menu`)
- Hyprland workspaces (1-5 persistent)

**Center:**
- Clock (day and time)
- Update indicator (shows when update available)
- Screen recording indicator

**Right side:**
- System tray (expandable)
- Bluetooth status
- Network status
- Audio volume
- CPU indicator
- Battery status

---

## Commands Reference

### omarchy-toggle-waybar

Toggle Waybar visibility (show/hide).

```bash
# Toggle Waybar on/off
omarchy-toggle-waybar
```

**Use cases:**
- Hide bar for fullscreen presentations
- Maximize screen space when needed
- Quickly access bar for status check

**Keybinding:** Usually bound to `Super + B` or similar

### omarchy-restart-waybar

Completely restart Waybar process.

```bash
# Restart Waybar
omarchy-restart-waybar
```

**When to use:**
- After major configuration changes
- When Waybar becomes unresponsive
- After theme changes
- When modules stop updating

**What it does:**
1. Kills running Waybar process
2. Starts new Waybar instance
3. Reloads all configuration files
4. Reconnects to Hyprland

### omarchy-refresh-waybar

Reload Waybar configuration without restarting.

```bash
# Reload configuration
omarchy-refresh-waybar
```

**When to use:**
- After editing config.jsonc
- After editing style.css
- For quick style changes
- When `reload_style_on_change` is disabled

**Note:** If `reload_style_on_change: true`, style changes apply automatically

---

## Modules and Customization

### Built-in Modules

#### Hyprland Workspaces

Shows workspace status and allows clicking to switch.

```jsonc
"hyprland/workspaces": {
  "on-click": "activate",
  "format": "{icon}",
  "format-icons": {
    "default": "",
    "1": "1",
    "2": "2",
    "3": "3",
    "4": "4",
    "5": "5",
    "active": "󱓻"
  },
  "persistent-workspaces": {
    "1": [],
    "2": [],
    "3": [],
    "4": [],
    "5": []
  }
}
```

**Features:**
- Click to switch workspace
- Shows active workspace
- Persistent workspaces always visible
- Empty workspaces indicated by opacity

#### Clock

Displays current time and date.

```jsonc
"clock": {
  "format": "{:L%A %H:%M}",              // "Monday 14:30"
  "format-alt": "{:L%d %B W%V %Y}",      // "21 October W43 2025"
  "tooltip": false,
  "on-click-right": "omarchy-launch-floating-terminal-with-presentation omarchy-tz-select"
}
```

**Features:**
- Click to toggle between time and date format
- Right-click to select timezone
- Locale-aware formatting

#### Network

Shows network connection status.

```jsonc
"network": {
  "format-icons": ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"],
  "format": "{icon}",
  "format-wifi": "{icon}",
  "format-ethernet": "󰀂",
  "format-disconnected": "󰤮",
  "tooltip-format-wifi": "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}",
  "tooltip-format-ethernet": "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}",
  "interval": 3,
  "on-click": "omarchy-launch-wifi"
}
```

**Features:**
- Signal strength indicator
- Bandwidth monitoring in tooltip
- Click to open WiFi manager
- Auto-updates every 3 seconds

#### Battery

Shows battery status and percentage.

```jsonc
"battery": {
  "format": "{capacity}% {icon}",
  "format-discharging": "{icon}",
  "format-charging": "{icon}",
  "format-plugged": "",
  "format-icons": {
    "charging": ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
    "default": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
  },
  "format-full": "󰂅",
  "tooltip-format-discharging": "{power:>1.0f}W↓ {capacity}%",
  "tooltip-format-charging": "{power:>1.0f}W↑ {capacity}%",
  "interval": 5,
  "on-click": "omarchy-menu power",
  "states": {
    "warning": 20,
    "critical": 10
  }
}
```

**Features:**
- Icon changes with battery level
- Different icons for charging/discharging
- Power consumption in tooltip
- Click to open power menu
- Warning states at 20% and 10%

#### CPU

Shows CPU usage indicator.

```jsonc
"cpu": {
  "interval": 5,
  "format": "󰍛",
  "on-click": "$TERMINAL -e btop"
}
```

**Features:**
- Simple CPU icon
- Click to open btop (resource monitor)
- Updates every 5 seconds

#### Pulseaudio

Audio volume control.

```jsonc
"pulseaudio": {
  "format": "{icon}",
  "on-click": "$TERMINAL --class=Wiremix -e wiremix",
  "on-click-right": "pamixer -t",
  "tooltip-format": "Playing at {volume}%",
  "scroll-step": 5,
  "format-muted": "",
  "format-icons": {
    "default": ["", "", ""]
  }
}
```

**Features:**
- Volume icon changes with level
- Click to open audio mixer
- Right-click to mute/unmute
- Scroll to adjust volume (5% steps)
- Shows volume percentage in tooltip

#### Bluetooth

Bluetooth connection indicator.

```jsonc
"bluetooth": {
  "format": "",
  "format-disabled": "󰂲",
  "format-connected": "",
  "tooltip-format": "Devices connected: {num_connections}",
  "on-click": "blueberry"
}
```

**Features:**
- Shows connection status
- Click to open Bluetooth manager
- Tooltip shows number of connected devices

### Custom Modules

#### Omarchy Menu

Launches the Omarchy system menu.

```jsonc
"custom/omarchy": {
  "format": "<span font='omarchy'>\ue900</span>",
  "on-click": "omarchy-menu",
  "tooltip-format": "Omarchy Menu\n\nSuper + Alt + Space"
}
```

#### Update Indicator

Shows when Omarchy updates are available.

```jsonc
"custom/update": {
  "format": "",
  "exec": "omarchy-update-available",
  "on-click": "omarchy-launch-floating-terminal-with-presentation omarchy-update",
  "tooltip-format": "Omarchy update available",
  "signal": 7,
  "interval": 3600
}
```

**Features:**
- Checks for updates hourly
- Click to run update
- Signal 7 to manually refresh

#### Screen Recording Indicator

Shows when screen recording is active.

```jsonc
"custom/screenrecording-indicator": {
  "on-click": "omarchy-cmd-screenrecord",
  "exec": "$OMARCHY_PATH/default/waybar/indicators/screen-recording.sh",
  "signal": 8,
  "return-type": "json"
}
```

**Features:**
- Shows red icon when recording
- Click to start/stop recording
- Signal 8 to update status

---

## Examples

### Example 1: Basic - Understanding the Status Bar

**Scenario:** You want to understand what each icon means and how to interact with them.

**Solution:**

**Left side:**
- **Omarchy icon** (󰀘) - Click to open Omarchy menu
- **Workspace numbers** (1, 2, 3, 4, 5) - Click to switch workspace, active workspace highlighted

**Center:**
- **Clock** - Click to toggle time/date format, right-click for timezone selector
- **Update icon** () - Only shows when update available, click to update
- **Recording icon** - Only shows when recording screen

**Right side:**
- **Tray expander** () - Click to expand system tray
- **Bluetooth** () - Click to open Bluetooth manager
- **Network** (󰤨) - Signal strength, click for WiFi settings
- **Volume** () - Scroll to adjust, click for mixer, right-click to mute
- **CPU** (󰍛) - Click to open btop
- **Battery** () - Shows charge level, click for power menu

---

### Example 2: Intermediate - Adding Custom Modules

**Scenario:** You want to add a weather module to Waybar.

**Solution:**

1. Create weather script (`~/.config/waybar/scripts/weather.sh`):

```bash
#!/bin/bash
# Simple weather using wttr.in
curl -s "wttr.in/Tokyo?format=%t+%C" 2>/dev/null || echo "N/A"
```

2. Make executable:

```bash
chmod +x ~/.config/waybar/scripts/weather.sh
```

3. Add to `~/.config/waybar/config.jsonc`:

```jsonc
{
  "modules-center": [
    "clock",
    "custom/weather",  // Add here
    "custom/update",
    "custom/screenrecording-indicator"
  ],

  // Add weather module configuration
  "custom/weather": {
    "exec": "~/.config/waybar/scripts/weather.sh",
    "interval": 1800,  // Update every 30 minutes
    "format": "{}",
    "tooltip": false
  }
}
```

4. Reload Waybar:

```bash
omarchy-refresh-waybar
```

---

### Example 3: Advanced - Custom Scripts and Indicators

**Scenario:** You want to add a VPN indicator that shows connection status.

**Solution:**

1. Create VPN status script (`~/.config/waybar/scripts/vpn-status.sh`):

```bash
#!/bin/bash

# Check if VPN is connected (adjust for your VPN)
if ip link show | grep -q "tun0\|wg0"; then
  status="connected"
  icon=""
  class="connected"
else
  status="disconnected"
  icon=""
  class="disconnected"
fi

# Return JSON for Waybar
echo "{\"text\":\"$icon\",\"class\":\"$class\",\"tooltip\":\"VPN $status\"}"
```

2. Make executable:

```bash
chmod +x ~/.config/waybar/scripts/vpn-status.sh
```

3. Add to `~/.config/waybar/config.jsonc`:

```jsonc
{
  "modules-right": [
    "group/tray-expander",
    "custom/vpn",  // Add here
    "bluetooth",
    "network",
    "pulseaudio",
    "cpu",
    "battery"
  ],

  "custom/vpn": {
    "exec": "~/.config/waybar/scripts/vpn-status.sh",
    "interval": 5,
    "return-type": "json",
    "on-click": "nmcli connection up YourVPN",
    "on-click-right": "nmcli connection down YourVPN"
  }
}
```

4. Add styling to `~/.config/waybar/style.css`:

```css
#custom-vpn {
  margin-right: 15px;
}

#custom-vpn.connected {
  color: #a6da95;  /* Green when connected */
}

#custom-vpn.disconnected {
  color: #ed8796;  /* Red when disconnected */
}
```

5. Reload:

```bash
omarchy-refresh-waybar
```

---

## Theme Integration

### How Theme Colors Work

Waybar integrates with Omarchy themes through CSS imports:

```css
/* In ~/.local/share/omarchy/config/waybar/style.css */
@import "../omarchy/current/theme/waybar.css";
```

The theme provides colors through CSS variables:

```css
/* Example from a theme's waybar.css */
* {
  @define-color background #24273a;
  @define-color foreground #cad3f5;
  @define-color accent #8aadf4;
}
```

### Theme-Aware Styling

Your `style.css` uses these variables:

```css
* {
  background-color: @background;
  color: @foreground;
  font-family: 'CaskaydiaMono Nerd Font';
}

#workspaces button.active {
  color: @accent;
}
```

### Custom Colors (Override Theme)

To use custom colors regardless of theme, create `~/.config/waybar/style.css`:

```css
/* Import Omarchy theme first */
@import "../../.local/share/omarchy/config/waybar/style.css";

/* Override specific elements */
#workspaces button {
  color: #8aadf4;  /* Custom blue */
}

#battery.warning {
  color: #f5a97f;  /* Custom orange */
}

#battery.critical {
  color: #ed8796;  /* Custom red */
  animation: blink 1s linear infinite;
}

@keyframes blink {
  to { opacity: 0.5; }
}
```

### Font Customization

```css
/* In ~/.config/waybar/style.css */

* {
  font-family: 'JetBrainsMono Nerd Font';
  font-size: 13px;  /* Larger text */
}

#clock {
  font-weight: bold;
}

#workspaces button {
  font-size: 14px;
}
```

---

## Troubleshooting

### Waybar Not Showing

**Problem:** Waybar doesn't appear after login.

**Solutions:**

```bash
# 1. Check if Waybar is running
pgrep waybar

# 2. Start Waybar manually
omarchy-restart-waybar

# 3. Check for errors
journalctl --user -u waybar.service -n 50

# 4. Verify configuration syntax
cat ~/.local/share/omarchy/config/waybar/config.jsonc | jq .
# If errors, check for missing commas, brackets, etc.
```

### Modules Not Updating

**Problem:** Network, battery, or other modules show stale data.

**Solutions:**

```bash
# 1. Restart Waybar
omarchy-restart-waybar

# 2. Check module intervals in config
cat ~/.local/share/omarchy/config/waybar/config.jsonc | grep interval

# 3. Increase update frequency
# Edit config.jsonc, lower interval values:
"network": {
  "interval": 1  // Update every second
}

# 4. Check system services
systemctl status NetworkManager
systemctl status bluetooth
```

### Custom Module Script Fails

**Problem:** Custom module doesn't show or shows error.

**Solutions:**

```bash
# 1. Test script directly
~/.config/waybar/scripts/your-script.sh

# 2. Check script permissions
ls -la ~/.config/waybar/scripts/
chmod +x ~/.config/waybar/scripts/your-script.sh

# 3. Check script output format
# For JSON modules, ensure valid JSON:
echo '{"text":"value","tooltip":"tooltip"}' | jq .

# 4. View Waybar logs
journalctl --user -u waybar.service -f
# Then click/interact with module to see errors
```

### Styling Not Applied

**Problem:** CSS changes don't take effect.

**Solutions:**

```bash
# 1. If reload_style_on_change is true, just save
# Otherwise, reload:
omarchy-refresh-waybar

# 2. Check CSS syntax
# CSS doesn't have a validator, but watch for:
# - Missing semicolons
# - Unclosed brackets
# - Invalid color values

# 3. Verify import paths
cat ~/.config/waybar/style.css | grep @import

# 4. Restart Waybar completely
omarchy-restart-waybar
```

### Icons Not Showing

**Problem:** Nerd Font icons show as squares or question marks.

**Solutions:**

```bash
# 1. Verify Nerd Font is installed
fc-list | grep -i nerd

# 2. Install CaskaydiaMono (Omarchy default)
# Via Omarchy's font installation

# 3. Force font in style.css
* {
  font-family: 'CaskaydiaMono Nerd Font', 'Symbols Nerd Font';
}

# 4. Rebuild font cache
fc-cache -fv

# 5. Restart Waybar
omarchy-restart-waybar
```

---

## Best Practices

### 1. Use User Config for Customization

**Don't edit:**
```bash
~/.local/share/omarchy/config/waybar/config.jsonc  # Will be overwritten
```

**Do edit:**
```bash
~/.config/waybar/config.jsonc  # Your customizations
```

### 2. Test Scripts Independently

Before adding custom modules:

```bash
# Make script
nvim ~/.config/waybar/scripts/test.sh

# Test it
bash ~/.config/waybar/scripts/test.sh

# Make executable
chmod +x ~/.config/waybar/scripts/test.sh

# Add to Waybar only when working
```

### 3. Use Appropriate Update Intervals

```jsonc
// Fast-changing data
"cpu": { "interval": 2 }
"network": { "interval": 3 }

// Moderate updates
"battery": { "interval": 5 }

// Slow-changing data
"custom/weather": { "interval": 1800 }  // 30 minutes
"custom/update": { "interval": 3600 }   // 1 hour
```

### 4. Keep Modules Minimal

Too many modules = cluttered bar:

```jsonc
// Good - essential modules
"modules-right": ["network", "pulseaudio", "battery"]

// Bad - too many
"modules-right": ["network", "wifi", "ethernet", "vpn", "bluetooth",
                  "pulseaudio", "jack", "cpu", "memory", "disk",
                  "temperature", "battery", "backlight", ...]
```

### 5. Use Tooltips for Details

Keep bar clean, put details in tooltips:

```jsonc
"battery": {
  "format": "{icon}",  // Just icon on bar
  "tooltip-format": "Battery: {capacity}%\nPower: {power}W\nTime: {time}"  // Details in tooltip
}
```

### 6. Comment Your Configurations

```jsonc
{
  "modules-right": [
    "custom/vpn",        // Shows VPN connection status
    "bluetooth",         // BT devices, click for manager
    "network",           // WiFi signal, bandwidth in tooltip
    "pulseaudio",        // Volume control
    "cpu",               // CPU usage, click for btop
    "battery"            // Battery %, click for power menu
  ]
}
```

---

## Related Documentation

### Omarchy Documentation
- [Hyprland Integration](/home/zack/dev/lib/omarchy-archive/04-desktop-environment/hyprland-integration.md) - Desktop environment that Waybar runs in
- [Theme System](/home/zack/dev/lib/omarchy-archive/03-theming/theme-system.md) - How themes affect Waybar colors
- [Window Management](/home/zack/dev/lib/omarchy-archive/04-desktop-environment/window-management.md) - Workspace system shown in Waybar

### Waybar Documentation
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki) - Official documentation
- [Configuration](https://github.com/Alexays/Waybar/wiki/Configuration) - All available modules
- [Styling](https://github.com/Alexays/Waybar/wiki/Styling) - CSS customization guide

---

**Last Updated:** 2025-10-21
**Omarchy Version:** Latest
