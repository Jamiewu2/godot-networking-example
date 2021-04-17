extends KinematicBody
class_name SaveableKinematicBody

#This is an "interface" but as far as I can tell there isn't a clean way to do that
#in gdscript, so time to make a bunch of classes

#TODO use godot scene groups to make this a lot easier???

func save_game_state():
	pass

func load_game_state(game_state):
	pass
