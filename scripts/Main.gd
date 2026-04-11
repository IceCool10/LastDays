extends Node2D

# 1. References to your new Nodes
@onready var family_nodes = {
    "father": $Family/Father,
    "mother": $Family/Mother,
    "son": $Family/Son,
    "daughter": $Family/Daughter
}

@onready var foodLabel = $CanvasLayer/ResourcesHBox/FoodLabel
@onready var waterLabel = $CanvasLayer/ResourcesHBox/WaterLabel
@onready var nextDayButton = $CanvasLayer/NextDayButton
@onready var diaryUI = $DiaryUI
@onready var diaryText = $DiaryUI/RichTextLabel # Ensure you have this child!

# 2. Game Variables
var day := 1
var food := 10
var water := 10

func _ready():
    randomize()
    diaryUI.hide() # Start with shelter visible
    
    # Start the Backend
    GameManager.start_new_game()
    
    # Connect the Next Day button if not done in editor
    if not nextDayButton.pressed.is_connected(_onNextDayButtonPressed):
        nextDayButton.pressed.connect(_onNextDayButtonPressed)
    
    refresh_shelter_view()

# --- DIARY TOGGLES ---
func _onOpenDairyPressed():
    # Generate the story text right before showing it
    diaryText.text = generate_diary_story()
    diaryUI.show()

func _onCloseDiaryPressed():
    diaryUI.hide()

# --- GAME LOGIC ---
func _onNextDayButtonPressed():
    # 1. Simple Hunger/Thirst Logic
    var state_chars = GameManager.current_state.characters
    for key in state_chars.keys():
        var data = state_chars[key]
        
        # For now, let's just make them hungry/thirsty every day 
        # (We will add the "Click to Feed" logic next!)
        data.hunger_days += 1
        data.thirst_days += 1

    # 2. Advance day
    day += 1
    
    # 3. Update Visuals
    refresh_shelter_view()
    
    # 4. Auto-open diary to show results of the night
    _onOpenDairyPressed()

func refresh_shelter_view():
    # Update Labels
    foodLabel.text = "Food: %d" % food
    waterLabel.text = "Water: %d" % water
    
    # Update Character Sprites (swaps textures)
    for member in family_nodes.values():
        if member.has_method("refresh"):
            member.refresh()

func generate_diary_story() -> String:
    var story = "DAY %d\n\n" % day
    var father = GameManager.current_state.characters.father
    
    if father.hunger_days > 0:
        story += "Arthur's stomach won't stop growling.\n"
    else:
        story += "Arthur actually looks full for once.\n"
        
    story += "\nWe need to keep going."
    return story
