# SSH Server Control

**Purpose:** Simple on-demand SSH server control for secure remote access to omarchy.

**Use Case:** Enable SSH access from iPhone or other devices only when needed, maintaining security through minimal exposure.

---

## Table of Contents

- [Quick Start](#quick-start)
- [Overview](#overview)
- [Scripts](#scripts)
- [Security Considerations](#security-considerations)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

### Start SSH Server

ssh-on

Or use SUPER + O → Start SSH Server

### Stop SSH Server

ssh-off

Or use SUPER + O → Stop SSH Server

### One-Time Setup

Run once to configure passwordless sudo and firewall:

ssh-setup

---

## Overview

The SSH control system provides:

1. **On-Demand Access** - Start SSH only when needed
2. **Quick Controls** - Available in SUPER + O docs menu
3. **Security First** - Stop SSH when done to minimize attack surface
4. **Passwordless Sudo** - No password required for SSH control commands

### Connection Details

| Setting | Value |
|---------|-------|
| Hostname | z4ck |
| IP Address | 192.168.4.111 |
| Port | 22 |
| Username | zack |
| Auth Method | Password |

---

## Scripts

### ssh-setup

Location: `~/.local/bin/ssh-setup`

**Purpose:** One-time setup for SSH control scripts

**Usage:**

ssh-setup

**What it does:**
- Configures passwordless sudo for SSH control
- Opens SSH port in firewall (ufw)
- Enables ssh-on and ssh-off commands without password prompts

**Note:** Requires sudo password once during setup

---

### ssh-optimize

Location: `~/.local/bin/ssh-optimize`

**Purpose:** Apply performance optimizations for faster SFTP file transfers

**Usage:**

ssh-optimize

**What it does:**
1. Creates automatic backup of current SSH configuration
2. Installs optimized sshd config:
   - Fast ciphers (chacha20-poly1305)
   - Disables DNS lookups
   - Enables compression
   - Optimized keep-alive settings
3. Increases network buffer sizes (128MB) for large file transfers
4. Optionally makes config immutable (prevents accidental changes)
5. Logs all changes to omarchy-archive

**Safety Features:**
- ✅ Automatic backup before changes
- ✅ Full logging of all modifications
- ✅ Easy restore script generated
- ✅ Optional immutable flag protection

**Logs:** `~/dev/lib/omarchy-archive/08-utilities/ssh-optimization-logs/`

**Backups:** `~/dev/lib/omarchy-archive/08-utilities/ssh-backups/`

**Note:** Run once after ssh-setup for best performance

---

### ssh-optimize-backup

Location: `~/.local/bin/ssh-optimize-backup`

**Purpose:** Manually create backup of SSH configuration

**Usage:**

ssh-optimize-backup

**What it does:**
- Backs up `/etc/ssh/sshd_config`
- Backs up `/etc/ssh/sshd_config.d/`
- Saves current network settings
- Creates timestamped restore script

**Restore:**

~/dev/lib/omarchy-archive/08-utilities/ssh-backups/[timestamp]/restore.sh

---

### ssh-on

Location: `~/.local/bin/ssh-on`

**Purpose:** Start the SSH server

**Usage:**

ssh-on

**Features:**
- Checks if SSH is already running
- Starts sshd service
- Displays connection info (IP address)
- Shows success/failure status

**Example Output:**

🔓 Starting SSH server...
✅ SSH is now running
📱 Connect from iPhone: ssh zack@192.168.4.111

---

### ssh-off

Location: `~/.local/bin/ssh-off`

**Purpose:** Stop the SSH server

**Usage:**

ssh-off

**Features:**
- Stops sshd service
- Verifies shutdown
- Shows success/failure status

**Example Output:**

🔒 Stopping SSH server...
✅ SSH is now stopped

---

## Security Considerations

### Best Practices ✅

1. **Stop SSH When Done**
   - Always run `ssh-off` after finishing remote access
   - Minimizes exposure to network attacks

2. **Use Strong Passwords**
   - SSH uses your user password
   - Ensure it's strong and unique

3. **Monitor SSH Access**
   - Check SSH logs periodically: `journalctl -u sshd`
   - Watch for unauthorized access attempts

4. **Consider SSH Keys** (Future Enhancement)
   - More secure than password authentication
   - Prevents brute-force attacks

### Security Features

- **Firewall Protected:** SSH port only open when explicitly allowed
- **On-Demand Only:** SSH not running by default or at boot
- **Local Network:** Only accessible on 192.168.4.x network
- **Encrypted:** All SSH traffic is encrypted

---

## Troubleshooting

### SSH Won't Start

**Problem:** `ssh-on` shows "Failed to start SSH"

**Solutions:**

Check if SSH is already running:

systemctl status sshd

Check firewall:

sudo ufw status

Manually start and check logs:

sudo systemctl start sshd
journalctl -u sshd -n 50

---

### Can't Connect from iPhone

**Problem:** Connection refused or timeout

**Solutions:**

1. Verify SSH is running:

systemctl is-active sshd

2. Check IP address (may have changed):

ip addr show | grep "inet " | grep -v "127.0.0.1"

3. Test SSH locally first:

ssh localhost

4. Verify firewall allows SSH:

sudo ufw status | grep ssh

---

### Permission Denied

**Problem:** "Permission denied" when trying to connect

**Solutions:**

1. Verify username is correct (should be "zack")
2. Check password is correct
3. Check SSH logs on omarchy:

journalctl -u sshd -n 20

---

### Scripts Don't Work (Need Sudo)

**Problem:** ssh-on/ssh-off ask for password

**Solution:** Run the setup script:

ssh-setup

This configures passwordless sudo for SSH control commands.

---

## iPhone SSH Client Setup

### Recommended Apps

1. **Termius** (Free)
   - Clean interface
   - Built-in key management
   - Supports SFTP

2. **Blink Shell** (Paid)
   - Professional grade
   - Excellent performance
   - Mosh support

### Connection Settings

- **Host:** 192.168.4.111
- **Port:** 22
- **Username:** zack
- **Password:** [your user password]

### Accessing Big Boy2 Drive

After connecting via SSH:

cd /home/zack/bigboy

---

## Performance Optimizations

### Running ssh-optimize

For significantly faster SFTP file transfers (especially video streaming):

ssh-optimize

This will:
1. **Create automatic backup** - full rollback capability
2. **Apply server optimizations:**
   - Fast ciphers (chacha20 - ~30% faster than AES)
   - Disable DNS lookups (faster connections)
   - Enable compression (better for text files)
   - Increase network buffers to 128MB (default is 16MB)
3. **Ask about immutable flag** - prevents accidental config changes
4. **Log everything** to omarchy-archive

### What Gets Changed

**File created:** `/etc/ssh/sshd_config.d/50-performance.conf`

Contents:
- UseDNS no
- GSSAPIAuthentication no
- Ciphers chacha20-poly1305@openssh.com,...
- MACs hmac-sha2-256-etm@openssh.com,...
- Compression yes
- TCPKeepAlive yes

**Network buffers (sysctl):**
- net.core.rmem_max = 128MB
- net.core.wmem_max = 128MB
- TCP window scaling enabled

### Immutable Flag Protection

When you make the config immutable:

sudo chattr +i /etc/ssh/sshd_config.d/50-performance.conf

**Protection:**
- ✅ Prevents accidental deletion
- ✅ Prevents package updates from overwriting
- ✅ Prevents even root from modifying (until unlocked)

**To unlock for changes:**

sudo chattr -i /etc/ssh/sshd_config.d/50-performance.conf

### Rollback/Restore

Every optimization creates a backup with restore script:

List backups:

ls -la ~/dev/lib/omarchy-archive/08-utilities/ssh-backups/

Restore from backup:

~/dev/lib/omarchy-archive/08-utilities/ssh-backups/[timestamp]/restore.sh

### Performance Expectations

**Before optimization:**
- Connection time: ~1-2 seconds
- Large file transfer: ~40-60 MB/s (local network)
- Video buffering: Occasional pauses

**After optimization:**
- Connection time: <500ms (connection reuse)
- Large file transfer: ~80-120 MB/s (local network)
- Video buffering: Smooth playback, minimal buffering

**Note:** Actual speeds depend on WiFi, disk speed (Big Boy2 is HDD), and network congestion

---

## Future Enhancements

### SSH Key Authentication

For password-less, more secure authentication:

1. Generate key on iPhone SSH client
2. Copy public key to omarchy: `~/.ssh/authorized_keys`
3. Test connection

### Auto-Stop Timer

Consider adding auto-stop after inactivity:

# Stop SSH after 1 hour of no connections
systemd timer + idle detection

---

## Related Documentation

- [Network Drive Mounting](./network-drive-mounting.md) - Remote filesystem access
- [Security & Auth](../07-system-setup/security-auth.md) - SSH key management
- [Utility Scripts](./utility-scripts.md) - Other omarchy utility commands

---

**Created:** 2025-11-02
**Updated:** 2025-11-02
**Purpose:** Secure on-demand SSH access with performance optimization for iPhone and remote devices

## Change Log

- **2025-11-02:** Added performance optimization system (ssh-optimize)
- **2025-11-02:** Added backup/restore functionality
- **2025-11-02:** Added immutable flag protection
- **2025-11-02:** Added comprehensive logging to omarchy-archive
- **2025-11-02:** Initial documentation created
