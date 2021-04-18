extends Node

var rewind_time: bool = false

func _ready():
	set_process_priority(-1)

func _physics_process(delta):
	if InputHandler.is_rewind_time_button_just_pressed:
		toggle_rewind_time()

	if rewind_time:
		var length: int = hacky_rewind_time()
		if length == 0:
			toggle_rewind_time()

#############
# fun stuff #
#############

func hacky_rewind_time() -> int:
	var state_history_length = len(StateHistoryHandler.state_history)
	if state_history_length == 0:
		return 0
		
	var game_state = StateHistoryHandler.state_history[-1]["game_state"]
	GameStateHandler.load_game_state(game_state)
	set_scene_physics_process(false)
	StateHistoryHandler.state_history.pop_back()
	return state_history_length
	
# hack, just setting players for now
# should instead loop through all scene objects
func set_scene_physics_process(active: bool):
	var player = get_tree().current_scene.get_node("Player")
	player.set_sm_active(active)

func toggle_rewind_time():
	rewind_time = !rewind_time
	set_scene_physics_process(!rewind_time)
