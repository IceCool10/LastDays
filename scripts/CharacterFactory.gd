extends Node
class_name CharacterFactory

func createCharacter(name: String, minTraits := 1, maxTraits := 2) -> Character:
    var c = Character.new()
    c.name = name
    
    # Random number of traits
    var traitCount = randi() % (maxTraits - minTraits + 1) + minTraits
    c.traits = TraitDB.getRandomTraits(traitCount)
    
    # Randomize survival thresholds slightly
    c.foodSurvival = 6 + randi() % 3  # 6–8
    c.waterSurvival = 4 + randi() % 3  # 4–6
    
    # Apply trait effects immediately
    c.applyTraitEffectsDaily()
    
    return c

func createCharacters(names: Array, minTraits := 1, maxTraits := 2) -> Array[Character]:
    var characters: Array[Character] = []
    for name in names:
        characters.append(createCharacter(name, minTraits, maxTraits))
    return characters	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
