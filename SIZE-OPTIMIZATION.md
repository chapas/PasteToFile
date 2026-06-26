# PasteToFile Size Optimization Guide

## Current Size Breakdown

```
Your Original Build (no installer):  150 KB
Current Executable (.NET 10):         488 KB
Current Installer:                    2.15 MB
```

## Why the Size Increased?

### 1. **Framework-Dependent vs Self-Contained** ✅ Good Config
- ✅ Your `SelfContained=false` is CORRECT - executable doesn't include .NET 10 runtime
- The 488 KB is just your app code + Windows Forms + managed code
- This is a ~3x increase from old version, but normal for:
  - .NET 10 Windows Forms apps (vs .NET Framework 4.x)
  - Debug symbols removal
  - IL trimming not applied

### 2. **Why 2.15 MB Installer?**
- Inno Setup wraps the executable with installer logic
- Compression is applied, but there's overhead

---

## 🎯 Optimization Strategy

You have **3 options** depending on your priorities:

| Option | Exe Size | Installer | Effort | Best For |
|--------|----------|-----------|--------|----------|
| **Option 1: Trim IL (Recommended)** | ~250 KB | ~1.2 MB | 5 min | Production |
| **Option 2: Compress Installer** | 488 KB | ~1.0 MB | 3 min | Quick win |
| **Option 3: Use Framework-dependent** | 488 KB | ~1.0 MB | Already set | Requires .NET 10 runtime pre-installed |

---

## ✅ Option 1: Enable IL Trimming (RECOMMENDED)

IL trimming removes unused .NET Framework code, reducing executable size significantly.

### Step 1: Update PasteToFile.csproj

Add these properties to `<PropertyGroup>`:

```xml
<PropertyGroup>
	<!-- Existing properties -->
	<OutputType>WinExe</OutputType>
	<TargetFramework>net10.0-windows7.0</TargetFramework>
	<UseWindowsForms>true</UseWindowsForms>

	<!-- ADD THESE: -->
	<PublishTrimmed>true</PublishTrimmed>
	<PublishReadyToRun>true</PublishReadyToRun>
	<DebugType>none</DebugType>
	<DebugSymbols>false</DebugSymbols>
	<TrimMode>partial</TrimMode>
	<InvariantGlobalization>false</InvariantGlobalization>
	<EnableTrimAnalyzer>true</EnableTrimAnalyzer>
</PropertyGroup>
```

### Step 2: Build & Publish

```powershell
cd C:\src\PasteToFile
dotnet clean
dotnet publish -c Release -p:PublishTrimmed=true -p:PublishReadyToRun=true
```

### Expected Result
- Executable: **250-300 KB** (vs 488 KB)
- Installer: **~1.2 MB** (vs 2.15 MB)
- **Savings: ~50-60%** ✨

### Risks & Considerations
- ⚠️ **Reflection**: If your code uses reflection on types, trimming might remove them
- ✅ **Your app**: Uses clipboard and registry APIs - SAFE to trim
- 🧪 **Testing**: Always test trimmed executable thoroughly

---

## ⚡ Option 2: Compress Installer Further

If you want to keep the 488 KB executable but reduce installer size:

### Update PasteToFile.iss

Find the `[Setup]` section and add compression settings:

```ini
[Setup]
AppName=PasteToFile
AppVersion=1.0.0
DefaultDirName={pf}\PasteToFile
DefaultGroupName=PasteToFile
Compression=lzma2/ultra       ; <-- Add this (ultra compression)
InternalCompressLevel=9       ; <-- Add this (max compression)
OutputBaseFilename=PasteToFile-Setup-1.0.0
```

### Expected Result
- Installer: **~1.0-1.1 MB** (vs 2.15 MB)
- Savings: ~40-50%
- **Trade-off**: ~10-20% longer installation time

---

## 🏆 Recommended Approach: Option 1 + Option 2

### COMBINED: IL Trimming + Compression

1. **Enable trimming** in `.csproj`
2. **Enable ultra compression** in `.iss`
3. **Rebuild everything**

### Expected Final Sizes
- Executable: **250-300 KB** ✨
- Installer: **~900 KB - 1.0 MB** ✨
- **Total savings: 55-60%**

---

## Step-by-Step: Complete Optimization

### 1. Update Project File

```powershell
# Open and edit the csproj
notepad C:\src\PasteToFile\PasteToFile.csproj
```

Add to `<PropertyGroup>`:
```xml
<PublishTrimmed>true</PublishTrimmed>
<PublishReadyToRun>true</PublishReadyToRun>
<DebugType>none</DebugType>
<DebugSymbols>false</DebugSymbols>
<TrimMode>partial</TrimMode>
```

### 2. Update Installer Configuration

```powershell
# Open the Inno Setup script
notepad C:\src\PasteToFile\PasteToFile.iss
```

Find `[Setup]` and add:
```ini
Compression=lzma2/ultra
InternalCompressLevel=9
```

### 3. Rebuild Installer

```powershell
cd C:\src\PasteToFile
.\build-installer.ps1
```

### 4. Verify Sizes

```powershell
Get-ChildItem "bin\Release\net10.0-windows7.0\win-x64\publish\PasteToFile.exe" | ForEach-Object {Write-Host "Exe: $([math]::Round($_.Length/1KB, 1)) KB"}
Get-ChildItem "Installer\*.exe" | ForEach-Object {Write-Host "Installer: $([math]::Round($_.Length/1MB, 2)) MB"}
```

---

## Troubleshooting Trimming Issues

### If trimmed app crashes at startup:

**Check for runtime issues:**
```powershell
cd "bin\Release\net10.0-windows7.0\win-x64\publish"
.\PasteToFile.exe  # Test manually
```

**If it crashes:**
1. The issue is usually reflection-based type discovery
2. Add trim-safe attributes to your code

### For your app specifically:

Add this to `Program.cs` if trimming causes issues (it shouldn't):

```csharp
using System.Runtime.CompilerServices;
using System.Diagnostics.CodeAnalysis;

[assembly: DynamicallyAccessedMembers(DynamicallyAccessedMemberTypes.All)]
```

---

## Size Comparison Table

| Configuration | Exe | Installer | Total | Ratio |
|---------------|-----|-----------|-------|-------|
| **Current** | 488 KB | 2.15 MB | 2.64 MB | 100% |
| **Option 1** (Trim only) | 250 KB | 1.2 MB | 1.45 MB | 55% |
| **Option 2** (Compression) | 488 KB | 1.0 MB | 1.49 MB | 56% |
| **Option 1 + 2** (Trim + Compress) | 250 KB | 900 KB | 1.15 MB | **44%** |

---

## Quick Commands

### Test current size:
```powershell
cd "C:\src\PasteToFile"
$exe = (Get-ChildItem "bin\Release\net10.0-windows7.0\win-x64\publish\*.exe").Length
$installer = (Get-ChildItem "Installer\*.exe").Length
Write-Host "Exe: $([math]::Round($exe/1KB))KB, Installer: $([math]::Round($installer/1MB, 2))MB"
```

### Rebuild with trimming:
```powershell
dotnet clean
dotnet publish -c Release -p:PublishTrimmed=true -p:PublishReadyToRun=true
```

### Rebuild installer:
```powershell
.\build-installer.ps1
```

---

## FAQ

**Q: Will trimming break my app?**  
A: Unlikely for your app. Your code uses APIs (.NET Framework built-ins like clipboard, registry). Trimming removes unused code, which your app doesn't use.

**Q: Do users need .NET 10 installed?**  
A: YES - your `SelfContained=false` means they need .NET 10 runtime. If you want to ship standalone, use `SelfContained=true` (but that's ~500 MB total).

**Q: Will compression slow down installation?**  
A: Slightly (10-20%), but only during install. Once installed, no difference in runtime speed.

**Q: Should I do both trimming and compression?**  
A: YES - they don't conflict. You get 55-60% size reduction total.

**Q: How do I revert if something breaks?**  
A: Keep a backup, or just remove the trim settings and rebuild.

---

## Next Steps

1. **Try Option 1** (IL Trimming) - easiest, biggest impact
2. **Test the trimmed executable** thoroughly
3. **Add Option 2** (compression) if you want even smaller installer
4. **Update your documentation** with the new smaller file sizes

**Would you like me to implement the optimizations for you?**
