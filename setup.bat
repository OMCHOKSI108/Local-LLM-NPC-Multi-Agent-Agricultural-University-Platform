@echo off
REM Local LLM NPC - Windows Setup Script
REM Created by Om Choksi

title Local LLM NPC Agricultural University Platform Setup

echo.
echo 🚀 Local LLM NPC Agricultural University Platform Setup
echo =======================================================
echo.

REM Function to check if command exists
where ollama >nul 2>nul
if %errorlevel% == 0 (
    echo ✅ Ollama: Installed
    set OLLAMA_INSTALLED=1
) else (
    echo ❌ Ollama: Not installed
    set OLLAMA_INSTALLED=0
)

where godot >nul 2>nul
if %errorlevel% == 0 (
    echo ✅ Godot: Installed
    set GODOT_INSTALLED=1
) else (
    echo ❌ Godot: Not installed
    set GODOT_INSTALLED=0
)

where dotnet >nul 2>nul
if %errorlevel% == 0 (
    echo ✅ .NET SDK: Installed
    set DOTNET_INSTALLED=1
) else (
    echo ❌ .NET SDK: Not installed
    set DOTNET_INSTALLED=0
)

echo.
echo 🛠️ Setup Options:
echo 1. Install prerequisites (manual download links)
echo 2. Setup AI models
echo 3. Build project
echo 4. Run project (executable)
echo 5. Run project (Godot editor)
echo 6. Create quick start guide
echo 7. Show demo video script
echo 8. Full setup assistance
echo.

set /p choice="Choose an option (1-8): "

if "%choice%"=="1" goto install_prereqs
if "%choice%"=="2" goto setup_models
if "%choice%"=="3" goto build_project
if "%choice%"=="4" goto run_executable
if "%choice%"=="5" goto run_godot
if "%choice%"=="6" goto create_guide
if "%choice%"=="7" goto show_demo_script
if "%choice%"=="8" goto full_setup
goto invalid_choice

:install_prereqs
echo.
echo 📥 Installation Links:
echo.
echo 1. Ollama: https://ollama.ai/download/windows
echo    - Download and install the Windows version
echo    - After installation, restart this script
echo.
echo 2. Godot 4.4.1 (Mono/C#): https://godotengine.org/download/archive/4.4.1/
echo    - Download "Godot Engine 4.4.1 (Mono/C#)" 
echo    - Extract and add to PATH or remember location
echo.
echo 3. .NET 8.0 SDK: https://dotnet.microsoft.com/download/dotnet/8.0
echo    - Download and install the SDK (not just runtime)
echo.
pause
goto menu

:setup_models
echo.
echo 🤖 Setting up AI models...
if %OLLAMA_INSTALLED%==0 (
    echo ❌ Ollama not installed. Please install Ollama first.
    goto install_prereqs
)

echo Starting Ollama service...
start /B ollama serve
timeout /t 5 /nobreak >nul

echo.
echo 📥 Downloading AI models (this may take 10-15 minutes)...
echo.
echo Downloading Gemma 2B (faster, lighter model)...
ollama pull gemma2:2b

echo.
echo Downloading Gemma 9B (better quality model)...
ollama pull gemma2:9b

echo.
echo ✅ AI models installed successfully!
ollama list
echo.
pause
goto menu

:build_project
echo.
echo 🔨 Building the project...
if %DOTNET_INSTALLED%==0 (
    echo ❌ .NET SDK not installed. Please install .NET 8.0 SDK first.
    goto install_prereqs
)

echo Restoring dependencies...
dotnet restore

echo Building project...
dotnet build --configuration Release

if %errorlevel% == 0 (
    echo ✅ Project built successfully!
) else (
    echo ❌ Build failed. Check the error messages above.
)
echo.
pause
goto menu

:run_executable
echo.
echo 🎮 Running Local LLM NPC (Pre-built executable)...
echo.
echo Make sure Ollama is running first:
start /B ollama serve
timeout /t 3 /nobreak >nul

echo.
echo Starting the game...
if exist "BIN\WINDOWS\local-llm-npc (4.4).exe" (
    start "Local LLM NPC" "BIN\WINDOWS\local-llm-npc (4.4).exe"
    echo.
    echo ✅ Game started! 
    echo 💡 In game settings, set Ollama URL to: http://localhost:11434
) else (
    echo ❌ Executable not found at BIN\WINDOWS\local-llm-npc (4.4).exe
    echo Please check if the file exists or build the project first.
)
echo.
pause
goto menu

:run_godot
echo.
echo 🎮 Running Local LLM NPC (Godot Editor)...
if %GODOT_INSTALLED%==0 (
    echo ❌ Godot not installed. Please install Godot 4.4.1 first.
    goto install_prereqs
)

echo Starting Ollama service...
start /B ollama serve
timeout /t 3 /nobreak >nul

echo.
echo Starting Godot project...
godot project.godot
echo.
echo 💡 In Godot, press F5 to run the project
echo 💡 In game settings, set Ollama URL to: http://localhost:11434
echo.
pause
goto menu

:create_guide
echo.
echo ✅ Creating QUICKSTART.md...
(
echo # Local LLM NPC - Quick Start Guide
echo.
echo ## 🚀 5-Minute Setup
echo.
echo ### Step 1: Install Prerequisites
echo 1. **Ollama**: https://ollama.ai/download/windows
echo 2. **Godot 4.4.1**: https://godotengine.org/download/archive/4.4.1/
echo 3. **.NET 8.0**: https://dotnet.microsoft.com/download/dotnet/8.0
echo.
echo ### Step 2: Setup AI Models
echo ```cmd
echo ollama serve
echo ollama pull gemma2:2b
echo ollama pull gemma2:9b
echo ```
echo.
echo ### Step 3: Run the Game
echo **Windows Executable**: `BIN\WINDOWS\local-llm-npc (4.4^).exe`
echo.
echo ### Step 4: Configure in Game
echo 1. Set Ollama URL: `http://localhost:11434`
echo 2. Choose your first specialist
echo 3. Start learning!
echo.
echo ## 🎬 3-Minute Video Demo Script
echo.
echo ### 0:00-0:30 - Introduction
echo "Welcome to Local LLM NPC, the world's first Multi-Agent Agricultural University!"
echo - Show main menu with 7 AI professors
echo - Highlight "Created by Om Choksi"
echo - Quick overview of offline AI technology
echo.
echo ### 0:30-1:30 - AI Professor Demonstration
echo **Demo Flow:**
echo 1. Select Dr. Terra Firma (Soil Science^)
echo 2. Ask: "How do I test my soil's pH and improve it for tomatoes?"
echo 3. Show detailed AI response with practical advice
echo 4. Demonstrate cross-referral to Dr. Flora Verde
echo 5. Show collaborative AI response
echo.
echo **Key Points to Mention:**
echo - "Each professor has 15-30 years of simulated expertise"
echo - "AI automatically refers to other specialists when needed"
echo - "All running completely offline with Gemma models"
echo.
echo ### 1:30-2:15 - Assessment System Demo
echo **Demo Flow:**
echo 1. Access the assessment center
echo 2. Start soil science fundamentals test
echo 3. Show different question types:
echo    - Multiple choice: "What is the ideal pH for blueberries?"
echo    - Calculation: "Calculate fertilizer needs for 1000 sq ft"
echo 4. Display real-time progress tracking
echo 5. Show detailed results and personalized recommendations
echo.
echo **Key Points:**
echo - "Adaptive difficulty adjusts to your learning level"
echo - "Immediate feedback and performance analytics"
echo - "Competency tracking across all agricultural domains"
echo.
echo ### 2:15-2:45 - Analytics Dashboard
echo **Demo Flow:**
echo 1. Open progress dashboard
echo 2. Show learning progress across all 7 specialties
echo 3. Display interaction heatmaps and learning patterns
echo 4. Demonstrate personalized recommendations
echo 5. Show achievement system and competency badges
echo.
echo **Key Points:**
echo - "Advanced analytics track your complete learning journey"
echo - "AI-powered recommendations optimize your learning path"
echo - "Professional-grade educational analytics"
echo.
echo ### 2:45-3:00 - Conclusion and Technical Specs
echo **Closing Points:**
echo - "Built with Godot 4.4.1 and Gemma AI models"
echo - "Completely open-source and privacy-first"
echo - "The future of agricultural education"
echo - "Created by Om Choksi for innovative AI education"
echo.
echo **Technical Overlay:**
echo - Engine: Godot 4.4.1
echo - AI: Gemma 2B/9B models via Ollama
echo - Architecture: Multi-agent system
echo - Privacy: 100%% offline operation
echo.
echo ## 📊 Specific Demo Questions
echo.
echo **Dr. Terra Firma (Soil Science^):**
echo - "What's the ideal pH for growing blueberries?"
echo - "How do I fix nitrogen-deficient soil naturally?"
echo - "Explain soil microorganism benefits"
echo.
echo **Dr. Flora Verde (Plant Biology^):**
echo - "Why are my tomato leaves turning yellow?"
echo - "How does photosynthesis affect plant growth?"
echo - "What causes blossom end rot in tomatoes?"
echo.
echo **Hydro Henderson (Water Management^):**
echo - "Design a drip irrigation system for my vegetable garden"
echo - "How much water do potato plants need per week?"
echo - "What's the best rainwater harvesting setup?"
echo.
echo **Assessment Questions (For Demo^):**
echo - Soil science fundamentals test
echo - Show adaptive difficulty adjustment
echo - Display comprehensive performance analytics
echo.
echo ## 🔧 Pre-Recording Checklist
echo.
echo - [ ] Ollama service running: `ollama serve`
echo - [ ] AI models loaded: `ollama list`
echo - [ ] Game launches without errors
echo - [ ] Test one conversation with each specialist
echo - [ ] Verify assessment system works
echo - [ ] Check analytics dashboard displays correctly
echo - [ ] Prepare screen recording software (1920x1080^)
echo - [ ] Test audio recording quality
echo - [ ] Have demo questions ready and tested
echo.
echo ## 🎯 Recording Tips
echo.
echo 1. **Resolution**: Record at 1920x1080 for clarity
echo 2. **Audio**: Use clear narration, speak at moderate pace
echo 3. **Pacing**: Allow time for AI responses (2-5 seconds^)
echo 4. **Preparation**: Test all demo questions beforehand
echo 5. **Backup**: Record multiple takes of each section
echo 6. **Professional**: Highlight the innovation and technical achievement
echo.
echo **Your project is now ready for professional video recording!**
) > QUICKSTART.md

echo ✅ QUICKSTART.md created with complete demo script!
echo 📖 Check the file for detailed 3-minute video guide
echo.
pause
goto menu

:show_demo_script
echo.
echo 🎬 3-MINUTE VIDEO DEMO SCRIPT
echo =============================
echo.
echo **PROJECT**: Local LLM NPC Agricultural University Platform
echo **CREATOR**: Om Choksi
echo **DURATION**: 3 minutes
echo.
echo ⏱️ 0:00-0:30 - INTRODUCTION
echo "Welcome to Local LLM NPC, the world's first Multi-Agent Agricultural University!"
echo "Created by Om Choksi, this revolutionary platform features 7 AI professors"
echo "running completely offline using Gemma models through Ollama."
echo.
echo 📱 SHOW: Main menu, specialist selection, project title
echo.
echo ⏱️ 0:30-1:30 - AI PROFESSOR DEMO
echo 1. Select Dr. Terra Firma (Soil Science)
echo 2. Ask: "How do I test my soil's pH and improve it for tomatoes?"
echo 3. Show AI response with practical advice
echo 4. Demonstrate automatic cross-referral to Dr. Flora Verde
echo 5. Show collaborative AI response
echo.
echo 💬 SAY: "Each professor has decades of simulated expertise and automatically"
echo "collaborates with other specialists for comprehensive answers."
echo.
echo ⏱️ 1:30-2:15 - ASSESSMENT SYSTEM
echo 1. Access assessment center
echo 2. Start soil science fundamentals test
echo 3. Show multiple choice and calculation questions
echo 4. Display real-time progress and adaptive difficulty
echo 5. Show detailed results with recommendations
echo.
echo 💬 SAY: "The adaptive assessment system adjusts difficulty in real-time"
echo "and provides comprehensive performance analytics."
echo.
echo ⏱️ 2:15-2:45 - ANALYTICS DASHBOARD
echo 1. Open progress dashboard
echo 2. Show learning progress across 7 specialties
echo 3. Display interaction patterns and competency tracking
echo 4. Demonstrate personalized AI recommendations
echo.
echo 💬 SAY: "Advanced analytics track your complete learning journey with"
echo "AI-powered recommendations for optimal educational outcomes."
echo.
echo ⏱️ 2:45-3:00 - CONCLUSION
echo "This is the future of agricultural education - AI-powered, offline,"
echo "and completely personalized. Built with Godot and Gemma models,"
echo "it's open-source and ready for deployment."
echo.
echo 📱 SHOW: Technical specs overlay, GitHub info, contact details
echo.
echo 🎯 DEMO QUESTIONS READY TO USE:
echo - "What's the ideal pH for blueberries?" (Dr. Terra Firma)
echo - "Why are my tomato leaves yellowing?" (Dr. Flora Verde)
echo - "Design a drip irrigation system" (Hydro Henderson)
echo.
pause
goto menu

:full_setup
echo.
echo 🚀 Full Setup Assistance
echo ========================
echo.
echo This will guide you through the complete setup process.
echo.
echo 📋 Current Status:
if %OLLAMA_INSTALLED%==1 echo ✅ Ollama: Ready
if %OLLAMA_INSTALLED%==0 echo ❌ Ollama: Needs installation
if %GODOT_INSTALLED%==1 echo ✅ Godot: Ready  
if %GODOT_INSTALLED%==0 echo ❌ Godot: Needs installation
if %DOTNET_INSTALLED%==1 echo ✅ .NET SDK: Ready
if %DOTNET_INSTALLED%==0 echo ❌ .NET SDK: Needs installation
echo.

if %OLLAMA_INSTALLED%==0 (
    echo 📥 Step 1: Install Ollama
    echo https://ollama.ai/download/windows
    echo Download and install, then restart this script.
    echo.
    pause
    goto menu
)

if %DOTNET_INSTALLED%==0 (
    echo 📥 Step 2: Install .NET 8.0 SDK
    echo https://dotnet.microsoft.com/download/dotnet/8.0
    echo Download and install the SDK, then restart this script.
    echo.
    pause
    goto menu
)

echo 🤖 Step 3: Setting up AI models...
start /B ollama serve
timeout /t 5 /nobreak >nul
ollama pull gemma2:2b
ollama pull gemma2:9b

echo.
echo 🔨 Step 4: Building project...
dotnet restore
dotnet build --configuration Release

echo.
echo ✅ Setup complete! 
echo.
echo 🎮 To run the project:
echo 1. Use: setup.bat and choose option 4 (run executable)
echo 2. Or manually run: BIN\WINDOWS\local-llm-npc (4.4).exe
echo.
echo 🎬 For video demo:
echo - Check QUICKSTART.md for complete demo script
echo - Test all features before recording
echo - Record at 1920x1080 resolution
echo.
echo 🎯 Your Local LLM NPC Agricultural University is ready!
echo.
pause
goto menu

:invalid_choice
echo.
echo ❌ Invalid choice. Please select 1-8.
echo.
pause

:menu
echo.
echo 🔄 Return to main menu? (Y/N)
set /p restart="Choice: "
if /i "%restart%"=="Y" goto start
if /i "%restart%"=="yes" goto start
goto end

:start
cls
goto main

:main
echo.
echo 🚀 Local LLM NPC Agricultural University Platform Setup
echo =======================================================
echo.
echo 🛠️ Setup Options:
echo 1. Install prerequisites (manual download links)
echo 2. Setup AI models
echo 3. Build project  
echo 4. Run project (executable)
echo 5. Run project (Godot editor)
echo 6. Create quick start guide
echo 7. Show demo video script
echo 8. Full setup assistance
echo 9. Exit
echo.

set /p choice="Choose an option (1-9): "

if "%choice%"=="1" goto install_prereqs
if "%choice%"=="2" goto setup_models
if "%choice%"=="3" goto build_project
if "%choice%"=="4" goto run_executable
if "%choice%"=="5" goto run_godot
if "%choice%"=="6" goto create_guide
if "%choice%"=="7" goto show_demo_script
if "%choice%"=="8" goto full_setup
if "%choice%"=="9" goto end
goto invalid_choice

:end
echo.
echo 🎉 Thank you for using Local LLM NPC setup!
echo 📧 Created by Om Choksi
echo 🌐 Multi-Agent Agricultural University Platform
echo.
pause
