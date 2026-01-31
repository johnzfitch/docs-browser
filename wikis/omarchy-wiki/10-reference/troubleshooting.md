# Omarchy Troubleshooting Guide

**Purpose:** Comprehensive problem-solving reference for common Omarchy issues
**Use Case:** When things don't work as expected

*Last Updated: 2025-10-21*

---

## Quick Diagnostic Commands

```bash
# Check system status
omarchy-version
omarchy-version-branch

# Check for updates
omarchy-update-available

# View recent logs
journalctl --user -n 50

# Check service status
systemctl --user status walker
systemctl --user status waybar
systemctl --user status pipewire

# Upload diagnostic logs
omarchy-upload-log
```

---

## Table of Contents

- [Theme Issues](#theme-issues)
- [Walker Problems](#walker-problems)
- [Audio Issues](#audio-issues)
- [WiFi & Network](#wifi--network)
- [Display & Graphics](#display--graphics)
- [Update Problems](#update-problems)
- [Performance Issues](#performance-issues)
- [Package Management](#package-management)
- [Authentication Issues](#authentication-issues)
- [Desktop Environment](#desktop-environment)
- [Log Files & Diagnostics](#log-files--diagnostics)
- [Emergency Recovery](#emergency-recovery)

---

## Theme Issues

### Theme Not Applying

**Symptoms:** Theme command runs but nothing changes visually

**Diagnosis:**
```bash
# Check current theme
omarchy-theme-current

# Check theme symlink
ls -la ~/.config/omarchy/current/theme

# List available themes
omarchy-theme-list
```

**Solutions:**

1. **Refresh theme completely:**
```bash
# Reapply current theme
omarchy-theme-set $(omarchy-theme-current)

# Restart affected services
omarchy-restart-walker
omarchy-restart-waybar
hyprctl reload
```

2. **Check theme files exist:**
```bash
# Verify theme directory
ls ~/.config/omarchy/themes/$(omarchy-theme-current)/

# Should contain: alacritty.toml, hyprland.conf, waybar.css, etc.
```

3. **Reinstall theme if corrupted:**
```bash
# Backup first
cp -r ~/.config/omarchy/themes/catppuccin ~/.config/omarchy/themes/catppuccin.backup

# Switch to different theme
omarchy-theme-set gruvbox

# Update themes (pulls fresh copies)
omarchy-theme-update
```

**Prevention:**
- Don't edit theme files directly in `~/.config/omarchy/themes/`
- Use `omarchy-theme-update` regularly
- Create custom themes by copying, not modifying originals

---

### Theme Partially Applies (Some Apps Only)

**Symptoms:** Waybar changes but terminal doesn't, or VS Code updates but browser doesn't

**Diagnosis:**
```bash
# Test each component manually
omarchy-theme-set-terminal
omarchy-theme-set-gnome
omarchy-theme-set-browser
omarchy-theme-set-vscode
omarchy-theme-set-obsidian

# Check for error messages
```

**Solutions:**

**Terminal not updating:**
```bash
# Check if terminal imports theme
grep import ~/.config/alacritty/alacritty.toml
# Should show: import = ["~/.config/omarchy/current/theme/alacritty.toml"]

# Force reload
omarchy-theme-set-terminal

# Or restart terminal
pkill alacritty && alacritty &
```

**VS Code not updating:**
```bash
# Check if code is in PATH
which code

# Manually run setter
omarchy-theme-set-vscode

# Check if extension installed
code --list-extensions | grep theme

# Check for skip flag
ls ~/.local/state/omarchy/toggles/skip-vscode-theme-changes
# If exists, remove it:
rm ~/.local/state/omarchy/toggles/skip-vscode-theme-changes
```

**Browser not updating:**
```bash
# Check if chromium/brave installed
which chromium
which brave

# Manually run setter
omarchy-theme-set-browser

# Restart browser completely
pkill chromium && chromium &
```

**Prevention:**
- Keep applications updated
- Don't override theme configs in user config files
- Install required extensions (VS Code themes, etc.)

---

### Background/Wallpaper Not Changing

**Symptoms:** Theme switches but wallpaper stays the same

**Diagnosis:**
```bash
# Check if theme has backgrounds
ls ~/.config/omarchy/current/theme/backgrounds/

# Check background symlink
readlink ~/.config/omarchy/current/background

# Check if swaybg is running
pgrep swaybg
```

**Solutions:**

1. **Cycle background manually:**
```bash
omarchy-theme-bg-next
```

2. **Restart swaybg:**
```bash
pkill swaybg
setsid uwsm-app -- swaybg -i ~/.config/omarchy/current/background -m fill &
```

3. **Theme has no backgrounds (intentional):**
```bash
# Some minimal themes use solid colors
# This is normal - swaybg will show black background
# Add your own images to theme/backgrounds/
cp ~/Pictures/wallpaper.png ~/.config/omarchy/current/theme/backgrounds/1-custom.png
omarchy-theme-bg-next
```

**Prevention:**
- Add multiple backgrounds to themes you use
- Name backgrounds with numeric prefixes (1-name.png, 2-name.png)
- Use image formats: PNG, JPG, WebP

---

### Colors Look Wrong or Washed Out

**Symptoms:** Colors don't match theme preview or look incorrect

**Diagnosis:**
```bash
# Check if monitor color profile is applied
hyprctl monitors

# Check terminal color settings
cat ~/.config/alacritty/alacritty.toml | grep -A 20 colors
```

**Solutions:**

1. **Reset gamma/color settings:**
```bash
# Check if hyprsunset is affecting colors
omarchy-restart-hyprsunset

# Check monitor config
cat ~/.config/hypr/monitors.conf
```

2. **Check for terminal overrides:**
```bash
# Look for color definitions after import
grep -A 50 import ~/.config/alacritty/alacritty.toml

# Remove any [colors] sections that appear after import line
```

3. **Verify GNOME/GTK theme:**
```bash
# Check current GTK theme
gsettings get org.gnome.desktop.interface gtk-theme

# Should be Adwaita-dark for dark themes
# Reapply if wrong:
omarchy-theme-set-gnome
```

**Prevention:**
- Don't manually set display gamma
- Keep color profiles consistent
- Test themes in different lighting conditions

---

## Walker Problems

### Walker Won't Launch

**Symptoms:** SUPER+SPACE does nothing, or Walker crashes immediately

**Diagnosis:**
```bash
# Check if walker is running
pgrep walker

# Check walker service status
systemctl --user status walker

# View walker logs
journalctl --user -u walker -n 50
```

**Solutions:**

1. **Restart walker service:**
```bash
omarchy-restart-walker

# Wait 2-3 seconds, then test
```

2. **Check walker config:**
```bash
# View config for errors
cat ~/.config/walker/config.toml

# Restore default config if corrupted
omarchy-refresh-walker
```

3. **Kill stuck walker processes:**
```bash
# Force kill all walker instances
pkill -9 walker

# Wait 5 seconds
sleep 5

# Start fresh
omarchy-restart-walker
```

4. **Check for conflicting launchers:**
```bash
# Make sure rofi/wofi aren't running
pkill rofi
pkill wofi
```

**Prevention:**
- Don't edit walker config while it's running
- Use `omarchy-restart-walker` after config changes
- Keep walker package updated

---

### Walker Search Not Working

**Symptoms:** Walker opens but search doesn't find applications

**Diagnosis:**
```bash
# Check application cache
ls ~/.cache/walker/

# Check if applications are installed
ls /usr/share/applications/ | wc -l
```

**Solutions:**

1. **Refresh application list:**
```bash
omarchy-refresh-applications

# Wait for cache rebuild
sleep 3

# Restart walker
omarchy-restart-walker
```

2. **Rebuild walker cache manually:**
```bash
# Remove old cache
rm -rf ~/.cache/walker/

# Restart walker (rebuilds cache)
omarchy-restart-walker

# Wait 5-10 seconds for indexing
```

3. **Check walker modules enabled:**
```bash
# View config
cat ~/.config/walker/config.toml | grep -A 5 modules

# Should include: applications, runner
```

**Prevention:**
- Run `omarchy-refresh-applications` after installing software
- Don't delete walker cache manually
- Keep walker config modules section intact

---

### Walker Keybindings Not Working

**Symptoms:** Can't navigate Walker with keyboard

**Diagnosis:**
```bash
# Check Hyprland bindings
grep walker ~/.config/hypr/bindings.conf

# Test if walker responds to mouse
```

**Solutions:**

1. **Check Hyprland keybindings:**
```bash
# View Walker binding
grep "SUPER.*SPACE" ~/.config/hypr/bindings.conf
# Should show: bind = SUPER, SPACE, exec, omarchy-launch-walker

# Reload Hyprland config
hyprctl reload
```

2. **Check for keyboard conflicts:**
```bash
# Look for duplicate SUPER+SPACE bindings
grep -r "SPACE" ~/.config/hypr/
```

3. **Reset to default config:**
```bash
# Backup custom config
cp ~/.config/walker/config.toml ~/.config/walker/config.toml.backup

# Restore default
omarchy-refresh-walker

# Restart
omarchy-restart-walker
```

**Prevention:**
- Test keybindings after Hyprland config changes
- Avoid duplicate keybinds
- Use `hyprctl reload` after binding changes

---

## Audio Issues

### No Sound Output

**Symptoms:** Audio not working, no sound from any application

**Diagnosis:**
```bash
# Check if pipewire is running
systemctl --user status pipewire
systemctl --user status pipewire-pulse
systemctl --user status wireplumber

# Check default audio device
pactl info | grep "Default Sink"

# List audio devices
pactl list sinks short
```

**Solutions:**

1. **Restart audio services:**
```bash
omarchy-restart-pipewire

# Wait 3-5 seconds for services to start
sleep 5

# Test audio
speaker-test -t wav -c 2 -l 1
```

2. **Check audio device selection:**
```bash
# Open audio mixer
wiremix

# Select correct output device
# Adjust volume levels
```

3. **Check if application is muted:**
```bash
# List all audio streams
pactl list sink-inputs

# Unmute system audio
pactl set-sink-mute @DEFAULT_SINK@ 0

# Set volume to 50%
pactl set-sink-volume @DEFAULT_SINK@ 50%
```

4. **Reset pipewire configuration:**
```bash
# Stop services
systemctl --user stop pipewire pipewire-pulse wireplumber

# Remove session files
rm -rf ~/.local/state/pipewire/

# Restart
omarchy-restart-pipewire
```

**Prevention:**
- Don't manually kill pipewire processes
- Check audio device before system sleep/wake
- Keep pipewire packages updated

---

### Audio Crackling or Stuttering

**Symptoms:** Audio plays but has pops, clicks, or stutters

**Diagnosis:**
```bash
# Check CPU usage during audio playback
btop

# Check pipewire buffer settings
pw-top
```

**Solutions:**

1. **Increase pipewire buffer size:**
```bash
# Edit pipewire pulse config
mkdir -p ~/.config/pipewire/pipewire-pulse.conf.d/
cat > ~/.config/pipewire/pipewire-pulse.conf.d/92-low-latency.conf << 'EOF'
pulse.properties = {
    pulse.min.quantum = 1024/48000
}
EOF

# Restart audio
omarchy-restart-pipewire
```

2. **Check for CPU throttling:**
```bash
# Check current power profile
powerprofilesctl get

# Switch to performance mode
powerprofilesctl set performance
```

3. **Disable audio enhancements:**
```bash
# Open audio mixer
wiremix

# Disable effects/filters if enabled
```

**Prevention:**
- Use performance power profile for audio work
- Close background applications during audio playback
- Keep system updated for audio driver fixes

---

### Wrong Audio Output Device

**Symptoms:** Audio goes to wrong speakers/headphones

**Diagnosis:**
```bash
# List all audio output devices
pactl list sinks short

# Check current default
pactl info | grep "Default Sink"
```

**Solutions:**

1. **Switch audio output:**
```bash
# Use built-in switcher
omarchy-cmd-audio-switch

# Or use mixer GUI
wiremix
```

2. **Set default device manually:**
```bash
# List devices (note the name)
pactl list sinks short

# Set default (replace DEVICE_NAME)
pactl set-default-sink DEVICE_NAME
```

3. **Persistent device selection:**
```bash
# Edit wireplumber config
mkdir -p ~/.config/wireplumber/main.lua.d/
cat > ~/.config/wireplumber/main.lua.d/51-default-device.lua << 'EOF'
rule = {
  matches = {
    {
      { "node.name", "equals", "your_device_name" },
    },
  },
  apply_properties = {
    ["device.priority"] = 1000,
  },
}
table.insert(alsa_monitor.rules, rule)
EOF

# Restart wireplumber
systemctl --user restart wireplumber
```

**Prevention:**
- Use audio switcher instead of manual pactl commands
- Set persistent defaults for frequently used devices
- Check audio device after plugging/unplugging headphones

---

### Microphone Not Working

**Symptoms:** Can't record audio, mic not detected

**Diagnosis:**
```bash
# List input devices
pactl list sources short

# Check default input
pactl info | grep "Default Source"

# Test microphone
arecord -d 5 /tmp/test.wav && aplay /tmp/test.wav
```

**Solutions:**

1. **Select correct microphone:**
```bash
# Open mixer
wiremix

# Select input tab
# Choose correct microphone
# Adjust input volume
```

2. **Unmute microphone:**
```bash
# Unmute default source
pactl set-source-mute @DEFAULT_SOURCE@ 0

# Set input volume
pactl set-source-volume @DEFAULT_SOURCE@ 80%
```

3. **Check application permissions:**
```bash
# Some apps need explicit permission
# Grant in app settings or via pipewire
```

**Prevention:**
- Test microphone after system updates
- Check input levels before important calls
- Use hardware mute button with caution

---

## WiFi & Network

### WiFi Not Connecting

**Symptoms:** Can't connect to wireless networks

**Diagnosis:**
```bash
# Check if WiFi is blocked
rfkill list wifi

# Check WiFi interface status
ip link show

# Check NetworkManager status
systemctl status NetworkManager

# View connection attempts
journalctl -u NetworkManager -n 50
```

**Solutions:**

1. **Unblock WiFi and restart:**
```bash
# Unblock WiFi hardware
rfkill unblock wifi

# Restart WiFi
omarchy-restart-wifi

# Wait 10 seconds
sleep 10

# Try connecting again
omarchy-launch-wifi
```

2. **Restart NetworkManager:**
```bash
# Restart network service
sudo systemctl restart NetworkManager

# Wait for initialization
sleep 5

# Try connecting
nmtui
```

3. **Reset network configuration:**
```bash
# Remove saved networks (will need to re-enter passwords)
sudo rm /etc/NetworkManager/system-connections/*

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Reconnect to networks
omarchy-launch-wifi
```

4. **Check for driver issues:**
```bash
# Check WiFi driver
lspci -k | grep -A 3 -i wifi

# Check for errors
dmesg | grep -i wifi

# Update firmware
omarchy-update-firmware
```

**Prevention:**
- Don't use rfkill to disable WiFi (use NetworkManager)
- Keep firmware packages updated
- Avoid interrupting NetworkManager during connection

---

### WiFi Connected But No Internet

**Symptoms:** WiFi shows connected but no internet access

**Diagnosis:**
```bash
# Test connectivity
ping -c 3 8.8.8.8

# Test DNS resolution
nslookup google.com

# Check default route
ip route show

# Check DNS servers
cat /etc/resolv.conf
```

**Solutions:**

1. **Reconnect to network:**
```bash
# Disconnect
nmcli connection down "Network Name"

# Wait 3 seconds
sleep 3

# Reconnect
nmcli connection up "Network Name"
```

2. **Fix DNS resolution:**
```bash
# Reset DNS
sudo rm /etc/resolv.conf
sudo systemctl restart NetworkManager

# Or configure custom DNS
omarchy-setup-dns
```

3. **Release and renew IP:**
```bash
# Release DHCP lease
sudo dhclient -r

# Renew lease
sudo dhclient
```

4. **Check for captive portal:**
```bash
# Open browser to trigger captive portal login
omarchy-launch-browser http://detectportal.firefox.com
```

**Prevention:**
- Use reliable DNS servers (1.1.1.1, 8.8.8.8)
- Check router firewall settings
- Avoid public WiFi without VPN

---

### Slow Network Speed

**Symptoms:** Downloads/uploads are slower than expected

**Diagnosis:**
```bash
# Check network interface speed
ethtool wlan0 | grep Speed

# Check for errors
ip -s link show

# Monitor bandwidth
iftop
```

**Solutions:**

1. **Check WiFi signal strength:**
```bash
# View signal quality
watch -n 1 'nmcli device wifi list | grep "*"'

# Move closer to router if signal is weak
```

2. **Switch to 5GHz band:**
```bash
# List available networks
nmcli device wifi list

# Connect to 5GHz network (usually faster)
nmcli device wifi connect "Network-5G" password "yourpassword"
```

3. **Disable power saving:**
```bash
# Check if power saving enabled
iwconfig 2>&1 | grep "Power Management"

# Disable power saving
sudo iwconfig wlan0 power off
```

4. **Check for background transfers:**
```bash
# Monitor network usage
nethogs

# Stop bandwidth-heavy processes
```

**Prevention:**
- Use wired connection for large transfers
- Keep WiFi drivers updated
- Use performance power profile for network-intensive tasks

---

## Display & Graphics

### Screen Tearing

**Symptoms:** Visible horizontal lines during scrolling or video playback

**Diagnosis:**
```bash
# Check current renderer
hyprctl systeminfo | grep -i render

# Check for VRR support
hyprctl monitors | grep vrr
```

**Solutions:**

1. **Enable VRR if supported:**
```bash
# Edit monitor config
nano ~/.config/hypr/monitors.conf

# Add vrr,1 to monitor line:
# monitor = DP-1, 2560x1440@144, 0x0, 1, vrr, 1

# Reload Hyprland
hyprctl reload
```

2. **Adjust render settings:**
```bash
# Edit Hyprland config
nano ~/.config/hypr/hyprland.conf

# Add/modify:
# render {
#     explicit_sync = 1
#     explicit_sync_kms = 1
# }

# Reload
hyprctl reload
```

3. **Check GPU drivers:**
```bash
# Check current driver
lspci -k | grep -A 3 VGA

# Update system (includes GPU drivers)
omarchy-update
```

**Prevention:**
- Use native refresh rate in monitor config
- Enable VRR when available
- Keep GPU drivers updated

---

### Display Not Detected

**Symptoms:** External monitor not showing up

**Diagnosis:**
```bash
# List connected displays
hyprctl monitors

# Check physical connections
xrandr --listmonitors

# View Hyprland monitor config
cat ~/.config/hypr/monitors.conf
```

**Solutions:**

1. **Reconnect display:**
```bash
# Unplug and replug cable
# Wait 5 seconds
sleep 5

# Check again
hyprctl monitors
```

2. **Add monitor to config:**
```bash
# Edit monitor config
nano ~/.config/hypr/monitors.conf

# Add line for your monitor (example):
# monitor = HDMI-A-1, 1920x1080@60, 1920x0, 1

# Reload Hyprland
hyprctl reload
```

3. **Use auto-detection:**
```bash
# Set monitor to auto
echo "monitor = , preferred, auto, 1" >> ~/.config/hypr/monitors.conf

# Reload
hyprctl reload
```

**Prevention:**
- Configure monitors in monitors.conf before connecting
- Use quality cables (DisplayPort > HDMI)
- Check monitor input source setting

---

### Wrong Resolution or Refresh Rate

**Symptoms:** Display using incorrect resolution or refresh rate

**Diagnosis:**
```bash
# Check current settings
hyprctl monitors

# List available modes
wlr-randr
```

**Solutions:**

1. **Set correct resolution:**
```bash
# Edit monitor config
nano ~/.config/hypr/monitors.conf

# Update monitor line:
# monitor = DP-1, 2560x1440@144, 0x0, 1

# Reload
hyprctl reload
```

2. **Try safe mode settings:**
```bash
# Use lower refresh rate if unstable
# monitor = DP-1, 2560x1440@60, 0x0, 1
```

3. **Check cable capabilities:**
```bash
# DisplayPort 1.2 = up to 4K@60Hz
# DisplayPort 1.4 = up to 4K@120Hz or 8K@60Hz
# HDMI 2.0 = up to 4K@60Hz
# HDMI 2.1 = up to 4K@120Hz

# Use appropriate cable for your desired resolution/refresh rate
```

**Prevention:**
- Document working monitor configs
- Use high-quality cables rated for your resolution
- Test resolution changes before committing

---

### Laptop Screen Not Turning Off

**Symptoms:** Laptop display stays on when lid closed

**Diagnosis:**
```bash
# Check hypridle config
cat ~/.config/hypr/hypridle.conf

# Check if hypridle is running
pgrep hypridle
```

**Solutions:**

1. **Restart hypridle:**
```bash
omarchy-restart-hypridle
```

2. **Check lid switch config:**
```bash
# Edit hypridle config
nano ~/.config/hypr/hypridle.conf

# Ensure lid switch listener is enabled

# Restart
omarchy-restart-hypridle
```

3. **Manually disable display:**
```bash
# Turn off specific monitor
hyprctl keyword monitor "eDP-1,disable"

# Turn back on
hyprctl keyword monitor "eDP-1,preferred,auto,1"
```

**Prevention:**
- Don't disable hypridle service
- Keep hypridle config intact
- Test lid close behavior after updates

---

## Update Problems

### Update Fails with Errors

**Symptoms:** `omarchy-update` exits with error messages

**Diagnosis:**
```bash
# Check for disk space
df -h /

# Check for partial updates
sudo pacman -Qk

# View update logs
journalctl -n 100 | grep -i error

# Check mirror status
cat /etc/pacman.d/mirrorlist | grep -v "^#" | head -5
```

**Solutions:**

1. **Clear package cache:**
```bash
# Remove old packages
sudo pacman -Scc

# Try update again
omarchy-update
```

2. **Fix partial updates:**
```bash
# Update package database
sudo pacman -Sy

# Update system packages specifically
omarchy-update-system-pkgs
```

3. **Refresh mirror list:**
```bash
# Update mirrors
omarchy-refresh-pacman-mirrorlist

# Wait for completion
# Try update again
omarchy-update
```

4. **Fix keyring issues:**
```bash
# Update archlinux-keyring first
sudo pacman -S archlinux-keyring

# Try update again
omarchy-update
```

5. **Check for conflicts:**
```bash
# Read error messages carefully
# Remove conflicting packages if safe
sudo pacman -R conflicting-package

# Try update again
```

**Prevention:**
- Run updates regularly (weekly)
- Don't interrupt updates in progress
- Keep adequate free disk space (>5GB)
- Review error messages before retrying

---

### Update Breaks System

**Symptoms:** System unstable after update

**Diagnosis:**
```bash
# Check which packages were updated
grep -i upgraded /var/log/pacman.log | tail -20

# Check for errors
journalctl -b -p err
```

**Solutions:**

1. **Downgrade problematic package:**
```bash
# View package history
ls /var/cache/pacman/pkg/ | grep package-name

# Downgrade specific package
sudo pacman -U /var/cache/pacman/pkg/package-name-oldversion.pkg.tar.zst
```

2. **Refresh configuration:**
```bash
# Refresh all configs
omarchy-refresh-config

# Restart Hyprland
# (logout and log back in)
```

3. **Restore from snapshot:**
```bash
# If using btrfs snapshots
sudo snapper list

# Rollback to previous snapshot
sudo snapper rollback SNAPSHOT_NUMBER

# Reboot
sudo reboot
```

**Prevention:**
- Create snapshot before major updates
- Read Arch Linux news before updating
- Test updates on non-critical systems first
- Keep update logs for reference

---

### Can't Update - Package Conflicts

**Symptoms:** Update blocked by package conflicts

**Diagnosis:**
```bash
# Try update to see conflict details
omarchy-update

# Check for orphaned packages
pacman -Qtdq

# Check for packages holding packages
pacman -Qi package-name | grep "Required By"
```

**Solutions:**

1. **Remove orphaned packages:**
```bash
# List orphans
pacman -Qtdq

# Remove orphans (careful!)
sudo pacman -Rns $(pacman -Qtdq)
```

2. **Resolve specific conflicts:**
```bash
# Read conflict message
# Usually format: "package-a conflicts with package-b"

# Remove old conflicting package
sudo pacman -R package-b

# Try update again
omarchy-update
```

3. **Skip problematic packages temporarily:**
```bash
# Edit pacman config
sudo nano /etc/pacman.conf

# Add to IgnorePkg line:
# IgnorePkg = problematic-package

# Update rest of system
omarchy-update

# Remove ignore later after fix
```

**Prevention:**
- Don't install packages from random sources
- Use official repos and AUR carefully
- Read package descriptions before installing
- Keep track of manually installed packages

---

### Update Completes But System Needs Restart

**Symptoms:** Update says "restart required" but unsure why

**Diagnosis:**
```bash
# Check if kernel was updated
uname -r
pacman -Q linux | awk '{print $2}'

# Check for systemd update
systemctl --version | head -1

# Check for required restarts
needrestart -r l
```

**Solutions:**

1. **Restart system services:**
```bash
# Restart user services
systemctl --user daemon-reexec

# Restart system services
sudo systemctl daemon-reexec
```

2. **Reboot system:**
```bash
# Clean reboot
sudo reboot

# Or schedule reboot
sudo shutdown -r +5 "System reboot in 5 minutes"
```

3. **Restart specific services only:**
```bash
# If only pipewire updated
omarchy-restart-pipewire

# If only waybar updated
omarchy-restart-waybar

# If kernel modules updated (needs reboot)
sudo reboot
```

**Prevention:**
- Reboot after kernel updates
- Schedule updates during low-activity times
- Save work before running updates
- Plan for restart after major updates

---

## Performance Issues

### System Feels Slow or Laggy

**Symptoms:** General sluggishness, delayed responses

**Diagnosis:**
```bash
# Check CPU usage
btop

# Check memory usage
free -h

# Check disk I/O
iotop

# Check for zombie processes
ps aux | grep Z

# Check system load
uptime
```

**Solutions:**

1. **Close resource-heavy applications:**
```bash
# List processes by CPU usage
ps aux --sort=-%cpu | head -10

# Kill specific process
kill -15 PID

# Force kill if needed
kill -9 PID
```

2. **Free up memory:**
```bash
# Check memory usage
free -h

# Clear page cache (safe)
sync; echo 1 | sudo tee /proc/sys/vm/drop_caches

# Restart memory-heavy services
omarchy-restart-walker
omarchy-restart-waybar
```

3. **Check for background updates:**
```bash
# Check if pacman running
pgrep pacman

# Check for system indexing
pgrep baloo
pgrep tracker
```

4. **Switch to performance mode:**
```bash
# Check current power profile
powerprofilesctl get

# Switch to performance
powerprofilesctl set performance
```

5. **Check disk health:**
```bash
# Check SMART status
sudo smartctl -a /dev/nvme0n1

# Check disk usage
df -h

# Check for I/O wait
iostat -x 1 5
```

**Prevention:**
- Close unused applications regularly
- Monitor resource usage with btop
- Use performance profile for demanding tasks
- Keep adequate free disk space
- Restart system weekly

---

### High CPU Usage

**Symptoms:** CPU constantly at high percentage

**Diagnosis:**
```bash
# Monitor CPU usage
btop

# Check per-process CPU
ps aux --sort=-%cpu | head -15

# Check CPU frequency
watch -n 1 'grep MHz /proc/cpuinfo'
```

**Solutions:**

1. **Identify CPU-hungry process:**
```bash
# Find top CPU consumers
top -o %CPU

# Kill specific process
kill PID
```

2. **Check for runaway services:**
```bash
# Check systemd services
systemctl --user status

# Check for failing services
systemctl --user --failed

# Restart problematic service
systemctl --user restart service-name
```

3. **Check for CPU throttling:**
```bash
# Check throttling
sudo dmesg | grep -i throttl

# Check temperature
sensors

# Improve cooling if overheating
```

4. **Limit background processes:**
```bash
# Disable unused services
systemctl --user disable service-name

# Nice heavy processes
renice -n 10 -p PID
```

**Prevention:**
- Monitor CPU temperature
- Keep system clean (dust-free)
- Use performance power profile selectively
- Close applications when done
- Update software regularly

---

### Memory Leak or High RAM Usage

**Symptoms:** Memory usage constantly increasing, system swapping

**Diagnosis:**
```bash
# Check memory usage
free -h

# Check per-process memory
ps aux --sort=-%mem | head -15

# Check for memory leaks
watch -n 1 'free -h'

# Check swap usage
swapon --show
```

**Solutions:**

1. **Identify memory hogs:**
```bash
# Sort by memory usage
btop
# Press 'M' to sort by memory

# Kill memory-hungry processes
kill PID
```

2. **Restart leaking services:**
```bash
# Common culprits:
omarchy-restart-walker
omarchy-restart-waybar
pkill -f electron  # Electron apps can leak
```

3. **Clear caches:**
```bash
# Clear page cache
sync; echo 1 | sudo tee /proc/sys/vm/drop_caches

# Clear user cache
rm -rf ~/.cache/thumbnails/*
rm -rf ~/.cache/walker/*
```

4. **Increase swap if needed:**
```bash
# Check current swap
swapon --show

# Add swap file if none
sudo dd if=/dev/zero of=/swapfile bs=1G count=8
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

**Prevention:**
- Restart long-running applications periodically
- Monitor memory usage regularly
- Close browser tabs regularly
- Keep adequate swap space
- Update applications (fixes leaks)

---

### Slow Boot Time

**Symptoms:** System takes long time to reach desktop

**Diagnosis:**
```bash
# Analyze boot time
systemd-analyze

# Show service timing
systemd-analyze blame

# Show critical chain
systemd-analyze critical-chain

# Plot boot process
systemd-analyze plot > boot.svg
```

**Solutions:**

1. **Disable slow services:**
```bash
# Check which services are slow
systemd-analyze blame

# Disable unnecessary services
sudo systemctl disable slow-service.service

# Or mask service
sudo systemctl mask slow-service.service
```

2. **Optimize plymouth:**
```bash
# Plymouth can slow boot
# Refresh configuration
omarchy-refresh-plymouth

# Or disable if not needed
sudo systemctl disable plymouth-start.service
```

3. **Check for timeouts:**
```bash
# View boot messages
journalctl -b

# Look for "Timed out waiting for" messages
```

**Prevention:**
- Only enable needed services
- Use SSD for system drive
- Keep system updated
- Avoid heavy startup applications

---

## Package Management

### Can't Install Package - Not Found

**Symptoms:** `omarchy-pkg-install` can't find package

**Diagnosis:**
```bash
# Update package database
sudo pacman -Sy

# Search for package
pacman -Ss package-name

# Check if in AUR
yay -Ss package-name
```

**Solutions:**

1. **Check spelling and search:**
```bash
# Search official repos
pacman -Ss keyword

# Search AUR
yay -Ss keyword

# Use partial names
pacman -Ss partial
```

2. **Install from AUR if not in official repos:**
```bash
omarchy-pkg-aur-install
# Search for package name
```

3. **Add to custom package list:**
```bash
# Add to your personal packages
omarchy-pkg-add package-name
```

**Prevention:**
- Update package database regularly
- Use correct package names
- Check Arch package website for package info
- Search AUR for missing packages

---

### AUR Package Won't Build

**Symptoms:** AUR install fails during compilation

**Diagnosis:**
```bash
# Check build output for errors
# Look for "error:" messages

# Check if dependencies installed
yay -Qi package-name

# Check disk space
df -h /tmp
```

**Solutions:**

1. **Install build dependencies:**
```bash
# Update system first
omarchy-update-system-pkgs

# Install base-devel if missing
sudo pacman -S base-devel
```

2. **Clear build cache:**
```bash
# Remove build cache
rm -rf ~/.cache/yay/*

# Try install again
omarchy-pkg-aur-install
```

3. **Check for broken dependencies:**
```bash
# List broken dependencies
pacman -Qkk

# Reinstall broken packages
sudo pacman -S --overwrite '*' package-name
```

4. **Manual build:**
```bash
# Clone AUR repo
git clone https://aur.archlinux.org/package-name.git
cd package-name

# Review PKGBUILD
less PKGBUILD

# Build manually
makepkg -si
```

**Prevention:**
- Keep system updated before AUR installs
- Read PKGBUILD comments
- Check AUR package page for known issues
- Install dependencies first

---

### Package Removal Breaks Dependencies

**Symptoms:** Can't remove package due to dependencies

**Diagnosis:**
```bash
# Check what depends on package
pacman -Qi package-name | grep "Required By"

# Check reverse dependencies
pactree -r package-name
```

**Solutions:**

1. **Remove with dependencies:**
```bash
# Remove package and unused dependencies
sudo pacman -Rs package-name
```

2. **Force remove (careful!):**
```bash
# Remove ignoring dependencies (can break system!)
sudo pacman -Rdd package-name

# Only use if you know what you're doing
```

3. **Replace with alternative:**
```bash
# Install alternative first
sudo pacman -S alternative-package

# Then remove original
sudo pacman -R original-package
```

**Prevention:**
- Read dependency warnings before removing
- Use -Rs to remove unused dependencies
- Check what depends on package first
- Consider alternatives before removing core packages

---

## Authentication Issues

### Can't Unlock Screen

**Symptoms:** Password not accepted at lock screen

**Diagnosis:**
```bash
# Check if password correct (from TTY)
# Press Ctrl+Alt+F2 to get to TTY

# Login with username/password
# If login works, hyprlock issue
```

**Solutions:**

1. **Switch to TTY and fix:**
```bash
# Press Ctrl+Alt+F2
# Login
# Kill hyprlock
killall hyprlock

# Switch back to Hyprland
# Press Ctrl+Alt+F1

# Restart hypridle
omarchy-restart-hypridle
```

2. **Reset hyprlock config:**
```bash
# Refresh hyprlock configuration
omarchy-refresh-hyprlock

# Restart hypridle
omarchy-restart-hypridle

# Test lock
omarchy-lock-screen
```

3. **Check PAM configuration:**
```bash
# View PAM config
cat /etc/pam.d/hyprlock

# Should be similar to system-auth
# Restore default if corrupted
```

**Prevention:**
- Test password at lock screen after changes
- Keep PAM packages updated
- Don't modify PAM configs without backup
- Remember password!

---

### Fingerprint Authentication Not Working

**Symptoms:** Can't login with fingerprint

**Diagnosis:**
```bash
# Check if fingerprint enrolled
fprintd-list username

# Check fprintd service
systemctl status fprintd
```

**Solutions:**

1. **Re-enroll fingerprint:**
```bash
# Remove old enrollment
omarchy-setup-fingerprint --remove

# Enroll again
omarchy-setup-fingerprint
```

2. **Check PAM configuration:**
```bash
# Verify fingerprint PAM module
cat /etc/pam.d/system-local-login | grep pam_fprintd

# Should show:
# auth sufficient pam_fprintd.so
```

3. **Restart fprintd:**
```bash
sudo systemctl restart fprintd
```

**Prevention:**
- Keep fingers clean when using fingerprint
- Enroll multiple fingers
- Test fingerprint after enrollment
- Keep fprintd updated

---

### FIDO2 Key Not Recognized

**Symptoms:** Security key not working for authentication

**Diagnosis:**
```bash
# Check if key detected
lsusb | grep -i security

# Check if pam_u2f installed
pacman -Q pam-u2f
```

**Solutions:**

1. **Re-setup FIDO2:**
```bash
# Remove existing setup
omarchy-setup-fido2 --remove

# Setup again
omarchy-setup-fido2
```

2. **Check PAM configuration:**
```bash
# View PAM config
cat /etc/pam.d/system-local-login | grep u2f

# Should show pam_u2f.so line
```

3. **Check key registration:**
```bash
# View registered keys
cat ~/.config/Yubico/u2f_keys
```

**Prevention:**
- Register backup keys
- Keep pam-u2f updated
- Don't remove keys while system locked
- Test key after registration

---

## Desktop Environment

### Waybar Not Showing

**Symptoms:** Status bar missing from top of screen

**Diagnosis:**
```bash
# Check if waybar running
pgrep waybar

# Check waybar service
systemctl --user status waybar

# View waybar logs
journalctl --user -u waybar -n 50
```

**Solutions:**

1. **Restart waybar:**
```bash
omarchy-restart-waybar

# Wait 2-3 seconds
# Bar should appear
```

2. **Check waybar config:**
```bash
# Test config syntax
waybar -c ~/.config/waybar/config.jsonc

# If errors, refresh config
omarchy-refresh-waybar
omarchy-restart-waybar
```

3. **Check if hidden:**
```bash
# Toggle visibility
omarchy-toggle-waybar

# Should show/hide bar
```

**Prevention:**
- Don't edit waybar config while running
- Use `omarchy-restart-waybar` after changes
- Keep waybar package updated
- Test config before restarting

---

### Window Management Issues

**Symptoms:** Windows not moving, resizing, or focusing properly

**Diagnosis:**
```bash
# Check Hyprland status
hyprctl version

# Check for errors
journalctl -b | grep -i hyprland

# List windows
hyprctl clients
```

**Solutions:**

1. **Reload Hyprland config:**
```bash
hyprctl reload
```

2. **Check keybindings:**
```bash
# View current bindings
hyprctl binds

# Check config
cat ~/.config/hypr/bindings.conf

# Refresh if corrupted
omarchy-refresh-hyprland
```

3. **Restart Hyprland:**
```bash
# Logout and log back in
# Or from TTY:
# systemctl restart display-manager
```

**Prevention:**
- Test config changes with hyprctl reload
- Keep backups of working configs
- Don't edit configs while learning
- Read error messages carefully

---

### Notifications Not Appearing

**Symptoms:** No notification popups

**Diagnosis:**
```bash
# Check if mako running
pgrep mako

# Test notification
notify-send "Test" "This is a test notification"

# Check mako config
cat ~/.config/mako/config
```

**Solutions:**

1. **Restart mako:**
```bash
# Kill mako
pkill mako

# Start mako
mako &

# Test again
notify-send "Test" "Working now?"
```

2. **Reload mako config:**
```bash
makoctl reload
```

3. **Check if notifications dismissed:**
```bash
# View notification history
makoctl history

# Restore from history if needed
```

4. **Reset mako config:**
```bash
# Backup current
cp ~/.config/mako/config ~/.config/mako/config.backup

# Restore from theme
cp ~/.config/omarchy/current/theme/mako.ini ~/.config/mako/config

# Restart
pkill mako && mako &
```

**Prevention:**
- Don't manually kill mako
- Keep mako config syntax correct
- Test notifications after theme changes
- Check if Do Not Disturb enabled

---

### Keybindings Not Working

**Symptoms:** Keyboard shortcuts don't trigger actions

**Diagnosis:**
```bash
# View current bindings
hyprctl binds

# Check config file
cat ~/.config/hypr/bindings.conf

# Look for errors
journalctl -b | grep -i binding
```

**Solutions:**

1. **Reload Hyprland:**
```bash
hyprctl reload
```

2. **Check for conflicts:**
```bash
# Search for duplicate bindings
grep "bind.*SUPER.*T" ~/.config/hypr/*.conf

# Remove duplicates
```

3. **Test specific binding:**
```bash
# Try binding manually
hyprctl keyword bind "SUPER, T, exec, alacritty"

# If works, issue is in config file
```

4. **Reset to defaults:**
```bash
# Backup custom config
cp ~/.config/hypr/bindings.conf ~/.config/hypr/bindings.conf.backup

# Restore default
omarchy-refresh-hyprland

# Reload
hyprctl reload
```

**Prevention:**
- Test bindings after changes
- Avoid duplicate bindings
- Use consistent modifier keys
- Document custom bindings

---

## Log Files & Diagnostics

### Important Log Locations

```bash
# System logs
journalctl -b                      # Current boot
journalctl -b -1                   # Previous boot
journalctl -p err                  # Errors only
journalctl -f                      # Follow live

# User services
journalctl --user -u walker
journalctl --user -u waybar
journalctl --user -u pipewire

# Hyprland logs
cat /tmp/hypr/$(ls -t /tmp/hypr/ | head -1)/hyprland.log

# X server (if used)
cat ~/.local/share/xorg/Xorg.0.log

# Package manager
cat /var/log/pacman.log

# Boot messages
dmesg | less

# Kernel messages
sudo dmesg -T
```

---

### Using omarchy-upload-log

**Purpose:** Share diagnostic logs with maintainers

**Usage:**
```bash
# Upload logs to pastebin
omarchy-upload-log

# Returns URL to share
# Example: https://paste.org/abc123
```

**What it includes:**
- System information
- Hyprland logs
- Service status
- Recent journal entries
- Package list
- Configuration snippets

**When to use:**
- Reporting bugs
- Asking for help
- Documenting issues
- Before system changes

**Privacy note:** Review logs before sharing (may contain paths, usernames)

---

### Diagnostic Commands Reference

```bash
# System info
omarchy-launch-about
omarchy-version
uname -a
lsb_release -a

# Hardware info
lspci -k                          # PCI devices
lsusb                            # USB devices
lsblk                            # Block devices
sensors                          # Temperature sensors
inxi -F                          # Full system info

# Service status
systemctl --user status
systemctl status
systemctl --failed

# Resource usage
btop                             # Interactive monitor
htop                             # Alternative monitor
free -h                          # Memory usage
df -h                            # Disk usage
iostat -x 1 5                    # I/O statistics

# Network diagnostics
ip addr                          # IP addresses
ip route                         # Routing table
nmcli device status              # Network devices
ping -c 3 8.8.8.8               # Connectivity test
nslookup google.com             # DNS test

# Package info
pacman -Q                        # All packages
pacman -Qe                       # Explicitly installed
pacman -Qm                       # AUR packages
pacman -Qdt                      # Orphans
omarchy-pkg-missing             # Missing omarchy packages

# Process info
ps aux                          # All processes
pstree                          # Process tree
pgrep process-name              # Find process
pidof process-name              # Get PID
```

---

## Emergency Recovery

### System Won't Boot

**Symptoms:** Black screen, kernel panic, or boot loop

**Solutions:**

1. **Boot to recovery:**
```bash
# At GRUB menu, select "Advanced options"
# Choose recovery kernel or fallback

# Or boot from USB live environment
```

2. **Check disk:**
```bash
# From live USB
sudo fsck /dev/nvme0n1p2

# Fix errors if found
```

3. **Chroot and repair:**
```bash
# Mount root
sudo mount /dev/nvme0n1p2 /mnt

# Mount boot
sudo mount /dev/nvme0n1p1 /mnt/boot

# Chroot
sudo arch-chroot /mnt

# Fix issues (reinstall packages, fix config)

# Exit and reboot
exit
sudo umount -R /mnt
sudo reboot
```

**Prevention:**
- Keep recovery USB handy
- Create regular snapshots
- Don't modify boot files without backup
- Test updates on non-critical systems

---

### Hyprland Crashes on Login

**Symptoms:** Hyprland starts then immediately crashes

**Solutions:**

1. **Switch to TTY:**
```bash
# Press Ctrl+Alt+F2
# Login
```

2. **Check logs:**
```bash
# View Hyprland log
cat /tmp/hypr/*/hyprland.log | tail -100

# Look for error at end
```

3. **Reset Hyprland config:**
```bash
# Backup
cp -r ~/.config/hypr ~/.config/hypr.backup

# Restore defaults
omarchy-refresh-hyprland

# Try logging in again
```

4. **Start Hyprland manually:**
```bash
# From TTY
Hyprland

# Watch for errors
```

**Prevention:**
- Test config changes before logout
- Keep config backups
- Use `hyprctl reload` for testing
- Read error messages in logs

---

### Can't Login at All

**Symptoms:** Display manager won't accept password

**Solutions:**

1. **Reset password from TTY:**
```bash
# Press Ctrl+Alt+F2
# Login as root (if root enabled)
# Or boot from live USB

# Change user password
passwd username
```

2. **Check display manager:**
```bash
# From TTY
sudo systemctl status display-manager

# Restart display manager
sudo systemctl restart display-manager
```

3. **Boot to single user mode:**
```bash
# At GRUB, add to kernel parameters:
# single

# Or:
# init=/bin/bash
```

**Prevention:**
- Remember passwords!
- Keep recovery USB available
- Document emergency procedures
- Test password changes before logout

---

### System Completely Frozen

**Symptoms:** No response to keyboard, mouse, or network

**Solutions:**

1. **Try SysRq keys:**
```bash
# Enable SysRq
Alt + SysRq + R    # Take keyboard control
Alt + SysRq + E    # Terminate processes
Alt + SysRq + I    # Kill processes
Alt + SysRq + S    # Sync disks
Alt + SysRq + U    # Unmount filesystems
Alt + SysRq + B    # Reboot

# Mnemonic: REISUB (Raising Elephants Is So Utterly Boring)
```

2. **SSH from another machine:**
```bash
# If SSH enabled
ssh user@frozen-machine

# Check status
btop
sudo systemctl status

# Reboot
sudo reboot
```

3. **Hard reset:**
```bash
# Hold power button 10 seconds
# Last resort - may cause data loss
```

**Prevention:**
- Enable SysRq keys in kernel
- Monitor resource usage
- Keep system updated
- Don't overload system

---

## Getting More Help

### Before Asking for Help

1. **Search documentation:**
```bash
grep -r "error message" /home/zack/dev/lib/omarchy-archive/
```

2. **Check logs:**
```bash
journalctl -b -p err
```

3. **Upload diagnostic log:**
```bash
omarchy-upload-log
```

4. **Document steps to reproduce:**
- What you did
- What you expected
- What actually happened
- Error messages

---

### Community Resources

- **GitHub Issues:** [github.com/basecamp/omarchy/issues](https://github.com/basecamp/omarchy/issues)
- **Arch Wiki:** [wiki.archlinux.org](https://wiki.archlinux.org/)
- **Hyprland Wiki:** [wiki.hyprland.org](https://wiki.hyprland.org/)

---

### What to Include in Bug Reports

```bash
# System info
omarchy-version
uname -a

# Diagnostic log
omarchy-upload-log

# Error message (exact text)
# Steps to reproduce
# Expected vs actual behavior
# Screenshots if applicable
```

---

## Related Documentation

- [Quick Reference](./quick-reference.md) - Fast command lookups
- [FAQ](./faq.md) - Frequently asked questions
- [Script Index](./script-index.md) - Detailed script documentation
- [Command Index](../02-core-commands/command-index.md) - All commands A-Z

---

*This troubleshooting guide covers 20+ common issue categories with detailed solutions. For additional help, consult the FAQ or upload logs with omarchy-upload-log.*
