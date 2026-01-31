[![Ghostty](https://ghostty.org/_next/static/media/ghostty-wordmark.6a43fa21.svg)](https://ghostty.org/)

Move the cursor to a specific row.

1.  0x1B
    
    ESC
    
2.  0x5B
    
    \[
    
3.  \_\_\_\_
    
    y
    
4.  0x64
    
    d
    

This sequence performs [cursor position (CUP)](https://ghostty.org/docs/vt/csi/cup) with `y` set to the parameterized value and `x` set to the current cursor position. There is no additional or different behavior for using `VPA`.

Because this invokes `CUP`, the cursor column (`y`) can change if it is outside the bounds of the `CUP` operation. For example, if [origin mode](https://ghostty.org/docs/vt#TODO) is set and the current cursor position is outside of the scroll region, the column will be adjusted.

[Edit on GitHub](https://github.com/ghostty-org/website/edit/main/docs/vt/csi/vpa.mdx)