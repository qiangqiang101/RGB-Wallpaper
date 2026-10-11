# Stages the Windows build output for packaging.
#
#   <OutDir>/app/                      published app (no .pdb), shared by every display
#   <OutDir>/wpe/rgbwallpaperN/        per-display project.json + config.json (Wallpaper Engine)
#   <OutDir>/lively-info/DisplayN/     per-display LivelyInfo.json (Lively Wallpaper)
#
# Usage: ./stage.ps1 -PublishDir <dotnet publish output> -OutDir <staging dir> [-Version 1.2.3]
param(
    [Parameter(Mandatory)] [string] $PublishDir,
    [Parameter(Mandatory)] [string] $OutDir,
    [string] $Version = '0.0.0',
    [int] $Displays = 4,
    [int] $BasePort = 8133
)

$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..')

$app = Join-Path $OutDir 'app'
Remove-Item $OutDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $app, (Join-Path $OutDir 'wpe'), (Join-Path $OutDir 'lively-info') | Out-Null

# Shared app files. The base config.json is replaced per display, and debug symbols
# (the native .pdb files alone are ~200 MB) are not needed at runtime.
Copy-Item (Join-Path $PublishDir '*') $app -Recurse
Get-ChildItem $app -Recurse -Filter *.pdb | Remove-Item -Force
Remove-Item (Join-Path $app 'config.json') -ErrorAction SilentlyContinue

# The portable publish also carries native libs for Linux/macOS/Android; drop everything but win-*.
Get-ChildItem (Join-Path $app 'runtimes') -Directory | Where-Object { $_.Name -notlike 'win-*' } | Remove-Item -Recurse -Force

$template = Get-Content (Join-Path $root 'wpe/project.template.json') -Raw
$utf8 = [System.Text.UTF8Encoding]::new($false)

for ($n = 1; $n -le $Displays; $n++) {
    $port = $BasePort + $n - 1
    $config = "{`n  `"Port`": $port`n}`n"

    # --- Wallpaper Engine: only the files that differ per display ---
    $wpe = Join-Path $OutDir "wpe/rgbwallpaper$n"
    New-Item -ItemType Directory -Force $wpe | Out-Null
    $project = $template.Replace('__PORT__', "$port").Replace('__N__', "$n")
    [IO.File]::WriteAllText((Join-Path $wpe 'project.json'), $project, $utf8)
    [IO.File]::WriteAllText((Join-Path $wpe 'config.json'), $config, $utf8)

    # --- Lively Wallpaper: LivelyInfo.json (the installer adds the shared app files + thumb.gif)
    $info = [ordered]@{
        AppVersion     = '2.2.0.0'
        Title          = "RGB Wallpaper (Display $n)"
        Thumbnail      = 'thumb.gif'
        Preview        = $null
        Desc           = "Port $port"
        Author         = "I'm Not MentaL"
        License        = 'MIT'
        Contact        = 'https://gitlab.com/OpenRGBDevelopers/OpenRGBWallpaperEnginePlugin'
        Type           = 0
        FileName       = 'Wallpaper-UI.exe'
        Arguments      = $null
        IsAbsolutePath = $false
        Id             = $null
        Tags           = $null
        Version        = 3
    }
    $infoDir = Join-Path $OutDir "lively-info/Display$n"
    New-Item -ItemType Directory -Force $infoDir | Out-Null
    $infoJson = $info | ConvertTo-Json
    [IO.File]::WriteAllText((Join-Path $infoDir 'LivelyInfo.json'), $infoJson, $utf8)
}

Write-Host "Staged $Displays displays into $OutDir"
