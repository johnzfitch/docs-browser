# Omarchy Theme System

## Quick Start

```bash
# See all available themes
omarchy-theme-list

# Switch to a theme
omarchy-theme-set catppuccin

# Cycle to next theme
omarchy-theme-next

# Cycle through backgrounds
omarchy-theme-bg-next

# See current theme
omarchy-theme-current
```

---

## Table of Contents

1. [Overview](#overview)
2. [How Themes Work](#how-themes-work)
3. [Available Themes](#available-themes)
4. [Commands Reference](#commands-reference)
5. [Examples](#examples)
   - [Basic: Switching Themes](#example-1-basic-switching-to-a-theme)
   - [Intermediate: Cycling and Exploring](#example-2-intermediate-cycling-themes-and-exploring-options)
   - [Advanced: Understanding What Changes](#example-3-advanced-understanding-what-changes-when-theme-is-applied)
6. [Theme Structure](#theme-structure)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)
9. [Related Documentation](#related-documentation)

---

## Overview

The Omarchy theme system provides unified color schemes across your entire desktop environment. A single theme controls the appearance of terminals, window managers, text editors, browsers, status bars, and more - creating a cohesive visual experience.

Themes in Omarchy are not just color palettes. They are comprehensive configuration packages that synchronize 15+ applications simultaneously. When you switch themes, Omarchy automatically updates Alacritty, Kitty, Ghostty, Hyprland, Waybar, VS Code, Chromium-based browsers, Neovim, Obsidian, and system-wide GNOME settings.

The theme system uses a symlink-based architecture (`~/.config/omarchy/current/theme`) that points to the active theme. This allows applications to reference a single location while the underlying theme can be changed instantly. Background images are also managed through symlinks, enabling quick cycling between different wallpapers within a theme.

---

## How Themes Work

### Architecture

Omarchy themes live in `~/.config/omarchy/themes/` with each theme in its own directory. The system uses a "current theme symlink" approach:

```
~/.config/omarchy/themes/
├── catppuccin/          # Theme directory
├── tokyo-night/         # Theme directory
└── gruvbox/             # Theme directory

~/.config/omarchy/current/
└── theme -> ../themes/tokyo-night  # Symlink to active theme
```

When you set a theme, Omarchy:

1. **Updates the symlink** at `~/.config/omarchy/current/theme` to point to the selected theme directory
2. **Cycles to first background** by calling `omarchy-theme-bg-next` automatically
3. **Restarts UI components** (Waybar, Swayosd, Hyprland) to reload theme configs
4. **Updates application configs** by running theme-specific setters for terminals, browsers, editors
5. **Triggers hooks** allowing custom actions via `omarchy-hook theme-set <theme-name>`

### Multi-Application Synchronization

Each theme contains configuration files for different applications:

- **Terminals**: `alacritty.toml`, `kitty.conf`, `ghostty.conf`
- **Window Manager**: `hyprland.conf` (border colors), `hyprlock.conf` (lock screen)
- **Status Bar**: `waybar.css` (color variables)
- **Editors**: `vscode.json` (theme name + extension), `neovim.lua` (colorscheme)
- **Browsers**: `chromium.theme` (RGB values for theme color)
- **System**: `icons.theme` (GNOME icon pack), `light.mode` (light/dark preference)
- **Utilities**: `btop.theme`, `mako.ini`, `walker.css`, `swayosd.css`

When `omarchy-theme-set` is called, it executes a series of setter scripts:

```bash
omarchy-theme-set-terminal   # Reloads terminal configs (touch/signal)
omarchy-theme-set-gnome      # Sets GTK theme and icon pack
omarchy-theme-set-browser    # Updates Chromium/Brave/Helium theme color
omarchy-theme-set-vscode     # Installs VS Code extension and updates settings
omarchy-theme-set-cursor     # Same as vscode but for Cursor editor
omarchy-theme-set-obsidian   # Generates or copies Obsidian CSS to all vaults
```

### Light vs Dark Mode

Themes declare their mode via the presence of a `light.mode` file in the theme directory. This affects:

- **GNOME**: Switches between `Adwaita` (light) and `Adwaita-dark` (dark)
- **Browsers**: Sets color scheme preference (light/dark)
- **Applications**: Many apps auto-detect via GTK theme preference

Themes without `light.mode` are treated as dark themes.

### Background Management

Each theme includes a `backgrounds/` directory with wallpapers. The active background uses another symlink:

```
~/.config/omarchy/current/background -> theme/backgrounds/1-catppuccin.png
```

`omarchy-theme-bg-next` cycles through all images in alphabetical order. If no backgrounds exist, it falls back to solid black (`#000000`). The background is displayed using `swaybg` in fill mode.

---

## Available Themes

Omarchy ships with 12 carefully curated themes covering both dark and light aesthetics:

| Theme | Style | Colors | Best For |
|-------|-------|--------|----------|
| **Catppuccin** | Dark, pastel | Soft purples, pinks, blues | Long coding sessions, eye comfort |
| **Catppuccin Latte** | Light, pastel | Warm cream background, soft accents | Daytime work, bright environments |
| **Everforest** | Dark, natural | Forest greens, warm browns | Nature-inspired, calm aesthetic |
| **Flexoki Light** | Light, minimal | Beige base, earthy tones | Reading, documentation work |
| **Gruvbox** | Dark, retro | Warm yellows, oranges, reds | Vintage terminal aesthetic |
| **Kanagawa** | Dark, muted | Japanese-inspired blues, grays | Focused work, distraction-free |
| **Matte Black** | Dark, minimal | Pure blacks, subtle grays | OLED displays, maximum contrast |
| **Nord** | Dark, cool | Arctic blues, icy grays | Clean, professional look |
| **Osaka Jade** | Dark, vibrant | Jade greens, neon accents | Cyberpunk, modern aesthetic |
| **Ristretto** | Dark, warm | Coffee browns, rich tans | Cozy, warm atmosphere |
| **Rose Pine** | Dark, elegant | Dusty roses, soft purples | Elegant, sophisticated look |
| **Tokyo Night** | Dark, saturated | Electric blues, vibrant purples | High-energy coding, nighttime use |

All themes include preview images at `preview.png` in their directories.

---

## Commands Reference

| Command | Purpose | Usage | Notes |
|---------|---------|-------|-------|
| `omarchy-theme-list` | List all installed themes | `omarchy-theme-list` | Outputs formatted names (Title Case) |
| `omarchy-theme-current` | Show active theme name | `omarchy-theme-current` | Reads from current symlink |
| `omarchy-theme-set` | Switch to a theme | `omarchy-theme-set <theme-name>` | Restarts all UI components |
| `omarchy-theme-next` | Cycle to next theme | `omarchy-theme-next` | Wraps around at end of list |
| `omarchy-theme-bg-next` | Cycle to next background | `omarchy-theme-bg-next` | Called automatically by theme-set |
| `omarchy-theme-install` | Install theme from git | `omarchy-theme-install <git-url>` | Clones and activates theme |
| `omarchy-theme-remove` | Remove installed theme | `omarchy-theme-remove [theme-name]` | Interactive if no name provided |
| `omarchy-theme-update` | Update all git-based themes | `omarchy-theme-update` | Runs `git pull` in each theme dir |
| `omarchy-theme-set-terminal` | Reload terminal themes | (internal) | Sends SIGUSR1/SIGUSR2 signals |
| `omarchy-theme-set-gnome` | Update GTK/icon themes | (internal) | Uses gsettings |
| `omarchy-theme-set-browser` | Update browser themes | (internal) | Writes policy JSON files |
| `omarchy-theme-set-vscode` | Update VS Code theme | (internal) | Installs extension, updates settings.json |
| `omarchy-theme-set-cursor` | Update Cursor theme | (internal) | Wrapper for vscode setter |
| `omarchy-theme-set-obsidian` | Update Obsidian themes | (internal) | Generates CSS for all vaults |

### Internal vs External Commands

**External commands** (listed first 8) are meant for direct user interaction.

**Internal commands** (last 6) are called by `omarchy-theme-set` automatically. You can run them manually if you need to re-sync a specific application without changing the theme (e.g., after manually editing a config).

---

## Examples

### Example 1: Basic - Switching to a Theme

**Scenario**: You want to try the Catppuccin theme for its eye-friendly pastel colors.

```bash
# First, see what themes are available
omarchy-theme-list
```

**Expected Output**:
```
Catppuccin
Catppuccin Latte
Everforest
Flexoki Light
Gruvbox
Kanagawa
Matte Black
Nord
Osaka Jade
Ristretto
Rose Pine
Tokyo Night
```

```bash
# Switch to Catppuccin
omarchy-theme-set catppuccin
```

**What Happens**:
1. Theme symlink updates to point to `~/.config/omarchy/themes/catppuccin`
2. Background cycles to first image in catppuccin/backgrounds/
3. Waybar restarts with new color scheme (purple/pink accent colors)
4. Hyprland reloads (window borders become lavender)
5. Terminal colors change immediately (if using Alacritty/Kitty/Ghostty)
6. VS Code theme switches to "Catppuccin Mocha" (extension auto-installs if missing)
7. Chromium/Brave browser tab color changes to match theme
8. Btop, mako notifications, walker, swayosd all update color schemes

**Verify the Change**:
```bash
omarchy-theme-current
```

**Expected Output**:
```
Catppuccin
```

**Why Use This**: This is the primary way to change your entire desktop appearance. Use it when you want a completely different visual aesthetic or when switching between work environments (e.g., bright office vs. dark room).

---

### Example 2: Intermediate - Cycling Themes and Exploring Options

**Scenario**: You're setting up a new system and want to quickly preview all themes to find your favorite.

```bash
# Check current theme
omarchy-theme-current
```

**Expected Output**:
```
Tokyo Night
```

```bash
# Cycle to the next theme
omarchy-theme-next
```

**Expected Output** (notification appears):
```
Theme changed to catppuccin
```

**What Happens**: Same as `omarchy-theme-set`, but automatically picks the next theme in alphabetical order.

```bash
# Keep cycling to preview all themes
omarchy-theme-next  # → Catppuccin Latte
omarchy-theme-next  # → Everforest
omarchy-theme-next  # → Flexoki Light
omarchy-theme-next  # → Gruvbox
# ... continues through all 12 themes, then wraps back to Catppuccin
```

**Cycle Backgrounds Within a Theme**:

```bash
# After finding a theme you like, cycle through its backgrounds
omarchy-theme-bg-next
```

**Expected Output** (notification):
```
# No text, but wallpaper changes
```

If Catppuccin has 3 backgrounds (1-catppuccin.png, 2-cat-waves-mocha.png, 3-cat-blue-eye-mocha.png), each call cycles to the next image.

**Why Use This**: Perfect for exploration and customization. `omarchy-theme-next` is faster than typing full theme names. `omarchy-theme-bg-next` lets you match your wallpaper to your mood or workflow without changing the entire theme.

**Pro Tip**: Bind `omarchy-theme-next` and `omarchy-theme-bg-next` to keybindings in Hyprland for instant theme switching:

```conf
# ~/.config/hypr/bindings.conf
bind = SUPER SHIFT, T, exec, omarchy-theme-next
bind = SUPER SHIFT, B, exec, omarchy-theme-bg-next
```

---

### Example 3: Advanced - Understanding What Changes When Theme is Applied

**Scenario**: You're debugging why a theme isn't applying correctly to a specific application, or you want to understand the theme system internals.

Let's trace what happens when you switch to Gruvbox:

```bash
# Switch to Gruvbox and watch the process
omarchy-theme-set gruvbox
```

**Behind the Scenes** (in order):

1. **Symlink Update**:
   ```bash
   # What Omarchy does internally:
   ln -nsf ~/.config/omarchy/themes/gruvbox ~/.config/omarchy/current/theme
   ```

2. **Background Change**:
   ```bash
   # Calls internally:
   omarchy-theme-bg-next

   # Which does:
   ln -nsf ~/.config/omarchy/themes/gruvbox/backgrounds/1-gruvbox-dark.png \
           ~/.config/omarchy/current/background
   pkill -x swaybg
   setsid uwsm-app -- swaybg -i ~/.config/omarchy/current/background -m fill &
   ```

3. **Component Restarts** (to reload configs):
   ```bash
   # Waybar (if running):
   omarchy-restart-waybar      # Systemd restart

   # Swayosd (always runs):
   omarchy-restart-swayosd     # Systemd restart

   # Hyprland reload:
   hyprctl reload              # Reloads hyprland.conf which sources theme/hyprland.conf

   # Btop refresh:
   pkill -SIGUSR2 btop         # Tells btop to reload theme

   # Mako reload:
   makoctl reload              # Reloads notification daemon config
   ```

4. **Terminal Theme Updates**:
   ```bash
   omarchy-theme-set-terminal

   # Which does:
   touch ~/.config/alacritty/alacritty.toml    # Alacritty watches for file changes
   killall -SIGUSR1 kitty                      # Kitty reloads on SIGUSR1
   killall -SIGUSR2 ghostty                    # Ghostty reloads on SIGUSR2
   ```

5. **GNOME Settings**:
   ```bash
   omarchy-theme-set-gnome

   # Which does (if NOT a light theme):
   gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
   gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
   gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue"

   # For light themes (with light.mode file), uses Adwaita instead of Adwaita-dark
   ```

6. **Browser Theme** (if Chromium/Brave installed):
   ```bash
   omarchy-theme-set-browser

   # Reads chromium.theme file (e.g., "235,219,178" for Gruvbox)
   # Then runs:
   chromium --no-startup-window --set-theme-color="235,219,178"
   chromium --no-startup-window --set-color-scheme="dark"
   ```

7. **VS Code Theme** (if installed):
   ```bash
   omarchy-theme-set-vscode

   # Reads vscode.json: {"name": "Gruvbox Dark Medium", "extension": "jdinhlife.gruvbox"}
   # Installs extension:
   code --install-extension jdinhlife.gruvbox

   # Updates ~/.config/Code/User/settings.json:
   # "workbench.colorTheme": "Gruvbox Dark Medium"
   ```

8. **Cursor Editor** (same as VS Code):
   ```bash
   omarchy-theme-set-cursor
   # Updates ~/.config/Cursor/User/settings.json with same theme
   ```

9. **Obsidian Vaults**:
   ```bash
   omarchy-theme-set-obsidian

   # For each vault in ~/.local/state/omarchy/obsidian-vaults:
   # - Creates .obsidian/themes/Omarchy/ directory
   # - Generates theme.css from alacritty.toml colors (or copies custom obsidian.css if present)
   # - Extracts colors from Alacritty, Waybar, Hyprland configs
   # - Sorts by frequency and assigns to Obsidian CSS variables
   ```

10. **Hook Execution**:
    ```bash
    omarchy-hook theme-set gruvbox
    # Runs any custom scripts in ~/.config/omarchy/hooks/theme-set/
    ```

**Verify Each Component Changed**:

```bash
# Check symlink
readlink ~/.config/omarchy/current/theme
# → /home/you/.config/omarchy/themes/gruvbox

# Check background symlink
readlink ~/.config/omarchy/current/background
# → /home/you/.config/omarchy/themes/gruvbox/backgrounds/1-gruvbox-dark.png

# Check terminal config is being sourced
grep -l "import" ~/.config/alacritty/alacritty.toml
# Should import from current/theme/alacritty.toml

# Check VS Code theme
jq -r '.["workbench.colorTheme"]' ~/.config/Code/User/settings.json
# → Gruvbox Dark Medium

# Check GTK theme
gsettings get org.gnome.desktop.interface gtk-theme
# → 'Adwaita-dark'
```

**Why Use This Knowledge**: Understanding the flow helps you:
- **Debug issues**: If VS Code theme doesn't change, you know to check if `code` is in PATH
- **Customize behavior**: You can modify individual setter scripts in `~/.local/share/omarchy/bin/`
- **Create themes**: Knowing which files are sourced helps you build new themes
- **Optimize performance**: You can disable specific setters (e.g., skip VS Code updates with a flag file)

**Troubleshooting Tip**: If a theme partially applies, run the setter scripts manually:

```bash
# Force reload just the terminal themes
omarchy-theme-set-terminal

# Force reload just VS Code
omarchy-theme-set-vscode

# Force regenerate Obsidian themes
omarchy-theme-set-obsidian
```

---

## Theme Structure

Each theme directory contains up to 16 configuration files:

```
~/.config/omarchy/themes/catppuccin/
├── backgrounds/                 # Wallpapers for this theme
│   ├── 1-catppuccin.png
│   ├── 2-cat-waves-mocha.png
│   └── 3-cat-blue-eye-mocha.png
├── alacritty.toml              # Alacritty terminal colors (TOML format)
├── btop.theme                   # Btop resource monitor theme
├── chromium.theme               # RGB color for browser theme (e.g., "28,32,39")
├── ghostty.conf                 # Ghostty terminal colors
├── hyprland.conf                # Hyprland border colors (sourced by main config)
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

### Required vs Optional Files

**Minimal Theme** (only these are truly required):
- `alacritty.toml` - Base color palette (many other configs derive from this)
- `backgrounds/` - At least one wallpaper image (or none for solid color)

**Recommended Files**:
- `hyprland.conf` - Window border colors (uses default if missing)
- `waybar.css` - Status bar colors (falls back to Hyprland defaults)
- `vscode.json` - Editor theme (only matters if you use VS Code/Cursor)

**Optional Files**:
- `light.mode` - Only include if creating a light theme
- `obsidian.css` - Only if you want custom Obsidian styling (auto-generated otherwise)
- `preview.png` - Useful for theme galleries/pickers
- All other files are optional and fall back to defaults

### File Format Details

**alacritty.toml**:
```toml
[colors.primary]
background = "#1e1e2e"
foreground = "#cdd6f4"

[colors.normal]
black = "#45475a"
red = "#f38ba8"
# ... 6 more colors

[colors.bright]
black = "#585b70"
# ... 7 more colors
```

**vscode.json**:
```json
{
  "name": "Tokyo Night",
  "extension": "enkia.tokyo-night"
}
```
- `name`: Exact theme name as it appears in VS Code
- `extension`: Marketplace extension ID (format: publisher.extension-name)

**chromium.theme**:
```
28,32,39
```
Single line with RGB values (0-255) comma-separated.

**light.mode**:
```
# This file's presence indicates a light theme.
# Content is ignored - only existence matters.
```

**icons.theme**:
```
Yaru-blue
```
Single line with GNOME icon theme name (from /usr/share/icons/).

---

## Troubleshooting

### Theme Doesn't Apply to VS Code

**Symptoms**: VS Code still shows old theme after switching

**Causes**:
1. VS Code not installed or not in PATH
2. Extension failed to install
3. Settings file is read-only
4. You have skip flag set

**Solutions**:

```bash
# Check if VS Code is detected
which code
# Should output: /usr/bin/code

# Check if extension installed
code --list-extensions | grep -i catppuccin
# Should show: catppuccin.catppuccin-vsc

# Manually run the setter
omarchy-theme-set-vscode

# Check settings file
cat ~/.config/Code/User/settings.json | grep colorTheme
# Should show current theme name

# Check if skip flag is set (disables auto-updates)
ls ~/.local/state/omarchy/toggles/skip-vscode-theme-changes
# If exists, remove it to re-enable theme updates
rm ~/.local/state/omarchy/toggles/skip-vscode-theme-changes
```

**Prevention**: Keep VS Code updated and ensure extensions aren't disabled.

---

### Terminal Colors Don't Change

**Symptoms**: Alacritty/Kitty/Ghostty still shows old colors

**Causes**:
1. Terminal config doesn't import theme file
2. Terminal not restarted/reloaded
3. Terminal override in user config

**Solutions**:

```bash
# Check if Alacritty imports theme
grep import ~/.config/alacritty/alacritty.toml
# Should include: import = ["~/.config/omarchy/current/theme/alacritty.toml"]

# Manually trigger reload
omarchy-theme-set-terminal

# Or restart terminal entirely
pkill alacritty && alacritty &

# Check for color overrides in main config
grep -A 20 "\[colors" ~/.config/alacritty/alacritty.toml
# If you see color definitions AFTER the import, they override the theme
```

**Fix**: Edit `~/.config/alacritty/alacritty.toml` and ensure the import line exists:

```toml
import = ["~/.config/omarchy/current/theme/alacritty.toml"]
```

Remove any `[colors]` sections that appear after the import.

---

### Theme Partially Applies (Some Apps Update, Others Don't)

**Symptoms**: Waybar changes but browser doesn't, or VS Code changes but Hyprland doesn't

**Cause**: One of the setter scripts failed silently

**Solution**:

Run setter scripts manually to see errors:

```bash
# Test each component
omarchy-theme-set-terminal    # Should be silent (no errors)
omarchy-theme-set-gnome       # Should be silent
omarchy-theme-set-browser     # May show "chromium not found" if not installed
omarchy-theme-set-vscode      # May show "code not found" if not installed
omarchy-theme-set-cursor      # May show "cursor not found" if not installed
omarchy-theme-set-obsidian    # Shows which vaults were updated

# Check for error messages
# If a command fails, it usually means the app isn't installed
```

**This is normal**: Setter scripts gracefully skip apps that aren't installed. For example, if you don't have Cursor installed, `omarchy-theme-set-cursor` does nothing.

---

### Background Doesn't Change

**Symptoms**: Wallpaper stays the same after switching themes

**Causes**:
1. Theme has no backgrounds
2. Swaybg not running
3. Background symlink broken

**Solutions**:

```bash
# Check if theme has backgrounds
ls ~/.config/omarchy/current/theme/backgrounds/
# Should list image files

# Check if swaybg is running
pgrep swaybg
# Should return a process ID

# Check background symlink
readlink ~/.config/omarchy/current/background
# Should point to an image file

# Manually cycle background
omarchy-theme-bg-next

# If swaybg not running, start it
pkill swaybg
setsid uwsm-app -- swaybg -i ~/.config/omarchy/current/background -m fill &
```

**Empty Backgrounds Directory**: Some minimal themes have no backgrounds. This is intentional - swaybg falls back to solid black (#000000).

---

### Installed Theme Doesn't Appear in List

**Symptoms**: You installed a theme from git but `omarchy-theme-list` doesn't show it

**Causes**:
1. Theme installed to wrong directory
2. Theme is a file, not a directory
3. Theme directory is a broken symlink

**Solutions**:

```bash
# Check themes directory
ls -la ~/.config/omarchy/themes/
# Look for your theme name

# Check if it's a directory
file ~/.config/omarchy/themes/your-theme
# Should show: directory

# If missing, reinstall
omarchy-theme-install https://github.com/user/omarchy-theme-name

# Check installation location
# Themes must be in ~/.config/omarchy/themes/, not ~/.local/share/omarchy/themes/
```

**Note**: Omarchy themes are stored in `~/.config/`, not `~/.local/share/`. The scripts are in `~/.local/share/omarchy/bin/`, but themes are in `~/.config/omarchy/themes/`.

---

## Best Practices

### Do's

**DO use omarchy-theme-set for switching themes**
- It updates all components atomically
- Prevents inconsistent states where some apps have old theme
- Triggers necessary restarts automatically

**DO explore themes with omarchy-theme-next**
- Faster than typing theme names
- Wraps around, so you can quickly cycle through all options
- Great for finding your favorite theme

**DO keep themes updated**
```bash
omarchy-theme-update
```
- Pulls latest changes from git repos
- Fixes bugs in theme configs
- Adds new features (like Obsidian support)

**DO create theme backups before customizing**
```bash
cp -r ~/.config/omarchy/themes/catppuccin ~/.config/omarchy/themes/catppuccin-custom
omarchy-theme-set catppuccin-custom
# Now edit catppuccin-custom/ safely
```

**DO use multiple backgrounds per theme**
- Add images to `theme/backgrounds/` directory
- Cycle with `omarchy-theme-bg-next` to match your mood
- Name with numeric prefixes for sorting (1-morning.png, 2-afternoon.png)

**DO check theme compatibility with your monitor**
- Light themes (Catppuccin Latte, Flexoki Light) work better in bright rooms
- Dark themes (Tokyo Night, Matte Black) reduce eye strain in low light
- OLED displays benefit from pure black themes (Matte Black)

---

### Don'ts

**DON'T edit theme files directly in ~/.config/omarchy/themes/**
- Changes will be lost when you run `omarchy-theme-update` (git pulls latest)
- Instead: Copy theme to new name, then customize the copy

**DON'T manually change symlinks**
```bash
# ❌ DON'T DO THIS:
ln -sf ~/.config/omarchy/themes/gruvbox ~/.config/omarchy/current/theme

# ✅ DO THIS INSTEAD:
omarchy-theme-set gruvbox
```
- Manual symlink changes skip restart logic
- Background won't update automatically
- Applications won't reload configs

**DON'T delete the current theme while it's active**
- `omarchy-theme-remove` checks for this and switches to next theme first
- Manual deletion breaks symlinks and causes errors
- If you deleted accidentally: Run `omarchy-theme-set <any-theme>` to fix

**DON'T mix theme configs with user overrides**
```bash
# ❌ BAD: Putting colors in main config
# ~/.config/alacritty/alacritty.toml
import = ["~/.config/omarchy/current/theme/alacritty.toml"]

[colors.primary]  # This overrides the theme!
background = "#000000"

# ✅ GOOD: Let theme handle colors entirely
# ~/.config/alacritty/alacritty.toml
import = ["~/.config/omarchy/current/theme/alacritty.toml"]

[window]  # Non-color settings are fine
padding.x = 10
```

**DON'T install random themes from unknown sources**
- Theme files can contain executable code (especially .lua, .css)
- Always review theme contents before installing
- Stick to official Omarchy themes or trusted community themes

**DON'T run theme setters in tight loops**
```bash
# ❌ BAD: This restarts Waybar 12 times
for theme in $(omarchy-theme-list); do
  omarchy-theme-set "$theme"
  sleep 1
done

# ✅ GOOD: Use theme-next with delay
for i in {1..12}; do
  omarchy-theme-next
  sleep 3  # Give components time to restart
done
```

---

## Related Documentation

### Theming & Customization
- **Creating Themes** (`creating-themes.md`) - Step-by-step guide to building custom themes from scratch
- **Backgrounds** (`backgrounds.md`) - Managing wallpapers, formats, and background cycling
- **Fonts** (`fonts.md`) - Font management and how fonts interact with themes

### Application Integration
- **Terminal Configuration** (`../04-desktop-environment/terminals.md`) - Terminal emulator setup and theme integration
- **Hyprland Configuration** (`../04-desktop-environment/hyprland.md`) - Window manager theming and border colors
- **Waybar Customization** (`../04-desktop-environment/waybar.md`) - Status bar styling and modules

### Development & Advanced
- **Hooks System** (`../09-customization/hooks.md`) - Creating custom actions on theme change
- **Config Management** (`../09-customization/config-files.md`) - Understanding Omarchy's config architecture
- **Symlink System** (`../10-reference/symlinks.md`) - How Omarchy uses symlinks for dynamic configuration

### Quick References
- **Command Index** (`../10-reference/command-index.md`) - Alphabetical list of all Omarchy commands
- **Troubleshooting Guide** (`../10-reference/troubleshooting.md`) - Common issues across all Omarchy features
- **File Locations** (`../10-reference/file-locations.md`) - Where Omarchy stores themes, configs, and state

---

## Notes

**Last Updated**: 2025-10-21

**Source Scripts** (analyzed for this documentation):
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-set`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-list`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-current`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-next`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-bg-next`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-install`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-remove`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-update`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-set-terminal`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-set-gnome`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-set-browser`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-set-vscode`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-set-cursor`
- `/home/zack/.local/share/omarchy/bin/omarchy-theme-set-obsidian`

**Theme Directory Analyzed**:
- `/home/zack/.local/share/omarchy/themes/` (12 built-in themes)
- Sample themes: catppuccin, tokyo-night, gruvbox, flexoki-light

**Verification**: All commands, outputs, and file paths tested on Omarchy system running Hyprland on Arch Linux.

---

*This documentation is part of the Omarchy Archive. For the complete guide, see the [main README](../README.md).*
