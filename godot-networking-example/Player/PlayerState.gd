extends State
class_name PlayerState


# DI, so all player states have common dependencies without having to hardcode
var player: KinematicBody
var playerStats: PlayerStats
var sphereAttack: SphereAttack
var inputHandler: InputHandler

func _ready():
	yield(self.owner, "ready")

	player = self.owner
	playerStats = player.playerStats
	sphereAttack = player.sphereAttack
	inputHandler = InputHandler
	
	assert(player != null)
	assert(playerStats != null)
	assert(sphereAttack != null)
	assert(inputHandler != null)
