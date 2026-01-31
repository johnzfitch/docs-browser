# Core Applications

Essential applications pre-installed with omarchy for everyday computing tasks.

## Table of Contents
- [Overview](#overview)
- [Browser: omarchy-chromium](#browser-omarchy-chromium)
- [File Manager: Nautilus](#file-manager-nautilus)
- [Terminals](#terminals)
- [Supporting Applications](#supporting-applications)
- [Examples](#examples)
- [Related Documentation](#related-documentation)

## Overview

Omarchy includes a curated set of core applications that form the foundation of daily computing tasks. These applications are installed by default and optimized for the Hyprland Wayland environment.

**Key Applications:**
- **omarchy-chromium** - Privacy-focused browser with Google account support
- **Nautilus** - GNOME file manager with full feature set
- **Terminal emulators** - Alacritty (default), Kitty, Ghostty
- **Utilities** - Calculator, disk utility, file viewer

All applications are installed via `omarchy-base.packages` during system installation.

## Browser: omarchy-chromium

### Description
Custom Chromium package optimized for omarchy with privacy enhancements and Wayland support.

### Features
- Native Wayland support
- Hardware acceleration enabled
- Privacy-focused default settings
- Google account integration (optional)
- Touch and gesture support

### Google Account Integration

**Command:** `omarchy-install-chromium-google-account`

Enables Google account login in Chromium by configuring OAuth2 credentials.

```bash
# Enable Google account login
omarchy-install-chromium-google-account
```

**What it does:**
1. Adds OAuth2 client ID to `~/.config/chromium-flags.conf`
2. Adds OAuth2 client secret
3. Allows native Google account login instead of browser-only mode

**Configuration file:** `~/.config/chromium-flags.conf`
```
--oauth2-client-id=77185425430.apps.googleusercontent.com
--oauth2-client-secret=OTJgUOQcT7lO7GsGZq2G4IlT
```

### Theme Integration

Chromium automatically adopts the current omarchy theme:

```bash
# Theme is set automatically when changing omarchy theme
omarchy-theme-set <theme-name>
```

The `omarchy-theme-set-browser` script handles browser theming internally.

## File Manager: Nautilus

### Description
GNOME's file manager (also known as "Files") with full Wayland support and GNOME integration.

### Features
- Modern, clean interface
- Network share support (SMB, NFS via gvfs)
- MTP device support (Android phones)
- File preview with Sushi
- Bulk renaming
- Integrated search
- Trash management

### Installed Packages
```
nautilus                # File manager
gnome-disk-utility      # Disk management
sushi                   # File previewer (press Space)
gvfs-smb               # Windows share support
gvfs-nfs               # NFS share support
gvfs-mtp               # Android device support
```

### Usage
```bash
# Launch file manager
nautilus

# Open specific directory
nautilus ~/Documents

# Open current directory in terminal
nautilus .
```

### File Preview
Press **Space** while selecting a file to quick-preview without opening.

## Terminals

### Available Terminals

Omarchy supports three terminal emulators:

1. **Alacritty** (default) - GPU-accelerated, minimal
2. **Kitty** - Feature-rich, GPU-accelerated
3. **Ghostty** - Modern, fast terminal

### Installation

**Command:** `omarchy-install-terminal [alacritty|kitty|ghostty]`

Install and switch between terminal emulators.

```bash
# Install and set Kitty as default
omarchy-install-terminal kitty

# Install and set Ghostty as default
omarchy-install-terminal ghostty

# Install and set Alacritty as default
omarchy-install-terminal alacritty
```

**What it does:**
1. Installs the selected terminal package
2. Updates `~/.config/uwsm/default` with new TERMINAL variable
3. Prompts for system restart (required for change to take effect)

### Default Terminal Configuration

The default terminal is set in `~/.config/uwsm/default`:
```bash
export TERMINAL=alacritty  # or kitty, ghostty
```

### Terminal Features

**Alacritty:**
- GPU-accelerated rendering
- Minimal configuration
- Fast startup
- Vi mode support
- Pre-configured in omarchy

**Kitty:**
- Tabs and windows
- Image protocol support
- Ligature support
- Split panes
- Scripting support

**Ghostty:**
- Modern architecture
- Fast performance
- Good font rendering
- Terminal graphics protocol

### Theme Integration

Terminals automatically match the current omarchy theme via `omarchy-theme-set-terminal`.

## Supporting Applications

### Calculator
```bash
# Launch calculator
gnome-calculator
```

### Disk Utility
```bash
# Manage disks and partitions
gnome-disk-utility
```

### Image Viewer
```bash
# View images
imv picture.png
```

### PDF Viewer
```bash
# View PDFs
evince document.pdf
```

### Image Editor
```bash
# Basic image editing
pinta
```

## Examples

### Example 1: Setting Up Chromium with Google Account

```bash
# 1. Run the Google account setup
omarchy-install-chromium-google-account

# 2. Launch Chromium
omarchy-chromium

# 3. Navigate to Google services (Gmail, Drive, etc.)
# 4. Sign in with Google account
# 5. Sync settings, bookmarks, extensions
```

### Example 2: File Management Workflow

```bash
# Open file manager in home directory
nautilus ~

# Access network shares
# File > Other Locations > Connect to Server
# smb://server/share

# Preview files
# Select file and press Space

# Mount Android phone
# Connect phone via USB
# File > Other Locations > Phone name
```

### Example 3: Switching Terminal Emulator

```bash
# Check current terminal
echo $TERMINAL
# Output: alacritty

# Install and switch to Kitty
omarchy-install-terminal kitty

# Confirm restart prompt
# After restart, $TERMINAL will be 'kitty'
```

### Example 4: Opening Terminal in Current Directory

```bash
# From file manager
# Right-click in folder > Open in Terminal

# Or via command
omarchy-cmd-terminal-cwd
```

## Package List

Core applications from `omarchy-base.packages`:

```
# Browser
omarchy-chromium

# File Management
nautilus
gnome-disk-utility
sushi
gvfs-mtp
gvfs-nfs
gvfs-smb

# Terminals
alacritty        # Default, always installed

# Utilities
gnome-calculator
evince           # PDF viewer
imv              # Image viewer
pinta            # Image editor

# File Tools
fastfetch        # System info
eza              # Modern ls
bat              # Better cat
dust             # Disk usage
tree-sitter-cli  # Parser tool
```

## Troubleshooting

### Chromium Won't Sign In to Google Account

**Problem:** Can't sign in to Google services in Chromium

**Solution:**
```bash
# Run the OAuth setup script
omarchy-install-chromium-google-account

# Restart Chromium
pkill chromium
omarchy-chromium
```

### Terminal Won't Change After Installation

**Problem:** New terminal installed but old one still launches

**Solution:**
```bash
# Terminal change requires system restart
systemctl reboot --no-wall

# Or re-login to desktop session
```

### Nautilus Can't Access Network Share

**Problem:** Network shares don't appear or fail to connect

**Solution:**
```bash
# Ensure gvfs packages are installed
pacman -Q gvfs-smb gvfs-nfs

# Restart gvfs daemon
systemctl --user restart gvfs-daemon

# Check network connectivity
ping server-hostname
```

### File Preview (Sushi) Not Working

**Problem:** Pressing Space on file doesn't show preview

**Solution:**
```bash
# Ensure Sushi is installed
pacman -Q sushi

# Check if Sushi service is running
ps aux | grep sushi

# Reinstall if necessary
omarchy-pkg-add sushi
```

## Best Practices

### Browser Usage
- Enable Google account integration for full Chrome sync
- Use hardware acceleration for better performance
- Configure privacy settings in Chromium preferences
- Install uBlock Origin for ad blocking

### File Management
- Use Sushi (Space) for quick file previews
- Organize files in standard XDG directories
- Use bookmarks for frequently accessed locations
- Enable network discovery for SMB shares

### Terminal Selection
- **Choose Alacritty** for minimal, fast terminal
- **Choose Kitty** for advanced features and tabs
- **Choose Ghostty** for modern terminal with good rendering
- Restart after changing default terminal

### Application Launching
- Use Walker (Super key) to launch applications
- Pin frequently used apps to favorites
- Use `omarchy-launch-or-focus` for window management

## Related Documentation

- [Desktop Environment](../04-desktop-environment/hyprland-integration.md) - Window management and keybindings
- [Walker Launcher](../04-desktop-environment/walker-elephant.md) - Application launcher
- [Package Management](../02-core-commands/package-management.md) - Installing additional software
- [Development Tools](./development-tools.md) - Developer-focused applications
- [Productivity Apps](./productivity-apps.md) - Productivity-focused applications

---

*Last Updated: 2025-10-21*
*Source: omarchy-base.packages, omarchy-install-chromium-google-account, omarchy-install-terminal, omarchy-theme-set-terminal, omarchy-theme-set-browser*
