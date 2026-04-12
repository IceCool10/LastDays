extends Node

var current_state = {}

# --- HELPER FUNCTIONS (The missing logic) ---

func load_json(path: String) -> Dictionary:
    if not FileAccess.file_exists(path):
        printerr("Error: File not found at ", path)
        return {}
        
    var file = FileAccess.open(path, FileAccess.READ)
    var content = file.get_as_text()
    file.close()
    
    var json = JSON.new()
    var error = json.parse(content)
    if error == OK:
        return json.data
    else:
        printerr("JSON Parse Error in ", path, ": ", json.get_error_message())
        return {}

func save_json(path: String, data: Dictionary):
    var file = FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        printerr("Error: Could not open file for writing at ", path)
        return
        
    var json_string = JSON.stringify(data, "\t") # Prettify for debugging
    file.store_string(json_string)
    file.close()

# --- GAME LOGIC ---

func start_new_game():
    # Make sure this file actually exists in your res:// folder!
    var config = load_json("res://data/characters/family_new_game.json")
    
    if config.is_empty():
        printerr("Config empty")
        return

    current_state = {
        "day": 1,
        "resources": config.starting_resources,
        "characters": {}
    }
    
    for key in config.family:
        var member = config.family[key]
        current_state.characters[key] = {
            "name": member.name,
            "health": member.base_health,
            "hunger_days": 0,
            "thirst_days": 0,
            "is_alive": true,
            "location": "shelter"
        }
    print("New Game Initialized: ", current_state)

func save_current_session():
    save_json("user://save_slot_1.json", current_state)

func load_previous_session():
    var loaded_data = load_json("user://save_slot_1.json")
    if not loaded_data.is_empty():
        current_state = loaded_data
        print("Game Loaded!")
