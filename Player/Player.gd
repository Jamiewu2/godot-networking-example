extends SaveableKinematicBody

onready var playerStats = $"PlayerController/PlayerStats"
onready var sphereAttack = $SphereAttack
onready var movementSM = $PlayerController/MovementSM
onready var attackSM = $PlayerController/AttackSM

func save_game_state() -> Array:
	var state = [
		self.transform,
		playerStats.save_game_state(),
		movementSM.save_game_state(),
		attackSM.save_game_state()
	]
	return state

func load_game_state(game_state: Array):
	self.transform = game_state[0]
	playerStats.load_game_state(game_state[1])
	movementSM.load_game_state(game_state[2])
	attackSM.load_game_state(game_state[3])
	
func set_sm_active(active: bool):
	movementSM.set_physics_process(active)
	attackSM.set_physics_process(active)
