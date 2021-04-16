extends Camera

export(NodePath) var targetPath: NodePath
var target: KinematicBody
var dist = Vector3()

func _ready():
	target = get_node(targetPath)
	assert(target != null)
	dist = target.translation - translation

func _on_Player_after_physics():
	translation.x = target.translation.x - dist.x
	translation.z = target.translation.z - dist.z
