extends State
class_name PlayerState


# DI, so all player states have common dependencies without having to hardcode
var player: KinematicBody
var playerStats: PlayerStats

func _ready():
	yield(self.owner, "ready")

	player = self.owner
	playerStats = player.playerStats
	
	assert(player != null)
	assert(playerStats != null)
	
func get_input_vector() -> Vector3:
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector.normalized()
