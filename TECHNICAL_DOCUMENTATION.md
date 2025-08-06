# Local LLM NPC - Technical Documentation
**Created by Om Choksi**

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture Design](#architecture-design)
3. [Multi-Agent System](#multi-agent-system)
4. [Assessment Framework](#assessment-framework)
5. [Analytics Engine](#analytics-engine)
6. [API Reference](#api-reference)
7. [Deployment Guide](#deployment-guide)
8. [Development Guidelines](#development-guidelines)

## Project Overview

Local LLM NPC is a revolutionary multi-agent educational platform that creates the world's first virtual agricultural university. Built by **Om Choksi**, this system leverages Gemma 3n's advanced AI capabilities to deliver expert-level agricultural education through specialized AI professors.

### Core Innovation

- **Multi-Agent Architecture**: 7 specialized AI professors with unique expertise domains
- **Intelligent Cross-Referral System**: AI specialists automatically collaborate and refer students
- **Adaptive Learning Assessment**: Dynamic difficulty adjustment based on student performance
- **Advanced Analytics Engine**: Comprehensive tracking of learning patterns and progress
- **Privacy-First Design**: Complete offline operation with no data transmission

### Technology Stack

- **Engine**: Godot 4.4.1 (Mono/C#)
- **AI Integration**: Ollama + Gemma 3n models
- **Language**: C# (.NET 8.0)
- **Data Format**: JSON for AI responses and configuration
- **Architecture Pattern**: Singleton + Observer + Strategy patterns

## Architecture Design

### System Components

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                   │
├─────────────────────────────────────────────────────────┤
│  SpecialistSelector  │  ConversationUI  │  Analytics    │
├─────────────────────────────────────────────────────────┤
│                    BUSINESS LOGIC LAYER                 │
├─────────────────────────────────────────────────────────┤
│  SpecialistManager   │  AssessmentSystem │  Analytics   │
│  SpecialistNPC       │  ConversationMgr  │  EventHandler│
├─────────────────────────────────────────────────────────┤
│                    DATA ACCESS LAYER                    │
├─────────────────────────────────────────────────────────┤
│  OllamaService       │  GameData         │  FileAccess  │
├─────────────────────────────────────────────────────────┤
│                    AI INTEGRATION LAYER                 │
├─────────────────────────────────────────────────────────┤
│  Gemma 3n Models     │  Ollama Server    │  JSON Schema │
└─────────────────────────────────────────────────────────┘
```

### Key Design Patterns

#### 1. Singleton Pattern
- `SpecialistManager`: Coordinates all AI specialists
- `ConversationAnalytics`: Tracks learning metrics
- `LearningAssessmentSystem`: Manages assessments

#### 2. Strategy Pattern
- Each `SpecialistNPC` implements different teaching strategies
- Adaptive assessment algorithms based on student performance

#### 3. Observer Pattern
- Event-driven communication between specialists
- Real-time analytics and progress tracking

## Multi-Agent System

### Specialist Architecture

Each specialist is implemented as a specialized AI agent with:

```csharp
public partial class SpecialistNPC : EducationalConversation
{
    public NPCSpecialty Specialty { get; set; }
    public ExpertiseLevel ExpertiseLevel { get; set; }
    public List<string> ResearchAreas { get; set; }
    public List<NPCSpecialty> CanReferTo { get; set; }
}
```

### Specialist Roster

| Specialist | Expertise Level | Years Experience | Primary Focus |
|------------|----------------|------------------|---------------|
| Dr. Terra Firma | Professor | 20 | Soil Science & Microbiome |
| Dr. Flora Verde | Professor | 25 | Plant Biology & Genetics |
| Hydro Henderson | Consultant | 18 | Water Management & Irrigation |
| Compost Carl | Master | 15 | Composting & Decomposition |
| Dr. Beneficial Betty | Researcher | 22 | Integrated Pest Management |
| Perma Pete | Master | 30 | Permaculture Design |
| Professor Green Thumb | Professor | 28 | General Agriculture |

### Cross-Referral Logic

The intelligent referral system analyzes student questions and automatically suggests appropriate specialists:

```csharp
public NPCSpecialty SuggestSpecialistFor(string topic)
{
    if (topic.Contains("soil") || topic.Contains("nutrient"))
        return NPCSpecialty.SoilScience;
    
    if (topic.Contains("water") || topic.Contains("irrigation"))
        return NPCSpecialty.WaterManagement;
    
    // Additional logic for other specialties...
}
```

## Assessment Framework

### Adaptive Assessment Engine

The assessment system dynamically adjusts question difficulty based on student performance:

```csharp
public Assessment GenerateAdaptiveAssessment(NPCSpecialty specialty)
{
    var profile = competencyProfiles[specialty];
    var currentLevel = profile.CurrentLevel;
    
    // Mix questions from current and adjacent difficulty levels
    var questionPool = BuildQuestionPool(specialty, currentLevel);
    return SelectOptimalQuestions(questionPool, profile);
}
```

### Question Types

1. **Multiple Choice**: Standard selection questions
2. **True/False**: Binary logic questions  
3. **Short Answer**: Open-ended responses with keyword matching
4. **Practical Application**: Real-world scenario questions
5. **Case Study**: Complex problem-solving scenarios
6. **Calculation**: Mathematical and formula-based questions

### Competency Tracking

Student progress is tracked across multiple dimensions:

```csharp
public class CompetencyProfile
{
    public DifficultyLevel CurrentLevel { get; set; }
    public Dictionary<string, CompetencyScore> Competencies { get; set; }
    public int AssessmentsTaken { get; set; }
    public DateTime LastAssessmentDate { get; set; }
}
```

## Analytics Engine

### Conversation Analytics

Comprehensive tracking of all educational interactions:

```csharp
public class ConversationInteraction
{
    public DateTime Timestamp { get; set; }
    public NPCSpecialty Specialty { get; set; }
    public string UserMessage { get; set; }
    public string AIResponse { get; set; }
    public TimeSpan Duration { get; set; }
}
```

### Learning Metrics

- **Specialist Usage Patterns**: Which experts are consulted most
- **Topic Progression**: How students advance through knowledge domains
- **Referral Effectiveness**: Success rate of cross-specialist referrals
- **Assessment Performance**: Score trends and competency development

### Analytics Reports

Generated reports include:

1. **Individual Progress Reports**: Personal learning journey
2. **Specialist Effectiveness Reports**: AI teacher performance metrics
3. **System Usage Analytics**: Platform utilization patterns
4. **Learning Outcome Analysis**: Educational objective achievement

## API Reference

### Core Classes

#### SpecialistManager

```csharp
public partial class SpecialistManager : Node
{
    public static SpecialistManager Instance { get; }
    public SpecialistNPC CurrentSpecialist { get; }
    
    public void SwitchToSpecialist(NPCSpecialty specialty);
    public NPCSpecialty SuggestSpecialistForTopic(string topic);
    public void MakeReferral(NPCSpecialty from, NPCSpecialty to, string reason);
}
```

#### LearningAssessmentSystem

```csharp
public partial class LearningAssessmentSystem : Node
{
    public static LearningAssessmentSystem Instance { get; }
    
    public Assessment GenerateAdaptiveAssessment(NPCSpecialty specialty);
    public AssessmentResult EvaluateAssessment(Assessment assessment, Dictionary<string, string> responses);
    public CompetencyReport GetCompetencyReport(NPCSpecialty specialty);
}
```

#### ConversationAnalytics

```csharp
public partial class ConversationAnalytics : Node
{
    public static ConversationAnalytics Instance { get; }
    
    public void RecordInteraction(NPCSpecialty specialty, string message, string response, TimeSpan duration);
    public void RecordReferral(NPCSpecialty from, NPCSpecialty to, string reason, string topic);
    public AnalyticsReport GenerateReport();
}
```

### Events and Signals

```csharp
[Signal]
public delegate void SpecialistChangedEventHandler(SpecialistNPC newSpecialist);

[Signal]
public delegate void SpecialistReferralEventHandler(NPCSpecialty from, NPCSpecialty to, string reason);

[Signal]
public delegate void AssessmentCompletedEventHandler(AssessmentResult result);
```

## Deployment Guide

### Prerequisites

1. **Godot Engine 4.4.1** (Mono/C# build)
2. **.NET SDK 8.0** or higher
3. **Ollama Server** with Gemma 3n models
4. **8GB RAM minimum** (16GB recommended for large models)

### Installation Steps

1. **Clone Repository**
   ```bash
   git clone https://github.com/omchoksi108/Local-LLM-NPC-Multi-Agent-Agricultural-University-Platform.git
   cd local-llm-npc
   ```

2. **Install Dependencies**
   ```bash
   dotnet restore
   ```

3. **Configure Ollama**
   ```bash
   ollama pull gemma3n:e4b
   ollama pull gemma3n:e2b
   ```

4. **Build and Run**
   - Open project in Godot 4.4.1
   - Configure Ollama host URL in settings
   - Press Play to launch

### Configuration Files

- `gamedata.json`: User preferences and settings
- `npcResponseSchema.json`: AI response structure definition
- Specialist backstory files: Domain-specific knowledge bases

## Development Guidelines

### Code Style

- **C# Conventions**: Follow Microsoft C# coding standards
- **Documentation**: XML comments for all public methods
- **Error Handling**: Comprehensive try-catch blocks with logging
- **Performance**: Async/await for AI operations

### Adding New Specialists

1. **Create Specialist Class**
   ```csharp
   public partial class NewSpecialistNPC : SpecialistNPC
   {
       public override void _Ready()
       {
           Specialty = NPCSpecialty.NewDomain;
           // Initialize specialist data
           base._Ready();
       }
   }
   ```

2. **Add Backstory Template**
   - Create `newSpecialistBackStory.txt`
   - Define expertise areas and teaching methods
   - Specify referral relationships

3. **Update Assessment Questions**
   - Add domain-specific questions to `LearningAssessmentSystem`
   - Define competency areas
   - Create adaptive difficulty progression

### Testing Framework

```csharp
[Test]
public void TestSpecialistReferral()
{
    var manager = SpecialistManager.Instance;
    var suggestion = manager.SuggestSpecialistForTopic("soil pH testing");
    Assert.AreEqual(NPCSpecialty.SoilScience, suggestion);
}
```

### Performance Optimization

- **Lazy Loading**: Load specialist data on demand
- **Caching**: Cache AI responses for common questions
- **Memory Management**: Dispose of large objects promptly
- **Background Processing**: Use async for long-running operations

## Contributing

### Development Workflow

1. **Fork Repository**
2. **Create Feature Branch**
3. **Implement Changes**
4. **Add Tests**
5. **Submit Pull Request**

### Code Review Checklist

- [ ] XML documentation for new public methods
- [ ] Unit tests for new functionality
- [ ] Performance impact assessment
- [ ] Memory leak testing
- [ ] Integration testing with AI models

---

## License

MIT License - Created by Om Choksi

## Contact

For technical questions or contributions, please contact:
- **Author**: Om Choksi
- **Project**: Local LLM NPC Agricultural University
- **Repository**: https://github.com/omchoksi108/Local-LLM-NPC-Multi-Agent-Agricultural-University-Platform

---

*This documentation covers the core technical implementation of the Local LLM NPC multi-agent educational system. For additional details on specific components, refer to the inline code documentation and example implementations.*
