extends State
class_name SphereAttackState


var sphereAttack: SphereAttack
var inputHandler: InputHandler

var animationTree: SaveableAnimationTree
var animationState: AnimationNodeStateMachinePlayback
var area: Area

func _ready():
	yield(self.owner, "ready")

	sphereAttack = self.owner
	animationTree = sphereAttack.animationTree
	animationState = sphereAttack.animationState
	area = sphereAttack.area
	inputHandler = InputHandler
	
	assert(sphereAttack != null)
	assert(animationTree != null)
	assert(animationState != null)
	assert(area != null)
	assert(inputHandler != null)
