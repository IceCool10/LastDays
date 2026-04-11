extends Sprite2D

# This allows you to set "father", "mother", etc., in the Inspector for each sprite
@export var character_key: String = "father"

func refresh():
    # Access the data from your GameManager [cite: 71]
    if not GameManager.current_state.has("characters"):
        return
        
    var data = GameManager.current_state.characters[character_key]
    
    # Determine which image to show based on backend stats [cite: 75, 112]
    var state_name = "normal"
    
    if not data.is_alive:
        state_name = "dead"
        # Optional: Make dead characters semi-transparent or darker
        self.modulate = Color(0.5, 0.5, 0.5, 1.0) 
    elif data.health < 30:
        state_name = "sick"
        self.modulate = Color(1, 1, 1, 1)
    else:
        state_name = "normal"
        self.modulate = Color(1, 1, 1, 1)

    # Construct the file path (Example: res://images/father_sick.png)
    var path = "res://images/" + character_key + "_" + state_name + ".png"
    
    # Check if the file exists before trying to load it to avoid crashes
    if FileAccess.file_exists(path):
        texture = load(path)
    else:
        printerr("Warning: Animation frame missing at ", path)
