# Omarchy Knowledge Archive - Structure Plan

**Created:** 2025-10-21
**Purpose:** Distill all omarchy knowledge into efficient, context-optimized documentation

---

## Archive Structure (10 Categories)

### 01-getting-started/
**Purpose:** Onboarding and understanding omarchy
- `installation.md` - How omarchy installs, boot process, package lists
- `first-run-guide.md` - Initial setup, omarchy-cmd-first-run, basics
- `overview.md` - What is omarchy, philosophy, components
- `architecture.md` - System structure, how pieces fit together

### 02-core-commands/
**Purpose:** Essential omarchy-* command reference
- `command-index.md` - Complete A-Z list of all 124 omarchy commands
- `package-management.md` - omarchy-pkg-*, omarchy-tui-*, omarchy-webapp-*
- `system-management.md` - omarchy-update*, omarchy-refresh*, omarchy-restart*
- `launcher-commands.md` - omarchy-launch-*, omarchy-cmd-*

### 03-theming/
**Purpose:** Visual customization and branding
- `theme-system.md` - How themes work, omarchy-theme-*
- `fonts.md` - Font management, omarchy-font-*
- `backgrounds.md` - Background management, omarchy-theme-bg-*
- `creating-themes.md` - Theme structure, creating custom themes

### 04-desktop-environment/
**Purpose:** Hyprland, Walker, Waybar integration
- `hyprland-integration.md` - How omarchy configures Hyprland
- `walker-elephant.md` - Walker launcher, Elephant providers
- `waybar-configuration.md` - Status bar setup and customization
- `window-management.md` - Window rules, workspaces, bindings

### 05-applications/
**Purpose:** Pre-installed software ecosystem
- `core-applications.md` - Essential apps (Chromium, Nautilus, etc.)
- `development-tools.md` - Docker, lazygit, lazydocker, gh
- `media-tools.md` - OBS, Kdenlive, mpv, satty
- `productivity-apps.md` - Obsidian, Typora, LibreOffice

### 06-development/
**Purpose:** Development environment setup
- `mise-integration.md` - Runtime management with mise
- `docker-setup.md` - Docker configuration, omarchy-install-docker-dbs
- `language-environments.md` - Ruby, Node, Go, PHP, Python, etc.
- `editor-setup.md` - Neovim, VSCode, Cursor, Zed integration

### 07-system-setup/
**Purpose:** Hardware and system configuration
- `audio-bluetooth-wifi.md` - Pipewire, blueberry, iwd setup
- `monitors-input.md` - Monitor config, input devices, touchpad
- `security-auth.md` - Fingerprint, Fido2, GPG, SSH
- `power-management.md` - Battery, power profiles, suspend

### 08-utilities/
**Purpose:** Daily-use tools and scripts
- `screenshot-screenrecord.md` - Capture tools, satty, gpu-screen-recorder
- `file-sharing.md` - omarchy-cmd-share, localsend
- `clipboard-management.md` - wl-clipboard, elephant-clipboard
- `utility-scripts.md` - Helper scripts, omarchy-drive-*, omarchy-setup-*

### 09-customization/
**Purpose:** Advanced configuration and tweaking
- `config-management.md` - Config structure, omarchy-refresh-config
- `keybindings.md` - Hyprland bindings, omarchy-menu-keybindings
- `autostart-scripts.md` - Autostart configuration, systemd integration
- `advanced-tweaks.md` - Expert-level customizations

### 10-reference/
**Purpose:** Quick lookups and troubleshooting
- `quick-reference.md` - Cheat sheet, common commands, shortcuts
- `troubleshooting.md` - Common issues and solutions
- `faq.md` - Frequently asked questions
- `script-index.md` - Detailed index of all 124 scripts

---

## Documentation Sources

### Primary Sources:
1. **124 bin scripts** (`/home/zack/.local/share/omarchy/bin/`)
2. **omarchy-menu** - Feature hierarchy and organization
3. **Package lists** - omarchy-base.packages, omarchy-other.packages
4. **Config files** - Default and current configs
5. **Install scripts** - Setup procedures and dependencies
6. **Themes** - 12 theme directories with structure

### Methodology:
- **Script Analysis**: Read each of the 124 scripts to extract functionality
- **Menu Mapping**: Use omarchy-menu structure as organizational guide
- **Config Documentation**: Document all default configurations
- **Example-First**: Every command gets practical examples
- **Cross-Reference**: Link related topics across categories

---

## File Template Structure

Each markdown file will follow this structure:

```markdown
# Topic Name

Brief overview paragraph

## Table of Contents
- [Section 1](#section-1)
- [Section 2](#section-2)
...

## Overview
What this topic covers and why it matters

## Core Concepts
Key ideas and terminology

## Commands/Configuration
Complete reference with syntax

## Examples
### Basic Example
### Intermediate Example
### Advanced Example

## Troubleshooting
Common issues and solutions

## Best Practices
Do's and don'ts

## Related Documentation
- [Topic A](../category/topic-a.md)
- [Topic B](../category/topic-b.md)

---
*Last Updated: YYYY-MM-DD*
*Source: [specific scripts or configs referenced]*
```

---

## Success Metrics

Archive should achieve:
- ✅ **Complete coverage** of all 124 omarchy scripts
- ✅ **Self-contained files** - each file answers its topic completely
- ✅ **Searchable** - grep-friendly formatting
- ✅ **Practical** - copy-paste ready examples
- ✅ **Maintainable** - clear sources, timestamps, modular structure
- ✅ **Context-efficient** - Maximum knowledge density for Claude Code

---

## Estimated File Count

- 01-getting-started: 4 files
- 02-core-commands: 4 files
- 03-theming: 4 files
- 04-desktop-environment: 4 files
- 05-applications: 4 files
- 06-development: 4 files
- 07-system-setup: 4 files
- 08-utilities: 4 files
- 09-customization: 4 files
- 10-reference: 4 files

**Total: 40 documentation files** (matching Hyprland archive)

Plus meta-documentation:
- README.md
- Claude.md
- QUICK-SEARCH.md
- SCRIPT-MAP.md (maps all 124 scripts to docs)

**Grand Total: 44 files**

---

## Next Steps

1. Create directory structure
2. Generate meta-documentation (README, Claude.md, QUICK-SEARCH)
3. Launch parallel Task agents to create documentation files
4. Cross-reference and validate
5. Create integration tools
6. Document the documentation process

---

*This is a living document that will be updated as the archive develops*
