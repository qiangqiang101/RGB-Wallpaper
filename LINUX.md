## ⬇️ Download

- Wallpaper App: [Linux amd64](https://github.com/qiangqiang101/RGB-Wallpaper/releases) | [Linux arm64](https://github.com/qiangqiang101/RGB-Wallpaper/releases)
- Wallpaper Script: [Download](https://github.com/qiangqiang101/RGB-Wallpaper/releases)

## 🚀 Setup RGB Wallpaper on Linux
A quick step-by-step guide to run the RGB Wallpaper app full screen on Linux (X11 / GNOME / Zorin OS) under desktop icons and panels.

### Step 1: Download Wallpaper App
1. Download the [files above](#-download)

2. Extract to your computer for example: ``/home/username/Applications/RGBWallpaper``.

### Step 2: Install Dependencies
Open a terminal and install the required tools:

```bash
sudo apt update
sudo apt install -y wmctrl x11-utils python3
```

### Step 3: Make Scripts Executable
Navigate to the application folder and grant execute permissions:

```bash
cd /home/username/Applications/RGBWallpaper
chmod +x start.sh set_wallpaper_window.py Wallpaper-UI
```

### Step 4: Run the Wallpaper
Launch the wallpaper script:

```bash
./start.sh
```

This automatically:
- Launches the wallpaper application.
- Strips title bars and window borders.
- Resizes the window to full screen.
- Integrates it into the desktop background layer beneath desktop icons and taskbars.

### Step 5: Autostart on Login (Optional)
To automatically launch the wallpaper every time you log into Linux:

1. Create the autostart folder:
   ```bash
   mkdir -p ~/.config/autostart
   ```

2. Create the file `~/.config/autostart/rgbwallpaper.desktop`:
   ```bash
   cat << 'EOF' > ~/.config/autostart/rgbwallpaper.desktop
   [Desktop Entry]
   Type=Application
   Name=RGB Wallpaper
   Comment=Launch RGB Live Wallpaper on login
   Exec=/home/username/Applications/RGBWallpaper/start.sh
   Icon=video-display
   Terminal=false
   Categories=Utility;
   X-GNOME-Autostart-enabled=true
   EOF
   ```

3. Make the autostart file executable:
   ```bash
   chmod +x ~/.config/autostart/rgbwallpaper.desktop
   ```