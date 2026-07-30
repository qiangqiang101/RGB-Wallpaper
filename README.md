# RGB Wallpaper

[中文 README](README.CN.md)

![Github All Releases](https://img.shields.io/github/downloads/qiangqiang101/RGB-Wallpaper/total.svg)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/qiangqiang101/RGB-Wallpaper)
![GitHub](https://img.shields.io/github/license/qiangqiang101/RGB-Wallpaper)
![GitHub branch checks state](https://img.shields.io/github/checks-status/qiangqiang101/RGB-Wallpaper/master)
![GitHub issues](https://img.shields.io/github/issues/qiangqiang101/RGB-Wallpaper)
![GitHub forks](https://img.shields.io/github/forks/qiangqiang101/RGB-Wallpaper?style=social)
![GitHub Repo stars](https://img.shields.io/github/stars/qiangqiang101/RGB-Wallpaper?style=social)
![YouTube Channel Subscribers](https://img.shields.io/youtube/channel/subscribers/UCAZlasvEy1euunP1M7nwj5Q?style=social)
[![Donate via PayPal](https://img.shields.io/badge/Donate-Paypal-brightgreen)](https://paypal.me/imnotmental)
[![Follow on Patreon](https://img.shields.io/badge/Donate-Patreon-orange)](https://www.patreon.com/imnotmental)

A high-performance desktop wallpaper application built with **Avalonia UI** targeting **.NET 10.0**. It translates lighting data from SignalRGB, OpenRGB, or RGBJunkie into custom, hardware-accelerated desktop visuals.

---

## ✨ Features

- **Hardware-Accelerated Rendering**: Custom Skia-based rendering control (`LedCanvas`) driving 60+ FPS fluid animations.
- **Audio Visualization**: Integrated loopback audio recording and FFT analysis (via `NAudio`) to drive offline music visualizers.
- **Offline Shaders**: Includes built-in shaders for Fire, Aurora, sunset/neon gradients, breathing, and rainbow cycles when local RGB servers are offline.
- **Isolated Port Configuration**: Port configuration is read from `config.json` instead of user state files, ensuring clean configuration management.

---

## 💾 Download

### Windows
[Wallpaper Engine](WPE.md) | [Lively Wallpaper](LIVELY.md)

### Linux
[Linux](LINUX.md)

---

## 🚧 Prerequisite

- [.NET 10.0 Runtime](https://dotnet.microsoft.com/en-us/download/dotnet/10.0)
- [Wallpaper Engine](https://store.steampowered.com/app/431960/Wallpaper_Engine/) | [Lively Wallpaper](https://github.com/rocksdanister/lively/releases/latest)
- [OpenRGB](https://openrgb.org/) | [SignalRGB](https://signalrgb.com/) | [RGBJunkie](https://rgbjunkie.com/RGBJunkieApp/)
- [OpenRGB Wallpaper Plugin](https://github.com/qiangqiang101/OpenRGB-Wallpaper-Engine) | [SignalRGB Wallpaper Plugin](https://github.com/qiangqiang101/SignalRGB-Wallpaper-Engine) | [RGBJunkie Wallpaper Plugin](https://github.com/qiangqiang101/SignalRGB-Wallpaper-Engine)

---

## ⚙️ Configuration (`config.json`)

The application listens on the UDP port specified in `config.json`. The file is deployed to the output build directory:

```json
{
  "Port": 8133
}
```

- Update `Port` to match the custom broadcast port set in your SignalRGB, OpenRGB, or RGBJunkie UDP broadcast settings.

---

## 🛠️ How to Build

### Prerequisites
- **.NET 10.0 SDK** (or later) installed on your system.

---

### 🪟 Building on Windows

On Windows, the application uses native Win32 APIs to hook into the desktop wallpaper structure (`WorkerW`/`Progman`) when hosted inside wallpaper managers like Lively Wallpaper and Wallpaper Engine.

#### 1. Compile the Project
Open a shell (PowerShell or Command Prompt) in this project folder (`Wallpaper-UI`) and run:

- **Debug Mode** (Includes borders and window decorations for local testing and debugging):
  ```bash
  dotnet build
  ```

- **Release Mode** (Optimized for deployment and Lively Wallpaper hosting):
  ```bash
  dotnet build -c Release
  ```

#### 2. Run the Application
You can run the compiled application:
```bash
dotnet run
```

---

### 🐧 Building on Linux

Avalonia UI is fully cross-platform and runs natively on Linux (under both X11 and Wayland). The Windows-specific Win32 interop logic is safely wrapped and bypassed on non-Windows platforms.

#### 1. Compile the Project
Open your terminal in this directory and run:

- **Standard Build**:
  ```bash
  dotnet build
  ```

- **Production Publish** (Generates a self-contained executable for Linux):
  ```bash
  dotnet publish -c Release -r linux-x64 --self-contained true -p:PublishSingleFile=true
  ```

#### 2. Run the Application
Run the published executable:
```bash
./bin/Release/net10.0/linux-x64/publish/Wallpaper-UI
```

#### 3. Linux Desktop Integration
Since Linux does not have a single standard window compositor layer equivalent to Windows `WorkerW`, you can dock the transparent window to your desktop wallpaper layer using toolkits like:
- **`xwinwrap`** (for X11 compositors):
  ```bash
  xwinwrap -g 1920x1080 -ni -s -b -nf -ov -- ./Wallpaper-UI
  ```
- Alternatively, check your desktop environment's window manager settings (e.g., KWin, Openbox, or GNOME extensions) to configure the window to stay at the bottom of the window stack without focus.
