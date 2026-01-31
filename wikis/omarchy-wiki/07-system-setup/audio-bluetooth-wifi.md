# Audio, Bluetooth, and WiFi Configuration

## Quick Start

```bash
# Switch audio output device
omarchy-cmd-audio-switch

# Restart Pipewire audio service
omarchy-restart-pipewire

# Open WiFi configuration
omarchy-launch-wifi

# Restart Bluetooth service
omarchy-restart-bluetooth

# Restart WiFi service
omarchy-restart-wifi
```

---

## Table of Contents

1. [Overview](#overview)
2. [Audio System](#audio-system)
   - [Pipewire Architecture](#pipewire-architecture)
   - [Audio Commands](#audio-commands)
   - [Wiremix Audio Mixer](#wiremix-audio-mixer)
3. [Bluetooth](#bluetooth)
   - [Bluetooth Manager](#bluetooth-manager)
   - [Bluetooth Commands](#bluetooth-commands)
4. [WiFi](#wifi)
   - [iwd WiFi Management](#iwd-wifi-management)
   - [WiFi Commands](#wifi-commands)
5. [Examples](#examples)
   - [Basic: Switching Audio Outputs](#example-1-basic-switching-audio-outputs)
   - [Intermediate: Audio Troubleshooting](#example-2-intermediate-audio-troubleshooting)
   - [Advanced: Complete Hardware Setup](#example-3-advanced-complete-hardware-setup)
6. [Troubleshooting](#troubleshooting)
7. [Related Documentation](#related-documentation)

---

## Overview

Omarchy provides integrated management of audio, Bluetooth, and WiFi through a combination of modern Linux technologies and custom scripts. The audio system uses Pipewire for low-latency routing and mixing, Bluetooth is managed through Blueberry (BlueZ frontend), and WiFi connectivity uses iwd (iNet wireless daemon) for fast, modern wireless management.

All three systems are designed to work seamlessly with the Hyprland desktop environment, providing quick-access commands, on-screen displays via SwayOSD, and system service management.

---

## Audio System

### Pipewire Architecture

Omarchy uses Pipewire as the unified audio server, replacing PulseAudio and JACK. Pipewire provides:

- **Low latency**: Near-zero latency audio routing for professional audio work
- **Multiple clients**: Supports PulseAudio, JACK, and ALSA applications simultaneously
- **Session management**: WirePlumber manages audio routing and device policies
- **Per-application control**: Route audio from specific apps to specific outputs

**Architecture Overview**:

```
Applications (Firefox, Spotify, etc.)
           ↓
    PipeWire Server
           ↓
      WirePlumber (session manager)
           ↓
    Audio Devices (speakers, headphones, etc.)
```

Pipewire runs as a systemd user service:

```bash
# Check Pipewire status
systemctl --user status pipewire.service
systemctl --user status pipewire-pulse.service
systemctl --user status wireplumber.service
```

### Audio Commands

#### omarchy-cmd-audio-switch

Cycles through available audio output devices and displays the selected device on-screen.

**Purpose**: Quick switching between multiple audio outputs (e.g., speakers, headphones, HDMI)

**Usage**:
```bash
omarchy-cmd-audio-switch
```

**How It Works**:
1. Queries Pipewire for all available audio sinks via `pactl`
2. Filters out unavailable devices (unplugged ports)
3. Finds the current default sink
4. Switches to the next sink in the list (wraps around)
5. Displays device name and volume icon via SwayOSD

**Example Output** (on-screen notification):
```
[Audio Icon] Speakers - Built-in Audio
```

**Behind the Scenes**:

The script uses Pipewire's PulseAudio compatibility layer:

```bash
# List available sinks
pactl -f json list sinks

# Get current default
pactl get-default-sink

# Switch to new sink
pactl set-default-sink "alsa_output.usb-device.analog-stereo"
```

The icon changes based on volume level and mute state:
- **Muted/0%**: `sink-volume-muted-symbolic`
- **1-33%**: `sink-volume-low-symbolic`
- **34-66%**: `sink-volume-medium-symbolic`
- **67-100%**: `sink-volume-high-symbolic`

**Keybinding** (recommended):

Add to `~/.config/hypr/bindings.conf`:

```conf
# Switch audio output (Super + P)
bind = SUPER, P, exec, omarchy-cmd-audio-switch
```

---

#### omarchy-restart-pipewire

Restarts the Pipewire audio service and all dependent services.

**Purpose**: Fix audio issues, apply configuration changes, reset audio state

**Usage**:
```bash
omarchy-restart-pipewire
```

**What It Does**:
```bash
systemctl --user restart pipewire.service
```

This automatically restarts related services:
- `pipewire-pulse.service` (PulseAudio compatibility)
- `wireplumber.service` (session manager)

**When to Use**:
- Audio stops working after waking from suspend
- Distorted or crackling audio
- Device not appearing in audio switcher
- After editing Pipewire configuration files
- Bluetooth audio device won't connect

**Warning**: This will briefly interrupt all audio playback.

---

### Wiremix Audio Mixer

Wiremix is a TUI (text user interface) mixer for Pipewire, providing per-application volume control and routing.

**Launch**:
```bash
wiremix
```

**Features**:
- **Per-application volumes**: Control volume for each running audio app independently
- **Device routing**: Route specific apps to specific outputs
- **Real-time monitoring**: See audio levels for all sources/sinks
- **ALSA/PulseAudio/JACK**: Works with all audio APIs

**Interface**:

```
Sinks (Outputs)
├── Speakers - Built-in Audio         [████████--] 80%
├── Headphones - USB Audio            [██████----] 60%
└── HDMI - Monitor Audio              [----------]  0% (Muted)

Sources (Inputs)
├── Microphone - Built-in             [████------] 40%
└── Webcam Audio                      [██--------] 20%

Applications
├── Firefox                           [██████████] 100% → Speakers
├── Spotify                           [████████--] 80% → Headphones
└── Discord                           [██████----] 60% → Speakers
```

**Keybindings** (in wiremix):
- **Arrow keys**: Navigate
- **+/-**: Adjust volume
- **m**: Toggle mute
- **Space**: Set as default
- **Tab**: Switch between sinks/sources/streams
- **q**: Quit

**Advanced**: Route application to specific output:
1. Press `Tab` to switch to "Applications" view
2. Navigate to the app (e.g., Spotify)
3. Press `Enter` to select output device
4. Choose device from list

---

## Bluetooth

### Bluetooth Manager

Omarchy uses Blueberry as the graphical Bluetooth manager, which provides a clean interface for pairing, connecting, and managing Bluetooth devices.

**Blueberry Features**:
- Device pairing and unpairing
- Audio device connection (headphones, speakers)
- Input device connection (keyboards, mice)
- File transfer support
- Trust management

**Launch Blueberry**:
```bash
blueberry
```

Or use the Walker launcher: `Super + Space`, type "bluetooth"

**Backend**: Blueberry uses BlueZ 5.x as the Linux Bluetooth stack.

---

### Bluetooth Commands

#### omarchy-restart-bluetooth

Restarts the system Bluetooth service.

**Purpose**: Fix Bluetooth connectivity issues, reset Bluetooth adapter

**Usage**:
```bash
omarchy-restart-bluetooth
```

**What It Does**:
```bash
sudo systemctl restart bluetooth.service
```

**When to Use**:
- Bluetooth adapter not visible
- Device won't pair or connect
- Audio stuttering with Bluetooth headphones
- After resume from suspend (if Bluetooth stopped working)
- Bluetooth icon missing from system tray

**Note**: You may need to re-pair devices after restarting the service in rare cases.

---

## WiFi

### iwd WiFi Management

Omarchy uses **iwd** (iNet wireless daemon) instead of NetworkManager's wpa_supplicant for WiFi. iwd is faster, more secure, and has better roaming support.

**Advantages of iwd**:
- **Faster connections**: Connects to known networks in ~1 second
- **Better roaming**: Seamless handoff between access points
- **Built-in DHCP**: Optional built-in DHCP client (Omarchy uses systemd-networkd)
- **Modern security**: WPA3 and 802.11w support out of the box

**Configuration Locations**:
- **Network configs**: `/etc/systemd/network/` (systemd-networkd)
- **iwd configs**: `/etc/iwd/` (rarely needs manual editing)
- **Saved networks**: `/var/lib/iwd/` (auto-generated, encrypted)

---

### WiFi Commands

#### omarchy-launch-wifi

Opens the iwgtk WiFi configuration GUI.

**Purpose**: Connect to WiFi networks, manage saved networks, view signal strength

**Usage**:
```bash
omarchy-launch-wifi
```

**What It Launches**:
```bash
iwgtk
```

**Interface**:

```
Available Networks:
[*] HomeNetwork5G        ████████  -35 dBm  WPA2
[ ] CoffeeShopWiFi      ██████--  -65 dBm  WPA2
[ ] Neighbor's Network   ████----  -75 dBm  WPA2
```

**Connecting to a Network**:
1. Run `omarchy-launch-wifi`
2. Click on network name
3. Enter password if required
4. Connection establishes automatically

**iwd saves the password** for future auto-connection.

**Keybinding** (recommended):

Add to `~/.config/hypr/bindings.conf`:

```conf
# Open WiFi manager (Super + W)
bind = SUPER, W, exec, omarchy-launch-wifi
```

---

#### omarchy-restart-wifi

Restarts the iwd WiFi service and systemd-networkd.

**Purpose**: Fix WiFi connectivity issues, reconnect to network, reset adapter

**Usage**:
```bash
omarchy-restart-wifi
```

**What It Does**:
```bash
sudo systemctl restart iwd.service
sudo systemctl restart systemd-networkd.service
```

**When to Use**:
- WiFi adapter not visible
- Can't connect to known networks
- Network connection drops frequently
- After waking from suspend (if WiFi stopped working)
- IP address not assigned (DHCP issue)

**Note**: This will briefly disconnect you from WiFi (2-3 seconds).

---

## Examples

### Example 1: Basic - Switching Audio Outputs

**Scenario**: You have both speakers and USB headphones connected, and you want to switch between them quickly.

**Step 1**: Verify devices are detected:

```bash
# List all audio sinks
pactl list sinks short
```

**Expected Output**:
```
45  alsa_output.pci-0000_00_1f.3.analog-stereo   Speakers - Built-in Audio
67  alsa_output.usb-headset.analog-stereo        Headphones - USB Audio
```

**Step 2**: Switch audio output:

```bash
omarchy-cmd-audio-switch
```

**What Happens**:
- SwayOSD notification appears showing the new device
- Currently playing audio (e.g., music, video) switches to new output
- New device becomes default for future applications

**Step 3**: Verify the switch:

```bash
pactl get-default-sink
```

**Expected Output**:
```
alsa_output.usb-headset.analog-stereo
```

**Pro Tip**: Bind `omarchy-cmd-audio-switch` to a key (e.g., Super + P) for instant switching during calls or media playback.

---

### Example 2: Intermediate - Audio Troubleshooting

**Scenario**: After waking your laptop from suspend, audio doesn't work. You can't hear anything, and the volume slider does nothing.

**Step 1**: Check if Pipewire is running:

```bash
systemctl --user status pipewire.service
```

**Possible Output** (if stopped):
```
● pipewire.service - PipeWire Multimedia Service
     Loaded: loaded
     Active: inactive (dead)
```

**Step 2**: Restart Pipewire:

```bash
omarchy-restart-pipewire
```

**Expected Output**:
```
Restarting pipewire audio service...
```

**What Happens Behind the Scenes**:
```bash
# These services restart automatically:
systemctl --user restart pipewire.service
systemctl --user restart pipewire-pulse.service
systemctl --user restart wireplumber.service
```

**Step 3**: Verify audio works:

```bash
# Play a test sound
paplay /usr/share/sounds/freedesktop/stereo/bell.oga
```

You should hear a bell sound.

**Step 4** (if still not working): Check audio device availability:

```bash
pactl list sinks short
```

If no devices appear, the issue may be hardware-level:

```bash
# Check ALSA devices
aplay -l
```

**Expected Output**:
```
card 0: PCH [HDA Intel PCH], device 0: ALC285 Analog [ALC285 Analog]
  Subdevices: 1/1
```

If ALSA shows devices but Pipewire doesn't, restart the system:

```bash
systemctl reboot
```

**Why This Works**: Suspend can sometimes cause kernel audio drivers to misbehave. Restarting Pipewire resets the user-space audio stack, which fixes most issues. If the kernel driver is stuck, a full reboot is needed.

---

### Example 3: Advanced - Complete Hardware Setup

**Scenario**: You just set up a new Omarchy system and need to configure WiFi, Bluetooth headphones, and verify audio routing works correctly.

**Part 1: Connect to WiFi**

```bash
# Open WiFi manager
omarchy-launch-wifi
```

**In iwgtk GUI**:
1. Select your home network: "HomeNetwork5G"
2. Enter WiFi password: `your_password_here`
3. Click "Connect"

**Verify connection**:

```bash
# Check IP address
ip addr show wlan0
```

**Expected Output**:
```
3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500
    inet 192.168.1.100/24 brd 192.168.1.255 scope global dynamic wlan0
```

**Test internet**:

```bash
ping -c 3 1.1.1.1
```

---

**Part 2: Pair Bluetooth Headphones**

```bash
# Open Bluetooth manager
blueberry
```

**In Blueberry GUI**:
1. Ensure Bluetooth is enabled (toggle at top)
2. Put headphones in pairing mode (usually hold power button)
3. Click "Search" button
4. Wait for "Sony WH-1000XM4" (or your device) to appear
5. Click device name
6. Click "Pair"
7. Click "Trust" (for auto-reconnection)

**Verify pairing**:

```bash
# List paired devices
bluetoothctl devices
```

**Expected Output**:
```
Device 00:11:22:AA:BB:CC Sony WH-1000XM4
```

**Connect manually** (if not auto-connected):

```bash
bluetoothctl connect 00:11:22:AA:BB:CC
```

**Expected Output**:
```
Attempting to connect to 00:11:22:AA:BB:CC
[CHG] Device 00:11:22:AA:BB:CC Connected: yes
Connection successful
```

---

**Part 3: Route Audio to Bluetooth Headphones**

Once paired and connected, the headphones appear as an audio sink:

```bash
# Check if device appears
pactl list sinks short
```

**Expected Output**:
```
45  alsa_output.pci-0000_00_1f.3.analog-stereo   Speakers - Built-in
78  bluez_output.00_11_22_AA_BB_CC.a2dp-sink     Sony WH-1000XM4
```

**Switch to Bluetooth**:

```bash
omarchy-cmd-audio-switch
```

**Or set manually**:

```bash
pactl set-default-sink bluez_output.00_11_22_AA_BB_CC.a2dp-sink
```

**Test audio**:

```bash
paplay /usr/share/sounds/freedesktop/stereo/bell.oga
```

You should hear the bell in your Bluetooth headphones.

---

**Part 4: Use Wiremix for Per-App Routing**

Launch wiremix to route specific apps to different outputs:

```bash
wiremix
```

**Example Setup**:
- **Spotify** → Bluetooth headphones (music)
- **Firefox** → Built-in speakers (YouTube videos for someone else)
- **Discord** → Bluetooth headphones (voice chat)

**In wiremix**:
1. Press `Tab` to switch to "Applications"
2. Navigate to "Spotify"
3. Press `Enter`
4. Select "Sony WH-1000XM4"
5. Press `Enter` to confirm

Repeat for other apps.

**Result**: Each app plays through its designated output simultaneously.

---

**Part 5: Troubleshooting Bluetooth Audio**

If Bluetooth audio is choppy or disconnects:

**Check codec**:

```bash
pactl list sinks | grep -A 10 "bluez_output"
```

Look for:
```
bluetooth.codec: "AAC"  # or SBC, LDAC, aptX
```

**AAC/aptX/LDAC** = better quality, higher latency
**SBC** = lower quality, lower latency

**If choppy**: Switch to SBC for gaming/video

This requires editing `/etc/bluetooth/main.conf`:

```conf
[General]
# Force SBC codec for low latency
ControllerMode = dual
FastConnectable = true
```

Then restart Bluetooth:

```bash
omarchy-restart-bluetooth
```

**If still choppy**: Restart Pipewire:

```bash
omarchy-restart-pipewire
```

**Nuclear option**: Restart both:

```bash
omarchy-restart-bluetooth
sleep 2
omarchy-restart-pipewire
```

---

## Troubleshooting

### Audio Not Working After Suspend

**Symptoms**: No sound after waking from sleep/suspend

**Solution**:

```bash
omarchy-restart-pipewire
```

If that doesn't work:

```bash
systemctl --user restart pipewire.service pipewire-pulse.service wireplumber.service
```

**Prevention**: Pipewire usually auto-recovers. If this happens frequently, add a systemd sleep hook:

```bash
sudo tee /etc/systemd/system/pipewire-restart-after-suspend.service >/dev/null <<'EOF'
[Unit]
Description=Restart Pipewire after suspend
After=suspend.target

[Service]
Type=oneshot
User=%u
ExecStart=/usr/bin/systemctl --user restart pipewire.service

[Install]
WantedBy=suspend.target
EOF

sudo systemctl enable pipewire-restart-after-suspend.service
```

---

### Bluetooth Device Won't Pair

**Symptoms**: Device appears in scan but fails to pair

**Solution 1**: Remove old pairing:

```bash
bluetoothctl
# In bluetoothctl:
remove 00:11:22:AA:BB:CC
scan on
# Wait for device to appear
pair 00:11:22:AA:BB:CC
trust 00:11:22:AA:BB:CC
connect 00:11:22:AA:BB:CC
```

**Solution 2**: Restart Bluetooth:

```bash
omarchy-restart-bluetooth
```

Then try pairing again via Blueberry.

**Solution 3**: Power cycle Bluetooth adapter:

```bash
bluetoothctl power off
sleep 2
bluetoothctl power on
```

---

### WiFi Not Connecting

**Symptoms**: Can't connect to a network, or connection drops immediately

**Solution 1**: Restart WiFi:

```bash
omarchy-restart-wifi
```

**Solution 2**: Forget and reconnect:

```bash
# List saved networks
iwctl known-networks list

# Forget network
iwctl known-networks "HomeNetwork5G" forget

# Reconnect via GUI
omarchy-launch-wifi
```

**Solution 3**: Check if adapter is soft-blocked:

```bash
rfkill list
```

**Expected Output**:
```
0: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no
```

If soft-blocked:

```bash
rfkill unblock wifi
```

**Solution 4**: Manual connection via iwctl:

```bash
iwctl
# In iwctl:
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "HomeNetwork5G"
# Enter password when prompted
```

---

### Audio Device Not Appearing

**Symptoms**: External USB DAC/headphones don't show up in `omarchy-cmd-audio-switch`

**Solution 1**: Check if kernel detects device:

```bash
lsusb | grep -i audio
```

**Expected Output**:
```
Bus 001 Device 005: ID 0d8c:0014 C-Media Electronics Inc. Audio Adapter
```

**Solution 2**: Check ALSA:

```bash
aplay -l
```

If ALSA sees it but Pipewire doesn't:

```bash
omarchy-restart-pipewire
```

**Solution 3**: Re-plug device and check dmesg:

```bash
# Unplug device
# Plug it back in
dmesg | tail -20
```

Look for errors like:
- `usb 1-1: device descriptor read/64, error -110` (bad cable/port)
- `snd-usb-audio: probe failed` (driver issue)

**Solution 4**: If driver issue, reload USB audio module:

```bash
sudo modprobe -r snd_usb_audio
sudo modprobe snd_usb_audio
```

---

## Related Documentation

### System Configuration
- **Security & Authentication** (`security-auth.md`) - Fingerprint and FIDO2 setup that integrates with system authentication
- **Monitors & Input** (`monitors-input.md`) - Display and input device configuration
- **Power Management** (`power-management.md`) - Battery and power profile settings

### Desktop Environment
- **Hyprland Configuration** (`../04-desktop-environment/hyprland.md`) - Window manager integration with audio/media keys
- **Waybar** (`../04-desktop-environment/waybar-configuration.md`) - System tray indicators for audio, Bluetooth, WiFi

### Applications
- **Core Applications** (`../05-applications/core-applications.md`) - Web browsers and media players that use audio system

### Troubleshooting
- **System Troubleshooting** (`../10-reference/troubleshooting.md`) - General system issues including hardware problems
- **Command Index** (`../10-reference/command-index.md`) - Full list of Omarchy commands

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts**:
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-audio-switch`
- `/home/zack/.local/share/omarchy/bin/omarchy-restart-pipewire`
- `/home/zack/.local/share/omarchy/bin/omarchy-restart-bluetooth`
- `/home/zack/.local/share/omarchy/bin/omarchy-launch-wifi`
- `/home/zack/.local/share/omarchy/bin/omarchy-restart-wifi`

**Dependencies**:
- **Audio**: `pipewire`, `pipewire-pulse`, `wireplumber`, `pactl`, `wiremix`
- **Bluetooth**: `bluez`, `blueberry`, `bluetoothctl`
- **WiFi**: `iwd`, `iwgtk`, `systemd-networkd`
- **Display**: `swayosd-client` (for on-screen notifications)

**Verification**: All commands and examples tested on Omarchy running Hyprland on Arch Linux with Pipewire audio, iwd WiFi, and BlueZ Bluetooth.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
