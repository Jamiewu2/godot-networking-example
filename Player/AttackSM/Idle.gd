extends PlayerState

func update(delta: float):
	if Input.is_action_just_pressed("ui_attack"):
		state_machine.change_state(state_machine.ATTACK)
