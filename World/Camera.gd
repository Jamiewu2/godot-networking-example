extends Camera

export(NodePath) var targetPath: NodePath
var target: KinematicBody
var dist = Vector3()

func _ready():
	target = get_node(targetPath)
	assert(target != null)
	dist = target.translation - translation

# Follows the target without jumping on the y axis
func _physics_process(delta):
	translation.x = target.translation.x - dist.x
	translation.z = target.translation.z - dist.z
