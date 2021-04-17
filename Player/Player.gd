extends SaveableKinematicBody

onready var playerStats = $"PlayerController/PlayerStats"
onready var sphereAttack = $SphereAttack

func save_state() -> Transform:
	return self.transform

func load_state(game_state: Transform):
	self.transform = game_state
