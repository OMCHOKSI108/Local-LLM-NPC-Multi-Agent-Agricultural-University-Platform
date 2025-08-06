using Godot;

namespace LocalLLMNPC
{
    public enum NPCSpecialty
    {
        AgricultureSpecialist,
        CropSpecialist,
        LivestockSpecialist,
        SoilSpecialist,
        PlantPathologist,
        Entomologist,
        IrrigationSpecialist,
        SustainableAgriculture,
        FarmManagement,
        AgriculturalEconomist
    }

    public enum DifficultyLevel
    {
        Beginner,
        Intermediate,
        Advanced,
        Expert
    }

    public enum AssessmentType
    {
        KnowledgeCheck,
        PracticalSkill,
        CriticalThinking,
        ProblemSolving,
        Competency
    }

    public partial class AssessmentResult : RefCounted
    {
        public NPCSpecialty Specialty { get; set; }
        public float Score { get; set; }
        public DifficultyLevel Level { get; set; }
        public string Feedback { get; set; } = "";
        public bool Passed { get; set; }
    }

    public partial class AssessmentSession : RefCounted
    {
        public NPCSpecialty Specialty { get; set; }
        public DifficultyLevel Level { get; set; }
        public float Progress { get; set; }
        public int CurrentQuestion { get; set; }
        public int TotalQuestions { get; set; }
    }

    public partial class ConversationAnalytics : RefCounted
    {
        public float EngagementScore { get; set; }
        public int MessageCount { get; set; }
        public float AverageResponseTime { get; set; }
    }

    public partial class LearningAssessmentSystem : RefCounted
    {
        public float CompletionRate { get; set; }
        public DifficultyLevel CurrentLevel { get; set; }
        public int TotalAssessments { get; set; }
    }

    public partial class SpecialistManager : RefCounted
    {
        public NPCSpecialty[] AvailableSpecialties { get; set; } = new NPCSpecialty[0];
        public NPCSpecialty CurrentSpecialty { get; set; }
    }

    public partial class AssessmentQuestion : RefCounted
    {
        public string Question { get; set; } = "";
        public string[] Options { get; set; } = new string[0];
        public int CorrectAnswer { get; set; }
        public string Explanation { get; set; } = "";
        public DifficultyLevel Difficulty { get; set; }
        public NPCSpecialty Specialty { get; set; }
    }
}
