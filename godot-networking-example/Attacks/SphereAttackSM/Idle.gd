extends SphereAttackState

func run_on_enter():
	animationState.travel("Idle")

func update(_delta: float):
	animationTree.load_game_state(state_machine.current_state.name, state_machine.duration)
