# Media Tools

Multimedia creation and editing tools pre-installed in omarchy.

## Table of Contents
- [Overview](#overview)
- [Screen Recording](#screen-recording)
- [Video Editing](#video-editing)
- [Media Playback](#media-playback)
- [Screenshot Tools](#screenshot-tools)
- [Image Editing](#image-editing)
- [Examples](#examples)
- [Related Documentation](#related-documentation)

## Overview

Omarchy includes a complete suite of media tools for screen recording, video editing, screenshot capture, and media playback. All tools are optimized for Wayland and hardware acceleration.

**Key Media Tools:**
- **OBS Studio** - Professional streaming and recording
- **Kdenlive** - Full-featured video editor
- **mpv** - Powerful media player
- **gpu-screen-recorder** - Efficient screen recording
- **satty** - Screenshot annotation tool
- **grim + slurp** - Wayland screenshot capture

All tools are installed via `omarchy-base.packages` and configured for omarchy.

## Screen Recording

### OBS Studio

**Package:** `obs-studio`

**Description:** Professional open-source software for video recording and live streaming.

**Launch:**
```bash
obs-studio
# Or via Walker: Super key -> "OBS"
```

**Features:**
- Scene composition with multiple sources
- Real-time video/audio mixing
- Hardware encoding (NVENC, VA-API, QuickSync)
- Streaming to Twitch, YouTube, etc.
- Virtual camera output
- Plugin ecosystem
- Wayland screen capture support

**Basic Setup:**
1. Launch OBS Studio
2. Add sources: Display Capture (Wayland), Window Capture, Audio Input
3. Configure output settings: Settings > Output
4. Choose encoder (hardware recommended)
5. Set recording path
6. Start recording/streaming

**Recommended Settings for Wayland:**
- Video capture: Use "Screen Capture (PipeWire)"
- Audio: PulseAudio/PipeWire input
- Encoder: Hardware (NVENC for NVIDIA, VA-API for AMD/Intel)
- Format: MP4 or MKV

**Keyboard Shortcuts:**
- `Ctrl+R` - Start/Stop Recording
- `Ctrl+P` - Pause Recording
- `Ctrl+E` - Settings

### gpu-screen-recorder

**Package:** `gpu-screen-recorder`

**Description:** High-performance screen recorder using GPU encoding for minimal CPU usage.

**Features:**
- Very low CPU usage
- Hardware encoding (NVENC, VA-API)
- Wayland support
- Audio capture
- Replay buffer mode
- Instant recording start

**Basic Usage:**
```bash
# Record entire screen
gpu-screen-recorder -w screen -f 60 -o output.mp4

# Record specific window
gpu-screen-recorder -w window -f 60 -o output.mp4

# Record with audio
gpu-screen-recorder -w screen -f 60 -a default -o output.mp4
```

**Common Options:**
- `-w screen` - Capture entire screen
- `-w window` - Capture specific window
- `-f 60` - Frame rate (60 fps)
- `-a default` - Audio device
- `-o file.mp4` - Output file
- `-c mkv` - Container format

**Integration:**

gpu-screen-recorder can be integrated with keybindings for instant recording:

```bash
# Create recording script
#!/bin/bash
gpu-screen-recorder -w screen -f 60 -a default -o ~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4
```

## Video Editing

### Kdenlive

**Package:** `kdenlive`

**Description:** Full-featured, professional video editing software with multi-track timeline.

**Launch:**
```bash
kdenlive
# Or via Walker: Super key -> "Kdenlive"
```

**Features:**
- Multi-track video/audio editing
- Wide format support
- Video effects and transitions
- Color correction and grading
- Keyframe animation
- Audio mixer
- Proxy editing for performance
- Hardware-accelerated rendering

**Basic Workflow:**
1. Launch Kdenlive
2. Create new project
3. Import media: Project > Add Clip
4. Drag clips to timeline
5. Cut and arrange clips
6. Add transitions between clips
7. Apply effects from Effects panel
8. Render: Project > Render

**Performance Tips:**
- Enable proxy clips for 4K footage: Settings > Configure Kdenlive > Proxy Clips
- Use hardware rendering: Settings > Configure Kdenlive > Rendering
- Close other applications during render
- Use SSD for project files

**Keyboard Shortcuts:**
- `Space` - Play/Pause
- `I` - Set In Point
- `O` - Set Out Point
- `Ctrl+X` - Cut clip
- `Ctrl+R` - Render

## Media Playback

### mpv

**Package:** `mpv`

**Description:** Powerful, minimalist media player with extensive format support and hardware acceleration.

**Launch:**
```bash
# Play video file
mpv video.mp4

# Play from URL
mpv https://example.com/video.mp4

# Play playlist
mpv *.mp4

# Play with subtitles
mpv video.mp4 --sub-file=subtitles.srt
```

**Features:**
- Hardware video decoding
- High-quality video output
- On-screen controller
- Subtitle support
- Streaming support
- Playlist management
- Screenshot capability
- Video filters

**Keyboard Controls:**
- `Space` - Play/Pause
- `Left/Right` - Seek -/+ 5 seconds
- `Up/Down` - Seek -/+ 1 minute
- `[` / `]` - Speed down/up
- `m` - Mute
- `f` - Fullscreen
- `s` - Screenshot
- `q` - Quit

**Configuration:**

Create `~/.config/mpv/mpv.conf`:
```ini
# Hardware acceleration
hwdec=auto

# High quality
profile=gpu-hq
scale=ewa_lanczossharp
cscale=ewa_lanczossharp

# Screenshot format
screenshot-format=png
screenshot-directory=~/Pictures/Screenshots

# Subtitles
sub-auto=fuzzy
sub-font-size=48
```

**Advanced Usage:**
```bash
# Play at specific speed
mpv --speed=1.5 video.mp4

# Loop video
mpv --loop video.mp4

# Play audio only
mpv --no-video audio.mp3

# Take screenshot
mpv video.mp4 --screenshot-format=png
```

## Screenshot Tools

### omarchy-cmd-screenshot

**Command:** `omarchy-cmd-screenshot [mode] [processing]`

**Description:** Omarchy's integrated screenshot utility using grim, slurp, and satty.

**Modes:**
- `smart` (default) - Intelligent selection with window snapping
- `region` - Free-form region selection
- `windows` - Select from visible windows
- `fullscreen` - Capture entire screen

**Processing:**
- `slurp` (default) - Open in satty for annotation
- `copy` - Copy directly to clipboard

**Usage:**
```bash
# Smart mode with annotation
omarchy-cmd-screenshot smart slurp

# Region mode, copy to clipboard
omarchy-cmd-screenshot region copy

# Full screen with annotation
omarchy-cmd-screenshot fullscreen

# Quick clipboard capture
omarchy-cmd-screenshot region copy
```

**Default Keybinding:**
- `Super+Shift+S` - Screenshot (smart mode)

**Output Location:**

Configured via `OMARCHY_SCREENSHOT_DIR` or defaults to `~/Pictures`

```bash
# Set custom screenshot directory
export OMARCHY_SCREENSHOT_DIR=~/Screenshots
```

### satty

**Package:** `satty`

**Description:** Screenshot annotation tool with drawing, text, and shape tools.

**Features:**
- Draw freehand lines
- Add shapes (rectangle, circle, arrow)
- Add text annotations
- Highlight areas
- Crop and blur
- Save or copy to clipboard
- Keyboard-driven workflow

**Usage:**
```bash
# Edit screenshot
satty --filename screenshot.png

# With output path
satty --filename screenshot.png --output-filename annotated.png

# Copy to clipboard on save
satty --filename screenshot.png --copy-command 'wl-copy'
```

**Keyboard Shortcuts:**
- `1-9` - Tool selection
- `Ctrl+S` - Save
- `Ctrl+C` - Copy to clipboard
- `Ctrl+Z` - Undo
- `Ctrl+Y` - Redo
- `Esc` - Exit

### grim + slurp

**Packages:** `grim`, `slurp`

**Description:** Wayland-native screenshot utilities.

**grim** - Screenshot capture
```bash
# Capture full screen
grim screenshot.png

# Capture specific region
grim -g "0,0 1920x1080" screenshot.png

# Capture to clipboard
grim - | wl-copy
```

**slurp** - Region selection
```bash
# Select region (returns geometry)
slurp
# Example output: 100,100 800x600

# Use with grim
grim -g "$(slurp)" screenshot.png

# Select from rectangles (windows)
slurp -r
```

**Combined Usage:**
```bash
# Interactive region screenshot
grim -g "$(slurp)" screenshot.png

# Screenshot and edit
grim -g "$(slurp)" - | satty --filename -

# Screenshot to clipboard
grim -g "$(slurp)" - | wl-copy
```

## Image Editing

### Pinta

**Package:** `pinta`

**Description:** Simple image editor similar to Paint.NET.

**Launch:**
```bash
pinta image.png
# Or via Walker
```

**Features:**
- Basic drawing tools
- Layers support
- Filters and effects
- Text tool
- Selection tools
- Clone stamp
- Simple and fast

**Use Cases:**
- Quick image edits
- Adding text to images
- Cropping and resizing
- Basic color adjustments
- Annotating screenshots

### ImageMagick

**Package:** `imagemagick`

**Description:** Command-line image manipulation tool.

**Usage:**
```bash
# Convert format
convert image.png image.jpg

# Resize image
convert image.jpg -resize 800x600 resized.jpg

# Add border
convert image.jpg -border 10x10 bordered.jpg

# Rotate image
convert image.jpg -rotate 90 rotated.jpg

# Create thumbnail
convert image.jpg -thumbnail 200x200 thumb.jpg

# Combine images
convert image1.jpg image2.jpg +append combined.jpg

# Add text
convert image.jpg -pointsize 48 -draw "text 10,50 'Hello'" output.jpg
```

## Examples

### Example 1: Screen Recording with OBS

```bash
# 1. Launch OBS Studio
obs-studio

# 2. Create scene
# Click '+' under Scenes > Name: "Desktop Recording"

# 3. Add sources
# Click '+' under Sources > Select "Screen Capture (PipeWire)"
# Choose display

# 4. Add audio
# Click '+' under Sources > "Audio Input Capture"
# Select microphone

# 5. Configure output
# Settings > Output > Recording
# Recording Path: ~/Videos
# Recording Format: MP4
# Encoder: NVIDIA NVENC H.264 (or VA-API)
# Quality: High

# 6. Start recording
# Click "Start Recording" or Ctrl+R

# 7. Stop recording
# Click "Stop Recording" or Ctrl+R
```

### Example 2: Quick Screenshot Workflow

```bash
# Take smart screenshot (bound to Super+Shift+S)
omarchy-cmd-screenshot

# Steps:
# 1. Screen freezes
# 2. Select region or click window
# 3. satty opens with screenshot
# 4. Annotate with tools (draw, text, arrows)
# 5. Press Ctrl+S to save or Ctrl+C to copy
# 6. Screenshot saved to ~/Pictures

# Quick clipboard capture
omarchy-cmd-screenshot region copy
# 1. Select region
# 2. Automatically copied to clipboard
# 3. Paste anywhere with Ctrl+V
```

### Example 3: Video Editing in Kdenlive

```bash
# 1. Launch Kdenlive
kdenlive

# 2. Create project
# File > New > Set project folder and name

# 3. Import clips
# Project > Add Clip > Select video files

# 4. Create timeline
# Drag video clips to Video1 track
# Drag audio clips to Audio1 track

# 5. Edit clips
# Click razor tool or press X to cut
# Drag clips to rearrange
# Delete unwanted sections

# 6. Add transitions
# Drag transition from Transitions panel between clips

# 7. Add effects
# Select clip > Drag effect from Effects panel

# 8. Add titles
# Project > Add Title Clip
# Edit text and style
# Drag to timeline

# 9. Render video
# Project > Render
# Choose preset (e.g., MP4 1080p)
# Set output file
# Click "Render to File"
```

### Example 4: Batch Image Processing

```bash
# Convert all PNGs to JPG
for img in *.png; do
  convert "$img" "${img%.png}.jpg"
done

# Resize all images to 1920x1080
for img in *.jpg; do
  convert "$img" -resize 1920x1080 "resized_$img"
done

# Create thumbnails
mkdir thumbnails
for img in *.jpg; do
  convert "$img" -thumbnail 200x200 "thumbnails/thumb_$img"
done

# Add watermark to all images
for img in *.jpg; do
  convert "$img" -pointsize 48 -fill white \
    -gravity southeast -annotate +10+10 '© 2025' \
    "watermarked_$img"
done
```

### Example 5: Media Player Configuration

```bash
# Create mpv config
mkdir -p ~/.config/mpv
cat > ~/.config/mpv/mpv.conf << 'EOF'
# Hardware acceleration
hwdec=auto

# High quality scaling
profile=gpu-hq
scale=ewa_lanczossharp
cscale=ewa_lanczossharp

# Screenshots
screenshot-format=png
screenshot-directory=~/Pictures/Screenshots
screenshot-template="%F-%wHh%wMm%wSs"

# Subtitles
sub-auto=fuzzy
sub-font-size=48
sub-border-size=2

# Performance
cache=yes
cache-secs=10

# Audio
volume=100
volume-max=150
EOF

# Test configuration
mpv video.mp4
```

### Example 6: Automated Screen Recording

```bash
# Create recording script
cat > ~/bin/quick-record.sh << 'EOF'
#!/bin/bash
OUTPUT_DIR=~/Videos/Recordings
mkdir -p "$OUTPUT_DIR"
FILENAME="recording-$(date +%Y%m%d-%H%M%S).mp4"

# Check if already recording
if pgrep -x gpu-screen-recorder > /dev/null; then
  pkill gpu-screen-recorder
  notify-send "Recording Stopped" "Video saved to $OUTPUT_DIR"
else
  gpu-screen-recorder -w screen -f 60 -a default -o "$OUTPUT_DIR/$FILENAME" &
  notify-send "Recording Started" "Press again to stop"
fi
EOF

chmod +x ~/bin/quick-record.sh

# Bind to keybinding in Hyprland
# Add to ~/.config/hypr/hyprland.conf:
# bind = SUPER_SHIFT, R, exec, ~/bin/quick-record.sh
```

## Package List

Media tools from `omarchy-base.packages`:

```
# Recording & Streaming
obs-studio              # Professional recording/streaming
gpu-screen-recorder     # Efficient GPU recording

# Video Editing
kdenlive               # Full-featured video editor

# Media Playback
mpv                    # Powerful media player

# Screenshot Tools
grim                   # Wayland screenshot
slurp                  # Region selector
satty                  # Annotation tool

# Image Editing
pinta                  # Simple image editor
imagemagick            # Command-line image processing

# Supporting Tools
ffmpegthumbnailer      # Video thumbnails
imv                    # Image viewer
```

## Troubleshooting

### OBS Can't Capture Screen

**Problem:** OBS shows black screen or can't find display

**Solution:**
```bash
# Ensure PipeWire screen sharing is working
systemctl --user status pipewire
systemctl --user status wireplumber

# Restart if needed
systemctl --user restart pipewire wireplumber

# Use "Screen Capture (PipeWire)" source in OBS
# Not "Display Capture" or "Window Capture"
```

### Screenshots Save to Wrong Location

**Problem:** Screenshots not saving to expected directory

**Solution:**
```bash
# Check current screenshot directory
echo $OMARCHY_SCREENSHOT_DIR

# Set custom directory
echo 'export OMARCHY_SCREENSHOT_DIR=~/Screenshots' >> ~/.bashrc
source ~/.bashrc

# Create directory
mkdir -p ~/Screenshots

# Test screenshot
omarchy-cmd-screenshot
```

### mpv Hardware Acceleration Not Working

**Problem:** mpv using software decoding, high CPU usage

**Solution:**
```bash
# Check hardware decoder availability
mpv --hwdec=auto video.mp4 --msg-level=vo=trace 2>&1 | grep -i hwdec

# For NVIDIA
# Ensure nvidia drivers installed
pacman -Q nvidia

# For AMD/Intel
# Ensure VA-API drivers installed
pacman -Q libva-mesa-driver  # AMD
pacman -Q intel-media-driver # Intel

# Test hardware decoding
mpv --hwdec=vaapi video.mp4  # AMD/Intel
mpv --hwdec=nvdec video.mp4  # NVIDIA
```

### Kdenlive Crashes During Render

**Problem:** Kdenlive crashes or freezes during video rendering

**Solution:**
```bash
# Enable proxy clips for large files
# Settings > Configure Kdenlive > Proxy Clips
# Check "Generate proxy clips"

# Reduce preview resolution
# Settings > Configure Kdenlive > Playback
# Preview resolution: 720p

# Use faster render preset
# Render > Choose "Ultra Fast" preset

# Close other applications
# Free up RAM and CPU
```

### satty Won't Open

**Problem:** satty doesn't launch or crashes immediately

**Solution:**
```bash
# Check if satty is installed
pacman -Q satty

# Test manually
echo "test" > /tmp/test.png
satty --filename /tmp/test.png

# Check for missing dependencies
ldd $(which satty) | grep "not found"

# Reinstall if needed
omarchy-pkg-add satty
```

## Best Practices

### Screen Recording
- Use hardware encoding (NVENC, VA-API) for better performance
- Record to fast storage (SSD) to avoid dropped frames
- Close unnecessary applications to free resources
- Test audio levels before important recordings
- Use separate audio tracks for easier editing

### Screenshots
- Use smart mode for automatic window detection
- Save screenshots to organized directories
- Use descriptive filenames with timestamps
- Annotate immediately while context is fresh
- Keep copies before heavy editing

### Video Editing
- Enable proxy clips for 4K footage
- Save project frequently
- Keep original footage untouched
- Export in multiple formats/resolutions
- Use hardware rendering when available

### Media Playback
- Configure hardware decoding for efficiency
- Use keyboard shortcuts for quick navigation
- Create profiles for different content types
- Organize media library with proper naming

## Related Documentation

- [Screenshot & Screen Record](../08-utilities/screenshot-screenrecord.md) - Detailed capture workflows
- [Hyprland Integration](../04-desktop-environment/hyprland-integration.md) - Screenshot keybindings
- [Core Applications](./core-applications.md) - Essential applications
- [Productivity Apps](./productivity-apps.md) - Productivity-focused applications

---

*Last Updated: 2025-10-21*
*Source: omarchy-base.packages, omarchy-cmd-screenshot*
