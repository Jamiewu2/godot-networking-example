extends SaveablePosition3D
class_name SphereAttack

signal on_attack_finished


onready var animationTree: SaveableAnimationTree = $AnimationTree
onready var animationState: AnimationNodeStateMachinePlayback = animationTree.get("parameters/StateMachine/playback")
onready var meshInstance: MeshInstance = $MeshInstance
onready var area: Area = $Area
onready var stateMachine: StateMachine = $SphereAttackController/SphereAttackSM

export var default_color: Color = Color(0,0,0,0)

func _ready():
	meshInstance.get_surface_material(0).albedo_color = default_color
	animationTree.active = true

# TODO fix this with signals, this code is breaking out of the state machine
func perform_attack():
	if stateMachine.current_state == stateMachine.get_state_from_key(stateMachine.IDLE):
		stateMachine.change_state(stateMachine.ATTACK)

func _on_Attack_attack_finished():
	emit_signal("on_attack_finished")
	
func save_game_state() -> Array:
	var game_state = stateMachine.save_game_state()
	return game_state

func load_game_state(game_state: Array):
	stateMachine.load_game_state(game_state)
	animationTree.load_game_state(stateMachine.current_state.name, stateMachine.duration)
