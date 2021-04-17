extends StateMachine


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var idle: State = $Idle
onready var move: State = $Move

enum {
	IDLE,
	MOVE
}

# Called when the node enters the scene tree for the first time.
func _ready():
	self.states = {
		IDLE: idle,
		MOVE: move
	}
