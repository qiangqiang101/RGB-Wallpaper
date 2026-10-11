# Stages the Windows build output for packaging.
#
#   <OutDir>/app/                      published app (no .pdb), shared by every display
#   <OutDir>/wpe/rgbwallpaperN/        per-display project.json + config.json (Wallpaper Engine)
#   <OutDir>/lively/*.zip              one drag & drop zip per display (Lively Wallpaper)
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
$assets = Join-Path $root 'assets'

$app = Join-Path $OutDir 'app'
Remove-Item $OutDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $app, (Join-Path $OutDir 'wpe'), (Join-Path $OutDir 'lively') | Out-Null

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

    # --- Lively Wallpaper: complete folder, zipped with the files at the zip root ---
    $lively = Join-Path $OutDir "lively-tmp/Display$n"
    New-Item -ItemType Directory -Force $lively | Out-Null
    Copy-Item (Join-Path $app '*') $lively -Recurse
    Copy-Item (Join-Path $assets 'thumb.gif') $lively
    [IO.File]::WriteAllText((Join-Path $lively 'config.json'), $config, $utf8)

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
    [IO.File]::WriteAllText((Join-Path $lively 'LivelyInfo.json'), ($info | ConvertTo-Json), $utf8)

    $zip = Join-Path $OutDir "lively/RGB-Wallpaper-Lively-Display$n-$Version.zip"
    Compress-Archive -Path (Join-Path $lively '*') -DestinationPath $zip -CompressionLevel Optimal
}

Remove-Item (Join-Path $OutDir 'lively-tmp') -Recurse -Force
Write-Host "Staged $Displays displays into $OutDir"
