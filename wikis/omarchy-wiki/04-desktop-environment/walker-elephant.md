# Walker & Elephant

## Quick Start

```bash
# Launch Walker (Super + Space)
omarchy-launch-walker

# Restart Walker service
omarchy-restart-walker

# Search for applications
# (just start typing)

# Use prefixes for specific providers
/           # Provider list
.filename   # Files
:symbol     # Symbols
=2+2        # Calculator
@search     # Web search
$           # Clipboard
```

---

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Provider System](#provider-system)
4. [Commands Reference](#commands-reference)
5. [Examples](#examples)
   - [Basic: Launching Applications](#example-1-basic-launching-applications)
   - [Intermediate: Using Different Providers](#example-2-intermediate-using-different-providers)
   - [Advanced: Creating Custom Providers](#example-3-advanced-creating-custom-providers)
6. [Configuration](#configuration)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)
9. [Related Documentation](#related-documentation)

---

## Overview

Walker is Omarchy's application launcher and command palette. It's a fast, extensible launcher that can search applications, files, run calculations, search the web, manage clipboard history, and much more through its plugin-based provider system.

Elephant is the backend daemon that powers Walker's provider system. It runs continuously in the background, maintaining search indices and providing real-time results to Walker. Together, they form a powerful launcher that adapts to different workflows through 12+ built-in providers.

Walker in Omarchy is configured to launch with `Super + Space`, providing instant access to your entire system. The interface is minimal, theme-aware, and responds in milliseconds. Type to search across all default providers, or use prefixes to access specific functionality directly.

---

## Architecture

### Components

**Walker** - The frontend launcher
- GTK4-based floating window
- Fuzzy search across multiple providers
- Keyboard-driven interface
- Theme integration via Omarchy

**Elephant** - The backend service
- Maintains search indices
- Handles provider queries
- Runs as systemd user service
- Provides real-time results

**Providers** - Plugin modules that power different features:
- **desktopapplications** - Application launcher
- **websearch** - Web search with history
- **files** - File browser and search
- **clipboard** - Clipboard manager
- **calc** - Calculator
- **symbols** - Unicode/emoji picker
- **bluetooth** - Bluetooth device manager
- **menus** - Omarchy system menus
- **runner** - Command runner
- **todo** - Quick todo list
- **unicode** - Unicode character search
- **providerlist** - Switch between providers

### Data Flow

```
User Input → Walker → Elephant → Provider → Results → Walker → Display
```

1. User types in Walker
2. Walker sends query to Elephant
3. Elephant queries active providers
4. Providers return results
5. Walker displays ranked results
6. User selects result
7. Provider-specific action executes

---

## Provider System

### Default Providers

When Walker launches, it queries three providers by default:

1. **desktopapplications** - Installed applications
2. **menus** - Omarchy system menus
3. **websearch** - Web search

Type to search across all three simultaneously. The most relevant results appear first, ranked by usage frequency and fuzzy match score.

### Prefix-Based Providers

Use prefixes to access specific providers directly:

| Prefix | Provider | Description | Example |
|--------|----------|-------------|---------|
| `/` | providerlist | Show all available providers | `/` |
| `.` | files | File browser and search | `.config` |
| `:` | symbols | Symbol/emoji picker | `:smile` |
| `=` | calc | Calculator | `=2+2*5` |
| `@` | websearch | Web search | `@hyprland wiki` |
| `$` | clipboard | Clipboard history | `$` |

### Provider Details

#### 1. Desktop Applications (`desktopapplications`)

Searches installed applications from `.desktop` files.

**Features:**
- Fuzzy search by app name
- Frequency-based ranking (most-used apps first)
- Pin favorite apps to top
- Clear application history

**Actions:**
- `Return` - Launch application
- `Shift + Return` - Launch and keep Walker open
- `Ctrl + H` - Clear launch history
- `Ctrl + P` - Pin/unpin application
- `Ctrl + N` - Move pinned app up
- `Ctrl + M` - Move pinned app down

**Examples:**
```
firefox          → Launch Firefox
term             → Launch terminal (fuzzy match)
code             → Launch VS Code
```

#### 2. Files (`.filename`)

Browse and search files starting from home or current directory.

**Features:**
- Navigate directories
- Fuzzy file search
- Open files with default application
- Copy file paths to clipboard

**Actions:**
- `Return` - Open file
- `Ctrl + Return` - Open containing directory
- `Ctrl + Shift + C` - Copy file path
- `Ctrl + C` - Copy file content

**Examples:**
```
.hyprland.conf   → Find Hyprland config
.Documents       → Browse Documents folder
.script.sh       → Find shell scripts
```

#### 3. Calculator (`=expression`)

Evaluate mathematical expressions.

**Features:**
- Basic arithmetic (`+`, `-`, `*`, `/`)
- Advanced functions (`sin`, `cos`, `sqrt`, `log`)
- Constants (`pi`, `e`)
- Save results for later

**Actions:**
- `Return` - Copy result to clipboard
- `Ctrl + S` - Save result to history
- `Ctrl + D` - Delete from history

**Examples:**
```
=2+2             → 4
=sqrt(144)       → 12
=pi * 5^2        → 78.54
=sin(45)         → 0.707
```

#### 4. Web Search (`@query`)

Search the web with your default browser.

**Features:**
- Instant search
- Search history
- Clear history

**Actions:**
- `Return` - Search in browser
- `Ctrl + H` - Clear search history

**Examples:**
```
@hyprland wiki           → Search "hyprland wiki"
@weather tokyo           → Search weather
@github omarchy          → Search GitHub
```

#### 5. Clipboard (`$`)

Manage clipboard history.

**Features:**
- Text history (last 100 items)
- Image support (can be toggled)
- Edit clipboard items
- Search through history

**Actions:**
- `Return` - Copy to clipboard
- `Ctrl + D` - Remove item
- `Ctrl + Shift + D` - Clear all history
- `Ctrl + I` - Toggle image history
- `Ctrl + O` - Edit clipboard item

**Examples:**
```
$                → Show all clipboard items
$password        → Search for "password" in clipboard
$http            → Find URLs in clipboard
```

#### 6. Symbols (`:symbol`)

Insert unicode symbols and emojis.

**Features:**
- Search by name
- Recently used symbols
- Categories (emoji, math, arrows, etc.)

**Actions:**
- `Return` - Copy symbol to clipboard
- `Ctrl + H` - Clear symbol history

**Examples:**
```
:smile           → 😊
:arrow           → →, ←, ↑, ↓
:check           → ✓, ✔
:lambda          → λ
```

#### 7. Bluetooth (`bluetooth`)

Manage Bluetooth devices.

**Features:**
- Discover nearby devices
- Pair/unpair devices
- Connect/disconnect
- Trust/untrust devices

**Actions:**
- `Ctrl + F` - Start device discovery
- `Return` - Pair/connect device
- `Ctrl + T` - Trust/untrust device
- `Ctrl + D` - Remove device

**Examples:**
```
# Open bluetooth provider, then:
# - Type device name to filter
# - Press Ctrl+F to discover new devices
# - Press Return to connect
```

#### 8. Menus (`menus`)

Access Omarchy system menus.

**Features:**
- Power menu (shutdown, reboot, etc.)
- Settings shortcuts
- System utilities

**Actions:**
- `Return` - Execute menu action

**Examples:**
```
power            → Power options menu
wifi             → WiFi settings
bluetooth        → Bluetooth settings
```

#### 9. Runner (`runner`)

Execute shell commands.

**Features:**
- Run commands directly
- Run in terminal
- Command history

**Actions:**
- `Return` - Run command
- `Shift + Return` - Run in terminal
- `Ctrl + H` - Clear command history

**Examples:**
```
neofetch         → Run neofetch
btop             → Launch btop in terminal
```

#### 10. Todo (`todo`)

Quick todo list manager.

**Features:**
- Add tasks quickly
- Mark tasks as done
- Active/inactive tasks
- Clear completed tasks

**Actions:**
- `Return` - Save new task / toggle task status
- `Ctrl + F` - Mark as done
- `Ctrl + D` - Delete task
- `Ctrl + X` - Clear all tasks

**Examples:**
```
# Type your todo item and press Return to save
Buy groceries
Call dentist
Fix bug in script
```

#### 11. Unicode (`unicode`)

Search and insert Unicode characters.

**Features:**
- Full Unicode database
- Search by name or code
- Recently used characters

**Actions:**
- `Return` - Copy character to clipboard
- `Ctrl + H` - Clear history

**Examples:**
```
snowman          → ☃
infinity         → ∞
degree           → °
```

#### 12. Provider List (`/`)

Switch between providers dynamically.

**Features:**
- See all available providers
- Quick provider switching
- Provider descriptions

**Actions:**
- `Return` - Switch to provider

**Examples:**
```
/                → Show all providers
/files           → Switch to files provider
/calc            → Switch to calculator
```

---

## Commands Reference

### omarchy-launch-walker

Launches Walker with proper environment setup.

```bash
# Launch Walker (also bound to Super + Space)
omarchy-launch-walker

# Launch with specific size
omarchy-launch-walker --width 800 --maxheight 400

# Launch with specific provider
omarchy-launch-walker --provider files
```

**What it does:**
1. Ensures Elephant daemon is running
2. Ensures Walker service is running
3. Launches Walker window with configured size
4. Sets up proper environment variables

**Default dimensions:**
- Width: 644px
- Min height: 300px
- Max height: 300px (expands with results)

### omarchy-restart-walker

Restarts both Walker and Elephant services.

```bash
# Restart everything
omarchy-restart-walker
```

**When to use:**
- After changing Walker configuration
- After installing new providers
- When Walker becomes unresponsive
- After theme changes

**What it does:**
1. Stops Walker service
2. Stops Elephant daemon
3. Restarts both services
4. Reloads configuration

---

## Examples

### Example 1: Basic - Launching Applications

**Scenario:** You want to quickly launch applications without using the mouse.

**Solution:**

```bash
# Press Super + Space to open Walker, then type:

firefox          # Launch Firefox browser
term             # Launch terminal (fuzzy matches "terminal")
code             # Launch VS Code
spot             # Launch Spotify (fuzzy match)
```

**Tips:**
- Walker learns from your usage - frequently used apps appear first
- You don't need to type the full name (fuzzy search)
- Press `Shift + Return` to keep Walker open after launching
- Pin frequently used apps with `Ctrl + P`

---

### Example 2: Intermediate - Using Different Providers

**Scenario:** You need to perform different tasks using various Walker providers.

**Solution:**

**Calculate a tip:**
```
# Super + Space, then:
=125 * 0.15      # Calculate 15% tip on $125
# Result: 18.75
# Press Return to copy to clipboard
```

**Find a file:**
```
# Super + Space, then:
.hyprland        # Search for Hyprland config
# Navigate with arrows, press Return to open
# Or Ctrl + Shift + C to copy path
```

**Insert an emoji:**
```
# Super + Space, then:
:heart           # Search for heart emoji
# Select the one you want, press Return to copy
```

**Search the web:**
```
# Super + Space, then:
@linux commands  # Search "linux commands"
# Press Return to open search in browser
```

**Paste from history:**
```
# Super + Space, then:
$                # Show clipboard history
# Type to filter, Return to copy back to clipboard
```

---

### Example 3: Advanced - Creating Custom Providers

**Scenario:** You want to create a custom provider for searching your project documentation.

**Note:** Custom providers require Elephant plugin development in Rust. This is an advanced topic - see Elephant documentation for details.

**Provider architecture:**

```rust
// Example provider structure
pub struct DocsProvider {
    docs_path: PathBuf,
    index: HashMap<String, DocEntry>,
}

impl Provider for DocsProvider {
    fn name(&self) -> &str {
        "docs"
    }

    fn query(&self, query: &str) -> Vec<Result> {
        // Search logic here
        self.index.iter()
            .filter(|(_, doc)| doc.title.contains(query))
            .map(|(_, doc)| Result::from(doc))
            .collect()
    }

    fn activate(&self, result: &Result) {
        // Open documentation file
        std::process::Command::new("xdg-open")
            .arg(&result.path)
            .spawn()
            .ok();
    }
}
```

**For simpler custom search functionality:**

Use the `runner` provider with a custom script:

```bash
# Create ~/bin/search-docs.sh
#!/bin/bash
query="$1"
fd "$query" ~/docs/ | fzf | xargs xdg-open

# Make executable
chmod +x ~/bin/search-docs.sh

# Use from Walker:
# Super + Space, then:
search-docs.sh keyword
# Or press Shift + Return to run in terminal
```

---

## Configuration

### Walker Configuration

Location: `~/.local/share/omarchy/config/walker/config.toml`

**Note:** This is managed by Omarchy. For user customization, create:
`~/.config/walker/config.toml` (overrides defaults)

**Key settings:**

```toml
# Behavior
force_keyboard_focus = true      # Keep focus in Walker
close_when_open = true            # Close if opened again
selection_wrap = true             # Wrap at top/bottom
click_to_close = true             # Click outside to close

# Search
exact_search_prefix = "'"         # ' prefix disables fuzzy search
global_argument_delimiter = "#"   # Delimiter for arguments

# Theme
theme = "omarchy-default"
additional_theme_location = "~/.local/share/omarchy/default/walker/themes/"

# Window positioning
[shell]
anchor_top = true
anchor_bottom = true
anchor_left = true
anchor_right = true

# Default providers (active without prefix)
[providers]
default = [
  "desktopapplications",
  "menus",
  "websearch",
]
empty = ["desktopapplications"]   # Show when no query
max_results = 50                   # Global max results

# Provider-specific prefixes
[[providers.prefixes]]
prefix = "/"
provider = "providerlist"

[[providers.prefixes]]
prefix = "."
provider = "files"

[[providers.prefixes]]
prefix = ":"
provider = "symbols"

[[providers.prefixes]]
prefix = "="
provider = "calc"

[[providers.prefixes]]
prefix = "@"
provider = "websearch"

[[providers.prefixes]]
prefix = "$"
provider = "clipboard"
```

### Keybindings

```toml
[keybinds]
close = ["Escape"]
next = ["Down"]
previous = ["Up"]
toggle_exact = ["ctrl e"]        # Toggle exact vs fuzzy search
resume_last_query = ["ctrl r"]   # Restore last search
quick_activate = []               # Activate without opening (disabled)
```

### Custom Actions

Provider-specific actions are defined in the `[providers.actions]` section:

```toml
[providers.actions]

desktopapplications = [
  { action = "start", default = true, bind = "Return" },
  { action = "start:keep", label = "open+next", bind = "shift Return", after = "KeepOpen" },
  { action = "pin", bind = "ctrl p", after = "AsyncReload" },
  { action = "erase_history", label = "clear hist", bind = "ctrl h", after = "AsyncReload" },
]

files = [
  { action = "open", default = true, bind = "Return" },
  { action = "opendir", label = "open dir", bind = "ctrl Return" },
  { action = "copypath", label = "copy path", bind = "ctrl shift c" },
  { action = "copyfile", label = "copy file", bind = "ctrl c" },
]

calc = [
  { action = "copy", default = true, bind = "Return" },
  { action = "delete", bind = "ctrl d", after = "AsyncReload" },
  { action = "save", bind = "ctrl s", after = "AsyncClearReload" },
]
```

---

## Troubleshooting

### Walker Doesn't Open

**Problem:** Pressing `Super + Space` does nothing.

**Solutions:**

```bash
# 1. Check if Elephant is running
pgrep elephant

# 2. Check if Walker service is running
pgrep -f "walker --gapplication-service"

# 3. Restart both
omarchy-restart-walker

# 4. Launch manually to see errors
omarchy-launch-walker

# 5. Check logs
journalctl --user -u walker.service -n 50
journalctl --user -u elephant.service -n 50
```

### Slow Search Results

**Problem:** Results take too long to appear.

**Solutions:**

```bash
# 1. Rebuild Elephant indices
systemctl --user restart elephant.service

# 2. Reduce max_results in config
# Edit ~/.config/walker/config.toml:
[providers]
max_results = 20  # Lower from 50

# 3. Disable heavy providers from defaults
[providers]
default = [
  "desktopapplications",  # Keep
  # "websearch",          # Disable
  # "files",              # Disable
]

# 4. Restart Walker
omarchy-restart-walker
```

### Clipboard History Missing

**Problem:** Clipboard provider shows no history.

**Solutions:**

```bash
# 1. Ensure Elephant clipboard manager is running
pgrep elephant

# 2. Check if clipboard items are being saved
# Copy something, then:
omarchy-launch-walker
# Type: $

# 3. Clear clipboard history and start fresh
# In Walker: $ then Ctrl + Shift + D

# 4. Check Elephant logs
journalctl --user -u elephant.service | grep clipboard
```

### Provider Not Available

**Problem:** A provider doesn't show up when using its prefix.

**Solutions:**

```bash
# 1. Check if provider is configured
cat ~/.local/share/omarchy/config/walker/config.toml | grep -A2 "prefix = \".\""

# 2. Verify Elephant supports the provider
# Launch Walker and type: /
# Look for the provider in the list

# 3. Restart services
omarchy-restart-walker

# 4. Check for configuration errors
journalctl --user -u walker.service -n 50
```

### Keybindings Not Working

**Problem:** Provider-specific keybindings don't work.

**Solutions:**

```bash
# 1. Check your custom config doesn't override actions
cat ~/.config/walker/config.toml | grep -A10 "providers.actions"

# 2. Remove conflicting keybindings
# Edit ~/.config/walker/config.toml
# Comment out conflicting action definitions

# 3. Use default keybindings
# Remove custom [providers.actions] section entirely

# 4. Restart Walker
omarchy-restart-walker
```

---

## Best Practices

### 1. Pin Frequently Used Apps

```bash
# In Walker:
# 1. Type app name (e.g., "firefox")
# 2. Press Ctrl + P to pin
# 3. Press Ctrl + N to move up in list
# 4. Pinned apps always appear first
```

### 2. Use Prefix Shortcuts

Learn the prefixes to access providers instantly:

```
=     Calculator (muscle memory)
.     Files (quick file access)
:     Symbols (emoji, unicode)
$     Clipboard (paste history)
@     Web search
```

### 3. Leverage Fuzzy Search

You don't need exact names:

```
fir    → Firefox
term   → Terminal
code   → VS Code
disc   → Discord
spot   → Spotify
```

### 4. Use Shift + Return for Sequences

When launching multiple apps:

```
# Super + Space
terminal    # Shift + Return (keeps Walker open)
firefox     # Shift + Return
spotify     # Return (closes Walker)
```

### 5. Clean Up History

Periodically clear histories for better results:

```
# In desktopapplications: Ctrl + H
# In websearch: Ctrl + H
# In clipboard: Ctrl + Shift + D
# In calc: Ctrl + D (per item)
```

### 6. Use Calculator for Quick Math

Instead of opening calculator app:

```
=15% of 250    → Quick percentage
=145 / 12      → Quick division
=sqrt(256)     → Advanced functions
```

### 7. Clipboard Management Workflow

```
# 1. Copy multiple items (Ctrl + C)
# 2. Later: $ to view history
# 3. Type to filter: "password", "url", etc.
# 4. Return to copy back
```

---

## Related Documentation

### Omarchy Documentation
- [Hyprland Integration](/home/zack/dev/lib/omarchy-archive/04-desktop-environment/hyprland-integration.md) - Keybinding that launches Walker
- [Theme System](/home/zack/dev/lib/omarchy-archive/03-theming/theme-system.md) - Walker theming
- [Waybar Configuration](/home/zack/dev/lib/omarchy-archive/04-desktop-environment/waybar-configuration.md) - Status bar integration

### Walker & Elephant Documentation
- [Walker GitHub](https://github.com/abenz1267/walker) - Official repository
- [Elephant GitHub](https://github.com/abenz1267/elephant) - Provider system

---

**Last Updated:** 2025-10-21
**Omarchy Version:** Latest
