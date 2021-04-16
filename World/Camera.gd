extends Camera

export(NodePath) var targetPath: NodePath
var target: KinematicBody
var dist = Vector3()

func _ready():
	#process this class after player, fixes camera jitter
	set_process_priority(1)
	
	target = get_node(targetPath)
	assert(target != null)
	dist = target.translation - translation

func _physics_process(delta):
	translation.x = target.translation.x - dist.x
	translation.z = target.translation.z - dist.z
