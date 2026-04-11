extends Node
class_name EventDB

var events := {}
var event_deck := []

func _ready():
    loadAllEvents()

func loadAllEvents():
    var dir = DirAccess.open("res://events/")
    if dir:
        for file_name in dir.get_files():
            if file_name.ends_with(".tres"):
                var ev = load("res::/events/" + file_name) as GEvent
                if ev:
                    events[ev.id] = ev
    _refill_and_shuffle_deck()

func _refill_and_shuffle_deck():
    event_deck = events.keys()
    event_deck.shuffle()

func getRandomEvent() -> GEvent:
    if events.is_empty():
        return null
    if event_deck.is_empty():
        _refill_and_shuffle_deck()
    var ev_id = event_deck.pop_back()
    return events[ev_id]

func roll_dynamic_chance(base_percent: int, variance: int) -> bool:
    var shift = randi_range(-variance, variance)
    var final_chance = clampi(base_percent + shift, 0, 100)
    var roll = randi_range(1, 100)
    return roll <= final_chance

func trigger_event(player, event: GEvent):
    print("Event:", event.description)
    for outcome in event.outcomes:
        # Get base chance (defaults to 100 if not set) and variance
        var base_chance = outcome.get("chance", 100)
        var variance = outcome.get("variance", 0)
        
        if roll_dynamic_chance(base_chance, variance):
            match outcome["type"]:
                "food":
                    var amount = randi_range(outcome["min"], outcome["max"])
                    player.consumeFood(-amount)
                    print(player.name, "found food:", amount)
                "water":
                    var amount = randi_range(outcome["min"], outcome["max"])
                    player.consumeWater(-amount)
                    print(player.name, "found water:", amount)
                "sick":
                    player.isExhausted = true
                    print(player.name, "got sick!")
                "item":
                    print(player.name, "found item:", outcome.get("item_name", "Unknown"))
