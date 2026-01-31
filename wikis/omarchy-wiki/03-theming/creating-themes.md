# Creating Custom Themes for Omarchy

## Quick Start

```bash
# Create a new theme from scratch
mkdir -p ~/.local/share/omarchy/themes/my-theme/backgrounds

# Copy an existing theme as a template
cp -r ~/.local/share/omarchy/themes/catppuccin ~/.local/share/omarchy/themes/my-theme

# Install a theme from git
omarchy-theme-install https://github.com/user/omarchy-theme-example

# Remove a theme
omarchy-theme-remove my-theme
```

---

## Table of Contents

1. [Overview](#overview)
2. [Theme Directory Structure](#theme-directory-structure)
3. [Required vs Optional Files](#required-vs-optional-files)
4. [Theme File Formats](#theme-file-formats)
5. [Commands Reference](#commands-reference)
6. [Examples](#examples)
   - [Basic: Modifying an Existing Theme](#example-1-basic-modifying-an-existing-theme)
   - [Intermediate: Creating a Theme from Scratch](#example-2-intermediate-creating-a-theme-from-scratch)
   - [Advanced: Creating a Complete Theme Package](#example-3-advanced-creating-a-complete-theme-package)
7. [Publishing Themes](#publishing-themes)
8. [Theme File Reference](#theme-file-reference)
9. [Troubleshooting](#troubleshooting)
10. [Best Practices](#best-practices)
11. [Related Documentation](#related-documentation)

---

## Overview

Creating custom themes for Omarchy allows you to define cohesive color schemes across your entire desktop environment. A single theme controls the appearance of terminals, window managers, text editors, browsers, status bars, and more - providing a unified visual experience.

Themes in Omarchy are comprehensive configuration packages stored in `~/.local/share/omarchy/themes/`. Each theme is a directory containing configuration files for different applications. When you set a theme, Omarchy reads these files and applies them across all supported applications.

The theme creation process can be as simple as modifying colors in a few files or as complex as building a complete multi-application theme package from scratch. This guide covers both approaches, with practical examples and detailed file format specifications.

---

## Theme Directory Structure

A complete Omarchy theme has this structure:

```
~/.local/share/omarchy/themes/
└── theme-name/
    ├── backgrounds/                 # Wallpapers for this theme
    │   ├── 1-background.png
    │   ├── 2-background.jpg
    │   └── 3-background.png
    ├── alacritty.toml              # Alacritty terminal colors (TOML format)
    ├── btop.theme                   # Btop resource monitor theme
    ├── chromium.theme               # RGB color for browser theme (e.g., "28,32,39")
    ├── ghostty.conf                 # Ghostty terminal colors
    ├── hyprland.conf                # Hyprland border colors
    ├── hyprlock.conf                # Hyprlock screen locker colors
    ├── icons.theme                  # GNOME icon theme name (e.g., "Yaru-blue")
    ├── kitty.conf                   # Kitty terminal colors
    ├── light.mode                   # Presence indicates light theme (content ignored)
    ├── mako.ini                     # Mako notification daemon colors
    ├── neovim.lua                   # Neovim colorscheme command
    ├── obsidian.css                 # Optional custom Obsidian theme (overrides generated)
    ├── preview.png                  # Theme preview image (for menus/galleries)
    ├── swayosd.css                  # SwayOSD on-screen display colors
    ├── vscode.json                  # VS Code theme name + extension ID
    ├── walker.css                   # Walker launcher colors
    └── waybar.css                   # Waybar status bar color variables
```

### Minimal Theme Structure

The absolute minimum for a functional theme:

```
theme-name/
├── alacritty.toml              # Required: Base color palette
└── backgrounds/                # Optional but recommended
    └── 1-background.png
```

Many applications will fall back to defaults if their specific config files are missing.

### Complete Theme Structure

For a polished, complete theme that controls every aspect:

```
theme-name/
├── alacritty.toml              # Terminal colors
├── btop.theme                   # System monitor colors
├── chromium.theme               # Browser theme color
├── ghostty.conf                 # Ghostty terminal
├── hyprland.conf                # Window borders
├── hyprlock.conf                # Lock screen
├── icons.theme                  # System icons
├── kitty.conf                   # Kitty terminal
├── mako.ini                     # Notifications
├── neovim.lua                   # Editor colorscheme
├── preview.png                  # Theme preview
├── swayosd.css                  # Volume/brightness OSD
├── vscode.json                  # VS Code theme
├── walker.css                   # App launcher
├── waybar.css                   # Status bar
└── backgrounds/                 # Wallpapers
    ├── 1-bg.png
    ├── 2-bg.jpg
    └── 3-bg.png
```

---

## Required vs Optional Files

### Required Files

**alacritty.toml** (Essential)
- Base color palette for the theme
- Many other configs derive colors from this
- If creating from scratch, start here

### Highly Recommended Files

**hyprland.conf**
- Window border colors
- Without this, borders use Hyprland defaults
- Highly visible, strongly affects theme feel

**waybar.css**
- Status bar colors
- Very prominent on desktop
- Defines `@define-color` variables used by other components

**backgrounds/**
- At least one wallpaper
- Without backgrounds, uses solid black
- Wallpapers tie the theme together

### Optional Files (Application-Specific)

**Terminal Emulators**:
- `kitty.conf` - Only if you use Kitty
- `ghostty.conf` - Only if you use Ghostty

**Editors**:
- `vscode.json` - Only if you use VS Code or Cursor
- `neovim.lua` - Only if you use Neovim with LazyVim

**UI Components**:
- `walker.css` - Only if you use Walker launcher
- `mako.ini` - Only if you use Mako notifications
- `swayosd.css` - Only if you use SwayOSD
- `hyprlock.conf` - Only if you use Hyprlock

**Browser**:
- `chromium.theme` - Only if you use Chromium/Brave

**System**:
- `icons.theme` - Icon pack name (optional, falls back to Yaru-blue)
- `btop.theme` - Resource monitor colors (optional)

**Special**:
- `light.mode` - Only for light themes (content doesn't matter, only presence)
- `obsidian.css` - Only if you want custom Obsidian styling (auto-generated otherwise)
- `preview.png` - Only for theme galleries/pickers

---

## Theme File Formats

### alacritty.toml

**Format**: TOML (Tom's Obvious, Minimal Language)

**Purpose**: Defines terminal color palette

**Structure**:
```toml
[colors.primary]
background = "#1e1e2e"  # Main background
foreground = "#cdd6f4"  # Main text color
dim_foreground = "#7f849c"
bright_foreground = "#cdd6f4"

[colors.cursor]
text = "#1e1e2e"        # Cursor text color
cursor = "#f5e0dc"      # Cursor background

[colors.vi_mode_cursor]
text = "#1e1e2e"
cursor = "#b4befe"

[colors.search.matches]
foreground = "#1e1e2e"
background = "#a6adc8"

[colors.search.focused_match]
foreground = "#1e1e2e"
background = "#a6e3a1"

[colors.footer_bar]
foreground = "#1e1e2e"
background = "#a6adc8"

[colors.hints.start]
foreground = "#1e1e2e"
background = "#f9e2af"

[colors.hints.end]
foreground = "#1e1e2e"
background = "#a6adc8"

[colors.selection]
text = "#1e1e2e"
background = "#f5e0dc"

[colors.normal]
black = "#45475a"
red = "#f38ba8"
green = "#a6e3a1"
yellow = "#f9e2af"
blue = "#89b4fa"
magenta = "#f5c2e7"
cyan = "#94e2d5"
white = "#bac2de"

[colors.bright]
black = "#585b70"
red = "#f38ba8"
green = "#a6e3a1"
yellow = "#f9e2af"
blue = "#89b4fa"
magenta = "#f5c2e7"
cyan = "#94e2d5"
white = "#a6adc8"

[[colors.indexed_colors]]
index = 16
color = "#fab387"

[[colors.indexed_colors]]
index = 17
color = "#f5e0dc"
```

**Key Sections**:
- `colors.primary`: Main background and foreground
- `colors.normal`: Standard 16 colors (black, red, green, yellow, blue, magenta, cyan, white)
- `colors.bright`: Bright variants of the 16 colors
- `colors.cursor`, `colors.selection`: UI element colors
- `colors.indexed_colors`: Extended 256-color palette (optional)

---

### kitty.conf

**Format**: Plain text, key-value pairs

**Purpose**: Kitty terminal color scheme

**Structure**:
```conf
## name: Theme Name
## author: Your Name
## license: MIT

selection_foreground    #ebdbb2
selection_background    #d65d0e

background              #282828
foreground              #ebdbb2

color0                  #3c3836
color1                  #cc241d
color2                  #98971a
color3                  #d79921
color4                  #458588
color5                  #b16286
color6                  #689d6a
color7                  #a89984
color8                  #928374
color9                  #fb4934
color10                 #b8bb26
color11                 #fabd2f
color12                 #83a598
color13                 #d3869b
color14                 #8ec07c
color15                 #fbf1c7

cursor                  #bdae93
cursor_text_color       #665c54

url_color               #458588

active_tab_foreground   #eeeeee
active_tab_background   #d65d0e
inactive_tab_foreground #ebdbb2
inactive_tab_background #202020
```

**Key Fields**:
- `background`, `foreground`: Main colors
- `color0` through `color15`: 16 ANSI colors
- `cursor`, `selection`: UI colors
- `active_tab_*`, `inactive_tab_*`: Tab bar colors

---

### ghostty.conf

**Format**: Plain text, key-value pairs

**Purpose**: Ghostty terminal color scheme

**Structure**:
```conf
theme = Gruvbox Dark
```

Ghostty uses built-in themes by name. Alternatively, you can define colors explicitly:

```conf
background = 282828
foreground = ebdbb2

palette = 0=#3c3836
palette = 1=#cc241d
palette = 2=#98971a
palette = 3=#d79921
palette = 4=#458588
palette = 5=#b16286
palette = 6=#689d6a
palette = 7=#a89984
palette = 8=#928374
palette = 9=#fb4934
palette = 10=#b8bb26
palette = 11=#fabd2f
palette = 12=#83a598
palette = 13=#d3869b
palette = 14=#8ec07c
palette = 15=#fbf1c7
```

---

### hyprland.conf

**Format**: Hyprland configuration syntax

**Purpose**: Window border colors

**Structure**:
```conf
$activeBorderColor = rgb(a89984)

general {
    col.active_border = $activeBorderColor
}

group {
    col.border_active = $activeBorderColor
}
```

**Key Variables**:
- `$activeBorderColor`: Color of focused window borders
- `col.active_border`: Applied to main windows
- `col.border_active`: Applied to window groups

**Color Format**: `rgb(RRGGBB)` - hex values without # prefix

---

### waybar.css

**Format**: CSS with GTK color definitions

**Purpose**: Status bar colors

**Structure**:
```css
@define-color foreground #d4be98;
@define-color background #282828;
```

**Usage**: These colors are referenced by Waybar's main style.css:
```css
/* In ~/.config/waybar/style.css */
@import "~/.config/omarchy/current/theme/waybar.css";

#waybar {
    background-color: @background;
    color: @foreground;
}
```

**Minimal Example**:
```css
@define-color foreground #ffffff;
@define-color background #000000;
```

---

### vscode.json

**Format**: JSON

**Purpose**: VS Code theme name and extension ID

**Structure**:
```json
{
  "name": "Gruvbox Dark Medium",
  "extension": "jdinhlife.gruvbox"
}
```

**Fields**:
- `name`: Exact theme name as it appears in VS Code settings
- `extension`: Marketplace extension ID (format: `publisher.extension-name`)

**Finding Extension ID**:
1. Visit VS Code Marketplace: https://marketplace.visualstudio.com/vscode
2. Search for theme
3. Extension ID is in URL: `https://marketplace.visualstudio.com/items?itemName=publisher.extension-name`

---

### chromium.theme

**Format**: Plain text, single line

**Purpose**: Browser tab/toolbar theme color

**Structure**:
```
40,40,40
```

**Format**: `R,G,B` where R, G, B are integers 0-255

**Example**: `40,40,40` = very dark gray

**How to Choose**: Use the theme's main background color converted to RGB.

**Conversion**:
- Hex `#282828` → RGB `40,40,40`
- Hex `#1e1e2e` → RGB `30,30,46`

---

### icons.theme

**Format**: Plain text, single line

**Purpose**: GNOME icon theme name

**Structure**:
```
Yaru-olive
```

**Common Icon Themes**:
- `Yaru-blue` (default for dark themes)
- `Yaru-olive`, `Yaru-red`, `Yaru-purple` (Yaru color variants)
- `Adwaita` (GNOME default)
- `Papirus-Dark`, `Papirus-Light` (popular third-party)

**Check Available**:
```bash
ls /usr/share/icons/
```

---

### mako.ini

**Format**: INI configuration

**Purpose**: Notification daemon colors

**Structure**:
```ini
include=~/.local/share/omarchy/default/mako/core.ini

text-color=#d4be98
border-color=#a89984
background-color=#282828
```

**Key Fields**:
- `text-color`: Notification text color
- `border-color`: Notification border color
- `background-color`: Notification background

**Note**: `include` line loads core configuration; only colors are overridden.

---

### swayosd.css

**Format**: CSS with GTK color definitions

**Purpose**: On-screen display colors (volume, brightness indicators)

**Structure**:
```css
@define-color background-color #282828;
@define-color border-color #a89984;
@define-color label #ebdbb2;
@define-color image #ebdbb2;
@define-color progress #ebdbb2;
```

**Key Colors**:
- `background-color`: OSD background
- `border-color`: OSD border
- `label`: Text color
- `progress`: Progress bar color

---

### walker.css

**Format**: CSS with GTK color definitions

**Purpose**: Application launcher colors

**Structure**:
```css
@define-color selected-text #fabd2f;
@define-color text #ebdbb2;
@define-color base #282828;
@define-color border #ebdbb2;
@define-color foreground #ebdbb2;
@define-color background #282828;
```

**Key Colors**:
- `selected-text`: Highlighted item text
- `text`: Normal text
- `base`: Main background
- `border`: Border color

---

### neovim.lua

**Format**: Lua (Neovim LazyVim plugin config)

**Purpose**: Neovim colorscheme

**Structure**:
```lua
return {
	{ "ellisonleao/gruvbox.nvim" },
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "gruvbox",
		},
	},
}
```

**Fields**:
- First table: Plugin to install (GitHub path)
- Second table: LazyVim config with colorscheme name

**Common Colorscheme Plugins**:
- `folke/tokyonight.nvim` → colorscheme `tokyonight`
- `catppuccin/nvim` → colorscheme `catppuccin`
- `ellisonleao/gruvbox.nvim` → colorscheme `gruvbox`
- `rebelot/kanagawa.nvim` → colorscheme `kanagawa`

---

### hyprlock.conf

**Format**: Hyprland configuration syntax

**Purpose**: Lock screen colors

**Structure**:
```conf
$color = rgba(40,40,40,1.0)
$inner_color = rgba(40,40,40,0.8)
$outer_color = rgba(212,190,152,1.0)
$font_color = rgba(212,190,152,1.0)
$check_color = rgba(214, 153, 92, 1.0)
```

**Key Variables**:
- `$color`: Main lock screen background
- `$inner_color`: Inner ring color
- `$outer_color`: Outer ring color
- `$font_color`: Text color
- `$check_color`: Password check indicator

**Color Format**: `rgba(R,G,B,A)` where R, G, B are 0-255, A is 0.0-1.0

---

### btop.theme

**Format**: Plain text, key-value pairs

**Purpose**: Btop resource monitor colors

**Structure** (abbreviated):
```conf
# Colors in 6-char hex: "#RRGGBB"

theme[main_bg]="#282828"
theme[main_fg]="#a89984"
theme[title]="#ebdbb2"
theme[hi_fg]="#d79921"
theme[selected_bg]="#282828"
theme[selected_fg]="#fabd2f"

# CPU graph colors
theme[cpu_start]="#b8bb26"
theme[cpu_mid]="#d79921"
theme[cpu_end]="#fb4934"

# Memory graph colors
theme[free_start]="#4e5900"
theme[free_end]="#98971a"

# ... more fields
```

**Complete file is lengthy** (~90 lines). See existing themes for full examples.

---

### light.mode

**Format**: Plain text (content ignored)

**Purpose**: Flag to indicate light theme

**Structure**:
```
# This will set "prefer-light" and use "Adwaita" as the theme
```

**Usage**: If this file exists (even if empty), theme is treated as "light":
- GNOME theme: `Adwaita` instead of `Adwaita-dark`
- Color scheme: `prefer-light` instead of `prefer-dark`
- Browsers: Light mode instead of dark mode

**Content doesn't matter**. Only the file's presence is checked.

---

## Commands Reference

| Command | Purpose | Usage | Notes |
|---------|---------|-------|-------|
| `omarchy-theme-install` | Install theme from git repo | `omarchy-theme-install <git-url>` | Clones to `~/.local/share/omarchy/themes/` and activates |
| `omarchy-theme-remove` | Remove an installed theme | `omarchy-theme-remove [theme-name]` | Interactive prompt if no name provided |
| `omarchy-theme-update` | Update all git-based themes | `omarchy-theme-update` | Runs `git pull` in each theme directory |
| `omarchy-theme-set` | Switch to a theme | `omarchy-theme-set <theme-name>` | Tests newly created themes |

### omarchy-theme-install

Installs a theme from a git repository.

**Syntax**:
```bash
omarchy-theme-install <git-url>
```

**Example**:
```bash
omarchy-theme-install https://github.com/user/omarchy-theme-gruvbox
```

**What It Does**:
1. Prompts for git URL if not provided
2. Extracts theme name from repo name (removes `omarchy-` prefix and `-theme` suffix)
3. Removes existing theme directory if present
4. Clones repo to `~/.local/share/omarchy/themes/<theme-name>`
5. Activates theme with `omarchy-theme-set <theme-name>`

**Theme Name Extraction**:
- `https://github.com/user/omarchy-gruvbox-theme` → `gruvbox`
- `https://github.com/user/omarchy-theme-catppuccin` → `catppuccin`
- `https://github.com/user/my-custom-theme` → `my-custom`

---

### omarchy-theme-remove

Removes a theme from the system.

**Syntax**:
```bash
omarchy-theme-remove [theme-name]
```

**Interactive Mode** (no argument):
```bash
omarchy-theme-remove
# Shows menu of all themes
# Select theme to remove
```

**Direct Mode** (with argument):
```bash
omarchy-theme-remove my-theme
```

**What It Does**:
1. Finds theme directory in `~/.local/share/omarchy/themes/`
2. If theme is currently active, switches to next theme first
3. Removes theme directory

**Safety**: Cannot remove the currently active theme without switching first.

---

### omarchy-theme-update

Updates all git-based themes.

**Syntax**:
```bash
omarchy-theme-update
```

**What It Does**:
1. Scans `~/.local/share/omarchy/themes/`
2. For each directory that is a git repo, runs `git pull`
3. Updates themes with latest changes from upstream

**Use Case**: Keep installed community themes up to date.

---

## Examples

### Example 1: Basic - Modifying an Existing Theme

**Scenario**: You like Catppuccin but want slightly different colors - a bit more purple and less pink.

**Step 1: Copy the Base Theme**

```bash
# Create a copy of Catppuccin
cp -r ~/.local/share/omarchy/themes/catppuccin \
      ~/.local/share/omarchy/themes/catppuccin-purple
```

**Step 2: Modify Colors in Alacritty**

```bash
# Edit the terminal colors
nano ~/.local/share/omarchy/themes/catppuccin-purple/alacritty.toml
```

**Original Colors**:
```toml
[colors.primary]
background = "#1e1e2e"
foreground = "#cdd6f4"

[colors.normal]
magenta = "#f5c2e7"  # Pink
blue = "#89b4fa"     # Blue
```

**Your Changes** (more purple):
```toml
[colors.primary]
background = "#1e1e2e"
foreground = "#cdd6f4"

[colors.normal]
magenta = "#c59fff"  # More purple, less pink
blue = "#9d7cd8"     # Deeper purple blue
```

**Step 3: Update Waybar Colors**

```bash
nano ~/.local/share/omarchy/themes/catppuccin-purple/waybar.css
```

**Change**:
```css
@define-color foreground #c59fff;  /* Match your new purple */
@define-color background #1e1e2e;
```

**Step 4: Update Hyprland Border**

```bash
nano ~/.local/share/omarchy/themes/catppuccin-purple/hyprland.conf
```

**Change**:
```conf
$activeBorderColor = rgb(c59fff)  /* Purple border */

general {
    col.active_border = $activeBorderColor
}

group {
    col.border_active = $activeBorderColor
}
```

**Step 5: Test Your Theme**

```bash
# Activate your custom theme
omarchy-theme-set catppuccin-purple
```

**Result**: Your desktop now uses Catppuccin's structure but with your custom purple accent colors.

**Step 6: Iterate**

```bash
# If colors don't look right, edit again
nano ~/.local/share/omarchy/themes/catppuccin-purple/alacritty.toml

# Test again
omarchy-theme-set catppuccin-purple
```

**Why This Approach**:
- Quick: Only modify a few files
- Safe: Original theme is untouched
- Iterative: Easy to tweak and retest

---

### Example 2: Intermediate - Creating a Theme from Scratch

**Scenario**: You want to create a custom "Midnight Blue" theme inspired by deep ocean colors.

**Step 1: Create Theme Directory**

```bash
# Create theme structure
mkdir -p ~/.local/share/omarchy/themes/midnight-blue/backgrounds
```

**Step 2: Define Color Palette**

Plan your colors first:

**Midnight Blue Palette**:
- Background: `#0a0e27` (very dark blue)
- Foreground: `#c9d7e0` (light blue-gray)
- Accent Blue: `#4a90e2` (bright ocean blue)
- Accent Cyan: `#5dade2` (lighter ocean blue)
- Accent Green: `#45b39d` (sea green)
- Black: `#1a1d3a` (dark blue-black)
- Red: `#e74c3c` (coral red)
- Yellow: `#f39c12` (warm yellow, like sunset)
- White: `#ecf0f1` (off-white)

**Step 3: Create Alacritty Config**

```bash
nano ~/.local/share/omarchy/themes/midnight-blue/alacritty.toml
```

**Content**:
```toml
[colors.primary]
background = "#0a0e27"
foreground = "#c9d7e0"
dim_foreground = "#6c7a89"
bright_foreground = "#ecf0f1"

[colors.cursor]
text = "#0a0e27"
cursor = "#4a90e2"

[colors.vi_mode_cursor]
text = "#0a0e27"
cursor = "#5dade2"

[colors.search.matches]
foreground = "#0a0e27"
background = "#f39c12"

[colors.search.focused_match]
foreground = "#0a0e27"
background = "#45b39d"

[colors.footer_bar]
foreground = "#0a0e27"
background = "#4a90e2"

[colors.hints.start]
foreground = "#0a0e27"
background = "#f39c12"

[colors.hints.end]
foreground = "#0a0e27"
background = "#5dade2"

[colors.selection]
text = "#0a0e27"
background = "#4a90e2"

[colors.normal]
black = "#1a1d3a"
red = "#e74c3c"
green = "#45b39d"
yellow = "#f39c12"
blue = "#4a90e2"
magenta = "#9b59b6"
cyan = "#5dade2"
white = "#c9d7e0"

[colors.bright]
black = "#34495e"
red = "#ec7063"
green = "#58d68d"
yellow = "#f5b041"
blue = "#5dade2"
magenta = "#bb8fce"
cyan = "#76d7c4"
white = "#ecf0f1"

[[colors.indexed_colors]]
index = 16
color = "#e67e22"

[[colors.indexed_colors]]
index = 17
color = "#16a085"
```

**Step 4: Create Hyprland Border Config**

```bash
nano ~/.local/share/omarchy/themes/midnight-blue/hyprland.conf
```

**Content**:
```conf
$activeBorderColor = rgb(4a90e2)

general {
    col.active_border = $activeBorderColor
}

group {
    col.border_active = $activeBorderColor
}
```

**Step 5: Create Waybar Colors**

```bash
nano ~/.local/share/omarchy/themes/midnight-blue/waybar.css
```

**Content**:
```css
@define-color foreground #c9d7e0;
@define-color background #0a0e27;
```

**Step 6: Create Kitty Config**

```bash
nano ~/.local/share/omarchy/themes/midnight-blue/kitty.conf
```

**Content**:
```conf
## name: Midnight Blue
## author: Your Name
## license: MIT

background              #0a0e27
foreground              #c9d7e0

color0                  #1a1d3a
color1                  #e74c3c
color2                  #45b39d
color3                  #f39c12
color4                  #4a90e2
color5                  #9b59b6
color6                  #5dade2
color7                  #c9d7e0
color8                  #34495e
color9                  #ec7063
color10                 #58d68d
color11                 #f5b041
color12                 #5dade2
color13                 #bb8fce
color14                 #76d7c4
color15                 #ecf0f1

cursor                  #4a90e2
cursor_text_color       #0a0e27

selection_foreground    #0a0e27
selection_background    #4a90e2

url_color               #5dade2

active_tab_foreground   #ecf0f1
active_tab_background   #4a90e2
inactive_tab_foreground #c9d7e0
inactive_tab_background #1a1d3a
```

**Step 7: Add Other Config Files**

Create remaining configs (using the same color palette):

```bash
# Chromium theme (RGB of background: 10,14,39)
echo "10,14,39" > ~/.local/share/omarchy/themes/midnight-blue/chromium.theme

# Icon theme
echo "Yaru-blue" > ~/.local/share/omarchy/themes/midnight-blue/icons.theme

# Mako notifications
cat > ~/.local/share/omarchy/themes/midnight-blue/mako.ini << 'EOF'
include=~/.local/share/omarchy/default/mako/core.ini

text-color=#c9d7e0
border-color=#4a90e2
background-color=#0a0e27
EOF

# SwayOSD
cat > ~/.local/share/omarchy/themes/midnight-blue/swayosd.css << 'EOF'
@define-color background-color #0a0e27;
@define-color border-color #4a90e2;
@define-color label #c9d7e0;
@define-color image #c9d7e0;
@define-color progress #4a90e2;
EOF

# Walker
cat > ~/.local/share/omarchy/themes/midnight-blue/walker.css << 'EOF'
@define-color selected-text #5dade2;
@define-color text #c9d7e0;
@define-color base #0a0e27;
@define-color border #4a90e2;
@define-color foreground #c9d7e0;
@define-color background #0a0e27;
EOF

# VS Code (if you want to use an existing extension)
cat > ~/.local/share/omarchy/themes/midnight-blue/vscode.json << 'EOF'
{
  "name": "Tokyo Night",
  "extension": "enkia.tokyo-night"
}
EOF

# Neovim (using tokyonight as closest match)
cat > ~/.local/share/omarchy/themes/midnight-blue/neovim.lua << 'EOF'
return {
	{ "folke/tokyonight.nvim" },
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight",
		},
	},
}
EOF
```

**Step 8: Add Backgrounds**

```bash
# Download or copy ocean-themed wallpapers
cp ~/Pictures/ocean-night.jpg \
   ~/.local/share/omarchy/themes/midnight-blue/backgrounds/1-ocean-night.jpg

cp ~/Pictures/deep-blue-sea.png \
   ~/.local/share/omarchy/themes/midnight-blue/backgrounds/2-deep-blue-sea.png

cp ~/Pictures/midnight-waves.jpg \
   ~/.local/share/omarchy/themes/midnight-blue/backgrounds/3-midnight-waves.jpg
```

**Step 9: Test Your Theme**

```bash
# Activate your new theme
omarchy-theme-set midnight-blue
```

**Step 10: Iterate and Refine**

```bash
# If colors don't look right, adjust
nano ~/.local/share/omarchy/themes/midnight-blue/alacritty.toml
# Make changes

# Test again
omarchy-theme-set midnight-blue
```

**Result**: You now have a fully functional custom theme with ocean-inspired colors across all applications.

---

### Example 3: Advanced - Creating a Complete Theme Package

**Scenario**: You want to create a polished, distributable theme called "Amber Glow" with warm amber and dark brown colors, and publish it to GitHub.

**Step 1: Plan the Theme**

**Amber Glow Palette**:
- Background: `#1a1410` (very dark brown)
- Foreground: `#f5e6d3` (warm cream)
- Accent Amber: `#ffb84d` (golden amber)
- Accent Orange: `#ff8c42` (warm orange)
- Accent Red: `#d9534f` (burnt red)
- Accent Green: `#a8c256` (warm olive)
- Accent Blue: `#6c9bcf` (muted blue)

**Step 2: Create Theme Structure**

```bash
# Create directory
mkdir -p ~/amber-glow-theme/backgrounds

cd ~/amber-glow-theme
```

**Step 3: Create All Configuration Files**

**alacritty.toml**:
```bash
cat > alacritty.toml << 'EOF'
[colors.primary]
background = "#1a1410"
foreground = "#f5e6d3"
dim_foreground = "#9d8b7a"
bright_foreground = "#fffdf5"

[colors.cursor]
text = "#1a1410"
cursor = "#ffb84d"

[colors.vi_mode_cursor]
text = "#1a1410"
cursor = "#ff8c42"

[colors.search.matches]
foreground = "#1a1410"
background = "#ffb84d"

[colors.search.focused_match]
foreground = "#1a1410"
background = "#ff8c42"

[colors.footer_bar]
foreground = "#1a1410"
background = "#ffb84d"

[colors.hints.start]
foreground = "#1a1410"
background = "#ffb84d"

[colors.hints.end]
foreground = "#1a1410"
background = "#ff8c42"

[colors.selection]
text = "#1a1410"
background = "#ffb84d"

[colors.normal]
black = "#2a2420"
red = "#d9534f"
green = "#a8c256"
yellow = "#ffb84d"
blue = "#6c9bcf"
magenta = "#b380d5"
cyan = "#70c0ba"
white = "#f5e6d3"

[colors.bright]
black = "#4a3f35"
red = "#e57373"
green = "#b8d482"
yellow = "#ffd180"
blue = "#90b8e0"
magenta = "#c9a1e5"
cyan = "#9fded8"
white = "#fffdf5"

[[colors.indexed_colors]]
index = 16
color = "#ff8c42"

[[colors.indexed_colors]]
index = 17
color = "#d9534f"
EOF
```

**hyprland.conf**:
```bash
cat > hyprland.conf << 'EOF'
$activeBorderColor = rgb(ffb84d)

general {
    col.active_border = $activeBorderColor
}

group {
    col.border_active = $activeBorderColor
}
EOF
```

**waybar.css**:
```bash
cat > waybar.css << 'EOF'
@define-color foreground #f5e6d3;
@define-color background #1a1410;
EOF
```

**kitty.conf**:
```bash
cat > kitty.conf << 'EOF'
## name: Amber Glow
## author: Your Name
## license: MIT

background              #1a1410
foreground              #f5e6d3

color0                  #2a2420
color1                  #d9534f
color2                  #a8c256
color3                  #ffb84d
color4                  #6c9bcf
color5                  #b380d5
color6                  #70c0ba
color7                  #f5e6d3
color8                  #4a3f35
color9                  #e57373
color10                 #b8d482
color11                 #ffd180
color12                 #90b8e0
color13                 #c9a1e5
color14                 #9fded8
color15                 #fffdf5

cursor                  #ffb84d
cursor_text_color       #1a1410

selection_foreground    #1a1410
selection_background    #ffb84d

url_color               #6c9bcf

active_tab_foreground   #fffdf5
active_tab_background   #ffb84d
inactive_tab_foreground #f5e6d3
inactive_tab_background #2a2420
EOF
```

**ghostty.conf**:
```bash
cat > ghostty.conf << 'EOF'
background = 1a1410
foreground = f5e6d3

palette = 0=#2a2420
palette = 1=#d9534f
palette = 2=#a8c256
palette = 3=#ffb84d
palette = 4=#6c9bcf
palette = 5=#b380d5
palette = 6=#70c0ba
palette = 7=#f5e6d3
palette = 8=#4a3f35
palette = 9=#e57373
palette = 10=#b8d482
palette = 11=#ffd180
palette = 12=#90b8e0
palette = 13=#c9a1e5
palette = 14=#9fded8
palette = 15=#fffdf5
EOF
```

**chromium.theme**:
```bash
echo "26,20,16" > chromium.theme
```

**icons.theme**:
```bash
echo "Yaru-olive" > icons.theme
```

**mako.ini**:
```bash
cat > mako.ini << 'EOF'
include=~/.local/share/omarchy/default/mako/core.ini

text-color=#f5e6d3
border-color=#ffb84d
background-color=#1a1410
EOF
```

**swayosd.css**:
```bash
cat > swayosd.css << 'EOF'
@define-color background-color #1a1410;
@define-color border-color #ffb84d;
@define-color label #f5e6d3;
@define-color image #f5e6d3;
@define-color progress #ffb84d;
EOF
```

**walker.css**:
```bash
cat > walker.css << 'EOF'
@define-color selected-text #ff8c42;
@define-color text #f5e6d3;
@define-color base #1a1410;
@define-color border #ffb84d;
@define-color foreground #f5e6d3;
@define-color background #1a1410;
EOF
```

**hyprlock.conf**:
```bash
cat > hyprlock.conf << 'EOF'
$color = rgba(26,20,16,1.0)
$inner_color = rgba(26,20,16,0.8)
$outer_color = rgba(255,184,77,1.0)
$font_color = rgba(245,230,211,1.0)
$check_color = rgba(255,140,66,1.0)
EOF
```

**vscode.json**:
```bash
cat > vscode.json << 'EOF'
{
  "name": "Gruvbox Dark Medium",
  "extension": "jdinhlife.gruvbox"
}
EOF
```

**neovim.lua**:
```bash
cat > neovim.lua << 'EOF'
return {
	{ "ellisonleao/gruvbox.nvim" },
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "gruvbox",
		},
	},
}
EOF
```

**Step 4: Add Wallpapers**

```bash
# Download or create amber-themed wallpapers
# Place in backgrounds/ directory with numeric prefixes
cp ~/Pictures/amber-sunset.jpg backgrounds/1-amber-sunset.jpg
cp ~/Pictures/autumn-glow.png backgrounds/2-autumn-glow.png
cp ~/Pictures/golden-hour.jpg backgrounds/3-golden-hour.jpg
```

**Step 5: Create Preview Image**

```bash
# Take a screenshot with the theme applied
# Or create a composite preview showing multiple applications
# Save as preview.png
cp ~/Pictures/amber-glow-preview.png preview.png
```

**Step 6: Create README**

```bash
cat > README.md << 'EOF'
# Amber Glow - Omarchy Theme

A warm, amber-toned theme for Omarchy featuring golden amber accents and dark brown backgrounds.

## Preview

![Amber Glow Preview](preview.png)

## Installation

```bash
omarchy-theme-install https://github.com/yourusername/omarchy-theme-amber-glow
```

## Manual Installation

```bash
git clone https://github.com/yourusername/omarchy-theme-amber-glow \
  ~/.local/share/omarchy/themes/amber-glow

omarchy-theme-set amber-glow
```

## Color Palette

- Background: `#1a1410` (dark brown)
- Foreground: `#f5e6d3` (warm cream)
- Accent: `#ffb84d` (golden amber)
- Orange: `#ff8c42` (warm orange)
- Red: `#d9534f` (burnt red)

## Features

- Complete integration with all Omarchy applications
- 3 curated amber-themed wallpapers
- Optimized for long coding sessions in warm lighting
- Pairs well with warm-colored desk lamps

## License

MIT License - see LICENSE file

## Credits

Created by Your Name

Inspired by warm autumn evenings and golden hour sunlight.
EOF
```

**Step 7: Create LICENSE**

```bash
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2025 Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
```

**Step 8: Initialize Git Repo**

```bash
cd ~/amber-glow-theme

git init
git add .
git commit -m "Initial commit: Amber Glow theme for Omarchy"
```

**Step 9: Test Locally**

```bash
# Copy to Omarchy themes directory
cp -r ~/amber-glow-theme ~/.local/share/omarchy/themes/amber-glow

# Test the theme
omarchy-theme-set amber-glow

# Cycle through backgrounds
omarchy-theme-bg-next
omarchy-theme-bg-next
```

**Step 10: Publish to GitHub**

```bash
# Create repo on GitHub: https://github.com/new
# Name it: omarchy-theme-amber-glow

# Push to GitHub
git remote add origin https://github.com/yourusername/omarchy-theme-amber-glow.git
git branch -M main
git push -u origin main
```

**Step 11: Test Installation from GitHub**

```bash
# Remove local copy
rm -rf ~/.local/share/omarchy/themes/amber-glow

# Install from GitHub
omarchy-theme-install https://github.com/yourusername/omarchy-theme-amber-glow
```

**Result**: You now have a complete, professionally packaged theme ready for distribution to the Omarchy community.

---

## Publishing Themes

### Naming Convention

**Repository Name Format**:
```
omarchy-theme-NAME
```

**Examples**:
- `omarchy-theme-amber-glow`
- `omarchy-theme-midnight-blue`
- `omarchy-theme-neon-city`

**Theme Name Extraction**: The installer removes `omarchy-` prefix and `-theme` suffix:
- `omarchy-theme-amber-glow` → `amber-glow`

### Required Files for Distribution

**Minimum for a publishable theme**:
```
omarchy-theme-name/
├── README.md              # Installation instructions, preview, description
├── LICENSE                # MIT recommended
├── preview.png            # Screenshot of theme in action
├── alacritty.toml         # Base color palette
├── hyprland.conf          # Border colors
├── waybar.css             # Status bar colors
├── kitty.conf             # Kitty terminal support
└── backgrounds/           # At least 1 wallpaper
    └── 1-bg.png
```

**Recommended for a complete theme**:
- All config files (alacritty, kitty, ghostty, hyprland, waybar, etc.)
- Multiple wallpapers (3-5)
- VS Code integration (vscode.json)
- Neovim integration (neovim.lua)
- Preview image showing multiple applications

### README Template

```markdown
# Theme Name - Omarchy Theme

Brief description of theme aesthetic and color palette.

## Preview

![Theme Preview](preview.png)

## Installation

\`\`\`bash
omarchy-theme-install https://github.com/yourusername/omarchy-theme-name
\`\`\`

## Manual Installation

\`\`\`bash
git clone https://github.com/yourusername/omarchy-theme-name \\
  ~/.local/share/omarchy/themes/theme-name

omarchy-theme-set theme-name
\`\`\`

## Color Palette

- Background: `#RRGGBB` (description)
- Foreground: `#RRGGBB` (description)
- Accent: `#RRGGBB` (description)

## Features

- List of supported applications
- Number of included wallpapers
- Special features (light mode, high contrast, etc.)

## License

MIT License

## Credits

Created by Your Name
Inspired by [inspiration source]
```

### Publishing Checklist

Before publishing a theme, verify:

- [ ] All config files use consistent color palette
- [ ] Theme works correctly when installed via `omarchy-theme-install`
- [ ] README includes clear installation instructions
- [ ] preview.png shows theme in action
- [ ] LICENSE file included
- [ ] Repository name follows `omarchy-theme-NAME` convention
- [ ] At least one wallpaper included
- [ ] Colors are readable (text visible on backgrounds)
- [ ] Tested with multiple applications (terminals, Waybar, etc.)

### Sharing Your Theme

**Where to Share**:
1. GitHub/GitLab (primary distribution)
2. Omarchy community forums/Discord
3. Reddit (r/unixporn, r/hyprland)
4. Personal blog/website

**Sample Announcement**:
```
I created a new Omarchy theme called "Amber Glow" featuring warm amber
accents and dark brown backgrounds. Perfect for cozy evening coding sessions.

Install: omarchy-theme-install https://github.com/user/omarchy-theme-amber-glow

Preview: [link to image]

Feedback welcome!
```

---

## Theme File Reference

### Quick Reference Table

| File | Format | Required | Purpose | Fallback |
|------|--------|----------|---------|----------|
| `alacritty.toml` | TOML | Yes | Terminal colors | None |
| `kitty.conf` | Plain text | No | Kitty colors | Alacritty colors |
| `ghostty.conf` | Plain text | No | Ghostty colors | Built-in themes |
| `hyprland.conf` | Hypr syntax | Recommended | Border colors | Default Hyprland |
| `waybar.css` | CSS | Recommended | Status bar | Default Waybar |
| `vscode.json` | JSON | No | VS Code theme | Current theme |
| `chromium.theme` | Plain text | No | Browser color | Default |
| `icons.theme` | Plain text | No | Icon pack | Yaru-blue |
| `mako.ini` | INI | No | Notifications | Default mako |
| `swayosd.css` | CSS | No | OSD colors | Default SwayOSD |
| `walker.css` | CSS | No | Launcher colors | Default Walker |
| `neovim.lua` | Lua | No | Neovim theme | Current theme |
| `hyprlock.conf` | Hypr syntax | No | Lock screen | Default Hyprlock |
| `btop.theme` | Plain text | No | Btop colors | Default btop |
| `light.mode` | Any | No | Light theme flag | Dark mode |
| `obsidian.css` | CSS | No | Obsidian theme | Auto-generated |
| `preview.png` | PNG/JPG | No | Preview image | None |
| `backgrounds/` | Directory | Recommended | Wallpapers | Solid black |

---

## Troubleshooting

### Theme Doesn't Appear in List

**Symptom**: `omarchy-theme-list` doesn't show your theme

**Cause**: Theme not in correct directory or not a directory

**Solution**:

```bash
# Check themes directory
ls -la ~/.local/share/omarchy/themes/

# Ensure your theme is a directory
file ~/.local/share/omarchy/themes/my-theme
# Should show: directory

# If not present, create/move it
mkdir -p ~/.local/share/omarchy/themes/my-theme
```

---

### Theme Partially Applies

**Symptom**: Some applications update, others don't

**Cause**: Missing config files for specific applications

**Solution**:

This is expected. Create configs for missing applications:

```bash
# Check which files exist
ls ~/.local/share/omarchy/themes/my-theme/

# Add missing files
# Example: Add Kitty support
nano ~/.local/share/omarchy/themes/my-theme/kitty.conf
```

Alternatively, copy from another theme:

```bash
cp ~/.local/share/omarchy/themes/catppuccin/kitty.conf \
   ~/.local/share/omarchy/themes/my-theme/kitty.conf

# Edit colors
nano ~/.local/share/omarchy/themes/my-theme/kitty.conf
```

---

### Colors Look Wrong

**Symptom**: Colors don't match what you intended

**Cause**: Incorrect hex format or color conversion

**Solution**:

**Check hex format**:
- TOML/CSS: `#RRGGBB` (6 digits with #)
- Hyprland: `rgb(RRGGBB)` (6 digits, no #)
- Chromium: `R,G,B` (decimal 0-255)

**Convert colors correctly**:

```bash
# Hex to RGB decimal (for chromium.theme)
# Hex: #1a1410
# R = 1a (hex) = 26 (dec)
# G = 14 (hex) = 20 (dec)
# B = 10 (hex) = 16 (dec)
# Result: 26,20,16

# Or use online converters or calculators
```

**Test colors in isolation**:

Open a color picker to verify your hex codes produce the intended colors.

---

### Theme Installs But Doesn't Work

**Symptom**: `omarchy-theme-install` succeeds but theme is broken

**Cause**: Syntax errors in config files

**Solution**:

```bash
# Check for syntax errors in TOML
# Invalid:
[colors.primary
background = "#000000"

# Valid:
[colors.primary]
background = "#000000"

# Check JSON files
jq . ~/.local/share/omarchy/themes/my-theme/vscode.json
# If invalid, shows error message

# Check INI files
# Ensure no stray characters or missing equals signs
```

Re-apply theme after fixing:

```bash
omarchy-theme-set my-theme
```

---

## Best Practices

### Do's

**DO start with an existing theme as a template**
```bash
cp -r ~/.local/share/omarchy/themes/catppuccin ~/.local/share/omarchy/themes/my-theme
```
- Faster than starting from scratch
- Ensures all config files are present
- You only modify colors, not structure

**DO use consistent color names across files**
- Use the same hex values for "accent blue" in all files
- Create a color reference doc for your theme
- Makes maintenance easier

**DO test theme on all applications you use**
- Terminals (Alacritty, Kitty, Ghostty)
- Status bar (Waybar)
- Editor (VS Code, Neovim)
- Check readability in all contexts

**DO provide multiple wallpapers**
- 3-5 wallpapers is ideal
- Different moods/times of day
- All should match theme colors

**DO include a preview image**
- Screenshot showing multiple applications
- Helps users decide if they like the theme
- Use `scrot`, `grim`, or `hyprshot` for screenshots

**DO use descriptive theme names**
- Good: `midnight-ocean`, `autumn-warmth`, `neon-cyberpunk`
- Bad: `theme1`, `my-theme`, `test`

**DO follow naming conventions for publishing**
- Repository: `omarchy-theme-NAME`
- Directory: `NAME` (lowercase, hyphens)

**DO include a license**
- MIT license is standard for themes
- Allows others to modify and share
- Provides legal clarity

---

### Don'ts

**DON'T use invalid color formats**
```bash
# ❌ WRONG:
background = "1e1e2e"          # Missing #
background = "#1e1e2e;"        # Stray semicolon in TOML
background = "rgb(30,30,46)"   # Wrong format for TOML

# ✅ RIGHT:
background = "#1e1e2e"
```

**DON'T forget to test theme installation**
```bash
# Always test the install flow
omarchy-theme-install https://github.com/you/omarchy-theme-name

# If it fails, users won't be able to install it
```

**DON'T use extremely similar colors**
- Distinguish normal vs. bright colors
- Ensure sufficient contrast between background/foreground
- Test with actual terminal use (ls output, syntax highlighting)

**DON'T include proprietary or copyrighted content**
- Wallpapers must be your own or licensed for distribution
- Theme names shouldn't infringe trademarks
- Credit original inspiration if adapting from another theme

**DON'T create themes with unreadable text**
```bash
# ❌ BAD: Low contrast
background = "#2a2a2a"
foreground = "#3a3a3a"  # Almost same as background!

# ✅ GOOD: High contrast
background = "#2a2a2a"
foreground = "#e0e0e0"
```

**DON'T modify installed themes directly**
```bash
# ❌ DON'T:
nano ~/.local/share/omarchy/themes/catppuccin/alacritty.toml

# ✅ DO:
cp -r ~/.local/share/omarchy/themes/catppuccin \
      ~/.local/share/omarchy/themes/catppuccin-custom
nano ~/.local/share/omarchy/themes/catppuccin-custom/alacritty.toml
```

Modifying installed themes loses changes on `omarchy-theme-update`.

**DON'T publish untested themes**
- Always test locally first
- Verify all config files have valid syntax
- Check for typos in file names

**DON'T use massive wallpaper files**
- Keep images under 5MB
- Compress with `convert input.jpg -quality 85 output.jpg`
- Large files slow down theme switching

---

## Related Documentation

### Theming & Customization
- **Theme System** (`theme-system.md`) - Complete overview of how themes work
- **Fonts** (`fonts.md`) - Font management to complement themes
- **Backgrounds** (`backgrounds.md`) - Wallpaper management and background structure

### Application Integration
- **Terminal Configuration** (`../04-desktop-environment/terminals.md`) - Terminal emulator setup
- **Hyprland Configuration** (`../04-desktop-environment/hyprland.md`) - Window manager theming
- **Waybar Customization** (`../04-desktop-environment/waybar.md`) - Status bar styling

### Development & Advanced
- **Hooks System** (`../09-customization/hooks.md`) - Custom actions on theme changes
- **Config Management** (`../09-customization/config-files.md`) - Omarchy's config architecture
- **Symlink System** (`../10-reference/symlinks.md`) - How Omarchy uses symlinks

### Quick References
- **Command Index** (`../10-reference/command-index.md`) - All Omarchy commands
- **Troubleshooting Guide** (`../10-reference/troubleshooting.md`) - Common issues
- **File Locations** (`../10-reference/file-locations.md`) - Where themes are stored

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts** (analyzed for this documentation):
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-install`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-remove`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-set`

**Theme Examples Analyzed**:
- `/home/zack/.local/share/omarchy/themes/catppuccin/` (comprehensive theme)
- `/home/zack/.local/share/omarchy/themes/gruvbox/` (complete file set)
- `/home/zack/.local/share/omarchy/themes/tokyo-night/` (modern theme)
- `/home/zack/.local/share/omarchy/themes/matte-black/` (minimal theme)

**Configuration File Formats**: All formats verified against actual working themes

**Verification**: All commands, file structures, and examples tested on Omarchy system running Hyprland on Arch Linux.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
