; Inno Setup script: installs RGB Wallpaper for Wallpaper Engine and/or Lively Wallpaper.
; Build:  iscc /DAppVersion=1.0.0 /DStageDir=<stage.ps1 output> installer.iss

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef StageDir
  #define StageDir "..\..\staging"
#endif

[Setup]
AppId={{6D1E5B0C-3F5A-4B8E-9A52-7C1F0E2B8D41}
AppName=RGB Wallpaper
AppVersion={#AppVersion}
AppPublisher=I'm Not MentaL
AppPublisherURL=https://github.com/qiangqiang101/RGB-Wallpaper
; Files go to the Wallpaper Engine / Lively folders chosen on the custom pages below,
; so there is no single install dir. Uninstall data lives in a fixed location instead.
CreateAppDir=no
UninstallFilesDir={commonappdata}\RGBWallpaper
UninstallDisplayName=RGB Wallpaper (Wallpaper Engine / Lively)
; Wallpaper Engine usually lives under Program Files (x86), so write access needs admin
PrivilegesRequired=admin
DisableProgramGroupPage=yes
OutputDir=..\..\dist
OutputBaseFilename=RGB-Wallpaper-Setup-{#AppVersion}
Compression=lzma2/ultra
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Types]
Name: "full"; Description: "Wallpaper Engine and Lively (all 4 displays each)"
Name: "wpe"; Description: "Wallpaper Engine only (all 4 displays)"
Name: "lively"; Description: "Lively Wallpaper only (all 4 displays)"
Name: "custom"; Description: "Custom: choose launcher and displays"; Flags: iscustom

[Components]
Name: "wpe"; Description: "Wallpaper Engine"; Types: full wpe
Name: "wpe\d1"; Description: "RGB Wallpaper (Display 1), port 8133"; Types: full wpe
Name: "wpe\d2"; Description: "RGB Wallpaper (Display 2), port 8134"; Types: full wpe
Name: "wpe\d3"; Description: "RGB Wallpaper (Display 3), port 8135"; Types: full wpe
Name: "wpe\d4"; Description: "RGB Wallpaper (Display 4), port 8136"; Types: full wpe
Name: "lively"; Description: "Lively Wallpaper"; Types: full lively
Name: "lively\d1"; Description: "RGB Wallpaper (Display 1), port 8133"; Types: full lively
Name: "lively\d2"; Description: "RGB Wallpaper (Display 2), port 8134"; Types: full lively
Name: "lively\d3"; Description: "RGB Wallpaper (Display 3), port 8135"; Types: full lively
Name: "lively\d4"; Description: "RGB Wallpaper (Display 4), port 8136"; Types: full lively

[Files]
; The shared app files use identical source/flags for every display, so Setup stores them only once.
; Each display then adds its own project.json/config.json (Wallpaper Engine) or LivelyInfo.json/config.json (Lively).

; ---- Wallpaper Engine ----
Source: "{#StageDir}\app\*"; DestDir: "{code:GetWpeDir}\rgbwallpaper1"; Components: wpe\d1; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "*.pdb"
Source: "{#StageDir}\wpe\rgbwallpaper1\*"; DestDir: "{code:GetWpeDir}\rgbwallpaper1"; Components: wpe\d1; Flags: ignoreversion
Source: "..\assets\preview.gif"; DestDir: "{code:GetWpeDir}\rgbwallpaper1"; Components: wpe\d1; Flags: ignoreversion

Source: "{#StageDir}\app\*"; DestDir: "{code:GetWpeDir}\rgbwallpaper2"; Components: wpe\d2; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "*.pdb"
Source: "{#StageDir}\wpe\rgbwallpaper2\*"; DestDir: "{code:GetWpeDir}\rgbwallpaper2"; Components: wpe\d2; Flags: ignoreversion
Source: "..\assets\preview.gif"; DestDir: "{code:GetWpeDir}\rgbwallpaper2"; Components: wpe\d2; Flags: ignoreversion

Source: "{#StageDir}\app\*"; DestDir: "{code:GetWpeDir}\rgbwallpaper3"; Components: wpe\d3; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "*.pdb"
Source: "{#StageDir}\wpe\rgbwallpaper3\*"; DestDir: "{code:GetWpeDir}\rgbwallpaper3"; Components: wpe\d3; Flags: ignoreversion
Source: "..\assets\preview.gif"; DestDir: "{code:GetWpeDir}\rgbwallpaper3"; Components: wpe\d3; Flags: ignoreversion

Source: "{#StageDir}\app\*"; DestDir: "{code:GetWpeDir}\rgbwallpaper4"; Components: wpe\d4; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "*.pdb"
Source: "{#StageDir}\wpe\rgbwallpaper4\*"; DestDir: "{code:GetWpeDir}\rgbwallpaper4"; Components: wpe\d4; Flags: ignoreversion
Source: "..\assets\preview.gif"; DestDir: "{code:GetWpeDir}\rgbwallpaper4"; Components: wpe\d4; Flags: ignoreversion

; ---- Lively Wallpaper (<library>\wallpapers\<folder>) ----
Source: "{#StageDir}\app\*"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display1"; Components: lively\d1; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "*.pdb"
Source: "{#StageDir}\lively-info\Display1\*"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display1"; Components: lively\d1; Flags: ignoreversion
Source: "{#StageDir}\wpe\rgbwallpaper1\config.json"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display1"; Components: lively\d1; Flags: ignoreversion
Source: "..\assets\thumb.gif"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display1"; Components: lively\d1; Flags: ignoreversion

Source: "{#StageDir}\app\*"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display2"; Components: lively\d2; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "*.pdb"
Source: "{#StageDir}\lively-info\Display2\*"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display2"; Components: lively\d2; Flags: ignoreversion
Source: "{#StageDir}\wpe\rgbwallpaper2\config.json"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display2"; Components: lively\d2; Flags: ignoreversion
Source: "..\assets\thumb.gif"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display2"; Components: lively\d2; Flags: ignoreversion

Source: "{#StageDir}\app\*"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display3"; Components: lively\d3; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "*.pdb"
Source: "{#StageDir}\lively-info\Display3\*"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display3"; Components: lively\d3; Flags: ignoreversion
Source: "{#StageDir}\wpe\rgbwallpaper3\config.json"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display3"; Components: lively\d3; Flags: ignoreversion
Source: "..\assets\thumb.gif"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display3"; Components: lively\d3; Flags: ignoreversion

Source: "{#StageDir}\app\*"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display4"; Components: lively\d4; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "*.pdb"
Source: "{#StageDir}\lively-info\Display4\*"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display4"; Components: lively\d4; Flags: ignoreversion
Source: "{#StageDir}\wpe\rgbwallpaper4\config.json"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display4"; Components: lively\d4; Flags: ignoreversion
Source: "..\assets\thumb.gif"; DestDir: "{code:GetLivelyDir}\wallpapers\rgbwallpaper-display4"; Components: lively\d4; Flags: ignoreversion

[Code]
const
  WpeSubDir = '\steamapps\common\wallpaper_engine\projects\myprojects';
  WpeMarker = '\steamapps\common\wallpaper_engine';

var
  WpePage: TInputDirWizardPage;
  LivelyPage: TInputDirWizardPage;
  WpeDetected: Boolean;
  LivelyDetected: Boolean;

{ ---------- Wallpaper Engine detection ---------- }

// Returns the Steam install folder, or '' if Steam isn't installed.
function GetSteamPath: String;
begin
  Result := '';
  if not RegQueryStringValue(HKCU, 'Software\Valve\Steam', 'SteamPath', Result) then
    if not RegQueryStringValue(HKLM32, 'SOFTWARE\Valve\Steam', 'InstallPath', Result) then
      RegQueryStringValue(HKLM64, 'SOFTWARE\Valve\Steam', 'InstallPath', Result);
  StringChangeEx(Result, '/', '\', True);
end;

// Wallpaper Engine may be on any Steam library drive, so read libraryfolders.vdf
// and return the first library that contains it.
function FindWpeLibrary(const SteamPath: String): String;
var
  Lines: TArrayOfString;
  I, P: Integer;
  Line, Candidate: String;
begin
  Result := '';
  if DirExists(SteamPath + WpeMarker) then
  begin
    Result := SteamPath;
    Exit;
  end;
  if not LoadStringsFromFile(SteamPath + '\steamapps\libraryfolders.vdf', Lines) then
    Exit;
  for I := 0 to GetArrayLength(Lines) - 1 do
  begin
    Line := Trim(Lines[I]);
    // Lines look like:  "path"		"D:\\SteamLibrary"
    if Pos('"path"', Line) = 1 then
    begin
      Delete(Line, 1, Length('"path"'));
      Line := Trim(Line);
      if (Length(Line) > 1) and (Line[1] = '"') then
      begin
        Delete(Line, 1, 1);
        P := Pos('"', Line);
        if P > 0 then
        begin
          Candidate := Copy(Line, 1, P - 1);
          StringChangeEx(Candidate, '\\', '\', True);
          if DirExists(Candidate + WpeMarker) then
          begin
            Result := Candidate;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

function DetectWpeDir: String;
var
  Steam, Lib: String;
begin
  WpeDetected := False;
  Steam := GetSteamPath;
  if Steam <> '' then
  begin
    Lib := FindWpeLibrary(Steam);
    if Lib <> '' then
    begin
      WpeDetected := True;
      Result := Lib + WpeSubDir;
    end
    else
      // Steam found but Wallpaper Engine isn't in any library: fall back to Steam's own library.
      Result := Steam + WpeSubDir;
    Exit;
  end;
  Result := ExpandConstant('{commonpf32}') + '\Steam' + WpeSubDir;
end;

{ ---------- Lively detection ---------- }

// Lively keeps its library location in %LOCALAPPDATA%\Lively Wallpaper\Settings.json:
//   "WallpaperDir": "C:\\Users\\me\\AppData\\Local\\Lively Wallpaper\\Library",
// Wallpapers live in <WallpaperDir>\wallpapers\<folder>.
function DetectLivelyDir: String;
var
  Lines: TArrayOfString;
  I, P: Integer;
  Line: String;
begin
  Result := ExpandConstant('{localappdata}') + '\Lively Wallpaper\Library';
  LivelyDetected := DirExists(ExpandConstant('{localappdata}') + '\Lively Wallpaper');
  if not LoadStringsFromFile(ExpandConstant('{localappdata}') + '\Lively Wallpaper\Settings.json', Lines) then
    Exit;
  for I := 0 to GetArrayLength(Lines) - 1 do
  begin
    Line := Trim(Lines[I]);
    if Pos('"WallpaperDir"', Line) = 1 then
    begin
      Delete(Line, 1, Length('"WallpaperDir"'));
      P := Pos('"', Line);           // opening quote of the value
      if P > 0 then
      begin
        Delete(Line, 1, P);
        P := Pos('"', Line);         // closing quote
        if P > 1 then
        begin
          Result := Copy(Line, 1, P - 1);
          StringChangeEx(Result, '\\', '\', True);
          LivelyDetected := True;
        end;
      end;
      Exit;
    end;
  end;
end;

{ ---------- Wizard pages ---------- }

// Silent installs can pass /WPEDIR="..." and /LIVELYDIR="..." to skip detection.
function InitialDir(const ParamName, Detected: String): String;
begin
  Result := ExpandConstant('{param:' + ParamName + '|}');
  if Result = '' then
    Result := Detected;
end;

procedure InitializeWizard;
begin
  WpePage := CreateInputDirPage(wpSelectComponents, 'Wallpaper Engine',
    'Where is Wallpaper Engine installed?',
    'Select the Wallpaper Engine "projects\myprojects" folder (detected automatically from Steam when possible). ' +
    'Click Next to continue.', False, '');
  WpePage.Add('');
  WpePage.Values[0] := InitialDir('WPEDIR', DetectWpeDir);

  LivelyPage := CreateInputDirPage(WpePage.ID, 'Lively Wallpaper',
    'Where is your Lively Wallpaper library?',
    'Select your Lively library folder (the one that contains "wallpapers"; detected automatically from ' +
    'Lively''s settings when possible). Click Next to continue.', False, '');
  LivelyPage.Add('');
  LivelyPage.Values[0] := InitialDir('LIVELYDIR', DetectLivelyDir);
end;

function GetWpeDir(Param: String): String;
begin
  Result := RemoveBackslash(WpePage.Values[0]);
end;

function GetLivelyDir(Param: String): String;
begin
  Result := RemoveBackslash(LivelyPage.Values[0]);
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := False;
  if PageID = WpePage.ID then
    Result := not WizardIsComponentSelected('wpe')
  else if PageID = LivelyPage.ID then
    Result := not WizardIsComponentSelected('lively');
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;

  if CurPageID = wpSelectComponents then
  begin
    if not (WizardIsComponentSelected('wpe') or WizardIsComponentSelected('lively')) then
    begin
      MsgBox('Select at least one display to install.', mbError, MB_OK);
      Result := False;
    end;
  end
  else if CurPageID = WpePage.ID then
  begin
    if not DirExists(ExtractFileDir(WpePage.Values[0])) then
      Result := MsgBox('"' + WpePage.Values[0] + '" does not look like a Wallpaper Engine projects ' +
        'folder (its parent folder does not exist).' + #13#10 + #13#10 + 'Install here anyway?',
        mbConfirmation, MB_YESNO) = IDYES;
  end
  else if CurPageID = LivelyPage.ID then
  begin
    if not DirExists(LivelyPage.Values[0] + '\wallpapers') then
      Result := MsgBox('"' + LivelyPage.Values[0] + '" does not contain a "wallpapers" folder, so it does ' +
        'not look like a Lively library.' + #13#10 + #13#10 + 'Install here anyway?',
        mbConfirmation, MB_YESNO) = IDYES;
  end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if (CurPageID = WpePage.ID) and not WpeDetected then
    WpePage.Description := 'Wallpaper Engine was not found automatically. Choose your Wallpaper Engine "projects\myprojects" folder manually.'
  else if (CurPageID = LivelyPage.ID) and not LivelyDetected then
    LivelyPage.Description := 'Lively Wallpaper was not found automatically. Choose your Lively library folder manually.';
end;
