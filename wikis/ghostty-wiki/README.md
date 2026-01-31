# Ghostty Knowledge Archive

**The Grand Archive - A Comprehensive, Self-Contained Ghostty Reference Library**

> Created: 2025-11-08
> Total Documents: 66 markdown files
> Total Size: 556KB of distilled knowledge
> Source: Official Ghostty Wiki

---

## 📚 What is This?

This is a **complete, distilled, and organized** reference library for Ghostty - the fast, feature-rich, cross-platform terminal emulator. Every document has been carefully organized from the official Ghostty wiki to provide:

- **Actionable information** - Copy-paste ready examples
- **Clear explanations** - Technical but accessible
- **Comprehensive coverage** - From basic config to terminal control sequences
- **Practical focus** - Real-world configurations and use cases
- **Self-contained** - All references use local relative paths

## 🎯 Quick Start

**New to Ghostty?** Start here:
1. [Configuration Guide](01-getting-started/Configuration.md)
2. [Features Overview](01-getting-started/Features.md)
3. [Help & Troubleshooting](01-getting-started/Help.md)

**Need a quick answer?** Check:
- [Option Reference](07-reference/Option%20Reference%20-%20Configuration.md)
- [Complete Config File](07-reference/ghostty.config.md)
- [Keybindings](02-keybindings/Keybindings%20-%20Configuration.md)

**Configuring something specific?** See the [Master Index](Claude.md)

---

## 📂 Archive Structure

```
ghostty-wiki/
│
├── Claude.md                    # Master index with full navigation
├── README.md                    # This file
│
├── 01-getting-started/          # Essential setup (5 files)
│   ├── Configuration.md         # Basic configuration guide
│   ├── Features.md              # Feature overview
│   ├── Help.md                  # Help and troubleshooting
│   ├── Shell Integration - Features.md
│   └── Color Theme - Features.md
│
├── 02-keybindings/              # Input and keybinds (3 files)
│   ├── Keybindings - Configuration.md
│   ├── Action Reference - Keybindings.md
│   └── Trigger Sequences - Keybindings.md
│
├── 03-terminal-api/             # VT API reference (2 files)
│   ├── Terminal API (VT).md
│   └── Reference - Terminal API (VT).md
│
├── 04-control-sequences/        # Terminal control codes (40 files)
│   ├── CSI sequences (cursor, erase, scroll, etc.)
│   ├── ESC sequences (index, reset, save/restore)
│   └── Control characters (BS, BEL, CR, LF, TAB)
│
├── 05-concepts/                 # Core concepts (3 files)
│   ├── Control Sequences - Concepts.md
│   ├── Cursor - Concepts.md
│   └── Screen - Concepts.md
│
├── 06-platform-specific/        # Platform guides (7 files)
│   ├── Linux.md
│   ├── Systemd and D-Bus - Linux.md
│   ├── macOS Login Shells - Help.md
│   ├── macOS Tiling Window Managers - Help.md
│   ├── GTK OpenGL Context - Help.md
│   ├── GTK Single Instance - Help.md
│   └── Terminfo - Help.md
│
└── 07-reference/                # Complete references (2 files)
    ├── Option Reference - Configuration.md  # All config options
    └── ghostty.config.md                    # Complete config file
```

---

## 🔍 How to Use This Archive

### As Claude Code Context

When working with Ghostty configuration or terminal development:

```bash
# Read the master index
cat /home/zack/dev/lib/ghostty-wiki/Claude.md

# Quick lookup for specific topics
grep -r "keybind" /home/zack/dev/lib/ghostty-wiki/
```

### As a Learning Resource

**Progressive Learning Path:**
1. Start with `01-getting-started/` for fundamentals
2. Configure keybindings in `02-keybindings/`
3. Explore terminal API in `03-terminal-api/`
4. Understand control sequences in `04-control-sequences/`
5. Platform-specific setup in `06-platform-specific/`

### As a Reference Manual

**Quick lookups:**
- Need config option? → `07-reference/Option Reference - Configuration.md`
- Setting up keybinds? → `02-keybindings/Action Reference - Keybindings.md`
- Terminal control codes? → `04-control-sequences/` (organized by type)
- Platform issues? → `06-platform-specific/` (your platform)

---

## 📊 Archive Statistics

| Category | Files | Coverage |
|----------|-------|----------|
| Getting Started | 5 | Configuration, features, help |
| Keybindings | 3 | All keybind configuration |
| Terminal API | 2 | VT API reference |
| Control Sequences | 40 | Complete CSI/ESC/Control reference |
| Concepts | 3 | Core terminal concepts |
| Platform Specific | 7 | Linux, macOS, GTK guides |
| Reference | 2 | Complete config reference |
| **TOTAL** | **66** | **Complete coverage** |

**Content Metrics:**
- 556KB of markdown documentation
- 100+ configuration examples
- 40+ terminal control sequences documented
- Platform-specific guides for Linux and macOS
- Complete keybinding system reference

---

## 🎓 Key Features

### Comprehensive Coverage
- **Every Ghostty feature documented** - From basic to advanced
- **Complete terminal API** - All VT control sequences
- **Platform-specific guides** - Linux and macOS
- **Full keybinding reference** - Every action documented

### Practical Focus
- **Copy-paste ready examples** - Working configurations
- **Real-world scenarios** - Actual use cases
- **Clear organization** - Easy to find what you need
- **Technical accuracy** - Direct from official wiki

### Self-Contained
- **Local file references** - All cross-links use relative paths
- **No external dependencies** - Works offline
- **Complete context** - No need to search elsewhere
- **Organized hierarchy** - Logical topic grouping

---

## 💡 Using with Claude Code

This archive is designed to work seamlessly with Claude Code:

### Method 1: Direct Reference

Ask Claude to read specific documentation:
```
"Read /home/zack/dev/lib/ghostty-wiki/01-getting-started/Configuration.md and help me set up my Ghostty config"
```

### Method 2: Search and Reference

Use grep to find relevant sections:
```bash
# Find all keybinding examples
grep -r "keybind" /home/zack/dev/lib/ghostty-wiki/ --include="*.md"

# Find color theme info
grep -r "theme" /home/zack/dev/lib/ghostty-wiki/01-getting-started/ --include="*.md"
```

### Method 3: Browser Integration (SUPER + G)

Quick access via omarchy-integrated browser:
- Press `SUPER + G` to search all docs
- Type your query
- Select result to view/edit

---

## 🔧 Maintenance

This archive is current as of **November 8, 2025** based on the official Ghostty wiki.

### Keeping Updated

To update this archive:
1. Check Ghostty releases for major changes
2. Pull latest wiki updates
3. Update relevant documentation files
4. Update timestamps in modified files

---

## 🌟 Philosophy

This archive follows these principles:

1. **Actionable over Theoretical** - Examples over explanations
2. **Complete over Concise** - Better to have too much info than too little
3. **Organized over Comprehensive** - Structure matters
4. **Self-Contained over Connected** - Work offline, work independently
5. **Practical over Perfect** - Real-world usage over edge cases

---

## 🔗 Related Resources

- **Official Ghostty Docs**: [ghostty.org/docs](https://ghostty.org/docs)
- **Custom Commands Reference**: See `/home/zack/COMMANDS.md`
- **Omarchy Docs**: See `/home/zack/dev/lib/omarchy-archive/`
- **Hyprland Docs**: See `/home/zack/dev/lib/hyprland-archive/`

---

## 📖 Contributing

This archive is organized from the official Ghostty wiki. To contribute:

1. **Report issues** with the archive organization
2. **Improve upstream** at the Ghostty wiki
3. **Suggest improvements** to the organization

---

## 🙏 Acknowledgments

- **Ghostty Team** - For creating an amazing terminal emulator
- **Ghostty Wiki Contributors** - For comprehensive documentation
- **Community** - For sharing configurations and knowledge

---

## 📜 License

This distilled documentation follows the same license as the original Ghostty wiki.

Original wiki: https://ghostty.org/docs

---

**Happy Ghostty-ing! 👻**

*This archive is your companion for mastering Ghostty - from first configuration to advanced terminal control.*
