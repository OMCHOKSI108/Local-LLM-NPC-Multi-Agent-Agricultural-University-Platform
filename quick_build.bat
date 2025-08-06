@echo off
echo 🚀 QUICK BUILD - Basic Agricultural Platform
echo ===========================================

echo 📦 Building basic version...
dotnet build --configuration ExportRelease --verbosity minimal

if %errorlevel% neq 0 (
    echo ❌ Build failed
    echo 💡 Trying Debug configuration...
    dotnet build --configuration Debug --verbosity minimal
    if %errorlevel% neq 0 (
        echo ❌ Debug build also failed
        pause
        exit /b 1
    )
    set BUILD_CONFIG=Debug
) else (
    set BUILD_CONFIG=ExportRelease
)

echo ✅ C# build successful with %BUILD_CONFIG% configuration

echo 🎮 Exporting Godot project...
if not exist "BIN\WINDOWS" mkdir "BIN\WINDOWS"

echo 📤 Exporting Windows executable...
godot --headless --export-release "Windows Desktop" "BIN\WINDOWS\local-llm-npc-enhanced.exe"

if exist "BIN\WINDOWS\local-llm-npc-enhanced.exe" (
    echo ✅ Windows build complete!
    echo 📍 Location: BIN\WINDOWS\local-llm-npc-enhanced.exe
) else (
    echo ❌ Windows export failed
)

echo.
echo 🎉 BUILD SUMMARY
echo ===============
echo C# Configuration: %BUILD_CONFIG%
if exist "BIN\WINDOWS\local-llm-npc-enhanced.exe" (
    echo Windows Build: ✅ SUCCESS
) else (
    echo Windows Build: ❌ FAILED
)

pause
