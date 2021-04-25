extends RigidBody
class_name Cube

var active_material: Material = preload("res://Materials/Active.material")
var sleeping_material: Material = preload("res://Materials/Sleeping.material")

onready var mesh_instance: MeshInstance = $MeshInstance

func _on_Cube_sleeping_state_changed():
	if !sleeping:
		mesh_instance.set_surface_material(0,active_material)
	else: 
		mesh_instance.set_surface_material(0,sleeping_material)


#this is just here so i dont completely lag the game
func _process(delta):
	var y = self.translation.y
	if y < -50:
		print("freed cube id: " + str(get_instance_id()))
		queue_free()
