extends SaveableNode
class_name Stats

export var default_max_health: int = 1
var health: int setget set_health, get_health
signal no_health

var stats_defaults = {
	"health": default_max_health
}

var stats = {
	"health": default_max_health
}

# put stats in here that don't change after init
# todo not used for now, might when i need to initialize object creation
var stats_constant: Dictionary = {}

func set_health(value: int) -> void:
	stats["health"] = value
	if health <= 0:
		emit_signal("no_health")
		
func get_health() -> int:
	return stats["health"]

func save_game_state() -> Dictionary:
	return stats.duplicate()
	
func load_game_state(game_state: Dictionary):
	stats = game_state
