@echo off
echo 🚀 PACKAGE RELEASE - Agricultural Education Platform
echo ============================================

set "RELEASE_DIR=RELEASES"
set "VERSION=v1.0.0"
set "PACKAGE_NAME=local-llm-npc-agricultural-platform-%VERSION%"

echo 📁 Creating release directory...
if not exist "%RELEASE_DIR%" mkdir "%RELEASE_DIR%"
if not exist "%RELEASE_DIR%\%VERSION%" mkdir "%RELEASE_DIR%\%VERSION%"

echo 🔨 Building the project...
dotnet build --configuration ExportRelease
if %ERRORLEVEL% neq 0 (
    echo ❌ Build failed!
    pause
    exit /b 1
)

echo 📦 Exporting Windows executable...
godot --headless --export-release "Windows Desktop" "%RELEASE_DIR%\%VERSION%\%PACKAGE_NAME%-windows.exe"
if %ERRORLEVEL% neq 0 (
    echo ❌ Export failed!
    pause
    exit /b 1
)

echo 📦 Creating release package...
cd "%RELEASE_DIR%\%VERSION%"

:: Create a proper release folder structure
if not exist "%PACKAGE_NAME%-windows" mkdir "%PACKAGE_NAME%-windows"
move "%PACKAGE_NAME%-windows.exe" "%PACKAGE_NAME%-windows\"
copy "..\..\README.md" "%PACKAGE_NAME%-windows\"
copy "..\..\LICENSE" "%PACKAGE_NAME%-windows\"

:: Create ZIP package
powershell Compress-Archive -Path "%PACKAGE_NAME%-windows" -DestinationPath "%PACKAGE_NAME%-windows.zip" -Force

cd ..\..

echo ✅ Release package created successfully!
echo 📍 Location: %RELEASE_DIR%\%VERSION%\%PACKAGE_NAME%-windows.zip
echo 💡 Upload this package to GitHub Releases instead of committing large files to Git

pause
