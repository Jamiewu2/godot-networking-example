extends Node

const PLAYER_KEY = "player1"

#returns current game_state
func get_game_state() -> Dictionary:
	#hardcoded game_state stuff
	var root: Viewport = get_tree().root
	
	var player: SaveableKinematicBody = get_tree().get_current_scene().get_node("Player")

	
	var game_state = {
		PLAYER_KEY: player.save_game_state()
	}
	
	if GlobalSettings.DEBUG:
		print("[GameStateHandler]: saved game_state: " + str(game_state))
		
	return game_state
	
#hardcoded loading
func load_game_state(game_state):
	var root: Viewport = get_tree().root
	
	var player: SaveableKinematicBody = get_tree().get_current_scene().get_node("Player")
	
	var player_state: Array = game_state[PLAYER_KEY]
	player.load_game_state(player_state)
	
	if GlobalSettings.DEBUG:
		print("[GameStateHandler]: loaded game_state: " + str(game_state))


func check_if_equal(game_state_1, game_state_2) -> bool:
	return dict_deep_equals(game_state_1, game_state_2)
	
func array_deep_equals(a1: Array, a2: Array) -> bool:
	if a1 == a2:
		return true
	if a1 == null or a2 == null:
		return false
	if len(a1) != len(a2):
		return false
		
	var is_same: bool = true
	for i in len(a1):
		var obj1 = a1[i]
		var obj2 = a2[i]
		
		if obj1 is Dictionary and obj2 is Dictionary:
			is_same = dict_deep_equals(obj1, obj2)
#			print(str(i) +  " dict is_same: " + str(is_same))
#			pass
		elif obj1 is Array and obj2 is Array:
			is_same = array_deep_equals(obj1, obj2)
#			print(str(i) +  " array is_same: " + str(is_same))
#			pass
		elif obj1 is Transform and obj2 is Transform:
			is_same = obj1.is_equal_approx(obj2)
#			print(str(i) +  " transform is_same: " + str(is_same))
#			pass
		elif obj1 is float and obj2 is float:
			is_same = is_equal_approx(obj1, obj2)
		else:
			is_same = obj1 == obj2
#			print(str(i) +  " obj is_same: " + str(is_same))
		
		if not is_same:
			return false
	return true
	
func dict_deep_equals(d1: Dictionary, d2: Dictionary) -> bool:
	if d1 == d2:
		return true
	if d1 == null or d2 == null:
		return false
	if len(d1) != len(d2):
		return false
		
	if not d2.has_all(d1.keys()):
		return false		
		
	var is_same: bool = true
	for key in d1:
		var obj1 = d1[key]
		var obj2 = d2[key]
		
		if obj1 is Dictionary and obj2 is Dictionary:
			is_same = dict_deep_equals(obj1, obj2)
#			print(str(key) +  " dict is_same: " + str(is_same))
#			pass
		elif obj1 is Array and obj2 is Array:
			is_same = array_deep_equals(obj1, obj2)
#			print(str(key) +  " array is_same: " + str(is_same))
#			pass
		elif obj1 is Transform and obj2 is Transform:
			is_same = obj1.is_equal_approx(obj2)
		elif obj1 is float and obj2 is float:
			is_same = is_equal_approx(obj1, obj2)
		else:
			is_same = obj1 == obj2
		
		if not is_same:
			return false
	return true
	
