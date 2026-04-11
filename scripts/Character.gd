extends Resource
class_name Character

var name: String
var traits: Array[Trait] = []
var portrait_normal: Texture2D
var portrait_exhausted: Texture2D

var daysWithoutFood := 0
var daysWithoutWater := 0

var foodSurvival := 7
var waterSurvival := 5

var isExhausted := false
var consecutiveMeals := 0

var baseExhaustionChance := 5

var maxRecoveryChance := 40

func consumeFood(amount := 1):
    # Reduce days without food
    daysWithoutFood = max(daysWithoutFood - amount, 0)

func consumeWater(amount := 1):
    # Reduce days without water
    daysWithoutWater = max(daysWithoutWater - amount, 0)

func isAlive() -> bool:
    return daysWithoutFood <= foodSurvival and daysWithoutWater <= waterSurvival

func hasTrait(traitId: String) -> bool:
    for t in traits:
        if t.id == traitId:
            return true
    return false

func endOfDay():
    # Increment days without food/water
    daysWithoutFood += 1
    daysWithoutWater += 1

    # Track consecutive meals
    if daysWithoutFood == 0:
        consecutiveMeals += 1
    else:
        consecutiveMeals = 0

    # Apply daily exhaustion chance
    checkExhaustion()

    # Optionally apply trait modifiers (e.g., Lucky)
    applyTraitEffectsDaily()
    
func checkExhaustion():
    isExhausted = false
    
    # Base chance to get exhausted if hungry/thirsty
    if randi_range(1, 100) <= baseExhaustionChance:
        isExhausted = true
    
    # Recovery chance if character ate consecutive days
    if consecutiveMeals > 1:
        var recoveryChance = min(consecutiveMeals * 10, maxRecoveryChance)  # 10% per day, max 35–40%
        if randi_range(1, 100) <= recoveryChance:
            isExhausted = false  # recovered from exhaustion
            
func canGoOnExpedition() -> bool:
    # Cannot go if exhausted
    return not isExhausted

func applyTraitEffectsDaily():
    for t in traits:
        match t.id:
            "lucky":
                # Lucky gives random small bonus per day
                foodSurvival += randi() % 2   # +0 or +1
                waterSurvival += randi() % 2  # +0 or +1
            "sick":
                # Sick increases exhaustion chance
                baseExhaustionChance += 5

func getExpeditionModifier(type: String) -> float:
    var modifier := 1.0
    for t in traits:
        if t.expeditionModifiers.has(type):
            modifier *= t.expeditionModifiers[type]
    return modifier



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
