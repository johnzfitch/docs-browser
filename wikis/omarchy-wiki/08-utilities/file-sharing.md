# File Sharing

## Quick Start

```bash
# Share clipboard contents
omarchy-cmd-share clipboard

# Share a specific file
omarchy-cmd-share file ~/Documents/report.pdf

# Share a folder
omarchy-cmd-share folder ~/Projects/myapp

# Share with interactive file picker
omarchy-cmd-share file

# Share with interactive folder picker
omarchy-cmd-share folder
```

---

## Table of Contents

1. [Overview](#overview)
2. [How It Works](#how-it-works)
3. [Sharing Modes](#sharing-modes)
4. [LocalSend Integration](#localsend-integration)
5. [Commands Reference](#commands-reference)
6. [Examples](#examples)
   - [Basic: Sharing a File Quickly](#example-1-basic-sharing-a-file-quickly)
   - [Intermediate: Cross-Device Clipboard Sync](#example-2-intermediate-cross-device-clipboard-sync)
   - [Advanced: Automated Sharing Workflows](#example-3-advanced-automated-sharing-workflows)
7. [Configuration](#configuration)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Related Documentation](#related-documentation)

---

## Overview

Omarchy provides seamless file sharing capabilities through LocalSend, enabling quick transfers between devices on the same network. The system supports sharing individual files, folders, and clipboard contents with an intuitive command-line interface.

**Key Features**:
- Share files, folders, or clipboard contents
- Interactive file/folder picker with `fzf`
- Automatic LocalSend service management
- Cross-platform sharing (works with Android, iOS, Windows, macOS, Linux)
- No internet connection required (local network only)
- End-to-end encrypted transfers
- No file size limits

The `omarchy-cmd-share` command wraps LocalSend's CLI to provide a consistent interface for all sharing operations. It automatically handles service startup, file selection, and process management using systemd for clean background execution.

---

## How It Works

### Architecture

**LocalSend** is a cross-platform file sharing application that uses a local network protocol (similar to AirDrop). The Omarchy integration:

1. **Runs LocalSend in headless mode** via systemd-run (no GUI window)
2. **Manages temporary files** for clipboard sharing (creates temp file with clipboard contents)
3. **Provides file/folder pickers** when no path is specified (uses fzf for interactive selection)
4. **Handles multiple file selection** by converting newline-separated paths to proper arguments

### Transfer Process

When you share a file/folder:
1. `omarchy-cmd-share` prepares the file path(s)
2. Launches LocalSend in headless mode with `systemd-run --user`
3. LocalSend broadcasts availability on the local network
4. Receiving device sees the sender in LocalSend app
5. Receiver accepts the transfer
6. Files transfer directly between devices (encrypted)
7. LocalSend process exits after transfer completes

**Network Requirements**:
- Both devices on the same local network (WiFi/Ethernet)
- Port 53317 accessible (default LocalSend port)
- Firewall allows LocalSend traffic

---

## Sharing Modes

### Clipboard Sharing

Share the current clipboard contents as a text file:

```bash
omarchy-cmd-share clipboard
```

**What Happens**:
1. Clipboard contents extracted with `wl-paste`
2. Written to temporary file (`/tmp/tmp.XXXXXX.txt`)
3. Temporary file sent via LocalSend
4. File remains in `/tmp` until system cleanup (ensures availability during transfer)

**Use Cases**:
- Share copied code snippets
- Transfer text between devices
- Quick note sharing without creating files

### File Sharing

Share one or more files:

```bash
# Share specific file(s)
omarchy-cmd-share file ~/Documents/report.pdf

# Share multiple files
omarchy-cmd-share file ~/file1.txt ~/file2.pdf ~/file3.jpg

# Interactive picker (select one or more files)
omarchy-cmd-share file
```

**Interactive Mode**:
When no file path is provided, `fzf` appears with all files in your home directory:
- Use arrow keys to navigate
- Press `Tab` to select multiple files
- Press `Enter` to confirm selection
- Press `Esc` to cancel

**Multi-File Selection**:
The script automatically detects multiple file selection (newline-separated paths) and passes them correctly to LocalSend.

### Folder Sharing

Share an entire folder (recursively includes all contents):

```bash
# Share specific folder
omarchy-cmd-share folder ~/Projects/myapp

# Interactive picker (select a single folder)
omarchy-cmd-share folder
```

**Interactive Mode**:
When no folder path is provided, `fzf` shows all directories in your home directory:
- Navigate with arrow keys
- Press `Enter` to select
- Press `Esc` to cancel

**Folder Contents**:
LocalSend transfers the entire folder structure, preserving:
- Subdirectories
- File permissions
- Relative paths

---

## LocalSend Integration

### LocalSend Overview

**LocalSend** is an open-source AirDrop alternative for all platforms. It enables:
- Fast local network file transfers
- Cross-platform compatibility (Linux, Android, iOS, Windows, macOS)
- No internet or cloud service required
- End-to-end encryption
- No file size or quantity limits

**Installation**:
```bash
# Arch Linux
sudo pacman -S localsend

# Other distributions
# Download from https://localsend.org
```

### Headless Mode

Omarchy uses LocalSend's `--headless` mode for CLI operation:

```bash
localsend --headless send <file>
```

This mode:
- Runs without GUI window
- Broadcasts the file availability
- Waits for receiver to accept
- Exits after transfer completes

### Systemd Service Management

The share command uses `systemd-run` to manage LocalSend:

```bash
systemd-run --user --quiet --collect localsend --headless send "$FILE"
```

**Benefits**:
- Detached from terminal (won't stop if terminal closes)
- Clean process management (auto-cleanup after exit)
- Proper service isolation
- `--collect` ensures resources freed after completion

**Process Lifecycle**:
1. `systemd-run` creates transient service unit
2. LocalSend starts in headless mode
3. Service runs in background until transfer completes
4. Service auto-terminates after successful transfer
5. systemd collects and cleans up resources

### Receiving Files

**On Linux** (with LocalSend installed):
```bash
# Run LocalSend GUI to receive files
localsend
```

The GUI shows incoming transfers from any device on the network.

**On Mobile** (Android/iOS):
1. Install LocalSend from app store
2. Open app
3. Accept incoming transfer when prompted

**On Windows/macOS**:
1. Download LocalSend from https://localsend.org
2. Run the application
3. Accept transfers in the app window

---

## Commands Reference

| Command | Purpose | Usage | Notes |
|---------|---------|-------|-------|
| `omarchy-cmd-share clipboard` | Share clipboard contents | `omarchy-cmd-share clipboard` | Creates temp file with clipboard text |
| `omarchy-cmd-share file` | Share file(s) | `omarchy-cmd-share file [path...]` | Interactive picker if no path provided |
| `omarchy-cmd-share folder` | Share folder | `omarchy-cmd-share folder [path]` | Interactive picker if no path provided |

### Arguments

**Clipboard Mode**:
```bash
omarchy-cmd-share clipboard
# No additional arguments
```

**File Mode**:
```bash
# No arguments - interactive picker
omarchy-cmd-share file

# Single file
omarchy-cmd-share file /path/to/file.pdf

# Multiple files
omarchy-cmd-share file file1.txt file2.pdf file3.jpg
```

**Folder Mode**:
```bash
# No arguments - interactive picker
omarchy-cmd-share folder

# Specific folder
omarchy-cmd-share folder /path/to/folder
```

---

## Examples

### Example 1: Basic - Sharing a File Quickly

**Scenario**: You need to send a PDF document to your phone.

**On your computer**:
```bash
omarchy-cmd-share file ~/Documents/invoice.pdf
```

**What Happens**:
1. LocalSend starts in headless mode
2. Your computer broadcasts "file available"
3. No terminal output (runs in background)

**On your phone**:
1. Open LocalSend app
2. See incoming transfer from your computer
3. Tap "Accept"
4. File downloads to your phone's Downloads folder

**Expected Result**:
File appears on phone within seconds. No confirmation message in terminal (service runs detached).

**Verify Transfer** (optional):
```bash
# Check if LocalSend is still running
systemctl --user list-units | grep localsend

# If transfer is complete, no units will be listed
```

**Why Use This**: Fastest way to transfer files between devices without cables, cloud services, or email. Perfect for quick document sharing, photo transfers, or sending files to your phone.

---

### Example 2: Intermediate - Cross-Device Clipboard Sync

**Scenario**: You copied a large code snippet on your computer and need it on your tablet for review.

**On your computer** (after copying code to clipboard):
```bash
omarchy-cmd-share clipboard
```

**What Happens**:
1. Clipboard contents written to `/tmp/tmp.Xa7B2q.txt` (random temp file)
2. LocalSend shares this temp file
3. File remains available until you restart or system cleans `/tmp`

**On your tablet**:
1. Open LocalSend
2. Accept transfer
3. Open the received `.txt` file
4. Copy contents on tablet

**Expected Result**:
Your clipboard contents are now available on the tablet as a text file.

**Alternative - Share Specific Clipboard Content**:

```bash
# Preview clipboard first
wl-paste

# If content is correct, share it
omarchy-cmd-share clipboard
```

**Sharing Clipboard Images**:

If your clipboard contains an image (from screenshot):
```bash
# Save clipboard image to temp file first
wl-paste > /tmp/clipboard-image.png

# Share the image file
omarchy-cmd-share file /tmp/clipboard-image.png
```

**Why Use This**: Eliminates the need for cloud-based clipboard sync services. Works offline, is faster, and keeps your data local. Perfect for code snippets, configuration files, or long text that's tedious to type on mobile devices.

---

### Example 3: Advanced - Automated Sharing Workflows

**Scenario**: You regularly share project builds with your team's testing devices.

**Share Latest Build Script**:

```bash
#!/bin/bash
# share-latest-build.sh

BUILD_DIR=~/Projects/myapp/builds

# Find the most recent APK/build file
LATEST_BUILD=$(ls -t "$BUILD_DIR"/*.apk 2>/dev/null | head -1)

if [[ -z "$LATEST_BUILD" ]]; then
  echo "No build found in $BUILD_DIR"
  exit 1
fi

echo "Sharing: $(basename "$LATEST_BUILD")"
omarchy-cmd-share file "$LATEST_BUILD"

echo "Build shared. Check receiving devices."
```

**Usage**:
```bash
chmod +x share-latest-build.sh
./share-latest-build.sh
```

**Expected Output**:
```
Sharing: myapp-v1.2.3.apk
Build shared. Check receiving devices.
```

**Share Entire Project Folder**:

```bash
# Share project folder for code review
omarchy-cmd-share folder ~/Projects/myapp
```

Recipient receives the entire folder structure with all files.

**Interactive Multi-File Selection**:

```bash
# Start interactive file picker
omarchy-cmd-share file

# In fzf interface:
# 1. Use arrow keys to navigate files
# 2. Press Tab to select first file
# 3. Press Tab again on other files to select multiple
# 4. Press Enter to share all selected files
```

**Expected Behavior**:
All selected files transfer as a batch. Recipient sees them as individual files in LocalSend.

**Automated Screenshot Sharing**:

```bash
#!/bin/bash
# share-latest-screenshot.sh

SCREENSHOT_DIR="${OMARCHY_SCREENSHOT_DIR:-$HOME/Pictures}"
LATEST=$(ls -t "$SCREENSHOT_DIR"/screenshot-*.png 2>/dev/null | head -1)

if [[ -z "$LATEST" ]]; then
  echo "No screenshots found"
  exit 1
fi

echo "Sharing latest screenshot: $(basename "$LATEST")"
omarchy-cmd-share file "$LATEST"
```

**Combined with Screenshot Capture**:

```bash
# Take screenshot and immediately share it
omarchy-cmd-screenshot && \
  omarchy-cmd-share file "$(ls -t ~/Pictures/screenshot-*.png | head -1)"
```

**Keybinding for Quick Sharing**:

Add to `~/.config/hypr/bindings.conf`:

```conf
# Share clipboard with Super+Shift+V
bind = SUPER SHIFT, V, exec, omarchy-cmd-share clipboard

# Share latest screenshot with Super+Shift+S
bind = SUPER SHIFT, S, exec, omarchy-cmd-share file "$(ls -t ~/Pictures/screenshot-*.png | head -1)"

# Interactive file picker with Super+Shift+F
bind = SUPER SHIFT, F, exec, kitty -e omarchy-cmd-share file
```

**Sharing to Multiple Devices**:

LocalSend broadcasts to all devices on the network:

```bash
# Share a file
omarchy-cmd-share file ~/Documents/meeting-notes.pdf

# Multiple devices can accept simultaneously
# Each device receives its own copy
```

**Why Use These Advanced Workflows**:
- **Automation** reduces repetitive tasks in development/testing workflows
- **Keybindings** enable instant sharing without typing commands
- **Scripts** ensure consistent file selection (always latest build, screenshot, etc.)
- **Multi-device broadcast** allows sharing to entire team at once

---

## Configuration

### LocalSend Settings

LocalSend can be configured via its GUI or config file:

**Config Location**:
```
~/.config/localsend/settings.json
```

**Common Settings**:
```json
{
  "destinationDirectory": "/home/you/Downloads",
  "saveToGallery": false,
  "quickSave": true,
  "port": 53317
}
```

**Modify Settings**:
```bash
# Open LocalSend GUI to change settings
localsend

# Navigate to Settings tab
# Adjust download location, port, etc.
```

### Network Configuration

**Firewall Rules** (if transfers fail):

```bash
# Allow LocalSend port (53317)
sudo firewall-cmd --add-port=53317/tcp --permanent
sudo firewall-cmd --reload

# Or with ufw:
sudo ufw allow 53317/tcp
```

**Check Port Availability**:
```bash
# See if port is in use
sudo ss -tulpn | grep 53317

# Test LocalSend connectivity
localsend --headless send /tmp/test.txt
# Then try to receive on another device
```

### Interactive Picker Configuration

The file/folder picker uses `fzf` with default settings. Customize by setting `FZF_DEFAULT_OPTS`:

```bash
# In ~/.bashrc or ~/.zshrc
export FZF_DEFAULT_OPTS="--height 40% --reverse --border"
```

### Temporary File Cleanup

Clipboard sharing creates temp files in `/tmp`. These are automatically cleaned on:
- System reboot
- Manual cleanup:
  ```bash
  # Remove old temp files (older than 1 day)
  find /tmp -name "tmp.*.txt" -mtime +1 -delete
  ```

---

## Troubleshooting

### No Devices Found

**Symptoms**: Sending device doesn't appear in LocalSend on receiving device

**Causes**:
1. Devices on different networks/subnets
2. Firewall blocking port 53317
3. LocalSend not running on receiving device

**Solution**:

```bash
# Verify both devices on same network
ip addr show | grep inet

# Check if LocalSend is running
ps aux | grep localsend

# Test port connectivity from receiving device
nc -zv <sender-ip> 53317

# Allow port in firewall
sudo firewall-cmd --add-port=53317/tcp --permanent
sudo firewall-cmd --reload

# Ensure LocalSend is running on receiver
localsend  # Opens GUI to receive
```

---

### Transfer Fails/Hangs

**Symptoms**: Transfer starts but never completes, or fails partway through

**Causes**:
1. Network instability
2. Large file timeout
3. Insufficient space on receiving device
4. LocalSend process killed prematurely

**Solution**:

```bash
# Check LocalSend process status
systemctl --user list-units | grep localsend

# For large files, ensure stable connection
# Consider using wired connection instead of WiFi

# Check available space on receiving device
df -h ~/Downloads  # (or wherever LocalSend saves files)

# Manually test with small file first
echo "test" > /tmp/test.txt
omarchy-cmd-share file /tmp/test.txt
```

---

### Interactive Picker Shows No Files

**Symptoms**: `omarchy-cmd-share file` shows empty list in fzf

**Causes**:
1. No files in home directory
2. `find` command errors
3. Permissions prevent file listing

**Solution**:

```bash
# Test find command manually
find "$HOME" -type f 2>/dev/null | head

# If output is empty, home directory has no files
# Navigate to directory with files first
cd ~/Documents
omarchy-cmd-share file

# Or specify file directly without picker
omarchy-cmd-share file /path/to/file.txt
```

---

### Clipboard Sharing Creates Empty File

**Symptoms**: Transfer succeeds but received file is empty

**Causes**:
1. Clipboard was empty when command ran
2. `wl-paste` not working
3. Clipboard contains non-text data (image, etc.)

**Solution**:

```bash
# Check clipboard contents first
wl-paste

# If empty output, clipboard has no text
# Copy something first, then share

# For images in clipboard, save and share as file:
wl-paste > /tmp/clipboard-image.png
file /tmp/clipboard-image.png  # Verify it's an image
omarchy-cmd-share file /tmp/clipboard-image.png
```

---

### Multiple File Selection Not Working

**Symptoms**: Selected multiple files in fzf but only one transfers

**Causes**:
1. Didn't use `Tab` to multi-select (just pressed Enter on last file)
2. Script error in handling newline-separated paths

**Solution**:

```bash
# In fzf:
# - Arrow down to first file
# - Press TAB (file is marked)
# - Arrow to next file
# - Press TAB (second file is marked)
# - Press ENTER (both files transfer)

# Manual multi-file sharing (bypass picker):
omarchy-cmd-share file ~/file1.txt ~/file2.pdf ~/file3.jpg
```

---

## Best Practices

### Do's

**DO verify clipboard contents before sharing**
```bash
# Check clipboard first
wl-paste | head -20

# Then share if correct
omarchy-cmd-share clipboard
```
- Prevents sharing unintended content
- Avoids empty file transfers
- Confirms clipboard has text data

**DO use descriptive filenames before sharing**
```bash
# BAD: Generic name
omarchy-cmd-share file ~/output.pdf

# GOOD: Descriptive name
mv ~/output.pdf ~/project-report-2025-10-21.pdf
omarchy-cmd-share file ~/project-report-2025-10-21.pdf
```
- Recipient knows what the file is
- Easier to organize received files
- Reduces confusion with multiple transfers

**DO test with small files first**
```bash
# Test connectivity with tiny file
echo "test" > /tmp/test.txt
omarchy-cmd-share file /tmp/test.txt

# If successful, proceed with large files
omarchy-cmd-share file ~/large-video.mp4
```

**DO keep LocalSend updated**
```bash
# Arch Linux
sudo pacman -Syu localsend

# Check version
localsend --version
```
- Bug fixes improve reliability
- New features enhance functionality
- Security updates protect transfers

**DO share folders instead of zipping when possible**
```bash
# Instead of:
tar -czf /tmp/project.tar.gz ~/Projects/myapp
omarchy-cmd-share file /tmp/project.tar.gz

# Do this:
omarchy-cmd-share folder ~/Projects/myapp
```
- Preserves folder structure
- Saves time (no compression needed)
- Recipient can browse files immediately

---

### Don'ts

**DON'T share sensitive files over untrusted networks**
- While LocalSend uses encryption, avoid public WiFi for sensitive data
- Use VPN or direct connection for confidential transfers
- Consider encrypting files before sharing on shared networks

**DON'T forget receiving device must have LocalSend running**
```bash
# Always ensure receiver is ready:
# 1. LocalSend app open on receiving device
# 2. App is in foreground or notifications enabled
# 3. Device is unlocked (for mobile devices)
```

**DON'T share extremely large files without warning**
- LocalSend has no size limit, but consider:
  - Receiver's available storage
  - Network bandwidth (large files take time)
  - Battery impact on mobile devices
- Communicate with recipient before sharing multi-GB files

**DON'T use clipboard sharing for binary data**
```bash
# BAD: Clipboard contains image/binary data
wl-paste > /tmp/clipboard.dat
omarchy-cmd-share clipboard  # May create corrupted file

# GOOD: Save to proper file format first
wl-paste > /tmp/clipboard-image.png
omarchy-cmd-share file /tmp/clipboard-image.png
```

**DON'T cancel transfers abruptly**
- Allow transfers to complete naturally
- If you must cancel, kill the LocalSend process cleanly:
  ```bash
  systemctl --user stop 'run-*.service'  # Stops all transient services
  ```
- Abrupt cancellation may leave partial files on receiver

---

## Related Documentation

### Utilities & Tools
- **Screenshot & Screen Recording** (`screenshot-screenrecord.md`) - Capture and share screenshots/recordings
- **Clipboard Management** (`clipboard-management.md`) - Advanced clipboard operations for sharing workflows
- **Utility Scripts** (`utility-scripts.md`) - Automation helpers for file sharing tasks

### Desktop Environment
- **Notifications** (`../04-desktop-environment/notifications.md`) - LocalSend notification integration
- **File Management** (`../04-desktop-environment/file-manager.md`) - Managing shared files after receiving

### Customization
- **Keybindings** (`../09-customization/keybindings.md`) - Binding share commands to keyboard shortcuts
- **Scripts** (`../09-customization/scripts.md`) - Creating automated sharing workflows

### Quick References
- **Command Index** (`../10-reference/command-index.md`) - All Omarchy commands
- **File Locations** (`../10-reference/file-locations.md`) - Where shared files are saved
- **Troubleshooting Guide** (`../10-reference/troubleshooting.md`) - Common issues across all features

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts** (analyzed for this documentation):
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-share`

**Tools Referenced**:
- `localsend` - Cross-platform file sharing application
- `wl-clipboard` (`wl-paste`) - Wayland clipboard utilities
- `fzf` - Interactive file/folder picker
- `systemd-run` - Service management for background processes
- `find` - File/folder discovery for picker

**External Resources**:
- LocalSend Website: https://localsend.org
- LocalSend GitHub: https://github.com/localsend/localsend
- LocalSend Protocol Documentation: https://github.com/localsend/protocol

**Verification**: All commands, workflows, and outputs tested on Omarchy system running Hyprland on Arch Linux with Wayland.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
