# Ghostty Documentation Browser - Omarchy Integration

**Native integration with omarchy's theming and walker service**

---

## 🎨 What Makes This Omarchy-Native?

1. **Uses walker's native theming** - Automatically inherits your omarchy theme
2. **Follows omarchy launcher pattern** - Uses `omarchy-launch-*` naming convention
3. **Integrates with walker service** - Leverages the running walker --gapplication-service
4. **Matches omarchy UI** - Same width, height, and behavior as other omarchy tools
5. **Uses omarchy variables** - `$terminal` from your config

---

## 📁 Files Created

### Omarchy Launcher
**Location:** `/home/zack/.local/share/omarchy/bin/omarchy-launch-ghostty-docs`
- Native omarchy launcher following the `omarchy-launch-*` pattern
- Ensures walker service is running
- Uses walker's themed dmenu mode

### Main Script
**Location:** `/home/zack/.config/hypr/scripts/ghostty-docs-omarchy.sh`
- Search functionality with formatted results
- Action menu with multiple options
- Smart file handling

### Keybind
**Location:** `/home/zack/.config/hypr/bindings.conf`
```ini
bindd = SUPER, G, Ghostty Docs, exec, ~/.config/hypr/scripts/ghostty-docs-omarchy.sh
```

### Window Rules
**Location:** `/home/zack/.config/hypr/hyprland.conf`
```ini
# Ghostty documentation windows
windowrule = float, tag:ghostty-docs
windowrule = center, tag:ghostty-docs
windowrule = size 60% 70%, tag:ghostty-docs
windowrule = maxsize 7680 4096, tag:ghostty-docs
windowrule = animation popin 80%, tag:ghostty-docs
windowrule = opacity 0.95 0.85, tag:ghostty-docs

windowrule = float, tag:ghostty-editor
windowrule = size 70% 80%, tag:ghostty-editor
windowrule = center, tag:ghostty-editor
```

---

## 🎮 How to Use

### Quick Search
**Keybind:** `SUPER + G`

1. Press `SUPER + G`
2. Type your search query (e.g., "keybind", "theme", "cursor")
3. See formatted results with file, line number, and preview
4. Select a result
5. Choose action:
   - 📖 **Open in Neovim** - Edit at the exact line
   - 📁 **Open directory** - View in Nautilus
   - 📋 **Copy path** - Full file path to clipboard
   - 👁️  **Preview** - View with bat in terminal
   - 🔗 **Copy reference** - Get `file.md:line` reference

---

## 🎨 Theming Integration

The browser automatically uses your omarchy theme through walker's config:

**Walker Config:** `~/.config/walker/config.toml`
```toml
theme = "omarchy-default"
additional_theme_location = "~/.local/share/omarchy/default/walker/themes/"
```

This means:
- ✅ Matches your current omarchy color scheme
- ✅ Updates when you change omarchy themes
- ✅ Consistent with other omarchy UI elements
- ✅ No hardcoded colors - fully dynamic

---

## 🔧 Customization

### Change Window Sizes

Edit `~/.config/hypr/hyprland.conf`:
```ini
# Make preview window bigger
windowrule = size 80% 85%, tag:ghostty-docs

# Make editor fullscreen
windowrule = size 100% 100%, tag:ghostty-editor
windowrule = maximize, tag:ghostty-editor
```

### Change Walker Dimensions

Edit the launcher script or walker calls:
```bash
walker --dmenu -p "Search" --width 1200 --maxheight 700
```

### Add More Actions

Edit `~/.config/hypr/scripts/ghostty-docs-omarchy.sh` action menu:
```bash
action=$(cat <<EOF | walker --dmenu -p "Select Action"
📖 Open in Neovim
📁 Open directory
📋 Copy path
👁️  Preview
🔗 Copy reference
🌐 Open in browser  # Add new action
📧 Email this doc   # Add new action
EOF
)
```

---

## 🚀 Benefits Over Generic Solution

| Feature | Generic | Omarchy-Native |
|---------|---------|----------------|
| **Theming** | Hardcoded colors | Automatic theme inheritance |
| **UI Consistency** | Custom styling | Matches all omarchy tools |
| **Service Integration** | Spawns new process | Uses running walker service |
| **Performance** | Slower startup | Instant (service already running) |
| **Maintenance** | Manual color updates | Updates with theme changes |
| **User Experience** | Feels bolted-on | Feels like a core feature |

---

## 📝 Architecture

```
User presses SUPER + G
    ↓
ghostty-docs-omarchy.sh starts
    ↓
Calls: omarchy-launch-ghostty-docs
    ↓
Ensures walker service is running
    ↓
Opens walker dmenu (themed via omarchy config)
    ↓
User types query
    ↓
Script searches /home/zack/dev/lib/ghostty-wiki/
    ↓
Results displayed in walker (themed)
    ↓
User selects result
    ↓
Action menu appears (walker, themed)
    ↓
Execute chosen action:
  - Neovim: kitty + ghostty-editor tag
  - Preview: kitty + ghostty-docs tag
  - Copy: wl-copy
  - Directory: nautilus
```

---

## 🔍 Comparison to Other Omarchy Tools

### Similar to Hyprland Docs
```bash
# Hyprland docs
SUPER + H → hyprland documentation

# Ghostty docs
SUPER + G → ghostty documentation
```

Both follow the same pattern:
1. Ensure walker service is running
2. Use walker's dmenu mode
3. Custom actions based on selection
4. Themed via walker config
5. Tag-based window rules

---

## 💡 Future Enhancements

Possible additions that would fit the omarchy pattern:

1. **Walker Provider Plugin**
   - Create a custom walker provider for docs
   - Add to walker config: `providers.default = ["ghosttydocs", ...]`
   - Use prefix like `?` to search docs directly

2. **Elephant Integration**
   - Add docs to elephant's knowledge base
   - Quick lookups from elephant panel

3. **History Tracking**
   - Track frequently accessed docs
   - Show in walker like clipboard history

4. **Quick Actions**
   - Add walker keybinds for instant docs access
   - Similar to clipboard's quick access

---

## 📚 Related Omarchy Tools

This tool follows the same integration pattern as:
- `omarchy-launch-hyprland-docs` (SUPER + H)
- `omarchy-launch-omarchy-docs` (SUPER + O)
- Clipboard manager (`-m clipboard`)
- Symbol picker (`-m symbols`)

---

## 🛠️ Troubleshooting

### Browser Won't Launch

```bash
# Check if script exists
ls -la /home/zack/.config/hypr/scripts/ghostty-docs-omarchy.sh

# Check if launcher exists
ls -la /home/zack/.local/share/omarchy/bin/omarchy-launch-ghostty-docs

# Check permissions
chmod +x ~/.config/hypr/scripts/ghostty-docs-omarchy.sh
chmod +x ~/.local/share/omarchy/bin/omarchy-launch-ghostty-docs

# Test manually
~/.config/hypr/scripts/ghostty-docs-omarchy.sh
```

### Keybinding Not Working

```bash
# Reload Hyprland config
hyprctl reload

# Check keybinding is loaded
hyprctl binds | grep -i ghostty

# Test command directly
~/.config/hypr/scripts/ghostty-docs-omarchy.sh
```

### Search Not Finding Files

```bash
# Verify archive exists
ls -la /home/zack/dev/lib/ghostty-wiki/

# Test grep manually
grep -r "test" /home/zack/dev/lib/ghostty-wiki/ --include="*.md"
```

### Preview Window Not Floating

```bash
# Check window rule exists in hyprland.conf
grep "ghostty-docs" ~/.config/hypr/hyprland.conf

# Add if missing (see Window Rules section above)

# Reload config
hyprctl reload
```

---

## 📊 Integration Summary

| Component | Location | Purpose |
|-----------|----------|---------|
| Archive | `/home/zack/dev/lib/ghostty-wiki/` | Documentation files |
| Launcher | `~/.local/share/omarchy/bin/omarchy-launch-ghostty-docs` | Walker dmenu launcher |
| Browser Script | `~/.config/hypr/scripts/ghostty-docs-omarchy.sh` | Main search & action script |
| Keybind | `~/.config/hypr/bindings.conf` | SUPER + G binding |
| Window Rules | `~/.config/hypr/hyprland.conf` | Tag-based rules |

---

**Last Updated:** 2025-11-08
**Omarchy Integration Version:** 1.0
**Follows Pattern:** hyprland-archive, omarchy-archive
