# Omarchy MMO-Style Keybind Redesign

## Data-Driven + Left-Hand L/XL Ergonomics

---

## Usage Data Analysis (Last 24 Hours)

### Apps Launched (Frequency Order)

1. **Terminal (alacritty)** - 20+ launches ⭐⭐⭐⭐⭐
2. **Neovim** - 8+ launches ⭐⭐⭐⭐
3. **Browser (chromium)** - 5+ launches ⭐⭐⭐⭐
4. **File Manager (nautilus)** - 4+ launches ⭐⭐⭐
5. **Screenshot tools** - frequent (but spam-clicked when broken)
6. **Walker (launcher)** - occasional
7. **Omarchy utilities** - occasional

### Top Shell Commands

1. `gh` (58 uses) - GitHub CLI
2. `cd` (40 uses) - Navigation
3. `hyprctl` (27 uses) - Window management
4. `claude` (23 uses) - This conversation!
5. `git` (21 uses) - Version control
6. `lazygit` (11 uses) - Git TUI

### Behavioral Patterns

- **Rapid terminal launches** (multiple within seconds) → needs to be instant
- **Screenshot-tray spam clicking** (8 clicks in 29s) → frustration when broken
- **Terminal → Neovim combo** (frequent) → should be seamless
- **Long work sessions** (2-5 hour gaps) → muscle memory matters

---

## Left-Hand MMO Hotbar Layout

```
┌─────┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬─────────┐
│ ESC │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ 8 │ 9 │ 0 │ - │ = │  BKSP   │
├─────┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬───────┤
│  TAB  │ Q │ W │ E │ R │ T │ Y │ U │ I │ O │ P │ [ │ ] │   \   │
├───────┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴───────┤
│  CAPS  │ A │ S │ D │ F │ G │ H │ J │ K │ L │ ; │ ' │  RETURN  │
├────────┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴──────────┤
│  SHIFT   │ Z │ X │ C │ V │ B │ N │ M │ , │ . │ / │    SHIFT   │
└──────┬───┴┬──┴─┬─┴───┴───┴───┴───┴───┴──┬┴───┼───┴┬────┬──────┘
       │CTRL│SUPER│       SPACE            │ ALT│    │    │
       └────┴─────┴────────────────────────┴────┴────┴────┘

LEFT HAND EASY REACH (L/XL fingers):
✅ Pinky:  ESC, TAB, CAPS, SHIFT, CTRL, ~, 1, Q, A, Z
✅ Ring:   2, W, S, X
✅ Middle: 3, E, D, C
✅ Index:  4, 5, R, T, F, G, V, B
✅ Thumb:  SUPER, ALT, SPACE

❌ HARD: -, =, [, ], \, P, ;, ', /, numbers 6-0
```

---

## MMO Design Principles

**Hotbar 1 (Most Frequent - SUPER + Left Hand Home):**

```
SUPER+Q → Browser          (Q=Quick access, #3 frequency)
SUPER+W → [RESERVED - no close!]
SUPER+E → Editor/Neovim    (E=Editor, #2 frequency)
SUPER+R → File Manager     (R=bRowse files, alt)
SUPER+A → Terminal         (A=Always use, #1 frequency!)
SUPER+S → Screenshot       (S=Screen, frequent utility)
SUPER+D → Desktop/Workspace switch
SUPER+F → File Manager     (F=Files, #4 frequency)
```

**Why SUPER+A for Terminal?**

- **#1 most launched app** (20+ times)
- **A = Home row, easiest left-hand reach**
- **A = "Always", semantic**
- Current SUPER+RETURN is right-hand stretch

**Hotbar 2 (SUPER+SHIFT modifiers - big actions):**

```
SUPER+SHIFT+Q → Quit/Close Window   (Q=Quit, far from W)
SUPER+SHIFT+E → Email/Communication
SUPER+SHIFT+R → Restart/Reload services
SUPER+SHIFT+A → Activity Monitor (btop)
SUPER+SHIFT+S → Screenshot Menu
```

**Close Window Solution:**

- SUPER+Q conflicts with Browser
- **Use SUPER+SHIFT+Q** (Q=Quit, big deliberate action)
- **Alternative: SUPER+X** (X=eXit, bottom row, easy to spam)

---

## Navigation - WASD Not HJKL

**User preference:** WASD (MMO style), both arrows + WASD

```
SUPER+W → Focus Up       (WASD up)
SUPER+A → Focus Left     (WASD left) - CONFLICT with Terminal!
SUPER+S → Focus Down     (WASD down) - CONFLICT with Screenshot!
SUPER+D → Focus Right    (WASD right) - CONFLICT with Desktop!
```

**Problem:** WASD conflicts with hotbar!

**Solution:** Use **ALT+WASD** for navigation (ALT = window operations)

```
ALT+W → Focus Up
ALT+A → Focus Left
ALT+S → Focus Down
ALT+D → Focus Right

ALT+SHIFT+W → Swap Up
ALT+SHIFT+A → Swap Left
ALT+SHIFT+S → Swap Down
ALT+SHIFT+D → Swap Right
```

**Keep arrows as backup:**

```
SUPER+arrows       → Focus (existing)
SUPER+SHIFT+arrows → Swap (existing)
```

---

## Complete Keybind Map

### SUPER Layer (App Launches + System)

**Left Hand Hotbar (Frequent Apps):**

```
SUPER+A → Terminal              ⭐⭐⭐⭐⭐ #1 frequency
SUPER+Q → Browser (private)     ⭐⭐⭐⭐ #3 frequency
SUPER+E → Neovim/Editor         ⭐⭐⭐⭐ #2 frequency
SUPER+R → File Manager          ⭐⭐⭐ #4 frequency
SUPER+S → Screenshot            (frequent utility)
SUPER+F → Fullscreen toggle
SUPER+T → Toggle floating
SUPER+G → Toggle grouping
SUPER+Z → Undo (future)
SUPER+X → Close Window          (X=eXit, easy spam)
SUPER+C → Copy (existing)
SUPER+V → Paste (existing)
```

**Right Hand (Less Frequent):**

```
SUPER+B → Browser (normal)
SUPER+N → Notes/Obsidian
SUPER+M → Music (Spotify)
SUPER+O → Omarchy docs
SUPER+H → Hyprland docs
SUPER+K → Keybindings help
```

**Big Keys:**

```
SUPER+SPACE     → Walker (app launcher)
SUPER+RETURN    → Terminal (backup - SUPER+A primary)
SUPER+ESC       → Power menu
SUPER+TAB       → Next workspace
SUPER+BACKSPACE → Toggle transparency
```

**Numbers:**

```
SUPER+1-5  → Workspaces (left hand easy)
SUPER+6-0  → Workspaces (right hand stretch)
```

### SUPER+SHIFT Layer (Destructive/Big Actions)

```
SUPER+SHIFT+Q → Close Window         (deliberate quit)
SUPER+SHIFT+X → Close All Workspace  (nuclear)
SUPER+SHIFT+A → Activity (btop)
SUPER+SHIFT+S → Screenshot menu
SUPER+SHIFT+R → Reload Hyprland
SUPER+SHIFT+B → Browser normal
SUPER+SHIFT+1-9 → Move to workspace
SUPER+SHIFT+TAB → Prev workspace
SUPER+SHIFT+SPACE → Toggle waybar
```

### ALT Layer (Window Navigation - MMO WASD)

```
ALT+W → Focus Up
ALT+A → Focus Left
ALT+S → Focus Down
ALT+D → Focus Right

ALT+SHIFT+W → Swap Up
ALT+SHIFT+A → Swap Left
ALT+SHIFT+S → Swap Down
ALT+SHIFT+D → Swap Right

ALT+F → Fullscreen (alternative)
ALT+T → Toggle tiling mode
ALT+TAB → Cycle windows
```

### SUPER+CTRL Layer (System Settings)

```
SUPER+CTRL+N → Nightlight
SUPER+CTRL+I → Idle toggle
SUPER+CTRL+T → Transparency
SUPER+CTRL+SPACE → Next background
SUPER+CTRL+F → Tiled fullscreen
```

### SUPER+ALT Layer (Advanced/Rare)

```
SUPER+ALT+SPACE → Omarchy menu
SUPER+ALT+arrows → Group operations
SUPER+ALT+H → Hyprland docs
```

---

## What Changes (Before → After)

| Action                  | Before           | After                        | Reason                             |
| ----------------------- | ---------------- | ---------------------------- | ---------------------------------- |
| **Terminal**            | SUPER+RETURN     | **SUPER+A**                  | #1 frequency, home row, left hand  |
| **Close window**        | SUPER+W          | **SUPER+X**                  | Far from W, easy to spam, X=eXit   |
| **Browser**             | SUPER+SHIFT+B    | **SUPER+Q**                  | Frequent (#3), Q=Quick, left hand  |
| **Editor**              | SUPER+N          | **SUPER+E**                  | Frequent (#2), E=Editor, left hand |
| **File Manager**        | SUPER+F conflict | **SUPER+F**                  | F=Files, left hand, #4 frequency   |
| **Screenshot**          | PRINT            | **SUPER+S** (also PRINT)     | S=Screen, left hand, backup PRINT  |
| **Navigate Up**         | SUPER+UP         | **ALT+W** (also keep arrows) | WASD MMO style                     |
| **Navigate Down**       | SUPER+DOWN       | **ALT+S** (also keep arrows) | WASD MMO style                     |
| **Navigate Left**       | SUPER+LEFT       | **ALT+A** (also keep arrows) | WASD MMO style                     |
| **Navigate Right**      | SUPER+RIGHT      | **ALT+D** (also keep arrows) | WASD MMO style                     |
| **Fullscreen**          | SUPER+F conflict | **SHIFT+F1**                 | F freed for file manager           |
| **Close all workspace** | (none)           | **SUPER+SHIFT+X**            | X family, nuclear option           |

---

## Files To Edit

1. `~/.config/hypr/bindings.conf` (your overrides)
2. `~/.local/share/omarchy/default/hypr/bindings/tiling-v2.conf`
3. `~/.local/share/omarchy/default/hypr/bindings/utilities.conf`

---

## Muscle Memory Migration

**Week 1:** Primary changes only

- SUPER+A → Terminal (replace SUPER+RETURN habit)
- SUPER+X → Close window (stop SUPER+W accidents)

**Week 2:** Hotbar additions

- SUPER+Q/E/R/S for Browser/Editor/Files/Screenshot

**Week 3:** WASD navigation

- ALT+WASD for focus movement (optional, arrows still work)

---

## Thick Finger Optimizations Applied

✅ **Big keys prioritized:** SPACE, ESC, TAB, SHIFT, RETURN
✅ **Left hand home row:** A, S, D, F (SUPER+A/S/D/F hotbar)
✅ **Avoid precision keys:** -, =, [, ], \ not used for primary actions
✅ **Easy modifier combos:** SUPER+letter (thumb+finger)
✅ **Cluster grouping:** QWER apps, ASDF utilities, ZXCV actions
✅ **Semantic naming:** A=Always(terminal), S=Screenshot, F=Fullscreen, X=eXit

---

## Testing Priority (By Frequency)

1. [ ] SUPER+A launches terminal (#1 app, 20+ daily)
2. [ ] SUPER+E launches neovim (#2 app, 8+ daily)
3. [ ] SUPER+Q launches browser (#3 app, 5+ daily)
4. [ ] SUPER+R launches file manager (#4 app, 4+ daily)
5. [ ] SUPER+X closes window (no more SUPER+W accidents!)
6. [ ] ALT+WASD navigation works (MMO style)
7. [ ] Arrows still work (backup navigation)
8. [ ] SUPER+S screenshot (frequent utility)

---

## Alternative: If SUPER+A Conflicts

If SUPER+A conflicts with something critical:

**Plan B - Use SUPER+SPACE variants:**

```
SUPER+SPACE       → Walker (existing)
SUPER+SHIFT+SPACE → Terminal (thumb mash, instant)
```

**Plan C - Use TAB:**

```
SUPER+TAB         → Terminal (TAB big, easy left hand)
SUPER+SHIFT+TAB   → Workspace navigation (move elsewhere)
```

User preference determines final choice.
