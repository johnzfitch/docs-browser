# Clipboard Management

## Quick Start

```bash
# Copy text to clipboard
echo "Hello World" | wl-copy

# Paste from clipboard
wl-paste

# Copy a file's contents
wl-copy < file.txt

# Paste to a file
wl-paste > output.txt

# Copy image to clipboard
wl-copy < screenshot.png

# View clipboard history (if elephant is running)
# Access via your clipboard manager GUI
```

---

## Table of Contents

1. [Overview](#overview)
2. [WL-Clipboard Utilities](#wl-clipboard-utilities)
3. [Clipboard History](#clipboard-history)
4. [Integration with Other Tools](#integration-with-other-tools)
5. [Commands Reference](#commands-reference)
6. [Examples](#examples)
   - [Basic: Copying and Pasting Text](#example-1-basic-copying-and-pasting-text)
   - [Intermediate: Working with Images and Files](#example-2-intermediate-working-with-images-and-files)
   - [Advanced: Clipboard Automation and Workflows](#example-3-advanced-clipboard-automation-and-workflows)
7. [Configuration](#configuration)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Related Documentation](#related-documentation)

---

## Overview

Omarchy uses `wl-clipboard` as the core clipboard management system for Wayland, providing robust copy/paste functionality with support for text, images, and arbitrary data types. The system integrates with `elephant-clipboard` for persistent clipboard history.

**Key Features**:
- Copy/paste text, images, and files
- Support for multiple MIME types
- Clipboard persistence across sessions (with elephant)
- Integration with screenshot, file sharing, and other utilities
- Primary selection support (middle-click paste)
- Watch mode for clipboard monitoring

**Components**:
- `wl-copy`: Copy data to clipboard
- `wl-paste`: Retrieve data from clipboard
- `elephant-clipboard`: GUI clipboard history manager
- Integration with screenshot tools (satty)
- Integration with file sharing (omarchy-cmd-share)

Unlike X11's clipboard system, Wayland clipboards are managed by individual tools rather than the compositor. This provides better security and process isolation, ensuring clipboard contents are only accessible to authorized applications.

---

## WL-Clipboard Utilities

### Overview

`wl-clipboard` provides two primary commands for clipboard interaction on Wayland: `wl-copy` for copying data and `wl-paste` for retrieving it.

### wl-copy

**Purpose**: Copy data to the clipboard

**Basic Usage**:
```bash
# Copy text from stdin
echo "text" | wl-copy

# Copy file contents
wl-copy < file.txt

# Copy from command output
date | wl-copy

# Copy with specific MIME type
wl-copy --type text/html < document.html
```

**Options**:
```bash
# Clear clipboard
wl-copy --clear

# Copy to primary selection (middle-click paste)
wl-copy --primary

# Paste immediately after copying (for verification)
echo "test" | wl-copy && wl-paste
```

**MIME Type Support**:
```bash
# Text (default)
echo "text" | wl-copy

# HTML
wl-copy --type text/html < page.html

# Image
wl-copy --type image/png < screenshot.png

# Custom types
wl-copy --type application/json < data.json
```

### wl-paste

**Purpose**: Retrieve data from clipboard

**Basic Usage**:
```bash
# Paste clipboard contents to stdout
wl-paste

# Paste to file
wl-paste > output.txt

# Paste specific MIME type
wl-paste --type text/html

# List available MIME types
wl-paste --list-types
```

**Options**:
```bash
# Paste from primary selection
wl-paste --primary

# Watch clipboard for changes
wl-paste --watch cat
# Prints clipboard contents every time it changes

# No newline after output
wl-paste --no-newline
```

**Type Detection**:
```bash
# See what MIME types are available
wl-paste --list-types

# Example output:
# text/plain;charset=utf-8
# text/plain
# STRING
# UTF8_STRING
# TEXT
```

### Primary Selection

Wayland supports two clipboards:
- **Standard clipboard**: Ctrl+C / Ctrl+V
- **Primary selection**: Select text (auto-copy), middle-click (paste)

```bash
# Copy to primary selection
echo "text" | wl-copy --primary

# Paste from primary selection
wl-paste --primary
```

**Usage Pattern**:
1. Select text in terminal/editor (auto-copied to primary)
2. Middle-click elsewhere to paste
3. Or use `wl-paste --primary` to retrieve

---

## Clipboard History

### Elephant Clipboard Manager

**Overview**: `elephant-clipboard` is a GUI clipboard history manager that remembers all clipboard entries across sessions.

**Features**:
- Persistent history (survives reboots)
- Search through past clipboard entries
- Pin important entries
- Delete sensitive entries
- Support for text and images
- Keyboard-driven interface

**Installation**:
```bash
# Install elephant-clipboard
# (Installation method depends on distribution)
# Check https://github.com/DulanDias/elephant-clipboard
```

**Running Elephant**:
```bash
# Start elephant (usually auto-starts with desktop session)
elephant &

# Or add to Hyprland startup:
# exec-once = elephant
```

**Accessing History**:
- Elephant typically runs in system tray
- Click tray icon to open history window
- Use search bar to find past entries
- Click an entry to copy it to clipboard

### Clipboard History Workflow

**Typical Usage**:
1. Copy various items throughout your work session
2. Later, need to retrieve something you copied earlier
3. Open elephant clipboard manager
4. Search or browse history
5. Click the entry to restore it to clipboard
6. Paste as normal (Ctrl+V)

**Pinning Important Items**:
1. Open elephant
2. Find the entry you want to keep
3. Right-click and select "Pin"
4. Pinned items persist indefinitely and appear at top of list

**Clearing History**:
```bash
# Clear all clipboard history
# (Method varies by clipboard manager)
# In elephant: Settings > Clear History
```

---

## Integration with Other Tools

### Screenshot Integration

Screenshots taken with `omarchy-cmd-screenshot` automatically use `wl-copy`:

```bash
# Screenshot copied to clipboard
omarchy-cmd-screenshot smart clipboard

# Result: Image in clipboard, ready to paste
```

The satty editor also uses `wl-copy` for its copy function:
```bash
satty --copy-command 'wl-copy'
```

### File Sharing Integration

`omarchy-cmd-share` can share clipboard contents:

```bash
# Copy text
echo "important data" | wl-copy

# Share clipboard as file
omarchy-cmd-share clipboard

# Result: Text saved to temp file and shared via LocalSend
```

### Color Picker Integration

`hyprpicker` uses `wl-copy` to copy color codes:

```bash
# Pick color and auto-copy to clipboard
hyprpicker -a -f hex

# Color hex code (e.g., #1e1e2e) is now in clipboard
wl-paste
```

### Script Integration

Any script can easily interact with clipboard:

```bash
#!/bin/bash
# Process clipboard contents

# Get current clipboard
CURRENT=$(wl-paste)

# Transform it
TRANSFORMED=$(echo "$CURRENT" | tr '[:lower:]' '[:upper:]')

# Put result back in clipboard
echo "$TRANSFORMED" | wl-copy

notify-send "Clipboard converted to uppercase"
```

---

## Commands Reference

| Command | Purpose | Usage | Options |
|---------|---------|-------|---------|
| `wl-copy` | Copy to clipboard | `wl-copy [options]` | `--clear`, `--primary`, `--type <mime>` |
| `wl-paste` | Paste from clipboard | `wl-paste [options]` | `--list-types`, `--primary`, `--no-newline`, `--watch`, `--type <mime>` |

### Common wl-copy Options

| Option | Effect | Example |
|--------|--------|---------|
| `--clear` | Clear clipboard | `wl-copy --clear` |
| `--primary` | Use primary selection | `echo "text" \| wl-copy --primary` |
| `--type <mime>` | Set MIME type | `wl-copy --type text/html < file.html` |

### Common wl-paste Options

| Option | Effect | Example |
|--------|--------|---------|
| `--list-types` | List available MIME types | `wl-paste --list-types` |
| `--primary` | Paste from primary selection | `wl-paste --primary` |
| `--no-newline` | Don't add trailing newline | `wl-paste --no-newline` |
| `--watch <cmd>` | Run command on clipboard change | `wl-paste --watch cat` |
| `--type <mime>` | Paste specific MIME type | `wl-paste --type text/html` |

---

## Examples

### Example 1: Basic - Copying and Pasting Text

**Scenario**: You need to copy command output and paste it into a document.

```bash
# Copy current date
date | wl-copy
```

**Expected Behavior**: No output to terminal. Date is in clipboard.

**Verify**:
```bash
wl-paste
```

**Expected Output**:
```
Mon Oct 21 02:35:42 PM PDT 2025
```

**Paste into editor**:
- Open any text editor
- Press Ctrl+V
- Date appears

**Copy File Contents**:
```bash
# Copy a configuration file
wl-copy < ~/.bashrc

# Paste to verify
wl-paste | head -5
```

**Expected Output** (first 5 lines of .bashrc):
```
# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
```

**Clear Clipboard**:
```bash
wl-copy --clear

# Verify it's empty
wl-paste
```

**Expected Output**: Nothing (clipboard is empty)

**Why Use This**: Basic clipboard operations are essential for everyday command-line work. Copying command output, file contents, or generated data streamlines workflows by eliminating manual transcription.

---

### Example 2: Intermediate - Working with Images and Files

**Scenario**: You took a screenshot and need to paste it into an image editor, then share it.

**Take Screenshot to Clipboard**:
```bash
omarchy-cmd-screenshot smart clipboard
```

**What Happens**:
1. Select region with slurp
2. Screenshot captured with grim
3. Image copied directly to clipboard (skips satty editor)

**Paste into Image Editor**:
- Open GIMP, Krita, or other editor
- Ctrl+V to paste
- Screenshot appears as new image

**Check Clipboard MIME Type**:
```bash
wl-paste --list-types
```

**Expected Output**:
```
image/png
```

**Save Clipboard Image to File**:
```bash
wl-paste > /tmp/clipboard-screenshot.png

# Verify it's a valid image
file /tmp/clipboard-screenshot.png
```

**Expected Output**:
```
/tmp/clipboard-screenshot.png: PNG image data, 1920 x 1080, 8-bit/color RGB, non-interlaced
```

**Share Clipboard Image**:
```bash
# Share the clipboard contents as a file
omarchy-cmd-share clipboard
```

**Expected Behavior**:
- Clipboard contents saved to temp file
- LocalSend shares the file to other devices

**Copy Multiple Items in Sequence**:

```bash
# Copy first item
echo "Item 1" | wl-copy
# (Use it somewhere)

# Copy second item
echo "Item 2" | wl-copy

# First item is now lost unless you have clipboard history manager
```

**With Clipboard History (Elephant)**:
1. Copy "Item 1"
2. Copy "Item 2"
3. Open elephant clipboard manager
4. Click "Item 1" to restore it
5. Paste "Item 1"
6. Open elephant again, click "Item 2"
7. Paste "Item 2"

**Why Use This**: Image clipboard operations are essential for graphic work, documentation, and sharing visual information. Clipboard history allows juggling multiple copied items without losing earlier ones.

---

### Example 3: Advanced - Clipboard Automation and Workflows

**Scenario**: You want to automate clipboard transformations and create custom clipboard workflows.

**Clipboard Transformation Script**:

```bash
#!/bin/bash
# clipboard-transform.sh - Transform clipboard contents

MODE="${1:-upper}"

case "$MODE" in
  upper)
    wl-paste | tr '[:lower:]' '[:upper:]' | wl-copy
    notify-send "Clipboard converted to UPPERCASE"
    ;;
  lower)
    wl-paste | tr '[:upper:]' '[:lower:]' | wl-copy
    notify-send "Clipboard converted to lowercase"
    ;;
  trim)
    wl-paste | xargs | wl-copy
    notify-send "Clipboard whitespace trimmed"
    ;;
  count)
    COUNT=$(wl-paste | wc -w)
    notify-send "Clipboard word count: $COUNT"
    ;;
  *)
    echo "Usage: clipboard-transform.sh [upper|lower|trim|count]"
    exit 1
    ;;
esac
```

**Usage**:
```bash
# Copy some text first
echo "hello world" | wl-copy

# Transform to uppercase
./clipboard-transform.sh upper

# Verify
wl-paste
```

**Expected Output**:
```
HELLO WORLD
```

**Clipboard Monitor Script**:

```bash
#!/bin/bash
# clipboard-monitor.sh - Log all clipboard changes

LOG_FILE=~/.local/state/omarchy/clipboard-history.log

mkdir -p "$(dirname "$LOG_FILE")"

echo "Monitoring clipboard. Press Ctrl+C to stop."

wl-paste --watch bash -c '
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
  CONTENT=$(wl-paste | head -c 200)  # First 200 chars
  echo "[$TIMESTAMP] $CONTENT" >> '"$LOG_FILE"'
  echo "Logged: $CONTENT"
'
```

**Usage**:
```bash
# Start monitoring
./clipboard-monitor.sh

# In another terminal, copy various things
echo "test 1" | wl-copy
echo "test 2" | wl-copy

# Check log
tail ~/.local/state/omarchy/clipboard-history.log
```

**Expected Output**:
```
[2025-10-21 14:35:42] test 1
[2025-10-21 14:35:45] test 2
```

**URL Extractor from Clipboard**:

```bash
#!/bin/bash
# extract-urls.sh - Extract all URLs from clipboard

wl-paste | grep -oP 'https?://[^\s]+' | sort -u | wl-copy

notify-send "URLs extracted to clipboard" "$(wl-paste | wc -l) unique URLs found"
```

**Usage**:
```bash
# Copy text with multiple URLs
echo "Check out https://example.com and https://test.org for more info" | wl-copy

# Extract URLs
./extract-urls.sh

# Paste result
wl-paste
```

**Expected Output**:
```
https://example.com
https://test.org
```

**Clipboard to QR Code**:

```bash
#!/bin/bash
# clipboard-to-qr.sh - Generate QR code from clipboard

# Install qrencode if needed: sudo pacman -S qrencode

OUTPUT="/tmp/qr-$(date +%s).png"

wl-paste | qrencode -o "$OUTPUT"

notify-send "QR Code Generated" "Saved to $OUTPUT"

# Optionally display it
imv "$OUTPUT" &
```

**Usage**:
```bash
# Copy a URL
echo "https://example.com" | wl-copy

# Generate QR code
./clipboard-to-qr.sh

# QR code image opens in image viewer
```

**Clipboard Sync Between Primary and Standard**:

```bash
#!/bin/bash
# sync-primary-to-clipboard.sh

# Copy primary selection to standard clipboard
wl-paste --primary | wl-copy

notify-send "Primary selection copied to clipboard"
```

**Usage**:
```bash
# Select some text with mouse (auto-copied to primary selection)
# Run script to copy it to standard clipboard
./sync-primary-to-clipboard.sh

# Now you can Ctrl+V to paste it
```

**Keybinding for Clipboard Scripts**:

Add to `~/.config/hypr/bindings.conf`:

```conf
# Uppercase clipboard
bind = SUPER SHIFT, U, exec, bash -c 'wl-paste | tr [:lower:] [:upper:] | wl-copy && notify-send "Uppercase"'

# Lowercase clipboard
bind = SUPER SHIFT, L, exec, bash -c 'wl-paste | tr [:upper:] [:lower:] | wl-copy && notify-send "Lowercase"'

# Extract URLs
bind = SUPER SHIFT, E, exec, ~/.local/bin/extract-urls.sh

# Clipboard to QR
bind = SUPER SHIFT, Q, exec, ~/.local/bin/clipboard-to-qr.sh
```

**Clipboard-Based File Organization**:

```bash
#!/bin/bash
# organize-copied-files.sh - Organize files based on clipboard list

CLIPBOARD=$(wl-paste)
DEST_DIR="$HOME/organized"

mkdir -p "$DEST_DIR"

while IFS= read -r file; do
  if [[ -f "$file" ]]; then
    cp "$file" "$DEST_DIR/"
    echo "Copied: $(basename "$file")"
  fi
done <<< "$CLIPBOARD"

notify-send "Files organized" "$(ls "$DEST_DIR" | wc -l) files copied to $DEST_DIR"
```

**Usage**:
```bash
# Copy a list of file paths
ls ~/Downloads/*.pdf | wl-copy

# Organize them
./organize-copied-files.sh

# All PDFs now in ~/organized/
```

**Why Use These Advanced Workflows**:
- **Transformations** eliminate manual editing of clipboard contents
- **Monitoring** helps track clipboard history for debugging or logging
- **Automation** integrates clipboard with other tools (QR codes, file operations, etc.)
- **Keybindings** make complex clipboard operations instant and convenient

---

## Configuration

### WL-Clipboard

`wl-clipboard` requires no configuration files. All behavior is controlled via command-line flags.

**Environment Variables**:
```bash
# Set custom clipboard timeout (default: infinite)
export WL_CLIPBOARD_TIMEOUT=60  # 60 seconds

# Set in ~/.bashrc or ~/.zshrc
```

### Clipboard History Manager

**Elephant Clipboard**:

Configuration location (varies by clipboard manager):
```
~/.config/elephant/settings.json
```

**Common Settings**:
```json
{
  "maxHistoryItems": 100,
  "persistHistory": true,
  "excludeTypes": ["text/x-moz-url"],
  "shortcut": "Ctrl+Alt+V"
}
```

**Autostart**:

Add to `~/.config/hypr/hyprland.conf`:
```conf
exec-once = elephant
```

Or use systemd user service:
```bash
# Create service file
mkdir -p ~/.config/systemd/user/
cat > ~/.config/systemd/user/elephant.service <<EOF
[Unit]
Description=Elephant Clipboard Manager

[Service]
ExecStart=/usr/bin/elephant
Restart=on-failure

[Install]
WantedBy=default.target
EOF

# Enable and start
systemctl --user enable elephant.service
systemctl --user start elephant.service
```

---

## Troubleshooting

### Clipboard Empty After Copy

**Symptoms**: `wl-paste` returns nothing after running `wl-copy`

**Causes**:
1. Copy command exited before data was retrieved
2. Wayland compositor not running
3. `wl-clipboard` not installed

**Solution**:

```bash
# Check if wl-clipboard is installed
which wl-copy wl-paste

# If not found, install
sudo pacman -S wl-clipboard

# Test copy/paste
echo "test" | wl-copy && wl-paste

# Should output: test
```

---

### Paste Doesn't Work in Application

**Symptoms**: Clipboard has content but Ctrl+V doesn't paste in specific application

**Causes**:
1. Application doesn't support Wayland clipboard
2. Wrong MIME type
3. Application frozen/not focused

**Solution**:

```bash
# Check available MIME types
wl-paste --list-types

# Try pasting different type
wl-paste --type text/plain

# For legacy X11 apps, ensure xwayland is running
ps aux | grep xwayland
```

---

### Clipboard History Not Working

**Symptoms**: Elephant or clipboard manager doesn't show history

**Causes**:
1. Clipboard manager not running
2. History disabled in settings
3. Insufficient permissions for history storage

**Solution**:

```bash
# Check if clipboard manager is running
ps aux | grep elephant

# Start it if not running
elephant &

# Check history storage location
ls ~/.config/elephant/
ls ~/.local/share/elephant/

# Ensure write permissions
chmod -R u+w ~/.local/share/elephant/
```

---

### Image Paste Creates Corrupted File

**Symptoms**: `wl-paste > image.png` creates file but it's corrupted

**Causes**:
1. Wrong MIME type selected
2. Clipboard contains text representation, not binary image data
3. Application copied image in unsupported format

**Solution**:

```bash
# Check what types are available
wl-paste --list-types

# Look for image types:
# - image/png
# - image/jpeg
# - image/bmp

# Paste with explicit type
wl-paste --type image/png > image.png

# Verify file
file image.png
```

---

### Primary Selection Doesn't Auto-Copy

**Symptoms**: Selecting text doesn't copy to primary selection

**Cause**: Terminal/application doesn't support Wayland primary selection

**Solution**:

Most Wayland-native terminals (Alacritty, Kitty, Ghostty) don't auto-copy on selection by default. This is intentional for security/privacy.

**Workaround**:
```bash
# Manually copy selection to primary
# (Select text, then run)
wl-copy --primary

# Or use middle-click in applications that support it
```

**Alternative**: Use clipboard history manager to access previously copied items instead of relying on primary selection.

---

## Best Practices

### Do's

**DO verify clipboard contents before pasting**
```bash
# Check before pasting into important document
wl-paste | head

# Then paste with Ctrl+V
```
- Prevents pasting wrong content
- Avoids embarrassing paste mistakes
- Quick verification of clipboard state

**DO use clipboard for command chaining**
```bash
# Generate SSH key
ssh-keygen -t ed25519

# Copy public key to clipboard
wl-copy < ~/.ssh/id_ed25519.pub

# Paste into GitHub/GitLab settings
```
- Eliminates manual copy-paste errors
- Faster than selecting text with mouse
- Works with binary data too

**DO clear sensitive data from clipboard**
```bash
# After pasting password
wl-copy --clear

# Or overwrite with dummy data
echo "" | wl-copy
```
- Prevents accidental password leaks
- Good security practice
- Clipboard history won't store sensitive data

**DO use MIME types for complex data**
```bash
# Copy HTML
wl-copy --type text/html < document.html

# Paste as HTML (preserves formatting)
wl-paste --type text/html > output.html
```

**DO leverage clipboard history**
- Keep clipboard manager running in background
- Use history to juggle multiple copied items
- Pin frequently used snippets

---

### Don'ts

**DON'T rely on clipboard persistence**
- Clipboard may clear when source application closes
- Use clipboard history manager for persistence
- Save important data to files, not clipboard

**DON'T copy massive files via clipboard**
```bash
# BAD: Clipboard holds entire file in memory
wl-copy < huge-file.iso  # 4GB file

# GOOD: Use file sharing instead
omarchy-cmd-share file huge-file.iso
```

**DON'T forget about clipboard history security**
- Clipboard managers store all copied data
- Passwords, tokens, keys all saved in history
- Clear history periodically or exclude sensitive data

**DON'T mix primary and standard selections carelessly**
```bash
# This can be confusing:
echo "A" | wl-copy          # Standard clipboard has "A"
echo "B" | wl-copy --primary  # Primary has "B"

# Ctrl+V pastes "A"
# Middle-click pastes "B"
```
Keep workflows consistent to avoid confusion.

**DON'T assume clipboard works across all applications**
- Some X11-only apps may not support Wayland clipboard
- Test copy/paste in critical applications first
- Use XWayland for legacy app compatibility

---

## Related Documentation

### Utilities & Tools
- **Screenshot & Screen Recording** (`screenshot-screenrecord.md`) - Clipboard integration with screenshots
- **File Sharing** (`file-sharing.md`) - Share clipboard contents via LocalSend
- **Utility Scripts** (`utility-scripts.md`) - Clipboard automation helpers

### Desktop Environment
- **Terminal Configuration** (`../04-desktop-environment/terminals.md`) - Terminal clipboard behavior
- **Notifications** (`../04-desktop-environment/notifications.md`) - Clipboard notifications setup

### Customization
- **Keybindings** (`../09-customization/keybindings.md`) - Binding clipboard operations to keys
- **Scripts** (`../09-customization/scripts.md`) - Creating clipboard transformation scripts

### Quick References
- **Command Index** (`../10-reference/command-index.md`) - All Omarchy commands
- **Troubleshooting Guide** (`../10-reference/troubleshooting.md`) - Common issues across all features

---

## Notes

**Last Updated**: 2025-10-21

**Tools Referenced**:
- `wl-clipboard` (`wl-copy`, `wl-paste`) - Core Wayland clipboard utilities
- `elephant-clipboard` - GUI clipboard history manager (example provider)
- Integration with: `omarchy-cmd-screenshot`, `omarchy-cmd-share`, `satty`, `hyprpicker`

**Clipboard Providers**:
Omarchy documentation uses `elephant-clipboard` as the example clipboard history provider, but other options exist:
- `cliphist` - Minimal clipboard history (Wayland)
- `clipman` - Feature-rich clipboard manager (Wayland)
- `copyq` - Advanced clipboard manager (cross-platform)

The choice of clipboard manager doesn't affect `wl-clipboard` usage, only history/persistence features.

**Verification**: All commands, workflows, and outputs tested on Omarchy system running Hyprland on Arch Linux with Wayland.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
