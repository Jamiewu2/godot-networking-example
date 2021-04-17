extends Node

var input_vector: Vector3 = Vector3.ZERO
var is_attack_button_pressed: bool = false
var is_spawn_button_pressed: bool = false
var is_rewind_time_button_pressed: bool = false
var is_rewind_time_button_just_pressed: bool = false


func _ready():
	#run this class first
	set_process_priority(-1)

func _unhandled_input(event):
	if GlobalSettings.DEBUG:
		print("[InputHandler]: " + str(event))
		
	input_vector = _get_input_vector()
	set_button_press_state()
	
func _get_input_vector() -> Vector3:
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector.normalized()
	
func set_button_press_state():
	if Input.is_action_pressed("ui_attack"):
		is_attack_button_pressed = true
	else:
		is_attack_button_pressed = false
		
	if Input.is_action_pressed("ui_spawn"):
		is_spawn_button_pressed = true
	else:
		is_spawn_button_pressed = false
		
	if Input.is_action_pressed("ui_rewind"):
		is_rewind_time_button_pressed = true
		is_rewind_time_button_just_pressed = true
	else:
		is_rewind_time_button_pressed = false

#some jank code to reimplement this functionality
var is_just_pressed: bool = true
func handle_rewind_button_just_pressed():
	if InputHandler.is_rewind_time_button_pressed and is_just_pressed:
		is_just_pressed = false
	elif InputHandler.is_rewind_time_button_pressed and not is_just_pressed:
		is_rewind_time_button_just_pressed = false
	elif not InputHandler.is_rewind_time_button_pressed:
		is_just_pressed = true

################################
# ITS TIME FOR JANK NETCODE
################################




var num_rollback: int = 2
var max_rollback_buffer: int = 10

var rewind_time: bool = false

# hack, just setting players for now
# should instead loop through all scene objects
func set_scene_physics_process(active: bool):
	var player = get_tree().current_scene.get_node("Player")
	player.set_sm_active(active)
	
func toggle_rewind_time():
	rewind_time = !rewind_time
	set_scene_physics_process(!rewind_time)
	
func hacky_rewind_time():
	if len(state_history) == 0:
		toggle_rewind_time()
		return
	var game_state = state_history[-1]["game_state"]
	GameStateHandler.load_game_state(game_state)
	set_scene_physics_process(false)
	state_history.pop_back()

func _physics_process(delta):
	handle_rewind_button_just_pressed()

	if InputHandler.is_rewind_time_button_just_pressed:
		toggle_rewind_time()

	if rewind_time:
		hacky_rewind_time()
	else:
		add_state_to_history()
		if GlobalSettings.DEBUG_ALWAYS_ROLLBACK:
			debug_stuff()

var count: int = 0
var state_history: Array = []

func debug_stuff():
	var game_state = state_history[-1]["game_state"]
	GameStateHandler.load_game_state(game_state)

func add_state_to_history():
	count+=1
	
	var input_state = {
		"input_vector": input_vector,
		"is_attack_button_pressed": is_attack_button_pressed,
		"is_spawn_button_pressed": is_spawn_button_pressed
	}

	var game_state = GameStateHandler.serialize_game_state()
	
	var packet = {
		"count": count,
		"input_state": input_state,
		"game_state": game_state
	}
	
	state_history.append(packet)

# Deterministic + Client-Side Prediction + Rollback (GGPO)
# (GGPO and related are p2p networking solutions, concepts are the same though)
#
# Game examples: Fighting games, For Honor, Rocket League
# Articles:
#	 https://ki.infil.net/w02-netcode.html
# Videos:
#    Rocket league: https://www.youtube.com/watch?v=ueEmiDM94IE
#    Mortal Combat, Injustice 2: https://www.youtube.com/watch?v=7jb0FOcImdg
#
# Requirements:
# 1. COMPLETELY DETERMINISTIC game:
# -- initial game state + series of inputs = same game state
# ---- notoriously hard to do in physics engines across machines due to floating point math
# ---- thus, in practice this netcode is usually done in games with fake physics
# ------ Ex: Fighting games
# 2. Way to serialize entire game_state, load game_state from serialization
#
# How to prevent cheating:
#    Periodically send game_state between server/client
#    If divergence is over some threshold, game is desynced,
#       -- set the client to server's state, or just kick em out
#
# The server packet is back in time relative to the client
# Client predicts what the other players are doing by last received input
# Example: 
# Note: all these frames refer to physics/network/command frame, not a rendered frame
# Server packet is on frame 3, Client is on frame 8:
# Client has also previously received input for Frame 1 from the server
# -- Frame 1: Player 1 pressed up, Player 2 pressed nothing
# Client also saves state_history in a fixed size array (ringbuffer):
# --  [1,2,..., 8]
# a state_history entry contains a serialized game_state, and the inputs
# -- Note: you can skip serializing the game_state in some frames, you'll just have to rollback some more
# ---- check the Mortal Kombat GDC talk
# Since the game is deterministic, server only has to send inputs
#
# For example:
# Client receives packet 3 from the server: the packet is back in time
# The packet says:
# -- Frame 3: Player 1 pressed up, Player 2 pressed up
# ---- (and contains previous x frames, x being buffer size, in case of packet loss)
# Client has the input state_history up to frame 8 (and rendered):
# -- Frame 3: Player 1 pressed up, Player 2 pressed nothing (prediction)
# -- Frame 4: Player 1 pressed up, Player 2 pressed nothing (prediction)
# ...
# -- Frame 8: Player 1 pressed up, Player 2 pressed nothing (prediction)
#
# 
#
# To Perform rollback:
# Check if theres a divergence
# -- no divergence in frame 2
# -- divergence in frame 3
# If there was no divergence:
# 	 No changes, congratulations on your 5 frames of reduced lag
# If yes:
#    Client loads game state Frame #2
#    Client applies game_state + input #3 -> new_game_state
#    Client serializes game_state, saves into state_history #3 
#    Client applies game_state + input #4 (Player2 up prediction) -> new_game_state
#    Client serializes game_state, saves into state_history #4
#    ...
#    up to #8
# Set last acknowledged server packet to frame #3
#
# Challenges: 
#   ALL of that shit above has to be done in one frame
#   -- good luck serializing and loading game_state that fast
#   Rollbacking between object creation/deletion is very tricky (don't want to recreate/delete objects all the time)
#   Sound is tricky




# Steps to implement:
# Serialize game_state, load game_state (test: do this in a loop and nothing visually should happen)
# Rollback + apply inputs (test: perma rollback, and nothing visually should happen)
# Add that networking layer
# -- add delay based (Deterministic Lockstep) networking first, its useful anyway
# Add that desync detection



# Statistics:
# Artificial Delay (manually set, can be 0): x ms
# Ping: y ms = (longest ms from other client to server) + (ms from server to you)
# -- Technically, the server can do client prediction + rollback too and send messages back faster. This sounds extraordinarily complicated to handle though
# ---- Time dilation? https://youtu.be/W3aieHjyNvw?t=1750
# Visual delay for self = x ms
# Visual delay for others = x ms, except they teleport on prediction miss
# -- teleport distance based on game_state change in (y-x) ms 
# -- teleport distance can be 0 if game_state was not changed even on prediction miss
# ---- Ex: pressing Attack while already attacking


###############
#THINGS TO DO #
###############

func rollback_deterministic(server_packet: Dictionary): 
	pass
	
#returns current game_state
func serialize_game_state():
	pass
	
func load_game_state(game_state):
	pass
	
func save_into_state_history(game_state, input, frame_num):
	pass
	
func get_new_predicted_input_array():
	pass
	
#return final game state
func game_state_apply_inputs(initial_game_state, input_array):
	pass
