extends Spatial

var cube_scene: PackedScene = preload("res://Objects/Cube.tscn")
onready var timer: Timer = $Timer

export var max_spawn_count: int = 5
export var spawn_speed: float = 0.4

var spawn_count: int = 0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
const FORCE: int = 1000
const RNG_SEED: int = 1234

func _ready():
	timer.wait_time = spawn_speed
	rng.set_seed(RNG_SEED)
	
func spawn_cube():
	var cube: RigidBody = cube_scene.instance()
	var x = rng.randf_range(-0.1, 0.1)
	var z = rng.randf_range(-0.1, 0.1)
		
	var impulse_vector: Vector3 = Vector3(x, 1, z).normalized()
	cube.add_central_force(impulse_vector * FORCE)
	self.add_child(cube)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_spawn"):
		spawn_count = 0
		timer.start()

func _on_Timer_timeout():
	if spawn_count >= max_spawn_count:
		timer.stop()
	else:
		spawn_count += 1
		spawn_cube()
