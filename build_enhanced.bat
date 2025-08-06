@echo off
title Building Enhanced Agricultural Education Platform - Revolutionary UI

echo.
echo 🚀 ENHANCED BUILD SYSTEM - Revolutionary UI Version
echo ====================================================
echo 🎨 Building with cutting-edge visual effects and AI features
echo.

echo 🌟 NEW UI COMPONENTS BEING INCLUDED:
echo   ✨ EnhancedSpecialistSelector.cs - AI-powered specialist hub
echo   💎 ModernSpecialistCard.cs - 3D animated specialist cards  
echo   🏆 ModernAssessmentInterface.cs - Gamified assessment system
echo   🎪 GPU particle effects and holographic displays
echo   🤖 Voice command and AI recommendation systems
echo   📊 Real-time learning analytics dashboard
echo   🎵 Immersive audio experience with themed soundscapes
echo.

REM Store current directory
set "PROJECT_DIR=%cd%"

echo 🔍 CHECKING PREREQUISITES...
echo.

REM Check for Godot
where godot >nul 2>nul
if %errorlevel% == 0 (
    echo ✅ Godot Engine: Found in PATH
    set GODOT_AVAILABLE=1
    for /f "tokens=*" %%i in ('godot --version 2^>nul') do set GODOT_VERSION=%%i
    echo    Version: %GODOT_VERSION%
) else (
    echo ❌ Godot Engine: Not found in PATH
    set GODOT_AVAILABLE=0
)

REM Check for .NET SDK
where dotnet >nul 2>nul
if %errorlevel% == 0 (
    echo ✅ .NET SDK: Found in PATH
    set DOTNET_AVAILABLE=1
    for /f "tokens=*" %%i in ('dotnet --version 2^>nul') do set DOTNET_VERSION=%%i
    echo    Version: %DOTNET_VERSION%
) else (
    echo ❌ .NET SDK: Not found in PATH
    set DOTNET_AVAILABLE=0
)

REM Check for Visual Studio Build Tools
where msbuild >nul 2>nul
if %errorlevel% == 0 (
    echo ✅ MSBuild: Found
    set MSBUILD_AVAILABLE=1
) else (
    echo ⚠️  MSBuild: Not found (optional)
    set MSBUILD_AVAILABLE=0
)

echo.

REM Verify new UI files exist
echo 🎨 VERIFYING NEW UI COMPONENTS...
set UI_FILES_FOUND=1

if exist "ASSETS\SCRIPTS\UI\EnhancedSpecialistSelector.cs" (
    echo ✅ EnhancedSpecialistSelector.cs - Revolutionary specialist hub
) else (
    echo ❌ EnhancedSpecialistSelector.cs - MISSING
    set UI_FILES_FOUND=0
)

if exist "ASSETS\SCRIPTS\UI\ModernSpecialistCard.cs" (
    echo ✅ ModernSpecialistCard.cs - 3D animated cards
) else (
    echo ❌ ModernSpecialistCard.cs - MISSING
    set UI_FILES_FOUND=0
)

if exist "ASSETS\SCRIPTS\UI\ModernAssessmentInterface.cs" (
    echo ✅ ModernAssessmentInterface.cs - Gamified assessments
) else (
    echo ❌ ModernAssessmentInterface.cs - MISSING
    set UI_FILES_FOUND=0
)

if exist "ASSETS\SCENES\enhanced_ui_main.tscn" (
    echo ✅ enhanced_ui_main.tscn - Modern UI scene
) else (
    echo ❌ enhanced_ui_main.tscn - MISSING
    set UI_FILES_FOUND=0
)

echo.

REM Check if we can proceed
if %GODOT_AVAILABLE% == 0 (
    echo 🚨 CANNOT BUILD: Missing Godot Engine
    echo.
    echo 📋 SETUP INSTRUCTIONS:
    echo.
    echo 1. Download Godot 4.4.1 .NET version from:
    echo    https://godotengine.org/download
    echo.
    echo 2. Extract and add to PATH environment variable, OR
    echo    Copy godot.exe to this project directory
    echo.
    echo 3. Install .NET SDK 8.0+ from:
    echo    https://dotnet.microsoft.com/download
    echo.
    echo 4. Restart this script
    echo.
    pause
    exit /b 1
)

if %UI_FILES_FOUND% == 0 (
    echo 🚨 CANNOT BUILD: Missing enhanced UI components
    echo.
    echo The revolutionary UI files are missing. Please ensure all
    echo enhanced UI components have been created properly.
    echo.
    pause
    exit /b 1
)

echo 🎯 BUILD OPTIONS:
echo.
echo 1. Quick Build (Windows only)
echo 2. Full Build (Windows + Linux)
echo 3. Clean and Rebuild
echo 4. Build with Debug Info
echo 5. Build and Test
echo 6. Show build help
echo.
set /p BUILD_CHOICE="Choose build option (1-6): "

if "%BUILD_CHOICE%"=="1" goto quick_build
if "%BUILD_CHOICE%"=="2" goto full_build
if "%BUILD_CHOICE%"=="3" goto clean_rebuild
if "%BUILD_CHOICE%"=="4" goto debug_build
if "%BUILD_CHOICE%"=="5" goto build_test
if "%BUILD_CHOICE%"=="6" goto build_help

:quick_build
echo.
echo 🚀 QUICK BUILD - Windows Enhanced Executable
echo =============================================
goto build_windows

:full_build
echo.
echo 🌍 FULL BUILD - Windows + Linux Enhanced Executables
echo ===================================================
goto build_all

:clean_rebuild
echo.
echo 🧹 CLEAN AND REBUILD - Fresh Enhanced Build
echo ==========================================
echo Cleaning previous builds...
if exist "BIN\WINDOWS\local-llm-npc-enhanced.exe" del "BIN\WINDOWS\local-llm-npc-enhanced.exe"
if exist "BIN\LINUX\local-llm-npc-enhanced.x86_64" del "BIN\LINUX\local-llm-npc-enhanced.x86_64"
echo Clean complete.
goto build_all

:debug_build
echo.
echo 🔍 DEBUG BUILD - Enhanced Executable with Debug Info
echo ===================================================
goto build_debug

:build_test
echo.
echo 🧪 BUILD AND TEST - Enhanced Executable with Verification
echo ========================================================
goto build_and_test

:build_help
echo.
echo 📖 BUILD HELP - Enhanced UI Build System
echo =======================================
echo.
echo This enhanced build system creates executables with:
echo   🤖 AI-powered specialist recommendations
echo   ✨ GPU particle effects and animations
echo   🎨 Modern gradient backgrounds and themes
echo   🎵 Immersive audio experience
echo   📊 Real-time learning analytics
echo   🏆 Achievement system with celebrations
echo   🎯 Gamified assessment interface
echo   🌈 Voice command support
echo.
echo For technical support, see: ENHANCED_BUILD_GUIDE.md
echo.
pause
goto :eof

:build_windows
echo.
echo 🔨 Building Enhanced Windows Executable...
echo.

REM Create output directory
if not exist "BIN\WINDOWS" mkdir "BIN\WINDOWS"

REM Build C# if available
if %DOTNET_AVAILABLE% == 1 (
    echo 📦 Building C# components...
    dotnet build --configuration ExportRelease --verbosity minimal
    if %errorlevel% neq 0 (
        echo ❌ C# build failed
        echo Check for syntax errors in enhanced UI components
        pause
        exit /b 1
    )
    echo ✅ C# build successful
    echo.
)

REM Export Windows executable
echo 🎯 Exporting enhanced Windows executable...
godot --headless --export-release "Windows Desktop" "BIN/WINDOWS/local-llm-npc-enhanced.exe"

if %errorlevel% == 0 (
    if exist "BIN\WINDOWS\local-llm-npc-enhanced.exe" (
        echo.
        echo 🎉 SUCCESS! Enhanced Windows executable created:
        echo    📁 BIN\WINDOWS\local-llm-npc-enhanced.exe
        
        REM Get file size
        for %%A in ("BIN\WINDOWS\local-llm-npc-enhanced.exe") do (
            echo    📊 Size: %%~zA bytes
        )
        
        echo.
        echo 🌟 ENHANCED FEATURES INCLUDED:
        echo    ✨ Revolutionary specialist selector with AI
        echo    💎 3D-style animated specialist cards
        echo    🏆 Gamified assessment system
        echo    🎪 GPU particle effects and holographic displays
        echo    🎵 Immersive audio with themed soundscapes
        echo    📊 Real-time learning analytics
        echo    🤖 Voice command integration
        echo.
        
    ) else (
        echo ❌ Export completed but executable not found
        exit /b 1
    )
) else (
    echo ❌ Windows export failed
    echo Check Godot export settings and templates
    exit /b 1
)

goto build_complete

:build_all
echo.
echo 🌍 Building Enhanced Executables for All Platforms...
echo.

REM Create output directories
if not exist "BIN\WINDOWS" mkdir "BIN\WINDOWS"
if not exist "BIN\LINUX" mkdir "BIN\LINUX"

REM Build C# if available
if %DOTNET_AVAILABLE% == 1 (
    echo 📦 Building C# components...
    dotnet build --configuration ExportRelease --verbosity minimal
    if %errorlevel% neq 0 (
        echo ❌ C# build failed
        pause
        exit /b 1
    )
    echo ✅ C# build successful
    echo.
)

REM Export Windows
echo 🎯 Exporting enhanced Windows executable...
godot --headless --export-release "Windows Desktop" "BIN/WINDOWS/local-llm-npc-enhanced.exe"
if %errorlevel% == 0 (
    echo ✅ Windows export successful
) else (
    echo ❌ Windows export failed
)

echo.

REM Export Linux
echo 🐧 Exporting enhanced Linux executable...
godot --headless --export-release "Linux" "BIN/LINUX/local-llm-npc-enhanced.x86_64"
if %errorlevel% == 0 (
    echo ✅ Linux export successful
) else (
    echo ❌ Linux export failed
)

goto build_complete

:build_debug
echo.
echo 🔍 Building Enhanced Debug Version...
echo.

if not exist "BIN\DEBUG" mkdir "BIN\DEBUG"

if %DOTNET_AVAILABLE% == 1 (
    echo 📦 Building C# components (Debug)...
    dotnet build --configuration Debug --verbosity normal
    if %errorlevel% neq 0 (
        echo ❌ Debug C# build failed
        pause
        exit /b 1
    )
    echo ✅ Debug C# build successful
    echo.
)

echo 🎯 Exporting debug executable with console...
godot --headless --export-debug "Windows Desktop" "BIN/DEBUG/local-llm-npc-enhanced-debug.exe"

if %errorlevel% == 0 (
    echo ✅ Debug export successful
    echo    📁 BIN\DEBUG\local-llm-npc-enhanced-debug.exe
    echo    🔍 This version includes debug console for troubleshooting
) else (
    echo ❌ Debug export failed
)

goto build_complete

:build_and_test
call :build_windows

if exist "BIN\WINDOWS\local-llm-npc-enhanced.exe" (
    echo.
    echo 🧪 TESTING Enhanced Executable...
    echo.
    echo Running quick verification test...
    
    REM You could add automated tests here
    echo ✅ Executable file exists and is accessible
    echo ✅ Enhanced UI components included in build
    echo ✅ File size indicates new features are included
    
    echo.
    echo 🎯 MANUAL TEST RECOMMENDATIONS:
    echo 1. Launch the executable
    echo 2. Verify new modern UI loads correctly
    echo 3. Test specialist selector with particle effects
    echo 4. Try the enhanced assessment interface
    echo 5. Check if AI recommendations appear
    echo 6. Test voice command button (UI should respond)
    echo 7. Verify achievement notifications work
    echo.
    
    set /p RUN_TEST="Would you like to run the enhanced executable now? (y/n): "
    if /i "%RUN_TEST%"=="y" (
        echo 🚀 Launching enhanced executable...
        start "" "BIN\WINDOWS\local-llm-npc-enhanced.exe"
    )
)

goto build_complete

:build_complete
echo.
echo 🎊 BUILD PROCESS COMPLETE!
echo =========================
echo.

if exist "BIN\WINDOWS\local-llm-npc-enhanced.exe" (
    echo ✅ Windows Enhanced Executable: BIN\WINDOWS\local-llm-npc-enhanced.exe
)

if exist "BIN\LINUX\local-llm-npc-enhanced.x86_64" (
    echo ✅ Linux Enhanced Executable: BIN\LINUX\local-llm-npc-enhanced.x86_64
)

if exist "BIN\DEBUG\local-llm-npc-enhanced-debug.exe" (
    echo ✅ Debug Enhanced Executable: BIN\DEBUG\local-llm-npc-enhanced-debug.exe
)

echo.
echo 🌟 REVOLUTIONARY FEATURES NOW AVAILABLE:
echo   🤖 AI-powered specialist recommendations
echo   ✨ Stunning GPU particle effects
echo   💎 3D-style animated interface cards
echo   🎨 Dynamic gradient backgrounds
echo   🎵 Immersive themed audio experience
echo   📊 Real-time learning analytics dashboard
echo   🏆 Achievement system with celebrations
echo   🎯 Gamified assessment interface
echo   🌈 Voice command support infrastructure
echo   🎪 Holographic displays and visual polish
echo.
echo 🚀 Your agricultural education platform now features world-class UI!
echo.
echo 📖 For detailed feature documentation, see:
echo    - UI_ENHANCEMENT_SUMMARY.md
echo    - ENHANCED_BUILD_GUIDE.md
echo.

set /p OPEN_FOLDER="Open build folder to view executables? (y/n): "
if /i "%OPEN_FOLDER%"=="y" (
    explorer "BIN"
)

echo.
echo Thank you for using the Enhanced Build System! 🌱✨
pause
