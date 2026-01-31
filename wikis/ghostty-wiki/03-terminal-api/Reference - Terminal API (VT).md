## VT Sequence Reference

A reference of all VT sequences supported by Ghostty.

This page lists many of the VT sequences that Ghostty supports.

This page is a work-in-progress. Ghostty supports many more sequences than are listed here and for the sequences listed here the quality of the linked documentation varies. This is a very contributor friendly area to help improve the documentation!

They are currently grouped by sequence type (control, esc, CSI, etc.) and the listed alphabetically by syntax. In the future, we will introduce better organization and search capabilities.

| Name | Syntax | Description |
| --- | --- | --- |
| [BEL](https://ghostty.org/docs/vt/control/bel) | `0x07` | Alert the user (beep) |
| [BS](https://ghostty.org/docs/vt/control/bs) | `0x08` | Move cursor backward one position |
| [TAB](https://ghostty.org/docs/vt/control/tab) | `0x09` | Move cursor right to the next tab stop |
| [LF](https://ghostty.org/docs/vt/control/lf) | `0x0A` | Move cursor down one line, scrolling if necessary |
| [CR](https://ghostty.org/docs/vt/control/cr) | `0x0D` | Move cursor to the left margin |
| [DECSC](https://ghostty.org/docs/vt/esc/decsc) | `ESC 7` | Save cursor |
| [DECRC](https://ghostty.org/docs/vt/esc/decrc) | `ESC 8` | Restore cursor |
| [IND](https://ghostty.org/docs/vt/esc/ind) | `ESC D` | Move cursor down, scrolling if necessary |
| [RI](https://ghostty.org/docs/vt/esc/ri) | `ESC M` | Move cursor up, scrolling if necessary |
| [RIS](https://ghostty.org/docs/vt/esc/ris) | `ESC c` | Full reset |
| [DECSCUSR](https://ghostty.org/docs/vt/csi/decscusr) | `CSI Pn " " q` | Set cursor style |
| [DECKPAM](https://ghostty.org/docs/vt/esc/deckpam) | `ESC =` | Set numeric keypad to application mode |
| [DECKPNM](https://ghostty.org/docs/vt/esc/deckpnm) | `ESC >` | Set numeric keypad to numeric mode |
| [DECALN](https://ghostty.org/docs/vt/esc/decaln) | `ESC # 8` | Screen alignment test |
| [CUU](https://ghostty.org/docs/vt/csi/cuu) | `CSI Pn A` | Move cursor up |
| [CUD](https://ghostty.org/docs/vt/csi/cud) | `CSI Pn B` | Move cursor down |
| [CUF](https://ghostty.org/docs/vt/csi/cuf) | `CSI Pn C` | Move cursor right |
| [CUB](https://ghostty.org/docs/vt/csi/cub) | `CSI Pn D` | Move cursor left |
| [CNL](https://ghostty.org/docs/vt/csi/cnl) | `CSI Pn E` | Move cursor down `n` lines and to the leftmost column |
| [CPL](https://ghostty.org/docs/vt/csi/cpl) | `CSI Pn F` | Move cursor up `n` lines and to the leftmost column |
| [CUP](https://ghostty.org/docs/vt/csi/cup) | `CSI Py ; Px H` | Move cursor to the specified row and column |
| [CHT](https://ghostty.org/docs/vt/csi/cht) | `CSI Pn I` | Move cursor right `n` tabs |
| [ED](https://ghostty.org/docs/vt/csi/ed) | `CSI Pn J` | Erase display |
| [EL](https://ghostty.org/docs/vt/csi/el) | `CSI Pn K` | Erase line |
| [DL](https://ghostty.org/docs/vt/csi/dl) | `CSI Pn M` | Delete `n` lines at the cursor |
| [IL](https://ghostty.org/docs/vt/csi/il) | `CSI Pn L` | Insert `n` lines at the cursor |
| [DCH](https://ghostty.org/docs/vt/csi/dch) | `CSI Pn P` | Delete `n` characters at the cursor |
| [SU](https://ghostty.org/docs/vt/csi/su) | `CSI Pn S` | Scroll up `n` lines |
| [SD](https://ghostty.org/docs/vt/csi/sd) | `CSI Pn T` | Scroll down `n` lines |
| [ECH](https://ghostty.org/docs/vt/csi/ech) | `CSI Pn X` | Erase `n` characters at the cursor |
| [CBT](https://ghostty.org/docs/vt/csi/cbt) | `CSI Pn Z` | Move cursor left `n` tabs |
| [HPR](https://ghostty.org/docs/vt/csi/hpr) | `CSI Pn a` | Move cursor to a column relative to the cursor |
| [REP](https://ghostty.org/docs/vt/csi/rep) | `CSI Pn b` | Repeat the preceding character `n` times |
| [VPA](https://ghostty.org/docs/vt/csi/vpa) | `CSI Py d` | Move cursor to the specified row |
| [VPR](https://ghostty.org/docs/vt/csi/vpr) | `CSI Pn e` | Move cursor down `n` rows relative to the cursor |
| [TBC](https://ghostty.org/docs/vt/csi/tbc) | `CSI Pn g` | Clear one or all tab stops |
| [DSR](https://ghostty.org/docs/vt/csi/dsr) | `CSI Pn n` | Device status report |
| [DECSTBM](https://ghostty.org/docs/vt/csi/decstbm) | `CSI Pt ; Pb r` | Set top and bottom margins |
| [DECSLRM](https://ghostty.org/docs/vt/csi/decslrm) | `CSI Pl ; Pr s` | Set left and right margins |
| [ICH](https://ghostty.org/docs/vt/csi/ich) | `CSI Pn @` | Insert `n` characters at the cursor |
| [HPA](https://ghostty.org/docs/vt/csi/hpa) | `CSI Px` \` | Move cursor to the specified column |
| [XTSHIFTESCAPE](https://ghostty.org/docs/vt/csi/xtshiftescape) | `CSI > Pn s` | Configure `shift` modifier behavior with mouse reports |