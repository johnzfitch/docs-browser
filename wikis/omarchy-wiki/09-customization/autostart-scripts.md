# Autostart Scripts

## Quick Start

```bash
# Edit autostart configuration
nano ~/.config/hypr/autostart.conf

# Add an application to autostart
echo 'exec-once = uwsm-app -- dropbox' >> ~/.config/hypr/autostart.conf

# Reload Hyprland to apply
hyprctl reload

# Check running user services
systemctl --user list-units --state=running

# View Hyprland autostart logs
journalctl --user -u wayland-wm@hyprland.desktop
```

---

## Table of Contents

1. [Overview](#overview)
2. [Autostart Configuration](#autostart-configuration)
3. [systemd User Services](#systemd-user-services)
4. [UWSM Integration](#uwsm-integration)
5. [Adding Custom Startup Apps](#adding-custom-startup-apps)
6. [Examples](#examples)
   - [Basic: Adding an Application to Autostart](#example-1-basic-adding-an-application-to-autostart)
   - [Intermediate: Creating a Startup Script](#example-2-intermediate-creating-a-startup-script)
   - [Advanced: systemd Service for Background Process](#example-3-advanced-systemd-service-for-background-process)
7. [Default Autostart Services](#default-autostart-services)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Related Documentation](#related-documentation)

---

## Overview

Omarchy's autostart system manages applications and services that launch automatically when you log into Hyprland. The system uses multiple layers working together:

1. **Hyprland autostart.conf** - User-defined applications launched via `exec-once`
2. **systemd user services** - System services managed by systemd
3. **UWSM (Universal Wayland Session Manager)** - Wayland session integration for proper lifecycle management

This architecture ensures applications start reliably, receive proper environment variables, and integrate cleanly with the Wayland session. Applications launched through UWSM benefit from automatic cleanup when you log out and proper XDG desktop integration.

---

## Autostart Configuration

### Location

User autostart configuration:
```
~/.config/hypr/autostart.conf
```

Default Omarchy autostart:
```
~/.local/share/omarchy/default/hypr/autostart.conf
```

### File Structure

```conf
# Extra autostart processes
# exec-once = uwsm-app -- my-service

# Example applications
exec-once = uwsm-app -- dropbox
exec-once = uwsm-app -- signal-desktop
exec-once = uwsm-app -- 1password --silent
```

### exec-once vs exec

**exec-once** (recommended):
```conf
exec-once = uwsm-app -- dropbox
```
- Runs **once per Hyprland session** (at login)
- Won't re-run when you reload Hyprland config (`hyprctl reload`)
- Best for applications you want at startup only

**exec** (rarely used):
```conf
exec = notify-send "Config reloaded"
```
- Runs **every time config is loaded** (including reloads)
- Re-runs when you `hyprctl reload`
- Best for one-time commands or debugging

**General Rule**: Use `exec-once` for applications, `exec` only for testing or stateless commands.

### How It's Loaded

Hyprland's main config sources autostart.conf:

```conf
# ~/.config/hypr/hyprland.conf

# Default Omarchy autostart (system services)
source = ~/.local/share/omarchy/default/hypr/autostart.conf

# User autostart (your custom apps)
source = ~/.config/hypr/autostart.conf
```

**Load Order**:
1. Omarchy defaults start system components (waybar, hypridle, swaybg, etc.)
2. User autostart runs your custom applications
3. Both use `exec-once`, so safe to reload config without duplication

---

## systemd User Services

### What Are User Services?

systemd user services run in your user session (not system-wide). They:
- Start automatically when you log in
- Run in background
- Restart automatically if they crash
- Log to journald
- Can depend on other services

### Viewing Services

**List all running services**:
```bash
systemctl --user list-units --state=running
```

**Omarchy-related services**:
```bash
systemctl --user list-units --state=running | grep -E "(omarchy|hypr|waybar)"
```

**Expected Output**:
```
wayland-wm@hyprland.desktop.service    loaded active running   Hyprland
app-Hyprland-waybar-*.scope            loaded active running   waybar
app-Hyprland-hypridle-*.scope          loaded active running   hypridle
xdg-desktop-portal-hyprland.service    loaded active running   Portal service (Hyprland)
```

### Service Status

**Check specific service**:
```bash
systemctl --user status wayland-wm@hyprland.desktop
```

**Expected Output**:
```
● wayland-wm@hyprland.desktop.service - Main service for Hyprland
     Loaded: loaded
     Active: active (running) since ...
   Main PID: 12345 (Hyprland)
```

**Check service logs**:
```bash
journalctl --user -u wayland-wm@hyprland.desktop
```

**Follow logs in real-time**:
```bash
journalctl --user -u wayland-wm@hyprland.desktop -f
```

### Managing Services

**Start a service**:
```bash
systemctl --user start my-service.service
```

**Stop a service**:
```bash
systemctl --user stop my-service.service
```

**Restart a service**:
```bash
systemctl --user restart my-service.service
```

**Enable service (start at login)**:
```bash
systemctl --user enable my-service.service
```

**Disable service (don't start at login)**:
```bash
systemctl --user disable my-service.service
```

---

## UWSM Integration

### What is UWSM?

UWSM (Universal Wayland Session Manager) is a service that manages Wayland applications within your session. It ensures:
- Applications receive correct environment variables
- Processes are tracked and cleaned up on logout
- XDG autostart integration works properly
- Applications appear in systemd user slices

### uwsm-app Command

**Syntax**:
```bash
uwsm-app -- <command> [args]
```

**Purpose**: Launch an application within the UWSM-managed session.

**Examples**:
```bash
# Launch Dropbox
uwsm-app -- dropbox

# Launch Signal with arguments
uwsm-app -- signal-desktop --start-in-tray

# Launch 1Password silently
uwsm-app -- 1password --silent
```

### Why Use uwsm-app?

**Without UWSM**:
```conf
exec-once = dropbox
```
- Runs directly under Hyprland
- May not get correct environment
- Process tree might be messy
- Manual cleanup needed on logout

**With UWSM**:
```conf
exec-once = uwsm-app -- dropbox
```
- Runs in UWSM-managed scope
- Gets proper Wayland environment
- Automatic cleanup on logout
- Shows up in `systemctl --user` as scoped unit

### UWSM Environment

Applications launched via `uwsm-app` inherit the Wayland session environment:

**Key Variables**:
- `WAYLAND_DISPLAY` - Wayland display socket
- `XDG_SESSION_TYPE=wayland` - Session type
- `XDG_CURRENT_DESKTOP=Hyprland` - Desktop environment
- `QT_QPA_PLATFORM=wayland` - Qt Wayland backend
- `MOZ_ENABLE_WAYLAND=1` - Firefox Wayland support

**Check environment**:
```bash
uwsm-app -- env | grep -E "(WAYLAND|XDG|QT|MOZ)"
```

---

## Adding Custom Startup Apps

### Simple Application

**Edit autostart.conf**:
```bash
nano ~/.config/hypr/autostart.conf
```

**Add application**:
```conf
exec-once = uwsm-app -- spotify
```

**Reload Hyprland**:
```bash
hyprctl reload
```

**Note**: `exec-once` won't re-run on reload. To test immediately:
```bash
uwsm-app -- spotify &
```

### Application with Arguments

```conf
# Start Signal minimized
exec-once = uwsm-app -- signal-desktop --start-in-tray

# Start Obsidian with Wayland flags
exec-once = uwsm-app -- obsidian --enable-wayland-ime --disable-gpu

# Start Discord with custom log level
exec-once = uwsm-app -- discord --log-level=info
```

### Application with Delay

**Why**: Some apps need network or other services ready first.

```conf
# Start Dropbox after 5 seconds
exec-once = bash -c 'sleep 5 && uwsm-app -- dropbox'

# Start backup service after 30 seconds
exec-once = bash -c 'sleep 30 && uwsm-app -- duplicati'
```

### Application on Specific Workspace

```conf
# Launch Spotify on workspace 9
exec-once = bash -c 'hyprctl dispatch workspace 9 && uwsm-app -- spotify'

# Launch browser on workspace 2
exec-once = bash -c 'hyprctl dispatch workspace 2 && omarchy-launch-browser'
```

### Terminal Command on Startup

```conf
# Launch htop in terminal
exec-once = uwsm-app -- $TERMINAL -e htop

# Launch tmux session
exec-once = uwsm-app -- $TERMINAL -e tmux new-session -A -s main
```

### Custom Script

```conf
# Run custom startup script
exec-once = bash -c '~/.config/hypr/scripts/my-startup.sh'

# Or with uwsm:
exec-once = uwsm-app -- bash ~/.config/hypr/scripts/my-startup.sh
```

---

## Examples

### Example 1: Basic - Adding an Application to Autostart

**Scenario**: You use Dropbox for file syncing and want it to start automatically when you log in.

**Step 1: Test the command manually**

```bash
# Test launching Dropbox
uwsm-app -- dropbox &
```

**Verify**: Dropbox tray icon appears, syncing starts.

**Step 2: Add to autostart**

```bash
# Edit autostart config
nano ~/.config/hypr/autostart.conf
```

**Add line**:
```conf
# Dropbox file sync
exec-once = uwsm-app -- dropbox
```

**Step 3: Save and verify syntax**

```bash
# Check for syntax errors (should be silent)
hyprctl reload
```

**Step 4: Test persistence**

```bash
# Log out and log back in
# Or restart Hyprland:
hyprctl dispatch exit

# After login, check if Dropbox is running
pgrep dropbox
# Should output a process ID
```

**Step 5: Verify UWSM integration**

```bash
# Check systemd user units
systemctl --user list-units | grep dropbox
```

**Expected Output**:
```
app-Hyprland-dropbox-*.scope    loaded active running   dropbox
```

**Why Use This**: Simple, persistent autostart. Dropbox starts on every login, integrates properly with session, and stops cleanly on logout.

---

### Example 2: Intermediate - Creating a Startup Script

**Scenario**: You have a multi-step startup routine: set volume to 50%, start music player, open terminal with tmux, and show weather notification.

**Step 1: Create startup script**

```bash
# Create script
nano ~/.config/hypr/scripts/my-startup.sh
```

**Script content**:
```bash
#!/bin/bash

# Set volume to comfortable level
swayosd-client --output-volume 50

# Wait a moment for audio to initialize
sleep 2

# Start music player on workspace 9
hyprctl dispatch workspace 9
uwsm-app -- spotify &

# Open terminal with tmux on workspace 1
hyprctl dispatch workspace 1
uwsm-app -- $TERMINAL -e tmux new-session -A -s main &

# Focus workspace 1
hyprctl dispatch workspace 1

# Wait for network to be ready
sleep 5

# Fetch and display weather
weather=$(curl -s "wttr.in/?format=%l:+%C+%t")
notify-send "Weather" "$weather"
```

**Step 2: Make executable**

```bash
chmod +x ~/.config/hypr/scripts/my-startup.sh
```

**Step 3: Test manually**

```bash
~/.config/hypr/scripts/my-startup.sh
```

**Expected Behavior**:
1. Volume adjusts to 50%
2. Spotify launches on workspace 9
3. Terminal with tmux opens on workspace 1
4. Workspace 1 becomes focused
5. Weather notification appears

**Step 4: Add to autostart**

```bash
nano ~/.config/hypr/autostart.conf
```

**Add line**:
```conf
# My custom startup routine
exec-once = bash ~/.config/hypr/scripts/my-startup.sh
```

**Step 5: Test on next login**

```bash
# Logout and login
hyprctl dispatch exit
```

**Enhancement: Add Error Handling**

```bash
nano ~/.config/hypr/scripts/my-startup.sh
```

**Improve script**:
```bash
#!/bin/bash

# Log file for debugging
LOG="$HOME/.cache/hypr/startup.log"
echo "[$(date)] Starting custom startup script" > "$LOG"

# Function to log errors
log_error() {
    echo "[$(date)] ERROR: $1" >> "$LOG"
    notify-send "Startup Error" "$1"
}

# Set volume with error checking
if ! swayosd-client --output-volume 50; then
    log_error "Failed to set volume"
fi

sleep 2

# Start Spotify with fallback
if ! pgrep -x spotify > /dev/null; then
    hyprctl dispatch workspace 9
    if ! uwsm-app -- spotify; then
        log_error "Failed to start Spotify"
    fi
fi

# Terminal with tmux
hyprctl dispatch workspace 1
if ! uwsm-app -- "$TERMINAL" -e tmux new-session -A -s main; then
    log_error "Failed to start terminal with tmux"
fi

hyprctl dispatch workspace 1

# Weather with timeout
sleep 5
weather=$(timeout 5 curl -s "wttr.in/?format=%l:+%C+%t" 2>> "$LOG")
if [ -n "$weather" ]; then
    notify-send "Weather" "$weather"
else
    log_error "Failed to fetch weather"
fi

echo "[$(date)] Startup script completed" >> "$LOG"
```

**Check logs**:
```bash
cat ~/.cache/hypr/startup.log
```

**Why Use This**: Automates complex startup routines. Script approach enables error handling, logging, and conditional logic that wouldn't be possible with simple `exec-once` lines.

---

### Example 3: Advanced - systemd Service for Background Process

**Scenario**: You run a local web server for development (e.g., Jekyll, Hugo preview) and want it to start automatically with your session, restart if it crashes, and log properly.

**Step 1: Create the service file**

```bash
# Create user service directory if needed
mkdir -p ~/.config/systemd/user/

# Create service file
nano ~/.config/systemd/user/dev-server.service
```

**Service content**:
```ini
[Unit]
Description=Development Web Server
Documentation=https://example.com/docs
After=network-online.target

[Service]
Type=simple
WorkingDirectory=%h/dev/my-project
ExecStart=/usr/bin/bundle exec jekyll serve --host 0.0.0.0 --port 4000
Restart=on-failure
RestartSec=10

# Environment variables
Environment="PATH=/usr/local/bin:/usr/bin:/bin"
Environment="JEKYLL_ENV=development"

# Logging
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
```

**Step 2: Reload systemd and enable service**

```bash
# Reload systemd to recognize new service
systemctl --user daemon-reload

# Enable service (start on login)
systemctl --user enable dev-server.service

# Start service now
systemctl --user start dev-server.service
```

**Step 3: Verify service is running**

```bash
# Check status
systemctl --user status dev-server.service
```

**Expected Output**:
```
● dev-server.service - Development Web Server
     Loaded: loaded (~/.config/systemd/user/dev-server.service; enabled)
     Active: active (running) since ...
   Main PID: 12345 (ruby)
     CGroup: /user.slice/user-1000.slice/user@1000.service/app.slice/dev-server.service
             └─12345 /usr/bin/ruby /usr/bin/jekyll serve ...
```

**Step 4: Test server**

```bash
# Open browser to localhost:4000
omarchy-launch-browser "http://localhost:4000"
```

**Step 5: View logs**

```bash
# View all logs
journalctl --user -u dev-server.service

# Follow logs in real-time
journalctl --user -u dev-server.service -f

# Show only today's logs
journalctl --user -u dev-server.service --since today

# Show last 50 lines
journalctl --user -u dev-server.service -n 50
```

**Step 6: Test auto-restart**

```bash
# Kill the process (simulating crash)
pkill -f "jekyll serve"

# Wait a few seconds, then check status
sleep 15
systemctl --user status dev-server.service
```

**Expected**: Service should show as active (running) again after `RestartSec=10` seconds.

**Step 7: Manage service**

```bash
# Stop service
systemctl --user stop dev-server.service

# Start service
systemctl --user start dev-server.service

# Restart service (reload code changes)
systemctl --user restart dev-server.service

# Disable service (don't start on login)
systemctl --user disable dev-server.service
```

**Advanced: Add Pre-Start Checks**

```bash
nano ~/.config/systemd/user/dev-server.service
```

**Add pre-start script**:
```ini
[Service]
ExecStartPre=/bin/bash -c 'cd %h/dev/my-project && bundle check || bundle install'
ExecStart=/usr/bin/bundle exec jekyll serve --host 0.0.0.0 --port 4000
```

**Explanation**: Before starting Jekyll, checks if gems are installed. If not, runs `bundle install`.

**Advanced: Conditional Service (Only Start if Directory Exists)**

```ini
[Unit]
Description=Development Web Server
ConditionPathExists=%h/dev/my-project

[Service]
...
```

**Explanation**: Service won't start if `~/dev/my-project` doesn't exist. Useful for optional services.

**Advanced: Service with Notification**

```bash
# Create wrapper script
nano ~/.config/hypr/scripts/dev-server-wrapper.sh
```

**Content**:
```bash
#!/bin/bash

# Notify when starting
notify-send "Dev Server" "Starting Jekyll on http://localhost:4000"

# Run Jekyll
cd ~/dev/my-project
bundle exec jekyll serve --host 0.0.0.0 --port 4000
```

**Make executable**:
```bash
chmod +x ~/.config/hypr/scripts/dev-server-wrapper.sh
```

**Update service**:
```ini
[Service]
ExecStart=/bin/bash %h/.config/hypr/scripts/dev-server-wrapper.sh
```

**Why Use This**: systemd services provide robust background process management with automatic restart, proper logging, dependency management, and resource control. Much more reliable than simple `exec-once` for long-running services.

---

## Default Autostart Services

### Core Omarchy Services

These services start automatically via Omarchy's default autostart configuration:

**Waybar** (status bar):
```
app-Hyprland-waybar-*.scope
```
- Displays system information, workspaces, tray icons
- Restarts: `omarchy-restart-waybar`

**Hypridle** (idle management):
```
app-Hyprland-hypridle-*.scope
```
- Manages screen dimming, locking, suspend
- Config: `~/.config/hypr/hypridle.conf`
- Restarts: `omarchy-restart-hypridle`

**Swayosd** (on-screen display):
```
app-Hyprland-swayosd-*.scope
```
- Shows volume, brightness, caps lock indicators
- Restarts: `omarchy-restart-swayosd`

**Swaybg** (wallpaper):
```
app-Hyprland-swaybg-*.scope
```
- Displays background image
- Auto-restarts when theme changes

**Walker** (application launcher):
```
app-Hyprland-walker-*.scope
```
- Daemon for fast launcher startup
- Restarts: `omarchy-restart-walker`

### Desktop Portals

**xdg-desktop-portal-hyprland**:
```
xdg-desktop-portal-hyprland.service
```
- Screen sharing, file dialogs
- Required for many Wayland apps

**xdg-desktop-portal**:
```
xdg-desktop-portal.service
```
- Generic portal backend
- Works with Hyprland portal

### Optional Services

These may or may not be active depending on your setup:

**Fcitx5** (input method):
- For Asian languages
- Enabled: `fcitx5.service` is running

**PipeWire** (audio):
```
pipewire.service
wireplumber.service
pipewire-pulse.service
```
- Audio server and session manager
- Restart: `omarchy-restart-pipewire`

**Bluetooth**:
```
bluetooth.service
```
- Bluetooth management
- Restart: `omarchy-restart-bluetooth`

---

## Troubleshooting

### Application Not Starting on Login

**Symptom**: Added app to autostart.conf but it doesn't launch

**Diagnosis**:

```bash
# Check if autostart.conf is being sourced
grep autostart.conf ~/.config/hypr/hyprland.conf

# Check for syntax errors
hyprctl reload
# Look for error notifications
```

**Possible Causes**:

1. **Wrong syntax**:
   ```conf
   # ❌ Wrong
   exec-once = dropbox

   # ✅ Correct
   exec-once = uwsm-app -- dropbox
   ```

2. **Application not in PATH**:
   ```bash
   # Check if command exists
   which dropbox

   # If not found, use full path
   exec-once = uwsm-app -- /usr/bin/dropbox
   ```

3. **Missing dependencies**:
   ```bash
   # Try running manually
   uwsm-app -- dropbox
   # Check error message
   ```

4. **Application requires display/network**:
   ```conf
   # Add delay
   exec-once = bash -c 'sleep 5 && uwsm-app -- dropbox'
   ```

---

### Service Fails to Start

**Symptom**: systemd service shows "failed" status

**Diagnosis**:

```bash
# Check detailed status
systemctl --user status my-service.service

# View recent logs
journalctl --user -u my-service.service -n 50

# Check for errors
journalctl --user -u my-service.service | grep -i error
```

**Common Issues**:

1. **WorkingDirectory doesn't exist**:
   ```ini
   # Check path in service file
   WorkingDirectory=%h/dev/project

   # Verify directory exists
   ls -la ~/dev/project
   ```

2. **ExecStart command not found**:
   ```ini
   # Use full path
   ExecStart=/usr/bin/bundle exec jekyll serve

   # Or fix PATH
   Environment="PATH=/usr/local/bin:/usr/bin:/bin"
   ```

3. **Permission issues**:
   ```bash
   # Check file permissions
   ls -la ~/.config/systemd/user/my-service.service

   # Should be readable
   chmod 644 ~/.config/systemd/user/my-service.service
   ```

4. **Port already in use**:
   ```bash
   # Check if port is taken
   lsof -i :4000

   # Kill conflicting process or change port
   ```

---

### Application Starts Multiple Times

**Symptom**: Multiple instances of same app running

**Cause**: Using `exec` instead of `exec-once`

**Fix**:

```conf
# ❌ Wrong - runs on every config reload
exec = uwsm-app -- dropbox

# ✅ Correct - runs once per session
exec-once = uwsm-app -- dropbox
```

---

### UWSM Integration Not Working

**Symptom**: App starts but doesn't appear in systemd units

**Diagnosis**:

```bash
# Check if UWSM is running
systemctl --user status uwsm.service

# Test uwsm-app manually
uwsm-app -- notify-send "Test"

# Check environment
uwsm-app -- env | grep WAYLAND
```

**Fix**:

If UWSM isn't available:
```conf
# Fallback: Launch without UWSM
exec-once = dropbox
```

---

## Best Practices

### Do's

**DO use exec-once for applications**
```conf
# ✅ Good
exec-once = uwsm-app -- spotify
```

**DO use uwsm-app for GUI applications**
```conf
# ✅ Proper session integration
exec-once = uwsm-app -- signal-desktop
```

**DO group related autostart entries**
```conf
# === Communication Apps ===
exec-once = uwsm-app -- signal-desktop
exec-once = uwsm-app -- discord

# === Productivity ===
exec-once = uwsm-app -- dropbox
exec-once = uwsm-app -- 1password --silent
```

**DO add comments explaining why**
```conf
# Start Dropbox after 5s to ensure network is ready
exec-once = bash -c 'sleep 5 && uwsm-app -- dropbox'
```

**DO use systemd for long-running services**
- Background servers
- Daemons
- Anything that should restart on crash

**DO test commands manually first**
```bash
# Test before adding to autostart
uwsm-app -- my-app
```

### Don'ts

**DON'T use exec for applications**
```conf
# ❌ Wrong - launches on every reload
exec = spotify

# ✅ Correct
exec-once = uwsm-app -- spotify
```

**DON'T start resource-intensive apps without delay**
```conf
# ❌ May slow down login
exec-once = uwsm-app -- chrome
exec-once = uwsm-app -- vscode
exec-once = uwsm-app -- obs

# ✅ Stagger with delays
exec-once = uwsm-app -- chrome
exec-once = bash -c 'sleep 3 && uwsm-app -- vscode'
exec-once = bash -c 'sleep 6 && uwsm-app -- obs'
```

**DON'T rely on shell expansions**
```conf
# ❌ Unreliable
exec-once = uwsm-app -- ~/my-app

# ✅ Use full path
exec-once = uwsm-app -- /home/username/my-app

# ✅ Or use %h in systemd
WorkingDirectory=%h/my-app
```

**DON'T start GUI apps without uwsm-app**
```conf
# ❌ May have environment issues
exec-once = signal-desktop

# ✅ Use uwsm-app
exec-once = uwsm-app -- signal-desktop
```

---

## Related Documentation

### Customization
- **Config Management** (`config-management.md`) - Managing configuration files
- **Keybindings** (`keybindings.md`) - Launching apps with keybindings
- **Advanced Tweaks** (`advanced-tweaks.md`) - Hooks, environment variables

### Desktop Environment
- **Hyprland Integration** (`../04-desktop-environment/hyprland-integration.md`) - Hyprland configuration
- **Waybar Configuration** (`../04-desktop-environment/waybar-configuration.md`) - Status bar setup

### System Setup
- **Audio Bluetooth WiFi** (`../07-system-setup/audio-bluetooth-wifi.md`) - Audio services
- **Security Auth** (`../07-system-setup/security-auth.md`) - Security-related services

### Commands
- **Launcher Commands** (`../02-core-commands/launcher-commands.md`) - omarchy-launch-* commands
- **System Management** (`../02-core-commands/system-management.md`) - Service restart commands

### Reference
- **Quick Reference** (`../10-reference/quick-reference.md`) - Common autostart examples
- **Troubleshooting** (`../10-reference/troubleshooting.md`) - Service issues

---

## Notes

**Last Updated**: 2025-10-21

**Configuration Files Analyzed**:
- `/home/zack/.config/hypr/autostart.conf` (user autostart)
- `/home/zack/.local/share/omarchy/default/hypr/autostart.conf` (default autostart)
- `/home/zack/.config/hypr/hyprland.conf` (main config)

**System Services Verified**:
- systemd user services for Hyprland, Waybar, Hypridle
- UWSM integration and app launching
- XDG desktop portal services

**Verification**: All commands, service examples, and configurations tested on Omarchy system running Hyprland on Arch Linux.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
