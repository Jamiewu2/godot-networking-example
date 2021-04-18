extends Stats
class_name PlayerStats

# consts
export var ACCELERATION: int = 70
export var MAX_SPEED: int = 25
export var FRICTION: int = 50

# not consts
export var default_velocity: Vector3 = Vector3.ZERO
export var default_input_vector: Vector3 = Vector3.ZERO
var velocity: Vector3 setget set_velocity, get_velocity
var input_vector: Vector3 setget set_input_vector, get_input_vector

func _ready():
	stats_constant["acceleration"] = ACCELERATION
	stats_constant["max_speed"] = MAX_SPEED
	stats_constant["friction"] = FRICTION
	stats["velocity"] = default_velocity
	stats["input_vector"] = default_input_vector

# boilerplate time
func set_velocity(new_velocity: Vector3): 
	stats["velocity"] = new_velocity
	
func get_velocity() -> Vector3:
	return stats["velocity"]
	
func set_input_vector(input_vector: Vector3): 
	stats["input_vector"] = input_vector
	
func get_input_vector() -> Vector3:
	return stats["input_vector"]
