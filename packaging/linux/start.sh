#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Launch the wallpaper app
"$SCRIPT_DIR/Wallpaper-UI" &

# Remove window limits, stretch to full screen, and set desktop wallpaper layer
python3 "$SCRIPT_DIR/set_wallpaper_window.py"


