using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

namespace LocalLLMNPC.UI
{
    /// <summary>
    /// Comprehensive progress tracking and analytics dashboard for the Agricultural University Platform.
    /// Created by Om Choksi to provide detailed insights into learning progress across all specialists.
    /// Features real-time progress tracking, competency mapping, and personalized recommendations.
    /// </summary>
    public partial class ProgressDashboard : Control
    {
        [Signal]
        public delegate void SpecialistFocusRequestedEventHandler(NPCSpecialty specialty);

        [Signal]
        public delegate void AssessmentRequestedEventHandler(NPCSpecialty specialty);

        [Signal]
        public delegate void BackToSelectorEventHandler();

        // UI Components
        private VBoxContainer mainContainer;
        private TabContainer tabContainer;

        // Overview Tab
        private Control overviewTab;
        private CircularProgressDisplay overallProgressCircle;
        private GridContainer achievementGrid;
        private VBoxContainer recentActivityList;
        private Label totalHoursLabel;
        private Label streakLabel;

        // Specialist Progress Tab
        private Control specialistTab;
        private VBoxContainer specialistProgressList;
        private Dictionary<NPCSpecialty, SpecialistProgressCard> specialistCards;

        // Analytics Tab
        private Control analyticsTab;
        private LineChart learningVelocityChart;
        private BarChart topicMasteryChart;
        private HeatMapDisplay interactionHeatmap;

        // Assessment Tab
        private Control assessmentTab;
        private VBoxContainer assessmentHistory;
        private GridContainer competencyMatrix;

        // Recommendations Tab
        private Control recommendationsTab;
        private VBoxContainer recommendationsList;
        private RichTextLabel personalizedPlan;

        // Data Sources
        private ConversationAnalytics analytics;
        private LearningAssessmentSystem assessmentSystem;
        private SpecialistManager specialistManager;

        // Visual Resources
        private Theme dashboardTheme;
        private Dictionary<NPCSpecialty, Color> specialtyColors;

        public override void _Ready()
        {
            InitializeDataSources();
            CreateDashboardLayout();
            LoadSpecialtyColors();
            PopulateAllTabs();
            ConnectSignals();

            // Auto-refresh timer
            var refreshTimer = new Timer();
            refreshTimer.WaitTime = 30.0f; // Refresh every 30 seconds
            refreshTimer.Timeout += UpdateAllDisplays;
            refreshTimer.Autostart = true;
            AddChild(refreshTimer);
        }

        private void InitializeDataSources()
        {
            analytics = GetNode<ConversationAnalytics>("/root/ConversationAnalytics");
            assessmentSystem = GetNode<LearningAssessmentSystem>("/root/LearningAssessmentSystem");
            specialistManager = GetNode<SpecialistManager>("/root/SpecialistManager");

            specialistCards = new Dictionary<NPCSpecialty, SpecialistProgressCard>();
        }

        private void CreateDashboardLayout()
        {
            SetAnchorsAndOffsetsPreset(Control.Preset.FullRect);

            mainContainer = new VBoxContainer();
            AddChild(mainContainer);

            // Dashboard header
            CreateDashboardHeader();

            // Main tab container
            tabContainer = new TabContainer();
            tabContainer.SetAnchorsAndOffsetsPreset(Control.Preset.FullRect);
            tabContainer.TabAlignment = TabBar.AlignmentMode.Center;
            mainContainer.AddChild(tabContainer);

            // Create all tabs
            CreateOverviewTab();
            CreateSpecialistTab();
            CreateAnalyticsTab();
            CreateAssessmentTab();
            CreateRecommendationsTab();
        }

        private void CreateDashboardHeader()
        {
            var headerContainer = new HBoxContainer();
            headerContainer.CustomMinimumSize = new Vector2(0, 80);
            mainContainer.AddChild(headerContainer);

            // Title and user info
            var titleSection = new VBoxContainer();
            headerContainer.AddChild(titleSection);

            var titleLabel = new Label();
            titleLabel.Text = "📊 Agricultural University - Learning Dashboard";
            titleLabel.AddThemeStyleboxOverride("normal", CreateHeaderStyle());
            titleSection.AddChild(titleLabel);

            var userStatsLabel = new Label();
            userStatsLabel.Text = $"👤 Student Progress Overview • Updated {DateTime.Now:HH:mm}";
            titleSection.AddChild(userStatsLabel);

            // Quick stats
            var quickStatsContainer = new HBoxContainer();
            headerContainer.AddChild(quickStatsContainer);

            totalHoursLabel = new Label();
            streakLabel = new Label();

            quickStatsContainer.AddChild(totalHoursLabel);
            quickStatsContainer.AddChild(streakLabel);

            // Back button
            var backButton = new Button();
            backButton.Text = "← Back to Specialists";
            backButton.CustomMinimumSize = new Vector2(180, 40);
            backButton.Connect("pressed", new Callable(this, nameof(OnBackPressed)));
            headerContainer.AddChild(backButton);
        }

        private void CreateOverviewTab()
        {
            overviewTab = new Control();
            overviewTab.Name = "📊 Overview";
            tabContainer.AddChild(overviewTab);

            var scrollContainer = new ScrollContainer();
            scrollContainer.SetAnchorsAndOffsetsPreset(Control.Preset.FullRect);
            overviewTab.AddChild(scrollContainer);

            var contentContainer = new VBoxContainer();
            scrollContainer.AddChild(contentContainer);

            // Overall progress section
            var progressSection = new HBoxContainer();
            contentContainer.AddChild(progressSection);

            // Circular progress display
            overallProgressCircle = new CircularProgressDisplay();
            overallProgressCircle.CustomMinimumSize = new Vector2(200, 200);
            progressSection.AddChild(overallProgressCircle);

            // Progress details
            var progressDetails = new VBoxContainer();
            progressSection.AddChild(progressDetails);

            var progressStats = new GridContainer();
            progressStats.Columns = 2;
            progressDetails.AddChild(progressStats);

            // Achievement section
            var achievementLabel = new Label();
            achievementLabel.Text = "🏆 Recent Achievements";
            achievementLabel.AddThemeStyleboxOverride("normal", CreateSectionHeaderStyle());
            contentContainer.AddChild(achievementLabel);

            achievementGrid = new GridContainer();
            achievementGrid.Columns = 4;
            contentContainer.AddChild(achievementGrid);

            // Recent activity section
            var activityLabel = new Label();
            activityLabel.Text = "📝 Recent Learning Activity";
            activityLabel.AddThemeStyleboxOverride("normal", CreateSectionHeaderStyle());
            contentContainer.AddChild(activityLabel);

            recentActivityList = new VBoxContainer();
            contentContainer.AddChild(recentActivityList);
        }

        private void CreateSpecialistTab()
        {
            specialistTab = new Control();
            specialistTab.Name = "👨‍🏫 Specialists";
            tabContainer.AddChild(specialistTab);

            var scrollContainer = new ScrollContainer();
            scrollContainer.SetAnchorsAndOffsetsPreset(Control.Preset.FullRect);
            specialistTab.AddChild(scrollContainer);

            specialistProgressList = new VBoxContainer();
            scrollContainer.AddChild(specialistProgressList);

            // Create progress cards for each specialist
            foreach (NPCSpecialty specialty in Enum.GetValues<NPCSpecialty>())
            {
                CreateSpecialistProgressCard(specialty);
            }
        }

        private void CreateAnalyticsTab()
        {
            analyticsTab = new Control();
            analyticsTab.Name = "📈 Analytics";
            tabContainer.AddChild(analyticsTab);

            var scrollContainer = new ScrollContainer();
            scrollContainer.SetAnchorsAndOffsetsPreset(Control.Preset.FullRect);
            analyticsTab.AddChild(scrollContainer);

            var analyticsContainer = new VBoxContainer();
            scrollContainer.AddChild(analyticsContainer);

            // Learning velocity chart
            var velocityLabel = new Label();
            velocityLabel.Text = "📈 Learning Velocity Over Time";
            velocityLabel.AddThemeStyleboxOverride("normal", CreateSectionHeaderStyle());
            analyticsContainer.AddChild(velocityLabel);

            learningVelocityChart = new LineChart();
            learningVelocityChart.CustomMinimumSize = new Vector2(600, 300);
            analyticsContainer.AddChild(learningVelocityChart);

            // Topic mastery chart
            var masteryLabel = new Label();
            masteryLabel.Text = "🎯 Topic Mastery Distribution";
            masteryLabel.AddThemeStyleboxOverride("normal", CreateSectionHeaderStyle());
            analyticsContainer.AddChild(masteryLabel);

            topicMasteryChart = new BarChart();
            topicMasteryChart.CustomMinimumSize = new Vector2(600, 250);
            analyticsContainer.AddChild(topicMasteryChart);

            // Interaction heatmap
            var heatmapLabel = new Label();
            heatmapLabel.Text = "🔥 Daily Interaction Heatmap";
            heatmapLabel.AddThemeStyleboxOverride("normal", CreateSectionHeaderStyle());
            analyticsContainer.AddChild(heatmapLabel);

            interactionHeatmap = new HeatMapDisplay();
            interactionHeatmap.CustomMinimumSize = new Vector2(700, 200);
            analyticsContainer.AddChild(interactionHeatmap);
        }

        private void CreateAssessmentTab()
        {
            assessmentTab = new Control();
            assessmentTab.Name = "📝 Assessments";
            tabContainer.AddChild(assessmentTab);

            var scrollContainer = new ScrollContainer();
            scrollContainer.SetAnchorsAndOffsetsPreset(Control.Preset.FullRect);
            assessmentTab.AddChild(scrollContainer);

            var assessmentContainer = new VBoxContainer();
            scrollContainer.AddChild(assessmentContainer);

            // Competency matrix
            var matrixLabel = new Label();
            matrixLabel.Text = "🎓 Competency Matrix";
            matrixLabel.AddThemeStyleboxOverride("normal", CreateSectionHeaderStyle());
            assessmentContainer.AddChild(matrixLabel);

            competencyMatrix = new GridContainer();
            competencyMatrix.Columns = 4;
            assessmentContainer.AddChild(competencyMatrix);

            // Assessment history
            var historyLabel = new Label();
            historyLabel.Text = "      Recent Assessment Results";
            historyLabel.AddThemeStyleboxOverride("normal", CreateSectionHeaderStyle());
            assessmentContainer.AddChild(historyLabel);

            assessmentHistory = new VBoxContainer();
            assessmentContainer.AddChild(assessmentHistory);
        }

        private void CreateRecommendationsTab()
        {
            recommendationsTab = new Control();
            recommendationsTab.Name = "💡 Recommendations";
            tabContainer.AddChild(recommendationsTab);

            var scrollContainer = new ScrollContainer();
            scrollContainer.SetAnchorsAndOffsetsPreset(Control.Preset.FullRect);
            recommendationsTab.AddChild(scrollContainer);

            var recommendationContainer = new VBoxContainer();
            scrollContainer.AddChild(recommendationContainer);

            // Personalized learning plan
            var planLabel = new Label();
            planLabel.Text = "🎯 Your Personalized Learning Plan";
            planLabel.AddThemeStyleboxOverride("normal", CreateSectionHeaderStyle());
            recommendationContainer.AddChild(planLabel);

            personalizedPlan = new RichTextLabel();
            personalizedPlan.CustomMinimumSize = new Vector2(600, 200);
            personalizedPlan.BbcodeEnabled = true;
            recommendationContainer.AddChild(personalizedPlan);

            // Specific recommendations
            var recommendationsLabel = new Label();
            recommendationsLabel.Text = "💡 Smart Recommendations";
            recommendationsLabel.AddThemeStyleboxOverride("normal", CreateSectionHeaderStyle());
            recommendationContainer.AddChild(recommendationsLabel);

            recommendationsList = new VBoxContainer();
            recommendationContainer.AddChild(recommendationsList);
        }

        private void CreateSpecialistProgressCard(NPCSpecialty specialty)
        {
            var card = new SpecialistProgressCard();
            card.Setup(specialty, analytics, assessmentSystem);
            card.SpecialistSelected += OnSpecialistCardSelected;
            card.AssessmentRequested += OnAssessmentCardRequested;

            specialistCards[specialty] = card;
            specialistProgressList.AddChild(card);
        }

        private void PopulateAllTabs()
        {
            UpdateOverviewTab();
            UpdateSpecialistTab();
            UpdateAnalyticsTab();
            UpdateAssessmentTab();
            UpdateRecommendationsTab();
        }

        private void UpdateOverviewTab()
        {
            // Update overall progress circle
            var totalProgress = CalculateOverallProgress();
            overallProgressCircle.UpdateProgress(totalProgress);

            // Update quick stats
            var totalHours = analytics.GetTotalLearningHours();
            var currentStreak = analytics.GetCurrentLearningStreak();

            totalHoursLabel.Text = $"⏱️ Total Hours: {totalHours:F1}";
            streakLabel.Text = $"🔥 Streak: {currentStreak} days";

            // Update achievements
            UpdateAchievements();

            // Update recent activity
            UpdateRecentActivity();
        }

        private void UpdateSpecialistTab()
        {
            foreach (var card in specialistCards.Values)
            {
                card.UpdateDisplay();
            }
        }

        private void UpdateAnalyticsTab()
        {
            // Update learning velocity chart
            var velocityData = analytics.GetLearningVelocityData();
            learningVelocityChart.UpdateData(velocityData);

            // Update topic mastery chart
            var masteryData = analytics.GetTopicMasteryData();
            topicMasteryChart.UpdateData(masteryData);

            // Update interaction heatmap
            var heatmapData = analytics.GetDailyInteractionData();
            interactionHeatmap.UpdateData(heatmapData);
        }

        private void UpdateAssessmentTab()
        {
            // Update competency matrix
            UpdateCompetencyMatrix();

            // Update assessment history
            UpdateAssessmentHistory();
        }

        private void UpdateRecommendationsTab()
        {
            // Generate personalized learning plan
            var learningPlan = GeneratePersonalizedPlan();
            personalizedPlan.Text = learningPlan;

            // Generate smart recommendations
            UpdateSmartRecommendations();
        }

        private float CalculateOverallProgress()
        {
            var specialtyCount = Enum.GetValues<NPCSpecialty>().Length;
            var totalProgress = 0f;

            foreach (NPCSpecialty specialty in Enum.GetValues<NPCSpecialty>())
            {
                totalProgress += analytics.GetSpecialtyProgress(specialty);
            }

            return totalProgress / specialtyCount;
        }

        private void UpdateAchievements()
        {
            // Clear existing achievements
            foreach (Node child in achievementGrid.GetChildren())
            {
                child.QueueFree();
            }

            var achievements = analytics.GetRecentAchievements();
            foreach (var achievement in achievements.Take(8)) // Show up to 8 recent achievements
            {
                var achievementBadge = CreateAchievementBadge(achievement);
                achievementGrid.AddChild(achievementBadge);
            }
        }

        private Control CreateAchievementBadge(Achievement achievement)
        {
            var badge = new VBoxContainer();
            badge.CustomMinimumSize = new Vector2(120, 100);

            var iconLabel = new Label();
            iconLabel.Text = achievement.Icon;
            iconLabel.HorizontalAlignment = HorizontalAlignment.Center;
            badge.AddChild(iconLabel);

            var nameLabel = new Label();
            nameLabel.Text = achievement.Name;
            nameLabel.HorizontalAlignment = HorizontalAlignment.Center;
            nameLabel.AutowrapMode = TextServer.AutowrapMode.WordSmart;
            badge.AddChild(nameLabel);

            var dateLabel = new Label();
            dateLabel.Text = achievement.DateEarned.ToString("MMM dd");
            dateLabel.HorizontalAlignment = HorizontalAlignment.Center;
            badge.AddChild(dateLabel);

            badge.AddThemeStyleboxOverride("normal", CreateAchievementBadgeStyle());
            return badge;
        }

        private void UpdateRecentActivity()
        {
            // Clear existing activity
            foreach (Node child in recentActivityList.GetChildren())
            {
                child.QueueFree();
            }

            var recentActivities = analytics.GetRecentActivities().Take(10);
            foreach (var activity in recentActivities)
            {
                var activityItem = CreateActivityItem(activity);
                recentActivityList.AddChild(activityItem);
            }
        }

        private Control CreateActivityItem(LearningActivity activity)
        {
            var item = new HBoxContainer();
            item.CustomMinimumSize = new Vector2(0, 40);

            var timeLabel = new Label();
            timeLabel.Text = activity.Timestamp.ToString("HH:mm");
            timeLabel.CustomMinimumSize = new Vector2(60, 0);
            item.AddChild(timeLabel);

            var iconLabel = new Label();
            iconLabel.Text = GetActivityIcon(activity.Type);
            iconLabel.CustomMinimumSize = new Vector2(30, 0);
            item.AddChild(iconLabel);

            var descriptionLabel = new Label();
            descriptionLabel.Text = activity.Description;
            descriptionLabel.AutowrapMode = TextServer.AutowrapMode.WordSmart;
            item.AddChild(descriptionLabel);

            return item;
        }

        private void UpdateCompetencyMatrix()
        {
            // Clear existing matrix
            foreach (Node child in competencyMatrix.GetChildren())
            {
                child.QueueFree();
            }

            foreach (NPCSpecialty specialty in Enum.GetValues<NPCSpecialty>())
            {
                var competencyCard = CreateCompetencyCard(specialty);
                competencyMatrix.AddChild(competencyCard);
            }
        }

        private Control CreateCompetencyCard(NPCSpecialty specialty)
        {
            var card = new VBoxContainer();
            card.CustomMinimumSize = new Vector2(200, 150);

            var nameLabel = new Label();
            nameLabel.Text = GetSpecialtyDisplayName(specialty);
            nameLabel.HorizontalAlignment = HorizontalAlignment.Center;
            card.AddChild(nameLabel);

            var competency = assessmentSystem.GetCompetencyLevel(specialty);
            var competencyBar = new ProgressBar();
            competencyBar.Value = competency * 100;
            competencyBar.ShowPercentage = true;
            card.AddChild(competencyBar);

            var levelLabel = new Label();
            levelLabel.Text = GetCompetencyLevelName(competency);
            levelLabel.HorizontalAlignment = HorizontalAlignment.Center;
            card.AddChild(levelLabel);

            var takeAssessmentButton = new Button();
            takeAssessmentButton.Text = "📝 Assess";
            takeAssessmentButton.Connect("pressed", new Callable(this, nameof(OnAssessmentRequested)).Bind(specialty));
            card.AddChild(takeAssessmentButton);

            card.AddThemeStyleboxOverride("normal", CreateCompetencyCardStyle());
            return card;
        }

        private void UpdateAssessmentHistory()
        {
            // Clear existing history
            foreach (Node child in assessmentHistory.GetChildren())
            {
                child.QueueFree();
            }

            var recentAssessments = assessmentSystem.GetRecentAssessments().Take(10);
            foreach (var assessment in recentAssessments)
            {
                var assessmentItem = CreateAssessmentHistoryItem(assessment);
                assessmentHistory.AddChild(assessmentItem);
            }
        }

        private Control CreateAssessmentHistoryItem(AssessmentResult assessment)
        {
            var item = new HBoxContainer();
            item.CustomMinimumSize = new Vector2(0, 50);

            var dateLabel = new Label();
            dateLabel.Text = assessment.CompletedAt.ToString("MMM dd");
            dateLabel.CustomMinimumSize = new Vector2(80, 0);
            item.AddChild(dateLabel);

            var subjectLabel = new Label();
            subjectLabel.Text = GetSpecialtyDisplayName(assessment.Specialty);
            subjectLabel.CustomMinimumSize = new Vector2(150, 0);
            item.AddChild(subjectLabel);

            var scoreLabel = new Label();
            scoreLabel.Text = $"{assessment.Score:F0}%";
            scoreLabel.CustomMinimumSize = new Vector2(60, 0);
            item.AddChild(scoreLabel);

            var gradeLabel = new Label();
            gradeLabel.Text = GetGradeName(assessment.Score);
            gradeLabel.CustomMinimumSize = new Vector2(80, 0);
            item.AddChild(gradeLabel);

            var timeLabel = new Label();
            timeLabel.Text = $"{assessment.Duration.TotalMinutes:F0}m";
            timeLabel.CustomMinimumSize = new Vector2(50, 0);
            item.AddChild(timeLabel);

            return item;
        }

        private string GeneratePersonalizedPlan()
        {
            var weakestAreas = assessmentSystem.GetWeakestAreas(3);
            var strongestAreas = assessmentSystem.GetStrongestAreas(2);
            var recommendedPath = specialistManager.GetRecommendedLearningPath();

            var plan = "[b]🎯 Your Personalized Learning Journey[/b]\n\n";

            plan += "[color=green]    Your Strengths:[/color]\n";
            foreach (var area in strongestAreas)
            {
                plan += $"• {GetSpecialtyDisplayName(area.Specialty)} - {area.Level:F0}% mastery\n";
            }

            plan += "\n[color=orange]📚 Areas for Improvement:[/color]\n";
            foreach (var area in weakestAreas)
            {
                plan += $"• {GetSpecialtyDisplayName(area.Specialty)} - Focus needed\n";
            }

            plan += "\n[color=blue]🛤️ Recommended Next Steps:[/color]\n";
            plan += recommendedPath;

            return plan;
        }

        private void UpdateSmartRecommendations()
        {
            // Clear existing recommendations
            foreach (Node child in recommendationsList.GetChildren())
            {
                child.QueueFree();
            }

            var recommendations = GenerateSmartRecommendations();
            foreach (var recommendation in recommendations)
            {
                var recommendationCard = CreateRecommendationCard(recommendation);
                recommendationsList.AddChild(recommendationCard);
            }
        }

        private List<SmartRecommendation> GenerateSmartRecommendations()
        {
            var recommendations = new List<SmartRecommendation>();

            // Analyze user's learning patterns and generate recommendations
            var learningPattern = analytics.GetLearningPattern();
            var competencyGaps = assessmentSystem.GetCompetencyGaps();
            var interactionHistory = analytics.GetInteractionHistory();

            // Generate recommendations based on patterns
            if (learningPattern.PreferredLearningTime.HasValue)
            {
                recommendations.Add(new SmartRecommendation
                {
                    Type = RecommendationType.OptimalTiming,
                    Title = "⏰ Optimal Learning Time",
                    Description = $"You learn best at {learningPattern.PreferredLearningTime:HH:mm}. Schedule your next session then!",
                    Priority = RecommendationPriority.Medium,
                    ActionSpecialty = null
                });
            }

            // Add more sophisticated recommendations
            return recommendations;
        }

        private Control CreateRecommendationCard(SmartRecommendation recommendation)
        {
            var card = new VBoxContainer();
            card.CustomMinimumSize = new Vector2(400, 120);

            var header = new HBoxContainer();
            card.AddChild(header);

            var titleLabel = new Label();
            titleLabel.Text = recommendation.Title;
            header.AddChild(titleLabel);

            var priorityLabel = new Label();
            priorityLabel.Text = GetPriorityIcon(recommendation.Priority);
            header.AddChild(priorityLabel);

            var descriptionLabel = new Label();
            descriptionLabel.Text = recommendation.Description;
            descriptionLabel.AutowrapMode = TextServer.AutowrapMode.WordSmart;
            card.AddChild(descriptionLabel);

            if (recommendation.ActionSpecialty.HasValue)
            {
                var actionButton = new Button();
                actionButton.Text = "Take Action";
                actionButton.Connect("pressed", new Callable(this, nameof(OnRecommendationActionPressed)).Bind(recommendation.ActionSpecialty.Value));
                card.AddChild(actionButton);
            }

            card.AddThemeStyleboxOverride("normal", CreateRecommendationCardStyle(recommendation.Priority));
            return card;
        }

        // Event handlers
        private void OnSpecialistCardSelected(NPCSpecialty specialty)
        {
            EmitSignal(SignalName.SpecialistFocusRequested, (int)specialty);
        }

        private void OnAssessmentCardRequested(NPCSpecialty specialty)
        {
            EmitSignal(SignalName.AssessmentRequested, (int)specialty);
        }

        private void OnAssessmentRequested(NPCSpecialty specialty)
        {
            EmitSignal(SignalName.AssessmentRequested, (int)specialty);
        }

        private void OnRecommendationActionPressed(NPCSpecialty specialty)
        {
            EmitSignal(SignalName.SpecialistFocusRequested, (int)specialty);
        }

        private void OnBackPressed()
        {
            EmitSignal(SignalName.BackToSelector);
        }

        private void UpdateAllDisplays()
        {
            PopulateAllTabs();
        }

        private void ConnectSignals()
        {
            // Connect any additional signals as needed
        }

        private void LoadSpecialtyColors()
        {
            specialtyColors = new Dictionary<NPCSpecialty, Color>
            {
                { NPCSpecialty.SoilScience, new Color(0.4f, 0.7f, 0.3f) },
                { NPCSpecialty.PlantBiology, new Color(0.2f, 0.8f, 0.2f) },
                { NPCSpecialty.WaterManagement, new Color(0.2f, 0.6f, 0.9f) },
                { NPCSpecialty.Composting, new Color(0.6f, 0.4f, 0.2f) },
                { NPCSpecialty.PestManagement, new Color(0.8f, 0.3f, 0.6f) },
                { NPCSpecialty.Permaculture, new Color(0.5f, 0.7f, 0.3f) },
                { NPCSpecialty.GeneralAgriculture, new Color(0.7f, 0.6f, 0.2f) }
            };
        }

        // Utility methods
        private string GetSpecialtyDisplayName(NPCSpecialty specialty)
        {
            return specialty switch
            {
                NPCSpecialty.SoilScience => "Soil Science",
                NPCSpecialty.PlantBiology => "Plant Biology",
                NPCSpecialty.WaterManagement => "Water Management",
                NPCSpecialty.Composting => "Composting",
                NPCSpecialty.PestManagement => "Pest Management",
                NPCSpecialty.Permaculture => "Permaculture",
                NPCSpecialty.GeneralAgriculture => "General Agriculture",
                _ => specialty.ToString()
            };
        }

        private string GetCompetencyLevelName(float competency)
        {
            return competency switch
            {
                >= 0.9f => "🏆 Expert",
                >= 0.7f => "🎓 Advanced",
                >= 0.5f => "📚 Intermediate",
                >= 0.3f => "🌱 Beginner",
                _ => "🆕 Novice"
            };
        }

        private string GetGradeName(float score)
        {
            return score switch
            {
                >= 90 => "A+",
                >= 85 => "A",
                >= 80 => "A-",
                >= 75 => "B+",
                >= 70 => "B",
                >= 65 => "B-",
                >= 60 => "C+",
                >= 55 => "C",
                _ => "F"
            };
        }

        private string GetActivityIcon(LearningActivityType type)
        {
            return type switch
            {
                LearningActivityType.Conversation => "      ",
                LearningActivityType.Assessment => "📝",
                LearningActivityType.SpecialistReferral => "🔗",
                LearningActivityType.AchievementUnlocked => "🏆",
                _ => "📚"
            };
        }

        private string GetPriorityIcon(RecommendationPriority priority)
        {
            return priority switch
            {
                RecommendationPriority.High => "🔴",
                RecommendationPriority.Medium => "🟡",
                RecommendationPriority.Low => "🟢",
                _ => "⚪"
            };
        }

        // Style creation methods
        private StyleBoxFlat CreateHeaderStyle()
        {
            var style = new StyleBoxFlat();
            style.BgColor = new Color(0.2f, 0.4f, 0.6f);
            style.SetCornerRadiusAll(8);
            style.SetContentMarginAll(10);
            return style;
        }

        private StyleBoxFlat CreateSectionHeaderStyle()
        {
            var style = new StyleBoxFlat();
            style.BgColor = new Color(0.15f, 0.15f, 0.15f);
            style.SetCornerRadiusAll(6);
            style.SetContentMarginAll(8);
            return style;
        }

        private StyleBoxFlat CreateAchievementBadgeStyle()
        {
            var style = new StyleBoxFlat();
            style.BgColor = new Color(0.3f, 0.3f, 0.35f);
            style.SetCornerRadiusAll(8);
            style.BorderWidthTop = 2;
            style.BorderColor = new Color(0.6f, 0.6f, 0.7f);
            return style;
        }

        private StyleBoxFlat CreateCompetencyCardStyle()
        {
            var style = new StyleBoxFlat();
            style.BgColor = new Color(0.25f, 0.25f, 0.3f);
            style.SetCornerRadiusAll(8);
            style.SetContentMarginAll(8);
            return style;
        }

        private StyleBoxFlat CreateRecommendationCardStyle(RecommendationPriority priority)
        {
            var style = new StyleBoxFlat();
            style.BgColor = priority switch
            {
                RecommendationPriority.High => new Color(0.4f, 0.2f, 0.2f),
                RecommendationPriority.Medium => new Color(0.4f, 0.3f, 0.2f),
                RecommendationPriority.Low => new Color(0.2f, 0.4f, 0.2f),
                _ => new Color(0.3f, 0.3f, 0.3f)
            };
            style.SetCornerRadiusAll(6);
            style.SetContentMarginAll(8);
            return style;
        }
    }

    // Supporting classes for the dashboard
    public partial class SpecialistProgressCard : Control
    {
        [Signal]
        public delegate void SpecialistSelectedEventHandler(NPCSpecialty specialty);

        [Signal]
        public delegate void AssessmentRequestedEventHandler(NPCSpecialty specialty);

        private NPCSpecialty specialty;
        private ConversationAnalytics analytics;
        private LearningAssessmentSystem assessmentSystem;

        // UI Components
        private Label nameLabel;
        private ProgressBar progressBar;
        private Label sessionCountLabel;
        private Label lastInteractionLabel;
        private Button consultButton;
        private Button assessButton;

        public void Setup(NPCSpecialty specialty, ConversationAnalytics analytics, LearningAssessmentSystem assessmentSystem)
        {
            this.specialty = specialty;
            this.analytics = analytics;
            this.assessmentSystem = assessmentSystem;

            CreateLayout();
            UpdateDisplay();
        }

        private void CreateLayout()
        {
            CustomMinimumSize = new Vector2(600, 100);

            var container = new HBoxContainer();
            AddChild(container);

            // Info section
            var infoSection = new VBoxContainer();
            container.AddChild(infoSection);

            nameLabel = new Label();
            infoSection.AddChild(nameLabel);

            progressBar = new ProgressBar();
            progressBar.CustomMinimumSize = new Vector2(300, 20);
            progressBar.ShowPercentage = true;
            infoSection.AddChild(progressBar);

            // Stats section
            var statsSection = new VBoxContainer();
            container.AddChild(statsSection);

            sessionCountLabel = new Label();
            lastInteractionLabel = new Label();
            statsSection.AddChild(sessionCountLabel);
            statsSection.AddChild(lastInteractionLabel);

            // Actions section
            var actionsSection = new VBoxContainer();
            container.AddChild(actionsSection);

            consultButton = new Button();
            consultButton.Text = "       Consult";
            consultButton.Connect("pressed", new Callable(this, nameof(OnConsultPressed)));
            actionsSection.AddChild(consultButton);

            assessButton = new Button();
            assessButton.Text = "📝 Assess";
            assessButton.Connect("pressed", new Callable(this, nameof(OnAssessPressed)));
            actionsSection.AddChild(assessButton);
        }

        public void UpdateDisplay()
        {
            nameLabel.Text = GetSpecialtyDisplayName(specialty);

            var progress = analytics.GetSpecialtyProgress(specialty);
            progressBar.Value = progress * 100;

            var stats = analytics.GetSpecialistStats(specialty);
            sessionCountLabel.Text = $"Sessions: {stats.SessionCount}";
            lastInteractionLabel.Text = $"Last: {stats.LastInteraction:MMM dd}";

            assessButton.Disabled = stats.SessionCount == 0;
        }

        private void OnConsultPressed()
        {
            EmitSignal(SignalName.SpecialistSelected, (int)specialty);
        }

        private void OnAssessPressed()
        {
            EmitSignal(SignalName.AssessmentRequested, (int)specialty);
        }

        private string GetSpecialtyDisplayName(NPCSpecialty specialty)
        {
            return specialty switch
            {
                NPCSpecialty.SoilScience => "🌱 Soil Science",
                NPCSpecialty.PlantBiology => "🌿 Plant Biology",
                NPCSpecialty.WaterManagement => "💧 Water Management",
                NPCSpecialty.Composting => "♻️ Composting",
                NPCSpecialty.PestManagement => "🐛 Pest Management",
                NPCSpecialty.Permaculture => "🌳 Permaculture",
                NPCSpecialty.GeneralAgriculture => "🚜 General Agriculture",
                _ => specialty.ToString()
            };
        }
    }

    // Custom chart controls (simplified implementations)
    public partial class CircularProgressDisplay : Control
    {
        private float progress = 0f;
        private Label percentageLabel;

        public override void _Ready()
        {
            percentageLabel = new Label();
            percentageLabel.HorizontalAlignment = HorizontalAlignment.Center;
            percentageLabel.VerticalAlignment = VerticalAlignment.Center;
            AddChild(percentageLabel);
        }

        public void UpdateProgress(float newProgress)
        {
            progress = Math.Clamp(newProgress, 0f, 1f);
            percentageLabel.Text = $"{progress * 100:F0}%\nOverall Progress";
            QueueRedraw();
        }

        public override void _Draw()
        {
            var center = Size / 2;
            var radius = Math.Min(Size.X, Size.Y) / 2 - 10;

            // Background circle
            DrawArc(center, radius, 0, Mathf.Tau, 64, Colors.DarkGray, 8);

            // Progress arc
            var endAngle = progress * Mathf.Tau - Mathf.Pi / 2;
            DrawArc(center, radius, -Mathf.Pi / 2, endAngle, 64, Colors.Green, 8);
        }
    }

    public partial class LineChart : Control
    {
        private List<Vector2> dataPoints = new List<Vector2>();

        public void UpdateData(List<Vector2> newData)
        {
            dataPoints = newData;
            QueueRedraw();
        }

        public override void _Draw()
        {
            if (dataPoints.Count < 2) return;

            for (int i = 0; i < dataPoints.Count - 1; i++)
            {
                var start = new Vector2(
                    dataPoints[i].X * Size.X,
                    Size.Y - (dataPoints[i].Y * Size.Y)
                );
                var end = new Vector2(
                    dataPoints[i + 1].X * Size.X,
                    Size.Y - (dataPoints[i + 1].Y * Size.Y)
                );
                DrawLine(start, end, Colors.Blue, 2);
            }
        }
    }

    public partial class BarChart : Control
    {
        private Dictionary<string, float> barData = new Dictionary<string, float>();

        public void UpdateData(Dictionary<string, float> newData)
        {
            barData = newData;
            QueueRedraw();
        }

        public override void _Draw()
        {
            if (barData.Count == 0) return;

            var barWidth = Size.X / barData.Count;
            var maxValue = barData.Values.Max();
            var x = 0f;

            foreach (var kvp in barData)
            {
                var height = (kvp.Value / maxValue) * Size.Y;
                var rect = new Rect2(x, Size.Y - height, barWidth - 2, height);
                DrawRect(rect, Colors.Blue);
                x += barWidth;
            }
        }
    }

    public partial class HeatMapDisplay : Control
    {
        private Dictionary<Vector2, float> heatmapData = new Dictionary<Vector2, float>();

        public void UpdateData(Dictionary<Vector2, float> newData)
        {
            heatmapData = newData;
            QueueRedraw();
        }

        public override void _Draw()
        {
            // Simplified heatmap visualization
            var cellSize = new Vector2(Size.X / 7, Size.Y / 24); // 7 days, 24 hours

            foreach (var kvp in heatmapData)
            {
                var pos = new Vector2(kvp.Key.X * cellSize.X, kvp.Key.Y * cellSize.Y);
                var intensity = kvp.Value;
                var color = new Color(intensity, intensity * 0.5f, 0, intensity);
                DrawRect(new Rect2(pos, cellSize), color);
            }
        }
    }

    // Data structures for dashboard functionality
    public class Achievement
    {
        public string Name { get; set; }
        public string Icon { get; set; }
        public DateTime DateEarned { get; set; }
        public string Description { get; set; }
    }

    public class LearningActivity
    {
        public DateTime Timestamp { get; set; }
        public LearningActivityType Type { get; set; }
        public string Description { get; set; }
        public NPCSpecialty? Specialty { get; set; }
    }

    public class SmartRecommendation
    {
        public RecommendationType Type { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public RecommendationPriority Priority { get; set; }
        public NPCSpecialty? ActionSpecialty { get; set; }
    }

    public enum LearningActivityType
    {
        Conversation,
        Assessment,
        SpecialistReferral,
        AchievementUnlocked
    }

    public enum RecommendationType
    {
        OptimalTiming,
        SkillGap,
        SpecialistRecommendation,
        AssessmentSuggestion
    }

    public enum RecommendationPriority
    {
        Low,
        Medium,
        High
    }
}
