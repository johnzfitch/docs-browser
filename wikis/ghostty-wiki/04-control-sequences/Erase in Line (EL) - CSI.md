Erase line contents with behavior depending on the command \`n\`.

1.  0x1B
    
    ESC
    
2.  0x5B
    
    \[
    
3.  \_\_\_\_
    
    n
    
4.  0x4B
    
    K
    

If `n` is unset, the value of `n` is 0. The only valid values for `n` are 0, 1, or 2. If any other value of `n` is given, do not execute this sequence. The remainder of the sequence documentation assumes a valid value of `n`.

For all valid values of `n`, this sequence unsets the pending wrap state. The cursor position will remain unchanged under all circumstances throughout this sequence.

If [Select Character Selection Attribute (DECSCA)](https://ghostty.org/docs/features/theme#TODO) is enabled or was the most recently enabled protection mode on the currently active screen, protected attributes are ignored. Otherwise, protected attributes will be respected. For more details on this specific logic for protected attribute handling, see [Erase Character (ECH)](https://ghostty.org/docs/vt/csi/ech).

For all operations, if a multi-cell character would be split, erase the full multi-cell character. For example, if "橋" is printed and the erase would only erase the first or second cell of the two-cell character, both cells should be erased.

If `n` is `0`, perform an **erase line right** operation. Erase line right is equivalent to [Erase Character (ECH)](https://ghostty.org/docs/vt/csi/ech) with `n` set to the total remaining columns from the cursor to the end of the line (and including the cursor). If the line is softwrapped, only the single row is erased; it does not erase through the wrap. Further, the wrap state of the row is reset such that the line is no longer considered wrapped.

If `n` is `1`, perform an **erase line left** operation. This replaces the `n` cells left of and including the cursor with a blank character and colors the background according to the current SGR state. The leftmost column that can be blanked is the first column of the screen. The [left margin](https://ghostty.org/docs/features/theme#TODO) has no effect on this operation.

If `n` is `2`, **erase the entire line**. This is the equivalent of erase left (`n = 1`) and erase right (`n = 0`) both being executed.

```
printf "ABCDE"
printf "\033[3G"
printf "\033[0K"
```

```
|ABc_____|
```

```
cols=$(tput cols)
printf "\033[${cols}G" # move to last column
printf "A" # set pending wrap state
printf "\033[0K"
printf "X"
```

```
|_______X|
```

The cursor should be on the 'X'

```
printf "ABC"
printf "\033[2G"
printf "\033[41m"
printf "\033[0K"
```

```
|Ac______|
```

The cells from `c` onwards should have a red background all the way to the right edge of the screen.

```
printf "AB橋DE"
printf "\033[4G"
printf "\033[0K"
```

```
|AB_c____|
```

```
printf "\033[1;1H" # move to top-left
printf "\033[0J" # clear screen
printf "ABCDE"
printf "\033[?69h" # enable left/right margins
printf "\033[1;3s" # scroll region left/right
printf "\033[2G"
printf "\033[0K"
```

```
|Ac________|
```

```
printf "\033V"
printf "ABCDE"
printf "\033[1\"q"
printf "\033[0\"q"
printf "\033[2G"
printf "\033[0K"
```

```
|Ac________|
```

```
printf "\033[1\"q"
printf "ABCDE"
printf "\033V"
printf "\033[2G"
printf "\033[0K"
printf "\033[1K"
printf "\033[2K"
```

```
|ABCDE_____|
```

```
printf "ABCDE"
printf "\033[3G"
printf "\033[1K"
```

```
|__cDE___|
```

```
printf "ABC"
printf "\033[2G"
printf "\033[41m"
printf "\033[1K"
```

```
|_cC_____|
```

The cells from `c` to the left should have a red background.

```
printf "AB橋DE"
printf "\033[3G"
printf "\033[1K"
```

```
|__c_DE__|
```

```
printf "\033V"
printf "ABCDE"
printf "\033[1\"q"
printf "\033[0\"q"
printf "\033[2G"
printf "\033[1K"
```

```
|_cCDE_____|
```

```
printf "ABCDE"
printf "\033[3G"
printf "\033[2K"
```

```
|__c_______|
```

```
printf "ABC"
printf "\033[2G"
printf "\033[41m"
printf "\033[2K"
```

```
|_c______|
```

The entire line should have a red background.