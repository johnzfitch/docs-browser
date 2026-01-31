# Quick Search Reference

**Purpose**: Fast ways to find information in the omarchy archive
**Last Updated**: 2025-10-21

---

## Search Command Reference

### Basic Searches

```bash
# Search for any term in archive
grep -r "theme" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Search with line numbers
grep -rn "omarchy-theme-set" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Search with context (2 lines before/after)
grep -rn -C 2 "omarchy-pkg-install" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Case-insensitive search
grep -ri "WALKER" /home/zack/dev/lib/omarchy-archive/ --include="*.md"
```

### Advanced Searches

```bash
# List files containing term
grep -rl "screenshot" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Count occurrences
grep -rc "hyprland" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Search specific category
grep -r "mise" /home/zack/dev/lib/omarchy-archive/06-development/ --include="*.md"

# Search for exact phrase
grep -r "theme system" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Multiple terms (AND)
grep -r "omarchy" /home/zack/dev/lib/omarchy-archive/ --include="*.md" | grep "launch"

# Multiple terms (OR)
grep -rE "theme|font" /home/zack/dev/lib/omarchy-archive/ --include="*.md"
```

### Script-Specific Searches

```bash
# Find script documentation
grep "omarchy-theme-set" /home/zack/dev/lib/omarchy-archive/SCRIPT-MAP.md

# Find all scripts in a category
grep "^omarchy-theme" /home/zack/dev/lib/omarchy-archive/SCRIPT-MAP.md

# Search by script purpose
grep "screenshot" /home/zack/dev/lib/omarchy-archive/SCRIPT-MAP.md
```

---

## Recommended Aliases

Add these to your `~/.bashrc` or `~/.zshrc`:

```bash
# Omarchy archive search
alias oa='grep -rn --include="*.md" -C 2 "$1" /home/zack/dev/lib/omarchy-archive/'

# Omarchy script lookup
alias oas='grep "$1" /home/zack/dev/lib/omarchy-archive/SCRIPT-MAP.md'

# Omarchy archive list
alias oal='ls -la /home/zack/dev/lib/omarchy-archive/'

# Omarchy archive file find
alias oaf='find /home/zack/dev/lib/omarchy-archive -name "*$1*.md"'
```

### Usage Examples

```bash
# Search archive
oa "theme-set"

# Look up script
oas "omarchy-launch-walker"

# Find files with name pattern
oaf "theme"
```

---

## Search by Category

### Getting Started
```bash
grep -r "keyword" /home/zack/dev/lib/omarchy-archive/01-getting-started/ --include="*.md"
```

### Commands
```bash
grep -r "omarchy-pkg" /home/zack/dev/lib/omarchy-archive/02-core-commands/ --include="*.md"
```

### Theming
```bash
grep -r "catppuccin" /home/zack/dev/lib/omarchy-archive/03-theming/ --include="*.md"
```

### Desktop Environment
```bash
grep -r "walker\|waybar\|hyprland" /home/zack/dev/lib/omarchy-archive/04-desktop-environment/ --include="*.md"
```

### Applications
```bash
grep -r "obsidian\|vscode" /home/zack/dev/lib/omarchy-archive/05-applications/ --include="*.md"
```

### Development
```bash
grep -r "mise\|docker" /home/zack/dev/lib/omarchy-archive/06-development/ --include="*.md"
```

### System Setup
```bash
grep -r "audio\|bluetooth\|wifi" /home/zack/dev/lib/omarchy-archive/07-system-setup/ --include="*.md"
```

### Utilities
```bash
grep -r "screenshot\|share" /home/zack/dev/lib/omarchy-archive/08-utilities/ --include="*.md"
```

### Customization
```bash
grep -r "keybinding\|config" /home/zack/dev/lib/omarchy-archive/09-customization/ --include="*.md"
```

### Reference
```bash
grep -r "troubleshoot\|faq" /home/zack/dev/lib/omarchy-archive/10-reference/ --include="*.md"
```

---

## Search Strategies

### Finding Commands

**When you know the command name:**
```bash
# Direct lookup
grep "omarchy-theme-set" /home/zack/dev/lib/omarchy-archive/SCRIPT-MAP.md

# Then read the referenced file
bat /home/zack/dev/lib/omarchy-archive/03-theming/theme-system.md
```

**When you know the category:**
```bash
# Search by command prefix
grep -r "omarchy-pkg-" /home/zack/dev/lib/omarchy-archive/02-core-commands/ --include="*.md"
```

**When you know the purpose:**
```bash
# Search by function
grep -r "install package" /home/zack/dev/lib/omarchy-archive/ --include="*.md"
```

### Finding Configuration

```bash
# Hyprland config
grep -r "hyprland.conf" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Walker config
grep -r "walker/config" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Theme config
grep -r "~/.config/omarchy/current" /home/zack/dev/lib/omarchy-archive/ --include="*.md"
```

### Finding Examples

```bash
# All examples in archive
grep -r "^```" /home/zack/dev/lib/omarchy-archive/ --include="*.md" | wc -l

# Examples for specific topic
grep -A 10 "Example" /home/zack/dev/lib/omarchy-archive/03-theming/theme-system.md

# Code blocks only
grep -A 20 "^```bash" /home/zack/dev/lib/omarchy-archive/ --include="*.md"
```

### Troubleshooting

```bash
# Check troubleshooting guide first
grep -i "error\|issue\|problem" /home/zack/dev/lib/omarchy-archive/10-reference/troubleshooting.md

# Search FAQ
grep -i "question\|why" /home/zack/dev/lib/omarchy-archive/10-reference/faq.md

# Find error messages
grep -r "failed\|error" /home/zack/dev/lib/omarchy-archive/ --include="*.md"
```

---

## Quick File Access

### Direct Paths

```bash
# Getting started
bat /home/zack/dev/lib/omarchy-archive/01-getting-started/overview.md

# Command index
bat /home/zack/dev/lib/omarchy-archive/02-core-commands/command-index.md

# Theme system
bat /home/zack/dev/lib/omarchy-archive/03-theming/theme-system.md

# Quick reference
bat /home/zack/dev/lib/omarchy-archive/10-reference/quick-reference.md

# Troubleshooting
bat /home/zack/dev/lib/omarchy-archive/10-reference/troubleshooting.md

# FAQ
bat /home/zack/dev/lib/omarchy-archive/10-reference/faq.md

# Script map
bat /home/zack/dev/lib/omarchy-archive/SCRIPT-MAP.md
```

---

## Browse with FZF (if installed)

```bash
# Interactive file browser
find /home/zack/dev/lib/omarchy-archive -name "*.md" | fzf --preview 'bat --color=always {}'

# Interactive search
grep -r "." /home/zack/dev/lib/omarchy-archive/ --include="*.md" | fzf --preview 'bat --color=always {1}'
```

---

## Search Tips

### Best Practices

1. **Start broad, narrow down**
   ```bash
   grep -rl "theme" archive/  # Find files
   grep -r "theme-set" archive/03-theming/  # Search specific category
   ```

2. **Use context flags**
   ```bash
   grep -C 3  # 3 lines before/after
   grep -B 5  # 5 lines before
   grep -A 5  # 5 lines after
   ```

3. **Combine with other tools**
   ```bash
   grep -r "theme" archive/ --include="*.md" | less
   grep -r "theme" archive/ --include="*.md" | wc -l
   ```

4. **Check script map first**
   ```bash
   # For command questions, always check script map
   grep "omarchy-whatever" /home/zack/dev/lib/omarchy-archive/SCRIPT-MAP.md
   ```

### Common Patterns

**Find all mentions of a feature:**
```bash
grep -rn "walker" /home/zack/dev/lib/omarchy-archive/ --include="*.md" | less
```

**Find configuration examples:**
```bash
grep -r "~/.config/" /home/zack/dev/lib/omarchy-archive/ --include="*.md"
```

**Find commands by prefix:**
```bash
grep -r "omarchy-launch-" /home/zack/dev/lib/omarchy-archive/ --include="*.md"
```

**Find related topics:**
```bash
# After finding initial topic, search for cross-references
grep -r "See also" /home/zack/dev/lib/omarchy-archive/ --include="*.md"
```

---

## Integration with Tools

### Using with bat

```bash
# Search and preview
search_and_preview() {
    local files=$(grep -rl "$1" /home/zack/dev/lib/omarchy-archive/ --include="*.md")
    echo "$files" | fzf --preview "bat --color=always {}"
}
```

### Using with ripgrep (rg)

```bash
# If ripgrep is installed (faster than grep)
rg "theme" /home/zack/dev/lib/omarchy-archive/ -g "*.md"
rg "omarchy-theme-set" /home/zack/dev/lib/omarchy-archive/ -g "*.md" -C 3
```

---

## Quick Reference Summary

| Task | Command |
|------|---------|
| Search everything | `grep -r "term" archive/ --include="*.md"` |
| Find files | `grep -rl "term" archive/ --include="*.md"` |
| With context | `grep -rn -C 2 "term" archive/ --include="*.md"` |
| Case-insensitive | `grep -ri "term" archive/ --include="*.md"` |
| Script lookup | `grep "script" archive/SCRIPT-MAP.md` |
| Multiple terms | `grep -rE "term1\|term2" archive/ --include="*.md"` |

---

## Related Archives

- **Custom Commands**: `/home/zack/COMMANDS.md` - SSH, mount, and session management commands
- **Hyprland Archive**: `/home/zack/dev/lib/hyprland-archive/` - Hyprland compositor documentation
- **Ghostty Wiki**: `/home/zack/dev/lib/ghostty-wiki/` - Ghostty terminal emulator documentation

---

*For more help, see [Claude.md](./Claude.md) for AI-assisted navigation or [README.md](./README.md) for archive overview.*
