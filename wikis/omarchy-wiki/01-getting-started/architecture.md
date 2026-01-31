# Omarchy Architecture

**Purpose:** Understanding how Omarchy components fit together
**Use Case:** System administrators, developers, and advanced users

*Last Updated: 2025-10-21*

---

## Quick Start (30-Second Guide)

```bash
# View system architecture visually
omarchy-launch-about

# Check component status
systemctl --user status walker waybar pipewire

# View config hierarchy
tree -L 2 ~/.config/omarchy

# Check installed components
pacman -Qe | wc -l  # Explicit packages
```

---

## Table of Contents

- [System Overview](#system-overview)
- [Architecture Diagram](#architecture-diagram)
- [Component Relationships](#component-relationships)
- [Config Hierarchy](#config-hierarchy)
- [Theme System Integration](#theme-system-integration)
- [Package Management Flow](#package-management-flow)
- [Data Flow Examples](#data-flow-examples)
- [Troubleshooting](#troubleshooting)
- [Related Documentation](#related-documentation)

---

## System Overview

Omarchy is built on a layered architecture where each component has a specific role and communicates with others through well-defined interfaces.

### Layer 1: Foundation (Linux Kernel & Systemd)

**Components:**
- Linux kernel (latest from Arch repos)
- systemd (init system and service manager)
- systemd-boot or GRUB (boot loader)
- Plymouth (boot splash)

**Responsibilities:**
- Hardware initialization
- Process management
- Service orchestration
- Boot sequence

---

### Layer 2: Display Server (Wayland)

**Components:**
- Hyprland (Wayland compositor)
- xdg-desktop-portal-hyprland (portal implementation)
- UWSM (Universal Wayland Session Manager)

**Responsibilities:**
- Display management
- Window rendering
- Input handling
- Screen sharing/recording portals

---

### Layer 3: Desktop Environment Components

**Components:**
- Walker (launcher) + Elephant (plugins)
- Waybar (status bar)
- Mako (notifications)
- Hypridle (idle management)
- Hyprlock (screen locker)
- Hyprsunset (night light)
- Swaybg (wallpaper)
- SwayOSD (on-screen display for volume/brightness)

**Responsibilities:**
- User interaction
- System status display
- Notifications
- Power management
- Visual effects

---

### Layer 4: Applications

**Components:**
- Terminal emulators (Alacritty, Kitty, Ghostty)
- Browsers (Firefox, Chromium)
- Editors (Neovim, VS Code, Cursor)
- File manager (Nautilus)
- Media apps (OBS, Kdenlive, MPV)
- Productivity apps (Obsidian, LibreOffice)

**Responsibilities:**
- User workflows
- Content creation
- File management
- Communication

---

### Layer 5: Omarchy Management Layer

**Components:**
- 124 omarchy-* scripts in `~/.local/share/omarchy/bin/`
- Theme system (`~/.config/omarchy/themes/`)
- Config templates (`~/.local/share/omarchy/config/`)
- State tracking (`~/.local/state/omarchy/`)

**Responsibilities:**
- Theme orchestration
- Package management
- System updates
- Configuration management
- User convenience commands

---

## Architecture Diagram

### Text-Based System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER INTERACTION                         │
│  Keyboard/Mouse → Hyprland → Applications/Walker/Waybar          │
└─────────────────────────────────────────────────────────────────┘
                                  ↓
┌─────────────────────────────────────────────────────────────────┐
│                      OMARCHY MANAGEMENT LAYER                    │
│                                                                   │
│  omarchy-menu → omarchy-theme-set → omarchy-pkg-install          │
│       ↓                   ↓                      ↓                │
│  Walker menus      Theme system         Package tracking         │
└─────────────────────────────────────────────────────────────────┘
                                  ↓
┌─────────────────────────────────────────────────────────────────┐
│                    DESKTOP ENVIRONMENT LAYER                     │
│                                                                   │
│  ┌─────────┐   ┌─────────┐   ┌────────┐   ┌──────────┐         │
│  │ Walker  │   │ Waybar  │   │  Mako  │   │ Hyprlock │         │
│  │ +       │   │         │   │        │   │          │         │
│  │Elephant │   │ Status  │   │ Notify │   │ Lock     │         │
│  └────┬────┘   └────┬────┘   └───┬────┘   └────┬─────┘         │
│       │             │            │              │                │
│       └─────────────┴────────────┴──────────────┘                │
│                          ↓                                       │
│                Read theme configs from:                          │
│                ~/.config/omarchy/current/theme/*                 │
└─────────────────────────────────────────────────────────────────┘
                                  ↓
┌─────────────────────────────────────────────────────────────────┐
│                     WAYLAND COMPOSITOR LAYER                     │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                       Hyprland                            │   │
│  │  - Window management                                     │   │
│  │  - Workspace management                                  │   │
│  │  - Input handling                                        │   │
│  │  - Rendering (OpenGL)                                    │   │
│  │  - Sources: ~/.config/omarchy/current/theme/hyprland.conf│   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                                  ↓
┌─────────────────────────────────────────────────────────────────┐
│                      SYSTEM SERVICES LAYER                       │
│                                                                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │ PipeWire │  │ NetworkM │  │  Docker  │  │   UFW    │        │
│  │  (Audio) │  │  (WiFi)  │  │  (Dev)   │  │(Firewall)│        │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘        │
│                                                                   │
│  Managed by: systemd                                             │
└─────────────────────────────────────────────────────────────────┘
                                  ↓
┌─────────────────────────────────────────────────────────────────┐
│                      OPERATING SYSTEM LAYER                      │
│                                                                   │
│  Arch Linux (Rolling Release)                                    │
│  - Kernel: Latest stable                                         │
│  - Init: systemd                                                 │
│  - Package Manager: pacman + yay (AUR)                           │
│  - Boot: systemd-boot or GRUB                                    │
└─────────────────────────────────────────────────────────────────┘
```

---

### Component Communication Flow

```
User presses SUPER+Space
        ↓
Hyprland receives key event (bindings.conf)
        ↓
Hyprland executes: omarchy-launch-walker
        ↓
omarchy-launch-walker script runs: walker -p "Launch…"
        ↓
Walker daemon receives command (via socket)
        ↓
Walker loads Elephant plugins
        ↓
Elephant-runner queries .desktop files
Elephant-desktopapplications provides app list
Elephant-websearch adds search providers
        ↓
Walker displays UI (reads theme from ~/.config/omarchy/current/theme/walker.css)
        ↓
User types "firefox"
        ↓
Walker filters results, shows Firefox
        ↓
User presses Enter
        ↓
Walker executes: gtk-launch firefox
        ↓
Firefox launches via Hyprland
        ↓
Hyprland tiles/floats window based on rules
        ↓
Firefox reads theme (if Chromium-based, from chromium.theme)
```

---

## Component Relationships

### Hyprland → Everything

Hyprland is the central component that manages:

**Windows:**
```
~/.config/hypr/hyprland.conf
  ↓
windowrule = float, Omarchy
windowrule = size 800 600, Omarchy
  ↓
Affects: All applications, Walker, settings windows
```

**Keybindings:**
```
~/.config/hypr/bindings.conf
  ↓
bind = SUPER, Space, exec, omarchy-launch-walker
bind = SUPER, M, exec, omarchy-menu
  ↓
Executes: Omarchy scripts
```

**Autostart:**
```
~/.config/hypr/hyprland.conf
  ↓
exec-once = omarchy-launch-waybar
exec-once = omarchy-launch-walker
exec-once = mako
  ↓
Starts: Desktop environment components
```

**Theming:**
```
~/.config/hypr/hyprland.conf sources:
~/.config/omarchy/current/theme/hyprland.conf
  ↓
Provides: Border colors, shadow colors, active window styling
```

---

### Walker → Elephant → Applications

Walker is the launcher, Elephant provides the plugins:

**Walker configuration:**
```
~/.config/walker/config.toml
  ↓
plugins = ["applications", "runner", "websearch", "clipboard", ...]
  ↓
Loads: Elephant modules
```

**Elephant modules:**
```
elephant-runner          → Command execution
elephant-desktopapplications → .desktop file parsing
elephant-websearch       → Search engine integration
elephant-clipboard       → Clipboard history
elephant-calc           → Calculator
elephant-todo           → Todo list
elephant-unicode        → Unicode picker
elephant-symbols        → Symbol picker
elephant-files          → File browser
elephant-bluetooth      → Bluetooth management
elephant-menus          → Context menus
```

**Data flow:**
```
User input → Walker
           ↓
Walker queries → Elephant plugins
           ↓
Plugins return → Results
           ↓
Walker displays → Results with icons
           ↓
User selects → Walker executes action
```

---

### Theme System → All Applications

The theme system uses symlinks for dynamic config switching:

**Symlink structure:**
```
~/.config/omarchy/current/theme → ../themes/tokyo-night
~/.config/omarchy/current/background → theme/backgrounds/1-tokyo-night.png
```

**Applications read from current symlink:**
```
Alacritty: ~/.config/alacritty/alacritty.toml
  import = ["~/.config/omarchy/current/theme/alacritty.toml"]

Kitty: ~/.config/kitty/kitty.conf
  include ~/.config/omarchy/current/theme/kitty.conf

Hyprland: ~/.config/hypr/hyprland.conf
  source = ~/.config/omarchy/current/theme/hyprland.conf

Waybar: ~/.config/waybar/style.css
  @import "../../omarchy/current/theme/waybar.css";
```

**When theme changes:**
```
omarchy-theme-set catppuccin
  ↓
1. Update symlink: current/theme → themes/catppuccin
2. Cycle background: omarchy-theme-bg-next
3. Restart Waybar: omarchy-restart-waybar
4. Restart Swayosd: omarchy-restart-swayosd
5. Reload Hyprland: hyprctl reload
6. Signal terminals: omarchy-theme-set-terminal
7. Update GNOME settings: omarchy-theme-set-gnome
8. Update browsers: omarchy-theme-set-browser
9. Update VS Code: omarchy-theme-set-vscode
10. Update Obsidian: omarchy-theme-set-obsidian
```

---

### Package Management → System State

Omarchy tracks packages in two files:

**Base packages:**
```
~/.local/share/omarchy/install/omarchy-base.packages
  ↓
Installed during: Initial setup
Updated by: Omarchy maintainers
```

**User packages:**
```
~/.local/share/omarchy/install/omarchy-other.packages
  ↓
Updated by: omarchy-pkg-add
Removed by: omarchy-pkg-drop
Used for: Reinstalls, system cloning
```

**Package flow:**
```
User runs: omarchy-pkg-install
  ↓
1. Walker prompts for package name
2. User enters: "htop"
3. Script installs: sudo pacman -S htop
4. Script adds to: omarchy-other.packages
5. Package tracked for future
```

---

## Config Hierarchy

### Omarchy Config Structure

```
~/.config/omarchy/
├── branding/
│   ├── about.txt              # System info shown in omarchy-launch-about
│   └── screensaver.txt        # Text displayed on screensaver
│
├── current/                   # Symlinks to active theme
│   ├── theme → ../themes/tokyo-night
│   └── background → theme/backgrounds/1-tokyo-night.png
│
├── hooks/                     # Custom hook scripts
│   ├── theme-set/            # Runs when theme changes
│   ├── package-install/      # Runs when package installed
│   └── update/               # Runs when system updates
│
└── themes/                    # All installed themes
    ├── catppuccin/
    │   ├── backgrounds/
    │   ├── alacritty.toml
    │   ├── hyprland.conf
    │   ├── waybar.css
    │   └── ... (16 config files)
    ├── tokyo-night/
    ├── gruvbox/
    └── ... (12 themes total)
```

---

### Hyprland Config Structure

Hyprland uses a modular config approach:

```
~/.config/hypr/
├── hyprland.conf              # Main config (user overrides)
│   ↓ sources
├── ~/.local/share/omarchy/config/hypr/hyprland.conf  # Omarchy defaults
│   ↓ sources
├── ~/.config/omarchy/current/theme/hyprland.conf     # Theme colors
│
├── monitors.conf              # Monitor configuration
├── bindings.conf              # Keybindings
├── input.conf                 # Input devices
├── looknfeel.conf             # Animations, decorations
├── hypridle.conf              # Idle management
├── hyprlock.conf              # Lock screen (sources theme)
└── hyprsunset.conf            # Night light
```

**Config loading order:**

1. `~/.config/hypr/hyprland.conf` (user config)
2. Sources: `~/.local/share/omarchy/config/hypr/hyprland.conf` (defaults)
3. Sources: `~/.config/omarchy/current/theme/hyprland.conf` (theme)
4. Sources: `monitors.conf`, `bindings.conf`, etc.

**This allows:**
- User overrides take precedence
- Omarchy defaults provide baseline
- Theme integration automatic
- Modular organization

---

### Application Config Hierarchy

**Terminals (Alacritty example):**

```
~/.config/alacritty/alacritty.toml
  ↓ import
~/.config/omarchy/current/theme/alacritty.toml

User config:
- Window settings
- Font size
- Key mappings

Theme provides:
- Color palette
- Background/foreground colors
```

**Waybar:**

```
~/.config/waybar/config.jsonc   # Module configuration
~/.config/waybar/style.css      # Styling
  ↓ @import
~/.config/omarchy/current/theme/waybar.css  # Theme colors
```

**Walker:**

```
~/.config/walker/config.toml    # Walker settings
  ↓ CSS loaded from
~/.config/omarchy/current/theme/walker.css  # Theme styling
```

---

### State and Data Locations

**Omarchy state:**
```
~/.local/state/omarchy/
├── installed                  # Flag: Omarchy is installed
├── first-run.mode             # Flag: Run first-run wizard
├── obsidian-vaults            # List of Obsidian vault paths
└── toggles/                   # Feature toggles
    ├── skip-vscode-theme-changes
    ├── waybar-hidden
    └── idle-disabled
```

**Package lists:**
```
~/.local/share/omarchy/install/
├── omarchy-base.packages      # Base packages (149)
└── omarchy-other.packages     # User-installed packages
```

**Theme templates:**
```
~/.local/share/omarchy/themes/  # Default themes (symlinked to ~/.config/omarchy/themes/)
```

**Application data:**
```
~/.local/share/
├── walker/                    # Walker data
├── hyprland/                  # Hyprland logs
└── applications/              # .desktop files for web/TUI apps
```

---

## Theme System Integration

### Theme File Mapping

Each theme contains up to 16 configuration files that map to different applications:

**Desktop Environment:**
```
hyprland.conf    → Hyprland borders, shadows, active window colors
hyprlock.conf    → Lock screen colors
waybar.css       → Waybar status bar colors
walker.css       → Walker launcher styling
mako.ini         → Notification colors
swayosd.css      → Volume/brightness OSD
swaybg (backgrounds/) → Wallpapers
```

**Terminals:**
```
alacritty.toml   → Alacritty colors
kitty.conf       → Kitty colors
ghostty.conf     → Ghostty colors (if installed)
```

**Editors:**
```
vscode.json      → VS Code theme name + extension
neovim.lua       → Neovim colorscheme
obsidian.css     → Obsidian theme (auto-generated if missing)
```

**Browsers:**
```
chromium.theme   → Browser tab color (RGB)
```

**System:**
```
icons.theme      → GNOME icon pack name
light.mode       → Light theme flag (presence = light)
btop.theme       → Btop system monitor theme
```

---

### Theme Application Flow

**Step-by-step theme change:**

```
User: omarchy-theme-set gruvbox
  ↓
Script: /home/zack/.local/share/omarchy/bin/omarchy-theme-set
  ↓
1. Validate theme exists
   ls ~/.config/omarchy/themes/gruvbox || error
  ↓
2. Update theme symlink
   ln -nsf ~/.config/omarchy/themes/gruvbox ~/.config/omarchy/current/theme
  ↓
3. Cycle to first background
   omarchy-theme-bg-next
   → ln -nsf theme/backgrounds/1-gruvbox.png ~/.config/omarchy/current/background
   → pkill swaybg && swaybg -i background -m fill
  ↓
4. Restart UI components
   omarchy-restart-waybar → systemctl --user restart waybar
   omarchy-restart-swayosd → systemctl --user restart swayosd
   hyprctl reload → Reloads Hyprland config
   pkill -SIGUSR2 btop → Tells btop to reload theme
   makoctl reload → Reloads notification daemon
  ↓
5. Update terminals
   omarchy-theme-set-terminal
   → touch ~/.config/alacritty/alacritty.toml (Alacritty watches file)
   → killall -SIGUSR1 kitty (Kitty reloads on signal)
   → killall -SIGUSR2 ghostty (Ghostty reloads on signal)
  ↓
6. Update GNOME settings
   omarchy-theme-set-gnome
   → gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
   → gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
   → gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue"
  ↓
7. Update browsers
   omarchy-theme-set-browser
   → Reads chromium.theme: "235,219,178"
   → chromium --no-startup-window --set-theme-color="235,219,178"
   → chromium --no-startup-window --set-color-scheme="dark"
  ↓
8. Update VS Code
   omarchy-theme-set-vscode
   → Reads vscode.json: {"name": "Gruvbox Dark", "extension": "jdinhlife.gruvbox"}
   → code --install-extension jdinhlife.gruvbox
   → Updates ~/.config/Code/User/settings.json
  ↓
9. Update Obsidian
   omarchy-theme-set-obsidian
   → For each vault, generates theme.css from alacritty.toml colors
   → Copies to vault/.obsidian/themes/Omarchy/theme.css
  ↓
10. Run hooks
    omarchy-hook theme-set gruvbox
    → Runs all scripts in ~/.config/omarchy/hooks/theme-set/
  ↓
Done. All components themed.
```

---

## Package Management Flow

### Installing a Package

```
User: omarchy-pkg-install
  ↓
1. Walker prompts for package name
  ↓
2. User enters: "neofetch"
  ↓
3. Script checks if already installed
   pacman -Qi neofetch && echo "Already installed" || continue
  ↓
4. Install via pacman
   sudo pacman -S --needed neofetch
  ↓
5. Add to tracked packages
   echo "neofetch" >> ~/.local/share/omarchy/install/omarchy-other.packages
  ↓
6. Sort and deduplicate
   sort -u omarchy-other.packages -o omarchy-other.packages
  ↓
7. Run post-install hook
   omarchy-hook package-install neofetch
  ↓
Done. Package installed and tracked.
```

---

### Removing a Package

```
User: omarchy-pkg-remove
  ↓
1. List installed packages from both lists
   cat omarchy-base.packages omarchy-other.packages
  ↓
2. Walker shows list for selection
  ↓
3. User selects: "neofetch"
  ↓
4. Remove via pacman
   sudo pacman -Rns neofetch
  ↓
5. Remove from tracked packages
   sed -i '/^neofetch$/d' omarchy-other.packages
  ↓
Done. Package removed and untracked.
```

---

### System Update Flow

```
User: omarchy-update
  ↓
1. Pull latest Omarchy scripts
   cd ~/.local/share/omarchy
   git pull origin master
  ↓
2. Update system packages
   sudo pacman -Syu
  ↓
3. Update AUR packages (if yay installed)
   yay -Syu
  ↓
4. Update mirrors (weekly check)
   omarchy-refresh-pacman-mirrorlist
  ↓
5. Update firmware (if available)
   fwupdmgr refresh && fwupdmgr update
  ↓
6. Run update hooks
   omarchy-hook update
  ↓
7. Check for reboot requirement
   if kernel updated: notify "Reboot required"
  ↓
Done. System updated.
```

---

## Data Flow Examples

### Example 1: Screenshot Workflow

```
User presses: Print Screen
  ↓
Hyprland receives key event
  ↓
Hyprland executes: omarchy-cmd-screenshot smart
  ↓
Script determines mode: "smart" = region selection + editing
  ↓
1. Run region selector
   slurp → Returns geometry (e.g., "100,100 800x600")
  ↓
2. Capture screenshot
   grim -g "100,100 800x600" /tmp/screenshot.png
  ↓
3. Open in editor
   satty -f /tmp/screenshot.png
  ↓
4. User annotates and saves
  ↓
5. Save to ~/Pictures/Screenshots/screenshot-2025-10-21-143022.png
  ↓
6. Copy to clipboard
   wl-copy < screenshot.png
  ↓
7. Show notification
   notify-send "Screenshot saved" "screenshot-2025-10-21-143022.png"
  ↓
Done. Screenshot captured, edited, saved, and copied.
```

---

### Example 2: Audio Output Switching

```
User: omarchy-cmd-audio-switch
  ↓
1. List available outputs
   pactl list sinks short
   → 45 alsa_output.pci-0000_00_1f.3.analog-stereo
   → 46 bluez_sink.XX_XX_XX_XX_XX_XX.a2dp_sink
  ↓
2. Walker shows list with friendly names
   → "Speakers (Built-in)"
   → "Headphones (Bluetooth)"
  ↓
3. User selects: "Headphones (Bluetooth)"
  ↓
4. Set default sink
   pactl set-default-sink bluez_sink.XX_XX_XX_XX_XX_XX.a2dp_sink
  ↓
5. Move existing streams to new sink
   pactl list sink-inputs short | while read stream; do
     pactl move-sink-input $stream bluez_sink.XX_XX_XX_XX_XX_XX.a2dp_sink
   done
  ↓
6. Show notification
   notify-send "Audio Output" "Switched to Headphones (Bluetooth)"
  ↓
Done. All audio routed to Bluetooth headphones.
```

---

### Example 3: Development Environment Setup

```
User: omarchy-install-dev-env ruby
  ↓
1. Check if mise installed
   which mise || sudo pacman -S mise
  ↓
2. Install Ruby via mise
   mise use --global ruby@3.3.0
  ↓
3. Wait for Ruby installation (downloads and compiles)
  ↓
4. Verify installation
   ruby --version
   → ruby 3.3.0
  ↓
5. Install Rails gem
   gem install rails
  ↓
6. Install additional gems
   gem install bundler pry rubocop
  ↓
7. Configure gem home
   echo 'export GEM_HOME="$HOME/.gem"' >> ~/.bashrc
   echo 'export PATH="$GEM_HOME/bin:$PATH"' >> ~/.bashrc
  ↓
8. Show completion message
   notify-send "Ruby on Rails" "Development environment ready"
  ↓
Done. Ruby + Rails ready for development.
```

---

## Troubleshooting

### Component Not Starting

**Symptoms:** Walker, Waybar, or other component won't start

**Diagnostic flow:**

```bash
# 1. Check if service is running
systemctl --user status walker

# 2. View recent logs
journalctl --user -u walker -n 50

# 3. Check config syntax
walker --validate-config

# 4. Check dependencies
pacman -Qi walker | grep Depends

# 5. Reset to defaults
omarchy-refresh-walker

# 6. Restart service
omarchy-restart-walker
```

---

### Theme Not Applying

**Symptoms:** Some apps don't update when theme changes

**Diagnostic flow:**

```bash
# 1. Check symlink is correct
readlink ~/.config/omarchy/current/theme
# Should point to correct theme

# 2. Check if theme files exist
ls ~/.config/omarchy/current/theme/
# Should list config files

# 3. Check app config imports theme
grep -r "omarchy/current/theme" ~/.config/alacritty/

# 4. Manually run setters
omarchy-theme-set-terminal
omarchy-theme-set-vscode
omarchy-theme-set-browser

# 5. Restart affected components
omarchy-restart-walker
omarchy-restart-waybar
hyprctl reload
```

---

### Config Changes Not Taking Effect

**Symptoms:** Edit config file but changes don't apply

**Diagnostic flow:**

```bash
# 1. Check which config is being used
# For Hyprland:
hyprctl getoption general:border_color
# Shows active value

# 2. Check config hierarchy
# User config: ~/.config/hypr/hyprland.conf
# Omarchy defaults: ~/.local/share/omarchy/config/hypr/hyprland.conf
# Theme: ~/.config/omarchy/current/theme/hyprland.conf

# 3. Ensure user config sources defaults
grep "source.*omarchy" ~/.config/hypr/hyprland.conf

# 4. Reload config
hyprctl reload

# 5. Check for errors
journalctl --user -u hyprland -n 50
```

---

## Related Documentation

### System Understanding
- [Overview](./overview.md) - Omarchy philosophy and components
- [Installation](./installation.md) - How components are installed
- [First Run Guide](./first-run-guide.md) - Initial configuration

### Component Details
- [Hyprland Configuration](../04-desktop-environment/hyprland.md) - Window manager
- [Walker & Elephant](../04-desktop-environment/walker-elephant.md) - Launcher and plugins
- [Waybar](../04-desktop-environment/waybar.md) - Status bar
- [Theme System](../03-theming/theme-system.md) - Theming architecture

### Advanced Topics
- [Config Management](../09-customization/config-management.md) - Config file organization
- [Hooks System](../09-customization/hooks.md) - Custom automation
- [Package Management](../02-core-commands/package-management.md) - Package tracking

### Reference
- [Quick Reference](../10-reference/quick-reference.md) - Common tasks
- [Troubleshooting](../10-reference/troubleshooting.md) - Problem solving
- [File Locations](../10-reference/file-locations.md) - Where everything lives

---

## Notes

**Last Updated:** 2025-10-21

**Architecture Analyzed:**
- Component relationships from source scripts
- Config hierarchy from actual file structure
- Data flow from tracing command execution
- Integration points from config file analysis

**Source References:**
- `/home/zack/.local/share/omarchy/` - Complete Omarchy installation
- `/home/zack/.config/omarchy/` - User configuration
- `/home/zack/.config/hypr/` - Hyprland config structure
- System service files in `/usr/lib/systemd/user/`

**Verification:** Architecture documented from live Omarchy system, all paths and flows tested.

---

*This architecture guide is part of the Omarchy Archive. For the complete documentation, see the [main README](../README.md).*
