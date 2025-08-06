using Godot;
using LocalLLMNPC;

namespace LocalLLMNPC.UI
{
    /// <summary>
    /// Simplified Specialist Selector for basic functionality
    /// </summary>
    public partial class SimpleSpecialistSelector : Control
    {
        [Signal] public delegate void SpecialistSelectedEventHandler(string specialtyName);

        private VBoxContainer mainContainer;
        private Label titleLabel;
        private GridContainer specialistGrid;

        public override void _Ready()
        {
            SetupUI();
            PopulateSpecialists();
        }

        private void SetupUI()
        {
            mainContainer = new VBoxContainer();
            AddChild(mainContainer);

            titleLabel = new Label();
            titleLabel.Text = "🌾 Agricultural Specialists";
            titleLabel.AddThemeStyleboxOverride("normal", new StyleBoxFlat());
            mainContainer.AddChild(titleLabel);

            specialistGrid = new GridContainer();
            specialistGrid.Columns = 3;
            mainContainer.AddChild(specialistGrid);
        }

        private void PopulateSpecialists()
        {
            var specialties = new NPCSpecialty[]
            {
                NPCSpecialty.AgricultureSpecialist,
                NPCSpecialty.CropSpecialist,
                NPCSpecialty.LivestockSpecialist,
                NPCSpecialty.SoilSpecialist,
                NPCSpecialty.PlantPathologist,
                NPCSpecialty.Entomologist
            };

            foreach (var specialty in specialties)
            {
                var button = new Button();
                button.Text = specialty.ToString();
                button.Pressed += () => OnSpecialistSelected(specialty);
                specialistGrid.AddChild(button);
            }
        }

        private void OnSpecialistSelected(NPCSpecialty specialty)
        {
            EmitSignal(SignalName.SpecialistSelected, specialty.ToString());
        }
    }
}
