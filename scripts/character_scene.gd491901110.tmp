extends TextureRect

@export var character_key: String = "father"

const COLUMN_INDEX = {"father": 0, "mother": 1, "son": 2, "daughter": 3}
const STATE_ROW = {"NORMAL": 0, "TIRED": 1, "SICK": 2, "GONE": 3}

# If your image is 1024px wide with 4 characters, 256 is the math.
const CELL_W = 256 
const CELL_H = 256
func update_appearance():
    if GameManager.current_state.is_empty(): return
    
    var data = GameManager.current_state.characters[character_key]
    var col = COLUMN_INDEX[character_key]
    
    var row = STATE_ROW.NORMAL
    if not data.is_alive: row = STATE_ROW.GONE
    elif data.health < 30: row = STATE_ROW.SICK
    elif data.hunger_days > 3: row = STATE_ROW.TIRED
    
    # Precise Offsets for portrait2.jpg
    var OFFSET_X = 0
    var OFFSET_Y = 0 
    
    var x_pos = (col * CELL_W) + OFFSET_X
    var y_pos = (row * CELL_H) + OFFSET_Y
    
    # Shrink the crop width/height to avoid seeing the neighbor's border
    var crop_w = CELL_W - (OFFSET_X * 2) 
    var crop_h = CELL_H - (OFFSET_Y * 2)
    
    var region_to_show = Rect2(x_pos, y_pos, crop_w, crop_h)
    
    var atlas = AtlasTexture.new()
    # FIX: Use .jpg to match your actual file
    atlas.atlas = load("res://images/family2.png") 
    atlas.region = region_to_show
    
    # CRITICAL: This stops the texture from showing pixels outside the Rect2
    atlas.filter_clip = true 
    
    self.texture = atlas
    print("Character: ", character_key, " Region: ", region_to_show)
