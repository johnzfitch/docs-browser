# Omarchy Documentation Integration

**Purpose:** Documentation browser integration with omarchy system
**Created:** 2025-10-21

---

## Overview

The omarchy documentation archive is fully integrated with the omarchy system following established patterns and conventions.

---

## Integration Components

### 1. Documentation Browser Script

**Location:** `/home/zack/.config/omarchy/scripts/omarchy-docs-browser.sh`

**Features:**
- 🔍 Search all documentation
- 📖 Browse by category
- 🔧 Command lookup via SCRIPT-MAP
- 📚 Quick access to reference files
- 👁️ Preview with bat
- ✏️ Open in editor
- 📋 Copy file paths
- 📁 Open containing directory

**Main Menu:**
```
🔍 Search All Docs       → Full-text search across all files
📖 Browse by Category    → Navigate by category structure
🔧 Command Lookup        → Find docs by command name
📚 Quick Reference       → Direct access to quick-reference.md
🔧 Troubleshooting       → Direct access to troubleshooting.md
❓ FAQ                   → Direct access to faq.md
📜 Script Index          → Direct access to script-index.md
```

### 2. Launcher Command

**Location:** `/home/zack/.local/share/omarchy/bin/omarchy-launch-omarchy-docs`

**Purpose:** Follows omarchy-launch-* naming convention

**Usage:**
```bash
omarchy-launch-omarchy-docs
```

### 3. Keybindings

**File:** `~/.config/hypr/bindings.conf`

**Bindings Added:**
```ini
# Omarchy Documentation Browser
SUPER + O              → Open omarchy docs browser
SUPER + CTRL + F1      → Quick Reference (preview)
SUPER + CTRL + F2      → Troubleshooting (preview)
SUPER + CTRL + F3      → FAQ (preview)
```

### 4. Window Rules

**File:** `~/.config/hypr/hyprland.conf`

**Rule for Preview Windows:**
```ini
windowrulev2 = float, class:(floating-docs)
windowrulev2 = size 60% 70%, class:(floating-docs)
windowrulev2 = center, class:(floating-docs)
```

---

## Usage Examples

### Quick Access

**Press SUPER + O:**
- Main menu appears via walker
- Select action (search, browse, command lookup)
- Choose file to view
- Select action (preview, edit, copy path)

### Search Workflow

**Example: Finding theme documentation**
1. Press `SUPER + O`
2. Select "🔍 Search All Docs"
3. Type "theme-set"
4. Select matching file from results
5. Choose "📖 Preview with bat" to view

### Command Lookup

**Example: Looking up omarchy-pkg-install**
1. Press `SUPER + O`
2. Select "🔧 Command Lookup"
3. Type "omarchy-pkg-install"
4. Documentation opens automatically

### Direct Quick Reference

**Press SUPER + CTRL + F1:**
- Quick reference opens immediately in terminal with bat
- Scrollable, searchable, ready to use

---

## Architecture

### Walker Integration

The browser uses walker in dmenu mode for all interactive menus:
```bash
omarchy-launch-walker --dmenu --width 350 --minheight 1 --maxheight 600 -p "Prompt"
```

**Benefits:**
- Native theme integration
- Consistent UI with other omarchy tools
- Fuzzy searching built-in
- Keyboard-friendly navigation

### File Actions

When viewing a file, users can:

**📖 Preview with bat:**
```bash
alacritty --class=floating-docs --title="Omarchy Docs: filename" \
    -e bat --color=always --style=numbers,grid "$file"
```

**✏️ Open in Editor:**
```bash
omarchy-launch-editor "$file"
```

**📋 Copy Path:**
```bash
echo "$file" | wl-copy
```

**📁 Open Directory:**
```bash
nautilus "$(dirname "$file")"
```

---

## Integration Patterns

### Naming Convention

Follows established omarchy patterns:
- **Browser script:** `omarchy-docs-browser.sh` (in config scripts)
- **Launcher:** `omarchy-launch-omarchy-docs` (in bin)
- **Keybinding:** SUPER + O (logical: O for Omarchy docs)

### Theme Integration

Uses walker's native theming:
- Automatically matches current omarchy theme
- No custom styling required
- Updates with `omarchy-theme-set`

### Window Management

Preview windows use `floating-docs` class:
- Floating by default
- 60% width × 70% height
- Centered on screen
- Works across all monitors

---

## Comparison with Hyprland Docs

The omarchy docs browser mirrors the hyprland docs browser:

| Feature | Hyprland Docs | Omarchy Docs |
|---------|--------------|--------------|
| Keybinding | SUPER + H | SUPER + O |
| Quick Ref | SUPER + ALT + F1 | SUPER + CTRL + F1 |
| Troubleshooting | SUPER + ALT + F2 | SUPER + CTRL + F2 |
| FAQ | SUPER + ALT + F3 | SUPER + CTRL + F3 |
| Browser Script | hypr-docs-omarchy.sh | omarchy-docs-browser.sh |
| Launcher | omarchy-launch-hyprland-docs | omarchy-launch-omarchy-docs |

**Rationale:** Consistent patterns make both systems easy to learn and use.

---

## File Locations Summary

```
/home/zack/dev/lib/omarchy-archive/           # Documentation archive (46 files, 1.2MB)
├── 01-getting-started/                       # 4 files
├── 02-core-commands/                         # 4 files
├── 03-theming/                               # 4 files
├── 04-desktop-environment/                   # 4 files
├── 05-applications/                          # 4 files
├── 06-development/                           # 4 files
├── 07-system-setup/                          # 4 files
├── 08-utilities/                             # 4 files
├── 09-customization/                         # 4 files
├── 10-reference/                             # 4 files
├── README.md                                 # Archive overview
├── Claude.md                                 # AI assistant guide
├── QUICK-SEARCH.md                           # Search commands
├── SCRIPT-MAP.md                             # Script → docs mapping
├── ARCHIVE-PLAN.md                           # Design methodology
└── OMARCHY-INTEGRATION.md                    # This file

/home/zack/.config/omarchy/scripts/
└── omarchy-docs-browser.sh                   # Main browser script

/home/zack/.local/share/omarchy/bin/
└── omarchy-launch-omarchy-docs               # Launcher command

/home/zack/.config/hypr/
└── bindings.conf                             # Keybindings added
```

---

## Future Enhancements

### Potential Additions

1. **History Tracking**
   - Track frequently accessed docs
   - Recent files menu
   - Bookmarking system

2. **Search Improvements**
   - Context preview in search results
   - Multi-term search
   - Regex support

3. **Integration Expansions**
   - Elephant provider for walker
   - Web interface (local markdown server)
   - Mobile-friendly docs viewer

4. **Content Enhancements**
   - Video tutorials
   - Interactive examples
   - Configuration validator

---

## Maintenance

### Updating Documentation

When omarchy scripts change:

1. Identify changed scripts
2. Find relevant doc files via SCRIPT-MAP.md
3. Update affected sections
4. Update "Last Updated" timestamp
5. Test examples

### Adding New Documentation

To add new docs:

1. Create file in appropriate category
2. Follow template structure from existing files
3. Update SCRIPT-MAP.md if documenting scripts
4. Add cross-references from related files
5. Test browser can find new file

---

## Troubleshooting

### Browser Won't Launch

```bash
# Check if script exists
ls -la /home/zack/.config/omarchy/scripts/omarchy-docs-browser.sh

# Check if launcher exists
ls -la /home/zack/.local/share/omarchy/bin/omarchy-launch-omarchy-docs

# Check permissions
chmod +x ~/.config/omarchy/scripts/omarchy-docs-browser.sh
chmod +x ~/.local/share/omarchy/bin/omarchy-launch-omarchy-docs

# Test manually
omarchy-launch-omarchy-docs
```

### Keybinding Not Working

```bash
# Reload Hyprland config
hyprctl reload

# Check keybinding is loaded
hyprctl binds | grep -i omarchy

# Test command directly
omarchy-launch-omarchy-docs
```

### Search Not Finding Files

```bash
# Verify archive exists
ls -la /home/zack/dev/lib/omarchy-archive/

# Test grep manually
grep -r "test" /home/zack/dev/lib/omarchy-archive/ --include="*.md"
```

### Preview Window Not Floating

```bash
# Check window rule exists in hyprland.conf
grep "floating-docs" ~/.config/hypr/hyprland.conf

# Add if missing
windowrulev2 = float, class:(floating-docs)
windowrulev2 = size 60% 70%, class:(floating-docs)
windowrulev2 = center, class:(floating-docs)

# Reload config
hyprctl reload
```

---

## Credits

**Created by:** Claude Code (Anthropic)
**Date:** 2025-10-21
**Based on:** Hyprland documentation browser pattern
**Integrated with:** Omarchy v3.1.1

---

*This integration provides seamless access to omarchy documentation following established omarchy patterns and conventions.*
