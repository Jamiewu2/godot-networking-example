extends StateMachine

onready var idle: State = $Idle
onready var move: State = $Move

enum {
	IDLE,
	MOVE
}

func _ready():
	self.states = {
		IDLE: idle,
		MOVE: move
	}
