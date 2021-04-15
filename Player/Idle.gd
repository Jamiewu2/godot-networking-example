extends PlayerState


var FRICTION

func run_on_enter():
	FRICTION = playerStats.FRICTION
	
func update(delta: float):
	playerStats.velocity = playerStats.velocity.move_toward(Vector3.ZERO, FRICTION * delta)
	playerStats.velocity = player.move_and_slide(playerStats.velocity)
	
#	if Input.is_action_just_pressed("ui_roll"):
#		state_machine.change_state(state_machine.ROLL)
#	elif Input.is_action_just_pressed("ui_attack"):
#		state_machine.change_state(state_machine.ATTACK)
	
	var input_vector: Vector3 = get_input_vector()
	if input_vector != Vector3.ZERO:
		state_machine.change_state(state_machine.MOVE)
