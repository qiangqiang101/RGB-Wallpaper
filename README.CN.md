# RGB Wallpaper

[ENGLISH README](README.CN.md)

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

一个使用 **Avalonia UI** 构建、面向 **.NET 10.0** 的高性能桌面壁纸应用程序。它将来自 SignalRGB、OpenRGB 或 RGBJunkie 的灯光数据转换为自定义的硬件加速桌面视觉效果。

---

## ✨ 特性

- **硬件加速渲染**：基于 Skia 的自定义渲染控件（`LedCanvas`），带来 60+ FPS 的流畅动画。
- **音频可视化**：集成了回环音频录制和 FFT 分析（通过 `NAudio`），可驱动离线音乐可视化器。
- **离线着色器**：内置火焰、极光、日落/霓虹渐变、呼吸和彩虹循环等着色器，在本地 RGB 服务器离线时自动运行。
- **独立的端口配置**：从 `config.json` 读取端口配置，而不是用户状态文件，确保配置管理的整洁度。

---

## 💾 下载

### Windows
[Wallpaper Engine](WPE.CN.md) | [Lively Wallpaper](LIVELY.CN.md)

### Linux
[Linux x64](https://github.com/qiangqiang101/RGB-Wallpaper/releases) | [Linux arm64](https://github.com/qiangqiang101/RGB-Wallpaper/releases)

---

## 🚧 前提条件

- [.NET 10.0](https://dotnet.microsoft.com/en-us/download/dotnet/10.0)
- [小红车](https://store.steampowered.com/app/431960/Wallpaper_Engine/) | [Lively Wallpaper](https://github.com/rocksdanister/lively/releases/latest)
- [OpenRGB](https://openrgb.org/) | [SignalRGB](https://signalrgb.com/) | [RGBJunkie](https://rgbjunkie.com/RGBJunkieApp/)
- [OpenRGB插件](https://github.com/qiangqiang101/OpenRGB-Wallpaper-Engine) | [SignalRGB插件](https://github.com/qiangqiang101/SignalRGB-Wallpaper-Engine) | [RGBJunkie插件](https://github.com/qiangqiang101/SignalRGB-Wallpaper-Engine)

---

## ⚙️ 配置 (`config.json`)

应用程序监听在 `config.json` 中指定的 UDP 端口。该文件将被部署到构建输出目录：

```json
{
  "Port": 8133
}
```

- 请将 `Port` 修改为您在 SignalRGB、OpenRGB 或 RGBJunkie UDP 广播设置中配置的自定义广播端口。

---

## 🛠️ 如何构建

### 前提条件
- 系统中已安装 **.NET 10.0 SDK**（或更高版本）。

---

### 🪟 在 Windows 上构建

在 Windows 上，当托管在壁纸管理器（如 Lively Wallpaper 和 Wallpaper Engine）中时，该程序会使用原生 Win32 API 挂钩（Hook）到桌面壁纸窗口结构（`WorkerW`/`Progman`）。

#### 1. 编译项目
在项目文件夹 (`Wallpaper-UI`) 中打开命令行（PowerShell 或 CMD）并运行：

- **调试模式**（包含窗口边框和装饰，用于本地测试和调试）：
  ```bash
  dotnet build
  ```

- **发布模式**（针对部署和 Lively Wallpaper 托管进行了优化）：
  ```bash
  dotnet build -c Release
  ```

#### 2. 运行程序
您可以直接运行编译好的程序：
```bash
dotnet run
```

---

### 🐧 在 Linux 上构建

Avalonia UI 完全跨平台，原生运行于 Linux 上（支持 X11 和 Wayland）。Windows 特有的 Win32 互操作逻辑已安全包裹并在非 Windows 平台上自动旁路（Bypass）。

#### 1. 编译项目
在当前目录中打开终端并运行：

- **标准构建**：
  ```bash
  dotnet build
  ```

- **生产发布**（生成供 Linux 使用的单文件自包含可执行程序）：
  ```bash
  dotnet publish -c Release -r linux-x64 --self-contained true -p:PublishSingleFile=true
  ```

#### 2. 运行程序
运行发布的可执行程序：
```bash
./bin/Release/net10.0/linux-x64/publish/Wallpaper-UI
```

#### 3. Linux 桌面集成
由于 Linux 没有类似于 Windows `WorkerW` 的统一标准窗口合成器层，您可以使用如下工具将透明窗口嵌入到桌面壁纸层：
- **`xwinwrap`**（适用于 X11 合成器）：
  ```bash
  xwinwrap -g 1920x1080 -ni -s -b -nf -ov -- ./Wallpaper-UI
  ```
- 或者，检查您桌面环境的窗口管理器设置（例如 KWin、Openbox 或 GNOME 扩展），配置该窗口置于窗口栈底部且不获取焦点。
