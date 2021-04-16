extends KinematicBody

onready var playerStats = $"PlayerController/PlayerStats"
onready var sphereAttack = $SphereAttack

signal after_physics

func _physics_process(delta):
	call_deferred("emit_physics_signal")
	
func emit_physics_signal():
	emit_signal("after_physics")
