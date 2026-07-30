## ⬇️ 下载

- 壁纸应用程序：[Linux amd64](https://github.com/qiangqiang101/RGB-Wallpaper/releases) | [Linux arm64](https://github.com/qiangqiang101/RGB-Wallpaper/releases)
- 壁纸启动脚本：[下载](https://github.com/qiangqiang101/RGB-Wallpaper/releases)

## 🚀 在 Linux 上设置 RGB 壁纸

本指南将逐步指导您在 Linux (X11 / GNOME / Zorin OS) 上全屏运行 RGB 壁纸程序，并将其置于桌面图标和面板下方。

### 第一步：下载壁纸程序
1. 下载[上方提供的文件](#-下载)

2. 将文件解压到您的电脑中，例如：``/home/username/Applications/RGBWallpaper``。

### 第二步：安装依赖项
打开终端并安装所需的工具：

```bash
sudo apt update
sudo apt install -y wmctrl x11-utils python3
```

### 第三步：赋予脚本执行权限
导航至应用程序文件夹并赋予执行权限：

```bash
cd /home/username/Applications/RGBWallpaper
chmod +x start.sh set_wallpaper_window.py Wallpaper-UI
```

### 第四步：运行壁纸
运行壁纸启动脚本：

```bash
./start.sh
```

该脚本将自动执行以下操作：
- 启动壁纸应用程序。
- 去除窗口标题栏和边框。
- 将窗口调整为全屏大小。
- 将其嵌入桌面背景层（置于桌面图标和任务栏下方）。

### 第五步：登录时自动启动（可选）
如果您希望每次登录 Linux 时自动启动壁纸：

1. 创建自启动文件夹：
   ```bash
   mkdir -p ~/.config/autostart
   ```

2. 创建文件 `~/.config/autostart/rgbwallpaper.desktop`：
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

3. 赋予自启动配置文件执行权限：
   ```bash
   chmod +x ~/.config/autostart/rgbwallpaper.desktop
   ```
