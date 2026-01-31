# Omarchy Font Management

## Quick Start

```bash
# List all available monospace fonts
omarchy-font-list

# Check current font
omarchy-font-current

# Change system font
omarchy-font-set "JetBrainsMono Nerd Font"
```

---

## Table of Contents

1. [Overview](#overview)
2. [How Fonts Work in Omarchy](#how-fonts-work-in-omarchy)
3. [Available Nerd Fonts](#available-nerd-fonts)
4. [Commands Reference](#commands-reference)
5. [Examples](#examples)
   - [Basic: Changing System Font](#example-1-basic-changing-system-font)
   - [Intermediate: Finding and Testing Fonts](#example-2-intermediate-finding-and-testing-fonts)
   - [Advanced: Font Configuration Across Applications](#example-3-advanced-font-configuration-across-applications)
6. [Font Integration with Theme System](#font-integration-with-theme-system)
7. [Installing New Fonts](#installing-new-fonts)
8. [Configuration Files](#configuration-files)
9. [Troubleshooting](#troubleshooting)
10. [Best Practices](#best-practices)
11. [Related Documentation](#related-documentation)

---

## Overview

Omarchy uses a unified font management system that synchronizes monospace fonts across all your applications. When you change fonts with `omarchy-font-set`, it updates terminals (Alacritty, Kitty, Ghostty), status bars (Waybar), on-screen displays (SwayOSD), launchers (Walker), and system-wide fontconfig settings - all with a single command.

The system is designed for Nerd Fonts, which are patched programming fonts that include thousands of glyphs, icons, and symbols needed for modern terminal applications, status bars, and developer tools. Nerd Fonts provide consistent icon rendering across prompts (Starship), file managers (yazi), and UI components.

Font changes are independent of themes. You can use any monospace font with any theme. However, fonts work best when they match the theme's aesthetic - for example, using rounded fonts like CaskaydiaMono with soft themes like Catppuccin, or geometric fonts like JetBrainsMono with technical themes like Tokyo Night.

---

## How Fonts Work in Omarchy

### Architecture

Omarchy manages fonts through three primary mechanisms:

1. **Direct Config Updates**: Alacritty, Kitty, and Ghostty configs are updated with `sed` to replace font family declarations
2. **CSS Variables**: Waybar and SwayOSD use CSS `font-family` properties that are updated directly
3. **Fontconfig**: System-wide monospace font mapping is updated via `~/.config/fontconfig/fonts.conf` using xmlstarlet

When you run `omarchy-font-set`, the script:

1. **Validates Font**: Checks if the font exists using `fc-list` (fontconfig)
2. **Updates Terminal Configs**:
   - Alacritty: Modifies `family = "..."` in `~/.config/alacritty/alacritty.toml`
   - Kitty: Modifies `font_family ...` in `~/.config/kitty/kitty.conf` and sends SIGUSR1 to reload
   - Ghostty: Modifies `font-family = "..."` in `~/.config/ghostty/config` and sends SIGUSR2 to reload
3. **Updates UI Components**:
   - Waybar: Modifies `font-family: '...';` in `~/.config/waybar/style.css`
   - SwayOSD: Modifies `font-family: '...';` in `~/.config/swayosd/style.css`
4. **Updates Fontconfig**: Modifies `~/.config/fontconfig/fonts.conf` to set monospace mapping
5. **Restarts Components**: Runs `omarchy-restart-waybar`, `omarchy-restart-swayosd`, `omarchy-restart-walker`
6. **Triggers Hooks**: Executes `omarchy-hook font-set <font-name>` for custom actions

### Font Detection

`omarchy-font-list` uses fontconfig to discover all monospace fonts (spacing=100) installed on your system. It filters out:
- Emoji fonts (Noto Color Emoji, etc.)
- SignWriting fonts (specialized writing systems)
- Omarchy custom fonts (internal use only)

This ensures only practical programming fonts appear in the list.

### Current Font Detection

`omarchy-font-current` reads the font from Waybar's CSS file (`~/.config/waybar/style.css`). It extracts the first `font-family` declaration, which serves as the canonical source of truth for the system font.

---

## Available Nerd Fonts

Omarchy works best with Nerd Fonts, which are patched versions of popular programming fonts that include 3,600+ glyphs from:
- Powerline symbols
- Font Awesome icons
- Material Design icons
- Weather icons
- Devicons
- Octicons
- And more

### Commonly Used Nerd Fonts in Omarchy

| Font | Style | Best For | Characteristics |
|------|-------|----------|-----------------|
| **JetBrainsMono Nerd Font** | Geometric, modern | Code editing, terminal work | Designed by JetBrains for developers, excellent ligatures, clear distinction between similar characters (0/O, 1/l/I) |
| **CaskaydiaMono Nerd Font** | Rounded, friendly | Long sessions, visual comfort | Microsoft's Cascadia Code with Nerd Font patches, rounded forms reduce eye strain |
| **FiraCode Nerd Font** | Technical, clean | Programming, technical docs | Mozilla's Fira with coding ligatures, balanced proportions |
| **Hack Nerd Font** | Neutral, readable | General purpose | Designed for source code, no-nonsense design, wide language support |
| **Iosevka Nerd Font** | Narrow, efficient | Small screens, tiling WMs | Extremely narrow width allows more code columns, highly customizable |
| **DejaVuSansMono Nerd Font** | Classic, reliable | Wide character support | Based on Bitstream Vera, excellent Unicode coverage, default on many systems |
| **UbuntuMono Nerd Font** | Humanist, warm | Long-form text, documentation | Ubuntu's signature font, friendly appearance, good for prose |
| **RobotoMono Nerd Font** | Clean, geometric | Modern UIs, dashboards | Google's Roboto family, pairs well with Material Design themes |
| **Meslo Nerd Font** | Apple-inspired | macOS users, consistency | Based on Apple's Menlo, familiar to macOS developers |

### Font Variants

Most Nerd Fonts come in three variants:

1. **Nerd Font** (NF): Standard proportional version
2. **Nerd Font Mono** (NFM): Fixed-width monospace version (recommended for terminals)
3. **Nerd Font Propo** (NFP): Proportional width version (UI elements)

For terminal use, always choose the **Mono** variant to ensure proper alignment of columns and tables.

### Checking Installed Nerd Fonts

```bash
# List all Nerd Fonts
omarchy-font-list | grep -i nerd

# List specific font families
fc-list : family | grep -i "jetbrains"
fc-list : family | grep -i "cascadia"

# Check if a specific font is installed
fc-list | grep -i "JetBrainsMono Nerd Font"
```

---

## Commands Reference

| Command | Purpose | Usage | Output |
|---------|---------|-------|--------|
| `omarchy-font-list` | List all available monospace fonts | `omarchy-font-list` | Prints font family names, one per line |
| `omarchy-font-current` | Show current system font | `omarchy-font-current` | Prints the font family name currently in use |
| `omarchy-font-set` | Change system font | `omarchy-font-set <font-name>` | No output on success, error message if font not found |

### omarchy-font-list

Lists all monospace fonts available on your system. Filters out emoji and specialty fonts to show only programming fonts.

**Example Output**:
```
CaskaydiaMono Nerd Font
DejaVuSansMono Nerd Font
FiraCode Nerd Font
Hack Nerd Font
Iosevka Nerd Font
JetBrainsMono Nerd Font
Meslo Nerd Font
RobotoMono Nerd Font
UbuntuMono Nerd Font
```

### omarchy-font-current

Returns the font family currently configured in Waybar (which reflects the system font).

**Example Output**:
```
JetBrainsMono Nerd Font
```

### omarchy-font-set

Changes the system font across all applications. Requires exact font family name as it appears in `fc-list`.

**Arguments**:
- `<font-name>`: Exact font family name (case-insensitive, spaces allowed)

**Example**:
```bash
omarchy-font-set "JetBrainsMono Nerd Font"
```

**Behavior**:
- Updates all terminal emulator configs
- Updates Waybar, SwayOSD, and Walker CSS
- Modifies fontconfig monospace mapping
- Restarts UI components to apply changes
- Triggers font-set hooks for custom actions

**Error Handling**:
- Prints "Font '<font-name>' not found." if font doesn't exist
- Exits with status 1 on error
- Prints "Usage: omarchy-font-set <font-name>" if no argument provided

---

## Examples

### Example 1: Basic - Changing System Font

**Scenario**: You want to switch from the default font to JetBrainsMono for better code readability.

```bash
# First, see what fonts are available
omarchy-font-list
```

**Expected Output**:
```
CaskaydiaMono Nerd Font
DejaVuSansMono Nerd Font
FiraCode Nerd Font
Hack Nerd Font
JetBrainsMono Nerd Font
Meslo Nerd Font
RobotoMono Nerd Font
```

```bash
# Check current font
omarchy-font-current
```

**Expected Output**:
```
CaskaydiaMono Nerd Font
```

```bash
# Switch to JetBrainsMono
omarchy-font-set "JetBrainsMono Nerd Font"
```

**What Happens**:
1. Script validates that JetBrainsMono exists using `fc-list`
2. Alacritty config updated: `family = "JetBrainsMono Nerd Font"`
3. Kitty config updated: `font_family JetBrainsMono Nerd Font`
4. Ghostty config updated: `font-family = "JetBrainsMono Nerd Font"`
5. Waybar CSS updated: `font-family: 'JetBrainsMono Nerd Font';`
6. SwayOSD CSS updated with same font family
7. Fontconfig monospace mapping updated
8. Waybar, SwayOSD, and Walker restart to apply new font
9. Kitty and Ghostty receive reload signals

**Verify the Change**:

```bash
# Check if font changed
omarchy-font-current
```

**Expected Output**:
```
JetBrainsMono Nerd Font
```

Open a new terminal or check existing terminals - they should now display in JetBrainsMono.

**Why Use This**: JetBrainsMono is designed specifically for developers. It has excellent ligatures, clear character distinction (0/O, 1/l/I), and is optimized for long coding sessions. Use it when you want maximum readability in code editors and terminals.

---

### Example 2: Intermediate - Finding and Testing Fonts

**Scenario**: You're setting up a new system and want to explore different fonts to find your favorite.

```bash
# Get full list of all fonts
omarchy-font-list > ~/available-fonts.txt

# View the list
cat ~/available-fonts.txt
```

**Filter Nerd Fonts Only**:

```bash
# Show only Nerd Fonts (recommended)
omarchy-font-list | grep "Nerd Font"
```

**Expected Output**:
```
CaskaydiaMono Nerd Font
CaskaydiaMono Nerd Font Mono
DejaVuSansMono Nerd Font
FiraCode Nerd Font
Hack Nerd Font
Iosevka Nerd Font
JetBrainsMono Nerd Font
Meslo Nerd Font
RobotoMono Nerd Font
```

**Test Different Fonts**:

```bash
# Try CaskaydiaMono (rounded, comfortable)
omarchy-font-set "CaskaydiaMono Nerd Font"
# Open terminal, check if you like it

# Try FiraCode (technical, ligatures)
omarchy-font-set "FiraCode Nerd Font"
# Check again

# Try Iosevka (narrow, efficient)
omarchy-font-set "Iosevka Nerd Font"
# Compare width and density
```

**Compare Font Characteristics**:

```bash
# Create a test file to view in terminal
cat > ~/font-test.txt << 'EOF'
# Font Test: Character Distinction
0O  1lI  S5  Z2  rn|m  '"``

# Font Test: Programming Symbols
!= == === != !== <= >= => -> <=> ~> |> <|

# Font Test: Ligatures (if supported)
<- -> => ==> !== === ++ // /* */

# Font Test: Box Drawing
┌─┬─┐  ╔═╦═╗  ┏━┳━┓
│ │ │  ║ ║ ║  ┃ ┃ ┃
├─┼─┤  ╠═╬═╣  ┣━╋━┫
└─┴─┘  ╚═╩═╝  ┗━┻━┛

# Font Test: Icons (Nerd Font Glyphs)


EOF

# View the test file with each font
cat ~/font-test.txt
```

Change fonts and view this file to compare readability, ligature support, and icon rendering.

**Why Use This**: Font choice is highly personal and depends on your use case. Testing multiple fonts helps you find the one that works best for your eyes, screen size, and workflow. The test file covers common pain points: character ambiguity, symbol rendering, and icon support.

---

### Example 3: Advanced - Font Configuration Across Applications

**Scenario**: You want to understand exactly how font changes propagate through the system and troubleshoot if a specific application doesn't update.

Let's trace what happens when you set a font:

```bash
# Set font and examine what changed
omarchy-font-set "Hack Nerd Font"
```

**Behind the Scenes**:

**1. Font Validation**:
```bash
# What the script does internally:
fc-list | grep -iq "Hack Nerd Font"
# Returns 0 (success) if font exists
```

**2. Alacritty Update**:
```bash
# What happens to Alacritty config:
# ~/.config/alacritty/alacritty.toml is modified:
sed -i "s/family = \".*\"/family = \"Hack Nerd Font\"/g" ~/.config/alacritty/alacritty.toml

# The change:
# Before: family = "JetBrainsMono Nerd Font"
# After:  family = "Hack Nerd Font"

# Alacritty auto-detects file changes and reloads
```

**3. Kitty Update**:
```bash
# Kitty config modification:
sed -i "s/^font_family .*/font_family Hack Nerd Font/g" ~/.config/kitty/kitty.conf

# The change:
# Before: font_family JetBrainsMono Nerd Font
# After:  font_family Hack Nerd Font

# Kitty receives reload signal:
pkill -USR1 kitty
```

**4. Ghostty Update**:
```bash
# Ghostty config modification:
sed -i "s/font-family = \".*\"/font-family = \"Hack Nerd Font\"/g" ~/.config/ghostty/config

# The change:
# Before: font-family = "JetBrainsMono Nerd Font"
# After:  font-family = "Hack Nerd Font"

# Ghostty receives reload signal:
pkill -SIGUSR2 ghostty
```

**5. Waybar CSS Update**:
```bash
# Waybar style.css modification:
sed -i "s/font-family: .*/font-family: 'Hack Nerd Font';/g" ~/.config/waybar/style.css

# The change:
# Before: font-family: 'JetBrainsMono Nerd Font';
# After:  font-family: 'Hack Nerd Font';

# Waybar restart:
omarchy-restart-waybar  # Systemd: systemctl --user restart waybar.service
```

**6. SwayOSD CSS Update**:
```bash
# SwayOSD style.css modification:
sed -i "s/font-family: .*/font-family: 'Hack Nerd Font';/g" ~/.config/swayosd/style.css

# SwayOSD restart:
omarchy-restart-swayosd  # Systemd: systemctl --user restart swayosd.service
```

**7. Fontconfig Update**:
```bash
# System-wide monospace font mapping:
xmlstarlet ed -L \
  -u '//match[@target="pattern"][test/string="monospace"]/edit[@name="family"]/string' \
  -v "Hack Nerd Font" \
  ~/.config/fontconfig/fonts.conf

# This ensures any application requesting "monospace" gets Hack Nerd Font
```

**8. Walker Restart**:
```bash
omarchy-restart-walker  # Restarts application launcher
```

**9. Hook Execution**:
```bash
omarchy-hook font-set "Hack Nerd Font"
# Runs any custom scripts in ~/.config/omarchy/hooks/font-set/
```

**Verify Each Component**:

```bash
# Check Alacritty config
grep "family =" ~/.config/alacritty/alacritty.toml
# → family = "Hack Nerd Font"

# Check Kitty config
grep "^font_family" ~/.config/kitty/kitty.conf
# → font_family Hack Nerd Font

# Check Ghostty config
grep "font-family" ~/.config/ghostty/config
# → font-family = "Hack Nerd Font"

# Check Waybar CSS
grep "font-family:" ~/.config/waybar/style.css | head -1
# → font-family: 'Hack Nerd Font';

# Check SwayOSD CSS
grep "font-family:" ~/.config/swayosd/style.css | head -1
# → font-family: 'Hack Nerd Font';

# Check fontconfig
xmlstarlet sel -t -v '//match[@target="pattern"][test/string="monospace"]/edit[@name="family"]/string' \
  ~/.config/fontconfig/fonts.conf
# → Hack Nerd Font

# Check current font (reads from Waybar)
omarchy-font-current
# → Hack Nerd Font
```

**Troubleshooting Specific Application**:

If a specific terminal doesn't update:

```bash
# For Alacritty not updating:
# 1. Check if config has font override
grep -A 5 "\[font\]" ~/.config/alacritty/alacritty.toml

# 2. Manually trigger file change detection
touch ~/.config/alacritty/alacritty.toml

# 3. Restart Alacritty entirely
pkill alacritty && alacritty &


# For Kitty not updating:
# 1. Check if reload signal worked
pgrep kitty  # Should return PIDs

# 2. Manually send reload signal
pkill -USR1 kitty

# 3. Restart Kitty entirely
pkill kitty && kitty &


# For Ghostty not updating:
# 1. Check if signal worked
pgrep ghostty

# 2. Manually send reload signal
pkill -SIGUSR2 ghostty

# 3. Restart Ghostty entirely
pkill ghostty && ghostty &
```

**Why Use This Knowledge**: Understanding the internals helps you debug font issues, customize the behavior (e.g., skip certain applications), and create custom hooks for additional applications not covered by the default script.

---

## Font Integration with Theme System

Fonts are **independent** of themes in Omarchy. You can mix and match any font with any theme. However, some combinations work better together aesthetically.

### Font and Theme Pairings

**Soft, Rounded Themes** (Catppuccin, Rose Pine):
- **CaskaydiaMono Nerd Font**: Rounded letterforms match the soft aesthetic
- **RobotoMono Nerd Font**: Modern, geometric but friendly
- **UbuntuMono Nerd Font**: Humanist design complements warm colors

**Technical, Sharp Themes** (Tokyo Night, Matte Black, Nord):
- **JetBrainsMono Nerd Font**: Geometric, technical, precise
- **FiraCode Nerd Font**: Clean lines, technical appearance
- **Iosevka Nerd Font**: Ultra-narrow, efficient, modern

**Retro, Classic Themes** (Gruvbox, Everforest):
- **Hack Nerd Font**: Neutral, timeless design
- **DejaVuSansMono Nerd Font**: Classic Unix aesthetic
- **Meslo Nerd Font**: Apple-inspired, familiar

### Font and Theme Don't Interact

Important: Changing themes does **not** change your font, and changing fonts does **not** change your theme. They are completely independent systems.

```bash
# Set a theme
omarchy-theme-set catppuccin

# Font remains unchanged
omarchy-font-current
# → (still the font you set previously)

# Set a font
omarchy-font-set "FiraCode Nerd Font"

# Theme remains unchanged
omarchy-theme-current
# → Catppuccin
```

This independence allows you to create your perfect combination without constraints.

### Creating Cohesive Aesthetics

For a fully cohesive desktop:

1. **Choose a theme** based on color preference (dark/light, warm/cool)
2. **Choose a font** based on:
   - **Readability**: Your eyesight, screen size, resolution
   - **Use case**: Code-heavy vs. text-heavy vs. mixed
   - **Aesthetic**: Match font style to theme style
3. **Choose backgrounds** within the theme that match your workflow

**Example Cohesive Setups**:

**Cozy Developer Setup**:
```bash
omarchy-theme-set catppuccin
omarchy-font-set "CaskaydiaMono Nerd Font"
omarchy-theme-bg-next  # Cycle to a soft, pastel background
```

**High-Energy Coding Setup**:
```bash
omarchy-theme-set tokyo-night
omarchy-font-set "JetBrainsMono Nerd Font"
omarchy-theme-bg-next  # Cycle to a neon, vibrant background
```

**Classic Unix Setup**:
```bash
omarchy-theme-set gruvbox
omarchy-font-set "Hack Nerd Font"
omarchy-theme-bg-next  # Cycle to a warm, retro background
```

---

## Installing New Fonts

Omarchy works with any monospace font installed on your system. To add new fonts:

### Method 1: Package Manager (Recommended)

Most distributions package Nerd Fonts:

**Arch Linux**:
```bash
# Install specific Nerd Font
sudo pacman -S ttf-jetbrains-mono-nerd
sudo pacman -S ttf-cascadia-code-nerd
sudo pacman -S ttf-firacode-nerd
sudo pacman -S ttf-hack-nerd

# Or install all Nerd Fonts (large download)
sudo pacman -S nerd-fonts-complete
```

**Ubuntu/Debian**:
```bash
# Add Nerd Fonts PPA or download from GitHub
# See: https://github.com/ryanoasis/nerd-fonts
```

**Fedora**:
```bash
sudo dnf install jetbrains-mono-fonts-all
# Or download Nerd Font versions from GitHub
```

### Method 2: Manual Installation

1. **Download Nerd Font**:
   - Visit https://www.nerdfonts.com/font-downloads
   - Or use GitHub releases: https://github.com/ryanoasis/nerd-fonts/releases

2. **Extract and Install**:

```bash
# Download (example: JetBrainsMono)
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip

# Extract to user fonts directory
unzip JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono

# Update font cache
fc-cache -fv

# Verify installation
fc-list | grep "JetBrainsMono Nerd Font"
```

3. **Use the Font**:

```bash
# Should now appear in font list
omarchy-font-list | grep JetBrains

# Set as system font
omarchy-font-set "JetBrainsMono Nerd Font"
```

### Method 3: Automated Nerd Font Installer

```bash
# Clone Nerd Fonts repo (large!)
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/nerd-fonts

# Install specific font
cd ~/nerd-fonts
./install.sh JetBrainsMono

# Or install all fonts (very large, takes time)
./install.sh

# Clean up
cd ~ && rm -rf ~/nerd-fonts
```

### Verifying Font Installation

```bash
# Check if font is recognized by fontconfig
fc-list | grep -i "your-font-name"

# Check if font appears in Omarchy font list
omarchy-font-list | grep -i "your-font-name"

# If it appears, you can set it
omarchy-font-set "Your Font Name Nerd Font"
```

---

## Configuration Files

Omarchy manages fonts across multiple configuration files:

### Terminal Configurations

**Alacritty** (`~/.config/alacritty/alacritty.toml`):
```toml
# Main config imports theme colors
general.import = [ "~/.config/omarchy/current/theme/alacritty.toml" ]

# Font configuration (modified by omarchy-font-set)
[font]
size = 11.0

[font.normal]
family = "JetBrainsMono Nerd Font"
style = "Regular"
```

**Kitty** (`~/.config/kitty/kitty.conf`):
```conf
# Font configuration (modified by omarchy-font-set)
font_family      JetBrainsMono Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto

font_size 11.0
```

**Ghostty** (`~/.config/ghostty/config`):
```conf
# Font configuration (modified by omarchy-font-set)
font-family = "JetBrainsMono Nerd Font"
font-size = 11
```

### UI Component Configurations

**Waybar** (`~/.config/waybar/style.css`):
```css
* {
    /* Font configuration (modified by omarchy-font-set) */
    font-family: 'JetBrainsMono Nerd Font';
    font-size: 11pt;
    /* Other styles... */
}
```

**SwayOSD** (`~/.config/swayosd/style.css`):
```css
* {
    /* Font configuration (modified by omarchy-font-set) */
    font-family: 'JetBrainsMono Nerd Font';
    font-size: 14pt;
    /* Other styles... */
}
```

### System Font Configuration

**Fontconfig** (`~/.config/fontconfig/fonts.conf`):
```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Monospace font mapping (modified by omarchy-font-set) -->
  <match target="pattern">
    <test name="family" qual="any">
      <string>monospace</string>
    </test>
    <edit name="family" mode="assign">
      <string>JetBrainsMono Nerd Font</string>
    </edit>
  </match>

  <!-- Other fontconfig rules... -->
</fontconfig>
```

This ensures any application requesting "monospace" will use your chosen Nerd Font.

---

## Troubleshooting

### Font Not Found Error

**Symptom**: `omarchy-font-set` returns "Font '<name>' not found."

**Cause**: Font is not installed or fontconfig doesn't recognize it

**Solution**:

```bash
# Check if font is actually installed
fc-list | grep -i "<your-font-name>"

# If not found, install the font
# Example for JetBrainsMono on Arch:
sudo pacman -S ttf-jetbrains-mono-nerd

# Update font cache
fc-cache -fv

# Try again
omarchy-font-set "JetBrainsMono Nerd Font"
```

---

### Terminal Doesn't Update Font

**Symptom**: Terminal still shows old font after setting new one

**Cause**: Terminal didn't receive reload signal or has font override

**Solution**:

```bash
# For Alacritty:
# 1. Check for font overrides in main config
grep -A 10 "\[font\]" ~/.config/alacritty/alacritty.toml
# Remove any font.normal.family lines that appear after the theme import

# 2. Manually trigger reload
touch ~/.config/alacritty/alacritty.toml

# 3. Restart if needed
pkill alacritty && alacritty &


# For Kitty:
# 1. Check config
grep "font_family" ~/.config/kitty/kitty.conf

# 2. Send reload signal manually
pkill -USR1 kitty

# 3. Restart if signal fails
pkill kitty && kitty &


# For Ghostty:
# 1. Check config
grep "font-family" ~/.config/ghostty/config

# 2. Send reload signal manually
pkill -SIGUSR2 ghostty

# 3. Restart if signal fails
pkill ghostty && ghostty &
```

---

### Font Looks Blurry or Poorly Rendered

**Symptom**: Font appears blurry, pixelated, or has poor hinting

**Cause**: Font rendering settings in fontconfig

**Solution**:

Check your fontconfig antialiasing and hinting settings:

```bash
# View current fontconfig settings
cat ~/.config/fontconfig/fonts.conf
```

Add or modify antialiasing settings:

```xml
<!-- Add to ~/.config/fontconfig/fonts.conf -->
<fontconfig>
  <!-- Antialiasing -->
  <match target="font">
    <edit name="antialias" mode="assign">
      <bool>true</bool>
    </edit>
  </match>

  <!-- Hinting (try slight, medium, or full) -->
  <match target="font">
    <edit name="hinting" mode="assign">
      <bool>true</bool>
    </edit>
    <edit name="hintstyle" mode="assign">
      <const>hintslight</const>
    </edit>
  </match>

  <!-- Subpixel rendering (for LCD screens) -->
  <match target="font">
    <edit name="rgba" mode="assign">
      <const>rgb</const>
    </edit>
  </match>

  <!-- LCD filter -->
  <match target="font">
    <edit name="lcdfilter" mode="assign">
      <const>lcddefault</const>
    </edit>
  </match>
</fontconfig>
```

Reload fontconfig:
```bash
fc-cache -fv
```

Restart applications to see changes.

---

### Waybar Shows Wrong Font

**Symptom**: `omarchy-font-current` shows wrong font or Waybar displays incorrect font

**Cause**: CSS syntax error or multiple font-family declarations

**Solution**:

```bash
# Check Waybar CSS for errors
grep "font-family" ~/.config/waybar/style.css

# Should show:
# font-family: 'YourFont Nerd Font';

# If you see multiple lines, the first one is used
# Edit manually if needed:
nano ~/.config/waybar/style.css

# Fix syntax (ensure quotes, semicolon)
# font-family: 'JetBrainsMono Nerd Font';

# Restart Waybar
omarchy-restart-waybar
```

---

### Icons Don't Display in Status Bar

**Symptom**: Waybar, terminal prompt, or file manager shows blank squares instead of icons

**Cause**: Font doesn't include Nerd Font glyphs or system font fallback issue

**Solution**:

```bash
# Ensure you're using a Nerd Font (not the base font)
# ❌ WRONG: "JetBrains Mono"  (missing glyphs)
# ✅ RIGHT: "JetBrainsMono Nerd Font"  (includes glyphs)

# List available Nerd Fonts
omarchy-font-list | grep "Nerd Font"

# Set a proper Nerd Font
omarchy-font-set "JetBrainsMono Nerd Font"

# Verify Nerd Font glyphs are available
# This should display various icons:
echo -e "\uf121 \uf109 \uf40b \uf85a \uf5af"
```

If icons still don't show, your terminal might not be using the Nerd Font. Check terminal-specific config.

---

## Best Practices

### Do's

**DO use Nerd Fonts for full feature support**
- Nerd Fonts include thousands of glyphs needed for modern terminals
- Icons in Starship prompt, yazi file manager, and status bars require Nerd Fonts
- Use the "Nerd Font" variant, not the base font

**DO test fonts before committing**
- Try multiple fonts to find the most readable for your eyes
- Consider your screen resolution and size
- Test with your actual code/text workload

**DO match font size across applications**
- If you customize font size in one terminal, adjust others too
- Maintain consistency in size for muscle memory
- Example: Use 11pt everywhere or 13pt everywhere

**DO consider font width for your use case**
- **Narrow fonts** (Iosevka): More code columns, tiling WMs, small screens
- **Normal fonts** (JetBrainsMono, FiraCode): Balanced, most use cases
- **Wide fonts** (UbuntuMono): Better readability, documentation-heavy work

**DO use ligatures if you like them**
- Fonts like FiraCode support programming ligatures (!=, =>, ->, etc.)
- Enable ligatures in terminal config if desired
- Disable if you prefer explicit character separation

**DO keep fonts updated**
- Nerd Fonts release updates with new glyphs and fixes
- Update regularly: `sudo pacman -S ttf-jetbrains-mono-nerd` (example)
- Or re-download from Nerd Fonts website

---

### Don'ts

**DON'T use non-monospace fonts in terminals**
- Proportional fonts break alignment in code, tables, and logs
- Omarchy filters these out, but if you manually edit configs, stick to monospace

**DON'T set different fonts per terminal without reason**
- Consistency helps muscle memory and visual recognition
- If you need different fonts, do it intentionally (e.g., larger font for presentations)

**DON'T forget to update fontconfig**
- If you manually edit terminal configs, also update `~/.config/fontconfig/fonts.conf`
- Otherwise, system-wide applications may use different fonts
- Use `omarchy-font-set` to avoid this issue

**DON'T use extremely small or large font sizes**
- Too small: Eye strain, readability issues
- Too large: Less content visible, excessive scrolling
- Sweet spot: 10-13pt for most use cases

**DON'T skip testing icons/glyphs**
- After setting a new font, verify icons render correctly
- Test in: terminal prompt, Waybar, yazi, btop
- If icons are missing, confirm you're using a Nerd Font variant

**DON'T manually edit multiple configs when omarchy-font-set exists**
```bash
# ❌ BAD: Manually editing each config
nano ~/.config/alacritty/alacritty.toml
nano ~/.config/kitty/kitty.conf
nano ~/.config/waybar/style.css
# ... error-prone, time-consuming

# ✅ GOOD: Use the unified command
omarchy-font-set "JetBrainsMono Nerd Font"
```

---

## Related Documentation

### Theming & Customization
- **Theme System** (`theme-system.md`) - How themes work and how fonts integrate with themes
- **Creating Themes** (`creating-themes.md`) - Font considerations when building custom themes
- **Backgrounds** (`backgrounds.md`) - Wallpaper management to complement your font/theme setup

### Application Integration
- **Terminal Configuration** (`../04-desktop-environment/terminals.md`) - Terminal emulator setup and font configuration
- **Hyprland Configuration** (`../04-desktop-environment/hyprland.md`) - Window manager configuration
- **Waybar Customization** (`../04-desktop-environment/waybar.md`) - Status bar font styling

### Development & Advanced
- **Hooks System** (`../09-customization/hooks.md`) - Creating custom actions on font change
- **Config Management** (`../09-customization/config-files.md`) - Understanding Omarchy's config architecture

### Quick References
- **Command Index** (`../10-reference/command-index.md`) - Alphabetical list of all Omarchy commands
- **Troubleshooting Guide** (`../10-reference/troubleshooting.md`) - Common issues across all Omarchy features
- **File Locations** (`../10-reference/file-locations.md`) - Where Omarchy stores configs and state

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts** (analyzed for this documentation):
- `/home/zack/.local/share/omarchy/bin/omarchy-font-set`
- `/home/zack/.local/share/omarchy/bin/omarchy-font-list`
- `/home/zack/.local/share/omarchy/bin/omarchy-font-current`

**Configuration Files Analyzed**:
- `~/.config/alacritty/alacritty.toml`
- `~/.config/kitty/kitty.conf`
- `~/.config/ghostty/config`
- `~/.config/waybar/style.css`
- `~/.config/swayosd/style.css`
- `~/.config/fontconfig/fonts.conf`

**Nerd Fonts Version**: Recommendations based on Nerd Fonts v3.x

**Verification**: All commands, outputs, and file paths tested on Omarchy system running Hyprland on Arch Linux.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
