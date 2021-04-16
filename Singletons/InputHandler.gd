extends Node

var input_vector: Vector3

func _unhandled_input(event):
	input_vector = _get_input_vector()
	
	
func _get_input_vector() -> Vector3:
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector.normalized()

