; Inno Setup script for the Windows installer of an app of the family.
;
; Packs the Flutter release bundle (build\windows\x64\runner\Release) into
; a per-user setup.exe that needs no administrator rights. Build it with
; devops\windows\build-installer.ps1, which passes /DAppVersion, /DOutputDir
; and /DAppDefines, the file with the app's identity, to ISCC.

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef OutputDir
  #define OutputDir "."
#endif
#include AppDefines

#define RepoRoot AddBackslash(SourcePath) + "..\.."
#define Bundle RepoRoot + "\build\windows\x64\runner\Release"

[Setup]
AppId={{{#AppGuid}}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher=Roman Lytvyn
AppPublisherURL={#AppWebsite}
AppSupportURL={#AppWebsite}/support/
VersionInfoVersion={#AppVersion}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir={#OutputDir}
OutputBaseFilename={#AppFile}-{#AppVersion}-setup
SetupIconFile={#RepoRoot}\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#AppFile}.exe
Compression=lzma2
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[CustomMessages]
english.AppTitle={#AppName}
ukrainian.AppTitle={#AppNameUk}

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#Bundle}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{cm:AppTitle}"; Filename: "{app}\{#AppFile}.exe"
Name: "{autodesktop}\{cm:AppTitle}"; Filename: "{app}\{#AppFile}.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppFile}.exe"; Description: "{cm:LaunchProgram,{cm:AppTitle}}"; Flags: nowait postinstall skipifsilent
