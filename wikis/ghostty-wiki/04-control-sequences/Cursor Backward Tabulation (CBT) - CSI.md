Move the cursor \`n\` tabs left.

1.  0x1B
    
    ESC
    
2.  0x5B
    
    \[
    
3.  \_\_\_\_
    
    n
    
4.  0x5A
    
    Z
    

The leftmost valid column for this operation is the first column. If [origin mode](https://ghostty.org/docs/features/theme#TODO) is enabled, then the leftmost valid column for this operation is the [left margin](https://ghostty.org/docs/features/theme#TODO).

Move the cursor left until the cursor position is on a tabstop. If the cursor would move past the leftmost valid column, the cursor remains at the leftmost valid column and the operation completes. Repeat this process `n` times.

Tabstops are dynamic and can be set with escape sequences such as [horizontal tab set (HTS)](https://ghostty.org/docs/features/theme#TODO), [tab clear (TBC)](https://ghostty.org/docs/vt/csi/tbc), etc. A terminal emulator may default tabstops at any interval, though an interval of 8 spaces is most common.

```
printf "\033[?5W" # reset tab stops
printf "\033[10Z"
printf "A"
```

```
|Ac________|
```

```
printf "\033[?5W" # reset tab stops
printf "\033[1;10H"
printf "X"
printf "\033[Z"
printf "A"
```

```
|________AX|
```

```
printf "\033[?5W" # reset tab stops
printf "\033[1;9H"
printf "X"
printf "\033[1;9H"
printf "\033[Z"
printf "A"
```

```
|A_______X_|
```

```
printf "\033[1;1H" # move to top-left
printf "\033[0J" # clear screen
printf "\033[?5W" # reset tab stops
printf "\033[?6h" # enable origin mode
printf "\033[?69h" # enable left/right margins
printf "\033[3;6s" # scroll region left/right
printf "\033[1;2H" # move cursor in region
printf "X"
printf "\033[Z"
printf "A"
```

```
|__AX______|
```

[Edit on GitHub](https://github.com/ghostty-org/website/edit/main/docs/vt/csi/cbt.mdx)

-   [
    
    Validation
    
    ](https://ghostty.org/docs/features/theme#validation)
-   [
    
    CBT V-1: Left Beyond First Column
    
    ](https://ghostty.org/docs/features/theme#cbt-v-1:-left-beyond-first-column)
-   [
    
    CBT V-2: Left Starting After Tab Stop
    
    ](https://ghostty.org/docs/features/theme#cbt-v-2:-left-starting-after-tab-stop)
-   [
    
    CBT V-3: Left Starting on Tabstop
    
    ](https://ghostty.org/docs/features/theme#cbt-v-3:-left-starting-on-tabstop)
-   [
    
    CBT V-4: Left Margin with Origin Mode
    
    ](https://ghostty.org/docs/features/theme#cbt-v-4:-left-margin-with-origin-mode)