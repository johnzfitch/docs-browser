# Omarchy Overview

**Purpose:** Introduction to Omarchy and its philosophy
**Use Case:** Understanding what Omarchy is and whether it's right for you

*Last Updated: 2025-10-21*

---

## Quick Start (30-Second Guide)

```bash
# Access the main menu
omarchy-menu

# Change your theme
omarchy-theme-set catppuccin

# Launch an application
omarchy-launch-walker

# Take a screenshot
omarchy-cmd-screenshot smart

# Get help
SUPER + O  # Opens documentation browser
```

---

## Table of Contents

- [What is Omarchy?](#what-is-omarchy)
- [Philosophy and Design Principles](#philosophy-and-design-principles)
- [Key Components Overview](#key-components-overview)
- [Who Should Use Omarchy](#who-should-use-omarchy)
- [Getting Started](#getting-started)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Related Documentation](#related-documentation)

---

## What is Omarchy?

Omarchy is DHH's opinionated Arch Linux + Hyprland desktop system. It's a complete, batteries-included Linux distribution that combines the power and flexibility of Arch Linux with the modern, tiling window management of Hyprland.

Unlike minimal window manager setups that require hours of configuration, Omarchy provides a fully-featured desktop environment out of the box. It's designed for developers and power users who want a beautiful, productive system without spending weeks tweaking config files.

**Key characteristics:**

- **Opinionated:** Thoughtful defaults based on real-world usage by DHH and the Basecamp team
- **Complete:** Includes everything from themes to development tools to media applications
- **Wayland-native:** Built on Hyprland, leveraging modern display server technology
- **Developer-focused:** Optimized for programming with integrated dev environments, Docker, version control
- **Cohesive:** Every component works together - themes apply across 15+ applications simultaneously
- **Maintainable:** Single-command updates keep your entire system in sync

---

## Philosophy and Design Principles

### 1. Opinionated Excellence Over Infinite Choice

Omarchy doesn't try to be everything to everyone. Instead, it makes strong choices:

- **One launcher:** Walker (not rofi, dmenu, wofi, or 10 others)
- **One notification system:** Mako (integrated with themes)
- **One status bar:** Waybar (pre-configured with useful modules)
- **Three terminals:** Alacritty, Kitty, Ghostty (all theme-integrated)

This reduces decision fatigue and ensures everything works together seamlessly.

### 2. Batteries Included, Not Assembly Required

Traditional Arch + Hyprland setups leave you with a black screen and a TODO list. Omarchy includes:

- Pre-configured Hyprland with sensible keybindings
- Complete theme system with 12 curated themes
- Walker launcher integrated with applications, clipboard, files, and search
- Elephant plugins for enhanced functionality (calculator, todo, clipboard history)
- Development environments ready to install (Ruby, Node, Python, Go, Rust, etc.)
- Media tools (OBS, Kdenlive, Satty for screenshots)
- Productivity apps (Obsidian, LibreOffice, Typora)

### 3. Unified Experience Through Themes

When you change a theme in Omarchy, it updates:

- Terminal emulators (Alacritty, Kitty, Ghostty)
- Window manager (Hyprland borders and effects)
- Status bar (Waybar colors)
- Lock screen (Hyprlock)
- Editors (VS Code, Cursor, Neovim)
- Browsers (Chromium, Brave tab colors)
- Utilities (btop, walker, notifications)

This creates a cohesive visual experience, not a patchwork of different color schemes.

### 4. Developer-First Workflows

Omarchy prioritizes developer needs:

- **Fast access to projects:** Walker integrates with your filesystem
- **Integrated version control:** GitHub CLI, Lazygit pre-installed
- **Containerized development:** Docker + Docker Compose ready
- **Multi-language support:** Mise for runtime management
- **Thoughtful keybindings:** SUPER+Return for terminal, SUPER+Space for launcher, SUPER+Q to close windows

### 5. Maintainability Over Customization

While Omarchy is highly customizable, it emphasizes maintainability:

- **Single update command:** `omarchy-update` keeps scripts, configs, and packages in sync
- **Declarative package lists:** System tracks what you've installed in `omarchy-base.packages` and `omarchy-other.packages`
- **Config refresh:** `omarchy-refresh-config` restores defaults if you break something
- **Version control ready:** All configs are in `~/.config/omarchy/`, easy to git track

### 6. Graceful Defaults, Easy Overrides

Omarchy configs use a hierarchy:

```
~/.config/hypr/hyprland.conf      → Your overrides (optional)
  ↓ imports
~/.local/share/omarchy/config/hypr/hyprland.conf  → Omarchy defaults
  ↓ sources
~/.config/omarchy/current/theme/hyprland.conf     → Theme colors
```

This lets you:

- Use Omarchy as-is (no overrides needed)
- Tweak specific settings (add to your local config)
- Keep theme integration (themes apply automatically)

---

## Key Components Overview

### Hyprland - The Window Manager

**What it does:** Manages windows, workspaces, keybindings, and effects

**Why Hyprland:**
- Modern Wayland compositor (not legacy X11)
- GPU-accelerated animations and effects
- Tiling by default, floating when needed
- Extensive customization through config files

**Key features in Omarchy:**
- 10 workspaces (SUPER+1 through SUPER+9, plus 0)
- Dynamic tiling with automatic layouts
- Window borders that match your theme
- Special workspace for scratchpad apps
- Pre-configured bindings for common tasks

**See:** [Hyprland Configuration](../04-desktop-environment/hyprland.md)

---

### Walker - The Launcher

**What it does:** Application launcher, clipboard manager, file browser, web search

**Why Walker:**
- Native Wayland performance (written in Go)
- Multiple modes in one tool (apps, clipboard, files, search)
- Extensible through Elephant plugins
- Integrates with Omarchy theme system

**Key features in Omarchy:**
- Launch apps with SUPER+Space
- Search clipboard history
- Browse recent files
- Calculator (type math expressions)
- Unicode picker, todo list, symbols

**See:** [Walker & Elephant](../04-desktop-environment/walker-elephant.md)

---

### Elephant - The Plugin System

**What it does:** Extends Walker with additional functionality

**Modules included:**
- **elephant-runner:** Application launcher
- **elephant-clipboard:** Clipboard history manager
- **elephant-files:** File browser and recent files
- **elephant-websearch:** Search engines integration
- **elephant-calc:** Calculator
- **elephant-todo:** Todo list manager
- **elephant-unicode:** Unicode character picker
- **elephant-symbols:** Math and special symbols
- **elephant-menus:** Context menu integration
- **elephant-bluetooth:** Bluetooth device management
- **elephant-desktopapplications:** .desktop file integration

**Why Elephant:**
- Modular design (install only what you need)
- Native performance (written in Go)
- Integrates with Walker seamlessly
- Provides features typically found in multiple separate tools

**See:** [Walker & Elephant](../04-desktop-environment/walker-elephant.md)

---

### Theme System - The Visual Glue

**What it does:** Provides unified color schemes across all applications

**Included themes (12 total):**
- Catppuccin (pastel, dark)
- Catppuccin Latte (pastel, light)
- Tokyo Night (vibrant, dark)
- Gruvbox (retro, warm)
- Nord (cool, arctic)
- Rose Pine (elegant, muted)
- Everforest (natural, green)
- Flexoki Light (minimal, beige)
- Kanagawa (muted, Japanese)
- Matte Black (minimal, OLED)
- Osaka Jade (vibrant, neon)
- Ristretto (warm, coffee)

**How it works:**
- Themes stored in `~/.config/omarchy/themes/`
- Current theme symlinked at `~/.config/omarchy/current/theme`
- Switch with `omarchy-theme-set <name>`
- Applications read from current symlink
- Automatic restarts ensure changes apply immediately

**See:** [Theme System](../03-theming/theme-system.md)

---

### Package Management - The Software Layer

**What it does:** Manages system packages, AUR packages, web apps, and TUI apps

**Package lists:**
- `omarchy-base.packages` - 149 core packages installed during setup
- `omarchy-other.packages` - Additional packages you install later

**Commands:**
- `omarchy-pkg-install` - Install from official Arch repos
- `omarchy-pkg-aur-install` - Install from AUR (using yay)
- `omarchy-webapp-install` - Install web applications as desktop apps
- `omarchy-tui-install` - Install TUI (terminal UI) applications
- `omarchy-pkg-remove` - Uninstall packages

**Base packages include:**
- **Desktop:** Hyprland, Waybar, Walker, Mako, Alacritty, Kitty
- **Development:** Docker, Mise, Lazygit, GitHub CLI, Neovim
- **Media:** OBS Studio, Kdenlive, MPV, Satty, GPU Screen Recorder
- **Productivity:** Obsidian, Typora, LibreOffice, Nautilus
- **Utilities:** Bat, Eza, Fd, Fzf, Ripgrep, Btop

**See:** [Package Management](../02-core-commands/package-management.md)

---

## Who Should Use Omarchy

### Ideal For:

**Developers who want productivity over tinkering:**
- You want a powerful dev environment without spending weeks configuring
- You value keyboard-driven workflows
- You need Docker, version control, and multiple language runtimes
- You want consistent theming across editors, terminals, and browsers

**Linux enthusiasts who appreciate curation:**
- You like Arch Linux philosophy (rolling release, simplicity)
- You want Wayland's modern features (better HiDPI, security, performance)
- You appreciate thoughtful defaults over infinite options
- You're willing to trade some flexibility for cohesiveness

**Designers and content creators on Linux:**
- You need OBS, Kdenlive, Pinta, GIMP
- You want a beautiful desktop that's also functional
- You value consistent theming across creative tools
- You need reliable hardware support (audio, displays, tablets)

**Basecamp employees and Rails developers:**
- Pre-configured for Ruby on Rails development
- DHH's personal setup, refined over years
- Optimized for Basecamp workflows
- Community of users with similar needs

---

### Not Ideal For:

**Users who need maximum stability:**
- Omarchy uses Arch (rolling release) which updates frequently
- Hyprland is cutting-edge, sometimes buggy
- If you need "just works" stability, use Ubuntu LTS or Fedora

**Users who want gaming-first:**
- While Steam and gaming work, Omarchy isn't optimized for it
- No pre-installed game launchers or optimizations
- Better options exist (Nobara, ChimeraOS)

 

**Users new to Linux:**
- Omarchy assumes familiarity with Linux concepts
- Terminal usage is frequent (though optional)
- Troubleshooting requires some Linux knowledge
- Consider Pop!_OS or Linux Mint first

**Users who want a minimal, DIY setup:**
- Omarchy is opinionated and includes many packages
- If you want to build from scratch, use vanilla Arch + Hyprland
- Omarchy's strength is curation, not minimalism

---

## Getting Started

### Installation

Omarchy installs via a single command on a fresh Arch Linux system:

```bash
bash <(curl -Ls https://omarchy.org/boot.sh)
```

This downloads and runs the bootstrap script which:

1. Installs git
2. Clones the Omarchy repository to `~/.local/share/omarchy/`
3. Runs the main installer (`install.sh`)
4. Sets up Hyprland as your session manager
5. Reboots into Omarchy

**Full installation guide:** [Installation](./installation.md)

---

### First Run

After installation, Omarchy runs a first-run wizard (`omarchy-cmd-first-run`) that helps you:

- Configure WiFi
- Set up firewall (UFW)
- Configure DNS resolver
- Set GNOME theme preferences
- Enable battery monitor (laptops)
- Show welcome message

**First-run guide:** [First Run Guide](./first-run-guide.md)

---

### Using Omarchy Menu

The Omarchy menu (`omarchy-menu` or SUPER+M) is your control center:

```bash
omarchy-menu
```

**Main categories:**

- **Apps:** Launch applications (same as Walker)
- **Learn:** Access documentation and tutorials
- **Trigger:** Screenshots, screen recording, file sharing
- **Style:** Change themes, fonts, backgrounds
- **Setup:** Configure audio, WiFi, Bluetooth, monitors
- **Install:** Add software (packages, AUR, web apps, dev environments)
- **Remove:** Uninstall software or themes
- **Update:** System updates, config refresh, firmware
- **About:** System information
- **System:** Lock, suspend, restart, shutdown

**Navigation:**

- Arrow keys to select
- Enter to confirm
- Escape to go back
- Type to filter options

---

## Examples

### Example 1: Basic - First Day with Omarchy

**Scenario:** You've just installed Omarchy and want to get oriented.

```bash
# After first login, Hyprland starts automatically
# You see a wallpaper, a top bar (Waybar), and nothing else

# Press SUPER+M to open the Omarchy menu
# (SUPER is usually the Windows key)

# Select "Learn" → "Keybindings" to see available shortcuts
# This opens a reference in Walker

# Press SUPER+Space to open Walker
# Type "firefox" and press Enter to launch browser

# Press SUPER+Return to open a terminal (Alacritty)
# Terminal opens with theme colors pre-applied

# Press SUPER+Q to close the terminal

# Press SUPER+M again, navigate to "Style" → "Theme"
# Select "Tokyo Night" to change your color scheme
# Entire desktop updates immediately

# Press SUPER+M → "Learn" → "Omarchy" to read full manual
```

**Why This Works:**
- Omarchy menu provides guided navigation
- All core features accessible via keyboard
- Theme changes apply globally
- Documentation is built-in

---

### Example 2: Intermediate - Setting Up Development Environment

**Scenario:** You're a Rails developer and need Ruby, PostgreSQL, and Redis.

```bash
# Open Omarchy menu
omarchy-menu

# Navigate: Install → Development → Ruby on Rails
# This runs: omarchy-install-dev-env ruby
# Installs: Ruby (via mise), Rails gem, dependencies

# Back to menu: Install → Development → Docker DB
# This runs: omarchy-install-docker-dbs
# Installs: PostgreSQL, MySQL, Redis, Memcached containers

# Verify installation
mise list           # Shows Ruby version
docker ps -a        # Shows database containers

# Start PostgreSQL
docker start postgres

# Create new Rails app
rails new myapp --database=postgresql
cd myapp
rails db:create
rails server

# Open browser to localhost:3000
omarchy-launch-browser
# Navigate to http://localhost:3000
```

**Why This Works:**
- Omarchy includes `mise` for language version management
- Docker DB script creates ready-to-use containers
- All dev tools pre-configured and themed
- No manual setup of gem paths, Docker networks, etc.

---

### Example 3: Advanced - Customizing Your Workflow

**Scenario:** You want to add custom keybindings and create a personalized theme.

**Step 1: Add Custom Keybindings**

```bash
# Edit Hyprland bindings
nvim ~/.config/hypr/bindings.conf

# Add at end of file:
# bind = SUPER, B, exec, omarchy-launch-browser
# bind = SUPER, E, exec, nautilus
# bind = SUPER SHIFT, S, exec, omarchy-cmd-screenshot smart

# Reload Hyprland
hyprctl reload
```

**Step 2: Create Custom Theme**

```bash
# Copy existing theme as base
cp -r ~/.config/omarchy/themes/catppuccin ~/.config/omarchy/themes/my-theme

# Edit colors
nvim ~/.config/omarchy/themes/my-theme/alacritty.toml
# Change colors to your preference

# Add custom wallpaper
cp ~/Pictures/my-wallpaper.png ~/.config/omarchy/themes/my-theme/backgrounds/1-custom.png

# Apply your theme
omarchy-theme-set my-theme
```

**Step 3: Track Changes in Git**

```bash
# Initialize git in config directory
cd ~/.config/omarchy/
git init
git add .
git commit -m "Initial Omarchy customization"

# Create GitHub repo and push
gh repo create my-omarchy-config --private
git remote add origin git@github.com:yourusername/my-omarchy-config.git
git push -u origin master
```

**Why This Works:**
- Omarchy configs are designed to be extended
- Theme structure is simple (just config files + images)
- Git tracking allows you to sync across machines
- Custom configs survive `omarchy-update`

---

## Troubleshooting

### Omarchy Menu Won't Open

**Symptoms:** SUPER+M doesn't show menu, `omarchy-menu` command fails

**Causes:**
1. Walker service not running
2. Keybinding conflict
3. Omarchy scripts not in PATH

**Solutions:**

```bash
# Check if Walker is running
pgrep walker

# If not running, start it
omarchy-restart-walker

# Check keybinding
grep "omarchy-menu" ~/.config/hypr/bindings.conf

# Verify scripts are accessible
which omarchy-menu
# Should show: /home/yourusername/.local/share/omarchy/bin/omarchy-menu

# Add to PATH if missing (shouldn't be needed)
export PATH="$HOME/.local/share/omarchy/bin:$PATH"
```

---

### Theme Doesn't Apply to All Apps

**Symptoms:** Some apps update theme, others don't

**Cause:** Some applications weren't running during theme change

**Solution:**

```bash
# Manually restart affected components
omarchy-restart-walker
omarchy-restart-waybar
hyprctl reload

# Reload terminal configs
omarchy-theme-set-terminal

# For VS Code specifically
omarchy-theme-set-vscode

# For browsers
omarchy-theme-set-browser
```

**See:** [Theme System Troubleshooting](../03-theming/theme-system.md#troubleshooting)

---

### Screen Tearing or Performance Issues

**Symptoms:** Choppy animations, tearing during video playback

**Causes:**
1. VRR (Variable Refresh Rate) settings
2. Graphics driver issues
3. Monitor configuration

**Solutions:**

```bash
# Edit Hyprland config
nvim ~/.config/hypr/hyprland.conf

# Try disabling VRR
# misc {
#   vrr = 0
# }

# Or enable VRR with tear sync
# misc {
#   vrr = 2
# }

# Reload Hyprland
hyprctl reload

# Check monitor config
nvim ~/.config/hypr/monitors.conf

# Ensure refresh rate is correct
# monitor = DP-1, 2560x1440@144, 0x0, 1
```

---

## Related Documentation

### Essential Next Steps
- [Installation Guide](./installation.md) - Detailed installation process
- [First Run Guide](./first-run-guide.md) - Post-install configuration
- [Architecture](./architecture.md) - How Omarchy components fit together
- [Quick Reference](../10-reference/quick-reference.md) - Common commands and tasks

### Core Systems
- [Theme System](../03-theming/theme-system.md) - Complete theming guide
- [Package Management](../02-core-commands/package-management.md) - Installing and managing software
- [Hyprland Configuration](../04-desktop-environment/hyprland.md) - Window manager setup
- [Walker & Elephant](../04-desktop-environment/walker-elephant.md) - Launcher and plugins

### Customization
- [Keybindings](../09-customization/keybindings.md) - Keyboard shortcuts
- [Config Management](../09-customization/config-management.md) - Managing configuration files
- [Creating Themes](../03-theming/creating-themes.md) - Building custom themes

### Support
- [Troubleshooting](../10-reference/troubleshooting.md) - Common problems and solutions
- [FAQ](../10-reference/faq.md) - Frequently asked questions

---

## Notes

**Last Updated:** 2025-10-21

**Source Materials:**
- `/home/zack/.local/share/omarchy/boot.sh` - Bootstrap installer
- `/home/zack/.local/share/omarchy/install.sh` - Main installer
- `/home/zack/.local/share/omarchy/bin/omarchy-menu` - Menu system
- Omarchy philosophy and design discussions

**Verification:** All commands, features, and package counts verified on Omarchy system running Hyprland on Arch Linux.

---

*This overview is part of the Omarchy Archive. For the complete documentation, see the [main README](../README.md).*
