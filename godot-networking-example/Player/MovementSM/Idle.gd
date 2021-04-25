extends PlayerState


var FRICTION

func run_on_enter():
	FRICTION = playerStats.FRICTION
	
func update(delta: float):
	playerStats.velocity = playerStats.velocity.move_toward(Vector3.ZERO, FRICTION * delta)
	playerStats.velocity = player.move_and_slide(playerStats.velocity)

	var input_vector: Vector3 = inputHandler.input_vector
	if input_vector != Vector3.ZERO:
		state_machine.change_state(state_machine.MOVE)
