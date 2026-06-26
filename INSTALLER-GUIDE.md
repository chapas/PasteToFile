# PasteToFile Installer Setup Guide

This document explains how to create the professional Windows installer for PasteToFile.

## What You'll Get

A professional Windows installer (`.exe` file) that:
- ✅ Automatically installs .NET 10.0 runtime if needed
- ✅ Sets up the context menu integration
- ✅ Creates Start Menu shortcuts
- ✅ Adds desktop icon (optional)
- ✅ Includes uninstall support
- ✅ Handles all registry operations automatically
- ✅ Looks professional with modern UI

---

## Prerequisites

### 1. Install Inno Setup

**Inno Setup** is required to compile the installer script into an `.exe` file.

**Download:**
- Visit: https://jrsoftware.org/isdl.php
- Download "Inno Setup 6" (or latest version)
- Run the installer and follow the prompts
- Accept default installation location

**Verify Installation:**
```powershell
Test-Path "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
# Should return True
```

### 2. Ensure .NET 10.0 SDK is Installed

The application needs to be published before creating the installer.

```powershell
dotnet --version
# Should show .NET 10.0 or later
```

---

## Creating the Installer

### Option 1: PowerShell Script (Recommended)

This is the easiest and most reliable method.

**Steps:**

1. Open PowerShell as Administrator
   - Press `Win + X`, select "Windows PowerShell (Admin)"

2. Navigate to the project:
   ```powershell
   cd "C:\src\PasteToFile"
   ```

3. Run the build script:
   ```powershell
   powershell -ExecutionPolicy Bypass -File build-installer.ps1
   ```

4. The script will:
   - Clean previous builds
   - Restore NuGet packages
   - Build the project in Release mode
   - Publish the application
   - Compile the installer using Inno Setup
   - Open the output folder

5. Your installer is ready at: `Installer\PasteToFile-Setup-1.0.0.exe`

---

### Option 2: Batch Script

Traditional batch file method (simpler, less colorful output).

**Steps:**

1. Open Command Prompt (cmd.exe) as Administrator
2. Navigate to the project:
   ```cmd
   cd C:\src\PasteToFile
   ```
3. Run the batch script:
   ```cmd
   build-installer.bat
   ```
4. Follow the prompts
5. Your installer is ready at: `Installer\PasteToFile-Setup-1.0.0.exe`

---

### Option 3: Manual Build

If you prefer to build step-by-step:

**Step 1 - Clean previous builds:**
```powershell
cd "C:\src\PasteToFile"
Remove-Item -Path "bin", "obj" -Recurse -Force -ErrorAction SilentlyContinue
```

**Step 2 - Build and publish:**
```powershell
dotnet restore
dotnet build -c Release
dotnet publish -c Release
```

**Step 3 - Compile installer:**
```powershell
& "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" /Q "PasteToFile.iss"
```

**Step 4 - Check output:**
```powershell
Get-ChildItem "Installer" -Filter "*.exe"
```

---

## Customizing the Installer

The installer is configured in `PasteToFile.iss` (Inno Setup script).

### Common Customizations

#### 1. Change Installation Directory
In `PasteToFile.iss`, find this line:
```ini
DefaultDirName={pf}\{#MyAppName}
```

Change `{pf}` to:
- `{pf}` = Program Files (default)
- `{localappdata}` = User's AppData\Local folder
- `{sd}` = System drive root (C:\)

#### 2. Add or Remove Components
In `PasteToFile.iss`, modify the `[Components]` section:
```ini
[Components]
Name: "program"; Description: "Program Files"; Types: full compact custom; Flags: fixed
Name: "integration"; Description: "Windows Explorer Integration"; Types: full; Flags: fixed
Name: "shortcut"; Description: "Start Menu Shortcut"; Types: full compact
```

#### 3. Change Setup Messages
Customize welcome messages in the `[Code]` section or use language files.

---

## Distributing the Installer

### File Information

Once created, your installer file:
- **Name:** `PasteToFile-Setup-1.0.0.exe`
- **Size:** ~50-100 MB (includes .NET runtime)
- **Requirements:** Windows 7 or later, Administrator privileges for installation

### Sharing

1. **Direct Download:**
   - Upload `Installer\PasteToFile-Setup-1.0.0.exe` to your server/website

2. **GitHub Releases:**
   - Upload to GitHub Releases for easy distribution

3. **Email:**
   - Attach the `.exe` file directly (users can run double-click to install)

### User Installation Instructions

Users just need to:
1. Download `PasteToFile-Setup-1.0.0.exe`
2. Double-click the file
3. Click "Install"
4. Follow the wizard prompts
5. Done! The context menu is ready to use.

---

## Troubleshooting

### Issue: "ISCC.exe not found"

**Solution:**
1. Verify Inno Setup is installed: `C:\Program Files (x86)\Inno Setup 6\ISCC.exe` should exist
2. If not found, download and install from: https://jrsoftware.org/isdl.php
3. Try a different installation location and run the build script again

### Issue: Build fails with "Project file not found"

**Solution:**
1. Ensure you're in the project root directory: `cd C:\src\PasteToFile`
2. Verify `PasteToFile.csproj` exists in current directory
3. Run: `ls PasteToFile.csproj` to confirm

### Issue: "The system cannot find the path specified"

**Solution:**
1. Close and reopen PowerShell/Command Prompt
2. Make sure PowerShell execution policy allows scripts:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
3. Try running with full paths:
   ```powershell
   powershell -ExecutionPolicy Bypass -File "C:\src\PasteToFile\build-installer.ps1"
   ```

### Issue: "Administrator rights required" error

**Solution:**
1. Right-click PowerShell/Command Prompt
2. Select "Run as administrator"
3. Run the build script again

---

## Advanced Options

### PowerShell Script Switches

The `build-installer.ps1` script supports several options:

```powershell
# Skip building, only create installer
.\build-installer.ps1 -SkipBuild

# Create installer only (no build)
.\build-installer.ps1 -SkipBuild -SkipInstaller:$false

# Build but don't open output folder
.\build-installer.ps1 -OpenOutput:$false

# Skip build and don't open folder
.\build-installer.ps1 -SkipBuild -OpenOutput:$false
```

### Batch Build for Multiple Versions

Create `batch-build.ps1`:
```powershell
$versions = @("1.0.0", "1.0.1", "1.1.0")
foreach ($version in $versions) {
	# Update version in .csproj
	# Rebuild installer
	& ".\build-installer.ps1" -SkipBuild:$false
}
```

---

## Installer Structure

The installer will:

1. **Extract files to:** `C:\Program Files\PasteToFile`
   - PasteToFile.exe
   - All required .NET libraries
   - README.md
   - LICENSE

2. **Create shortcuts:**
   - Start Menu: `Start → All Programs → PasteToFile → PasteToFile`
   - Optional Desktop Icon

3. **Register in Windows:**
   - Add to Control Panel → Programs and Features
   - Uninstall support

4. **Setup Context Menu:**
   - Register Windows Explorer right-click entry
   - Path: `HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file`

---

## Version Updates

When you release a new version:

1. Update version in `PasteToFile.csproj`:
   ```xml
   <AssemblyVersion>1.1.0</AssemblyVersion>
   <FileVersion>1.1.0</FileVersion>
   ```

2. Update version in `PasteToFile.iss`:
   ```ini
   #define MyAppVersion "1.1.0"
   ```

3. Rebuild the installer:
   ```powershell
   .\build-installer.ps1
   ```

4. New installer file: `Installer\PasteToFile-Setup-1.1.0.exe`

---

## See Also

- [Inno Setup Documentation](https://jrsoftware.org/isinfo.php)
- [PasteToFile README](README.md)
- [.NET 10.0 Downloads](https://dotnet.microsoft.com/download/dotnet/10.0)
