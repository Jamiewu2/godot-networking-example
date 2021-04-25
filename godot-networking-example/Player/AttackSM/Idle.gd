extends PlayerState

func update(delta: float):
	if inputHandler.is_attack_button_pressed:
		state_machine.change_state(state_machine.ATTACK)
