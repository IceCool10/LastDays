extends Node2D


    # Called when the node enters the scene tree for the first time.

var day := 1
var characters := []
var characterButtons := {}  # key = character name, value = {"feed": TextureButton, "water": TextureButton}

@onready var dayLabelLoading := $CanvasLayer/LoadingScreen/DayLabelLoading
@onready var loadingScreen := $CanvasLayer/LoadingScreen
@onready var charactersVBox := $CanvasLayer/CharactersVBox
@onready var nextDayButton := $CanvasLayer/NextDayButton
@onready var foodLabel := $CanvasLayer/ResourcesHBox/FoodLabel
@onready var waterLabel := $CanvasLayer/ResourcesHBox/WaterLabel
@onready var eventPanel := $CanvasLayer/EventPanel
@onready var eventLabel := eventPanel.get_node("EventLabel")
@onready var eventButtonsContainer := eventPanel.get_node("ButtonsHBox")
@onready var testEventButton := $CanvasLayer/TestEventButton




var food := 10
var water := 10
var feedAllActive := false
var waterAllActive := false

func _ready():
    randomize()
    var factory = CharacterFactory.new()
    characters = factory.createCharacters(["Alice", "Bob", "Charlie"])
    updateUI()

    nextDayButton.pressed.connect(_onNextDayButtonPressed)
    testEventButton.pressed.connect(_onTestEventPressed)  # NEW
    loadingScreen.visible = false

func _onTestEventPressed():
    # Pick a test event from EventDb
    var testEvent = EventDb.getRandomEvent()  # Make sure you have this function
    showEvent(testEvent)

func getActiveFeedCount() -> int:
    var count := 0
    for buttons in characterButtons.values():
        if buttons["feed"].button_pressed:
            count += 1
    return count
    
func getActiveWaterCount() -> int:
    var count := 0
    for buttons in characterButtons.values():
        if buttons["water"].button_pressed:
            count += 1
    return count
    
func updateFeedButtonAvailability():
    var activeFeeds = getActiveFeedCount()

    for buttons in characterButtons.values():
        var feedButton = buttons["feed"]

        # Allow unchecking always
        if feedButton.button_pressed:
            feedButton.disabled = false
            feedButton.modulate = Color(1,1,1,1.0)
        else:
            feedButton.disabled = activeFeeds >= food
            if feedButton.disabled:
                feedButton.modulate = Color(1,1,1,0.2)
            else:
                feedButton.modulate = Color(1,1,1,0.5)
            
func updateWaterButtonAvailability():
    var activeFeeds = getActiveWaterCount()

    for buttons in characterButtons.values():
        var waterButton = buttons["water"]

        # Allow unchecking always
        if waterButton.button_pressed:
            waterButton.disabled = false
            waterButton.modulate = Color(1,1,1,1.0)
        else:
            waterButton.disabled = activeFeeds >= water
            if waterButton.disabled:
                waterButton.modulate = Color(1,1,1,0.2)
            else:
                waterButton.modulate = Color(1,1,1,0.5)

func createGlobalActionButton(texture_path: String) -> TextureButton:
    var button = TextureButton.new()
    button.toggle_mode = false
    button.custom_minimum_size = Vector2(64, 64)

    var tex = load(texture_path)
    var img = tex.get_image()
    img.resize(64, 64)
    var new_tex = ImageTexture.create_from_image(img)

    button.texture_normal = new_tex
    button.texture_pressed = new_tex
    button.texture_hover = new_tex

    return button         

func _onFeedAllPressed():
    feedAllActive = !feedAllActive  # toggle state

    var remainingFood = food

    for c in characters:
        var buttons = characterButtons.get(c.name)
        if buttons:
            var feedButton = buttons["feed"]

            if feedAllActive:
                # Check if food available
                if remainingFood > 0 and not feedButton.button_pressed:
                    feedButton.button_pressed = true
                    remainingFood -= 1
            else:
                # Uncheck all
                if feedButton.button_pressed:
                    feedButton.button_pressed = false

    updateFeedButtonAvailability()

       
func _onWaterAllPressed():
    waterAllActive = !waterAllActive

    var remainingWater = water

    for c in characters:
        var buttons = characterButtons.get(c.name)
        if buttons:
            var waterButton = buttons["water"]

            if waterAllActive:
                if remainingWater > 0 and not waterButton.button_pressed:
                    waterButton.button_pressed = true
                    remainingWater -= 1
            else:
                if waterButton.button_pressed:
                    waterButton.button_pressed = false

    updateWaterButtonAvailability()  

func selectOnlyThis(selectedBtn: Button):
    for btn in eventButtonsContainer.get_children():
        if btn != selectedBtn:
            btn.pressed = false

func _onEventCharacterSelected(character: Character, event: GEvent):
    EventDb.trigger_event(character, event)
    eventPanel.visible = false
    print("Event applied to", character.name)
    updateUI()

func _onEventYesNoSelected(event: GEvent, choice: bool):
    EventDb.trigger_event_choice(event, choice)
    eventPanel.visible = false
    print("Event choice:", choice)
    updateUI()

func showEvent(event: GEvent):
    eventPanel.visible = true
    eventLabel.text = event.description
    
    # Clear previous buttons
    for child in eventButtonsContainer.get_children():
        child.queue_free()
    
    if event.target_type == "character":
        # Character selection: toggle buttons, allow only one
        for c in characters:
            var btn = Button.new()
            btn.text = c.name
            btn.toggle_mode = true
            btn.pressed.connect(func(): selectOnlyThis(btn))  # helper to allow only 1
            btn.connect("pressed", Callable(self, "_onEventCharacterSelected").bind(c, event))
            eventButtonsContainer.add_child(btn)
    elif event.target_type == "yes_no":
        var yesBtn = Button.new()
        yesBtn.text = "Yes"
        yesBtn.connect("pressed", Callable(self, "_onEventYesNoSelected").bind(event, true))
        eventButtonsContainer.add_child(yesBtn)
        
        var noBtn = Button.new()
        noBtn.text = "No"
        noBtn.connect("pressed", Callable(self, "_onEventYesNoSelected").bind(event, false))
        eventButtonsContainer.add_child(noBtn)
                            
func updateUI():
    # Update day label on loading screen
    dayLabelLoading.text = "Day: %d" % day
    foodLabel.text = "Food: %d" % food
    waterLabel.text = "Water: %d" % water
    # Clear previous UI
    for child in charactersVBox.get_children():
        child.queue_free()
        
    
    # Main horizontal row for all characters
    var mainRow = HBoxContainer.new()
    charactersVBox.add_child(mainRow)

    for c in characters:
        # VBox for name + buttons
        var charBox = VBoxContainer.new()

        # Icons row (buttons)
        var iconsRow = HBoxContainer.new()
        iconsRow.size_flags_horizontal = Control.SIZE_EXPAND_FILL

        # Feed button (TextureButton)
        var feedButton = TextureButton.new()
        feedButton.name = c.name + "_Feed"
        feedButton.toggle_mode = true
        feedButton.set_custom_minimum_size(Vector2(64,64))  # button size

        # Load and scale the image dynamically
        var tex = load("res://images/food.png")
        var img = tex.get_image()
        img.resize(64, 64)  # scale image to 64x64
        var new_tex = ImageTexture.create_from_image(img)

        feedButton.texture_normal = new_tex
        feedButton.texture_pressed = new_tex
        if food > 0:
            feedButton.modulate = Color(1,1,1,0.5)
        else:
            feedButton.modulate = Color(1,1,1,0.2)
        # Toggle transparency when pressed
        feedButton.toggled.connect(func(pressed):
            updateFeedButtonAvailability()
            if pressed:
                feedButton.modulate = Color(1,1,1,1)
            else:
                feedButton.modulate = Color(1,1,1,0.5)
        )
        feedButton.disabled = food <= 0
        iconsRow.add_child(feedButton)

       
        var waterButton = TextureButton.new()
        waterButton.name = c.name + "_Feed"
        waterButton.toggle_mode = true
        waterButton.set_custom_minimum_size(Vector2(64,64))  # button size

        # Load and scale the image dynamically
        tex = load("res://images/water.png")
        img = tex.get_image()
        img.resize(64, 64)  # scale image to 64x64
        new_tex = ImageTexture.create_from_image(img)

        waterButton.texture_normal = new_tex
        waterButton.texture_pressed = new_tex
        if water > 0:
            waterButton.modulate = Color(1,1,1,0.5)
        else:
            waterButton.modulate = Color(1,1,1,0.2)
        # Toggle transparency when pressed
        waterButton.toggled.connect(func(pressed):
            updateWaterButtonAvailability()
            if pressed:
                waterButton.modulate = Color(1,1,1,1)
            else:
                waterButton.modulate = Color(1,1,1,0.5)
        )

        waterButton.disabled = water <= 0
        iconsRow.add_child(waterButton)
        ## Name label, centered above buttons
        var nameLabel = Label.new()
        nameLabel.text = c.name
        nameLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        nameLabel.horizontal_alignment = Label.PRESET_CENTER

        # Add label and icons to character box
        charBox.add_child(nameLabel)
        charBox.add_child(iconsRow)

        # Add spacer to separate characters horizontally
        var spacer = Control.new()
        spacer.custom_minimum_size = Vector2(20,0)

        mainRow.add_child(charBox)
        mainRow.add_child(spacer)
        characterButtons[c.name] = {"feed": feedButton, "water": waterButton}
    
    var globalRow = HBoxContainer.new()
    globalRow.alignment = BoxContainer.ALIGNMENT_CENTER
    charactersVBox.add_child(globalRow)
    var feedAllButton = createGlobalActionButton("res://images/food.png")
    var waterAllButton = createGlobalActionButton("res://images/water.png")
    
    feedAllButton.pressed.connect(func():
        _onFeedAllPressed()
    )

    waterAllButton.pressed.connect(func():
        _onWaterAllPressed()
    )
    globalRow.add_child(feedAllButton)
    globalRow.add_child(waterAllButton)

func _onNextDayButtonPressed():
    loadingScreen.visible = true
    var loadingLabel = loadingScreen.get_node("DayLabelLoading") as Label
    loadingLabel.text = "Day %d" % day
    await get_tree().create_timer(1.2).timeout

    # Feed / Water characters based on button states
    for c in characters:
        var buttons = characterButtons.get(c.name, null)
        if buttons:
            if buttons["feed"].button_pressed and food > 0:
                food -= 1
                c.consumeFood(1)
                print(c.name, " --> FED")
            if buttons["water"].button_pressed and water > 0:
                water -= 1
                c.consumeWater(1)

    # Advance day
    for c in characters.duplicate():
        c.endOfDay()
        if not c.isAlive():
            print(c.name, "has died!")
            characters.erase(c)

    day += 1
    updateUI()
    loadingScreen.visible = false

    # Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
