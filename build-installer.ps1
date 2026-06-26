# PasteToFile Build and Installer Script (PowerShell)
# This script builds the application and creates a professional Windows installer

param(
	[switch]$SkipBuild = $false,
	[switch]$SkipInstaller = $false,
	[switch]$OpenOutput = $true
)

# Colors for console output
$Color_Info = 'Cyan'
$Color_Success = 'Green'
$Color_Error = 'Red'
$Color_Warning = 'Yellow'

function Write-Header {
	param([string]$Message)
	Write-Host ""
	Write-Host "========================================" -ForegroundColor $Color_Info
	Write-Host "  $Message" -ForegroundColor $Color_Info
	Write-Host "========================================" -ForegroundColor $Color_Info
	Write-Host ""
}

function Write-Step {
	param([string]$Message, [int]$Step, [int]$Total)
	Write-Host "[$Step/$Total] $Message" -ForegroundColor $Color_Info
}

function Write-Success {
	param([string]$Message)
	Write-Host "✓ $Message" -ForegroundColor $Color_Success
}

function Write-Error-Custom {
	param([string]$Message)
	Write-Host "✗ $Message" -ForegroundColor $Color_Error
}

function Write-Warning-Custom {
	param([string]$Message)
	Write-Host "⚠ $Message" -ForegroundColor $Color_Warning
}

# Check if we're in the right directory
if (-not (Test-Path "PasteToFile.sln")) {
	Write-Header "PasteToFile - Build Error"
	Write-Error-Custom "PasteToFile.sln not found in current directory!"
	Write-Host "Please run this script from the project root directory."
	exit 1
}

Write-Header "PasteToFile - Installer Builder"

# Step 1: Clean previous builds (unless skipping build)
if (-not $SkipBuild) {
	Write-Step "Cleaning previous builds" 1 3

	if (Test-Path "bin") {
		Remove-Item -Path "bin" -Recurse -Force -ErrorAction SilentlyContinue
		Write-Success "Cleaned bin directory"
	}

	if (Test-Path "obj") {
		Remove-Item -Path "obj" -Recurse -Force -ErrorAction SilentlyContinue
		Write-Success "Cleaned obj directory"
	}

	# Step 2: Restore and Build
	Write-Step "Building PasteToFile in Release mode" 2 3

	try {
		Write-Host "  Restoring NuGet packages..." -ForegroundColor Gray
		dotnet restore 2>&1 | Out-Null
		if ($LASTEXITCODE -ne 0) {
			throw "Failed to restore NuGet packages"
		}
		Write-Success "NuGet packages restored"

		Write-Host "  Compiling project..." -ForegroundColor Gray
		dotnet build -c Release --no-restore 2>&1 | Out-Null
		if ($LASTEXITCODE -ne 0) {
			throw "Failed to build project"
		}
		Write-Success "Project built successfully"

		Write-Host "  Publishing application..." -ForegroundColor Gray
		dotnet publish -c Release --no-build 2>&1 | Out-Null
		if ($LASTEXITCODE -ne 0) {
			throw "Failed to publish project"
		}
		Write-Success "Application published"
	}
	catch {
		Write-Error-Custom "Build failed: $_"
		exit 1
	}
} else {
	Write-Success "Skipping build (using existing binaries)"
}

# Step 3: Create Installer
if (-not $SkipInstaller) {
	Write-Step "Creating Windows installer" 3 3

	# Check if Inno Setup is installed
	$InnoSetupPaths = @(
		"C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
		"C:\Program Files\Inno Setup 6\ISCC.exe",
		"C:\Program Files (x86)\Inno Setup 5\ISCC.exe",
		"C:\Program Files\Inno Setup 5\ISCC.exe"
	)

	$InnoCompiler = $null
	foreach ($Path in $InnoSetupPaths) {
		if (Test-Path $Path) {
			$InnoCompiler = $Path
			Write-Success "Found Inno Setup at: $Path"
			break
		}
	}

	if (-not $InnoCompiler) {
		Write-Error-Custom "Inno Setup 5 or 6 is not installed!"
		Write-Host ""
		Write-Host "Please download and install Inno Setup from:" -ForegroundColor Yellow
		Write-Host "https://jrsoftware.org/isdl.php" -ForegroundColor Cyan
		Write-Host ""
		Write-Host "After installation, run this script again." -ForegroundColor Yellow
		Write-Host ""

		if ($OpenOutput) {
			Write-Host "Opening download page..." -ForegroundColor Gray
			Start-Process "https://jrsoftware.org/isdl.php"
		}
		exit 1
	}

	# Create Installer directory if it doesn't exist
	if (-not (Test-Path "Installer")) {
		New-Item -ItemType Directory -Path "Installer" | Out-Null
		Write-Success "Created Installer directory"
	}

	# Compile the installer
	Write-Host "  Compiling installer script..." -ForegroundColor Gray
	& $InnoCompiler /Q "PasteToFile.iss" 2>&1 | Out-Null

	if ($LASTEXITCODE -eq 0) {
		Write-Success "Installer created successfully"

		# Find the created installer file
		$InstallerFile = Get-ChildItem -Path "Installer" -Filter "PasteToFile-Setup-*.exe" | 
						Sort-Object -Property LastWriteTime -Descending | 
						Select-Object -First 1

		if ($InstallerFile) {
			Write-Header "SUCCESS!"
			Write-Host "Installer created at:" -ForegroundColor $Color_Success
			Write-Host "  $($InstallerFile.FullName)" -ForegroundColor Cyan
			Write-Host ""
			Write-Host "File size: $([math]::Round($InstallerFile.Length / 1MB, 2)) MB" -ForegroundColor Gray
			Write-Host ""

			if ($OpenOutput) {
				Write-Host "Opening installer folder..." -ForegroundColor Gray
				Invoke-Item -Path "Installer"
			}
		}
	} else {
		Write-Error-Custom "Failed to create installer"
		exit 1
	}
} else {
	Write-Success "Skipping installer creation"
}

Write-Host ""
Write-Host "You can now share or run the installer!" -ForegroundColor $Color_Success
Write-Host ""
