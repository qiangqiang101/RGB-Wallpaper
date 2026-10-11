; Inno Setup script: installs RGB Wallpaper into Wallpaper Engine's "myprojects" folder.
; Build:  iscc /DAppVersion=1.0.0 /DStageDir=<stage.ps1 output> installer.iss

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef StageDir
  #define StageDir "..\..\staging"
#endif

[Setup]
AppId={{6D1E5B0C-3F5A-4B8E-9A52-7C1F0E2B8D41}
AppName=RGB Wallpaper for Wallpaper Engine
AppVersion={#AppVersion}
AppPublisher=I'm Not MentaL
AppPublisherURL=https://github.com/qiangqiang101/RGB-Wallpaper
DefaultDirName={code:GetDefaultDir}
DirExistsWarning=no
; Wallpaper Engine usually lives under Program Files (x86), so write access needs admin
PrivilegesRequired=admin
DisableProgramGroupPage=yes
DisableReadyPage=no
UsePreviousAppDir=no
OutputDir=..\..\dist
OutputBaseFilename=RGB-Wallpaper-WallpaperEngine-Setup-{#AppVersion}
Compression=lzma2/ultra
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayName=RGB Wallpaper for Wallpaper Engine

[Types]
Name: "full"; Description: "All 4 displays"
Name: "single"; Description: "Display 1 only"
Name: "custom"; Description: "Custom: choose which displays"; Flags: iscustom

[Components]
Name: "d1"; Description: "RGB Wallpaper (Display 1), port 8133"; Types: full single custom
Name: "d2"; Description: "RGB Wallpaper (Display 2), port 8134"; Types: full
Name: "d3"; Description: "RGB Wallpaper (Display 3), port 8135"; Types: full
Name: "d4"; Description: "RGB Wallpaper (Display 4), port 8136"; Types: full

[Files]
; {app} is Wallpaper Engine's projects\myprojects folder; each display gets its own project folder.
; Shared app files are copied once per selected display, with that display's own project.json/config.json.
Source: "{#StageDir}\app\*"; DestDir: "{app}\rgbwallpaper1"; Components: d1; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "*.pdb"
Source: "{#StageDir}\wpe\rgbwallpaper1\*"; DestDir: "{app}\rgbwallpaper1"; Components: d1; Flags: ignoreversion
Source: "..\assets\preview.gif"; DestDir: "{app}\rgbwallpaper1"; Components: d1; Flags: ignoreversion

Source: "{#StageDir}\app\*"; DestDir: "{app}\rgbwallpaper2"; Components: d2; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "*.pdb"
Source: "{#StageDir}\wpe\rgbwallpaper2\*"; DestDir: "{app}\rgbwallpaper2"; Components: d2; Flags: ignoreversion
Source: "..\assets\preview.gif"; DestDir: "{app}\rgbwallpaper2"; Components: d2; Flags: ignoreversion

Source: "{#StageDir}\app\*"; DestDir: "{app}\rgbwallpaper3"; Components: d3; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "*.pdb"
Source: "{#StageDir}\wpe\rgbwallpaper3\*"; DestDir: "{app}\rgbwallpaper3"; Components: d3; Flags: ignoreversion
Source: "..\assets\preview.gif"; DestDir: "{app}\rgbwallpaper3"; Components: d3; Flags: ignoreversion

Source: "{#StageDir}\app\*"; DestDir: "{app}\rgbwallpaper4"; Components: d4; Flags: recursesubdirs createallsubdirs ignoreversion; Excludes: "*.pdb"
Source: "{#StageDir}\wpe\rgbwallpaper4\*"; DestDir: "{app}\rgbwallpaper4"; Components: d4; Flags: ignoreversion
Source: "..\assets\preview.gif"; DestDir: "{app}\rgbwallpaper4"; Components: d4; Flags: ignoreversion

[Messages]
SelectDirLabel3=Select the Wallpaper Engine "myprojects" folder (detected automatically from Steam when possible).
SelectDirBrowseLabel=Click Next to continue, or Browse to pick a different Wallpaper Engine "myprojects" folder.

[Code]
const
  WpeSubDir = '\steamapps\common\wallpaper_engine\projects\myprojects';
  WpeMarker = '\steamapps\common\wallpaper_engine';

var
  WpeDetected: Boolean;

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

function GetDefaultDir(Param: String): String;
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
      Exit;
    end;
    // Steam found but Wallpaper Engine isn't in any library: fall back to Steam's own library.
    Result := Steam + WpeSubDir;
    Exit;
  end;
  Result := ExpandConstant('{commonpf32}') + '\Steam' + WpeSubDir;
end;

procedure InitializeWizard;
begin
  GetDefaultDir('');  // refresh WpeDetected regardless of when Setup evaluated DefaultDirName
  if not WpeDetected then
    MsgBox('Wallpaper Engine was not found automatically.' + #13#10 + #13#10 +
      'On the next pages, choose your Wallpaper Engine "projects\myprojects" folder ' +
      'manually. You can also cancel and install Wallpaper Engine from Steam first.',
      mbInformation, MB_OK);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if CurPageID = wpSelectDir then
    if not DirExists(ExtractFileDir(WizardDirValue)) then
      Result := MsgBox('The folder "' + WizardDirValue + '" does not look like a Wallpaper Engine ' +
        'projects folder (its parent folder does not exist).' + #13#10 + #13#10 + 'Install here anyway?',
        mbConfirmation, MB_YESNO) = IDYES;
end;
