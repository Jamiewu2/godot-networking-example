extends SphereAttackState

export var IMPULSE_STRENGTH: float = 30
signal attack_finished

func run_on_enter():
	animationState.travel("Attack")
	
	var overlapping_bodies: Array = area.get_overlapping_bodies()
	for body in overlapping_bodies:
		var pos = self.global_transform.origin
		var body_pos = body.global_transform.origin
		var knockback_vector: Vector3 = pos.direction_to(body_pos)
		var impulse = knockback_vector * IMPULSE_STRENGTH
		
		if body is RigidBody:
			body.apply_central_impulse(impulse)
		else:
			#todo, but this shouldnt happen until i add other players
			assert(false)

func run_on_exit():
	emit_signal("attack_finished")

func attack_animation_finished():
	state_machine.change_state(state_machine.IDLE)
