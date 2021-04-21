extends CanvasLayer


onready var colorRect = $ColorRect

func _ready():
	pass


func _physics_process(delta):
	if Rewind.rewind_time:
		colorRect.show()
	else:
		colorRect.hide()
