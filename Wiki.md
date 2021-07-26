This page is intended to be a wiki-like collection of various issues that may be encountered.

# Xmonad

## Opened window is blank

Sometimes when a window opens a new window (e.g., opens a file dialogue), the resulting window will appear as a completely blank (white) window. Evidently this is caused by sizing issues (see: https://github.com/xmonad/xmonad/issues/210). A workaround is to hit `mod-t`, which resizes the window.

## Floating window too large

Floating windows that are launched may sometimes be sized too large so that they are unusable. First, try the above `mod-t` to resize the window. If that does not work, a (n annoying) workaround is to manually drag the window by holding down `mod`, so that the relevant portions of the window can be seen.
