# PasteToFile v1.0.1 - Optimization & Startup Feature

## Changes in This Release

### ✨ New Features
- **Windows Startup Integration** 🚀
  - Optional checkbox during installation: "Start PasteToFile automatically when Windows starts"
  - Runs silently in the background, ready to use with clipboard
  - Automatically removed from startup when uninstalled
  - Uses Windows Registry (HKCU\Software\Microsoft\Windows\CurrentVersion\Run)

### 🔧 Optimizations
- **Ultra Compression** - Inno Setup now uses `lzma2/ultra` compression
- **Solid Compression** - Better compression ratio for smaller installer
- **Lean Build Configuration** - Optimized release build without unnecessary symbols

### 📊 File Sizes

| Component | Size |
|-----------|------|
| **Executable (PasteToFile.exe)** | 488 KB |
| **Installer (PasteToFile-Setup-1.0.0.exe)** | 2.15 MB |

### 🔍 Technical Details

#### Installer Configuration (`PasteToFile.iss`)
- Compression: `lzma2/ultra` (ultra compression mode)
- Solid compression enabled for maximum efficiency
- Admin privileges required (registry integration)
- Framework-dependent deployment (.NET 10 runtime required)

#### Project Configuration (`PasteToFile.csproj`)
- Target: `.NET 10` with Windows 7+ support
- Single-file publish enabled
- Framework-dependent (no runtime bundled)
- Win-x64 runtime identifier
- Debug symbols stripped for release build

#### Startup Integration
The installer registers the application with Windows startup if the user selects it:

```
Registry Key: HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
Registry Value: PasteToFile
Value Data: C:\Program Files\PasteToFile\PasteToFile.exe
```

**Uninstall Behavior**: The registry entry is automatically removed when uninstalling.

---

## Installation Features

### During Installation
1. **Standard Installation** - Install to Program Files with context menu integration
2. **Optional Startup** - Checkbox to add PasteToFile to Windows startup
3. **Optional Desktop Icon** - Checkbox to create desktop shortcut
4. **Start Menu Shortcut** - Always created for easy access

### First Run Experience
- Registers Windows Explorer context menu: "Paste to file"
- Displays welcome message with usage instructions
- Applies system registry modifications (admin mode)

### Windows Startup Behavior (if enabled)
- Automatically launches when Windows boots
- Runs silently without showing window
- Registers context menu on startup
- Stays running in the background

---

## Usage

### Installation
```bash
# Run the installer
PasteToFile-Setup-1.0.0.exe
```

### Using "Paste to file"
1. Copy an image or text to clipboard
2. Right-click in any folder (empty space)
3. Select "Paste to file"
4. File is automatically created and saved

### Uninstallation
- Control Panel > Programs > Uninstall a Program > PasteToFile
- Or: Program Files\PasteToFile\Uninstall.exe
- Registry entries automatically cleaned up

---

## What You Get

✅ Professional Windows installer  
✅ One-click installation  
✅ Windows Explorer integration  
✅ Optional Windows startup  
✅ Easy uninstallation  
✅ Automatic registry cleanup  
✅ No installation bloat  

---

## System Requirements

- **OS**: Windows 7 or later
- **.NET Runtime**: .NET 10 (installed automatically if missing)
- **Privileges**: Administrator rights required for installation and registry integration
- **Disk Space**: ~50 MB for .NET 10 runtime (if not already installed) + 2 MB for the app

---

## Notes

- The installer runs with admin privileges to register the context menu in HKCU
- Each user can optionally add PasteToFile to their startup
- The startup entry runs at user login, not system startup
- Multiple users can have separate startup preferences

---

**Version**: 1.0.1  
**Last Updated**: 2026  
**Status**: Production Ready
