# Editor Setup

## Quick Start

```bash
# Install VS Code
omarchy-install-vscode

# Launch editor for current directory
omarchy-launch-editor .

# Launch editor for specific file
omarchy-launch-editor ~/myproject/README.md

# Set default editor
export EDITOR=nvim  # Add to ~/.bashrc

# Install additional editors
omarchy-pkg-add cursor-bin     # Cursor AI editor
omarchy-pkg-add zed            # Zed editor
omarchy-pkg-add sublime-text-4 # Sublime Text
```

---

## Table of Contents

1. [Overview](#overview)
2. [Neovim (omarchy-nvim)](#neovim-omarchy-nvim)
3. [VS Code](#vs-code)
4. [Cursor](#cursor)
5. [Other Editors](#other-editors)
6. [omarchy-launch-editor](#omarchy-launch-editor)
7. [Theme Integration](#theme-integration)
8. [Examples](#examples)
   - [Basic: Installing and Launching VS Code](#example-1-basic-installing-and-launching-vs-code)
   - [Intermediate: Multi-Editor Workflow](#example-2-intermediate-multi-editor-workflow)
   - [Advanced: Neovim Configuration](#example-3-advanced-neovim-configuration)
9. [Troubleshooting](#troubleshooting)
10. [Best Practices](#best-practices)
11. [Related Documentation](#related-documentation)

---

## Overview

Omarchy supports multiple code editors with deep integration for theming, configuration, and launching. The editor ecosystem in Omarchy includes:

- **Neovim**: Pre-configured terminal-based editor (omarchy-nvim)
- **VS Code**: Microsoft's popular editor with auto-theming
- **Cursor**: AI-first fork of VS Code with Claude integration
- **Zed**: Rust-based collaborative editor
- **Sublime Text**: Fast, lightweight GUI editor
- **Helix**: Modal terminal editor (alternative to Neovim)
- **Micro**: User-friendly terminal editor (nano-like)

All editors integrate with Omarchy's theme system, automatically applying color schemes when you change themes via `omarchy-theme-set`.

The `omarchy-launch-editor` command provides a unified way to open editors regardless of type (terminal or GUI), handling proper session management and environment setup.

---

## Neovim (omarchy-nvim)

### Overview

Neovim is Omarchy's default terminal-based editor. Omarchy includes a pre-configured Neovim setup (omarchy-nvim) with:

- LSP (Language Server Protocol) support
- Syntax highlighting and treesitter
- File explorer and fuzzy finder
- Git integration
- Auto-completion
- Theme synchronization with Omarchy themes

### Installation

Neovim is installed by default with Omarchy. Configuration lives in `~/.config/nvim/`.

### Configuration Location

```
~/.config/nvim/
├── init.lua              # Main configuration entry point
├── lua/
│   ├── plugins/          # Plugin configurations
│   ├── settings.lua      # Editor settings
│   └── keymaps.lua       # Key bindings
└── ...
```

### Launching Neovim

```bash
# Direct launch
nvim file.txt

# Via omarchy-launch-editor
omarchy-launch-editor file.txt
# (If EDITOR=nvim, launches Neovim in terminal)
```

### Theme Integration

Neovim themes are configured in Omarchy theme directories:

```
~/.config/omarchy/themes/tokyo-night/neovim.lua
```

Example `neovim.lua`:

```lua
-- Set colorscheme
vim.cmd('colorscheme tokyonight-night')
```

When you run `omarchy-theme-set tokyo-night`, Neovim automatically loads this configuration via:

```
~/.config/omarchy/current/theme/neovim.lua  # Symlink to active theme
```

### Customization

Add personal Neovim config that survives theme changes:

```lua
-- ~/.config/nvim/init.lua

-- Load theme from Omarchy
local theme_file = vim.fn.expand('~/.config/omarchy/current/theme/neovim.lua')
if vim.fn.filereadable(theme_file) == 1 then
  dofile(theme_file)
end

-- Your custom settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
```

### Common Operations

```bash
# Open file
nvim file.txt

# Open at specific line
nvim +42 file.txt

# Open in read-only mode
nvim -R file.txt

# Diff two files
nvim -d file1.txt file2.txt
```

**Inside Neovim**:
- `:w` - Save file
- `:q` - Quit
- `:wq` - Save and quit
- `:e filename` - Open another file
- `:split` - Horizontal split
- `:vsplit` - Vertical split

---

## VS Code

### Installation

```bash
omarchy-install-vscode
```

**What gets installed**:
- `visual-studio-code-bin` package (from AUR)
- Password store configuration (`~/.vscode/argv.json`)
- Settings to disable auto-updates (managed by pacman instead)

**Auto-launch**: VS Code opens automatically after installation.

### Configuration

**Settings location**: `~/.config/Code/User/settings.json`

**Initial settings** (created by installer):

```json
{
  "update.mode": "none"
}
```

This disables VS Code's built-in updater (use `pacman -Syu` instead).

### Theme Integration

VS Code themes are managed automatically by `omarchy-theme-set-vscode`.

**How it works**:

1. Theme includes `vscode.json`:
   ```json
   {
     "name": "Tokyo Night",
     "extension": "enkia.tokyo-night"
   }
   ```

2. When theme is set, `omarchy-theme-set-vscode`:
   - Installs the extension (`code --install-extension enkia.tokyo-night`)
   - Updates `settings.json` with theme name:
     ```json
     {
       "workbench.colorTheme": "Tokyo Night"
     }
     ```

3. VS Code applies theme immediately (if running)

**Disable auto-theming**:

```bash
# Create skip flag
touch ~/.local/state/omarchy/toggles/skip-vscode-theme-changes

# Now omarchy-theme-set won't modify VS Code
```

### Extensions

```bash
# Install extension via CLI
code --install-extension ms-python.python

# List installed extensions
code --list-extensions

# Uninstall extension
code --uninstall-extension extension-id
```

**Recommended extensions** (install manually):

```bash
# Language support
code --install-extension ms-python.python
code --install-extension rebornix.ruby
code --install-extension golang.go
code --install-extension rust-lang.rust-analyzer

# Tools
code --install-extension eamodio.gitlens
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint

# Themes (if not using Omarchy themes)
code --install-extension enkia.tokyo-night
code --install-extension catppuccin.catppuccin-vsc
```

### Launching VS Code

```bash
# Open current directory
code .

# Open specific file
code file.txt

# Open with omarchy-launch-editor
EDITOR=code omarchy-launch-editor .
```

---

## Cursor

### Overview

Cursor is a fork of VS Code with built-in AI assistance (Claude, GPT-4). It shares VS Code's extension ecosystem but adds AI-powered code completion, chat, and refactoring.

### Installation

```bash
# Install Cursor
omarchy-pkg-add cursor-bin

# Launch Cursor
cursor
```

### Configuration

**Settings location**: `~/.config/Cursor/User/settings.json`

Cursor uses a separate configuration directory from VS Code, but extensions and settings are compatible.

### Theme Integration

Cursor theming works identically to VS Code:

```bash
# Automatically themed via omarchy-theme-set
omarchy-theme-set catppuccin

# Skip Cursor theme changes
touch ~/.local/state/omarchy/toggles/skip-cursor-theme-changes
```

**Implementation**: `omarchy-theme-set-cursor` is a wrapper around `omarchy-theme-set-vscode` with Cursor-specific paths:

```bash
#!/bin/bash
omarchy-theme-set-vscode \
  cursor \
  "$HOME/.config/Cursor/User/settings.json" \
  "$HOME/.local/state/omarchy/toggles/skip-cursor-theme-changes" \
  Cursor
```

### AI Features

Cursor includes:
- **Cmd+K**: AI code generation
- **Cmd+L**: Chat with AI about code
- **Auto-complete**: AI-powered suggestions
- **Codebase awareness**: AI understands your entire project

**API keys**: Configure in Cursor settings for Claude or GPT-4 access.

### Launching Cursor

```bash
# Open current directory
cursor .

# Open specific file
cursor file.txt

# Set as default editor
export EDITOR=cursor
omarchy-launch-editor .
```

---

## Other Editors

### Zed

**Overview**: Fast, Rust-based collaborative editor with built-in multiplayer.

**Installation**:

```bash
omarchy-pkg-add zed
```

**Launching**:

```bash
# Open current directory
zed .

# Open file
zed file.txt
```

**Features**:
- Native performance (Rust)
- Real-time collaboration
- LSP support
- Vim mode
- AI assistance (GPT-4)

### Sublime Text

**Overview**: Lightweight, fast GUI editor with powerful plugin ecosystem.

**Installation**:

```bash
omarchy-pkg-add sublime-text-4
```

**Launching**:

```bash
# Open current directory
subl .

# Open file
subl file.txt
```

**Configuration**: `~/.config/sublime-text/Packages/User/Preferences.sublime-settings`

### Helix

**Overview**: Modal terminal editor (like Neovim) with built-in LSP and treesitter.

**Installation**:

```bash
omarchy-pkg-add helix
```

**Launching**:

```bash
# Open file
hx file.txt

# Or via alias
helix file.txt
```

**Features**:
- No configuration needed (works out of the box)
- Multiple cursors
- LSP built-in
- Vim-like modal editing

### Micro

**Overview**: Terminal editor with nano-like keybindings (no modal editing).

**Installation**:

```bash
omarchy-pkg-add micro
```

**Launching**:

```bash
micro file.txt
```

**Features**:
- Easy to use (Ctrl+S to save, Ctrl+Q to quit)
- Syntax highlighting
- Mouse support
- Plugins

---

## omarchy-launch-editor

### Overview

`omarchy-launch-editor` is a unified launcher for all editors, handling differences between terminal and GUI editors automatically.

### Usage

```bash
omarchy-launch-editor [file|directory]
```

**How it works**:

1. Reads `$EDITOR` environment variable (defaults to `nvim`)
2. Detects if editor is terminal-based or GUI
3. Launches appropriately:
   - **Terminal editors** (nvim, vim, nano, micro, hx, helix): Opens in new terminal window
   - **GUI editors** (code, cursor, zed, subl): Launches directly

### Implementation

```bash
#!/bin/bash

case "${EDITOR:-nvim}" in
nvim | vim | nano | micro | hx | helix)
  # Terminal editor: Launch in terminal
  exec setsid uwsm-app -- "$TERMINAL" -e "$EDITOR" "$@"
  ;;
*)
  # GUI editor: Launch directly
  exec setsid uwsm-app -- "$EDITOR" "$@"
  ;;
esac
```

### Setting Default Editor

```bash
# In ~/.bashrc
export EDITOR=nvim        # Neovim
export EDITOR=code        # VS Code
export EDITOR=cursor      # Cursor
export EDITOR=hx          # Helix
export EDITOR=micro       # Micro

# Reload
source ~/.bashrc
```

### Examples

```bash
# Launch for current directory
omarchy-launch-editor .

# Launch for specific file
omarchy-launch-editor ~/projects/myapp/README.md

# Uses $EDITOR automatically
EDITOR=code omarchy-launch-editor .  # Opens in VS Code
EDITOR=nvim omarchy-launch-editor .  # Opens in Neovim in terminal
```

---

## Theme Integration

### How Editor Theming Works

Omarchy themes can include configurations for multiple editors:

```
~/.config/omarchy/themes/tokyo-night/
├── alacritty.toml       # Terminal theme
├── vscode.json          # VS Code theme
├── neovim.lua           # Neovim colorscheme
└── ...
```

When you run `omarchy-theme-set tokyo-night`:

1. Symlink updated: `~/.config/omarchy/current/theme -> ../themes/tokyo-night`
2. Editor setters run:
   - `omarchy-theme-set-vscode` - Installs extension, updates settings.json
   - `omarchy-theme-set-cursor` - Same for Cursor
   - Neovim: Reads `~/.config/omarchy/current/theme/neovim.lua` on startup

### Supported Editors for Theming

| Editor | Theme File | Auto-Apply | Setter Script |
|--------|------------|------------|---------------|
| Neovim | `neovim.lua` | On restart | Manual load in init.lua |
| VS Code | `vscode.json` | Immediate | `omarchy-theme-set-vscode` |
| Cursor | `vscode.json` | Immediate | `omarchy-theme-set-cursor` |
| Obsidian | `obsidian.css` | On restart | `omarchy-theme-set-obsidian` |

**Note**: Zed, Sublime, Helix require manual theme configuration (not auto-themed by Omarchy).

### Creating Theme Support for Editors

**For VS Code/Cursor** (`vscode.json`):

```json
{
  "name": "Catppuccin Mocha",
  "extension": "catppuccin.catppuccin-vsc"
}
```

**For Neovim** (`neovim.lua`):

```lua
-- Install plugin first (in your Neovim config)
-- Then reference it here
vim.cmd('colorscheme catppuccin-mocha')
```

### Disabling Auto-Theming

```bash
# VS Code
touch ~/.local/state/omarchy/toggles/skip-vscode-theme-changes

# Cursor
touch ~/.local/state/omarchy/toggles/skip-cursor-theme-changes

# Both
mkdir -p ~/.local/state/omarchy/toggles
touch ~/.local/state/omarchy/toggles/skip-vscode-theme-changes
touch ~/.local/state/omarchy/toggles/skip-cursor-theme-changes
```

---

## Examples

### Example 1: Basic - Installing and Launching VS Code

**Scenario**: You want to use VS Code for web development.

```bash
# Step 1: Install VS Code
$ omarchy-install-vscode
Installing VSCode...
[sudo] password for zack:
resolving dependencies...
looking for conflicting packages...

Packages (1) visual-studio-code-bin-1.93.0-1

[...]
# VS Code launches automatically

# Step 2: Set as default editor
$ echo 'export EDITOR=code' >> ~/.bashrc
$ source ~/.bashrc

# Step 3: Test launch
$ cd ~/projects/myapp
$ omarchy-launch-editor .
# VS Code opens with myapp directory

# Step 4: Install extensions
$ code --install-extension esbenp.prettier-vscode
Installing extension 'esbenp.prettier-vscode'...
Extension 'esbenp.prettier-vscode' v10.4.0 was successfully installed.

# Step 5: Change Omarchy theme
$ omarchy-theme-set catppuccin
Setting theme to: catppuccin
[...]

# VS Code theme automatically updates to Catppuccin!
```

**What happened**:
- VS Code installed via AUR
- Configured to use system package manager for updates
- Set as default editor via `$EDITOR`
- `omarchy-launch-editor` opens VS Code
- Theme auto-applies when Omarchy theme changes

---

### Example 2: Intermediate - Multi-Editor Workflow

**Scenario**: Use Neovim for quick edits, VS Code for projects, Cursor for AI assistance.

```bash
# Setup: All editors installed
$ omarchy-pkg-add cursor-bin

# Neovim as default for CLI
$ export EDITOR=nvim

# Quick edit with Neovim
$ omarchy-launch-editor ~/.bashrc
# Opens Neovim in terminal, edit, :wq to save

# Project work with VS Code
$ cd ~/projects/myapp
$ code .
# VS Code opens full project

# AI-assisted coding with Cursor
$ cd ~/projects/experimental
$ cursor .
# Cursor opens with AI features

# Set theme once, applies to all
$ omarchy-theme-set tokyo-night
# All three editors (Neovim, VS Code, Cursor) get Tokyo Night theme
```

**Workflow benefits**:
- **Neovim**: Fast terminal edits, config files, Git commits
- **VS Code**: Full-featured project development, debugging
- **Cursor**: Experimental work with AI pair programming

**Theme consistency**: All editors share the same color scheme automatically.

---

### Example 3: Advanced - Neovim Configuration

**Scenario**: Customize Neovim with plugins while maintaining Omarchy theme integration.

```bash
# Step 1: Check existing config
$ ls ~/.config/nvim/
init.lua  lua/  ...

# Step 2: Edit init.lua to load Omarchy theme
$ nvim ~/.config/nvim/init.lua
```

Add to `init.lua`:

```lua
-- ~/.config/nvim/init.lua

-- Load Omarchy theme if available
local omarchy_theme = vim.fn.expand('~/.config/omarchy/current/theme/neovim.lua')
if vim.fn.filereadable(omarchy_theme) == 1 then
  dofile(omarchy_theme)
else
  -- Fallback theme if Omarchy theme not found
  vim.cmd('colorscheme default')
end

-- Personal settings
vim.opt.number = true          -- Line numbers
vim.opt.relativenumber = true  -- Relative line numbers
vim.opt.expandtab = true       -- Spaces instead of tabs
vim.opt.tabstop = 2            -- 2 spaces per tab
vim.opt.shiftwidth = 2         -- 2 spaces for indentation
vim.opt.smartindent = true     -- Auto-indent new lines

-- Key mappings
vim.g.mapleader = " "  -- Space as leader key

-- Quick save
vim.keymap.set('n', '<leader>w', ':w<CR>')

-- Quick quit
vim.keymap.set('n', '<leader>q', ':q<CR>')

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
```

**Step 3: Install additional plugins** (using lazy.nvim or packer.nvim):

```lua
-- Add to init.lua

-- Install lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup({
  -- File explorer
  "nvim-tree/nvim-tree.lua",

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- LSP support
  "neovim/nvim-lspconfig",

  -- Auto-completion
  "hrsh7th/nvim-cmp",

  -- Git integration
  "lewis6991/gitsigns.nvim",
})
```

**Step 4: Test theme switching**:

```bash
# Change Omarchy theme
$ omarchy-theme-set gruvbox

# Open Neovim
$ nvim test.txt
# Should show Gruvbox colors

# Change theme again
$ omarchy-theme-set catppuccin

# Restart Neovim
$ nvim test.txt
# Should show Catppuccin colors
```

**What happened**:
- Neovim configured to load Omarchy theme dynamically
- Personal settings preserved across theme changes
- Plugins added without breaking theme integration
- Theme changes apply immediately on Neovim restart

---

## Troubleshooting

### Editor Command Not Found

**Problem**: `code: command not found` after installing VS Code

**Solution**: Reload shell or restart terminal

```bash
# Reload
source ~/.bashrc

# Or restart
exec bash

# Or use full path
/usr/bin/code
```

### Theme Not Applying to VS Code

**Problem**: VS Code theme doesn't change when running `omarchy-theme-set`

**Solution**: Check if skip flag exists

```bash
# Check for skip flag
ls ~/.local/state/omarchy/toggles/skip-vscode-theme-changes

# If exists, remove it
rm ~/.local/state/omarchy/toggles/skip-vscode-theme-changes

# Set theme again
omarchy-theme-set tokyo-night
```

**Alternative**: VS Code extension not installed

```bash
# Manually install theme extension
code --install-extension enkia.tokyo-night

# Then set theme in VS Code settings
# Ctrl+, -> search "color theme" -> select Tokyo Night
```

### omarchy-launch-editor Opens Wrong Editor

**Problem**: `omarchy-launch-editor` opens Neovim but you want VS Code

**Solution**: Set `$EDITOR` environment variable

```bash
# Check current editor
echo $EDITOR
# Output: nvim

# Change to VS Code
export EDITOR=code

# Make permanent
echo 'export EDITOR=code' >> ~/.bashrc
source ~/.bashrc

# Test
omarchy-launch-editor .
# Should open VS Code
```

### Neovim Theme Not Loading

**Problem**: Neovim shows default colors instead of Omarchy theme

**Solution**: Check if theme file exists and is loaded

```bash
# Check theme file exists
ls -la ~/.config/omarchy/current/theme/neovim.lua

# Check it's a symlink to active theme
readlink ~/.config/omarchy/current/theme/neovim.lua
# Should show: ../../themes/tokyo-night/neovim.lua (or current theme)

# Verify init.lua loads it
grep -n "omarchy" ~/.config/nvim/init.lua
# Should show dofile() call loading the theme
```

**Fix**: Add theme loading to `init.lua` (see Example 3 above).

### Cursor or VS Code Won't Launch

**Problem**: `cursor` or `code` command hangs or fails to launch

**Solution**: Launch with verbose output

```bash
# Debug VS Code launch
code --verbose

# Debug Cursor launch
cursor --verbose

# Check if process already running
ps aux | grep code
ps aux | grep cursor

# Kill existing processes
pkill code
pkill cursor

# Try launching again
code .
```

---

## Best Practices

### 1. Set One Default Editor

Choose a primary editor and set `$EDITOR`:

```bash
# In ~/.bashrc
export EDITOR=nvim  # or code, cursor, hx, etc.
```

This makes Git commits, `visudo`, and other tools use your preferred editor.

### 2. Use omarchy-launch-editor for Consistency

Instead of calling editors directly:

```bash
# Inconsistent
code .
nvim file.txt
cursor project/

# Consistent
omarchy-launch-editor .
omarchy-launch-editor file.txt
omarchy-launch-editor project/
```

Benefits:
- Works the same regardless of editor choice
- Handles terminal vs GUI editors automatically
- Easy to switch editors by changing `$EDITOR`

### 3. Leverage Theme Auto-Sync

Let Omarchy manage editor themes:

```bash
# Don't manually configure themes in each editor
# Just set Omarchy theme
omarchy-theme-set catppuccin

# All supported editors update automatically
```

### 4. Keep Separate Configs for Different Editors

Don't try to use one config for all editors. Each has strengths:

- **Neovim**: Terminal, SSH, quick edits
- **VS Code**: GUI projects, debugging, extensions
- **Cursor**: AI-assisted development

Use each for what it's best at.

### 5. Install Language Extensions

For full language support, install extensions:

```bash
# VS Code
code --install-extension ms-python.python
code --install-extension rebornix.ruby

# Check what's installed
code --list-extensions
```

### 6. Disable Auto-Theming if You Prefer Manual Control

If you like choosing your own themes:

```bash
touch ~/.local/state/omarchy/toggles/skip-vscode-theme-changes
touch ~/.local/state/omarchy/toggles/skip-cursor-theme-changes
```

### 7. Use Terminal Editors for SSH

When working on remote servers:

```bash
# On remote server
export EDITOR=nvim  # or hx, micro

# Not code or cursor (GUI editors won't work over SSH)
```

---

## Related Documentation

- **[Theme System](../03-theming/theme-system.md)** - Understanding Omarchy's theming
- **[Mise Integration](./mise-integration.md)** - Language runtime management
- **[Language Environments](./language-environments.md)** - Setting up development languages
- **Core Commands** - Package installation and management

**External Resources**:
- [Neovim Documentation](https://neovim.io/doc/)
- [VS Code Documentation](https://code.visualstudio.com/docs)
- [Cursor Documentation](https://cursor.sh/docs)
- [Zed Documentation](https://zed.dev/docs)
- [Helix Documentation](https://docs.helix-editor.com/)
