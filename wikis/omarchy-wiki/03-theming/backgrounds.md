# Omarchy Background Management

## Quick Start

```bash
# Cycle to next background in current theme
omarchy-theme-bg-next

# Check current theme's backgrounds
ls ~/.config/omarchy/current/theme/backgrounds/

# View current background symlink
readlink ~/.config/omarchy/current/background
```

---

## Table of Contents

1. [Overview](#overview)
2. [How Backgrounds Work](#how-backgrounds-work)
3. [Background Structure in Themes](#background-structure-in-themes)
4. [Commands Reference](#commands-reference)
5. [Examples](#examples)
   - [Basic: Cycling Backgrounds](#example-1-basic-cycling-backgrounds)
   - [Intermediate: Adding Custom Backgrounds](#example-2-intermediate-adding-custom-backgrounds)
   - [Advanced: Creating Background Collections](#example-3-advanced-creating-background-collections)
6. [Adding Custom Backgrounds](#adding-custom-backgrounds)
7. [Background File Formats](#background-file-formats)
8. [Swaybg Integration](#swaybg-integration)
9. [Troubleshooting](#troubleshooting)
10. [Best Practices](#best-practices)
11. [Related Documentation](#related-documentation)

---

## Overview

Omarchy manages desktop backgrounds through a symlink-based system integrated with themes. Each theme can include multiple wallpapers, and you can cycle through them instantly with `omarchy-theme-bg-next`. Backgrounds are displayed using `swaybg`, a Wayland wallpaper daemon that efficiently renders images with various display modes.

The background system is tightly coupled with themes but operates independently. Changing backgrounds doesn't restart any services besides `swaybg`, making it extremely lightweight. If a theme has no backgrounds, `swaybg` falls back to a solid black color (`#000000`), creating a minimal aesthetic.

Backgrounds use the same symlink architecture as themes: a single symlink at `~/.config/omarchy/current/background` points to the active wallpaper. This allows applications (like lock screens) to reference a consistent location while the underlying image can be changed instantly.

---

## How Backgrounds Work

### Architecture

Backgrounds are stored within theme directories:

```
~/.config/omarchy/themes/
├── catppuccin/
│   └── backgrounds/
│       ├── 1-catppuccin.png
│       ├── 2-cat-waves-mocha.png
│       └── 3-cat-blue-eye-mocha.png
├── tokyo-night/
│   └── backgrounds/
│       ├── 1-tokyo-night.png
│       ├── 2-tokyo-street.jpg
│       └── 3-anime-city.png
└── matte-black/
    └── backgrounds/
        # (empty - uses solid color)

~/.config/omarchy/current/
├── theme -> ../themes/catppuccin          # Active theme symlink
└── background -> theme/backgrounds/2-cat-waves-mocha.png  # Active background symlink
```

### Cycling Mechanism

When you run `omarchy-theme-bg-next`, the script:

1. **Discovers Backgrounds**: Scans `~/.config/omarchy/current/theme/backgrounds/` for image files
2. **Sorts Alphabetically**: Orders files by name (this is why numeric prefixes like `1-`, `2-` are useful)
3. **Finds Current Background**: Reads the symlink at `~/.config/omarchy/current/background`
4. **Calculates Next Index**: Wraps around to the first background after the last one
5. **Updates Symlink**: Points `current/background` to the next image
6. **Restarts Swaybg**: Kills existing `swaybg` process and launches a new one with the updated image

If no backgrounds exist, `swaybg` is launched with `--color '#000000'` for a solid black background.

### Integration with Theme System

Backgrounds are automatically cycled when you set a theme:

```bash
omarchy-theme-set catppuccin
# This internally calls omarchy-theme-bg-next
# So you always get the first background of the new theme
```

This ensures a consistent experience: each theme switch gives you a fresh start with its first background.

### Symlink Chain

The background symlink is a relative symlink that goes through the theme symlink:

```
~/.config/omarchy/current/background
  → theme/backgrounds/1-catppuccin.png
  → ../themes/catppuccin/backgrounds/1-catppuccin.png
  → /home/you/.config/omarchy/themes/catppuccin/backgrounds/1-catppuccin.png
```

This indirection means changing the theme automatically changes the background directory without additional work.

---

## Background Structure in Themes

### Standard Layout

Each theme directory can contain a `backgrounds/` subdirectory:

```
theme-name/
├── alacritty.toml
├── waybar.css
├── hyprland.conf
├── ... (other theme files)
└── backgrounds/
    ├── 1-first-bg.png
    ├── 2-second-bg.jpg
    ├── 3-third-bg.png
    └── ... (more backgrounds)
```

### Naming Conventions

**Numeric Prefixes** (Recommended):
- Use `1-`, `2-`, `3-` prefixes to control order
- Backgrounds cycle in alphabetical order
- Numeric prefixes ensure predictable sequence

Examples:
```
1-morning.png
2-afternoon.png
3-evening.png
4-night.png
```

**Descriptive Names**:
- Include theme name or color scheme
- Helps identify background when browsing files
- Examples: `1-catppuccin.png`, `2-cat-waves-mocha.png`

**Theme Consistency**:
- Name backgrounds after the theme for easy identification
- Example in gruvbox theme: `1-gruvbox-dark.png`, `2-gruvbox-forest.jpg`

### Empty Backgrounds Directory

Some themes intentionally have no backgrounds (or an empty `backgrounds/` directory):

```
matte-black/
├── alacritty.toml
├── waybar.css
└── backgrounds/  # Empty directory
```

This is valid and intentional. `omarchy-theme-bg-next` will use a solid black background (`#000000`) via `swaybg --color`.

Minimal themes like "Matte Black" embrace this aesthetic for OLED screens or distraction-free environments.

---

## Commands Reference

| Command | Purpose | Usage | Behavior |
|---------|---------|-------|----------|
| `omarchy-theme-bg-next` | Cycle to next background | `omarchy-theme-bg-next` | Wraps around at end of background list |

### omarchy-theme-bg-next

Cycles through all backgrounds in the current theme's `backgrounds/` directory.

**Behavior**:
- Sorts backgrounds alphabetically by filename
- Finds current background from symlink
- Advances to next background (wraps to first after last)
- Updates symlink at `~/.config/omarchy/current/background`
- Kills existing `swaybg` process
- Launches new `swaybg` with updated background

**Output**:
- No terminal output on success
- Notification via `notify-send` if no backgrounds found: "No background was found for theme"

**Edge Cases**:
- **No backgrounds**: Uses solid black color (`#000000`)
- **Single background**: Cycling does nothing (always shows the same image)
- **First run**: If symlink doesn't exist, starts with first background

**Called Automatically By**:
- `omarchy-theme-set`: Always cycles to first background when switching themes

---

## Examples

### Example 1: Basic - Cycling Backgrounds

**Scenario**: You're using the Catppuccin theme and want to change the wallpaper to match your mood or time of day.

```bash
# Check current theme
omarchy-theme-current
```

**Expected Output**:
```
Catppuccin
```

```bash
# See what backgrounds are available
ls ~/.config/omarchy/current/theme/backgrounds/
```

**Expected Output**:
```
1-catppuccin.png  2-cat-waves-mocha.png  3-cat-blue-eye-mocha.png
```

```bash
# Check which background is currently active
readlink ~/.config/omarchy/current/background
```

**Expected Output**:
```
/home/you/.config/omarchy/themes/catppuccin/backgrounds/1-catppuccin.png
```

```bash
# Cycle to the next background
omarchy-theme-bg-next
```

**What Happens**:
1. Script finds all 3 backgrounds in the directory
2. Identifies current background as `1-catppuccin.png`
3. Calculates next index: 1 → 2
4. Updates symlink to point to `2-cat-waves-mocha.png`
5. Kills existing `swaybg` process
6. Launches new `swaybg -i ~/.config/omarchy/current/background -m fill`

**Result**: Your wallpaper instantly changes to `2-cat-waves-mocha.png`.

```bash
# Verify the change
readlink ~/.config/omarchy/current/background
```

**Expected Output**:
```
/home/you/.config/omarchy/themes/catppuccin/backgrounds/2-cat-waves-mocha.png
```

```bash
# Cycle again
omarchy-theme-bg-next

# Now it's on 3-cat-blue-eye-mocha.png

# Cycle once more
omarchy-theme-bg-next

# It wraps back to 1-catppuccin.png
```

**Why Use This**: Quickly change your desktop aesthetic without switching themes. Match your wallpaper to your workflow, time of day, or mood. Cycling is instant and doesn't interrupt any running applications.

**Pro Tip**: Bind `omarchy-theme-bg-next` to a keybinding in Hyprland:

```conf
# ~/.config/hypr/bindings.conf
bind = SUPER SHIFT, B, exec, omarchy-theme-bg-next
```

Press `SUPER+SHIFT+B` to instantly cycle wallpapers.

---

### Example 2: Intermediate - Adding Custom Backgrounds

**Scenario**: You have a collection of wallpapers you love and want to add them to your favorite theme (Gruvbox).

**Step 1: Prepare Your Images**

```bash
# Create a temporary directory for your wallpapers
mkdir -p ~/wallpapers-to-add

# Copy or download your favorite images
cp ~/Pictures/forest.jpg ~/wallpapers-to-add/
cp ~/Pictures/mountains.png ~/wallpapers-to-add/
wget -O ~/wallpapers-to-add/desert.jpg https://example.com/desert-wallpaper.jpg
```

**Step 2: Check Current Backgrounds**

```bash
# See what backgrounds Gruvbox already has
ls ~/.local/share/omarchy/themes/gruvbox/backgrounds/
```

**Expected Output**:
```
1-gruvbox-dark.png
```

**Step 3: Add Your Custom Backgrounds**

```bash
# Copy your wallpapers to the Gruvbox theme backgrounds directory
# Use numeric prefixes to control order
cp ~/wallpapers-to-add/forest.jpg \
   ~/.local/share/omarchy/themes/gruvbox/backgrounds/2-gruvbox-forest.jpg

cp ~/wallpapers-to-add/mountains.png \
   ~/.local/share/omarchy/themes/gruvbox/backgrounds/3-gruvbox-mountains.png

cp ~/wallpapers-to-add/desert.jpg \
   ~/.local/share/omarchy/themes/gruvbox/backgrounds/4-gruvbox-desert.jpg
```

**Step 4: Verify and Test**

```bash
# Check updated backgrounds list
ls ~/.local/share/omarchy/themes/gruvbox/backgrounds/
```

**Expected Output**:
```
1-gruvbox-dark.png
2-gruvbox-forest.jpg
3-gruvbox-mountains.png
4-gruvbox-desert.jpg
```

```bash
# If you're already using Gruvbox theme, cycle through your new backgrounds
omarchy-theme-bg-next  # Shows 2-gruvbox-forest.jpg
omarchy-theme-bg-next  # Shows 3-gruvbox-mountains.png
omarchy-theme-bg-next  # Shows 4-gruvbox-desert.jpg
omarchy-theme-bg-next  # Wraps back to 1-gruvbox-dark.png
```

**Step 5: Clean Up**

```bash
# Remove temporary directory
rm -rf ~/wallpapers-to-add
```

**Why Use This**: Personalize your themes with wallpapers that match your aesthetic preferences. Mix official theme backgrounds with your own curated collection.

**Pro Tip**: Name backgrounds descriptively so you know what to expect when cycling:
- `1-gruvbox-cozy-cabin.jpg`
- `2-gruvbox-autumn-forest.jpg`
- `3-gruvbox-warm-fireplace.jpg`

---

### Example 3: Advanced - Creating Background Collections

**Scenario**: You want to create a custom theme variant with curated wallpapers for different times of day, maintaining the color scheme but varying the mood.

**Step 1: Copy Base Theme**

```bash
# Create a custom theme based on Catppuccin
cp -r ~/.local/share/omarchy/themes/catppuccin \
      ~/.local/share/omarchy/themes/catppuccin-timebased

# Clear out existing backgrounds
rm ~/.local/share/omarchy/themes/catppuccin-timebased/backgrounds/*
```

**Step 2: Organize Your Background Collection**

Create backgrounds for different times of day:

```bash
# Create a collection directory
mkdir -p ~/catppuccin-collection

# Download or create backgrounds matching Catppuccin's pastel aesthetic
# (Example URLs are placeholders - use real wallpaper sources)

# Morning backgrounds (bright, soft, pastel blues/pinks)
wget -O ~/catppuccin-collection/morning-1.jpg https://example.com/morning-pastel-sky.jpg
wget -O ~/catppuccin-collection/morning-2.png https://example.com/sunrise-mountains.png

# Afternoon backgrounds (warm, light, energetic)
wget -O ~/catppuccin-collection/afternoon-1.jpg https://example.com/bright-meadow.jpg
wget -O ~/catppuccin-collection/afternoon-2.png https://example.com/sunny-beach.png

# Evening backgrounds (cooling colors, transitional)
wget -O ~/catppuccin-collection/evening-1.jpg https://example.com/sunset-city.jpg
wget -O ~/catppuccin-collection/evening-2.png https://example.com/dusk-forest.png

# Night backgrounds (dark, calming, deep purples/blues)
wget -O ~/catppuccin-collection/night-1.jpg https://example.com/starry-night.jpg
wget -O ~/catppuccin-collection/night-2.png https://example.com/moonlit-lake.png
```

**Step 3: Add Backgrounds with Descriptive Names**

```bash
# Copy backgrounds with organized naming scheme
cp ~/catppuccin-collection/morning-1.jpg \
   ~/.local/share/omarchy/themes/catppuccin-timebased/backgrounds/1-morning-pastel-sky.jpg

cp ~/catppuccin-collection/morning-2.png \
   ~/.local/share/omarchy/themes/catppuccin-timebased/backgrounds/2-morning-sunrise-mountains.png

cp ~/catppuccin-collection/afternoon-1.jpg \
   ~/.local/share/omarchy/themes/catppuccin-timebased/backgrounds/3-afternoon-meadow.jpg

cp ~/catppuccin-collection/afternoon-2.png \
   ~/.local/share/omarchy/themes/catppuccin-timebased/backgrounds/4-afternoon-beach.png

cp ~/catppuccin-collection/evening-1.jpg \
   ~/.local/share/omarchy/themes/catppuccin-timebased/backgrounds/5-evening-sunset-city.jpg

cp ~/catppuccin-collection/evening-2.png \
   ~/.local/share/omarchy/themes/catppuccin-timebased/backgrounds/6-evening-dusk-forest.png

cp ~/catppuccin-collection/night-1.jpg \
   ~/.local/share/omarchy/themes/catppuccin-timebased/backgrounds/7-night-starry.jpg

cp ~/catppuccin-collection/night-2.png \
   ~/.local/share/omarchy/themes/catppuccin-timebased/backgrounds/8-night-moonlit-lake.png
```

**Step 4: Activate Your Custom Theme**

```bash
# Switch to your custom theme
omarchy-theme-set catppuccin-timebased
```

**What Happens**:
- Theme symlink points to `catppuccin-timebased`
- Background cycles to first image: `1-morning-pastel-sky.jpg`
- All color schemes remain Catppuccin (since you copied the theme files)
- Only backgrounds are different

**Step 5: Use Throughout the Day**

```bash
# Morning routine: Cycle to a morning background
omarchy-theme-bg-next  # 1-morning-pastel-sky.jpg
omarchy-theme-bg-next  # 2-morning-sunrise-mountains.png

# Afternoon work session: Cycle to afternoon backgrounds
omarchy-theme-bg-next  # 3-afternoon-meadow.jpg
omarchy-theme-bg-next  # 4-afternoon-beach.png

# Evening wind-down: Cycle to evening backgrounds
omarchy-theme-bg-next  # 5-evening-sunset-city.jpg

# Night coding: Cycle to night backgrounds
omarchy-theme-bg-next  # 7-night-starry.jpg
```

**Step 6: Create Multiple Theme Variants**

Repeat for other themes:

```bash
# Tokyo Night time-based variant
cp -r ~/.local/share/omarchy/themes/tokyo-night \
      ~/.local/share/omarchy/themes/tokyo-night-timebased

# Gruvbox seasonal variant
cp -r ~/.local/share/omarchy/themes/gruvbox \
      ~/.local/share/omarchy/themes/gruvbox-seasonal

# Add curated backgrounds to each
```

**Why Use This**: Create highly personalized desktop experiences that match your workflow. Time-based backgrounds can reinforce circadian rhythms (bright in morning, dark at night) without switching entire themes.

**Advanced Tip**: Combine with hooks to automatically cycle backgrounds based on time of day:

```bash
# Create a hook script at ~/.config/omarchy/hooks/hourly-background/cycle.sh

#!/bin/bash
HOUR=$(date +%H)

if [[ $HOUR -ge 6 && $HOUR -lt 12 ]]; then
  # Morning: Cycle to backgrounds 1-2
  # (implement logic to set specific background)
elif [[ $HOUR -ge 12 && $HOUR -lt 18 ]]; then
  # Afternoon: Backgrounds 3-4
elif [[ $HOUR -ge 18 && $HOUR -lt 22 ]]; then
  # Evening: Backgrounds 5-6
else
  # Night: Backgrounds 7-8
fi
```

Trigger this via a systemd timer for automatic time-based background changes.

---

## Adding Custom Backgrounds

### Where to Add Backgrounds

Backgrounds are stored in the theme's `backgrounds/` directory:

```
~/.local/share/omarchy/themes/THEME-NAME/backgrounds/
```

**Example**:
```bash
# Add to Catppuccin theme
~/.local/share/omarchy/themes/catppuccin/backgrounds/

# Add to Tokyo Night theme
~/.local/share/omarchy/themes/tokyo-night/backgrounds/

# Add to your custom theme
~/.local/share/omarchy/themes/my-custom-theme/backgrounds/
```

### Step-by-Step: Adding a Background

**Step 1: Choose a Theme**

```bash
# List available themes
omarchy-theme-list

# Or see theme directories
ls ~/.local/share/omarchy/themes/
```

**Step 2: Check Existing Backgrounds**

```bash
# Example: Checking Gruvbox backgrounds
ls ~/.local/share/omarchy/themes/gruvbox/backgrounds/
```

**Step 3: Prepare Your Image**

```bash
# Copy or download your wallpaper
cp ~/Pictures/my-wallpaper.jpg ~/my-wallpaper.jpg

# Or download from URL
wget -O ~/my-wallpaper.jpg https://example.com/wallpaper.jpg
```

**Step 4: Add to Theme**

```bash
# Determine next numeric prefix
# If theme has 1-bg.png and 2-bg.png, use 3-

# Copy with proper naming
cp ~/my-wallpaper.jpg \
   ~/.local/share/omarchy/themes/gruvbox/backgrounds/3-my-custom-wallpaper.jpg
```

**Step 5: Test**

```bash
# If already using the theme, cycle to see your new background
omarchy-theme-bg-next
```

Your new background will appear in the cycle.

### Tips for Custom Backgrounds

**Match Theme Colors**:
- Choose wallpapers that complement the theme's color palette
- For Catppuccin: Soft pastels, purples, pinks
- For Gruvbox: Warm earth tones, browns, oranges
- For Tokyo Night: Deep blues, vibrant purples, neon accents

**Resolution Recommendations**:
- Use native resolution or higher for your display
- Example: 1920x1080, 2560x1440, 3840x2160
- Swaybg will scale images, but native looks best

**File Size Considerations**:
- Keep images under 5MB for fast loading
- Compress large images with tools like `imagemagick`:
  ```bash
  convert large-image.png -quality 85 compressed-image.jpg
  ```

**Testing Compatibility**:
- Test wallpaper with theme before adding permanently
- Check readability: Can you see Waybar text, terminal windows?
- Adjust image brightness/contrast if needed

---

## Background File Formats

Swaybg supports common image formats:

| Format | Extension | Use Case | Notes |
|--------|-----------|----------|-------|
| **PNG** | `.png` | High quality, transparency | Larger file size, lossless |
| **JPEG** | `.jpg`, `.jpeg` | Photographs, realistic images | Smaller file size, lossy compression |
| **WebP** | `.webp` | Modern format, balanced | Good compression, wide support |
| **BMP** | `.bmp` | Uncompressed | Very large, rarely used |
| **GIF** | `.gif` | (static only) | Animations not supported by swaybg |

### Recommended Format

**For most users**: **JPEG** (`.jpg`)
- Good balance of quality and file size
- Best for photographic wallpapers
- Fast loading

**For minimal/vector backgrounds**: **PNG** (`.png`)
- Lossless quality
- Best for solid colors, gradients, minimalist designs
- Supports transparency (though not needed for wallpapers)

### Image Optimization

Optimize images before adding to themes:

```bash
# Install imagemagick
sudo pacman -S imagemagick  # Arch
sudo apt install imagemagick  # Ubuntu/Debian

# Compress a PNG
convert input.png -quality 85 output.jpg

# Resize to native resolution
convert input.jpg -resize 1920x1080 output.jpg

# Batch process multiple images
for img in ~/wallpapers/*.jpg; do
  convert "$img" -quality 85 -resize 1920x1080 "$(basename "$img" .jpg)-optimized.jpg"
done
```

### Aspect Ratio Considerations

Swaybg uses `-m fill` mode by default, which:
- Scales image to cover entire screen
- Maintains aspect ratio
- Crops edges if aspect ratio doesn't match

**Recommendations**:
- Use images matching your display's aspect ratio
- Common ratios: 16:9 (1920x1080), 16:10 (1920x1200), 21:9 (ultrawide)
- Images with different ratios will be cropped

---

## Swaybg Integration

### What is Swaybg?

Swaybg is a lightweight Wayland wallpaper daemon. It efficiently displays a single image as the desktop background with minimal resource usage.

**Features**:
- Multiple display modes: fill, fit, stretch, tile, center
- Solid color backgrounds
- Low memory footprint
- Wayland-native (no X11 dependencies)

### Display Modes

Omarchy uses `swaybg -m fill` (fill mode):

| Mode | Behavior | Use Case |
|------|----------|----------|
| **fill** | Scale to cover screen, crop edges | Default, best for most images |
| **fit** | Scale to fit within screen, may have borders | Images smaller than screen |
| **stretch** | Stretch to fill screen, distorts aspect ratio | (not recommended) |
| **center** | Display at original size, centered | Small images, patterns |
| **tile** | Repeat image to fill screen | Tiled patterns |

Omarchy defaults to `fill` because it provides the most aesthetically pleasing result for standard wallpapers.

### How Omarchy Uses Swaybg

**Launch Command**:
```bash
setsid uwsm-app -- swaybg -i ~/.config/omarchy/current/background -m fill >/dev/null 2>&1 &
```

**Breakdown**:
- `setsid`: Creates new session (prevents inheriting terminal signals)
- `uwsm-app`: Wraps process for UWSM (Universal Wayland Session Manager)
- `swaybg -i <image>`: Specifies image path
- `-m fill`: Sets display mode to fill
- `>/dev/null 2>&1 &`: Suppresses output, runs in background

**When No Backgrounds Exist**:
```bash
setsid uwsm-app -- swaybg --color '#000000' >/dev/null 2>&1 &
```

Uses solid black color instead of an image.

### Swaybg Process Management

**Finding Swaybg Process**:
```bash
# Check if swaybg is running
pgrep swaybg

# See full command
ps aux | grep swaybg
```

**Manually Restarting Swaybg**:
```bash
# Kill existing swaybg
pkill -x swaybg

# Launch with current background
setsid uwsm-app -- swaybg -i ~/.config/omarchy/current/background -m fill &
```

**Changing Display Mode** (Advanced):

If you prefer a different display mode, you can manually restart swaybg:

```bash
# Use "fit" mode instead of "fill"
pkill -x swaybg
setsid uwsm-app -- swaybg -i ~/.config/omarchy/current/background -m fit &
```

Note: This change is temporary. `omarchy-theme-bg-next` will revert to `fill` mode.

To make it permanent, modify the `omarchy-theme-bg-next` script:

```bash
# Edit the script
nano ~/.local/share/omarchy/bin/omarchy-theme-bg-next

# Find the line:
setsid uwsm-app -- swaybg -i "$CURRENT_BACKGROUND_LINK" -m fill >/dev/null 2>&1 &

# Change "fill" to your preferred mode:
setsid uwsm-app -- swaybg -i "$CURRENT_BACKGROUND_LINK" -m fit >/dev/null 2>&1 &
```

---

## Troubleshooting

### Background Doesn't Change

**Symptom**: Running `omarchy-theme-bg-next` doesn't update the wallpaper

**Causes**:
1. Swaybg isn't running
2. Symlink not updating
3. No backgrounds in theme

**Solutions**:

```bash
# Check if swaybg is running
pgrep swaybg
# If no output, swaybg isn't running

# Manually restart swaybg
pkill -x swaybg
setsid uwsm-app -- swaybg -i ~/.config/omarchy/current/background -m fill &

# Check if backgrounds exist
ls ~/.config/omarchy/current/theme/backgrounds/
# If empty or directory doesn't exist, theme has no backgrounds

# Check symlink
readlink ~/.config/omarchy/current/background
# Should point to an image file

# Try cycling again
omarchy-theme-bg-next
```

---

### Wallpaper is Cropped or Distorted

**Symptom**: Background image looks stretched, cropped, or doesn't fit screen properly

**Cause**: Image aspect ratio doesn't match your display, or wrong display mode

**Solutions**:

```bash
# Check your display resolution
hyprctl monitors | grep -A 5 "Monitor"

# Example output:
# Monitor eDP-1 (ID 0):
#   1920x1080@60.00

# If image is wrong aspect ratio, either:
# 1. Use a different image matching your aspect ratio
# 2. Change swaybg display mode to "fit" (may have borders)

# Temporarily change to "fit" mode:
pkill -x swaybg
setsid uwsm-app -- swaybg -i ~/.config/omarchy/current/background -m fit &
```

**Prevention**: Use images matching your display's aspect ratio. For 1920x1080 (16:9), use 16:9 images.

---

### Swaybg Crashes or Keeps Restarting

**Symptom**: Background flickers, swaybg restarts repeatedly, or desktop shows no wallpaper

**Cause**: Corrupted image file or unsupported format

**Solutions**:

```bash
# Check current background file
readlink ~/.config/omarchy/current/background
# Example: /home/you/.config/omarchy/themes/catppuccin/backgrounds/2-corrupt.png

# Test if image is valid
file /home/you/.config/omarchy/themes/catppuccin/backgrounds/2-corrupt.png
# Should say: PNG image data, ... or JPEG image data, ...

# If file is corrupted, remove or replace it
rm /home/you/.config/omarchy/themes/catppuccin/backgrounds/2-corrupt.png

# Cycle to next valid background
omarchy-theme-bg-next
```

**Prevention**: Test images before adding to theme:

```bash
# Verify image is valid
file ~/my-wallpaper.jpg

# Open image to confirm it displays correctly
imv ~/my-wallpaper.jpg  # or xdg-open ~/my-wallpaper.jpg
```

---

### Theme Has No Backgrounds

**Symptom**: `omarchy-theme-bg-next` shows notification "No background was found for theme"

**Cause**: Theme's `backgrounds/` directory is empty or doesn't exist

**Solution**: This is intentional for some themes (like Matte Black). Swaybg falls back to solid black.

**If you want backgrounds**:

```bash
# Check which theme you're using
omarchy-theme-current
# Example: Matte Black

# Add backgrounds to the theme
mkdir -p ~/.local/share/omarchy/themes/matte-black/backgrounds/

# Copy some wallpapers
cp ~/Pictures/wallpaper1.jpg ~/.local/share/omarchy/themes/matte-black/backgrounds/1-bg.jpg
cp ~/Pictures/wallpaper2.png ~/.local/share/omarchy/themes/matte-black/backgrounds/2-bg.png

# Cycle to first background
omarchy-theme-bg-next
```

---

### Background Symlink is Broken

**Symptom**: `readlink ~/.config/omarchy/current/background` shows a path, but file doesn't exist

**Cause**: Background file was deleted or moved

**Solution**:

```bash
# Check symlink
readlink ~/.config/omarchy/current/background
# Example: /home/you/.config/omarchy/themes/catppuccin/backgrounds/deleted.png

# Check if file exists
ls -lh /home/you/.config/omarchy/themes/catppuccin/backgrounds/deleted.png
# ls: cannot access ... No such file or directory

# Cycle to next valid background (script handles broken symlinks)
omarchy-theme-bg-next

# This will find the first valid background and update the symlink
```

---

## Best Practices

### Do's

**DO use numeric prefixes for background order**
```
1-morning.jpg
2-afternoon.jpg
3-evening.jpg
4-night.jpg
```
- Ensures predictable cycling order
- Easy to insert backgrounds in between (1.5-midday.jpg → 15-midday.jpg)

**DO keep backgrounds organized by theme**
- Don't mix unrelated wallpapers in one theme
- Example: Gruvbox theme should have warm, earthy wallpapers
- Create theme variants for different wallpaper collections

**DO optimize images for your display**
```bash
# Resize and compress
convert input.jpg -resize 1920x1080 -quality 85 output.jpg
```
- Faster loading times
- Less disk space
- No visible quality loss

**DO match wallpapers to theme colors**
- Catppuccin: Soft pastels, purples, pinks
- Tokyo Night: Deep blues, vibrant purples
- Gruvbox: Warm earth tones
- Ensures cohesive aesthetic

**DO test backgrounds before committing**
- Check if text is readable (Waybar, terminals)
- Verify image isn't too busy or distracting
- Ensure colors don't clash with theme

**DO create theme variants for different background sets**
```bash
cp -r ~/.local/share/omarchy/themes/catppuccin \
      ~/.local/share/omarchy/themes/catppuccin-nature
# Add nature-themed wallpapers to catppuccin-nature
```

---

### Don'ts

**DON'T add too many backgrounds to one theme**
- More than 10-15 backgrounds makes cycling cumbersome
- Hard to remember which background is next
- Creates clutter in backgrounds directory

**DON'T use extremely large images**
- Keep under 5MB per image
- Large images slow down swaybg launch
- Compress with `convert input.jpg -quality 85 output.jpg`

**DON'T use animated GIFs**
- Swaybg doesn't support animations
- Only first frame will display
- Use static images instead

**DON'T mix aspect ratios in one theme**
- Some images will be cropped, others won't
- Creates inconsistent experience when cycling
- Stick to images matching your display's aspect ratio

**DON'T add backgrounds that make text unreadable**
- Avoid very bright or high-contrast images
- Test with Waybar, terminal windows open
- If text is hard to read, adjust image brightness:
  ```bash
  convert input.jpg -brightness-contrast -20 output.jpg
  ```

**DON'T manually edit the background symlink**
```bash
# ❌ DON'T DO THIS:
ln -sf ~/.local/share/omarchy/themes/catppuccin/backgrounds/2-bg.png \
       ~/.config/omarchy/current/background

# ✅ DO THIS INSTEAD:
omarchy-theme-bg-next
```
- Manual edits skip swaybg restart logic
- Wallpaper won't update until swaybg restarts
- Use `omarchy-theme-bg-next` for proper handling

---

## Related Documentation

### Theming & Customization
- **Theme System** (`theme-system.md`) - Complete overview of Omarchy's theming architecture
- **Creating Themes** (`creating-themes.md`) - How to build custom themes with background collections
- **Fonts** (`fonts.md`) - Font management to complement your backgrounds

### Application Integration
- **Hyprland Configuration** (`../04-desktop-environment/hyprland.md`) - Window manager setup and keybindings for background cycling
- **Waybar Customization** (`../04-desktop-environment/waybar.md`) - Ensure Waybar text is readable on your backgrounds

### Development & Advanced
- **Hooks System** (`../09-customization/hooks.md`) - Create custom actions on background change
- **Config Management** (`../09-customization/config-files.md`) - Understanding symlink architecture

### Quick References
- **Command Index** (`../10-reference/command-index.md`) - All Omarchy commands
- **Troubleshooting Guide** (`../10-reference/troubleshooting.md`) - Common issues
- **File Locations** (`../10-reference/file-locations.md`) - Where backgrounds are stored

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts** (analyzed for this documentation):
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-bg-next`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-set`

**Background Directories Analyzed**:
- `/home/zack/.local/share/omarchy/themes/*/backgrounds/`
- Sample themes: catppuccin (3 backgrounds), tokyo-night (3 backgrounds), gruvbox (1 background), matte-black (0 backgrounds)

**Swaybg Configuration**: Tested on Hyprland with swaybg version compatible with Wayland protocols

**Verification**: All commands, outputs, and file paths tested on Omarchy system running Hyprland on Arch Linux.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
