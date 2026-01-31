Reset margins, move cursor to the top left, and fill the screen with \`E\`.

1.  0x1B
    
    ESC
    
2.  0x23
    
    #
    
3.  0x38
    
    8
    

Reset the top, bottom, left, and right margins and unset [origin mode](https://ghostty.org/docs/config/keybind#TODO). The cursor is moved to the top-left corner of the screen.

All stylistic SGR attributes are unset, such as bold, blink, etc. SGR foreground and background colors are preserved. The [protected attribute](https://ghostty.org/docs/config/keybind#TODO) is not unset.

The entire screen is filled with the character `E`. The letter `E` ignores the current SGR settings and is written with no styling.

```
printf "\033#8"
```

```
|EEEEEEEE|
|EEEEEEEE|
|EEEEEEEE|
```

```
printf "\033[2;3r" # scroll region top/bottom
printf "\033#8"
printf "\033[T"
```

```
|c_______|
|EEEEEEEE|
|EEEEEEEE|
```

[Edit on GitHub](https://github.com/ghostty-org/website/edit/main/docs/vt/esc/decaln.mdx)

-   [
    
    Validation
    
    ](https://ghostty.org/docs/config/keybind#validation)
-   [
    
    DECALN V-1: Simple Usage
    
    ](https://ghostty.org/docs/config/keybind#decaln-v-1:-simple-usage)
-   [
    
    DECALN V-2: Reset Margins
    
    ](https://ghostty.org/docs/config/keybind#decaln-v-2:-reset-margins)