extends Node

const GROUP_CALL_REALTIME = 2
var rewind_time: bool = false

func _ready():
	set_process_priority(-3)

func _physics_process(_delta: float):
	if InputHandler.is_rewind_time_button_just_pressed:
		toggle_rewind_time()

	if rewind_time:
		var length: int = hacky_rewind_time()
		if length == 0:
			toggle_rewind_time()

#############
# fun stuff #
#############

const REWIND_SPEED = 2 

func hacky_rewind_time() -> int:
	var state_history_length = len(StateHistoryHandler.state_history)
	if state_history_length <= REWIND_SPEED:
		return 0
		
	var pos = -1 * (REWIND_SPEED + 1)
	var game_state = StateHistoryHandler.state_history[pos]["game_state"]
	GameStateHandler.load_game_state(game_state)
	for i in range(REWIND_SPEED):
		StateHistoryHandler.state_history.pop_back()
	return state_history_length
	
func set_scene_physics_process(active: bool):
	pass
	#get_tree().call_group_flags(GROUP_CALL_REALTIME, StateMachine.GROUP, "set_active", active)

func toggle_rewind_time():
	rewind_time = !rewind_time
	if not rewind_time:
		var game_state = StateHistoryHandler.state_history[-1]["game_state"]
		GameStateHandler.load_game_state(game_state)
		StateHistoryHandler.state_history.pop_back()
		
	set_scene_physics_process(!rewind_time)
