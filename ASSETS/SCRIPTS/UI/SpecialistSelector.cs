using Godot;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace LocalLLMNPC.UI
{
    /// <summary>
    /// Comprehensive UI component for selecting and interacting with agricultural specialists.
    /// Designed by Om Choksi for the Multi-Agent Agricultural University Platform.
    /// Provides intuitive interface for specialist selection, progress tracking, and analytics.
    /// </summary>
    public partial class SpecialistSelector : Control
    {
        [Signal]
        public delegate void SpecialistSelectedEventHandler(NPCSpecialty specialty);

        [Signal]
        public delegate void AssessmentRequestedEventHandler(NPCSpecialty specialty);

        [Signal]
        public delegate void ProgressViewRequestedEventHandler();

        // Enhanced UI Component References
        private GridContainer specialistGrid;
        private VBoxContainer selectedSpecialistInfo;
        private AnimationPlayer uiAnimationPlayer;
        private Tween selectionTween;

        // Modern Progress Displays
        private CircularProgressBar overallProgress;
        private RadialProgressIndicator sessionProgress;
        private ParticleSystem2D selectionParticles;

        // Enhanced Information Display
        private RichTextLabel specialistDescription;
        private GradientButton selectButton;
        private GlowButton assessmentButton;
        private ModernButton progressButton;

        // Status Indicators
        private AnimatedLabel sessionCountLabel;
        private ExpertiseRadar expertiseRadar;
        private AvailabilityIndicator availabilityIndicator;
        private Separator modernSeparator;

        // Visual Enhancement Elements
        private BackgroundGradient backgroundGradient;
        private FloatingIcons floatingIcons;
        private UIGlowEffect glowEffect;
        private SmoothTransitions transitionManager;

        // Enhanced Specialist Cards with Modern Design
        private Dictionary<NPCSpecialty, ModernSpecialistCard> specialistCards;
        private NPCSpecialty? currentlySelected;
        private Vector2 originalCardSize = new Vector2(300, 400);
        private Vector2 expandedCardSize = new Vector2(320, 420);

        // Advanced Analytics Integration
        private ConversationAnalytics analytics;
        private LearningAssessmentSystem assessmentSystem;
        private RealTimeMetrics metricsDisplay;
        private PerformanceVisualizer performanceViz;

        // Enhanced Visual Resources & Themes
        private PackedScene modernSpecialistCardScene;
        private Theme agriculturalTheme;

        // Dynamic Styling System
        private GradientStyleBox selectedCardStyle;
        private AnimatedStyleBox defaultCardStyle;
        private GlowStyleBox hoveredCardStyle;
        private ParticleStyleBox activeCardStyle;

        // Color Schemes & Visual Effects
        private readonly Color PRIMARY_GREEN = new Color(0.2f, 0.7f, 0.3f);
        private readonly Color ACCENT_GOLD = new Color(0.9f, 0.7f, 0.2f);
        private readonly Color BACKGROUND_DARK = new Color(0.1f, 0.15f, 0.1f);
        private readonly Color TEXT_BRIGHT = new Color(0.95f, 0.95f, 0.9f);

        // Animation & Transition Controls
        private float cardHoverScale = 1.05f;
        private float selectionAnimationDuration = 0.3f;
        private Curve easingCurve;

        public override void _Ready()
        {
            InitializeUI();
            LoadSpecialistData();
            ConnectSignals();
            UpdateProgressDisplay();
        }

        private void InitializeUI()
        {
            // Main container setup
            SetAnchorsAndOffsetsPreset(Control.Preset.FullRect);

            // Create main layout
            var mainVBox = new VBoxContainer();
            AddChild(mainVBox);

            // Title section
            var titleLabel = new Label();
            titleLabel.Text = "🏛️ Agricultural University - Select Your Professor";
            titleLabel.AddThemeStyleboxOverride("normal", CreateTitleStyle());
            titleLabel.HorizontalAlignment = HorizontalAlignment.Center;
            mainVBox.AddChild(titleLabel);

            // Progress overview
            CreateProgressSection(mainVBox);

            // Specialist grid
            CreateSpecialistGrid(mainVBox);

            // Selected specialist info panel
            CreateInfoPanel(mainVBox);

            // Analytics and assessment system integration
            analytics = GetNode<ConversationAnalytics>("/root/ConversationAnalytics");
            assessmentSystem = GetNode<LearningAssessmentSystem>("/root/LearningAssessmentSystem");

            // Initialize visual styles
            InitializeStyles();
        }

        private void CreateProgressSection(VBoxContainer parent)
        {
            var progressContainer = new VBoxContainer();
            parent.AddChild(progressContainer);

            var progressLabel = new Label();
            progressLabel.Text = "📊 Overall Learning Progress";
            progressLabel.AddThemeStyleboxOverride("normal", CreateSectionStyle());
            progressContainer.AddChild(progressLabel);

            overallProgress = new ProgressBar();
            overallProgress.CustomMinimumSize = new Vector2(400, 30);
            overallProgress.ShowPercentage = true;
            progressContainer.AddChild(overallProgress);

            progressButton = new Button();
            progressButton.Text = "📈 View Detailed Progress";
            progressButton.CustomMinimumSize = new Vector2(200, 35);
            progressContainer.AddChild(progressButton);
        }

        private void CreateSpecialistGrid(VBoxContainer parent)
        {
            var gridLabel = new Label();
            gridLabel.Text = "👨‍🏫 Choose Your Specialist Professor";
            gridLabel.AddThemeStyleboxOverride("normal", CreateSectionStyle());
            parent.AddChild(gridLabel);

            // Create scrollable container for specialists
            var scrollContainer = new ScrollContainer();
            scrollContainer.CustomMinimumSize = new Vector2(800, 400);
            parent.AddChild(scrollContainer);

            specialistGrid = new GridContainer();
            specialistGrid.Columns = 2;
            specialistGrid.AddThemeConstantOverride("h_separation", 20);
            specialistGrid.AddThemeConstantOverride("v_separation", 20);
            scrollContainer.AddChild(specialistGrid);

            specialistCards = new Dictionary<NPCSpecialty, SpecialistCard>();
        }

        private void CreateInfoPanel(VBoxContainer parent)
        {
            separator = new HSeparator();
            parent.AddChild(separator);

            selectedSpecialistInfo = new VBoxContainer();
            selectedSpecialistInfo.Visible = false;
            parent.AddChild(selectedSpecialistInfo);

            // Specialist details
            var detailsContainer = new HBoxContainer();
            selectedSpecialistInfo.AddChild(detailsContainer);

            // Left side - Description
            var leftPanel = new VBoxContainer();
            leftPanel.CustomMinimumSize = new Vector2(500, 0);
            detailsContainer.AddChild(leftPanel);

            specialistDescription = new RichTextLabel();
            specialistDescription.CustomMinimumSize = new Vector2(480, 150);
            specialistDescription.BbcodeEnabled = true;
            specialistDescription.FitContent = true;
            leftPanel.AddChild(specialistDescription);

            // Right side - Stats and actions
            var rightPanel = new VBoxContainer();
            rightPanel.CustomMinimumSize = new Vector2(250, 0);
            detailsContainer.AddChild(rightPanel);

            expertiseLabel = new Label();
            sessionCountLabel = new Label();
            availabilityLabel = new Label();

            rightPanel.AddChild(expertiseLabel);
            rightPanel.AddChild(sessionCountLabel);
            rightPanel.AddChild(availabilityLabel);

            // Action buttons
            var buttonContainer = new HBoxContainer();
            selectedSpecialistInfo.AddChild(buttonContainer);

            selectButton = new Button();
            selectButton.Text = "🗣️ Start Conversation";
            selectButton.CustomMinimumSize = new Vector2(180, 40);
            selectButton.AddThemeStyleboxOverride("normal", CreateActionButtonStyle());

            assessmentButton = new Button();
            assessmentButton.Text = "📝 Take Assessment";
            assessmentButton.CustomMinimumSize = new Vector2(180, 40);
            assessmentButton.AddThemeStyleboxOverride("normal", CreateAssessmentButtonStyle());

            buttonContainer.AddChild(selectButton);
            buttonContainer.AddChild(assessmentButton);
        }

        private void LoadSpecialistData()
        {
            var specialistData = new Dictionary<NPCSpecialty, SpecialistInfo>
            {
                {
                    NPCSpecialty.SoilScience,
                    new SpecialistInfo
                    {
                        Name = "🌱 Dr. Terra Firma",
                        Title = "Soil Science Professor",
                        Expertise = "Soil Microbiome Expert",
                        Experience = "20 years",
                        Icon = "🧪",
                        Color = new Color(0.4f, 0.7f, 0.3f),
                        Description = "[b]Soil Science Specialist[/b]\n\n" +
                                     "Dr. Terra Firma brings two decades of soil science expertise to our agricultural university. " +
                                     "Her deep understanding of soil microbiomes, nutrient cycling, and carbon sequestration makes her " +
                                     "the go-to expert for all soil-related questions.\n\n" +
                                     "[color=green]🔬 Specializations:[/color]\n" +
                                     "• Soil microorganism interactions\n" +
                                     "• pH management and testing\n" +
                                     "• Nutrient cycling optimization\n" +
                                     "• Carbon sequestration strategies\n" +
                                     "• Soil health assessment\n\n" +
                                     "[color=blue]🤝 Collaborates with:[/color] Composting, Plant Biology, Water Management"
                    }
                },
                {
                    NPCSpecialty.PlantBiology,
                    new SpecialistInfo
                    {
                        Name = "🌿 Dr. Flora Verde",
                        Title = "Plant Biology Professor",
                        Expertise = "Plant Physiology Expert",
                        Experience = "18 years",
                        Icon = "🔬",
                        Color = new Color(0.2f, 0.8f, 0.2f),
                        Description = "[b]Plant Biology Specialist[/b]\n\n" +
                                     "Dr. Flora Verde is our resident plant biology expert with extensive research in photosynthesis, " +
                                     "plant anatomy, and genetics. Her microscopic observation skills and growth experiment designs " +
                                     "help students understand the intricate world of plant science.\n\n" +
                                     "[color=green]🔬 Specializations:[/color]\n" +
                                     "• Photosynthesis optimization\n" +
                                     "• Plant hormone regulation\n" +
                                     "• Genetic plant breeding\n" +
                                     "• Disease diagnosis and treatment\n" +
                                     "• Plant anatomy and physiology\n\n" +
                                     "[color=blue]🤝 Collaborates with:[/color] Soil Science, Water Management, Pest Management"
                    }
                },
                {
                    NPCSpecialty.WaterManagement,
                    new SpecialistInfo
                    {
                        Name = "💧 Hydro Henderson",
                        Title = "Water Management Consultant",
                        Expertise = "Irrigation Systems Expert",
                        Experience = "15 years",
                        Icon = "💧",
                        Color = new Color(0.2f, 0.6f, 0.9f),
                        Description = "[b]Water Management Specialist[/b]\n\n" +
                                     "Hydro Henderson specializes in efficient water use, irrigation system design, and conservation strategies. " +
                                     "With expertise in both traditional and hydroponic systems, Henderson helps optimize water resources for " +
                                     "maximum agricultural productivity.\n\n" +
                                     "[color=green]🔬 Specializations:[/color]\n" +
                                     "• Drip irrigation design\n" +
                                     "• Water conservation strategies\n" +
                                     "• Hydroponic system setup\n" +
                                     "• Rainwater harvesting\n" +
                                     "• Drought management planning\n\n" +
                                     "[color=blue]🤝 Collaborates with:[/color] Soil Science, Plant Biology, Permaculture"
                    }
                },
                {
                    NPCSpecialty.Composting,
                    new SpecialistInfo
                    {
                        Name = "♻️ Compost Carl",
                        Title = "Composting Master",
                        Expertise = "Organic Matter Expert",
                        Experience = "22 years",
                        Icon = "♻️",
                        Color = new Color(0.6f, 0.4f, 0.2f),
                        Description = "[b]Composting Specialist[/b]\n\n" +
                                     "Compost Carl is the master of all things decomposition! With over two decades perfecting the art " +
                                     "and science of composting, Carl understands every aspect from thermophilic processes to " +
                                     "vermicomposting systems.\n\n" +
                                     "[color=green]🔬 Specializations:[/color]\n" +
                                     "• Thermophilic composting systems\n" +
                                     "• Vermicomposting optimization\n" +
                                     "• Bokashi fermentation\n" +
                                     "• C:N ratio management\n" +
                                     "• Large-scale waste processing\n\n" +
                                     "[color=blue]🤝 Collaborates with:[/color] Soil Science, Pest Management, Permaculture"
                    }
                },
                {
                    NPCSpecialty.PestManagement,
                    new SpecialistInfo
                    {
                        Name = "🐛 Dr. Beneficial Betty",
                        Title = "IPM Research Specialist",
                        Expertise = "Biological Controls Expert",
                        Experience = "16 years",
                        Icon = "🐞",
                        Color = new Color(0.8f, 0.3f, 0.6f),
                        Description = "[b]Integrated Pest Management Specialist[/b]\n\n" +
                                     "Dr. Beneficial Betty revolutionizes pest management through biological controls and beneficial insect " +
                                     "habitat creation. Her ecosystem-based approach minimizes pesticide use while maximizing agricultural " +
                                     "productivity through natural predator-prey relationships.\n\n" +
                                     "[color=green]🔬 Specializations:[/color]\n" +
                                     "• Beneficial insect identification\n" +
                                     "• Biological control implementation\n" +
                                     "• Natural pesticide formulation\n" +
                                     "• Habitat creation for predators\n" +
                                     "• IPM system design\n\n" +
                                     "[color=blue]🤝 Collaborates with:[/color] Plant Biology, Soil Science, Permaculture"
                    }
                },
                {
                    NPCSpecialty.Permaculture,
                    new SpecialistInfo
                    {
                        Name = "🌳 Perma Pete",
                        Title = "Permaculture Design Master",
                        Expertise = "Regenerative Systems Expert",
                        Experience = "25 years",
                        Icon = "🌳",
                        Color = new Color(0.5f, 0.7f, 0.3f),
                        Description = "[b]Permaculture Design Specialist[/b]\n\n" +
                                     "Perma Pete is the visionary behind sustainable food systems and regenerative design. With a quarter-century " +
                                     "of experience creating food forests and polyculture systems, Pete helps design closed-loop agricultural " +
                                     "ecosystems that work with nature.\n\n" +
                                     "[color=green]🔬 Specializations:[/color]\n" +
                                     "• Food forest design\n" +
                                     "• Polyculture guild creation\n" +
                                     "• Regenerative farming systems\n" +
                                     "• Closed-loop design\n" +
                                     "• Pattern recognition and zoning\n\n" +
                                     "[color=blue]🤝 Collaborates with:[/color] All specialists for integrated approaches"
                    }
                },
                {
                    NPCSpecialty.GeneralAgriculture,
                    new SpecialistInfo
                    {
                        Name = "🚜 Professor Green Thumb",
                        Title = "General Agriculture Coordinator",
                        Expertise = "Farm Management Expert",
                        Experience = "30 years",
                        Icon = "🚜",
                        Color = new Color(0.7f, 0.6f, 0.2f),
                        Description = "[b]General Agriculture Coordinator[/b]\n\n" +
                                     "Professor Green Thumb serves as the welcoming gateway to our agricultural university. With three decades " +
                                     "of comprehensive farming experience, the Professor helps newcomers find their path and coordinates " +
                                     "learning across all agricultural specialties.\n\n" +
                                     "[color=green]🔬 Specializations:[/color]\n" +
                                     "• Beginning farmer guidance\n" +
                                     "• Crop planning and rotation\n" +
                                     "• Farm economics and management\n" +
                                     "• Sustainable farming practices\n" +
                                     "• Educational pathway coordination\n\n" +
                                     "[color=blue]🤝 Collaborates with:[/color] Refers to appropriate specialists based on student needs"
                    }
                }
            };

            // Create specialist cards
            foreach (var specialist in specialistData)
            {
                CreateSpecialistCard(specialist.Key, specialist.Value);
            }
        }

        private void CreateSpecialistCard(NPCSpecialty specialty, SpecialistInfo info)
        {
            var card = new SpecialistCard();
            card.Setup(specialty, info);
            card.CustomMinimumSize = new Vector2(350, 180);

            // Connect card selection
            card.Connect("pressed", new Callable(this, nameof(OnSpecialistCardSelected)).Bind(specialty));
            card.Connect("mouse_entered", new Callable(this, nameof(OnCardHovered)).Bind(specialty));
            card.Connect("mouse_exited", new Callable(this, nameof(OnCardUnhovered)).Bind(specialty));

            specialistCards[specialty] = card;
            specialistGrid.AddChild(card);
        }

        private void ConnectSignals()
        {
            selectButton.Connect("pressed", new Callable(this, nameof(OnSelectPressed)));
            assessmentButton.Connect("pressed", new Callable(this, nameof(OnAssessmentPressed)));
            progressButton.Connect("pressed", new Callable(this, nameof(OnProgressPressed)));
        }

        private void UpdateProgressDisplay()
        {
            // Calculate overall progress from analytics
            var totalInteractions = analytics.GetTotalInteractions();
            var completedAssessments = assessmentSystem.GetCompletedAssessments();

            var progressPercent = Math.Min(100, (totalInteractions * 2 + completedAssessments * 10));
            overallProgress.Value = progressPercent;

            // Update specialist card progress indicators
            foreach (var card in specialistCards)
            {
                var specialtyProgress = analytics.GetSpecialtyProgress(card.Key);
                card.Value.UpdateProgress(specialtyProgress);
            }
        }

        private void OnSpecialistCardSelected(NPCSpecialty specialty)
        {
            // Update selection visual state
            if (currentlySelected.HasValue)
            {
                specialistCards[currentlySelected.Value].SetSelected(false);
            }

            currentlySelected = specialty;
            specialistCards[specialty].SetSelected(true);

            // Update info panel
            UpdateSpecialistInfo(specialty);
            selectedSpecialistInfo.Visible = true;
        }

        private void OnCardHovered(NPCSpecialty specialty)
        {
            specialistCards[specialty].SetHovered(true);
        }

        private void OnCardUnhovered(NPCSpecialty specialty)
        {
            specialistCards[specialty].SetHovered(false);
        }

        private void UpdateSpecialistInfo(NPCSpecialty specialty)
        {
            var specialistData = GetSpecialistData(specialty);
            var stats = analytics.GetSpecialistStats(specialty);

            specialistDescription.Text = specialistData.Description;
            expertiseLabel.Text = $"🎓 {specialistData.Expertise} ({specialistData.Experience})";
            sessionCountLabel.Text = $"       Sessions: {stats.SessionCount}";
            availabilityLabel.Text = $"⚡ Response Time: {GetResponseTimeEstimate(specialty)}";

            // Update button states based on progress
            var hasInteracted = stats.SessionCount > 0;
            assessmentButton.Disabled = !hasInteracted;
            assessmentButton.TooltipText = hasInteracted ?
                "Take assessment to test your knowledge" :
                "Have a conversation first before taking assessment";
        }

        private void OnSelectPressed()
        {
            if (currentlySelected.HasValue)
            {
                EmitSignal(SignalName.SpecialistSelected, (int)currentlySelected.Value);
            }
        }

        private void OnAssessmentPressed()
        {
            if (currentlySelected.HasValue)
            {
                EmitSignal(SignalName.AssessmentRequested, (int)currentlySelected.Value);
            }
        }

        private void OnProgressPressed()
        {
            EmitSignal(SignalName.ProgressViewRequested);
        }

        private string GetResponseTimeEstimate(NPCSpecialty specialty)
        {
            // Simulate AI response time estimation based on complexity
            var responseTime = specialty switch
            {
                NPCSpecialty.GeneralAgriculture => "~2s",
                NPCSpecialty.SoilScience or NPCSpecialty.PlantBiology => "~3s",
                NPCSpecialty.WaterManagement or NPCSpecialty.Composting => "~4s",
                NPCSpecialty.PestManagement or NPCSpecialty.Permaculture => "~5s",
                _ => "~3s"
            };
            return responseTime;
        }

        private SpecialistInfo GetSpecialistData(NPCSpecialty specialty)
        {
            // Return corresponding specialist data
            // This would be populated from the LoadSpecialistData method
            return new SpecialistInfo(); // Placeholder
        }

        private StyleBoxFlat CreateTitleStyle()
        {
            var style = new StyleBoxFlat();
            style.BgColor = new Color(0.2f, 0.4f, 0.6f);
            style.SetCornerRadiusAll(8);
            style.SetContentMarginAll(10);
            return style;
        }

        private StyleBoxFlat CreateSectionStyle()
        {
            var style = new StyleBoxFlat();
            style.BgColor = new Color(0.15f, 0.15f, 0.15f);
            style.SetCornerRadiusAll(6);
            style.SetContentMarginAll(8);
            return style;
        }

        private StyleBoxFlat CreateActionButtonStyle()
        {
            var style = new StyleBoxFlat();
            style.BgColor = new Color(0.3f, 0.7f, 0.3f);
            style.SetCornerRadiusAll(5);
            style.SetContentMarginAll(8);
            return style;
        }

        private StyleBoxFlat CreateAssessmentButtonStyle()
        {
            var style = new StyleBoxFlat();
            style.BgColor = new Color(0.6f, 0.4f, 0.8f);
            style.SetCornerRadiusAll(5);
            style.SetContentMarginAll(8);
            return style;
        }

        private void InitializeStyles()
        {
            selectedCardStyle = new StyleBoxFlat();
            selectedCardStyle.BgColor = new Color(0.4f, 0.6f, 0.8f, 0.8f);
            selectedCardStyle.SetCornerRadiusAll(8);
            selectedCardStyle.BorderWidthTop = 3;
            selectedCardStyle.BorderWidthBottom = 3;
            selectedCardStyle.BorderWidthLeft = 3;
            selectedCardStyle.BorderWidthRight = 3;
            selectedCardStyle.BorderColor = new Color(0.6f, 0.8f, 1.0f);

            defaultCardStyle = new StyleBoxFlat();
            defaultCardStyle.BgColor = new Color(0.2f, 0.2f, 0.25f);
            defaultCardStyle.SetCornerRadiusAll(8);

            hoveredCardStyle = new StyleBoxFlat();
            hoveredCardStyle.BgColor = new Color(0.3f, 0.3f, 0.35f);
            hoveredCardStyle.SetCornerRadiusAll(8);
        }
    }

    /// <summary>
    /// Individual specialist card component for the selector interface
    /// </summary>
    public partial class SpecialistCard : Button
    {
        private NPCSpecialty specialty;
        private SpecialistInfo info;
        private ProgressBar progressBar;
        private Label nameLabel;
        private Label titleLabel;
        private Label iconLabel;
        private bool isSelected;
        private bool isHovered;

        public void Setup(NPCSpecialty specialty, SpecialistInfo info)
        {
            this.specialty = specialty;
            this.info = info;

            CreateCardLayout();
            UpdateVisuals();
        }

        private void CreateCardLayout()
        {
            var vbox = new VBoxContainer();
            AddChild(vbox);

            // Header with icon and name
            var header = new HBoxContainer();
            vbox.AddChild(header);

            iconLabel = new Label();
            iconLabel.Text = info.Icon;
            iconLabel.AddThemeStyleboxOverride("normal", new StyleBoxFlat());
            header.AddChild(iconLabel);

            var nameContainer = new VBoxContainer();
            header.AddChild(nameContainer);

            nameLabel = new Label();
            nameLabel.Text = info.Name;
            nameLabel.AddThemeStyleboxOverride("normal", new StyleBoxFlat());
            nameContainer.AddChild(nameLabel);

            titleLabel = new Label();
            titleLabel.Text = info.Title;
            titleLabel.AddThemeStyleboxOverride("normal", new StyleBoxFlat());
            nameContainer.AddChild(titleLabel);

            // Progress indicator
            progressBar = new ProgressBar();
            progressBar.CustomMinimumSize = new Vector2(300, 8);
            progressBar.ShowPercentage = false;
            vbox.AddChild(progressBar);

            // Experience label
            var expLabel = new Label();
            expLabel.Text = $"Experience: {info.Experience}";
            expLabel.HorizontalAlignment = HorizontalAlignment.Center;
            vbox.AddChild(expLabel);
        }

        private void UpdateVisuals()
        {
            Modulate = info.Color;
        }

        public void UpdateProgress(float progress)
        {
            progressBar.Value = progress * 100;
        }

        public void SetSelected(bool selected)
        {
            isSelected = selected;
            UpdateCardStyle();
        }

        public void SetHovered(bool hovered)
        {
            isHovered = hovered;
            UpdateCardStyle();
        }

        private void UpdateCardStyle()
        {
            if (isSelected)
            {
                // Apply selected style
                Modulate = new Color(1.2f, 1.2f, 1.2f);
            }
            else if (isHovered)
            {
                // Apply hovered style
                Modulate = new Color(1.1f, 1.1f, 1.1f);
            }
            else
            {
                // Apply default style
                Modulate = info.Color;
            }
        }
    }

    /// <summary>
    /// Data structure for specialist information display
    /// </summary>
    public class SpecialistInfo
    {
        public string Name { get; set; }
        public string Title { get; set; }
        public string Expertise { get; set; }
        public string Experience { get; set; }
        public string Icon { get; set; }
        public Color Color { get; set; }
        public string Description { get; set; }
    }
}
