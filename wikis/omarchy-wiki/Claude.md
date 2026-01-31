# Claude.md - AI Assistant Navigation Guide

**Purpose**: Optimized navigation structure for Claude Code and AI assistants
**Archive Location**: `/home/zack/dev/lib/omarchy-archive/`
**Last Updated**: 2025-10-21

---

## Quick Context

You are working with the **Omarchy Knowledge Archive** - a comprehensive, distilled documentation set for the complete Omarchy system (Arch Linux + Hyprland desktop environment).

### Key Facts
- **40 documentation files** across 10 categories
- **124 omarchy utility scripts** fully documented
- **203 packages** (149 base + 54 optional)
- **12 themes** with customization guides
- **Complete coverage** of commands, configs, and workflows

---

## When to Use This Archive

### ✅ DO Use This Archive For:
- Questions about omarchy commands (`omarchy-*`)
- Theming and customization
- Package management
- Development environment setup
- System configuration
- Troubleshooting omarchy issues
- Understanding omarchy architecture
- Script functionality lookups

### ❌ DO NOT Use This Archive For:
- General Hyprland questions → Use `/home/zack/dev/lib/hyprland-archive/`
- General Arch Linux questions → Search web or Arch Wiki
- Non-omarchy software → Use software's own documentation

---

## Archive Structure (Mental Model)

```
📁 omarchy-archive/
├── 01-getting-started/      [Start here for new users]
├── 02-core-commands/        [Most common: command lookups]
├── 03-theming/              [Visual customization]
├── 04-desktop-environment/  [Hyprland/Walker/Waybar]
├── 05-applications/         [Software ecosystem]
├── 06-development/          [Dev tools & environments]
├── 07-system-setup/         [Hardware & security]
├── 08-utilities/            [Daily tools & scripts]
├── 09-customization/        [Advanced config]
└── 10-reference/            [Quick lookups & troubleshooting]
```

---

## Navigation Strategy

### For User Questions

**1. Identify Question Type:**

| Question Type | Primary Category | Secondary Category |
|--------------|------------------|-------------------|
| "How do I [command]?" | `02-core-commands/` | `10-reference/quick-reference.md` |
| "How do I change theme?" | `03-theming/theme-system.md` | - |
| "What does omarchy-X do?" | `SCRIPT-MAP.md` → specific file | - |
| "How do I install X?" | `02-core-commands/package-management.md` | `05-applications/` |
| "X doesn't work" | `10-reference/troubleshooting.md` | Relevant category |
| "How does omarchy work?" | `01-getting-started/architecture.md` | - |
| "Setup my dev environment" | `06-development/` | - |
| "Configure monitors/audio/etc" | `07-system-setup/` | - |

**2. Read Strategy:**

**Option A - Quick Lookup (Use First):**
```bash
grep -r "keyword" /home/zack/dev/lib/omarchy-archive/ --include="*.md" -n -C 2
```

**Option B - File Read (If grep narrows it down):**
Read specific file identified by grep

**Option C - Index Lookup:**
Check `SCRIPT-MAP.md` for script → documentation mapping

### For Script Questions

**User asks about specific script (`omarchy-something`):**

1. Check `SCRIPT-MAP.md` - maps all 124 scripts to docs
2. Read the referenced documentation file
3. Provide answer with examples from that file

---

## Category-Specific Guidance

### 01-getting-started/
**When**: User is new to omarchy or asks "what is omarchy"
**Files**:
- `overview.md` - System overview, philosophy
- `architecture.md` - How omarchy components fit together
- `installation.md` - Install process, boot.sh, package lists
- `first-run-guide.md` - Initial setup after installation

### 02-core-commands/
**When**: User asks how to use omarchy commands (MOST COMMON)
**Files**:
- `command-index.md` - A-Z listing of ALL commands
- `package-management.md` - omarchy-pkg-*, omarchy-tui-*, omarchy-webapp-*
- `system-management.md` - omarchy-update*, omarchy-refresh*, omarchy-restart*
- `launcher-commands.md` - omarchy-launch-*, omarchy-cmd-*

### 03-theming/
**When**: User wants to customize appearance
**Files**:
- `theme-system.md` - How themes work, omarchy-theme-*
- `fonts.md` - Font management
- `backgrounds.md` - Background images
- `creating-themes.md` - Building custom themes

### 04-desktop-environment/
**When**: Questions about Hyprland, Walker, Waybar
**Files**:
- `hyprland-integration.md` - How omarchy uses Hyprland
- `walker-elephant.md` - Launcher system, providers
- `waybar-configuration.md` - Status bar
- `window-management.md` - Window rules, workspaces

### 05-applications/
**When**: Questions about installed software
**Files**:
- `core-applications.md` - Essential apps
- `development-tools.md` - Dev-specific tools
- `media-tools.md` - OBS, video, audio
- `productivity-apps.md` - Obsidian, LibreOffice

### 06-development/
**When**: Setting up or using development tools
**Files**:
- `mise-integration.md` - Runtime version management
- `docker-setup.md` - Container development
- `language-environments.md` - Ruby, Node, Go, Python, etc.
- `editor-setup.md` - Neovim, VSCode, Cursor, Zed

### 07-system-setup/
**When**: Hardware, drivers, security configuration
**Files**:
- `audio-bluetooth-wifi.md` - Connectivity
- `monitors-input.md` - Display and input devices
- `security-auth.md` - Fingerprint, Fido2, encryption
- `power-management.md` - Battery, power profiles

### 08-utilities/
**When**: Daily-use tools and helper scripts
**Files**:
- `screenshot-screenrecord.md` - Capture tools
- `file-sharing.md` - Sharing and transfer
- `clipboard-management.md` - Clipboard tools
- `utility-scripts.md` - Miscellaneous helpers

### 09-customization/
**When**: Advanced tweaking and configuration
**Files**:
- `config-management.md` - Config system structure
- `keybindings.md` - Keyboard shortcuts
- `autostart-scripts.md` - Startup automation
- `advanced-tweaks.md` - Expert-level mods

### 10-reference/
**When**: Quick lookups, troubleshooting, FAQ (CHECK FIRST for problems)
**Files**:
- `quick-reference.md` - Cheat sheet (READ THIS FIRST for quick questions)
- `troubleshooting.md` - Common issues (READ THIS FIRST for problems)
- `faq.md` - Frequently asked questions
- `script-index.md` - Detailed script documentation

---

## Search Patterns

### Finding Commands
```bash
# Find all references to a command
grep -r "omarchy-theme-set" /home/zack/dev/lib/omarchy-archive/ --include="*.md"

# Find command syntax
grep -rn "omarchy-pkg-install" /home/zack/dev/lib/omarchy-archive/ -A 3
```

### Finding Topics
```bash
# Find theme-related content
grep -r "theme" /home/zack/dev/lib/omarchy-archive/ --include="*.md" -l

# Find examples
grep -r "Example" /home/zack/dev/lib/omarchy-archive/03-theming/ -n
```

### Script Lookup
```bash
# Find which file documents a script
grep "omarchy-launch-walker" /home/zack/dev/lib/omarchy-archive/SCRIPT-MAP.md
```

---

## Response Strategy

### When Answering Questions:

1. **Cite Source**: Always mention which file(s) you referenced
   - Example: "According to `02-core-commands/command-index.md`..."

2. **Provide Examples**: Extract actual examples from the docs
   - Don't invent examples, use documented ones

3. **Cross-Reference**: If multiple files are relevant, mention them
   - Example: "See also `03-theming/theme-system.md` for theme details"

4. **File Path Format**: When referencing code locations, use this format:
   - Format: `/home/zack/.local/share/omarchy/bin/omarchy-theme-set:123`
   - Means: script at line 123

5. **Check Freshness**: Note the "Last Updated" timestamp in files
   - If docs seem outdated, mention this to user

---

## Common Patterns

### Pattern 1: Command Usage Question
```
User: "How do I install a package?"
Your Response:
1. Read: 02-core-commands/package-management.md
2. Extract: Command syntax + examples
3. Answer: With syntax, example, and any caveats
4. Cite: "From package-management.md, section 'Installing Packages'"
```

### Pattern 2: Troubleshooting
```
User: "Theme won't apply"
Your Response:
1. Read: 10-reference/troubleshooting.md (check first!)
2. If not there, read: 03-theming/theme-system.md
3. Answer: With troubleshooting steps
4. Cite: Source file and section
```

### Pattern 3: Understanding System
```
User: "How does omarchy work?"
Your Response:
1. Read: 01-getting-started/architecture.md
2. Optionally read: 01-getting-started/overview.md
3. Answer: High-level explanation with key components
4. Offer: "Would you like details on any specific component?"
```

### Pattern 4: Script Functionality
```
User: "What does omarchy-theme-next do?"
Your Response:
1. Check: SCRIPT-MAP.md for the script
2. Read: Referenced file (likely 03-theming/theme-system.md)
3. Answer: What it does, syntax, example
4. Cite: Both SCRIPT-MAP and main doc file
```

---

## Special Files

### SCRIPT-MAP.md
**Purpose**: Maps all 124 scripts to their documentation
**Use**: When user asks about specific `omarchy-*` command
**Format**: `script-name` → `category/file.md#section`

### QUICK-SEARCH.md
**Purpose**: Search command reference
**Use**: Show user how to search archive themselves
**Contains**: Grep patterns, aliases, search strategies

### ARCHIVE-PLAN.md
**Purpose**: Documentation methodology and design decisions
**Use**: Understanding archive structure and philosophy
**Contains**: Why categories exist, template structure, coverage goals

---

## Performance Tips

### Context Efficiency

**DO**:
- Use grep first to narrow down files
- Read only relevant sections when possible
- Reference line numbers when citing
- Keep responses focused on archive content

**DON'T**:
- Read entire categories unless necessary
- Fabricate examples not in docs
- Mix omarchy docs with other sources without clarification
- Assume docs are complete (note gaps if found)

---

## Error Handling

### If Documentation Is Missing:
1. Check `SCRIPT-MAP.md` - maybe it's elsewhere
2. Search entire archive with grep
3. If truly missing: "This specific topic isn't fully documented yet. Based on the script at `/home/zack/.local/share/omarchy/bin/[script]`, here's what it does..."
4. Suggest: Creating documentation for that topic

### If Documentation Is Outdated:
1. Note the "Last Updated" date
2. Mention: "Documentation is from [date], current omarchy is [version]"
3. Suggest: "You may want to check the script directly at [path]"

### If Question Is Ambiguous:
1. Check multiple relevant files
2. Provide answer with: "If you're asking about [A], see [file]. If you mean [B], see [other file]"

---

## Integration with Other Archives

### Hyprland Archive
Location: `/home/zack/dev/lib/hyprland-archive/`
When: Questions about Hyprland specifics (not omarchy integration)
Overlap: Window rules, bindings, Hyprland config
**Strategy**: Refer to Hyprland archive for Hyprland-specific questions, this archive for "how omarchy uses Hyprland"

---

## Examples of Good Responses

### Example 1: Command Question
```
User: "How do I switch themes?"
Claude:
Based on 03-theming/theme-system.md:

Use `omarchy-theme-set <theme-name>`:
\`\`\`bash
omarchy-theme-set catppuccin
\`\`\`

Or cycle through themes:
\`\`\`bash
omarchy-theme-next
\`\`\`

To see available themes:
\`\`\`bash
omarchy-theme-list
\`\`\`

The theme system updates all applications (Hyprland, Walker, terminals, etc.)
automatically. See 03-theming/creating-themes.md if you want to create custom themes.
```

### Example 2: Troubleshooting
```
User: "Walker won't launch"
Claude:
According to 10-reference/troubleshooting.md, here are the steps:

1. Check if walker is running:
\`\`\`bash
pgrep walker
\`\`\`

2. Restart walker service:
\`\`\`bash
omarchy-restart-walker
\`\`\`

3. Check for errors:
\`\`\`bash
journalctl --user -u walker -n 50
\`\`\`

If issues persist, see 04-desktop-environment/walker-elephant.md for detailed
walker configuration and debugging steps.
```

---

## Final Reminders

1. **Always search first** - grep before reading entire files
2. **Cite your sources** - mention which file you used
3. **Use actual examples** - from the docs, not invented
4. **Cross-reference** - link related topics
5. **Note timestamps** - docs may be outdated
6. **Check SCRIPT-MAP** - for script-specific questions
7. **Start with reference/** - for quick questions and troubleshooting

---

**Archive Version**: 1.0
**Compatible With**: Omarchy v3.1.1
**Next Update**: When omarchy updates significantly

---

*This file optimizes your ability to help users quickly and accurately. Follow these patterns for best results.*
