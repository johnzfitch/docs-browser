Move the cursor down \`n\` cells.

1.  0x1B
    
    ESC
    
2.  0x5B
    
    \[
    
3.  \_\_\_\_
    
    n
    
4.  0x42
    
    B
    

The parameter `n` must be an integer greater than or equal to 1. If `n` is less than or equal to 0, adjust `n` to be 1. If `n` is omitted, `n` defaults to 1.

This sequence always unsets the pending wrap state.

If the current cursor position is at or above the [bottom margin](https://ghostty.org/docs/features/theme#TODO), the lowest point the cursor can move is the bottom margin. If the current cursor position is below the bottom margin, the lowest point the cursor can move is the final row.

This sequence never triggers scrolling.

```
printf "A"
printf "\033[2B" # cursor down
printf "X"
```

```
|A_________|
|__________|
|_Xc_______|
```

```
printf "\033[1;1H" # move to top-left
printf "\033[0J" # clear screen
printf "\n\n\n\n" # screen is 4 high
printf "\033[1;3r" # set scrolling region
printf "A"
printf "\033[5B" # cursor down
printf "X"
```

```
|A_________|
|__________|
|_Xc_______|
|__________|
```

```
printf "\033[1;1H" # move to top-left
printf "\033[0J" # clear screen
printf "\n\n\n\n\n" # screen is 5 high
printf "\033[1;3r" # set scrolling region
printf "A"
printf "\033[4;1H" # move below region
printf "\033[5B" # cursor down
printf "X"
```

```
|A_________|
|__________|
|__________|
|__________|
|_Xc_______|
```

[Edit on GitHub](https://github.com/ghostty-org/website/edit/main/docs/vt/csi/cud.mdx)

-   [
    
    Validation
    
    ](https://ghostty.org/docs/features/theme#validation)
-   [
    
    CUD V-1: Cursor Down
    
    ](https://ghostty.org/docs/features/theme#cud-v-1:-cursor-down)
-   [
    
    CUD V-2: Cursor Down Above Bottom Margin
    
    ](https://ghostty.org/docs/features/theme#cud-v-2:-cursor-down-above-bottom-margin)
-   [
    
    CUD V-3: Cursor Down Below Bottom Margin
    
    ](https://ghostty.org/docs/features/theme#cud-v-3:-cursor-down-below-bottom-margin)