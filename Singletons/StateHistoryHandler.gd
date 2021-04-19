extends Node

const GROUP_CALL_REALTIME = 2

var state_history: Array = []
var frame_num: int = 0

func _ready():
	set_process_priority(-2)

func rollback_and_reapply(num_frames: int):
	if num_frames + 1 > len(state_history):
		return
	
	var pos = -1 * (num_frames + 1)
	var game_state = state_history[pos]["game_state"]
	GameStateHandler.load_game_state(game_state)

	for i in range(num_frames):
		var packet: Dictionary = state_history[pos+i]
		var next_packet: Dictionary = state_history[pos+i+1]
		
		var input_state: Array = packet["input_state"]
		var delta: float = packet["delta"]
		var next_input_state: Array = next_packet["input_state"]
		var orig_game_state = next_packet["game_state"]
		
		InputHandler.load_input_state(input_state)
		#simulate update
		get_tree().call_group_flags(GROUP_CALL_REALTIME, StateMachine.GROUP, "update", delta)
		InputHandler.load_input_state(next_input_state)
		
		var new_game_state = GameStateHandler.get_game_state()
		if not GameStateHandler.check_if_equal(orig_game_state, new_game_state):
			#shouldnt happen, at least for now
			print("rollback_game_state: " + str(game_state))
			print("orig_game_state: " + str(orig_game_state))
			print("new_game_state: " + str(new_game_state))
			assert(false)
			pass

func add_state_to_history(delta: float):
	frame_num+=1
	var input_state = InputHandler.get_input_state()
	var game_state = GameStateHandler.get_game_state()
	
	var packet = {
		"frame_num": frame_num,
		"input_state": input_state,
		"game_state": game_state,
		"delta": delta
	}
	state_history.append(packet)

func _physics_process(delta: float):
	if Rewind.rewind_time:
		return
	else:
		do_networking(delta)

func do_networking(delta: float):
	add_state_to_history(delta)

	if GlobalSettings.DEBUG_ALWAYS_ROLLBACK:
		var num_frames = 2
		for i in range(2):
			rollback_and_reapply(num_frames)
