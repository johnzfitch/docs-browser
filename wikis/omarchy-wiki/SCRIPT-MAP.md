# Omarchy Script Index - Complete Mapping

**Purpose**: Map all 124 omarchy scripts to their documentation
**Last Updated**: 2025-10-21
**Total Scripts**: 124

---

## How to Use This Index

### Quick Lookup
```bash
# Find script documentation
grep "omarchy-theme-set" /home/zack/dev/lib/omarchy-archive/SCRIPT-MAP.md

# Then read the referenced file
```

### Script Categories

Scripts are organized into functional categories matching the archive structure:

- **Battery & Power** → 07-system-setup/power-management.md
- **Commands (cmd-)** → 02-core-commands/launcher-commands.md
- **Development** → 06-development/
- **Drive Management** → 07-system-setup/
- **Font Management** → 03-theming/fonts.md
- **Installation** → 02-core-commands/package-management.md
- **Launch Commands** → 02-core-commands/launcher-commands.md
- **Menu System** → 02-core-commands/system-management.md
- **Package Management** → 02-core-commands/package-management.md
- **Power Profiles** → 07-system-setup/power-management.md
- **Refresh/Restart** → 02-core-commands/system-management.md
- **Setup Tools** → 07-system-setup/
- **State Management** → 02-core-commands/system-management.md
- **Theme Management** → 03-theming/theme-system.md
- **Toggle Commands** → 08-utilities/utility-scripts.md
- **TUI Management** → 02-core-commands/package-management.md
- **Update System** → 02-core-commands/system-management.md
- **Version Management** → 02-core-commands/system-management.md
- **Webapp Management** → 02-core-commands/package-management.md
- **Windows VM** → 05-applications/productivity-apps.md

---

## Complete Script Index (A-Z)

### B

**omarchy-battery-monitor**
- **Category**: Power Management
- **Documentation**: `07-system-setup/power-management.md`
- **Purpose**: Monitor battery status and display notifications
- **Usage**: Runs as background service

---

### C

**omarchy-cmd-apple-display-brightness**
- **Category**: Commands
- **Documentation**: `08-utilities/utility-scripts.md`
- **Purpose**: Adjust Apple display brightness
- **Usage**: Hardware-specific utility

**omarchy-cmd-audio-switch**
- **Category**: Commands
- **Documentation**: `07-system-setup/audio-bluetooth-wifi.md`
- **Purpose**: Switch between audio outputs
- **Usage**: `omarchy-cmd-audio-switch`

**omarchy-cmd-close-all-windows**
- **Category**: Commands
- **Documentation**: `04-desktop-environment/window-management.md`
- **Purpose**: Close all open windows
- **Usage**: `omarchy-cmd-close-all-windows`

**omarchy-cmd-first-run**
- **Category**: Commands
- **Documentation**: `01-getting-started/first-run-guide.md`
- **Purpose**: First-run setup wizard
- **Usage**: Runs automatically on first boot

**omarchy-cmd-missing**
- **Category**: Commands
- **Documentation**: `02-core-commands/command-index.md`
- **Purpose**: Check for missing commands
- **Usage**: Internal utility

**omarchy-cmd-present**
- **Category**: Commands
- **Documentation**: `02-core-commands/command-index.md`
- **Purpose**: Check if command is present
- **Usage**: Internal utility

**omarchy-cmd-screenrecord**
- **Category**: Commands
- **Documentation**: `08-utilities/screenshot-screenrecord.md`
- **Purpose**: Record screen (region, display, with audio/webcam)
- **Usage**: `omarchy-cmd-screenrecord [region|output] [--with-audio] [--with-webcam]`

**omarchy-cmd-screenshot**
- **Category**: Commands
- **Documentation**: `08-utilities/screenshot-screenrecord.md`
- **Purpose**: Take screenshots with editing
- **Usage**: `omarchy-cmd-screenshot smart [clipboard]`

**omarchy-cmd-screensaver**
- **Category**: Commands
- **Documentation**: `08-utilities/utility-scripts.md`
- **Purpose**: Control screensaver
- **Usage**: `omarchy-cmd-screensaver`

**omarchy-cmd-share**
- **Category**: Commands
- **Documentation**: `08-utilities/file-sharing.md`
- **Purpose**: Share clipboard, file, or folder
- **Usage**: `omarchy-cmd-share [clipboard|file|folder]`

**omarchy-cmd-terminal-cwd**
- **Category**: Commands
- **Documentation**: `02-core-commands/launcher-commands.md`
- **Purpose**: Get current working directory of terminal
- **Usage**: Internal utility

---

### D

**omarchy-dev-add-migration**
- **Category**: Development
- **Documentation**: `06-development/language-environments.md`
- **Purpose**: Add omarchy migration script
- **Usage**: Development tool for omarchy itself

**omarchy-drive-info**
- **Category**: Drive Management
- **Documentation**: `07-system-setup/security-auth.md`
- **Purpose**: Display drive encryption info
- **Usage**: `omarchy-drive-info`

**omarchy-drive-select**
- **Category**: Drive Management
- **Documentation**: `07-system-setup/security-auth.md`
- **Purpose**: Select encrypted drive
- **Usage**: `omarchy-drive-select`

**omarchy-drive-set-password**
- **Category**: Drive Management
- **Documentation**: `07-system-setup/security-auth.md`
- **Purpose**: Set/change drive encryption password
- **Usage**: `omarchy-drive-set-password`

---

### F

**omarchy-font-current**
- **Category**: Font Management
- **Documentation**: `03-theming/fonts.md`
- **Purpose**: Display current system font
- **Usage**: `omarchy-font-current`

**omarchy-font-list**
- **Category**: Font Management
- **Documentation**: `03-theming/fonts.md`
- **Purpose**: List available fonts
- **Usage**: `omarchy-font-list`

**omarchy-font-set**
- **Category**: Font Management
- **Documentation**: `03-theming/fonts.md`
- **Purpose**: Set system font
- **Usage**: `omarchy-font-set "Font Name"`

---

### H

**omarchy-hook**
- **Category**: System
- **Documentation**: `09-customization/advanced-tweaks.md`
- **Purpose**: Hook system for custom scripts
- **Usage**: Internal utility

---

### I

**omarchy-install-chromium-google-account**
- **Category**: Installation
- **Documentation**: `05-applications/core-applications.md`
- **Purpose**: Set up Google account in Chromium
- **Usage**: `omarchy-install-chromium-google-account`

**omarchy-install-dev-env**
- **Category**: Installation
- **Documentation**: `06-development/language-environments.md`
- **Purpose**: Install development environments
- **Usage**: `omarchy-install-dev-env [ruby|node|python|go|rust|etc]`

**omarchy-install-docker-dbs**
- **Category**: Installation
- **Documentation**: `06-development/docker-setup.md`
- **Purpose**: Install Docker databases (PostgreSQL, MySQL, Redis)
- **Usage**: `omarchy-install-docker-dbs`

**omarchy-install-dropbox**
- **Category**: Installation
- **Documentation**: `05-applications/productivity-apps.md`
- **Purpose**: Install and configure Dropbox
- **Usage**: `omarchy-install-dropbox`

**omarchy-install-steam**
- **Category**: Installation
- **Documentation**: `05-applications/productivity-apps.md`
- **Purpose**: Install Steam gaming platform
- **Usage**: `omarchy-install-steam`

**omarchy-install-tailscale**
- **Category**: Installation
- **Documentation**: `07-system-setup/security-auth.md`
- **Purpose**: Install Tailscale VPN
- **Usage**: `omarchy-install-tailscale`

**omarchy-install-terminal**
- **Category**: Installation
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Install/switch terminal emulator
- **Usage**: `omarchy-install-terminal [alacritty|ghostty|kitty]`

**omarchy-install-vscode**
- **Category**: Installation
- **Documentation**: `06-development/editor-setup.md`
- **Purpose**: Install and configure VSCode
- **Usage**: `omarchy-install-vscode`

---

### L

**omarchy-launch-about**
- **Category**: Launch Commands
- **Documentation**: `02-core-commands/launcher-commands.md`
- **Purpose**: Display about/system info
- **Usage**: `omarchy-launch-about`

**omarchy-launch-browser**
- **Category**: Launch Commands
- **Documentation**: `02-core-commands/launcher-commands.md`
- **Purpose**: Launch default browser
- **Usage**: `omarchy-launch-browser [url]`

**omarchy-launch-editor**
- **Category**: Launch Commands
- **Documentation**: `02-core-commands/launcher-commands.md`
- **Purpose**: Launch default editor
- **Usage**: `omarchy-launch-editor [file]`

**omarchy-launch-floating-terminal-with-presentation**
- **Category**: Launch Commands
- **Documentation**: `02-core-commands/launcher-commands.md`
- **Purpose**: Launch floating terminal with presentation mode
- **Usage**: `omarchy-launch-floating-terminal-with-presentation [command]`

**omarchy-launch-hyprland-docs**
- **Category**: Launch Commands
- **Documentation**: `02-core-commands/launcher-commands.md`
- **Purpose**: Launch Hyprland documentation browser
- **Usage**: `omarchy-launch-hyprland-docs`

**omarchy-launch-or-focus**
- **Category**: Launch Commands
- **Documentation**: `02-core-commands/launcher-commands.md`
- **Purpose**: Launch app or focus if already running
- **Usage**: `omarchy-launch-or-focus [class] [command]`

**omarchy-launch-or-focus-webapp**
- **Category**: Launch Commands
- **Documentation**: `02-core-commands/launcher-commands.md`
- **Purpose**: Launch or focus web application
- **Usage**: `omarchy-launch-or-focus-webapp [name]`

**omarchy-launch-screensaver**
- **Category**: Launch Commands
- **Documentation**: `08-utilities/utility-scripts.md`
- **Purpose**: Launch screensaver
- **Usage**: `omarchy-launch-screensaver [force]`

**omarchy-launch-walker**
- **Category**: Launch Commands
- **Documentation**: `04-desktop-environment/walker-elephant.md`
- **Purpose**: Launch Walker application launcher
- **Usage**: `omarchy-launch-walker [options]`

**omarchy-launch-webapp**
- **Category**: Launch Commands
- **Documentation**: `02-core-commands/launcher-commands.md`
- **Purpose**: Launch web application
- **Usage**: `omarchy-launch-webapp [name|url]`

**omarchy-launch-wifi**
- **Category**: Launch Commands
- **Documentation**: `07-system-setup/audio-bluetooth-wifi.md`
- **Purpose**: Launch WiFi configuration
- **Usage**: `omarchy-launch-wifi`

**omarchy-lock-screen**
- **Category**: System
- **Documentation**: `07-system-setup/security-auth.md`
- **Purpose**: Lock screen
- **Usage**: `omarchy-lock-screen`

---

### M

**omarchy-menu**
- **Category**: Menu System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Main TUI menu for omarchy
- **Usage**: `omarchy-menu [submenu]`

**omarchy-menu-keybindings**
- **Category**: Menu System
- **Documentation**: `09-customization/keybindings.md`
- **Purpose**: Display keybindings reference
- **Usage**: `omarchy-menu-keybindings`

**omarchy-migrate**
- **Category**: System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Run omarchy migrations
- **Usage**: `omarchy-migrate`

---

### N

**omarchy-notification-dismiss**
- **Category**: Utility
- **Documentation**: `08-utilities/utility-scripts.md`
- **Purpose**: Dismiss all notifications
- **Usage**: `omarchy-notification-dismiss`

---

### P

**omarchy-pkg-add**
- **Category**: Package Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Add package to tracking list
- **Usage**: `omarchy-pkg-add [package]`

**omarchy-pkg-aur-accessible**
- **Category**: Package Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Check if AUR is accessible
- **Usage**: Internal utility

**omarchy-pkg-aur-install**
- **Category**: Package Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Install package from AUR
- **Usage**: `omarchy-pkg-aur-install`

**omarchy-pkg-drop**
- **Category**: Package Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Remove package from tracking list
- **Usage**: `omarchy-pkg-drop [package]`

**omarchy-pkg-ignored**
- **Category**: Package Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: List ignored packages
- **Usage**: `omarchy-pkg-ignored`

**omarchy-pkg-install**
- **Category**: Package Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Install package from official repos
- **Usage**: `omarchy-pkg-install`

**omarchy-pkg-missing**
- **Category**: Package Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: List missing packages
- **Usage**: `omarchy-pkg-missing`

**omarchy-pkg-pinned**
- **Category**: Package Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: List pinned packages
- **Usage**: `omarchy-pkg-pinned`

**omarchy-pkg-present**
- **Category**: Package Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Check if package is installed
- **Usage**: `omarchy-pkg-present [package]`

**omarchy-pkg-remove**
- **Category**: Package Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Remove installed package
- **Usage**: `omarchy-pkg-remove`

**omarchy-powerprofiles-list**
- **Category**: Power Management
- **Documentation**: `07-system-setup/power-management.md`
- **Purpose**: List available power profiles
- **Usage**: `omarchy-powerprofiles-list`

---

### R

**omarchy-refresh-applications**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Refresh application list
- **Usage**: `omarchy-refresh-applications`

**omarchy-refresh-config**
- **Category**: Refresh/Restart
- **Documentation**: `09-customization/config-management.md`
- **Purpose**: Refresh all configurations
- **Usage**: `omarchy-refresh-config`

**omarchy-refresh-fastfetch**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Refresh fastfetch config
- **Usage**: `omarchy-refresh-fastfetch`

**omarchy-refresh-hypridle**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Refresh hypridle config
- **Usage**: `omarchy-refresh-hypridle`

**omarchy-refresh-hyprland**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Reset to default Hyprland config
- **Usage**: `omarchy-refresh-hyprland`

**omarchy-refresh-hyprlock**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Refresh hyprlock config
- **Usage**: `omarchy-refresh-hyprlock`

**omarchy-refresh-hyprsunset**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Refresh hyprsunset config
- **Usage**: `omarchy-refresh-hyprsunset`

**omarchy-refresh-pacman-mirrorlist**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Refresh pacman mirrorlist
- **Usage**: `omarchy-refresh-pacman-mirrorlist`

**omarchy-refresh-plymouth**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Refresh plymouth boot screen
- **Usage**: `omarchy-refresh-plymouth`

**omarchy-refresh-swayosd**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Refresh swayosd config
- **Usage**: `omarchy-refresh-swayosd`

**omarchy-refresh-walker**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Refresh walker config
- **Usage**: `omarchy-refresh-walker`

**omarchy-refresh-waybar**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Refresh waybar config
- **Usage**: `omarchy-refresh-waybar`

**omarchy-reset-sudo**
- **Category**: System
- **Documentation**: `07-system-setup/security-auth.md`
- **Purpose**: Reset sudo timestamp
- **Usage**: `omarchy-reset-sudo`

**omarchy-restart-app**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Restart application
- **Usage**: `omarchy-restart-app [name]`

**omarchy-restart-bluetooth**
- **Category**: Refresh/Restart
- **Documentation**: `07-system-setup/audio-bluetooth-wifi.md`
- **Purpose**: Restart Bluetooth service
- **Usage**: `omarchy-restart-bluetooth`

**omarchy-restart-hypridle**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Restart hypridle service
- **Usage**: `omarchy-restart-hypridle`

**omarchy-restart-hyprsunset**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Restart hyprsunset service
- **Usage**: `omarchy-restart-hyprsunset`

**omarchy-restart-pipewire**
- **Category**: Refresh/Restart
- **Documentation**: `07-system-setup/audio-bluetooth-wifi.md`
- **Purpose**: Restart Pipewire audio service
- **Usage**: `omarchy-restart-pipewire`

**omarchy-restart-swayosd**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Restart swayosd service
- **Usage**: `omarchy-restart-swayosd`

**omarchy-restart-walker**
- **Category**: Refresh/Restart
- **Documentation**: `04-desktop-environment/walker-elephant.md`
- **Purpose**: Restart walker service
- **Usage**: `omarchy-restart-walker`

**omarchy-restart-waybar**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Restart waybar
- **Usage**: `omarchy-restart-waybar`

**omarchy-restart-wifi**
- **Category**: Refresh/Restart
- **Documentation**: `07-system-setup/audio-bluetooth-wifi.md`
- **Purpose**: Restart WiFi service
- **Usage**: `omarchy-restart-wifi`

**omarchy-restart-xcompose**
- **Category**: Refresh/Restart
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Restart XCompose
- **Usage**: `omarchy-restart-xcompose`

---

### S

**omarchy-setup-dns**
- **Category**: Setup
- **Documentation**: `07-system-setup/security-auth.md`
- **Purpose**: Configure DNS settings
- **Usage**: `omarchy-setup-dns`

**omarchy-setup-fido2**
- **Category**: Setup
- **Documentation**: `07-system-setup/security-auth.md`
- **Purpose**: Set up Fido2 authentication
- **Usage**: `omarchy-setup-fido2 [--remove]`

**omarchy-setup-fingerprint**
- **Category**: Setup
- **Documentation**: `07-system-setup/security-auth.md`
- **Purpose**: Set up fingerprint authentication
- **Usage**: `omarchy-setup-fingerprint [--remove]`

**omarchy-show-done**
- **Category**: Display
- **Documentation**: `08-utilities/utility-scripts.md`
- **Purpose**: Show completion message
- **Usage**: Internal utility

**omarchy-show-logo**
- **Category**: Display
- **Documentation**: `08-utilities/utility-scripts.md`
- **Purpose**: Display omarchy logo
- **Usage**: `omarchy-show-logo`

**omarchy-snapshot**
- **Category**: System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Create system snapshot
- **Usage**: `omarchy-snapshot`

**omarchy-state**
- **Category**: State Management
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Manage omarchy state
- **Usage**: `omarchy-state [get|set|clear] [key] [value]`

---

### T

**omarchy-theme-bg-next**
- **Category**: Theme Management
- **Documentation**: `03-theming/backgrounds.md`
- **Purpose**: Cycle to next background
- **Usage**: `omarchy-theme-bg-next`

**omarchy-theme-current**
- **Category**: Theme Management
- **Documentation**: `03-theming/theme-system.md`
- **Purpose**: Display current theme name
- **Usage**: `omarchy-theme-current`

**omarchy-theme-install**
- **Category**: Theme Management
- **Documentation**: `03-theming/creating-themes.md`
- **Purpose**: Install new theme
- **Usage**: `omarchy-theme-install`

**omarchy-theme-list**
- **Category**: Theme Management
- **Documentation**: `03-theming/theme-system.md`
- **Purpose**: List available themes
- **Usage**: `omarchy-theme-list`

**omarchy-theme-next**
- **Category**: Theme Management
- **Documentation**: `03-theming/theme-system.md`
- **Purpose**: Switch to next theme
- **Usage**: `omarchy-theme-next`

**omarchy-theme-remove**
- **Category**: Theme Management
- **Documentation**: `03-theming/creating-themes.md`
- **Purpose**: Remove installed theme
- **Usage**: `omarchy-theme-remove`

**omarchy-theme-set**
- **Category**: Theme Management
- **Documentation**: `03-theming/theme-system.md`
- **Purpose**: Set specific theme
- **Usage**: `omarchy-theme-set [theme-name]`

**omarchy-theme-set-browser**
- **Category**: Theme Management
- **Documentation**: `03-theming/theme-system.md`
- **Purpose**: Apply theme to browser
- **Usage**: Internal (called by omarchy-theme-set)

**omarchy-theme-set-cursor**
- **Category**: Theme Management
- **Documentation**: `03-theming/theme-system.md`
- **Purpose**: Apply theme cursor
- **Usage**: Internal (called by omarchy-theme-set)

**omarchy-theme-set-gnome**
- **Category**: Theme Management
- **Documentation**: `03-theming/theme-system.md`
- **Purpose**: Apply theme to GNOME apps
- **Usage**: Internal (called by omarchy-theme-set)

**omarchy-theme-set-obsidian**
- **Category**: Theme Management
- **Documentation**: `03-theming/theme-system.md`
- **Purpose**: Apply theme to Obsidian
- **Usage**: Internal (called by omarchy-theme-set)

**omarchy-theme-set-terminal**
- **Category**: Theme Management
- **Documentation**: `03-theming/theme-system.md`
- **Purpose**: Apply theme to terminal
- **Usage**: Internal (called by omarchy-theme-set)

**omarchy-theme-set-vscode**
- **Category**: Theme Management
- **Documentation**: `03-theming/theme-system.md`
- **Purpose**: Apply theme to VSCode
- **Usage**: Internal (called by omarchy-theme-set)

**omarchy-theme-update**
- **Category**: Theme Management
- **Documentation**: `03-theming/creating-themes.md`
- **Purpose**: Update installed extra themes
- **Usage**: `omarchy-theme-update`

**omarchy-toggle-idle**
- **Category**: Toggle Commands
- **Documentation**: `08-utilities/utility-scripts.md`
- **Purpose**: Toggle idle lock
- **Usage**: `omarchy-toggle-idle`

**omarchy-toggle-nightlight**
- **Category**: Toggle Commands
- **Documentation**: `08-utilities/utility-scripts.md`
- **Purpose**: Toggle nightlight mode
- **Usage**: `omarchy-toggle-nightlight`

**omarchy-toggle-screensaver**
- **Category**: Toggle Commands
- **Documentation**: `08-utilities/utility-scripts.md`
- **Purpose**: Toggle screensaver
- **Usage**: `omarchy-toggle-screensaver`

**omarchy-toggle-waybar**
- **Category**: Toggle Commands
- **Documentation**: `04-desktop-environment/waybar-configuration.md`
- **Purpose**: Toggle waybar visibility
- **Usage**: `omarchy-toggle-waybar`

**omarchy-tui-install**
- **Category**: TUI Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Install TUI application
- **Usage**: `omarchy-tui-install`

**omarchy-tui-remove**
- **Category**: TUI Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Remove TUI application
- **Usage**: `omarchy-tui-remove`

**omarchy-tz-select**
- **Category**: System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Select timezone
- **Usage**: `omarchy-tz-select`

---

### U

**omarchy-update**
- **Category**: Update System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Update omarchy system
- **Usage**: `omarchy-update`

**omarchy-update-available**
- **Category**: Update System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Check if update available
- **Usage**: `omarchy-update-available`

**omarchy-update-available-reset**
- **Category**: Update System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Reset update available flag
- **Usage**: `omarchy-update-available-reset`

**omarchy-update-branch**
- **Category**: Update System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Switch omarchy branch
- **Usage**: `omarchy-update-branch [master|dev]`

**omarchy-update-firmware**
- **Category**: Update System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Update system firmware
- **Usage**: `omarchy-update-firmware`

**omarchy-update-git**
- **Category**: Update System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Update via git
- **Usage**: Internal utility

**omarchy-update-perform**
- **Category**: Update System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Perform system update
- **Usage**: Internal utility

**omarchy-update-restart**
- **Category**: Update System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Restart after update
- **Usage**: `omarchy-update-restart`

**omarchy-update-system-pkgs**
- **Category**: Update System
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Update system packages
- **Usage**: `omarchy-update-system-pkgs`

**omarchy-upload-log**
- **Category**: System
- **Documentation**: `10-reference/troubleshooting.md`
- **Purpose**: Upload log for debugging
- **Usage**: `omarchy-upload-log`

---

### V

**omarchy-version**
- **Category**: Version Management
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Display omarchy version
- **Usage**: `omarchy-version`

**omarchy-version-branch**
- **Category**: Version Management
- **Documentation**: `02-core-commands/system-management.md`
- **Purpose**: Display current branch
- **Usage**: `omarchy-version-branch`

---

### W

**omarchy-webapp-handler-hey**
- **Category**: Webapp Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Handler for HEY webapp
- **Usage**: Internal handler

**omarchy-webapp-handler-zoom**
- **Category**: Webapp Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Handler for Zoom webapp
- **Usage**: Internal handler

**omarchy-webapp-install**
- **Category**: Webapp Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Install web application
- **Usage**: `omarchy-webapp-install`

**omarchy-webapp-remove**
- **Category**: Webapp Management
- **Documentation**: `02-core-commands/package-management.md`
- **Purpose**: Remove web application
- **Usage**: `omarchy-webapp-remove`

**omarchy-windows-vm**
- **Category**: Virtual Machines
- **Documentation**: `05-applications/productivity-apps.md`
- **Purpose**: Manage Windows VM
- **Usage**: `omarchy-windows-vm [install|remove|start]`

---

## Script Count by Category

| Category | Count |
|----------|-------|
| Command (cmd-) | 12 |
| Launch | 11 |
| Theme | 15 |
| Package Management | 10 |
| Refresh/Restart | 16 |
| Update System | 9 |
| Setup | 3 |
| Toggle | 4 |
| Font | 3 |
| Drive | 3 |
| Webapp | 4 |
| TUI | 2 |
| Power | 2 |
| Version | 2 |
| Menu | 2 |
| Display | 2 |
| Other | 24 |
| **Total** | **124** |

---

## Quick Category Lookup

### By Function

**Screenshot/Recording**: `omarchy-cmd-screenshot`, `omarchy-cmd-screenrecord`
**Theming**: `omarchy-theme-*` (15 commands)
**Package Management**: `omarchy-pkg-*` (10 commands)
**Launching**: `omarchy-launch-*` (11 commands)
**System Updates**: `omarchy-update-*` (9 commands)
**Service Restart**: `omarchy-restart-*`, `omarchy-refresh-*` (16 commands)

---

*For usage examples and detailed documentation, see the referenced files.*
