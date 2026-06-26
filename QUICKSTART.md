# Quick Start - Build Installer in 5 Minutes

## TL;DR - Just Want to Build It?

### Prerequisites (Do Once)
1. Download Inno Setup 6: https://jrsoftware.org/isdl.php
   - Install with default options
2. Have .NET 10.0 SDK installed (you already have it)

### Build the Installer (5 Minutes)

**Windows PowerShell (Recommended):**
```powershell
cd "C:\src\PasteToFile"
powershell -ExecutionPolicy Bypass -File build-installer.ps1
```

**Or Command Prompt:**
```cmd
cd C:\src\PasteToFile
build-installer.bat
```

### Done!
Your installer is at: `C:\src\PasteToFile\Installer\PasteToFile-Setup-1.0.0.exe`

Double-click it to install!

---

## What Happens When You Build?

1. ✅ Cleans previous builds
2. ✅ Restores NuGet packages
3. ✅ Compiles in Release mode
4. ✅ Publishes to bin\Release\net10.0-windows7.0\publish
5. ✅ Creates professional Windows installer
6. ✅ Opens the output folder

## What Happens When Users Install?

1. ✅ Checks for .NET 10.0 runtime (installs if missing)
2. ✅ Extracts files to Program Files
3. ✅ Configures Windows Explorer context menu
4. ✅ Creates Start Menu shortcut
5. ✅ Ready to use!

## File Structure After Build

```
C:\src\PasteToFile\
├── build-installer.ps1          # PowerShell build script
├── build-installer.bat           # Batch build script
├── PasteToFile.iss              # Inno Setup configuration
├── Installer\                   # Output folder
│   └── PasteToFile-Setup-1.0.0.exe  # ← Your installer!
└── bin\Release\net10.0-windows7.0\publish\  # Compiled app
	├── PasteToFile.exe
	├── *.dll
	└── ...
```

---

## Common Tasks

### Update Version Number
Edit `PasteToFile.iss` and change:
```ini
#define MyAppVersion "1.0.0"  ← Change this
```

Then rebuild.

### Distribute Installer
- Just share: `Installer\PasteToFile-Setup-1.0.0.exe`
- Users double-click to install
- No additional steps needed!

### Troubleshoot
See: [INSTALLER-GUIDE.md](INSTALLER-GUIDE.md)

---

**That's it! Your professional Windows installer is ready.** 🚀
