# PasteToFile Installer Setup Guide

Professional Windows installer creation guide for PasteToFile utility.

**Last Updated:** June 2026  
**Version:** 1.0.0  
**Status:** Production-Ready ✅

---

## Table of Contents

1. [Overview](#overview)
2. [What You'll Get](#what-youll-get)
3. [Prerequisites](#prerequisites)
4. [Quick Start](#quick-start)
5. [Creating the Installer](#creating-the-installer)
6. [Customizing the Installer](#customizing-the-installer)
7. [Distribution Methods](#distribution-methods)
8. [Troubleshooting](#troubleshooting)
9. [Advanced Topics](#advanced-topics)
10. [FAQ](#faq)

---

## Overview

This guide covers the complete lifecycle of PasteToFile's Windows installer:
- **Building** the installer from source
- **Customizing** installer behavior and appearance
- **Distributing** to end users
- **Managing** updates and versions
- **Troubleshooting** common issues

The installer is built using **Inno Setup**, the industry-standard Windows installer platform trusted by thousands of projects.

---

## What You'll Get

A professional, production-ready Windows installer (`.exe` file) with:

- ✅ **Automatic .NET 10.0 Runtime Detection** - Prompts users to install if missing
- ✅ **Context Menu Integration** - "Paste to file" appears in Windows Explorer right-click menu
- ✅ **Smart Installation** - Detects system configuration and adapts installation paths
- ✅ **Start Menu Shortcuts** - Easy access from Start Menu
- ✅ **Desktop Icon Option** - Users can choose to add desktop shortcut
- ✅ **Professional UI** - Modern installer wizard with branding
- ✅ **Auto-Update Support** - Built-in uninstall and reinstall capabilities
- ✅ **Registry Management** - Handles all system registry operations
- ✅ **Clean Uninstall** - Complete removal of all files and registry entries
- ✅ **Lightweight** - ~2 MB installer (self-contained application)

---

## Prerequisites

### System Requirements for Building

| Requirement | Version | Notes |
|------------|---------|-------|
| **Windows** | 10, 11, Server 2019+ | 64-bit preferred |
| **.NET SDK** | 10.0 or later | Required for compilation |
| **Inno Setup** | 6.0 or later | Required for installer compilation |
| **PowerShell** | 5.0+ or Core | For running build scripts |
| **Administrator** | Yes | Required to modify registry during setup |

### 1. Install .NET 10.0 SDK

Check if you have .NET 10.0 SDK:

```powershell
dotnet --version
```

Expected output: `10.0.x` or higher

**If not installed:**
- Download from: https://dotnet.microsoft.com/download/dotnet/10.0
- Choose "SDK" version
- Run the installer
- Restart your terminal/IDE

### 2. Install Inno Setup 6

**Inno Setup** compiles the `.iss` script into the final `.exe` installer.

**Steps:**

1. Visit: https://jrsoftware.org/isdl.php
2. Download **"Inno Setup 6"** (or latest stable version)
3. Run the installer
4. Accept default installation location: `C:\Program Files (x86)\Inno Setup 6`
5. Complete the installation

**Verify Installation:**

```powershell
# Check if ISCC.exe exists
Test-Path "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
# Should return: True
```

**Alternative Locations (if different):**
- Inno Setup 5: `C:\Program Files (x86)\Inno Setup 5\ISCC.exe`
- Custom path: Update scripts accordingly

---

## Quick Start

**Just want to build the installer fast?**

```powershell
cd "C:\src\PasteToFile"
powershell -ExecutionPolicy Bypass -File build-installer.ps1
```

Your installer will be at: `Installer\PasteToFile-Setup-1.0.0.exe`

**Then double-click to test!** 🚀

---

## Creating the Installer

### Build Methods Comparison

| Method | Ease | Features | Best For |
|--------|------|----------|----------|
| **PowerShell** | ⭐⭐⭐ Easy | Colored output, progress | Most users |
| **Batch** | ⭐⭐ Medium | Basic output, menu | CMD preference |
| **Manual** | ⭐ Complex | Full control | Debugging |
| **CI/CD** | ⭐⭐⭐ Easy | Automated | Team workflows |

---

### Method 1: PowerShell Script (Recommended) ⭐

**Best for:** Most users, fastest, colored output

**Steps:**

1. **Open PowerShell as Administrator**
   - Press `Win + X`, select "Windows PowerShell (Admin)"
   - Or right-click PowerShell icon and select "Run as administrator"

2. **Navigate to project:**
   ```powershell
   cd "C:\src\PasteToFile"
   ```

3. **Run the build script:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File build-installer.ps1
   ```

4. **Watch the progress:**
   - Script automatically:
     - ✓ Cleans previous builds
     - ✓ Restores NuGet packages
     - ✓ Compiles in Release mode
     - ✓ Publishes application
     - ✓ Compiles Inno Setup script
     - ✓ Opens installer folder

5. **Result:** `Installer\PasteToFile-Setup-1.0.0.exe` ✅

**Advanced options:**
```powershell
# Skip build, only create installer
.\build-installer.ps1 -SkipBuild

# Build without opening output folder
.\build-installer.ps1 -OpenOutput:$false

# Combine options
.\build-installer.ps1 -SkipBuild -OpenOutput:$false
```

---

### Method 2: Batch Script

**Best for:** Traditional Command Prompt users, simple interface

**Steps:**

1. **Open Command Prompt as Administrator**
   - Press `Win + X`, select "Command Prompt (Admin)"
   - Or right-click cmd.exe and select "Run as administrator"

2. **Navigate to project:**
   ```cmd
   cd C:\src\PasteToFile
   ```

3. **Run the script:**
   ```cmd
   build-installer.bat
   ```

4. **Follow the menu:**
   - Interactive menu appears with options
   - Select "1" for full build
   - Wait for completion

5. **Result:** `Installer\PasteToFile-Setup-1.0.0.exe` ✅

---

### Method 3: Interactive Menu (GUI-Style)

**Best for:** Decision-making, trial builds

**Steps:**

1. Double-click `build.bat` in the project root
2. Menu appears with options:
   - [1] Build Installer (Full)
   - [2] Quick Rebuild (Skip Clean)
   - [3] Open Installer Folder
   - [4] Clean Build Artifacts
   - [5] View Build Guide
   - [6] Exit

3. Enter your choice and follow prompts

---

### Method 4: Manual Step-by-Step Build

**Best for:** Debugging, custom workflows, learning

**Step 1 - Clean previous builds:**
```powershell
cd "C:\src\PasteToFile"
Remove-Item -Path "bin", "obj" -Recurse -Force -ErrorAction SilentlyContinue
```

**Step 2 - Restore and compile:**
```powershell
dotnet restore
dotnet build -c Release
dotnet publish -c Release
```

**Step 3 - Compile installer:**
```powershell
& "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" /Q "PasteToFile.iss"
```

**Step 4 - Verify output:**
```powershell
Get-ChildItem "Installer" -Filter "*.exe"
```

**Output indicators:**
- File size: ~2.15 MB (self-contained .NET app)
- Creation time: Usually 1-2 minutes
- Status: Ready for distribution ✅

---

### Build Output Structure

After successful build, your directory contains:

```
C:\src\PasteToFile\
├── bin\Release\net10.0-windows7.0\
│   └── win-x64\publish\
│       └── PasteToFile.exe           (self-contained ~500 KB)
│
├── Installer\
│   ├── PasteToFile-Setup-1.0.0.exe   ← Your installer! (2.15 MB)
│   └── Other setup files...
│
├── build-installer.ps1               (automation script)
├── build-installer.bat               (automation script)
├── build.bat                         (interactive menu)
└── PasteToFile.iss                  (Inno Setup configuration)
```

---

## Customizing the Installer

### File: `PasteToFile.iss` (Inno Setup Configuration)

This is the main configuration file that controls installer behavior, appearance, and deployment.

### Basic Customizations

#### 1. Change Application Version

**File:** `PasteToFile.iss`

Find this line:
```ini
#define MyAppVersion "1.0.0"
```

Change to your version:
```ini
#define MyAppVersion "1.1.0"
```

**Important:** This affects:
- Installer filename: `PasteToFile-Setup-1.1.0.exe`
- Version in Add/Remove Programs
- Registry version tracking
- Upgrade detection

#### 2. Change Installation Directory

**Default location:** `C:\Program Files\PasteToFile`

To change, find:
```ini
DefaultDirName={pf}\{#MyAppName}
```

Replace `{pf}` with:
- `{pf}` = Program Files (x86 on 64-bit systems)
- `{pf64}` = Program Files (64-bit)
- `{localappdata}` = C:\Users\[Username]\AppData\Local
- `{userdesktop}` = Desktop
- `{sd}` = System drive (C:\)

**Example - Install to AppData:**
```ini
DefaultDirName={localappdata}\{#MyAppName}
```

#### 3. Customize Installer Appearance

**Language:**
```ini
DefaultLanguage=en
```

Add more languages:
```ini
[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "es"; MessagesFile: "compiler:Spanish.isl"
Name: "fr"; MessagesFile: "compiler:French.isl"
```

**Wizard Style:**
```ini
WizardStyle=modern
```

Options: `modern` (default), `classic`

#### 4. Add Application Icon

Inno Setup automatically uses `PasteToFile.ico`.

To use a different icon:
```ini
SetupIconFile=MyIcon.ico
UninstallDisplayIcon={app}\MyIcon.ico
```

#### 5. Change License File

By default uses `LICENSE` file.

To use a different license:
```ini
LicenseFile=LICENSE.txt
```

Or disable license page:
```ini
LicenseFile=
```

### Advanced Customizations

#### Require Administrator Rights Optionally

**Current (requires admin):**
```ini
PrivilegesRequired=admin
```

**Alternative options:**
```ini
PrivilegesRequired=lowest        ; Don't require admin
PrivilegesRequired=poweruser     ; Require PowerUser or higher
```

#### Auto-Update Behavior

**Allow multiple installations:**
```ini
AllowUNCPath=yes
AllowRootDirectory=no
```

#### Compression Settings

**Current (LZMA - best compression):**
```ini
Compression=lzma
SolidCompression=yes
```

**Faster build, larger installer:**
```ini
Compression=zip
SolidCompression=no
```

#### Add Components

**Current [Components]:**
```ini
[Components]
Name: "program"; Description: "Program Files"; Types: full compact custom; Flags: fixed
Name: "integration"; Description: "Windows Explorer Integration"; Types: full; Flags: fixed
Name: "shortcut"; Description: "Start Menu Shortcut"; Types: full compact
```

**To make a component optional:**
- Remove `Flags: fixed`
- Users can uncheck during installation

---

## Distribution Methods

### 1. Direct File Distribution

**Simplest Method:**

```powershell
# Copy installer to shared location
Copy-Item "Installer\PasteToFile-Setup-1.0.0.exe" -Destination "\\server\share\installers\"

# Or to USB/external drive
Copy-Item "Installer\PasteToFile-Setup-1.0.0.exe" -Destination "E:\installers\"
```

**Share with others:**
- Email the `.exe` file directly
- Upload to cloud storage (OneDrive, Google Drive, Dropbox)
- Copy to USB drive

### 2. GitHub Releases

**Steps:**

1. Create release on GitHub:
   ```bash
   cd C:\src\PasteToFile
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

2. Go to: https://github.com/chapas/PasteToFile/releases

3. Click "Draft a new release"

4. Upload `Installer\PasteToFile-Setup-1.0.0.exe`

5. Users can download directly from GitHub

### 3. Website/Blog

**Host on your website:**

```html
<a href="/downloads/PasteToFile-Setup-1.0.0.exe">
  Download PasteToFile Installer (2.15 MB)
</a>
```

**Add metadata:**
- File size: 2.15 MB
- Version: 1.0.0
- Requirements: Windows 7+, .NET 10.0
- License: MIT

### 4. Automated Updates (Advanced)

**Using Update Checker library:**

```csharp
// Check for updates periodically
// Download new installer automatically
// Prompt user to install
```

---

## Troubleshooting

### Build Issues

### Build Issues

#### ❌ Error: "ISCC.exe not found"

```
ERROR: Inno Setup 6 is not installed!
```

**Cause:** Inno Setup compiler is not installed or not in expected location

**Solution:**
1. Install Inno Setup 6:
   - Visit: https://jrsoftware.org/isdl.php
   - Download and run installer
   - Use default installation path
   - Restart your terminal

2. Verify installation:
   ```powershell
   Test-Path "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
   # Should return: True
   ```

3. If installed elsewhere, update build scripts:
   - Find your ISCC.exe location
   - Update `build-installer.ps1` line ~85 with correct path

---

#### ❌ Error: "dotnet command not found"

```
dotnet: The term 'dotnet' is not recognized
```

**Cause:** .NET SDK is not installed or not in PATH

**Solution:**
1. Install .NET 10.0 SDK:
   - Download: https://dotnet.microsoft.com/download/dotnet/10.0
   - Select "SDK" (not Runtime)
   - Run installer
   - Restart terminal

2. Verify:
   ```powershell
   dotnet --version
   # Should show: 10.0.x or higher
   ```

3. Clear NuGet cache if persisting:
   ```powershell
   dotnet nuget locals all --clear
   dotnet restore
   ```

---

#### ❌ Error: "Project file not found"

```
MSBUILD : error MSB1009: Project file does not exist.
```

**Cause:** Script running from wrong directory

**Solution:**
1. Verify you're in project root:
   ```powershell
   cd "C:\src\PasteToFile"
   Test-Path "PasteToFile.sln"  # Must return True
   ```

2. Check all required files exist:
   ```powershell
   Test-Path "PasteToFile.csproj"    # True
   Test-Path "PasteToFile.sln"       # True
   Test-Path "LICENSE"               # True
   Test-Path "README.md"             # True
   ```

---

#### ❌ Error: "Access Denied" during build

```
Access is denied. (Exception from HRESULT: 0x80070005 (E_ACCESSDENIED))
```

**Cause:** Missing administrator rights or file locks

**Solution:**
1. Run PowerShell as Administrator:
   - Press `Win + X`
   - Select "Windows PowerShell (Admin)"

2. Close Visual Studio if open:
   - Unlocks project files
   - Allows clean rebuild

3. Check file permissions:
   ```powershell
   Get-Item "PasteToFile.csproj" | Select-Object Owner
   ```

---

### Installation Issues

#### ❌ Installer won't start

```
Setup.exe - Application Error
The application failed to initialize properly (0xc0000135)
```

**Cause:** .NET 10.0 runtime not installed on user's system

**Solution for Users:**
1. Download .NET 10.0 Desktop Runtime:
   - Go to: https://dotnet.microsoft.com/download/dotnet/10.0
   - Select "Desktop Runtime"
   - Choose x64 (for 64-bit Windows)
   - Install

2. Restart computer

3. Try installer again

**Solution for Developers:**
- Ensure installer prompts for .NET installation (it should automatically)

---

#### ❌ Context menu not appearing

**Cause:** Registry entry not created or Explorer needs refresh

**Solution:**
1. Verify installation completed:
   - Check `C:\Program Files\PasteToFile\PasteToFile.exe` exists

2. Refresh Windows Explorer:
   - Open Task Manager (Ctrl+Shift+Esc)
   - Find "Windows Explorer"
   - Click "Restart"

3. Try registry entry manually:
   ```powershell
   # Check registry
   Get-Item "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file" -ErrorAction SilentlyContinue

   # If not found, run PasteToFile.exe as admin
   & "C:\Program Files\PasteToFile\PasteToFile.exe"
   ```

---

#### ❌ "Administrator rights required" prompt

**Cause:** Installer requires admin rights to modify registry

**Solution for Users:**
1. Right-click installer
2. Select "Run as administrator"
3. Click "Yes" in User Account Control prompt

**Solution for Developers:**
- This is expected; Inno Setup configuration requires it for registry modifications

---

### Uninstallation Issues

#### ❌ Cannot uninstall from Programs and Features

**Solution:**
1. Try "Repair" first (may fix registry)

2. Use Programs and Features:
   - Settings → Apps → Apps & features
   - Find "PasteToFile"
   - Click "Uninstall"

3. Manual uninstall:
   ```powershell
   # Remove registry entries
   Remove-Item "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file" -Force -ErrorAction SilentlyContinue

   # Delete program folder
   Remove-Item "C:\Program Files\PasteToFile" -Recurse -Force -ErrorAction SilentlyContinue
   ```

---

## Advanced Topics

### Version Management Strategy

**Semantic Versioning:** `MAJOR.MINOR.PATCH`

**Example:**
- **1.0.0** - Initial release
- **1.0.1** - Bug fix
- **1.1.0** - New feature
- **2.0.0** - Breaking changes

**To update version:**

1. Update `.csproj`:
   ```xml
   <AssemblyVersion>1.1.0</AssemblyVersion>
   <FileVersion>1.1.0</FileVersion>
   ```

2. Update `.iss`:
   ```ini
   #define MyAppVersion "1.1.0"
   ```

3. Commit and tag:
   ```bash
   git add -A
   git commit -m "Release version 1.1.0"
   git tag -a v1.1.0 -m "Version 1.1.0"
   git push origin main --tags
   ```

4. Rebuild installer:
   ```powershell
   .\build-installer.ps1
   ```

---

### GitHub Actions CI/CD Automation

**Create `.github/workflows/build-installer.yml`:**

```yaml
name: Build Installer

on:
  push:
	tags:
	  - 'v*'

jobs:
  build:
	runs-on: windows-latest
	steps:
	  - uses: actions/checkout@v3

	  - name: Setup .NET
		uses: actions/setup-dotnet@v3
		with:
		  dotnet-version: '10.0.x'

	  - name: Build
		run: dotnet publish -c Release

	  - name: Setup Inno Setup
		run: choco install innosetup -y

	  - name: Create Installer
		run: |
		  & "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" /Q "PasteToFile.iss"

	  - name: Upload to Release
		uses: softprops/action-gh-release@v1
		with:
		  files: Installer/PasteToFile-Setup-*.exe
```

**Benefits:**
- Automatic builds on every release tag
- Installer automatically uploaded to GitHub Releases
- No manual building required
- Version control integration

---

### Creating Silent Installation Scripts

**Create `install-silent.ps1` for deployment teams:**

```powershell
param(
	[string]$InstallerPath = "PasteToFile-Setup-1.0.0.exe",
	[string]$InstallDir = "C:\Program Files\PasteToFile"
)

# Silent installation
& $InstallerPath /SILENT /DIR=$InstallDir

# Wait for completion
Start-Sleep -Seconds 5

# Verify
if (Test-Path "$InstallDir\PasteToFile.exe") {
	Write-Host "Installation successful!" -ForegroundColor Green
} else {
	Write-Host "Installation failed!" -ForegroundColor Red
	exit 1
}
```

**Usage:**
```powershell
.\install-silent.ps1 -InstallerPath "PasteToFile-Setup-1.0.0.exe"
```

---

### Batch Deployment (Enterprise)

**For IT departments deploying to multiple computers:**

```powershell
# Deploy to multiple machines
$computers = @("PC-001", "PC-002", "PC-003")
$installerPath = "\\server\share\installers\PasteToFile-Setup-1.0.0.exe"

foreach ($computer in $computers) {
	Invoke-Command -ComputerName $computer -ScriptBlock {
		& $Using:installerPath /SILENT /DIR="C:\Program Files\PasteToFile"
	}
}

Write-Host "Deployment complete on $($computers.Count) computers"
```

---

### Customizing Post-Installation Behavior

**Edit `[Run]` section in `PasteToFile.iss` to:**

```ini
[Run]
; Run app immediately after install
Filename: "{app}\{#MyAppExeName}"; Description: "Launch PasteToFile"; Flags: nowait postinstall skipifsilent

; Run setup script
Filename: "{app}\setup.bat"; Flags: runhidden

; Open documentation
Filename: "{app}\README.md"; Description: "View README"; Flags: postinstall skipifsilent unchecked
```

---

## FAQ

### Q: What's the installer file size?

**A:** Approximately 2.15 MB
- Self-contained .NET 10 application (~500 KB exe)
- LZMA compression applied
- No external dependencies bundled

---

### Q: Can I distribute the installer freely?

**A:** Yes! The project is MIT licensed
- Redistribute installer as-is
- Modify installer for internal use
- No restrictions

---

### Q: How do I create an auto-update system?

**A:** Use a version checker:

```csharp
// Check for new version
// Compare installed vs available
// Download new installer
// Prompt user to upgrade
// Run installer in background
```

**Popular libraries:**
- AutoUpdate
- Squirrel.Windows
- WinSparkle

---

### Q: Can I build the installer on Mac/Linux?

**A:** Inno Setup only runs on Windows
- Build cross-platform .NET app on any OS
- Use Windows VM or CI/CD for installer
- Or use alternative (NSIS, WiX) on other platforms

---

### Q: What if I need to support older Windows versions?

**A:** Edit `PasteToFile.iss`:

```ini
[Setup]
MinVersion=5.1  ; Windows XP SP3
```

**Note:** Requires .NET 10.0 runtime, which needs Windows 7+

---

### Q: How do I add a Start Menu folder?

**Currently:** Already included

**Customize path in `[Icons]`:**
```ini
Name: "{commonstartmenu}\Utilities\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
```

---

### Q: Can I sign the installer executable?

**A:** Yes, with code signing certificate

```powershell
# After building installer
$cert = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert

Set-AuthenticodeSignature -FilePath "Installer\PasteToFile-Setup-1.0.0.exe" `
						  -Certificate $cert[0]
```

**Benefits:**
- Users trust signed installer
- No Windows SmartScreen warning
- Professional appearance

---

### Q: How do I rollback to an older version?

**Steps:**

1. Keep old installer files:
   ```
   Installer\
   ├── PasteToFile-Setup-1.0.0.exe  (old)
   └── PasteToFile-Setup-1.1.0.exe  (new)
   ```

2. Uninstall current version

3. Run older installer

---

### Q: What's included in the installer?

**Always included:**
- PasteToFile.exe (self-contained)
- README.md (documentation)
- LICENSE (MIT license)
- Uninstaller
- Registry entries
- Start Menu shortcut

**Optional (user choice):**
- Desktop icon
- Any custom scripts

---

## Performance Tips

### Reduce Installer Build Time

```powershell
# Skip previous build cleanup
.\build-installer.ps1 -SkipBuild
```

**Saves ~10-15 seconds**

### Reduce Installer File Size

**In `PasteToFile.iss`:**
```ini
Compression=zip              ; Faster, larger
SolidCompression=no          ; Individual compression per file
```

---

## Security Considerations

### Code Signing

**Prevent Windows SmartScreen warnings:**

1. Obtain code signing certificate ($100-300/year)

2. Sign installer:
   ```powershell
   signtool.exe sign /f "certificate.pfx" /p "password" `
					 /t "http://timestamp.server.com" `
					 "Installer\PasteToFile-Setup-1.0.0.exe"
   ```

### Checksum Verification

**Provide SHA256 checksum for downloads:**

```powershell
Get-FileHash "Installer\PasteToFile-Setup-1.0.0.exe" -Algorithm SHA256
```

**Share on website so users can verify integrity**

---

## Maintenance

### Regular Updates

**Every 3 months:**
- Review for security patches
- Update .NET runtime if needed
- Test on latest Windows versions
- Rebuild installer

### Version Tracking

**Document in `CHANGELOG.md`:**

```markdown
## [1.1.0] - 2026-06-26
### Added
- Improved error handling
- Better logging

### Fixed
- Context menu integration bug #42

### Changed
- Upgraded to .NET 10.0.1

## [1.0.0] - 2026-06-15
### Added
- Initial release
```

---

## Related Resources

- [Inno Setup Documentation](https://jrsoftware.org/isinfo.php)
- [.NET 10.0 Downloads](https://dotnet.microsoft.com/download/dotnet/10.0)
- [Windows Installer Best Practices](https://docs.microsoft.com/windows/win32/msi/windows-installer-portal)
- [GitHub Releases](https://docs.github.com/repositories/releasing-projects-on-github/about-releases)

---

## Support

For issues or questions:
1. Check this guide's troubleshooting section
2. Review [Inno Setup documentation](https://jrsoftware.org/isinfo.php)
3. Check [GitHub Issues](https://github.com/chapas/PasteToFile/issues)
4. Contact support through [GitHub Discussions](https://github.com/chapas/PasteToFile/discussions)

---

**Last Updated:** June 2026  
**Guide Version:** 2.0  
**Status:** Production-Ready ✅
