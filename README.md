# Paste to File - Windows Installation Guide

## Overview

**Paste to File** is a Windows utility that integrates with Windows Explorer's context menu, allowing you to quickly paste clipboard contents directly into the current directory.

### Features
- ✅ Right-click context menu integration in Windows Explorer
- ✅ Paste images from clipboard as JPEG files
- ✅ Paste text from clipboard as TXT files
- ✅ Automatic file naming with collision detection
- ✅ Works from any folder location
- ✅ Lightweight and fast

---

## System Requirements

- **Operating System:** Windows 7 or later (Windows 10/11 recommended)
- **.NET Runtime:** .NET 10.0 Runtime or .NET 10.0 Desktop Runtime
- **Architecture:** x64 (64-bit)
- **Administrator Rights:** Required for initial setup (to modify Windows Registry)

---

## Installation Methods

### Method 1: Quick Installation (Recommended)

#### Step 1: Build the Application
```powershell
cd C:\src\PasteToFile
dotnet publish -c Release
```

#### Step 2: Run Setup as Administrator
1. Open **PowerShell** as Administrator
   - Right-click the PowerShell icon and select "Run as administrator"
2. Navigate to the project directory:
   ```powershell
   cd C:\src\PasteToFile
   ```
3. Run the published executable:
   ```powershell
   .\bin\Release\net10.0-windows7.0\publish\PasteToFile.exe
   ```

#### Step 3: Verify Installation
- Open Windows Explorer
- Right-click in an empty area of any folder
- You should see a **"Paste to file"** option in the context menu

---

### Method 2: Manual Installation (Advanced Users)

If you prefer to manually control the installation:

#### Step 1: Build and Publish
```powershell
cd C:\src\PasteToFile
dotnet publish -c Release -o "C:\Program Files\PasteToFile"
```

#### Step 2: Register Context Menu Manually
1. Open **Registry Editor** (`regedit.exe`) as Administrator
2. Navigate to:
   ```
   HKEY_CLASSES_ROOT\Directory\Background\shell
   ```
3. Create a new key named `Paste to file`
4. Set the default value to `Paste to file`
5. Create a subkey named `command`
6. In the `command` key, set the default value to:
   ```
   "C:\Program Files\PasteToFile\PasteToFile.exe" "%V"
   ```
7. Close Registry Editor
8. Right-click on the desktop and select "Refresh" to apply changes

---

### Method 3: Automated Installation Script

Save this as `install.ps1` and run as Administrator:

```powershell
# Paste to File Installation Script
param(
	[string]$InstallPath = "$env:ProgramFiles\PasteToFile"
)

Write-Host "Installing Paste to File..." -ForegroundColor Green

# Step 1: Build and Publish
Write-Host "Building application..."
cd $PSScriptRoot
dotnet publish -c Release -o $InstallPath

# Step 2: Create Registry entries
Write-Host "Registering context menu..."
$regPath = "HKCU:\Software\Classes\Directory\Background\shell\Paste to file"
$commandPath = "$regPath\command"

# Create shell entry
New-Item -Path $regPath -Force | Out-Null
New-ItemProperty -Path $regPath -Name "(Default)" -Value "Paste to file" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $regPath -Name "Position" -Value "0" -PropertyType String -Force | Out-Null

# Create command entry
New-Item -Path $commandPath -Force | Out-Null
New-ItemProperty -Path $commandPath -Name "(Default)" -Value "`"$InstallPath\PasteToFile.exe`" `"%V`"" -PropertyType String -Force | Out-Null

Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "You can now right-click in any folder and select 'Paste to file'" -ForegroundColor Cyan
```

Run with:
```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

---

## Usage

1. **Copy content to clipboard:**
   - Copy an image (Ctrl+C) or text (Ctrl+C)

2. **Navigate to target folder:**
   - Open Windows Explorer and go to the folder where you want to save

3. **Use context menu:**
   - Right-click in empty space of the folder
   - Select **"Paste to file"**

4. **Automatic file creation:**
   - Image: Saved as `pastedfile_001.jpg` (auto-numbered if duplicates exist)
   - Text: Saved as `pastedfile_001.txt` (auto-numbered if duplicates exist)

---

## Uninstallation

### Quick Uninstall

1. Open **Registry Editor** as Administrator
2. Navigate to:
   ```
   HKEY_CLASSES_ROOT\Directory\Background\shell
   ```
3. Right-click the `Paste to file` folder and select **Delete**
4. Optional: Delete the installation folder

### Registry Key Locations

If you installed using different methods, the registry keys may be in:
- `HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file` (System-wide)
- `HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\Paste to file` (User-only)

---

## Troubleshooting

### Issue: "Paste to file" option doesn't appear
**Solution:**
1. Ensure you ran the setup as Administrator
2. Restart Windows Explorer:
   - Open Task Manager (Ctrl+Shift+Esc)
   - Find "Windows Explorer"
   - Click "Restart"
3. Verify the registry keys exist:
   - Open Registry Editor and check both paths listed above

### Issue: "Cannot find .NET 10.0 Runtime"
**Solution:**
1. Download and install .NET 10.0 Desktop Runtime:
   - Visit https://dotnet.microsoft.com/download/dotnet/10.0
   - Choose "Desktop Runtime"
   - Follow the installer instructions
2. Restart your computer
3. Try running PasteToFile.exe again

### Issue: Access Denied when running setup
**Solution:**
1. Right-click PowerShell or Command Prompt
2. Select "Run as administrator"
3. Re-run the setup command

### Issue: Files are not being created
**Possible causes:**
1. The target folder may not have write permissions
   - Right-click folder → Properties → Security → Edit → Allow "Full Control" for your user
2. Clipboard may not contain compatible content
   - Only JPEG images and plain text are supported
3. Temp folder permissions issue
   - Check that `C:\Users\[YourUsername]\AppData\Local\Temp` is writable

---

## Development & Building

### Prerequisites
- .NET 10.0 SDK or later
- Visual Studio 2022 or Visual Studio Code (optional)

### Build from Source
```powershell
# Clone or extract the repository
cd C:\src\PasteToFile

# Restore dependencies
dotnet restore

# Build in Debug mode
dotnet build

# Build for Release
dotnet publish -c Release

# Run tests (if available)
dotnet test
```

### Project Structure
```
PasteToFile/
├── Program.cs              # Main application and setup logic
├── PasteToFile.csproj      # Project configuration (.NET 10.0)
├── PasteToFile.ico         # Application icon
├── README.md               # This file
└── bin/Release/            # Compiled binaries (generated)
```

---

## Technical Details

### Registry Integration
The utility modifies the Windows Registry to add a context menu entry:
- **Location:** `HKEY_CLASSES_ROOT\Directory\Background\shell\Paste to file`
- **Command:** Executes `PasteToFile.exe "%V"` where `%V` is the folder path
- **Scope:** System-wide access from any folder

### Supported File Types
| Input Type | Output Format | Example |
|-----------|---------------|---------|
| Image (clipboard) | JPEG (.jpg) | `pastedfile_001.jpg` |
| Text (clipboard) | Plain Text (.txt) | `pastedfile_001.txt` |

### Environment
- **Framework:** .NET 10.0 (Windows Desktop)
- **Architecture:** x64
- **Platform:** Windows 7+ (64-bit)

---

## License

This project is licensed under the **MIT License**. See LICENSE file for details.

---

## Support & Feedback

For issues, feature requests, or feedback:
1. Check this README's Troubleshooting section
2. Review the GitHub Issues page (if applicable)
3. Contact the development team

---

## Version History

### v1.0.0 (Current)
- Initial release
- Context menu integration for Windows Explorer
- Support for images and text
- Automatic file numbering
- .NET 10.0 compatibility

---

## FAQ

**Q: Is this safe to use?**  
A: Yes, this utility only reads from your clipboard and writes to your chosen folder. It requires administrator rights only for initial setup to modify the Registry.

**Q: Can I use this on Windows 11?**  
A: Yes, fully compatible with Windows 11.

**Q: What if the filename already exists?**  
A: The utility automatically appends a number to avoid overwriting. Example: `pastedfile_001.jpg`, `pastedfile_002.jpg`, etc.

**Q: Can I customize the output filename?**  
A: Currently, filenames are auto-generated with numbering. Custom naming is a planned feature.

**Q: Does this work on network drives?**  
A: Yes, as long as you have write permissions to the network folder.

**Q: Can I uninstall without removing the executable?**  
A: Yes, simply delete the Registry entries. The executable file can remain on disk.

---

**Last Updated:** January 2025  
**Tested On:** Windows 11 22H2, .NET 10.0
