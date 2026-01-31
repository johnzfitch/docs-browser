# Ghostty Documentation - Master Index

**Comprehensive reference for Ghostty terminal emulator**

> Last Updated: 2025-11-08
> Total Files: 66 markdown documents
> Archive Location: `/home/zack/dev/lib/ghostty-wiki/`

---

## 📚 Quick Navigation

### Essential Files
- **[README](README.md)** - Archive overview and usage guide
- **[Complete Config Reference](07-reference/ghostty.config.md)** - Full configuration file
- **[Option Reference](07-reference/Option%20Reference%20-%20Configuration.md)** - All config options
- **[Quick Search Guide](QUICK-SEARCH.md)** - Search commands for this archive

### Integration
- **[Omarchy Integration](OMARCHY-INTEGRATION.md)** - Browser setup with SUPER + G keybind

---

## 🔄 Terminal History (Context Recovery)

**When asked to "continue from before":** Check `/home/zack/dev/lib/terminal-history/`

Sessions auto-logged as `session_YYYY-MM-DD_HH-MM-SS.txt` with full terminal output.

```bash
# Read most recent session
cat $(ls -t ~/dev/lib/terminal-history/session_*.txt | head -1)

# Search sessions for keywords/errors
grep -r "keyword" ~/dev/lib/terminal-history/ | tail -50
```

---

## 🎯 By Topic

### 01 - Getting Started

Essential setup and configuration:

- **[Configuration.md](01-getting-started/Configuration.md)** - Basic configuration guide
- **[Features.md](01-getting-started/Features.md)** - Overview of Ghostty features
- **[Help.md](01-getting-started/Help.md)** - Help and troubleshooting
- **[Shell Integration - Features.md](01-getting-started/Shell%20Integration%20-%20Features.md)** - Shell integration features
- **[Color Theme - Features.md](01-getting-started/Color%20Theme%20-%20Features.md)** - Theme system

### 02 - Keybindings

Complete keybinding system:

- **[Keybindings - Configuration.md](02-keybindings/Keybindings%20-%20Configuration.md)** - How to configure keybinds
- **[Action Reference - Keybindings.md](02-keybindings/Action%20Reference%20-%20Keybindings.md)** - All available actions
- **[Trigger Sequences - Keybindings.md](02-keybindings/Trigger%20Sequences%20-%20Keybindings.md)** - Trigger sequence system

### 03 - Terminal API (VT)

Virtual Terminal API reference:

- **[Terminal API (VT).md](03-terminal-api/Terminal%20API%20%28VT%29.md)** - VT API overview
- **[Reference - Terminal API (VT).md](03-terminal-api/Reference%20-%20Terminal%20API%20%28VT%29.md)** - Complete VT reference

### 04 - Control Sequences

40 terminal control code docs in `04-control-sequences/` (CSI, ESC, Control chars). Use grep or browse directory for specific sequences.

### 05 - Concepts

Core terminal concepts:

- **[Control Sequences - Concepts.md](05-concepts/Control%20Sequences%20-%20Concepts.md)** - How control sequences work
- **[Cursor - Concepts.md](05-concepts/Cursor%20-%20Concepts.md)** - Cursor behavior
- **[Screen - Concepts.md](05-concepts/Screen%20-%20Concepts.md)** - Screen model

### 06 - Platform Specific

Platform-specific guides:

- **[Linux.md](06-platform-specific/Linux.md)** - Linux setup and integration
- **[Systemd and D-Bus - Linux.md](06-platform-specific/Systemd%20and%20D-Bus%20-%20Linux.md)** - Systemd integration
- **[macOS Login Shells - Help.md](06-platform-specific/macOS%20Login%20Shells%20-%20Help.md)** - macOS shell setup
- **[macOS Tiling Window Managers - Help.md](06-platform-specific/macOS%20Tiling%20Window%20Managers%20-%20Help.md)** - TWM integration
- **[GTK OpenGL Context - Help.md](06-platform-specific/GTK%20OpenGL%20Context%20-%20Help.md)** - GTK OpenGL
- **[GTK Single Instance - Help.md](06-platform-specific/GTK%20Single%20Instance%20-%20Help.md)** - GTK instances
- **[Terminfo - Help.md](06-platform-specific/Terminfo%20-%20Help.md)** - Terminfo database

### 07 - Reference

Complete references:

- **[Option Reference - Configuration.md](07-reference/Option%20Reference%20-%20Configuration.md)** - All config options
- **[ghostty.config.md](07-reference/ghostty.config.md)** - Complete config file with all options

---

**Search:** See [QUICK-SEARCH.md](QUICK-SEARCH.md) for grep patterns
**Quick Access:** SUPER + G → Omarchy browser search
**Total Files:** 66 docs across 7 categories

---

**Last Updated:** 2025-11-08
**Maintained By:** Omarchy System
**Source:** Ghostty Official Wiki
