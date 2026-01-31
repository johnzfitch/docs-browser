Restore the cursor-related state saved via Save Cursor (DECSC).

1.  0x1B
    
    ESC
    
2.  0x38
    
    8
    

If a cursor was never previously saved, this sets all the typically saved values to their default values.

Validation is shared with [Save Cursor (DECSC)](https://ghostty.org/docs/vt/esc/decsc).

[Edit on GitHub](https://github.com/ghostty-org/website/edit/main/docs/vt/esc/decrc.mdx)