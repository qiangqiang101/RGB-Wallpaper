using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using Avalonia;
using Avalonia.Media;

namespace Wallpaper_UI;

public class RGBClient
{
    private UdpClient? _udpClient;
    private int _listenPort = 8133; // Default port
    private bool _isListening = false;
    private DateTime _lastPacketTime = DateTime.Now;

    public event EventHandler<RGBSettingsChangedEventArgs>? SettingsChanged;

    public bool IsListening => _isListening;
    public DateTime LastPacketTime => _lastPacketTime;

    private readonly List<Color> _colors = new();
    public List<Color> Colors => _colors;

    private MatrixSizeType _matrixSizeType;
    public MatrixSizeType MatrixSizeType => _matrixSizeType;

    private MatrixSizeTier _matrixSizeTier;
    public MatrixSizeTier MatrixSizeTier => _matrixSizeTier;

    public bool IsPortrait
    {
        get
        {
            return _matrixSizeType switch
            {
                MatrixSizeType.Portrait4_1 or MatrixSizeType.Portrait4_3 or MatrixSizeType.Portrait5_4 or
                MatrixSizeType.Portrait16_9 or MatrixSizeType.Portrait16_10 or MatrixSizeType.Portrait21_9 or
                MatrixSizeType.Portrait32_9 => true,
                _ => false
            };
        }
    }

    public Size MatrixSize
    {
        get
        {
            switch (_matrixSizeType)
            {
                case MatrixSizeType.Landscape4_1:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(8, 2),
                        MatrixSizeTier.Normal => new Size(16, 4),
                        MatrixSizeTier.Large => new Size(32, 8),
                        _ => new Size(64, 16)
                    };
                case MatrixSizeType.Portrait4_1:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(2, 8),
                        MatrixSizeTier.Normal => new Size(4, 16),
                        MatrixSizeTier.Large => new Size(8, 32),
                        _ => new Size(16, 64)
                    };
                case MatrixSizeType.Landscape4_3:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(8, 6),
                        MatrixSizeTier.Normal => new Size(16, 12),
                        MatrixSizeTier.Large => new Size(32, 24),
                        _ => new Size(64, 48)
                    };
                case MatrixSizeType.Portrait4_3:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(6, 8),
                        MatrixSizeTier.Normal => new Size(12, 16),
                        MatrixSizeTier.Large => new Size(24, 32),
                        _ => new Size(48, 64)
                    };
                case MatrixSizeType.Landscape5_4:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(10, 8),
                        MatrixSizeTier.Normal => new Size(20, 16),
                        MatrixSizeTier.Large => new Size(40, 32),
                        _ => new Size(80, 64)
                    };
                case MatrixSizeType.Portrait5_4:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(8, 10),
                        MatrixSizeTier.Normal => new Size(16, 20),
                        MatrixSizeTier.Large => new Size(32, 40),
                        _ => new Size(64, 80)
                    };
                case MatrixSizeType.Landscape16_9:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(32, 18),
                        MatrixSizeTier.Normal => new Size(48, 27),
                        MatrixSizeTier.Large => new Size(64, 36),
                        _ => new Size(128, 72)
                    };
                case MatrixSizeType.Portrait16_9:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(18, 32),
                        MatrixSizeTier.Normal => new Size(27, 48),
                        MatrixSizeTier.Large => new Size(36, 64),
                        _ => new Size(72, 128)
                    };
                case MatrixSizeType.Landscape16_10:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(32, 20),
                        MatrixSizeTier.Normal => new Size(48, 30),
                        MatrixSizeTier.Large => new Size(64, 40),
                        _ => new Size(128, 80)
                    };
                case MatrixSizeType.Portrait16_10:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(20, 32),
                        MatrixSizeTier.Normal => new Size(30, 48),
                        MatrixSizeTier.Large => new Size(40, 64),
                        _ => new Size(80, 128)
                    };
                case MatrixSizeType.Landscape21_9:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(42, 18),
                        MatrixSizeTier.Normal => new Size(63, 27),
                        MatrixSizeTier.Large => new Size(84, 36),
                        _ => new Size(168, 72)
                    };
                case MatrixSizeType.Portrait21_9:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(18, 42),
                        MatrixSizeTier.Normal => new Size(27, 63),
                        MatrixSizeTier.Large => new Size(36, 48), // Wait: VBA had new Size(36, 48) - let's preserve or fix it later. Let's preserve for exact parity.
                        _ => new Size(72, 168)
                    };
                case MatrixSizeType.Landscape32_9:
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(64, 18),
                        MatrixSizeTier.Normal => new Size(96, 27),
                        MatrixSizeTier.Large => new Size(128, 36),
                        _ => new Size(256, 72)
                    };
                default: // Portrait32_9
                    return _matrixSizeTier switch
                    {
                        MatrixSizeTier.Small => new Size(18, 64),
                        MatrixSizeTier.Normal => new Size(27, 96),
                        MatrixSizeTier.Large => new Size(36, 128),
                        _ => new Size(72, 256)
                    };
            }
        }
    }

    private ShutdownEffect _shutdownEffect;
    public ShutdownEffect ShutdownEffect => _shutdownEffect;

    private bool _showFps;
    public bool ShowFps => _showFps;

    private int _blurIntensity;
    public int BlurIntensity => _blurIntensity;

    private LEDShape _ledShape;
    public LEDShape LEDShape => _ledShape;

    private int _roundedRectangleCornerRadius;
    public int RoundedRectangleCornerRadius => _roundedRectangleCornerRadius;

    private float _ledPadding;
    public float LEDPadding => _ledPadding;

    private int _fps;
    public int FPS => _fps;

    private Stretch _coverImageStretch;
    public Stretch CoverImageStretch => _coverImageStretch;

    private Color _backgroundColor;
    public Color BackgroundColor => _backgroundColor;

    private Color _shutdownColor;
    public Color ShutdownColor => _shutdownColor;

    private int _cpuUsagePauseValue;
    public int CPUUsagePauseValue => _cpuUsagePauseValue;

    private string? _coverImage;
    public string? CoverImage => _coverImage;

    public RGBClient(UserSave save, int port = 8133)
    {
        _listenPort = port;
        _matrixSizeType = save.MatrixSizeType;
        _matrixSizeTier = save.MatrixSizeTier;
        _shutdownEffect = save.ShutdownEffect;
        _showFps = save.ShowFps;
        _blurIntensity = save.BlurIntensity;
        _ledShape = save.LedShape;
        _roundedRectangleCornerRadius = save.RoundedRectangleCornerRadius;
        _ledPadding = save.LedPadding;
        _fps = save.FPS;
        _coverImageStretch = save.CoverImageStretch;
        _cpuUsagePauseValue = save.CpuUsagePauseValue;
        _backgroundColor = save.BackgroundColor;
        _shutdownColor = save.ShutdownColor;
        _coverImage = save.CoverImage;
    }

    public void StartListening()
    {
        if (_isListening) return;

        try
        {
            _udpClient = new UdpClient(_listenPort);
            _isListening = true;
            var remoteEP = new IPEndPoint(IPAddress.Any, 0);

            while (_isListening)
            {
                try
                {
                    byte[] packetData = _udpClient.Receive(ref remoteEP);
                    _lastPacketTime = DateTime.Now;
                    ProcessRGBPacket(packetData, remoteEP);
                }
                catch (Exception ex)
                {
                    if (_isListening) // Only log if we were supposed to be listening
                    {
                        Logger.Log($"Error receiving data: {ex.Message}");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Logger.Log($"Error starting UDP listener: {ex.Message}");
        }
    }

    private readonly List<byte> _combinedData = new();

    private void ProcessRGBPacket(byte[] data, IPEndPoint sender)
    {
        try
        {
            if (data.Length < 8) return;

            switch ((int)data[0])
            {
                case 0:
                    int currPacket = data[1];
                    int numPackets = data[2];

                    if (currPacket == numPackets - 1)
                    {
                        _combinedData.AddRange(data.Skip(3));
                        ParseRGBCommands(_combinedData.ToArray());
                        _combinedData.Clear();
                    }
                    else
                    {
                        _combinedData.AddRange(data.Skip(3));
                    }
                    break;

                case 1:
                    ParseSettingCommands(data);
                    break;
            }
        }
        catch (Exception ex)
        {
            Logger.Log($"Error processing packet: {ex.Message} {ex.StackTrace}");
        }
    }

    private void ParseSettingCommands(byte[] data)
    {
        if (data.Length >= 8)
        {
            try
            {
                _matrixSizeType = (MatrixSizeType)data[1];
                _matrixSizeTier = (MatrixSizeTier)data[2];
                _shutdownEffect = (ShutdownEffect)data[3];
                _showFps = data[4] != 0;
                _blurIntensity = data[5];
                _ledShape = (LEDShape)data[6];
                _roundedRectangleCornerRadius = data[7];
                _ledPadding = data[8];
                _fps = data[9];
                _coverImageStretch = (Stretch)data[10];
                _cpuUsagePauseValue = data[11];
                _backgroundColor = Color.FromRgb(data[12], data[13], data[14]);
                _shutdownColor = Color.FromRgb(data[15], data[16], data[17]);
                
                // Skip length byte at index 18, cover image starts at 19
                _coverImage = Encoding.UTF8.GetString(data.Skip(19).ToArray()).TrimEnd('\0');

                var eventArgs = new RGBSettingsChangedEventArgs(
                    _matrixSizeType, _matrixSizeTier, _shutdownEffect, _showFps, _blurIntensity,
                    _ledShape, _roundedRectangleCornerRadius, _ledPadding, _fps, _coverImageStretch,
                    _backgroundColor, _cpuUsagePauseValue, _coverImage, _shutdownColor);

                SettingsChanged?.Invoke(this, eventArgs);
            }
            catch (Exception ex)
            {
                Logger.Log($"Error parsing settings packet: {ex.Message} {ex.StackTrace}");
            }
        }
    }

    private void ParseRGBCommands(byte[] data)
    {
        if (data.Length >= 3)
        {
            try
            {
                lock (_colors)
                {
                    _colors.Clear();
                    for (int i = 0; i < data.Length - 2; i += 3)
                    {
                        byte r = data[i];
                        byte g = data[i + 1];
                        byte b = data[i + 2];
                        _colors.Add(Color.FromRgb(r, g, b));
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.Log($"Error parsing RGB packet: {ex.Message} {ex.StackTrace}");
            }
        }
    }

    public void StopListening()
    {
        _isListening = false;
        if (_udpClient != null)
        {
            _udpClient.Close();
            _udpClient = null;
        }
    }
}

public class RGBSettingsChangedEventArgs : EventArgs
{
    public MatrixSizeType MatrixSizeType { get; }
    public MatrixSizeTier MatrixSizeTier { get; }
    public ShutdownEffect ShutdownEffect { get; }
    public bool ShowFps { get; }
    public int BlurIntensity { get; }
    public LEDShape LEDShape { get; }
    public int RoundedRectangleCornerRadius { get; }
    public float LEDPadding { get; }
    public int FPS { get; }
    public Stretch CoverImageStretch { get; }
    public Color BackgroundColor { get; }
    public Color ShutdownColor { get; }
    public int CPUUsagePauseValue { get; }
    public string? CoverImage { get; }

    public RGBSettingsChangedEventArgs(
        MatrixSizeType matrixSizeType, MatrixSizeTier matrixSizeTier, ShutdownEffect shutdownEffect,
        bool showFps, int blurIntensity, LEDShape ledShape, int roundedRectangleCornerRadius,
        float ledPadding, int fps, Stretch coverImageStretch, Color backgroundColor,
        int cpuUsagePauseValue, string? coverImage, Color shutdownColor)
    {
        MatrixSizeType = matrixSizeType;
        MatrixSizeTier = matrixSizeTier;
        ShutdownEffect = shutdownEffect;
        ShowFps = showFps;
        BlurIntensity = blurIntensity;
        LEDShape = ledShape;
        RoundedRectangleCornerRadius = roundedRectangleCornerRadius;
        LEDPadding = ledPadding;
        FPS = fps;
        CoverImageStretch = coverImageStretch;
        BackgroundColor = backgroundColor;
        CPUUsagePauseValue = cpuUsagePauseValue;
        CoverImage = coverImage;
        ShutdownColor = shutdownColor;
    }
}
