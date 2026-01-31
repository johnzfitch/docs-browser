# Quick Search Commands

**Fast lookups for the Ghostty Archive**

## Search the Entire Archive

```bash
# Search for any keyword across all documentation
grep -r "keyword" /home/zack/dev/lib/ghostty-wiki/ --include="*.md"

# Search with line numbers
grep -rn "keyword" /home/zack/dev/lib/ghostty-wiki/ --include="*.md"

# Case-insensitive search
grep -ri "keyword" /home/zack/dev/lib/ghostty-wiki/ --include="*.md"

# Search with context (2 lines before/after)
grep -rn -C 2 "keyword" /home/zack/dev/lib/ghostty-wiki/ --include="*.md"
```

## Common Searches

```bash
# Find keybinding examples
grep -r "keybind" /home/zack/dev/lib/ghostty-wiki/02-keybindings/ --include="*.md"

# Find configuration options
grep -r "font" /home/zack/dev/lib/ghostty-wiki/07-reference/ --include="*.md"

# Find color/theme info
grep -r "theme\|color" /home/zack/dev/lib/ghostty-wiki/01-getting-started/ --include="*.md" -i

# Find cursor-related info
grep -r "cursor" /home/zack/dev/lib/ghostty-wiki/04-control-sequences/ --include="*.md" -i

# Find platform-specific info
grep -r "linux\|macos" /home/zack/dev/lib/ghostty-wiki/06-platform-specific/ --include="*.md" -i

# Find shell integration
grep -r "shell" /home/zack/dev/lib/ghostty-wiki/01-getting-started/ --include="*.md" -i
```

## Search Specific Sections

```bash
# Getting started only
grep -r "keyword" /home/zack/dev/lib/ghostty-wiki/01-getting-started/ --include="*.md"

# Keybindings only
grep -r "keyword" /home/zack/dev/lib/ghostty-wiki/02-keybindings/ --include="*.md"

# Control sequences only
grep -r "keyword" /home/zack/dev/lib/ghostty-wiki/04-control-sequences/ --include="*.md"

# Platform-specific only
grep -r "keyword" /home/zack/dev/lib/ghostty-wiki/06-platform-specific/ --include="*.md"

# Reference only
grep -r "keyword" /home/zack/dev/lib/ghostty-wiki/07-reference/ --include="*.md"
```

## Shell Alias (Optional)

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# Search Ghostty archive
alias ghostty-search='grep -rn --include="*.md" -C 2'

# Usage: ghostty-search "keyword" /home/zack/dev/lib/ghostty-wiki/
```

Or even better:

```bash
# Search Ghostty archive (short version)
gs() {
    grep -rn --include="*.md" -C 2 "$1" /home/zack/dev/lib/ghostty-wiki/
}

# Usage: gs "keyword"
```

## Quick File Access

```bash
# Master index
cat /home/zack/dev/lib/ghostty-wiki/Claude.md

# Complete config reference
cat /home/zack/dev/lib/ghostty-wiki/07-reference/ghostty.config.md

# Option reference
cat /home/zack/dev/lib/ghostty-wiki/07-reference/Option\ Reference\ -\ Configuration.md

# Keybinding actions
cat /home/zack/dev/lib/ghostty-wiki/02-keybindings/Action\ Reference\ -\ Keybindings.md

# Configuration guide
cat /home/zack/dev/lib/ghostty-wiki/01-getting-started/Configuration.md
```

## Finding Specific Config Syntax

```bash
# Font configuration
grep -A 10 "font" /home/zack/dev/lib/ghostty-wiki/07-reference/Option\ Reference\ -\ Configuration.md | head -20

# Theme configuration
grep -A 10 "theme" /home/zack/dev/lib/ghostty-wiki/01-getting-started/Color\ Theme\ -\ Features.md | head -20

# Keybind syntax
grep -A 10 "keybind" /home/zack/dev/lib/ghostty-wiki/02-keybindings/Keybindings\ -\ Configuration.md | head -20
```

## Browser Integration (SUPER + G)

Instead of manual grep commands, use the integrated browser:

```bash
# Press SUPER + G
# Type your search query
# Select result
# Choose action (Preview, Edit, Copy)
```

**Benefits:**
- Walker themed UI
- Formatted results
- Quick actions
- Line number navigation
- No need to remember grep syntax

---

## Related Archives

- **Custom Commands**: `/home/zack/COMMANDS.md` - SSH, mount, and session management commands
- **Omarchy Archive**: `/home/zack/dev/lib/omarchy-archive/` - Omarchy system documentation
- **Hyprland Archive**: `/home/zack/dev/lib/hyprland-archive/` - Hyprland compositor documentation

---

**Bookmark this file for instant access to search commands!**

**Pro Tip:** Use `SUPER + G` for the best experience with walker integration.
