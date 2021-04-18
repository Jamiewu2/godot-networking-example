extends PlayerState

func run_on_enter():
	sphereAttack.perform_attack()
	
func _on_SphereAttack_on_attack_finished():
	state_machine.change_state(state_machine.IDLE)

func save_game_state():
	pass
	
func load_game_state(game_state):
	pass
