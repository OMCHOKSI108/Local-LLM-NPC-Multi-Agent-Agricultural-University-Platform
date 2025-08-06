#!/bin/bash
# Local LLM NPC - Quick Setup Script for Windows
# Created by Om Choksi

echo "🚀 Local LLM NPC Agricultural University Platform Setup"
echo "======================================================="
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to download and install Ollama on Windows
install_ollama_windows() {
    echo "📥 Installing Ollama for Windows..."
    
    # Check if running in PowerShell/Windows
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        echo "Please manually download and install Ollama from:"
        echo "https://ollama.ai/download/windows"
        echo ""
        echo "After installation, run:"
        echo "ollama pull gemma2:2b"
        echo "ollama pull gemma2:9b"
        read -p "Press Enter after installing Ollama..."
    else
        # Linux/macOS installation
        curl -fsSL https://ollama.ai/install.sh | sh
    fi
}

# Function to install Godot
install_godot() {
    echo "🎮 Installing Godot 4.4.1..."
    echo "Please download Godot 4.4.1 (Mono/C#) from:"
    echo "https://godotengine.org/download/archive/4.4.1/"
    echo ""
    echo "Choose: Godot Engine 4.4.1 (Mono/C#)"
    read -p "Press Enter after installing Godot..."
}

# Function to install .NET SDK
install_dotnet() {
    echo "⚙️ Installing .NET 8.0 SDK..."
    echo "Please download and install .NET 8.0 SDK from:"
    echo "https://dotnet.microsoft.com/download/dotnet/8.0"
    read -p "Press Enter after installing .NET SDK..."
}

# Function to setup AI models
setup_ai_models() {
    echo "🤖 Setting up AI models..."
    
    if command_exists ollama; then
        echo "✅ Ollama is installed"
        
        # Start Ollama service
        echo "Starting Ollama service..."
        ollama serve &
        sleep 5
        
        # Pull required models
        echo "📥 Downloading AI models (this may take a while)..."
        ollama pull gemma2:2b
        ollama pull gemma2:9b
        
        echo "✅ AI models installed successfully"
        ollama list
    else
        echo "❌ Ollama not found. Please install Ollama first."
        install_ollama_windows
    fi
}

# Function to build the project
build_project() {
    echo "🔨 Building the project..."
    
    if command_exists dotnet; then
        echo "✅ .NET SDK is installed"
        dotnet restore
        dotnet build --configuration Release
        echo "✅ Project built successfully"
    else
        echo "❌ .NET SDK not found. Please install .NET 8.0 SDK first."
        install_dotnet
    fi
}

# Function to run the project
run_project() {
    echo "🎮 Running Local LLM NPC..."
    
    if command_exists godot; then
        echo "✅ Godot is installed"
        echo "Starting project..."
        godot --main-scene res://ASSETS/SCENES/main.tscn
    else
        echo "❌ Godot not found."
        echo "💡 Alternative: Run the pre-built executable:"
        echo ""
        if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
            echo "Windows: ./BIN/WINDOWS/local-llm-npc\ \(4.4\).exe"
        else
            echo "Linux: ./BIN/LINUX/local-llm-npc\ \(4.4\).x86_64"
        fi
        echo ""
        read -p "Press Enter to continue..."
    fi
}

# Function to create quick start guide
create_quick_start() {
    cat > QUICKSTART.md << EOF
# Local LLM NPC - Quick Start Guide

## 🚀 5-Minute Setup

### Step 1: Install Prerequisites
1. **Ollama**: Download from https://ollama.ai/download
2. **Godot 4.4.1**: Download from https://godotengine.org/download/archive/4.4.1/
3. **.NET 8.0**: Download from https://dotnet.microsoft.com/download/dotnet/8.0

### Step 2: Setup AI Models
\`\`\`bash
ollama serve
ollama pull gemma2:2b
ollama pull gemma2:9b
\`\`\`

### Step 3: Run the Game
**Option A: Use Pre-built Executable**
- Windows: \`BIN/WINDOWS/local-llm-npc (4.4).exe\`
- Linux: \`BIN/LINUX/local-llm-npc (4.4).x86_64\`

**Option B: Run from Godot**
\`\`\`bash
godot project.godot
# Press F5 to run
\`\`\`

### Step 4: Configure in Game
1. Set Ollama URL: \`http://localhost:11434\`
2. Choose your first specialist
3. Start learning!

## 🎬 Video Demo Script (3 minutes)

### 0:00-0:30 - Introduction
"Welcome to Local LLM NPC, featuring 7 AI agricultural professors!"

### 0:30-1:30 - AI Professors Demo
1. Select Dr. Terra Firma
2. Ask: "How do I test soil pH for tomatoes?"
3. Show cross-referral to Dr. Flora Verde
4. Demonstrate collaborative AI responses

### 1:30-2:15 - Assessment System
1. Take a soil science assessment
2. Show adaptive difficulty
3. Display results and analytics

### 2:15-3:00 - Analytics Dashboard
1. Show learning progress
2. Display competency tracking
3. Demonstrate recommendation system

## 📊 Demo Questions by Specialist

**Dr. Terra Firma (Soil Science):**
- "What's the ideal pH for blueberries?"
- "How do I fix nitrogen deficiency?"

**Dr. Flora Verde (Plant Biology):**
- "Why are my tomato leaves yellowing?"
- "How does photosynthesis work?"

**Hydro Henderson (Water Management):**
- "Design a drip irrigation system"
- "How much water do potatoes need?"

**Assessment Demo:**
- Start with soil science fundamentals
- Show multiple choice and calculation questions
- Display performance analytics

## 🔧 Troubleshooting

**Issue: Cannot connect to Ollama**
\`\`\`bash
ollama serve
curl http://localhost:11434/api/version
\`\`\`

**Issue: Slow AI responses**
- Use smaller model: \`ollama pull gemma2:2b\`
- Increase timeout in game settings

**Issue: Game won't start**
\`\`\`bash
dotnet restore
dotnet build
\`\`\`

## 🎯 Ready for Video!

Your project is now ready for recording a professional demo video!
EOF

    echo "✅ Created QUICKSTART.md with demo script"
}

# Main setup flow
main() {
    echo "🌟 Welcome to Local LLM NPC Setup!"
    echo ""
    
    # Check current status
    echo "📋 Checking system requirements..."
    
    if command_exists ollama; then
        echo "✅ Ollama: Installed"
    else
        echo "❌ Ollama: Not installed"
    fi
    
    if command_exists godot; then
        echo "✅ Godot: Installed"
    else
        echo "❌ Godot: Not installed"
    fi
    
    if command_exists dotnet; then
        echo "✅ .NET SDK: Installed"
    else
        echo "❌ .NET SDK: Not installed"
    fi
    
    echo ""
    echo "🛠️ Setup Options:"
    echo "1. Install missing prerequisites"
    echo "2. Setup AI models"
    echo "3. Build project"
    echo "4. Run project"
    echo "5. Create quick start guide"
    echo "6. Full setup (all steps)"
    echo ""
    
    read -p "Choose an option (1-6): " choice
    
    case $choice in
        1)
            echo "Installing prerequisites..."
            if ! command_exists ollama; then install_ollama_windows; fi
            if ! command_exists godot; then install_godot; fi
            if ! command_exists dotnet; then install_dotnet; fi
            ;;
        2)
            setup_ai_models
            ;;
        3)
            build_project
            ;;
        4)
            run_project
            ;;
        5)
            create_quick_start
            ;;
        6)
            echo "🚀 Running full setup..."
            if ! command_exists ollama; then install_ollama_windows; fi
            if ! command_exists godot; then install_godot; fi
            if ! command_exists dotnet; then install_dotnet; fi
            setup_ai_models
            build_project
            create_quick_start
            echo ""
            echo "🎉 Setup complete! Ready to run your AI Agricultural University!"
            echo "📖 Check QUICKSTART.md for demo video script"
            ;;
        *)
            echo "Invalid option. Please run the script again."
            ;;
    esac
}

# Run main function
main
