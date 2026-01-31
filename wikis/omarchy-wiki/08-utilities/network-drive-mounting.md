# Network Drive Mounting

**Purpose:** Auto-mounting remote filesystems via SSHFS with seamless integration into Nautilus and the omarchy workflow.

**Use Case:** Access remote cPanel/server files as if they're local directories, with auto-mount on login and easy remounting via SUPER + O menu.

---

## Table of Contents

- [Quick Start](#quick-start)
- [Overview](#overview)
- [Configuration](#configuration)
- [Scripts](#scripts)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## Quick Start

### Mount a Network Drive Now
```bash
# Mount internetuniverse feed
mount-internetuniverse

# Or remount all network drives
remount-network-drives

# Or use SUPER + O → Remount Network Drives
```

### Check Mount Status
```bash
# Check if mounted
mountpoint ~/internetuniverse_feed

# List all mounts
mount | grep sshfs
```

### Unmount
```bash
unmount-internetuniverse

# Or use Nautilus sidebar eject button (if visible)
```

---

## Overview

The network drive mounting system provides:

1. **SSHFS Integration** - SSH-based filesystem mounting
2. **Auto-mount on Login** - Systemd user units handle automatic mounting
3. **Nautilus Integration** - Custom bookmark names and icons
4. **Post-update Hooks** - Preserves customizations after omarchy updates
5. **Easy Remounting** - Available in SUPER + O docs menu

### Current Mounts

| Name | Remote Path | Local Path | Status |
|------|-------------|------------|--------|
| feed@internet | `internet@195.250.27.45:/home/internet/feed.internetuniverse.org` | `~/internetuniverse_feed` | Auto-mount |

---

## Configuration

### SSH Keys

Location: `~/.ssh/internetuniverse_feed_daddy`
- Converted from PPK format to OpenSSH
- Public key uploaded to server: `~/.ssh/authorized_keys`
- Permissions: `600` (private key), `644` (public key)

### SSH Config

File: `~/.ssh/config`
```ini
Host internetuniverse-feed
    HostName 195.250.27.45
    User internet
    IdentityFile ~/.ssh/internetuniverse_feed_daddy
    ServerAliveInterval 15
    ServerAliveCountMax 3
```

### Systemd Auto-Mount

File: `~/.config/systemd/user/home-zack-internetuniverse_feed.mount`

Key options:
- `reconnect` - Auto-reconnect on connection loss
- `ServerAliveInterval=15` - Keep connection alive
- `_netdev` - Network dependency
- `x-systemd.automount` - Mount on access

### Nautilus Integration

**Bookmark:** `~/.config/gtk-3.0/bookmarks`
```
file:///home/zack/internetuniverse_feed feed@internet
```

**Custom Icon:** `~/internetuniverse_feed/.directory`
```ini
[Desktop Entry]
Icon=/home/zack/dev/iconics/catalog/ui/news.png
```

**GTK CSS:** `~/.config/gtk-4.0/gtk.css`
- Hides eject buttons for network mounts (optional)

### Post-Update Hook

File: `~/.config/omarchy/hooks/post-update`

Automatically restores after omarchy updates:
- Nautilus bookmark
- Custom directory icon
- Runs on every system update

---

## Scripts

### mount-internetuniverse

Location: `~/.local/bin/mount-internetuniverse`

**Purpose:** Mount the internetuniverse feed cPanel site

**Usage:**
```bash
mount-internetuniverse
```

**Features:**
- Checks if already mounted
- Creates mount point if needed
- Opens Nautilus on success
- Uses SSH key authentication

### unmount-internetuniverse

Location: `~/.local/bin/unmount-internetuniverse`

**Purpose:** Safely unmount the network drive

**Usage:**
```bash
unmount-internetuniverse
```

### remount-network-drives

Location: `~/.local/bin/remount-network-drives`

**Purpose:** Remount all configured network drives

**Usage:**
```bash
remount-network-drives

# Or: SUPER + O → Remount Network Drives
```

**Features:**
- Runs all mount scripts
- Shows desktop notification
- Available in omarchy docs menu (SUPER + O)

---

## Troubleshooting

### Mount Failed

**Problem:** SSHFS mount fails with "Connection refused" or "Permission denied"

**Solutions:**
```bash
# 1. Check SSH connection
ssh internetuniverse-feed "pwd"

# 2. Verify key permissions
ls -l ~/.ssh/internetuniverse_feed_daddy  # Should be -rw-------

# 3. Check if already mounted
mountpoint ~/internetuniverse_feed

# 4. Force unmount if stale
fusermount -u ~/internetuniverse_feed

# 5. Remount
mount-internetuniverse
```

### Auto-Mount Not Working

**Problem:** Drive doesn't mount on login

**Solutions:**
```bash
# 1. Check systemd unit status
systemctl --user status home-zack-internetuniverse_feed.mount

# 2. Enable if disabled
systemctl --user enable home-zack-internetuniverse_feed.mount

# 3. Start manually
systemctl --user start home-zack-internetuniverse_feed.mount

# 4. Check logs
journalctl --user -u home-zack-internetuniverse_feed.mount
```

### Bookmark/Icon Disappeared After Update

**Problem:** Nautilus bookmark or custom icon missing after omarchy update

**Solution:**
```bash
# Post-update hook should restore automatically
# If not, run manually:
~/.config/omarchy/hooks/post-update

# Or restart Nautilus:
nautilus -q
```

### Stale Mount (Frozen/Unresponsive)

**Problem:** Mount point exists but files don't load

**Solutions:**
```bash
# 1. Force unmount
fusermount -u ~/internetuniverse_feed

# 2. Clean up if needed
rmdir ~/internetuniverse_feed  # Only if empty

# 3. Remount
mount-internetuniverse
```

---

## Best Practices

### Do's ✅

- **Use SSH keys** instead of passwords for security
- **Enable auto-mount** via systemd for convenience
- **Set ServerAliveInterval** to prevent connection timeouts
- **Use post-update hooks** to preserve customizations
- **Test remounting** after omarchy updates

### Don'ts ❌

- **Don't store passwords** in scripts or config files
- **Don't manually edit systemd mount units** - use `systemctl --user edit` instead
- **Don't force-kill** SSHFS processes - use `fusermount -u`
- **Don't mount over existing directories** with files in them
- **Don't use the same mount point** for multiple remotes

### Security Considerations

1. **SSH Key Security**
   - Keep private keys at `600` permissions
   - Use passphrase-protected keys when possible
   - Upload only public keys to servers

2. **Network Security**
   - SSHFS is encrypted via SSH
   - Verify server fingerprints on first connection
   - Use `StrictHostKeyChecking=yes` in production

3. **Access Control**
   - Mount points inherit server permissions
   - Files are owned by the remote user (shows as numeric UID locally)
   - Changes made locally apply immediately to remote server

---

## Adding New Network Drives

To add a new network drive:

1. **Create mount script** in `~/.local/bin/mount-<name>`
2. **Add to remount script** in `~/.local/bin/remount-network-drives`
3. **Create systemd unit** in `~/.config/systemd/user/`
4. **Add bookmark** to `~/.config/gtk-3.0/bookmarks`
5. **Update post-update hook** in `~/.config/omarchy/hooks/post-update`

---

## Related Documentation

- [Utility Scripts](./utility-scripts.md) - Other omarchy utility commands
- [File Sharing](./file-sharing.md) - Sharing files between systems
- [Security & Auth](../07-system-setup/security-auth.md) - SSH key management

---

**Created:** 2025-10-29
**Updated:** 2025-10-29
**Source:** Custom SSHFS integration for omarchy
