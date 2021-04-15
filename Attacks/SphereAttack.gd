extends Position3D
class_name SphereAttack

signal on_attack_finished

onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var meshInstance: MeshInstance = $MeshInstance
onready var area: Area = $Area

export var default_color: Color = Color(0,0,0,0)
export var IMPULSE_STRENGTH: float = 30

func _ready():
	meshInstance.get_surface_material(0).albedo_color = default_color

func perform_attack():
	animationPlayer.play("Attack")
	
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

func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("on_attack_finished")
