; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Unyo"
; #define MyAppVersion "v0.5.9"
#define MyAppPublisher "Kevin Borges"
#define MyAppURL "https://github.com/K3vinb5/Unyo"
#define MyAppExeName "unyo.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{F90925D3-ED12-4E10-93DC-536BCA639295}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
OutputDir=build\windows\x64\runner
OutputBaseFilename=unyo-{#MyAppVersion}-windows-setup
; "ArchitecturesAllowed=x64compatible" specifies that Setup cannot run
; on anything but x64 and Windows 11 on Arm.
ArchitecturesAllowed=x64compatible
; "ArchitecturesInstallIn64BitMode=x64compatible" requests that the
; install be done in "64-bit mode" on x64 or Windows 11 on Arm,
; meaning it should use the native 64-bit Program Files directory and
; the 64-bit view of the registry.
ArchitecturesInstallIn64BitMode=x64compatible
DisableProgramGroupPage=yes
LicenseFile=windows-installer\LICENSE.txt
; Remove the following line to run in administrative install mode (install for all users.)
; PrivilegesRequired=lowest
; PrivilegesRequiredOverridesAllowed=dialog
SetupIconFile=windows\runner\resources\app_icon.ico
AppCopyright=© 2024 {#AppPublisher}
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

; [Tasks]#define MyAppVersion "v0.5.9"

Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "build\windows\x64\runner\Release\{#AppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(AppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent