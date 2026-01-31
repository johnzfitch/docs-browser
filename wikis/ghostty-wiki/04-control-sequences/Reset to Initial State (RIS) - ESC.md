## Full Reset (RIS)

Reset the terminal to its initial state.

1.  0x1B
    
    ESC
    
2.  0x63
    
    c
    

The full reset operation does the following:

-   Set the cursor shape to the default
-   Reset the scroll region to the full screen
-   Disable [left and right margin mode (mode 69)](https://ghostty.org/docs/features/theme#TODO)
-   Disable [origin mode (mode 6)](https://ghostty.org/docs/features/theme#TODO)
-   Unset cursor foreground and background colors
-   Reset charsets to the default
-   Reset [cursor key mode (DECCKM)](https://ghostty.org/docs/features/theme#TODO)
-   Reset [disable keyboard input (KAM)](https://ghostty.org/docs/features/theme#TODO)
-   Reset [application keypad mode](https://ghostty.org/docs/vt/esc/deckpnm)
-   Reset xterm keyboard modifier state to the default
-   Disable cursor [protected attribute](https://ghostty.org/docs/features/theme#TODO)
-   Disable any [protected area](https://ghostty.org/docs/features/theme#TODO)
-   Reset all [mouse tracking modes](https://ghostty.org/docs/features/theme#TODO)
-   Reset tabstops to default
-   Enable [send-receive mode (mode 12)](https://ghostty.org/docs/features/theme#TODO)
-   Reset [backspace sends delete (mode 67)](https://ghostty.org/docs/features/theme#TODO)
-   Return to the primary screen and clear it
-   Move the cursor to the top-left corner
-   Reset the pending wrap state
-   Reset saved cursor state

[Edit on GitHub](https://github.com/ghostty-org/website/edit/main/docs/vt/esc/ris.mdx)