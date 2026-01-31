# Omarchy Knowledge Archive

**Complete, Distilled Documentation for the Omarchy System**

*Last Updated: 2025-10-21*

---

## What Is This?

This archive contains comprehensive documentation for **Omarchy** - the opinionated Arch Linux + Hyprland desktop environment created by DHH and 37signals. All knowledge from 124+ utility scripts, configurations, and the entire omarchy ecosystem has been distilled into organized, searchable, example-rich documentation.

### Why This Archive Exists

Omarchy is a complete system with hundreds of scripts and configurations. This archive:

- ✅ **Consolidates** scattered knowledge from scripts into organized docs
- ✅ **Provides examples** for every command and feature
- ✅ **Enables offline reference** without needing to read source code
- ✅ **Optimizes for search** with grep-friendly formatting
- ✅ **Maintains consistency** across all documentation
- ✅ **Reduces context** for AI assistants like Claude Code

---

## Archive Structure

### Progressive Disclosure: Beginner → Expert

```
01-getting-started/      Installation, first run, overview, architecture
02-core-commands/        Essential omarchy-* command reference
03-theming/              Visual customization and branding
04-desktop-environment/  Hyprland, Walker, Waybar integration
05-applications/         Pre-installed software ecosystem
06-development/          Development environment setup
07-system-setup/         Hardware and system configuration
08-utilities/            Daily-use tools and scripts
09-customization/        Advanced configuration and tweaking
10-reference/            Quick lookups, troubleshooting, FAQ
```

### Meta-Documentation

- **README.md** (this file) - Archive overview
- **Claude.md** - AI assistant navigation guide
- **QUICK-SEARCH.md** - Search command reference
- **SCRIPT-MAP.md** - Complete index of all 124 omarchy scripts
- **ARCHIVE-PLAN.md** - Archive design and methodology

---

## Quick Start

### For Humans

**Browse by category:**
```bash
cd /home/zack/dev/lib/omarchy-archive
ls 01-getting-started/
```

**Search for a topic:**
```bash
grep -r "screenshot" . --include="*.md"
```

**View a specific file:**
```bash
bat 02-core-commands/command-index.md
```

### For AI Assistants

See [Claude.md](./Claude.md) for navigation structure optimized for context-aware reading.

---

## Search Quick Reference

```bash
# Search entire archive
grep -r "keyword" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Search with context
grep -rn --include="*.md" -C 3 "theme-set" /home/zack/dev/lib/omarchy-archive/

# Find script documentation
grep -r "omarchy-cmd-screenshot" /home/zack/dev/lib/omarchy-archive/

# Case-insensitive search
grep -ri "walker" /home/zack/dev/lib/omarchy-archive/
```

**Recommended alias:**
```bash
# Add to ~/.bashrc
oa() { grep -rn --include="*.md" -C 2 "$1" /home/zack/dev/lib/omarchy-archive/; }

# Usage
oa "theme-set"
```

---

## Documentation Coverage

### Core Areas

- ✅ **All 124 omarchy utility scripts** documented
- ✅ **Complete command reference** with syntax and examples
- ✅ **Theming system** - 12 themes, customization guide
- ✅ **Desktop environment** - Hyprland, Walker, Waybar, Elephant
- ✅ **Package ecosystem** - 149 base + 54 optional packages
- ✅ **Development tools** - Mise, Docker, language environments
- ✅ **System setup** - Hardware, security, power management
- ✅ **Utilities** - Screenshots, sharing, clipboard
- ✅ **Troubleshooting** - Common issues and solutions
- ✅ **Integration guides** - How to extend omarchy

### File Count

- **40 core documentation files** (4 per category)
- **4 meta-documentation files** (README, Claude, QUICK-SEARCH, SCRIPT-MAP)
- **1 archive plan** (design methodology)
- **Total: 45 files**

---

## How to Use This Archive

### Learning Omarchy (First Time)

1. Start with [01-getting-started/overview.md](./01-getting-started/overview.md)
2. Read [01-getting-started/first-run-guide.md](./01-getting-started/first-run-guide.md)
3. Browse [02-core-commands/command-index.md](./02-core-commands/command-index.md)
4. Explore other categories as needed

### Solving Problems

1. Check [10-reference/troubleshooting.md](./10-reference/troubleshooting.md)
2. Search for error messages: `grep -r "error text" .`
3. Review [10-reference/faq.md](./10-reference/faq.md)

### Customizing Your Setup

1. Read [03-theming/theme-system.md](./03-theming/theme-system.md)
2. Explore [09-customization/](./09-customization/)
3. Check [04-desktop-environment/](./04-desktop-environment/)

### Development Work

1. Start with [06-development/mise-integration.md](./06-development/mise-integration.md)
2. Review [06-development/language-environments.md](./06-development/language-environments.md)
3. Configure [06-development/editor-setup.md](./06-development/editor-setup.md)

---

## Documentation Philosophy

### Principles

1. **Examples-First** - Every command has working examples
2. **Self-Contained** - Each file answers its topic completely
3. **Cross-Referenced** - Related topics are linked
4. **Searchable** - Optimized for grep and text search
5. **Practical** - Focus on "how to" rather than "what is"
6. **Complete** - No omarchy feature left undocumented

### Template Structure

Every file follows this format:
- Overview
- Table of contents
- Core concepts
- Syntax/commands
- Progressive examples (basic → advanced)
- Troubleshooting
- Best practices
- Related documentation

---

## Keeping Updated

This archive is based on Omarchy v3.1.1 (2025-10-21).

To update:
```bash
cd /home/zack/dev/lib/omarchy
git pull
# Then regenerate affected documentation files
```

---

## Contributing

This archive is generated documentation. To improve:

1. Identify gaps or errors
2. Check source scripts in `/home/zack/.local/share/omarchy/bin/`
3. Update corresponding documentation file
4. Add timestamp and source reference

---

## Related Resources

- **Omarchy Website**: [omarchy.org](https://omarchy.org)
- **GitHub Repository**: [basecamp/omarchy](https://github.com/basecamp/omarchy)
- **Custom Commands Reference**: See `/home/zack/COMMANDS.md`
- **Hyprland Docs**: See `/home/zack/dev/lib/hyprland-archive/`
- **Ghostty Docs**: See `/home/zack/dev/lib/ghostty-wiki/`
- **Arch Wiki**: [wiki.archlinux.org](https://wiki.archlinux.org/)

---

## Archive Statistics

- **Files**: 40 documentation + 5 meta files
- **Coverage**: 124 scripts, 203 packages, 12 themes
- **Size**: ~1MB of markdown documentation
- **Examples**: 500+ code snippets and configurations
- **Cross-References**: 200+ internal links

---

## Credits

**Created by**: Claude Code (Anthropic)
**Based on**: Omarchy by DHH and 37signals
**Methodology**: Inspired by Hyprland knowledge archive approach
**Purpose**: Efficient knowledge access for users and AI assistants

---

## License

This documentation archive follows the same MIT License as Omarchy itself.

---

**Need help?** Start with [Claude.md](./Claude.md) for AI-optimized navigation or [QUICK-SEARCH.md](./QUICK-SEARCH.md) for search commands.
