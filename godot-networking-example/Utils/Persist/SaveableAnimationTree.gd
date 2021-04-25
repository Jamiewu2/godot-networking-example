extends AnimationTree
class_name SaveableAnimationTree

# There does not seem to be an easy way to get current animation state
# I'm going to handle saving animation state from elsewhere
func save_game_state():
	# don't call this
	assert(false)

func load_game_state(game_state, animation_duration: float):
	pass
