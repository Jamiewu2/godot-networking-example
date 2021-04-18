extends SaveableAnimationTree

const SEEK_KEY = "parameters/Seek/seek_position"
onready var animationState: AnimationNodeStateMachinePlayback = get("parameters/StateMachine/playback")

func load_game_state(animation_name, animation_duration):
	animationState.travel(animation_name)
	self.set(SEEK_KEY, animation_duration) 
