extends Node

const PLAYER_KEY = "player1"

#returns current game_state
func serialize_game_state() -> Dictionary:
	#hardcoded game_state stuff
	var player: SaveableKinematicBody = get_tree().get_current_scene().get_node("Player")
	
	var game_state = {
		PLAYER_KEY: player.save_game_state()
	}
	
	if GlobalSettings.DEBUG:
		print("[GameStateHandler]: saved game_state: " + str(game_state))
		
	return game_state
	
func load_game_state(game_state):
	
	#hardcoded loading
	var player_state: Array = game_state[PLAYER_KEY]
	var player: SaveableKinematicBody = get_tree().get_current_scene().get_node("Player")
	player.load_game_state(player_state)
	
	if GlobalSettings.DEBUG:
		print("[GameStateHandler]: loaded game_state: " + str(game_state))
