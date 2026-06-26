; PasteToFile Installer Script
; Inno Setup 6 Compiler Script (.iss)
; This creates a professional Windows installer for PasteToFile

#define MyAppName "PasteToFile"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "PasteToFile"
#define MyAppURL "https://github.com/chapas/PasteToFile"
#define MyAppExeName "PasteToFile.exe"

[Setup]
AppId=PasteToFile-{#MyAppVersion}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile=LICENSE
OutputDir=.\Installer
OutputBaseFilename=PasteToFile-Setup-{#MyAppVersion}
WizardStyle=modern
PrivilegesRequired=admin
Compression=lzma2/ultra
SolidCompression=yes
DisableProgramGroupPage=no
CreateUninstallRegKey=yes
Uninstallable=yes

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"

[Types]
Name: "full"; Description: "Full installation"
Name: "compact"; Description: "Minimal installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "program"; Description: "Program Files"; Types: full compact custom; Flags: fixed
Name: "integration"; Description: "Windows Explorer Integration"; Types: full; Flags: fixed
Name: "shortcut"; Description: "Start Menu Shortcut"; Types: full compact

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "startupfolder"; Description: "Create Start Menu Shortcut"; GroupDescription: "Start Menu"
Name: "autostart"; Description: "Start PasteToFile automatically when Windows starts"; GroupDescription: "Startup"; Flags: unchecked

[Files]
; Main application executable (self-contained)
Source: "bin\Release\net10.0-windows7.0\win-x64\publish\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
; Application icon
Source: "PasteToFile.ico"; DestDir: "{app}"; Flags: ignoreversion
; Documentation
Source: "README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\README"; Filename: "notepad.exe"; Parameters: "{app}\README.md"
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Launch PasteToFile"; Flags: nowait postinstall skipifsilent
Filename: "powershell.exe"; Parameters: "-Command ""if ($env:autostart -eq 'true') { $null = New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'PasteToFile' -Value '{app}\{#MyAppExeName}' -Force }"""; Flags: runhidden; Tasks: autostart

[UninstallRun]
Filename: "powershell.exe"; Parameters: "-Command ""reg delete 'HKCR:\Directory\Background\shell\Paste to file' /f 2>$null; exit 0"""; Flags: runhidden

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  if CurStep = ssPostInstall then
  begin
	// Register Windows startup if autostart task is selected
	if IsTaskSelected('autostart') then
	begin
	  RegWriteStringValue(HKEY_CURRENT_USER, 'Software\Microsoft\Windows\CurrentVersion\Run',
						  'PasteToFile', ExpandConstant('{app}\{#MyAppExeName}'));
	end;

	MsgBox('PasteToFile has been successfully installed!' + #13#13 +
		   'You can now right-click in any folder and select "Paste to file".' + #13#13 +
		   'Copy an image or text to clipboard, then use the context menu to paste it as a file.',
		   mbInformation, MB_OK);
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
  begin
	// Remove Windows startup registry entry on uninstall
	RegDeleteValue(HKEY_CURRENT_USER, 'Software\Microsoft\Windows\CurrentVersion\Run', 'PasteToFile');
  end;
end;
