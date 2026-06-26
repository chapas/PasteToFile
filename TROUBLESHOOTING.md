# PasteToFile - Troubleshooting & Support Guide

Complete reference for resolving common issues with building, installing, and using PasteToFile.

**Last Updated:** June 2026  
**Version:** 1.0  

---

## Table of Contents

1. [Build Process Troubleshooting](#build-process-troubleshooting)
2. [Installation Issues](#installation-issues)
3. [Runtime Issues](#runtime-issues)
4. [Context Menu Problems](#context-menu-problems)
5. [Uninstallation Issues](#uninstallation-issues)
6. [System Registry Issues](#system-registry-issues)
7. [Performance & Optimization](#performance--optimization)
8. [Getting Help](#getting-help)

---

## Build Process Troubleshooting

### Build Fails - "Project file not found"

**Error Message:**
```
MSBuild : error MSB1009: Project file does not exist.
```

**Root Causes:**
1. Wrong working directory
2. PasteToFile.csproj is missing or moved
3. File permissions issue

**Solutions:**

✓ **Step 1:** Verify working directory
```powershell
cd "C:\src\PasteToFile"
Get-Location  # Confirm you're in the right place

# Verify files exist
ls PasteToFile.csproj
ls PasteToFile.sln
```

✓ **Step 2:** Check file integrity
```powershell
# Restore from git if corrupted
git restore PasteToFile.csproj
git restore PasteToFile.sln
```

✓ **Step 3:** Check file permissions
```powershell
Get-Item "PasteToFile.csproj" | Select-Object FullName, Owner, @{
	Name="Readable"
	Expression={$_.GetAccessControl().Access}
}
```

---

### Build Fails - ".NET SDK not found"

**Error Messages:**
```
dotnet: The term 'dotnet' is not recognized as the name of a cmdlet
error NETSDK1003: The target platform identifier 'windows7.0' is not valid
```

**Root Causes:**
1. .NET 10.0 SDK not installed
2. .NET SDK not in system PATH
3. Wrong .NET version installed
4. Terminal not restarted after .NET installation

**Solutions:**

✓ **Verify .NET Installation:**
```powershell
# Check installed versions
dotnet --list-sdks

# Should show:
# 10.0.x [C:\Program Files\dotnet\sdk\10.0.x]
```

✓ **If Not Installed:**
1. Download from: https://dotnet.microsoft.com/download/dotnet/10.0
2. Choose **SDK** (not Runtime)
3. Run installer
4. **Restart PowerShell/cmd completely**
5. Retry

✓ **Add .NET to PATH (Manual):**
```powershell
# If PATH missing (rare)
$env:Path += ";C:\Program Files\dotnet"

# Verify
dotnet --version
```

✓ **Clear NuGet Cache (if still failing):**
```powershell
dotnet nuget locals all --clear
dotnet restore
```

---

### Build Fails - "Inno Setup not found"

**Error Message:**
```
ERROR: Inno Setup 6 is not installed!
Please download and install from: https://jrsoftware.org/isdl.php
```

**Root Causes:**
1. Inno Setup not installed
2. Installed to non-standard location
3. Installation corrupted
4. ISCC.exe missing from installation

**Solutions:**

✓ **Verify Installation:**
```powershell
# Check if ISCC.exe exists
Test-Path "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
# Should return: True

# List Inno Setup versions
Get-ChildItem "C:\Program Files*" -Filter "Inno Setup*" -Directory
```

✓ **Reinstall Inno Setup:**
1. Go to: https://jrsoftware.org/isdl.php
2. Download **Inno Setup 6** (or latest)
3. Uninstall existing version first:
   - Control Panel → Programs and Features
   - Find "Inno Setup"
   - Click Uninstall
4. Run new installer
5. Use **default installation path** when prompted
6. Restart PowerShell

✓ **Update Build Script for Custom Location:**
```powershell
# Open build-installer.ps1
# Find line: $InnoSetupPaths = @(
# Add your custom path:
$InnoSetupPaths = @(
	"C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
	"C:\Program Files\Inno Setup 6\ISCC.exe",
	"C:\Custom\Path\Inno Setup\ISCC.exe"  # Add your path here
)
```

---

### Build Fails - "PowerShell execution policy"

**Error Message:**
```
File C:\src\PasteToFile\build-installer.ps1 cannot be loaded because running scripts 
is disabled on this system.
```

**Root Cause:** PowerShell execution policy blocks script execution

**Solutions:**

✓ **Temporary (for this session):**
```powershell
powershell -ExecutionPolicy Bypass -File build-installer.ps1
```

✓ **Permanent (recommended):**
```powershell
# Check current policy
Get-ExecutionPolicy -List

# Set to RemoteSigned (secure)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Verify
Get-ExecutionPolicy
```

---

### Build Fails - "Access Denied" or "File in use"

**Error Messages:**
```
Access is denied. (Exception from HRESULT: 0x80070005)
The process cannot access the file because it is being used by another process
```

**Root Causes:**
1. Visual Studio has files locked
2. Previous build process still running
3. Antivirus scanning files during build
4. Not running as Administrator

**Solutions:**

✓ **Step 1:** Close Visual Studio
```powershell
# Check for stuck processes
Get-Process | Where-Object {$_.Name -like "*Visual*"}

# Kill if necessary
Stop-Process -Name "devenv" -Force
```

✓ **Step 2:** Run as Administrator
```powershell
# Close current PowerShell
# Right-click PowerShell icon
# Select "Run as administrator"
# Navigate to project and retry
```

✓ **Step 3:** Clean build directory
```powershell
# Full clean
Remove-Item "bin", "obj" -Recurse -Force -ErrorAction SilentlyContinue
git clean -fd  # Remove untracked files

# Restore and rebuild
dotnet restore
dotnet build -c Release
```

✓ **Step 4:** Check antivirus
- Temporarily disable Windows Defender/antivirus during build
- Add `C:\src\PasteToFile` to antivirus exclusions

---

## Installation Issues

### Installer Won't Start - "0xc0000135" Error

**Error Message:**
```
Setup.exe - Application Error
The application failed to initialize properly (0xc0000135)
```

**Root Cause:** .NET 10.0 runtime not installed on target system

**Solutions for End Users:**

✓ **Install .NET 10.0 Desktop Runtime:**
1. Go to: https://dotnet.microsoft.com/download/dotnet/10.0
2. Download **Desktop Runtime**
3. Choose **x64** (for 64-bit Windows)
4. Run installer
5. Restart computer
6. Run PasteToFile installer again

✓ **Verify Installation:**
```powershell
# Check .NET version
dotnet --version

# Check Desktop Runtime
dotnet --list-runtimes
# Should show: Microsoft.WindowsDesktop.App 10.0.x
```

---

### Installer Prompts for Administrator But Already Admin

**Behavior:** Installer requires admin elevation even though running as admin

**This is expected!** 

Registry modifications for context menu require full admin privileges. The UAC prompt is normal.

**For Silent Deployment:**
```powershell
# Run without prompts (for IT deployment)
& "PasteToFile-Setup-1.0.0.exe" /SILENT /DIR="C:\Program Files\PasteToFile"
```

---

### Installer Progress Hangs

**Behavior:** Installer appears frozen at specific step

**Solutions:**

✓ **Wait longer** (first 30 seconds are typical)
- .NET runtime detection can take time
- File extraction is compressed

✓ **Check Task Manager:**
```powershell
# See if ISCC processes running
Get-Process | Where-Object {$_.Name -like "*setup*" -or $_.Name -like "*iscc*"}
```

✓ **If truly hung (5+ minutes):**
- Press `Ctrl+Alt+Delete` → Task Manager
- Find "Setup" or installer process
- Click "End Task"
- Try again or contact support

---

## Runtime Issues

### "Paste to File" Context Menu Missing

**Symptom:** Right-click in folder doesn't show "Paste to file" option

**Root Causes:**
1. Installation didn't complete
2. Registry entry not created
3. Windows Explorer needs refresh
4. User doesn't have permission to modify registry

**Solutions:**

✓ **Step 1:** Verify Installation
```powershell
# Check if exe exists
Test-Path "C:\Program Files\PasteToFile\PasteToFile.exe"
# Should return: True

# Check file is executable
(Get-Item "C:\Program Files\PasteToFile\PasteToFile.exe").VersionInfo
```

✓ **Step 2:** Refresh Windows Explorer
```powershell
# Restart Windows Explorer
taskkill /F /IM explorer.exe
Start-Sleep -Seconds 2
explorer.exe
```

✓ **Step 3:** Check Registry Entry
```powershell
# Check if registry key exists
Get-Item "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file" -ErrorAction SilentlyContinue

# If not found, manually create:
$regPath = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file"
New-Item -Path $regPath -Force
New-Item -Path "$regPath\command" -Force
Set-ItemProperty -Path $regPath -Name "(Default)" -Value "Paste to file"
Set-ItemProperty -Path "$regPath\command" -Name "(Default)" -Value '"C:\Program Files\PasteToFile\PasteToFile.exe" "%V"'
```

✓ **Step 4:** Re-run Setup
```powershell
# Run as administrator
& "C:\Program Files\PasteToFile\PasteToFile.exe"
```

---

### Application Won't Start

**Symptoms:**
- Double-clicking .exe does nothing
- Application closes immediately
- No error message

**Solutions:**

✓ **Run from Command Line:**
```powershell
cd "C:\Program Files\PasteToFile"
& ".\PasteToFile.exe"

# Check for error messages in output
```

✓ **Check Event Viewer for errors:**
```powershell
# View recent application errors
Get-EventLog -LogName Application -Source .NET -Newest 5
```

✓ **Verify .NET Runtime:**
```powershell
dotnet --version
dotnet --list-runtimes
```

---

## Context Menu Problems

### "Paste to File" Executes but Does Nothing

**Behavior:** Menu item exists, clicking does nothing, no file created

**Root Causes:**
1. Clipboard is empty
2. Clipboard contains unsupported type
3. No write permission to target directory
4. Application error in execution

**Solutions:**

✓ **Verify Clipboard Content:**
```powershell
# Check clipboard
[Windows.Forms.Clipboard]::GetText()

# Should contain text or image data
```

✓ **Test with Known Content:**
1. Copy text: `Hello World`
2. Right-click any folder
3. Select "Paste to file"
4. Check if file created

✓ **Check Directory Permissions:**
```powershell
# Test write permissions
$testFile = "C:\Users\[Username]\Desktop\test.txt"
"test" | Out-File $testFile -ErrorAction SilentlyContinue
Remove-Item $testFile -ErrorAction SilentlyContinue

# If error, you lack write permissions
```

✓ **Enable Debug Logging:**
Edit `Program.cs` to enable verbose output:
```csharp
private static readonly bool Verbose = true;  // Change to true
```

Recompile and test.

---

### "Paste to File" Appears Multiple Times

**Behavior:** Context menu shows "Paste to file" several times

**Root Cause:** Registry entry exists in multiple locations

**Solution:**
```powershell
# Remove all instances
Remove-Item "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file" -Force -ErrorAction SilentlyContinue
Remove-Item "Registry::HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\Paste to file" -Force -ErrorAction SilentlyContinue

# Re-run setup to create single instance
& "C:\Program Files\PasteToFile\PasteToFile.exe"

# Restart Explorer
taskkill /F /IM explorer.exe
Start-Sleep -Seconds 2
explorer.exe
```

---

## Uninstallation Issues

### Cannot Uninstall from Programs and Features

**Behavior:**
- Uninstall button grayed out
- Uninstall fails with error
- Application still appears after uninstall

**Solutions:**

✓ **Step 1:** Try "Repair" First
- Settings → Apps → Apps & features
- Find PasteToFile
- Click "Repair"
- Then try "Uninstall"

✓ **Step 2:** Manual Uninstall
```powershell
# Remove from Add/Remove Programs
Get-WmiObject Win32_Product | Where-Object {$_.Name -like "*PasteToFile*"} | Remove-WmiObject

# Delete program folder
Remove-Item "C:\Program Files\PasteToFile" -Recurse -Force -ErrorAction SilentlyContinue
```

✓ **Step 3:** Clean Registry
```powershell
# Remove registry entries
Remove-Item "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file" -Recurse -Force
Remove-Item "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PasteToFile*" -Recurse -Force
```

---

## System Registry Issues

### Registry Entry Shows Wrong Path

**Behavior:** Registry points to old installation directory after moving PasteToFile

**Solution:**
```powershell
# Check current registry entry
$regPath = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file\command"
Get-ItemProperty -Path $regPath | Select-Object -ExpandProperty "(Default)"

# If wrong path, update it
Set-ItemProperty -Path $regPath -Name "(Default)" -Value '"C:\Program Files\PasteToFile\PasteToFile.exe" "%V"'

# Verify
Get-ItemProperty -Path $regPath | Select-Object -ExpandProperty "(Default)"
```

---

### Registry Corruption

**Symptoms:**
- Registry entries not readable
- "Access Denied" errors when modifying registry
- Settings don't persist

**Solutions:**

✓ **Export Registry Before Changes:**
```powershell
# Backup registry
reg export "HKCR\Directory\Background\shell\Paste to file" "backup.reg"
```

✓ **Restore from Backup:**
```powershell
# If corrupted, restore
reg import "backup.reg"
```

✓ **Full Registry Scan:**
```powershell
# Run Windows System File Checker
sfc /scannow  # Requires admin
```

---

## Performance & Optimization

### Installer Build Takes Very Long

**Typical build time:** 1-2 minutes

**If taking longer:**

✓ **Check system resources:**
```powershell
# Check CPU and memory usage
Get-Process | Sort-Object -Property WorkingSet -Descending | Select-Object -First 5

# Check disk speed
# Should show >50 MB/s sequential write
```

✓ **Skip unnecessary steps:**
```powershell
# Skip build, only create installer (faster)
.\build-installer.ps1 -SkipBuild

# Skip opening folder after build
.\build-installer.ps1 -OpenOutput:$false
```

✓ **Disable antivirus scanning temporarily:**
- Antivirus real-time scanning slows builds significantly
- Add `C:\src\PasteToFile` to exclusions

---

### Application Slow on Old Hardware

**Behavior:** "Paste to file" takes >5 seconds to execute

**Solutions:**

✓ **Baseline Performance:**
- Modern machine: <1 second
- Older machine (5+ years): 2-5 seconds
- This is normal for .NET startup time

✓ **Optimize:**
- Ensure no antivirus scanning on target directory
- Close other applications
- Increase available RAM if possible

---

## Getting Help

### Information to Collect

When reporting issues, gather:

```powershell
# System information
[System.Environment]::OSVersion

# .NET information
dotnet --version
dotnet --list-runtimes
dotnet --list-sdks

# Inno Setup version
& "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" /? | Select-String "version"

# PasteToFile installation
Get-Item "C:\Program Files\PasteToFile\PasteToFile.exe" | Select-Object VersionInfo

# Registry entry
Get-Item "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file\command" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "(Default)"

# Error logs
Get-EventLog -LogName Application -Source .NET -Newest 10 -ErrorAction SilentlyContinue | Export-Csv "errors.csv"
```

### Where to Report Issues

1. **GitHub Issues:** https://github.com/chapas/PasteToFile/issues
   - Check existing issues first
   - Include system info from above
   - Describe steps to reproduce

2. **GitHub Discussions:** https://github.com/chapas/PasteToFile/discussions
   - For general questions
   - Feature requests
   - Usage help

3. **Documentation:** 
   - See [README.md](README.md) for overview
   - See [INSTALLER-GUIDE.md](INSTALLER-GUIDE.md) for setup
   - See this file for troubleshooting

---

## Common Command Reference

**Quick diagnostics:**

```powershell
# System check
dotnet --version
Get-ExecutionPolicy
Test-Path "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"

# Verify installation
Get-Item "C:\Program Files\PasteToFile\PasteToFile.exe" -ErrorAction SilentlyContinue
Get-Item "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file" -ErrorAction SilentlyContinue

# Logs
Get-EventLog -LogName Application -Newest 20

# Performance
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5
```

---

## Version History

**v1.0** - June 2026
- Initial troubleshooting guide
- Comprehensive error solutions
- Best practices documented

---

**Document Version:** 1.0  
**Last Updated:** June 2026  
**Status:** Complete ✅
