; Inno Setup script for the Windows installer of Deberc.
;
; Packs the Flutter release bundle (build\windows\x64\runner\Release) into
; a per-user setup.exe that needs no administrator rights. Build it with
; devops\windows\build-installer.ps1, which passes /DAppVersion and
; /DOutputDir to ISCC.

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef OutputDir
  #define OutputDir "."
#endif

#define RepoRoot AddBackslash(SourcePath) + "..\.."
#define Bundle RepoRoot + "\build\windows\x64\runner\Release"

[Setup]
AppId={{83DDDBB1-F39C-47A3-89A0-56E53BD2BE29}
AppName=Deberc
AppVersion={#AppVersion}
AppVerName=Deberc {#AppVersion}
AppPublisher=Roman Lytvyn
AppPublisherURL=https://deberc.lytvyn.org
AppSupportURL=https://deberc.lytvyn.org/support/
VersionInfoVersion={#AppVersion}
DefaultDirName={autopf}\Deberc
DefaultGroupName=Deberc
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir={#OutputDir}
OutputBaseFilename=deberc-{#AppVersion}-setup
SetupIconFile={#RepoRoot}\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\deberc.exe
Compression=lzma2
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[CustomMessages]
english.AppTitle=Deberc
ukrainian.AppTitle=Деберць

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#Bundle}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{cm:AppTitle}"; Filename: "{app}\deberc.exe"
Name: "{autodesktop}\{cm:AppTitle}"; Filename: "{app}\deberc.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\deberc.exe"; Description: "{cm:LaunchProgram,{cm:AppTitle}}"; Flags: nowait postinstall skipifsilent
