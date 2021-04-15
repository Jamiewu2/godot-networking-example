extends PlayerState

var MAX_SPEED
var ACCELERATION

func run_on_enter():
	MAX_SPEED = playerStats.MAX_SPEED
	ACCELERATION = playerStats.ACCELERATION
	
func clamp_vec3(vec: Vector3) -> Vector3:
	var length = vec.length()
	if length > MAX_SPEED:
		return vec * (MAX_SPEED / length)
	return vec

func update(delta: float):
	var input_vector = get_input_vector()
	
	if input_vector != Vector3.ZERO:
		playerStats.input_vector = input_vector
	
		var velocity = playerStats.velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) 
		velocity = self.clamp_vec3(velocity)
		playerStats.velocity = velocity
		playerStats.velocity = player.move_and_slide(playerStats.velocity)
		
	else:
		state_machine.change_state(state_machine.IDLE)
#
#	if Input.is_action_just_pressed("ui_roll"):
#		state_machine.change_state(state_machine.ROLL)
#	elif Input.is_action_just_pressed("ui_attack"):
#		state_machine.change_state(state_machine.ATTACK)
