extends Node

#hardcoding this
var DELTA: float = (1.0/60)

const GROUP_CALL_REALTIME = 2

var state_history: Array = []
var frame_num: int = 0

func rollback_and_reapply(num_frames: int):
	if num_frames + 1 > len(state_history):
		return
	
	var pos = -1 * (num_frames + 1)
	var game_state = state_history[pos]["game_state"]
	GameStateHandler.load_game_state(game_state)

	for i in range(num_frames):
		var input_state = state_history[pos+i]["input_state"]
		var next_input_state = state_history[pos+i+1]["input_state"]
		InputHandler.load_input_state(input_state)
		
#		var orig_game_state = state_history[pos+i+1]["game_state"]
#		print("orig_game_state: " + str(orig_game_state))
#		print("rollback_game_state: " + str(game_state))
		
		#get_tree().call_group(StateMachine.GROUP, "update", DELTA)
		get_tree().call_group_flags(GROUP_CALL_REALTIME, StateMachine.GROUP, "update", DELTA)
		InputHandler.load_input_state(next_input_state)
		
#		var new_game_state = GameStateHandler.get_game_state()
#		print("new_game_state: " + str(new_game_state))
#		print("a")
		

func add_state_to_history():
	frame_num+=1
	var input_state = InputHandler.get_input_state()
	var game_state = GameStateHandler.get_game_state()
	
	var packet = {
		"frame_num": frame_num,
		"input_state": input_state,
		"game_state": game_state
	}
	state_history.append(packet)

func _physics_process(delta: float):
	if Rewind.rewind_time:
		return
	else:
		do_networking(delta)

func do_networking(delta: float):
	add_state_to_history()
	if GlobalSettings.DEBUG_ALWAYS_ROLLBACK:
		var num_frames = 2
		rollback_and_reapply(num_frames)
