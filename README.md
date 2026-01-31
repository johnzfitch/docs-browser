# docs-browser

![book](icons/book-64x64.png)

Unified documentation browser for Hyprland-based Linux desktops. Search and browse multiple doc archives from a single Walker-powered interface.

**208 docs | 70K lines | instant search with relevance ranking**

## Installation

### AUR (Arch Linux)

```bash
yay -S docs-browser
```

### Manual Install

```bash
# Clone the repo
git clone https://github.com/johnzfitch/docs-browser.git
cd docs-browser

# Install script and wikis
sudo install -Dm755 docs-browser /usr/bin/docs-browser
sudo mkdir -p /usr/share/docs-browser
sudo cp -r wikis /usr/share/docs-browser/

# Bind to a key (Hyprland)
# Add to ~/.config/hypr/bindings.conf:
bindd = SUPER, H, Docs Browser, exec, docs-browser
```

### Custom Wiki Location

Override the default path with `DOCS_BROWSER_PATH`:

```bash
export DOCS_BROWSER_PATH="$HOME/my-wikis"
docs-browser
```

## How it works

```
┌─────────────────────────────────────────────────────────┐
│  Super+H → Main Menu                                    │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │
│  │ Search All  │    │  Omarchy    │    │  Hyprland   │  │
│  │             │    │  Wiki       │    │  Wiki       │  │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘  │
│         │                  │                  │         │
│         ▼                  ▼                  ▼         │
│  ┌─────────────────────────────────────────────────┐    │
│  │  Walker dmenu → Type query                      │    │
│  └─────────────────────────────────────────────────┘    │
│         │                                               │
│         ▼                                               │
│  ┌─────────────────────────────────────────────────┐    │
│  │  Ranked results with relevance scoring          │    │
│  │  [source] file │ line │ context                 │    │
│  └─────────────────────────────────────────────────┘    │
│         │                                               │
│         ▼                                               │
│  ┌─────────────────────────────────────────────────┐    │
│  │  Actions: Edit │ Preview │ Copy path            │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

## Features

| Feature | Description |
|---------|-------------|
| **Relevance ranking** | Filename matches > headings > line position > word boundaries |
| **Multi-archive** | Search across Omarchy + Hyprland + Ghostty wikis simultaneously |
| **Toggle behavior** | Press Super+H again to dismiss (natural toggle) |
| **Browse mode** | Navigate by category without searching |
| **Action menu** | Open in editor, preview with bat, copy path/reference |

## Relevance Scoring

The search algorithm scores results by:

1. **+100** Filename contains query
2. **+30** Match in first 5 lines
3. **+20** Match is a heading (`#`)
4. **+25** Exact word boundary match
5. **+15** Match in lines 5-15

Results sorted by score, limited to top 100.

## CLI Modes

```bash
docs-browser              # Main menu
docs-browser omarchy      # Search omarchy wiki only
docs-browser hyprland     # Search hyprland wiki only
docs-browser ghostty      # Search ghostty wiki only
docs-browser all          # Search all archives directly
docs-browser browse-omarchy   # Browse omarchy by category
docs-browser browse-hyprland  # Browse hyprland by category
docs-browser browse-ghostty   # Browse ghostty by category
```

## Dependencies

**Required:**
- [Walker](https://github.com/abenz1267/walker) - Application launcher with dmenu mode
- [wl-clipboard](https://github.com/bugaevc/wl-clipboard) - Wayland clipboard

**Optional:**
- [bat](https://github.com/sharkdp/bat) - Syntax-highlighted preview (falls back to less)
- [Ghostty](https://ghostty.org/) - Default terminal (configurable via `$TERMINAL`)
- [Hyprland](https://hyprland.org/) - Window tagging support

## Configuration

Environment variables:
- `$DOCS_BROWSER_PATH` - Wiki location (default: `/usr/share/docs-browser/wikis`)
- `$EDITOR` - Editor for opening files (default: nvim)
- `$TERMINAL` - Terminal emulator (default: ghostty)

## Included Documentation

### Omarchy Wiki
Desktop environment configuration, theming, keybindings, and workflow documentation for [Omarchy](https://github.com/basecamp/omakub)-based systems.

### Hyprland Wiki
Official Hyprland documentation covering configuration, plugins, and Wayland compositor features.

### Ghostty Wiki
Configuration and usage documentation for [Ghostty](https://ghostty.org/), the fast GPU-accelerated terminal emulator.

## Design Constraints

- **Toggle-first**: Pressing the keybind again dismisses the menu (no stuck windows)
- **Graceful degradation**: Works without bat, falls back to less
- **No state**: Pure function, no background daemons
- **Fast**: grep-based search, no indexing required

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| Walker not appearing | Walker not in PATH | Install walker, check `which walker` |
| Results missing | Archive path wrong | Check `$DOCS_BROWSER_PATH` points to wikis |
| Editor not opening | Wrong terminal | Set `$TERMINAL` to your terminal |
| Copy not working | wl-copy missing | Install wl-clipboard |

## License

MIT
