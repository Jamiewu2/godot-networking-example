extends SaveablePosition3D
class_name SphereAttack

signal on_attack_finished

const SEEK_KEY = "parameters/Seek/seek_position"

onready var animationTree: AnimationTree = $AnimationTree
onready var animationState: AnimationNodeStateMachinePlayback = animationTree.get("parameters/StateMachine/playback")
onready var meshInstance: MeshInstance = $MeshInstance
onready var area: Area = $Area
onready var stateMachine: StateMachine = $SphereAttackController/SphereAttackSM

export var default_color: Color = Color(0,0,0,0)
export var IMPULSE_STRENGTH: float = 30


#workaround because it seems that you can't read the animation position from an animation tree
#HACK because of off by 1 frame bug 
#var time_in_attack: float = -0.0167
#var start_timer: bool = false

func _ready():
	meshInstance.get_surface_material(0).albedo_color = default_color
	animationTree.active = true

func perform_attack():
	if stateMachine.current_state == stateMachine.get_state_from_key(stateMachine.IDLE):
		stateMachine.change_state(stateMachine.ATTACK)

func _on_Attack_attack_finished():
	emit_signal("on_attack_finished")


	
## theres probably an off by 1 frame bug here
#func _physics_process(delta):
#	if start_timer:
#		time_in_attack += delta
#		if time_in_attack < 0:
#			time_in_attack = 0

#func save_game_state() -> Array:
#	var current_state = animationState.get_current_node()
#
#	#this happens on initialization, for some reason
#	if current_state == "": 
#		current_state = "Idle"
#
#	if current_state == "Idle" and start_counting:
#		frames_it_takes_to_switch += 1
#		return ["Attack", time_in_attack]
#	elif current_state == "Attack" and start_counting:
#		print("frames it takes to switch: " + str(frames_it_takes_to_switch))
#		start_counting = false
#		frames_it_takes_to_switch = 0		
#
#	if current_state != "Idle" and current_state != "Attack":
#		print("current_state" + str(current_state))
#
#	if current_state == "Idle":
#		var game_state = [current_state, 0]
#		return game_state
#	else:
#		var game_state = [current_state, time_in_attack]
#		return game_state
#
#func load_game_state(game_state: Array):
#	var current_state = game_state[0]
#	var time_in_attack = game_state[1]
#
#	if current_state != "Idle" and time_in_attack == 0:
#		start_counting = true
#
#	animationState.travel(current_state)
#	if current_state != "Idle":
#		animationTree.set(SEEK_KEY, time_in_attack) 

