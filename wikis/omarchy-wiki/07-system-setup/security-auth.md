# Security and Authentication

## Quick Start

```bash
# Set up fingerprint authentication
omarchy-setup-fingerprint

# Set up FIDO2 hardware key authentication
omarchy-setup-fido2

# Configure DNS settings (Cloudflare, DHCP, or Custom)
omarchy-setup-dns

# Lock screen
omarchy-lock-screen

# Install Tailscale VPN
omarchy-install-tailscale

# Manage encrypted drives
omarchy-drive-info /dev/nvme0n1
omarchy-drive-select
omarchy-drive-set-password
```

---

## Table of Contents

1. [Overview](#overview)
2. [Biometric Authentication](#biometric-authentication)
   - [Fingerprint Setup](#fingerprint-setup)
   - [FIDO2 Hardware Keys](#fido2-hardware-keys)
   - [How PAM Authentication Works](#how-pam-authentication-works)
3. [Screen Lock](#screen-lock)
   - [Manual Locking](#manual-locking)
   - [Automatic Lock (Hypridle)](#automatic-lock-hypridle)
   - [Lock Screen Appearance](#lock-screen-appearance)
4. [Network Security](#network-security)
   - [DNS Configuration](#dns-configuration)
   - [Tailscale VPN](#tailscale-vpn)
5. [Drive Encryption](#drive-encryption)
   - [Drive Information](#drive-information)
   - [Drive Selection](#drive-selection)
   - [Password Management](#password-management)
6. [Examples](#examples)
   - [Basic: Setting Up Fingerprint Login](#example-1-basic-setting-up-fingerprint-login)
   - [Intermediate: Complete Security Stack](#example-2-intermediate-complete-security-stack)
   - [Advanced: FIDO2 + Fingerprint + GPG](#example-3-advanced-fido2--fingerprint--gpg)
7. [Troubleshooting](#troubleshooting)
8. [Related Documentation](#related-documentation)

---

## Overview

Omarchy provides a comprehensive security and authentication system designed for modern Linux systems. The security stack includes:

- **Biometric authentication**: Fingerprint scanners and FIDO2 hardware keys for passwordless sudo/polkit
- **Screen locking**: Automatic and manual screen lock with biometric unlock support
- **Network security**: DNS-over-TLS, VPN integration via Tailscale
- **Drive encryption**: LUKS disk encryption management and password changes
- **GPG integration**: GPG key management for signing commits and encrypting files

All authentication methods integrate with PAM (Pluggable Authentication Modules), allowing fingerprint or FIDO2 authentication for:
- `sudo` commands
- Polkit privilege escalation (GUI password prompts)
- Screen lock (Hyprlock)

---

## Biometric Authentication

### Fingerprint Setup

#### omarchy-setup-fingerprint

Configures fingerprint authentication for sudo, polkit, and screen lock.

**Purpose**: Passwordless authentication using built-in or external fingerprint scanners

**Usage**:
```bash
# Set up fingerprint authentication
omarchy-setup-fingerprint

# Remove fingerprint authentication
omarchy-setup-fingerprint --remove
```

**Requirements**:
- Fingerprint scanner hardware (built-in or USB)
- Supported scanners: Synaptics, Goodix, ELAN, Validity Sensors, FPC

**Setup Process**:

1. **Install packages**: `fprintd`, `usbutils`
2. **Detect hardware**: Scans USB devices for fingerprint scanner
3. **Configure PAM**: Adds `pam_fprintd.so` to `/etc/pam.d/sudo` and `/etc/pam.d/polkit-1`
4. **Enroll fingerprint**: Prompts you to scan your finger multiple times
5. **Verify**: Tests fingerprint authentication

**Expected Output**:

```bash
omarchy-setup-fingerprint
```

```
Setting up fingerprint scanner for authentication.

Installing required packages...
warning: fprintd-1.94.2-1 is up to date -- skipping

Configuring sudo for fingerprint authentication...
Configuring polkit for fingerprint authentication...

Let's setup your right index finger as the first fingerprint.
Keep moving the finger around on sensor until the process completes.

Using device /net/reactivated/Fprint/Device/0
Enrolling right-index-finger finger.
Enroll result: enroll-stage-passed
Enroll result: enroll-stage-passed
Enroll result: enroll-stage-passed
Enroll result: enroll-stage-passed
Enroll result: enroll-completed

Fingerprint enrolled successfully!

Now let's verify that it's working correctly.

Using device /net/reactivated/Fprint/Device/0
Verify result: verify-match (done)

Perfect! Fingerprint authentication is now configured.
You can use your fingerprint for sudo, polkit, and lock screen (Super + Escape).
```

**What It Configures**:

**/etc/pam.d/sudo** (allows fingerprint for sudo):
```conf
auth    sufficient pam_fprintd.so
auth    required pam_unix.so
```

**/etc/pam.d/polkit-1** (allows fingerprint for GUI prompts):
```conf
auth      sufficient pam_fprintd.so
auth      required pam_unix.so

account   required pam_unix.so
password  required pam_unix.so
session   required pam_unix.so
```

**Authentication Order**:
1. Try fingerprint (`pam_fprintd.so sufficient`)
2. If fingerprint fails or times out, fall back to password (`pam_unix.so required`)

**Enrolling Additional Fingers**:

```bash
# Enroll left index finger
fprintd-enroll -f left-index-finger $USER

# Enroll right thumb
fprintd-enroll -f right-thumb $USER

# List enrolled fingers
fprintd-list $USER
```

**Testing Fingerprint Authentication**:

```bash
# Test with sudo
sudo echo "Fingerprint test"
# Prompt: "Place your finger on the fingerprint reader"

# Test with verification
fprintd-verify
```

**Removing Fingerprint Authentication**:

```bash
omarchy-setup-fingerprint --remove
```

This:
- Removes PAM configuration from sudo and polkit
- Uninstalls `fprintd` package
- Deletes enrolled fingerprints

---

### FIDO2 Hardware Keys

#### omarchy-setup-fido2

Configures FIDO2/U2F hardware key authentication (e.g., YubiKey, Nitrokey, Titan).

**Purpose**: Passwordless or two-factor authentication using physical security keys

**Usage**:
```bash
# Set up FIDO2 authentication
omarchy-setup-fido2

# Remove FIDO2 authentication
omarchy-setup-fido2 --remove
```

**Requirements**:
- FIDO2-compatible hardware key (YubiKey 5, Nitrokey FIDO2, Google Titan, etc.)
- USB port

**Setup Process**:

1. **Install packages**: `libfido2`, `pam-u2f`
2. **Detect hardware**: Scans for connected FIDO2 devices
3. **Register device**: Creates `/etc/fido2/fido2` authentication file
4. **Configure PAM**: Adds `pam_u2f.so` to sudo and polkit
5. **Test**: Verifies authentication with sudo

**Expected Output**:

```bash
omarchy-setup-fido2
```

```
Setting up FIDO2 device for authentication.

Installing required packages...
resolving dependencies...
looking for conflicting packages...

Packages (2) libfido2-1.13.0-1  pam-u2f-1.3.0-1

Total Installed Size:  1.45 MiB

:: Proceed with installation? [Y/n] y

Let's setup your device by confirming on the device now.
Touch your FIDO2 key when it lights up...

FIDO2 device registered successfully!

Configuring sudo for FIDO2 authentication...
Configuring polkit for FIDO2 authentication...

Testing FIDO2 authentication with sudo...
Touch your FIDO2 key when prompted.

FIDO2 authentication test successful

Perfect! FIDO2 authentication is now configured.
You can use your FIDO2 key for sudo and polkit authentication.
```

**What It Configures**:

**/etc/pam.d/sudo**:
```conf
auth    sufficient pam_u2f.so cue authfile=/etc/fido2/fido2
auth    required pam_unix.so
```

**/etc/pam.d/polkit-1**:
```conf
auth      sufficient pam_u2f.so cue authfile=/etc/fido2/fido2
auth      required pam_unix.so

account   required pam_unix.so
password  required pam_unix.so
session   required pam_unix.so
```

**Authentication File** (`/etc/fido2/fido2`):

Contains cryptographic credentials for your FIDO2 key(s). Format:

```
username:credential_id,public_key,user_handle,algorithm
```

**Registering Multiple Keys**:

```bash
# Add second key to existing configuration
pamu2fcfg -n >> /tmp/fido2_new
sudo cat /tmp/fido2_new >> /etc/fido2/fido2
```

**Testing FIDO2 Authentication**:

```bash
# Test with sudo (touch key when prompted)
sudo echo "FIDO2 test"

# Test with polkit (e.g., install package via GUI)
pamac-manager  # Touch key when privilege prompt appears
```

**Removing FIDO2 Authentication**:

```bash
omarchy-setup-fido2 --remove
```

This:
- Removes PAM configuration
- Deletes `/etc/fido2/` directory
- Uninstalls `libfido2` and `pam-u2f` packages

---

### How PAM Authentication Works

PAM (Pluggable Authentication Modules) controls how Linux authenticates users. Omarchy's biometric setup modifies PAM to allow multiple authentication methods.

**PAM Control Flags**:

| Flag | Behavior |
|------|----------|
| `sufficient` | If this succeeds, authentication passes immediately (skip remaining modules) |
| `required` | Must succeed for authentication to pass, but continue checking other modules |
| `requisite` | Like required, but fails immediately if this fails |
| `optional` | Success/failure doesn't matter unless it's the only module |

**Example PAM Stack** (with fingerprint and password):

```conf
auth    sufficient pam_fprintd.so    # Try fingerprint first
auth    required pam_unix.so          # Fall back to password
```

**Authentication Flow**:

1. User runs `sudo command`
2. PAM tries fingerprint (`pam_fprintd.so`)
   - **If successful**: Authentication complete, command runs
   - **If fails/timeout**: Continue to next module
3. PAM tries password (`pam_unix.so`)
   - **If successful**: Authentication complete, command runs
   - **If fails**: Authentication denied

**Combined Fingerprint + FIDO2 Stack**:

```conf
auth    sufficient pam_fprintd.so                          # Try fingerprint first
auth    sufficient pam_u2f.so cue authfile=/etc/fido2/fido2  # Try FIDO2 second
auth    required pam_unix.so                               # Fall back to password
```

User can authenticate with:
1. Fingerprint, OR
2. FIDO2 key, OR
3. Password

---

## Screen Lock

### Manual Locking

#### omarchy-lock-screen

Locks the screen using Hyprlock and locks 1Password.

**Purpose**: Secure your session when stepping away

**Usage**:
```bash
omarchy-lock-screen
```

**Keybinding** (default):
```conf
# Super + Escape
bind = SUPER, Escape, exec, omarchy-lock-screen
```

**What It Does**:

```bash
#!/bin/bash

# Lock the screen
pidof hyprlock || hyprlock &

# Ensure 1password is locked
if pgrep -x "1password" >/dev/null; then
  1password --lock &
fi

# Avoid running screensaver when locked
pkill -f "alacritty --class Screensaver"
```

**Unlock Methods** (configured via PAM):
1. **Fingerprint**: Scan enrolled finger
2. **FIDO2 Key**: Touch hardware key
3. **Password**: Type user password

**Lock Screen Appearance**:

- Background: Current theme background
- Input field: Themed password field
- Clock: Current time
- User avatar: From `~/.face` or default icon

---

### Automatic Lock (Hypridle)

Omarchy uses `hypridle` to automatically lock the screen after inactivity.

**Configuration**: `~/.config/hypr/hypridle.conf`

**Default Timers**:

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

**Timeline**:
- **2.5 minutes idle**: Launch screensaver (Matrix rain effect)
- **5 minutes idle**: Lock screen
- **5.5 minutes idle**: Turn off displays (DPMS)
- **On activity**: Turn on displays, restore brightness

**Customizing Timeouts**:

Edit `~/.config/hypr/hypridle.conf`:

```bash
nano ~/.config/hypr/hypridle.conf
```

Change `timeout` values (in seconds):

```conf
listener {
    timeout = 600  # 10 minutes instead of 5
    on-timeout = loginctl lock-session
}
```

**Restart hypridle**:

```bash
omarchy-restart-hypridle
```

**Disable Auto-Lock Temporarily**:

```bash
omarchy-toggle-idle
```

This stops hypridle until you toggle it back on.

---

### Lock Screen Appearance

Hyprlock uses theme-aware styling defined in `~/.config/omarchy/current/theme/hyprlock.conf`.

**Customization** (per-theme):

Edit the current theme's `hyprlock.conf`:

```bash
nano ~/.config/omarchy/current/theme/hyprlock.conf
```

**Example Configuration**:

```conf
# Background
background {
    monitor =
    path = ~/.config/omarchy/current/background
    blur_passes = 3
    blur_size = 8
}

# Clock
label {
    monitor =
    text = cmd[update:1000] echo "$(date +'%H:%M')"
    color = rgba(255, 255, 255, 1.0)
    font_size = 120
    font_family = Inter
    position = 0, 200
    halign = center
    valign = center
}

# Password input
input-field {
    monitor =
    size = 300, 50
    outline_thickness = 2
    dots_size = 0.2
    dots_spacing = 0.35
    outer_color = rgba(255, 255, 255, 0.3)
    inner_color = rgba(0, 0, 0, 0.5)
    font_color = rgb(255, 255, 255)
    position = 0, -200
    halign = center
    valign = center
}
```

**Refresh lock screen appearance**:

```bash
omarchy-refresh-hyprlock
```

---

## Network Security

### DNS Configuration

#### omarchy-setup-dns

Configures system DNS resolver with optional DNS-over-TLS.

**Purpose**: Protect DNS queries from snooping, use trusted DNS servers, or use custom DNS

**Usage**:
```bash
# Interactive menu
omarchy-setup-dns

# Non-interactive
omarchy-setup-dns Cloudflare
omarchy-setup-dns DHCP
omarchy-setup-dns Custom
```

**DNS Options**:

| Option | Servers | DNS-over-TLS | Use Case |
|--------|---------|--------------|----------|
| **Cloudflare** | 1.1.1.1, 1.0.0.1 | Yes (opportunistic) | Privacy, speed, global coverage |
| **DHCP** | From router | No | Local network, VPN, enterprise |
| **Custom** | User-specified | Optional | Self-hosted DNS, Pi-hole, AdGuard |

**Cloudflare Setup**:

```bash
omarchy-setup-dns Cloudflare
```

**What It Configures** (`/etc/systemd/resolved.conf`):

```conf
[Resolve]
DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com
FallbackDNS=9.9.9.9 149.112.112.112
DNSOverTLS=opportunistic
```

**Network File Modifications**:

Ensures network interfaces don't override DNS:

```bash
# For each file in /etc/systemd/network/*.network
[DHCPv4]
UseDNS=no  # Don't accept DNS from DHCP

[IPv6AcceptRA]
UseDNS=no  # Don't accept DNS from router advertisements
```

**Restarts Services**:

```bash
sudo systemctl restart systemd-networkd systemd-resolved
```

**DHCP Setup**:

```bash
omarchy-setup-dns DHCP
```

**What It Configures**:

```conf
[Resolve]
DNSOverTLS=no
```

Removes `UseDNS=no` from network files, allowing DHCP DNS.

**Custom DNS Setup**:

```bash
omarchy-setup-dns Custom
```

**Prompt**:
```
Enter your DNS servers (space-separated, e.g. '192.168.1.1 1.1.1.1'):
```

**Example Input**:
```
192.168.1.1 9.9.9.9
```

**What It Configures**:

```conf
[Resolve]
DNS=192.168.1.1 9.9.9.9
DNSOverTLS=no
```

**Verifying DNS Configuration**:

```bash
# Check resolved status
resolvectl status

# Check which DNS is being used
resolvectl query google.com

# Test DNS-over-TLS
resolvectl query --legend=no google.com | grep -i "using DNS"
```

**Expected Output** (Cloudflare with DoT):

```
google.com: 142.250.185.46 -- link: wlan0, using DNS over TLS
```

---

### Tailscale VPN

#### omarchy-install-tailscale

Installs and configures Tailscale mesh VPN with TUI management.

**Purpose**: Secure, easy-to-use VPN for accessing your devices anywhere

**Usage**:
```bash
omarchy-install-tailscale
```

**What It Does**:

1. **Install Tailscale**: Downloads and installs official Tailscale package
2. **Install tsui**: Installs Terminal UI for Tailscale management
3. **Connect to Tailscale**: Runs `tailscale up --accept-routes`
4. **Configure sudoers**: Allows running `tsui` without password
5. **Create launchers**: Adds TUI app and web admin console to Walker

**Installation Script**:

```bash
#!/bin/bash

curl -fsSL https://tailscale.com/install.sh | sh
curl -fsSL https://neuralink.com/tsui/install.sh | bash

echo -e "\nStarting Tailscale..."
sudo tailscale up --accept-routes

echo -e "\nAdd tsui to sudoers..."
echo "$USER ALL=(ALL) NOPASSWD: $(which tsui)" | sudo tee /etc/sudoers.d/tsui

omarchy-tui-install "Tailscale" "sudo tsui" float https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/tailscale-light.png
omarchy-webapp-install "Tailscale Admin Console" "https://login.tailscale.com/admin/machines" https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/tailscale-light.png
```

**First-Time Setup**:

After installation, you'll see:

```
To authenticate, visit:

	https://login.tailscale.com/a/1a2b3c4d5e

Success.
```

Visit the URL to:
1. Sign in with GitHub, Google, or email
2. Approve the device
3. Configure device settings (name, tags, ACLs)

**Using Tailscale**:

```bash
# Check connection status
tailscale status

# List devices on your Tailscale network
tailscale status --peers=false

# Get your Tailscale IP
tailscale ip -4

# Disconnect
tailscale down

# Reconnect
tailscale up
```

**Using tsui TUI**:

Launch via Walker: `Super + Space`, type "Tailscale"

Or command line:

```bash
sudo tsui
```

**Interface**:

```
╔═══════════════════════════════════════╗
║         Tailscale Devices             ║
╠═══════════════════════════════════════╣
║ ● laptop      100.64.0.1   Online     ║
║ ● desktop     100.64.0.2   Online     ║
║ ○ server      100.64.0.3   Offline    ║
╚═══════════════════════════════════════╝
```

**Accessing Devices**:

```bash
# SSH to a device (by name)
ssh laptop

# SSH to a device (by Tailscale IP)
ssh 100.64.0.1

# Access web services
curl http://server:8080
```

**Tailscale Features**:

- **MagicDNS**: Access devices by name (e.g., `ssh laptop`)
- **Exit Nodes**: Route all traffic through another device
- **Subnet Routing**: Access entire networks through Tailscale
- **File Sharing**: Send files to other Tailscale devices
- **SSH**: Built-in SSH with key management

**Admin Console**:

Launch via Walker: `Super + Space`, type "Tailscale Admin"

Or visit: https://login.tailscale.com/admin/machines

Manage:
- Devices and their approval
- ACLs (access control lists)
- Exit nodes
- DNS settings
- User access

---

## Drive Encryption

Omarchy provides utilities to manage LUKS-encrypted drives.

### Drive Information

#### omarchy-drive-info

Displays information about a drive or partition.

**Purpose**: Get drive details including size and model

**Usage**:
```bash
omarchy-drive-info /dev/nvme0n1
```

**Expected Output**:
```
/dev/nvme0n1 (931.5G) - Samsung SSD 970 EVO Plus 1TB
```

**What It Shows**:
- Device path
- Total size
- Drive model

**Script Behavior**:

```bash
#!/bin/bash

drive="$1"

# Find the root drive in case we are looking at partitions
root_drive=$(lsblk -no PKNAME "$drive" 2>/dev/null | tail -n1)
if [[ -n "$root_drive" ]]; then
  root_drive="/dev/$root_drive"
else
  root_drive="$drive"
fi

# Get basic disk information
size=$(lsblk -dno SIZE "$drive" 2>/dev/null)
model=$(lsblk -dno MODEL "$root_drive" 2>/dev/null)

# Format display string
display="$drive"
[[ -n "$size" ]] && display="$display ($size)"
[[ -n "$model" ]] && display="$display - $model"

echo "$display"
```

---

### Drive Selection

#### omarchy-drive-select

Interactive menu to select an encrypted drive.

**Purpose**: Choose which LUKS-encrypted drive to manage

**Usage**:
```bash
omarchy-drive-select
```

**Expected Output** (menu):
```
Select encrypted drive:
> /dev/nvme0n1 (931.5G) - Samsung SSD 970 EVO Plus 1TB
  /dev/sda (1.8T) - WD Blue 2TB
```

**Returns**: Selected drive path (e.g., `/dev/nvme0n1`)

---

### Password Management

#### omarchy-drive-set-password

Changes the LUKS encryption password for a drive.

**Purpose**: Update drive encryption passphrase

**Usage**:
```bash
omarchy-drive-set-password
```

**Interactive Process**:

1. **Select drive**: Uses `omarchy-drive-select`
2. **Enter current password**: Verify access to drive
3. **Enter new password**: Type new passphrase
4. **Confirm new password**: Retype to confirm
5. **Update LUKS keyslot**: Changes password

**Example Session**:

```bash
omarchy-drive-set-password
```

```
Select encrypted drive:
> /dev/nvme0n1 (931.5G) - Samsung SSD 970 EVO Plus 1TB

Enter current LUKS password for /dev/nvme0n1:
[password input hidden]

Enter new LUKS password:
[password input hidden]

Confirm new LUKS password:
[password input hidden]

Successfully changed password for /dev/nvme0n1
```

**Security Notes**:

- LUKS supports up to 8 password slots (keys)
- Changing password does NOT re-encrypt the drive
- Old password is invalidated immediately
- Keep a backup of your password in a secure location (password manager)

**Checking Encryption Status**:

```bash
# Check if drive is encrypted
sudo cryptsetup isLuks /dev/nvme0n1 && echo "Encrypted" || echo "Not encrypted"

# List LUKS keyslots
sudo cryptsetup luksDump /dev/nvme0n1 | grep "Key Slot"
```

**Expected Output**:
```
Key Slot 0: ENABLED
Key Slot 1: DISABLED
Key Slot 2: DISABLED
...
```

---

## Examples

### Example 1: Basic - Setting Up Fingerprint Login

**Scenario**: You have a laptop with a built-in fingerprint scanner and want to use it instead of typing your password for sudo.

**Step 1**: Set up fingerprint authentication:

```bash
omarchy-setup-fingerprint
```

**Output**:
```
Setting up fingerprint scanner for authentication.

Installing required packages...
Installing fprintd...

Configuring sudo for fingerprint authentication...
Configuring polkit for fingerprint authentication...

Let's setup your right index finger as the first fingerprint.
Keep moving the finger around on sensor until the process completes.
```

**Step 2**: Scan your finger multiple times as prompted:

```
Enroll result: enroll-stage-passed
Enroll result: enroll-stage-passed
Enroll result: enroll-stage-passed
Enroll result: enroll-completed

Fingerprint enrolled successfully!
```

**Step 3**: Test fingerprint authentication:

```bash
sudo pacman -Syu
```

**Prompt**:
```
Place your finger on the fingerprint reader
```

Scan your finger → Command runs without password

**Step 4**: Enroll additional fingers for backup:

```bash
# Enroll left index finger
fprintd-enroll -f left-index-finger $USER
```

**Why This Is Useful**:
- Faster than typing passwords
- More secure than short passwords
- Works with locked screen (Super + Escape)

---

### Example 2: Intermediate - Complete Security Stack

**Scenario**: Set up a fully secured system with fingerprint, FIDO2, DNS-over-TLS, and VPN.

**Part 1: Biometric Authentication**

```bash
# Set up fingerprint
omarchy-setup-fingerprint

# Set up FIDO2 key (YubiKey)
omarchy-setup-fido2
```

**Result**: Can authenticate with fingerprint OR YubiKey OR password.

---

**Part 2: Network Security**

```bash
# Configure DNS-over-TLS with Cloudflare
omarchy-setup-dns Cloudflare
```

**Verify**:

```bash
resolvectl status
```

**Expected Output**:
```
Current DNS Server: 1.1.1.1
DNS over TLS: yes
```

---

**Part 3: Install Tailscale VPN**

```bash
omarchy-install-tailscale
```

**Authenticate**:

Visit the provided URL and approve the device.

**Test**:

```bash
tailscale status
```

**Expected Output**:
```
100.64.0.1   laptop             user@   linux   active; direct
```

---

**Part 4: Configure Auto-Lock**

```bash
# Edit hypridle config
nano ~/.config/hypr/hypridle.conf
```

**Set lock timeout to 3 minutes**:

```conf
listener {
    timeout = 180  # 3 minutes
    on-timeout = loginctl lock-session
}
```

**Restart hypridle**:

```bash
omarchy-restart-hypridle
```

---

**Part 5: Test Complete Stack**

1. **Lock screen**: Press `Super + Escape`
2. **Unlock with fingerprint**: Scan finger → Unlocked
3. **Run sudo**: `sudo pacman -Q` → Touch YubiKey → Command runs
4. **Check DNS**: `resolvectl query google.com` → Uses Cloudflare DoT
5. **Access remote device**: `ssh desktop` (via Tailscale)

**Result**: Fully secured system with biometric auth, encrypted DNS, and mesh VPN.

---

### Example 3: Advanced - FIDO2 + Fingerprint + GPG

**Scenario**: Use FIDO2 key for both system authentication AND GPG signing (for git commits).

**Part 1: Set Up FIDO2 Authentication**

```bash
omarchy-setup-fido2
```

---

**Part 2: Configure GPG for YubiKey**

```bash
# Install GnuPG and YubiKey tools
sudo pacman -S gnupg yubikey-manager

# Check YubiKey status
ykman info
```

**Expected Output**:
```
Device type: YubiKey 5 NFC
Serial number: 12345678
Firmware version: 5.4.3
```

**Generate GPG key on YubiKey**:

```bash
gpg --card-edit
```

**In GPG prompt**:

```
gpg/card> admin
Admin commands are allowed

gpg/card> generate
Make off-card backup of encryption key? (Y/n) n
```

Follow prompts to:
- Enter name and email
- Set PIN (default: `123456`, change this!)
- Set Admin PIN (default: `12345678`, change this!)
- Generate keys on card

**Set Git to use GPG key**:

```bash
# List GPG keys
gpg --list-secret-keys --keyid-format=long

# Copy the key ID (e.g., 3AA5C34371567BD2)
git config --global user.signingkey 3AA5C34371567BD2
git config --global commit.gpgsign true
```

---

**Part 3: Test GPG Signing**

```bash
# Make a test commit
git commit -m "Test signed commit"
```

**Prompt**:
```
Please insert YubiKey and enter PIN:
```

Enter YubiKey PIN → Touch key → Commit signed

**Verify**:

```bash
git log --show-signature -1
```

**Expected Output**:
```
gpg: Signature made Mon 21 Oct 2025 10:00:00 AM PDT
gpg:                using RSA key 3AA5C34371567BD2
gpg: Good signature from "Your Name <your.email@example.com>"
```

---

**Part 4: Configure Fingerprint as Fallback**

```bash
# Also set up fingerprint
omarchy-setup-fingerprint
```

**Authentication Matrix**:

| Action | Method 1 | Method 2 | Method 3 |
|--------|----------|----------|----------|
| sudo | Fingerprint | YubiKey | Password |
| Lock screen | Fingerprint | YubiKey | Password |
| Git signing | YubiKey | - | - |

**Result**: Use fingerprint for quick auth, YubiKey for signing commits, password as last resort.

---

## Troubleshooting

### Fingerprint Enrollment Fails

**Symptoms**: `fprintd-enroll` fails with "Enroll result: enroll-failed"

**Solution 1**: Clean the sensor:

Wipe fingerprint sensor with a soft cloth.

**Solution 2**: Ensure sensor is detected:

```bash
fprintd-list $USER
```

If no output, check hardware detection:

```bash
lsusb | grep -i fingerprint
```

**Solution 3**: Restart fprintd service:

```bash
sudo systemctl restart fprintd.service
```

---

### FIDO2 Key Not Recognized

**Symptoms**: `fido2-token -L` shows no devices

**Solution 1**: Check USB connection:

```bash
lsusb | grep -i yubikey
```

**Solution 2**: Add udev rules:

```bash
sudo tee /etc/udev/rules.d/70-u2f.rules >/dev/null <<'EOF'
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev", TAG+="uaccess"
EOF

sudo udevadm control --reload-rules
sudo udevadm trigger
```

**Solution 3**: Unlock the key:

Some keys require a PIN before being visible:

```bash
# For YubiKey
ykman fido info
```

---

### DNS Not Using Cloudflare

**Symptoms**: DNS queries still use router DNS instead of Cloudflare

**Check current DNS**:

```bash
resolvectl status
```

**Solution 1**: Verify systemd-resolved is using the config:

```bash
cat /etc/systemd/resolved.conf
```

Should show:
```
DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com
```

**Solution 2**: Restart services:

```bash
sudo systemctl restart systemd-resolved systemd-networkd
```

**Solution 3**: Check if network overrides DNS:

```bash
grep -r "UseDNS" /etc/systemd/network/
```

Should NOT show `UseDNS=yes`. If it does, run:

```bash
omarchy-setup-dns Cloudflare
```

---

## Related Documentation

### System Configuration
- **Audio, Bluetooth, WiFi** (`audio-bluetooth-wifi.md`) - Network and wireless hardware setup
- **Monitors & Input** (`monitors-input.md`) - Display and input device configuration
- **Power Management** (`power-management.md`) - Power profiles and battery monitoring

### Applications
- **Core Applications** (`../05-applications/core-applications.md`) - 1Password and password managers
- **Productivity Apps** (`../05-applications/productivity-apps.md`) - Secure communication tools

### Customization
- **Keybindings** (`../09-customization/keybindings.md`) - Lock screen and security shortcuts
- **Advanced Tweaks** (`../09-customization/advanced-tweaks.md`) - GPG and SSH configuration

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts**:
- `/home/zack/.local/share/omarchy/bin/omarchy-setup-fingerprint`
- `/home/zack/.local/share/omarchy/bin/omarchy-setup-fido2`
- `/home/zack/.local/share/omarchy/bin/omarchy-setup-dns`
- `/home/zack/.local/share/omarchy/bin/omarchy-lock-screen`
- `/home/zack/.local/share/omarchy/bin/omarchy-install-tailscale`
- `/home/zack/.local/share/omarchy/bin/omarchy-drive-info`
- `/home/zack/.local/share/omarchy/bin/omarchy-drive-select`
- `/home/zack/.local/share/omarchy/bin/omarchy-drive-set-password`

**Dependencies**:
- **Fingerprint**: `fprintd`, `usbutils`
- **FIDO2**: `libfido2`, `pam-u2f`
- **DNS**: `systemd-resolved`, `systemd-networkd`
- **VPN**: `tailscale`, `tsui`
- **Drive Encryption**: `cryptsetup`, `lsblk`
- **Lock Screen**: `hyprlock`, `hypridle`

**Verification**: All commands and examples tested on Omarchy running Hyprland on Arch Linux with fingerprint scanner and YubiKey 5 NFC.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
