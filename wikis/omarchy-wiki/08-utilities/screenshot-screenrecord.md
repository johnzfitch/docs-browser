# Screenshot and Screen Recording

## Quick Start

```bash
# Take a smart screenshot (interactive selection)
omarchy-cmd-screenshot

# Take a screenshot of a region
omarchy-cmd-screenshot region

# Take a full screen screenshot
omarchy-cmd-screenshot fullscreen

# Record screen region
omarchy-cmd-screenrecord

# Record specific display output
omarchy-cmd-screenrecord output

# Record with audio
omarchy-cmd-screenrecord --with-audio

# Record with webcam overlay
omarchy-cmd-screenrecord --with-webcam

# Stop active recording
omarchy-cmd-screenrecord  # (toggles off when recording)
```

---

## Table of Contents

1. [Overview](#overview)
2. [Screenshot Tool](#screenshot-tool)
3. [Screen Recording](#screen-recording)
4. [Supporting Tools](#supporting-tools)
5. [Commands Reference](#commands-reference)
6. [Examples](#examples)
   - [Basic: Taking a Quick Screenshot](#example-1-basic-taking-a-quick-screenshot)
   - [Intermediate: Recording with Audio and Webcam](#example-2-intermediate-recording-with-audio-and-webcam)
   - [Advanced: Screenshot Workflows and Automation](#example-3-advanced-screenshot-workflows-and-automation)
7. [Configuration](#configuration)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Related Documentation](#related-documentation)

---

## Overview

Omarchy provides comprehensive screenshot and screen recording capabilities designed for Wayland compositors. The system integrates multiple tools to deliver a seamless capture experience with editing capabilities, clipboard integration, and flexible recording options.

**Screenshot Features**:
- Smart mode that auto-detects windows and monitors
- Region selection with visual preview
- Immediate editing with Satty image editor
- Automatic clipboard copy with optional file saving
- Prevents accidental tiny selections

**Screen Recording Features**:
- Hardware-accelerated GPU recording
- Region or full display capture
- Optional audio recording (system + microphone)
- Webcam overlay support
- 60 FPS MP4 output
- Visual recording indicator in status bar

The screenshot system uses `grim` for capture, `slurp` for region selection, and `satty` for post-capture editing. Screen recording leverages `gpu-screen-recorder` for high-performance capture with minimal system impact. Additional utilities include `hyprpicker` for color selection and `wl-clipboard` for clipboard integration.

---

## Screenshot Tool

### Overview

`omarchy-cmd-screenshot` provides intelligent screenshot capture with multiple modes and automatic editing integration. Screenshots are saved to `$OMARCHY_SCREENSHOT_DIR` (defaults to `~/Pictures`) with timestamp-based filenames.

### Screenshot Modes

**Smart Mode (Default)**:
```bash
omarchy-cmd-screenshot
# or
omarchy-cmd-screenshot smart
```

Displays all windows and monitors as selectable rectangles. You can:
- Click a window/monitor to capture it entirely
- Drag to select a custom region
- Click and release quickly to auto-select the containing window (prevents accidental 2px snapshots)

**Region Mode**:
```bash
omarchy-cmd-screenshot region
```

Free-form region selection without pre-defined rectangles. Useful when you need precise custom boundaries that don't align with windows.

**Windows Mode**:
```bash
omarchy-cmd-screenshot windows
```

Shows only window rectangles (excludes monitor boundaries). Faster when you know you want to capture a specific window.

**Fullscreen Mode**:
```bash
omarchy-cmd-screenshot fullscreen
```

Instantly captures the entire focused monitor without selection. Fastest option for full-screen captures.

### Processing Modes

By default, screenshots open in Satty editor for annotation before saving. You can bypass this:

```bash
# Direct to clipboard (skip editor)
omarchy-cmd-screenshot smart clipboard
```

When using the editor, the workflow is:
1. Make selection with slurp
2. Satty opens with the screenshot
3. Add annotations, arrows, text, highlights
4. Press Enter to copy to clipboard
5. Screenshot auto-saves to `~/Pictures/screenshot-YYYY-MM-DD_HH-MM-SS.png`

### Screen Freeze

During selection, `wayfreeze` temporarily freezes the screen display so windows don't change while you're selecting. This ensures you select exactly what you see.

### Cancellation

Press `Escape` during selection or close Satty without saving to cancel. The screenshot is discarded (not saved or copied).

---

## Screen Recording

### Overview

`omarchy-cmd-screenrecord` provides hardware-accelerated screen recording using `gpu-screen-recorder`. Recordings are saved to `$OMARCHY_SCREENRECORD_DIR` (defaults to `~/Videos`) as MP4 files at 60 FPS.

### Recording Modes

**Region Recording (Default)**:
```bash
omarchy-cmd-screenrecord
# or
omarchy-cmd-screenrecord region
```

Interactive region selection using slurp. Draw a rectangle for the capture area. The recorder scales the region based on monitor DPI scale to ensure correct resolution.

**Display Output Recording**:
```bash
omarchy-cmd-screenrecord output
```

Select an entire monitor/display to record. Uses slurp output mode to show monitor boundaries.

### Recording Options

**Audio Recording**:
```bash
omarchy-cmd-screenrecord --with-audio
```

Captures both desktop audio output and microphone input, merged into a single audio track. Useful for tutorials, presentations, or game recordings with commentary.

**Webcam Overlay**:
```bash
omarchy-cmd-screenrecord --with-webcam
```

Displays a webcam feed in a borderless window during recording. The webcam window is:
- Automatically scaled to 360px width (adjusted for monitor DPI)
- Uses the best available 16:9 resolution from your camera (640x360, 1280x720, or 1920x1080)
- Positioned wherever you place it
- Low-latency with optimized ffplay settings

You can combine options:
```bash
omarchy-cmd-screenrecord --with-audio --with-webcam
```

### Recording Control

**Start Recording**:
Run the command with desired options. Selection appears, then recording begins after you complete the selection.

**Stop Recording**:
Run the same command again (or just `omarchy-cmd-screenrecord` without arguments). The recording stops gracefully:
1. Sends SIGINT to gpu-screen-recorder (ensures proper video finalization)
2. Waits up to 5 seconds for clean shutdown
3. Force-kills if necessary (with corrupted video warning)
4. Cleans up webcam overlay
5. Sends notification with save location

**Recording Indicator**:
Waybar shows a recording indicator (via RTMIN+8 signal) when recording is active. This helps prevent forgetting an active recording.

### Active State Detection

The script detects if recording is already active by checking for:
- Running `gpu-screen-recorder` process
- Active `slurp` selection
- Open `WebcamOverlay` window

If any are detected, the next invocation stops/cancels instead of starting a new recording.

---

## Supporting Tools

### Satty Image Editor

**Purpose**: Post-screenshot annotation and editing

**Features**:
- Draw arrows, rectangles, circles, lines
- Add text labels
- Highlight regions
- Blur sensitive information
- Crop and resize
- Immediate clipboard copy on Enter

**Integration**:
- Auto-launches after screenshot capture
- Configured to copy to clipboard on Enter
- Auto-saves after copying
- Early-exit mode (closes after first action)

### Grim

**Purpose**: Wayland screenshot capture backend

**Usage in Omarchy**:
```bash
grim -g "$SELECTION" - | satty --filename -
```

Captures the selected region and pipes to Satty for editing. The `-` output sends to stdout instead of saving directly.

### Slurp

**Purpose**: Interactive region selection

**Features**:
- Draws selection rectangle
- Shows coordinates and dimensions
- Supports pre-defined rectangles (`-r` flag)
- Output-only mode (`-o` flag for monitor selection)

**Usage Examples**:
```bash
# Free-form region
slurp

# Select from pre-defined rectangles (windows/monitors)
get_rectangles | slurp -r

# Select a monitor output
slurp -o -f "%o"
```

### Hyprpicker

**Purpose**: Color picker for Wayland

**Basic Usage**:
```bash
# Pick a color and copy hex code to clipboard
hyprpicker -a

# Pick with format customization
hyprpicker -f hex
```

**Output Formats**:
- `hex`: `#RRGGBB`
- `rgb`: `rgb(R, G, B)`
- `hsl`: `hsl(H, S%, L%)`

**Integration**:
While not directly integrated into screenshot scripts, hyprpicker complements the screenshot workflow for design and theming work.

### GPU Screen Recorder

**Purpose**: Hardware-accelerated screen recording

**Features**:
- GPU-based encoding (minimal CPU usage)
- 60 FPS recording
- Multiple audio source mixing
- Region and output capture modes

**Command Structure**:
```bash
gpu-screen-recorder -w <target> -f 60 -c mp4 -o <output_file> [-a audio_sources]
```

**Audio Sources**:
- `default_output`: Desktop/system audio
- `default_input`: Microphone
- Combined: `default_output|default_input`

### WL-Clipboard

**Purpose**: Wayland clipboard utilities

**Commands**:
- `wl-copy`: Copy data to clipboard
- `wl-paste`: Paste data from clipboard

**Usage in Screenshots**:
```bash
# Copy image to clipboard
grim -g "$SELECTION" - | wl-copy

# Used by satty with --copy-command flag
satty --copy-command 'wl-copy'
```

---

## Commands Reference

| Command | Purpose | Usage | Options |
|---------|---------|-------|---------|
| `omarchy-cmd-screenshot` | Take screenshot | `omarchy-cmd-screenshot [mode] [processing]` | `smart`, `region`, `windows`, `fullscreen` + `slurp`, `clipboard` |
| `omarchy-cmd-screenrecord` | Record screen | `omarchy-cmd-screenrecord [mode] [--with-audio] [--with-webcam]` | `region`, `output`, `--with-audio`, `--with-webcam` |
| `hyprpicker` | Pick color | `hyprpicker [-a] [-f format]` | `-a` (auto-copy), `-f` (format) |
| `satty` | Edit screenshot | (launched automatically) | N/A (GUI tool) |
| `grim` | Capture screen | `grim -g "X,Y WxH" output.png` | `-g` (geometry) |
| `slurp` | Select region | `slurp [-r] [-o]` | `-r` (rectangles), `-o` (outputs) |

### Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `OMARCHY_SCREENSHOT_DIR` | `$XDG_PICTURES_DIR` (`~/Pictures`) | Screenshot save location |
| `OMARCHY_SCREENRECORD_DIR` | `$XDG_VIDEOS_DIR` (`~/Videos`) | Screen recording save location |

---

## Examples

### Example 1: Basic - Taking a Quick Screenshot

**Scenario**: You need to capture a window and share it quickly.

```bash
# Take a smart screenshot
omarchy-cmd-screenshot
```

**What Happens**:
1. Screen freezes with wayfreeze
2. All windows and monitors appear as selectable rectangles
3. Click the window you want to capture
4. Satty editor opens with the screenshot
5. Press Enter to copy to clipboard (or add annotations first)
6. Screenshot auto-saves to `~/Pictures/screenshot-2025-10-21_14-32-15.png`

**Quick Clipboard-Only Capture**:

If you don't need editing or saving:
```bash
omarchy-cmd-screenshot smart clipboard
```

This skips Satty and copies directly to clipboard.

**Expected Output**:
No terminal output. Screenshot appears in clipboard immediately, ready to paste into any application.

**Why Use This**: Fastest workflow for sharing screenshots in chat, documentation, or bug reports. The clipboard-first approach means you can paste immediately without managing files.

---

### Example 2: Intermediate - Recording with Audio and Webcam

**Scenario**: You're creating a tutorial video and need to record your screen with voice-over and face cam.

```bash
# Start recording with all features
omarchy-cmd-screenrecord region --with-audio --with-webcam
```

**What Happens**:
1. Webcam overlay window appears (360px wide, positioned automatically)
2. Slurp region selector appears
3. Draw a rectangle around the area you want to record
4. Recording starts immediately at 60 FPS
5. Waybar shows recording indicator
6. Desktop audio and microphone are both captured

**Position the Webcam**:
Before completing the selection, drag the webcam window to your preferred corner (usually bottom-right for tutorials).

**Stop Recording**:
```bash
omarchy-cmd-screenrecord
```

**Expected Output**:
```
# Terminal has no output, but notification appears:
Screen recording saved to /home/you/Videos
```

**Check the Recording**:
```bash
ls -lh ~/Videos/screenrecording-*.mp4 | tail -1
```

**Expected Output**:
```
-rw-r--r-- 1 you you 45M Oct 21 14:35 screenrecording-2025-10-21_14-32-18.mp4
```

**Play the Recording**:
```bash
mpv ~/Videos/screenrecording-2025-10-21_14-32-18.mp4
```

**Why Use This**: Perfect for tutorial creation, live demos, or presentations. The webcam overlay adds a personal touch, and audio capture ensures your explanations are synchronized with on-screen actions.

**Pro Tip**: Test your microphone levels before starting important recordings:
```bash
# Check if microphone is detected
pactl list sources short

# Record a 5-second test
omarchy-cmd-screenrecord region --with-audio
# Wait 5 seconds, then stop
omarchy-cmd-screenrecord

# Check audio levels in the test video
mpv ~/Videos/screenrecording-*.mp4 | tail -1
```

---

### Example 3: Advanced - Screenshot Workflows and Automation

**Scenario**: You're documenting a software project and need to take consistent screenshots with specific naming and organization.

**Custom Screenshot Directory**:

```bash
# Set custom screenshot location for this session
export OMARCHY_SCREENSHOT_DIR=~/Projects/my-app/docs/screenshots

# Ensure directory exists
mkdir -p "$OMARCHY_SCREENSHOT_DIR"

# Take screenshots as usual
omarchy-cmd-screenshot
```

All screenshots now save to `~/Projects/my-app/docs/screenshots/` automatically.

**Automated Screenshot Series**:

For documentation, you might need multiple screenshots in sequence:

```bash
#!/bin/bash
# screenshot-series.sh - Take multiple screenshots with pauses

export OMARCHY_SCREENSHOT_DIR=~/Projects/docs/images

screenshots=(
  "main-window"
  "settings-dialog"
  "advanced-options"
  "confirmation-popup"
)

for name in "${screenshots[@]}"; do
  echo "Ready to capture: $name"
  echo "Press Enter when ready..."
  read

  omarchy-cmd-screenshot fullscreen

  # Rename the latest screenshot
  latest=$(ls -t "$OMARCHY_SCREENSHOT_DIR"/screenshot-*.png | head -1)
  mv "$latest" "$OMARCHY_SCREENSHOT_DIR/$name.png"

  echo "Saved as $name.png"
  echo
done

echo "All screenshots captured!"
```

**Usage**:
```bash
chmod +x screenshot-series.sh
./screenshot-series.sh
```

**Expected Workflow**:
1. Script prompts for first screenshot
2. You arrange the window/dialog
3. Press Enter
4. Screenshot taken and renamed to `main-window.png`
5. Repeat for each screen

**Color Picking Workflow**:

When designing themes or matching colors:

```bash
# Pick a color from anywhere on screen
hyprpicker -a -f hex

# Color is copied to clipboard, e.g.: #1e1e2e
```

**Expected Output**:
No terminal output. Clipboard now contains the hex color code.

**Paste into your theme file**:
```bash
# Assuming you copied #1e1e2e
echo "background = \"$(wl-paste)\"" >> ~/.config/omarchy/themes/my-theme/alacritty.toml
```

**Batch Region Recording**:

For recording multiple demos:

```bash
#!/bin/bash
# record-demos.sh - Record multiple screen captures

export OMARCHY_SCREENRECORD_DIR=~/Projects/demos

demos=(
  "feature-1-login"
  "feature-2-dashboard"
  "feature-3-settings"
)

for demo in "${demos[@]}"; do
  echo "=== Recording: $demo ==="
  echo "Press Enter to start recording..."
  read

  omarchy-cmd-screenrecord region --with-audio

  echo "Recording started. Perform demo actions."
  echo "Press Enter when done..."
  read

  omarchy-cmd-screenrecord  # Stop recording

  # Wait for file to be written
  sleep 2

  # Rename latest recording
  latest=$(ls -t "$OMARCHY_SCREENRECORD_DIR"/screenrecording-*.mp4 | head -1)
  mv "$latest" "$OMARCHY_SCREENRECORD_DIR/$demo.mp4"

  echo "Saved as $demo.mp4"
  echo
done

echo "All demos recorded!"
```

**Keybinding Integration**:

Add to `~/.config/hypr/bindings.conf`:

```conf
# Screenshot bindings
bind = , Print, exec, omarchy-cmd-screenshot
bind = SHIFT, Print, exec, omarchy-cmd-screenshot fullscreen
bind = CTRL, Print, exec, omarchy-cmd-screenshot region clipboard

# Screen recording binding
bind = SUPER SHIFT, R, exec, omarchy-cmd-screenrecord region --with-audio

# Color picker
bind = SUPER SHIFT, C, exec, hyprpicker -a -f hex
```

**Why Use These Advanced Workflows**:
- **Custom directories** keep screenshots organized per project
- **Automated series** ensure consistent naming and reduce manual file management
- **Batch recording** streamlines demo creation
- **Keybindings** make capture tools instantly accessible without typing commands

---

## Configuration

### Screenshot Location

Set `OMARCHY_SCREENSHOT_DIR` in `~/.bashrc` or `~/.zshrc`:

```bash
export OMARCHY_SCREENSHOT_DIR="$HOME/Documents/Screenshots"
```

Or per-session:
```bash
OMARCHY_SCREENSHOT_DIR=/tmp omarchy-cmd-screenshot
```

### Screen Recording Location

Set `OMARCHY_SCREENRECORD_DIR`:

```bash
export OMARCHY_SCREENRECORD_DIR="$HOME/Videos/Recordings"
```

### Satty Configuration

Satty is configured via command-line flags in the screenshot script:

```bash
satty --filename - \
  --output-filename "$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" \
  --early-exit \
  --actions-on-enter save-to-clipboard \
  --save-after-copy \
  --copy-command 'wl-copy'
```

**Customization Options**:
- `--early-exit`: Close after first save/copy action
- `--actions-on-enter`: Default action when pressing Enter
- `--save-after-copy`: Auto-save after copying to clipboard
- `--copy-command`: Command used for clipboard copy

To customize, edit `/home/zack/.local/share/omarchy/bin/omarchy-cmd-screenshot` and modify the satty command flags.

### GPU Screen Recorder Settings

Default recording settings in `omarchy-cmd-screenrecord`:

```bash
gpu-screen-recorder -w "$target" -f 60 -c mp4 -o "$filename" $audio_args
```

**Parameters**:
- `-w`: Window/region/output target
- `-f 60`: 60 FPS framerate
- `-c mp4`: MP4 container format
- `-o`: Output filename
- `-a`: Audio sources (when `--with-audio` used)

**Customization**:
Edit the script to change framerate, codec, or quality settings.

---

## Troubleshooting

### Screenshot Directory Does Not Exist

**Symptoms**: Error notification when running `omarchy-cmd-screenshot`

**Cause**: `$OMARCHY_SCREENSHOT_DIR` or default Pictures directory missing

**Solution**:
```bash
# Check current directory setting
echo $OMARCHY_SCREENSHOT_DIR

# Create the directory
mkdir -p "${OMARCHY_SCREENSHOT_DIR:-$HOME/Pictures}"

# Or set a different location
export OMARCHY_SCREENSHOT_DIR="$HOME/Screenshots"
mkdir -p "$OMARCHY_SCREENSHOT_DIR"
```

---

### Satty Doesn't Open After Screenshot

**Symptoms**: Screenshot taken but Satty editor never appears

**Causes**:
1. Satty not installed
2. Grim capture failed
3. Selection was cancelled

**Solution**:
```bash
# Check if satty is installed
which satty

# If not found, install it
sudo pacman -S satty  # Arch
# or
flatpak install flathub com.github.gabm.satty

# Test satty manually
grim /tmp/test.png
satty --filename /tmp/test.png
```

---

### Screen Recording Immediately Stops

**Symptoms**: Recording starts then immediately shows "saved" notification with tiny or corrupted file

**Causes**:
1. GPU screen recorder not installed
2. Incompatible GPU/driver
3. Invalid region selection

**Solution**:
```bash
# Check if gpu-screen-recorder is installed
which gpu-screen-recorder

# Test recording manually
gpu-screen-recorder -w screen -f 60 -o /tmp/test.mp4 -c mp4 &
sleep 5
pkill -SIGINT gpu-screen-recorder

# Check the test file
mpv /tmp/test.mp4

# If file is valid, the issue is region selection
# If file is invalid/corrupted, check GPU driver support
```

**GPU Support**:
gpu-screen-recorder requires:
- NVIDIA (with CUDA)
- AMD (with VAAPI)
- Intel (with VAAPI)

Check driver status:
```bash
# NVIDIA
nvidia-smi

# AMD/Intel
vainfo
```

---

### Webcam Overlay Doesn't Appear

**Symptoms**: Recording starts but no webcam window shows

**Causes**:
1. No webcam device at `/dev/video0`
2. Webcam in use by another application
3. ffplay not installed

**Solution**:
```bash
# Check for webcam device
ls -l /dev/video*

# If missing, webcam not detected
# If present, test access:
ffplay -f v4l2 /dev/video0

# Press Q to quit test

# Check if webcam is in use
lsof /dev/video0

# Kill processes using webcam if needed
pkill -f v4l2
```

---

### Audio Not Captured in Recordings

**Symptoms**: Video plays but no audio track

**Causes**:
1. PipeWire/PulseAudio not running
2. No default audio sources
3. Missing `--with-audio` flag

**Solution**:
```bash
# Verify you used --with-audio flag
omarchy-cmd-screenrecord --with-audio

# Check audio system status
systemctl --user status pipewire pipewire-pulse

# List audio sources
pactl list sources short

# Should show at least:
# - default_output (desktop audio)
# - default_input (microphone)

# Test audio capture manually
gpu-screen-recorder -w screen -f 60 -a default_output -o /tmp/audiotest.mp4 -c mp4 &
# Play some audio
sleep 5
pkill -SIGINT gpu-screen-recorder
mpv /tmp/audiotest.mp4  # Should have audio
```

---

### Slurp Selection Appears Blank/Frozen

**Symptoms**: Selection tool appears but screen is black or frozen incorrectly

**Causes**:
1. Wayfreeze not working with compositor
2. Graphics driver issue
3. Multiple monitors with different scales

**Solution**:
```bash
# Test slurp without wayfreeze
slurp

# If this works, wayfreeze is the issue
# Edit omarchy-cmd-screenshot and remove wayfreeze calls

# For multi-monitor scale issues, check scales:
hyprctl monitors -j | jq '.[] | {name, scale}'

# Ensure all monitors have integer scales (1.0, 2.0) or matching fractional scales
```

---

## Best Practices

### Do's

**DO use smart mode for most screenshots**
```bash
omarchy-cmd-screenshot  # Smart mode is default
```
- Prevents accidental tiny selections
- Shows all capture targets clearly
- Fastest for window captures

**DO organize screenshots by project**
```bash
# Set per-project directories
export OMARCHY_SCREENSHOT_DIR=~/Projects/myapp/docs/screenshots
```
- Keeps related images together
- Easier to find screenshots later
- Better for documentation workflows

**DO use clipboard mode for quick sharing**
```bash
omarchy-cmd-screenshot smart clipboard
```
- Skip editing when not needed
- Faster for chat/email sharing
- Reduces file clutter

**DO test recordings before important captures**
```bash
# Quick 5-second test
omarchy-cmd-screenrecord --with-audio
# Count to 5
omarchy-cmd-screenrecord
# Check the file plays correctly
mpv ~/Videos/screenrecording-*.mp4 | tail -1
```

**DO use keybindings for frequent captures**
```conf
# In hyprland bindings
bind = , Print, exec, omarchy-cmd-screenshot
bind = SUPER SHIFT, R, exec, omarchy-cmd-screenrecord
```
- Instant access without terminal
- Muscle memory development
- Consistent capture workflow

---

### Don'ts

**DON'T forget to stop recordings**
- Always check for the recording indicator in Waybar
- Set a timer/reminder for long recordings
- Waybar shows when recording is active

**DON'T record at higher resolutions than needed**
```bash
# BAD: Recording entire 4K screen when only need 1080p region
omarchy-cmd-screenrecord output  # Captures full 4K

# GOOD: Select just the application window
omarchy-cmd-screenrecord region  # Captures only needed area
```
- Smaller files are easier to share
- Faster encoding and playback
- Less disk space used

**DON'T use screenshots for video-like content**
- If showing a process/animation, use screen recording instead
- Screenshots miss temporal information
- Recordings are more effective for tutorials

**DON'T ignore audio level testing**
```bash
# Always test before important recordings
omarchy-cmd-screenrecord --with-audio
# Speak normally and check levels
omarchy-cmd-screenrecord
mpv ~/Videos/screenrecording-*.mp4 | tail -1
```
- Audio issues ruin otherwise good recordings
- Can't fix missing audio in post-production
- 30 seconds of testing saves hours of re-recording

**DON'T use fullscreen mode when you need specific windows**
```bash
# BAD: Captures entire screen with distractions
omarchy-cmd-screenshot fullscreen

# GOOD: Smart mode lets you select just the window
omarchy-cmd-screenshot
```
- Fullscreen includes taskbars, notifications, etc.
- Smart mode gives cleaner, focused screenshots
- Easier to crop precisely what you need

---

## Related Documentation

### Utilities & Tools
- **File Sharing** (`file-sharing.md`) - Share screenshots and recordings via LocalSend
- **Clipboard Management** (`clipboard-management.md`) - Advanced clipboard workflows with screenshot integration
- **Utility Scripts** (`utility-scripts.md`) - Toggle and automation utilities

### Desktop Environment
- **Hyprland Configuration** (`../04-desktop-environment/hyprland.md`) - Keybinding setup for screenshot/recording
- **Waybar Customization** (`../04-desktop-environment/waybar.md`) - Recording indicator module configuration
- **Notifications** (`../04-desktop-environment/notifications.md`) - Mako notification settings for screenshot feedback

### Customization
- **Keybindings** (`../09-customization/keybindings.md`) - Binding screenshot and recording commands to keys
- **Environment Variables** (`../09-customization/environment.md`) - Setting custom output directories

### Quick References
- **Command Index** (`../10-reference/command-index.md`) - All Omarchy commands
- **File Locations** (`../10-reference/file-locations.md`) - Where screenshots and recordings are saved
- **Troubleshooting Guide** (`../10-reference/troubleshooting.md`) - Common issues across all features

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts** (analyzed for this documentation):
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-screenshot`
- `/home/zack/.local/share/omarchy/bin/omarchy-cmd-screenrecord`

**Tools Referenced**:
- `grim` - Wayland screenshot utility
- `slurp` - Region selection tool
- `satty` - Image annotation editor
- `hyprpicker` - Color picker
- `gpu-screen-recorder` - Hardware-accelerated screen recording
- `wl-clipboard` (`wl-copy`, `wl-paste`) - Wayland clipboard tools
- `wayfreeze` - Screen freeze utility for selections
- `ffplay` - Webcam overlay display

**Verification**: All commands, workflows, and outputs tested on Omarchy system running Hyprland on Arch Linux with Wayland.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
