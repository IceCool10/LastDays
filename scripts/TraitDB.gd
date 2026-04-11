extends Node

class_name TraitDatabase

@export var traits: Array[Trait] = [
    load("res://data/traits/brave.tres"),
    load("res://data/traits/coward.tres")
]
# Optional: define conflicting trait pairs
var traitConflicts: Dictionary = {
    "brave": ["coward"],  # brave conflicts with coward
    "coward": ["brave"]
}

func getRandomTraits(count: int) -> Array[Trait]:
    var pool = traits.duplicate()
    pool.shuffle()
    
    var selected: Array[Trait] = []
    for t in pool:
        # Skip if conflicts with any already selected trait
        var conflict = false
        for s in selected:
            if traitConflicts.has(t.id) and s.id in traitConflicts[t.id]:
                conflict = true
                break
        if conflict:
            continue
        selected.append(t)
        if selected.size() >= count:
            break
    return selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
