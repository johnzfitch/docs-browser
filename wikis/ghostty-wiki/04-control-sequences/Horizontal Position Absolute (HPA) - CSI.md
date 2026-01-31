[![Ghostty](https://ghostty.org/_next/static/media/ghostty-wordmark.6a43fa21.svg)](https://ghostty.org/)

Move the cursor to a specific column.

1.  0x1B
    
    ESC
    
2.  0x5B
    
    \[
    
3.  \_\_\_\_
    
    x
    
4.  0x60
    
    \`
    

This sequence performs [cursor position (CUP)](https://ghostty.org/docs/vt/csi/cup) with `x` set to the parameterized value and `y` set to the current cursor position. There is no additional or different behavior for using `HPA`.

Because this invokes `CUP`, the cursor row (`x`) can change if it is outside the bounds of the `CUP` operation. For example, if [origin mode](https://ghostty.org/docs/config/keybind#TODO) is set and the current cursor position is outside of the scroll region, the row will be adjusted.

[Edit on GitHub](https://github.com/ghostty-org/website/edit/main/docs/vt/csi/hpa.mdx)