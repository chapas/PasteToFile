@echo off
REM PasteToFile Build and Installer Script
REM This script builds the application and creates the installer

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   PasteToFile - Installer Builder
echo ========================================
echo.

REM Check if we're in the right directory
if not exist "PasteToFile.sln" (
	echo ERROR: PasteToFile.sln not found in current directory!
	echo Please run this script from the project root directory.
	pause
	exit /b 1
)

REM Step 1: Clean previous builds
echo [1/4] Cleaning previous builds...
if exist "bin" (
	rmdir /s /q "bin" >nul 2>&1
)
if exist "obj" (
	rmdir /s /q "obj" >nul 2>&1
)

REM Step 2: Restore and Build
echo [2/4] Building PasteToFile in Release mode...
dotnet restore
if errorlevel 1 (
	echo ERROR: Failed to restore NuGet packages!
	pause
	exit /b 1
)

dotnet build -c Release
if errorlevel 1 (
	echo ERROR: Failed to build project!
	pause
	exit /b 1
)

REM Step 3: Publish
echo [3/4] Publishing application...
dotnet publish -c Release
if errorlevel 1 (
	echo ERROR: Failed to publish project!
	pause
	exit /b 1
)

REM Step 4: Create Installer
echo [4/4] Creating Windows installer...

REM Check if Inno Setup is installed
if exist "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" (
	echo Found Inno Setup 6
	set INNO_COMPILER="C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
) else if exist "C:\Program Files\Inno Setup 6\ISCC.exe" (
	echo Found Inno Setup 6
	set INNO_COMPILER="C:\Program Files\Inno Setup 6\ISCC.exe"
) else (
	echo.
	echo ERROR: Inno Setup 6 is not installed!
	echo.
	echo Please download and install Inno Setup from:
	echo https://jrsoftware.org/isdl.php
	echo.
	echo After installation, run this script again.
	pause
	exit /b 1
)

REM Create Installer directory if it doesn't exist
if not exist "Installer" (
	mkdir "Installer"
)

REM Compile the installer
echo Compiling installer script...
%INNO_COMPILER% /Q "PasteToFile.iss"
if errorlevel 1 (
	echo ERROR: Failed to create installer!
	pause
	exit /b 1
)

echo.
echo ========================================
echo   SUCCESS!
echo ========================================
echo.
echo Installer created at: Installer\PasteToFile-Setup-1.0.0.exe
echo.
echo You can now share or run the installer!
echo.
pause
