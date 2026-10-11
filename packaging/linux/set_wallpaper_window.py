#!/usr/bin/env python3
import ctypes
import os
import subprocess
import sys
import time

class XSizeHints(ctypes.Structure):
    _fields_ = [
        ("flags", ctypes.c_long),
        ("x", ctypes.c_int), ("y", ctypes.c_int),
        ("width", ctypes.c_int), ("height", ctypes.c_int),
        ("min_width", ctypes.c_int), ("min_height", ctypes.c_int),
        ("max_width", ctypes.c_int), ("max_height", ctypes.c_int),
        ("width_inc", ctypes.c_int), ("height_inc", ctypes.c_int),
        ("min_aspect_num", ctypes.c_int), ("min_aspect_den", ctypes.c_int),
        ("max_aspect_num", ctypes.c_int), ("max_aspect_den", ctypes.c_int),
        ("base_width", ctypes.c_int), ("base_height", ctypes.c_int),
        ("win_gravity", ctypes.c_int),
    ]

def main():
    target_class = "app.Wallpaper-UI"
    target_title = "Wallpaper UI"
    
    # Wait for window ID
    wid_hex = None
    for _ in range(30):
        try:
            output = subprocess.check_output(["wmctrl", "-l", "-x"], text=True)
            for line in output.splitlines():
                if target_class in line or target_title in line:
                    wid_hex = line.split()[0]
                    break
        except Exception:
            pass
        if wid_hex:
            break
        time.sleep(0.3)
        
    if not wid_hex:
        print("Error: Could not find Wallpaper UI window.", file=sys.stderr)
        sys.exit(1)
        
    wid = int(wid_hex, 16)
    
    # 1. Remove title bar & window decorations
    subprocess.run(["xprop", "-id", wid_hex, "-f", "_MOTIF_WM_HINTS", "32c", "-set", "_MOTIF_WM_HINTS", "0x2, 0x0, 0x0, 0x0, 0x0"], check=False)
    
    # 2. Set Window Type to DESKTOP (embeds window into the desktop background layer)
    subprocess.run(["xprop", "-id", wid_hex, "-f", "_NET_WM_WINDOW_TYPE", "32a", "-set", "_NET_WM_WINDOW_TYPE", "_NET_WM_WINDOW_TYPE_DESKTOP"], check=False)

    # 3. Add window state: below layer, sticky across workspaces, hide from taskbar & pager
    subprocess.run(["wmctrl", "-i", "-r", wid_hex, "-b", "remove,fullscreen"], check=False)
    subprocess.run(["wmctrl", "-i", "-r", wid_hex, "-b", "add,sticky,below,skip_taskbar,skip_pager"], check=False)

    # 4. Connect to X11
    X11 = ctypes.cdll.LoadLibrary("libX11.so.6")
    display = X11.XOpenDisplay(None)
    if not display:
        print("Error: Could not open X11 display.", file=sys.stderr)
        sys.exit(1)
        
    screen = X11.XDefaultScreen(display)
    width = X11.XDisplayWidth(display, screen)
    height = X11.XDisplayHeight(display, screen)
    
    # 5. Clear hardcoded min/max size constraints imposed by Avalonia
    hints = XSizeHints()
    hints.flags = 0
    X11.XSetWMNormalHints(display, wid, ctypes.byref(hints))
    
    # 6. Move & resize to full monitor dimensions, lower to background layer
    X11.XMoveResizeWindow(display, wid, 0, 0, width, height)
    X11.XLowerWindow(display, wid)
    X11.XFlush(display)

if __name__ == "__main__":
    main()
