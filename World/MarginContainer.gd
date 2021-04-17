extends MarginContainer

onready var fpsLabel = $HBoxContainer/VBoxContainer/FPSLabel
onready var memoryLabel = $HBoxContainer/VBoxContainer/MemoryLabel

func _ready():
	var my_style = StyleBoxFlat.new()
	my_style.set_bg_color(Color(0,0,0,0.2))

	fpsLabel.set("custom_styles/normal", my_style) 
	memoryLabel.set("custom_styles/normal", my_style) 

func _physics_process(delta):
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	var memory = Performance.get_monitor(Performance.MEMORY_STATIC)
	var memory_in_mb = round(memory/(1024 * 1024))
	fpsLabel.text = "FPS: " + str(fps)
	memoryLabel.text = "Memory: " + str(memory_in_mb) + " MB"
	
