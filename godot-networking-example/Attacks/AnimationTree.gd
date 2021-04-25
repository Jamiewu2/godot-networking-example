extends SaveableAnimationTree

const SEEK_KEY = "parameters/Seek/seek_position"
const TIMESCALE_KEY = "parameters/TimeScale/scale"
onready var animationState: AnimationNodeStateMachinePlayback = get("parameters/StateMachine/playback")

func load_game_state(animation_name, animation_duration):
	animationState.travel(animation_name)
	self.set(SEEK_KEY, animation_duration) 
