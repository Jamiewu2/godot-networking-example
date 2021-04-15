extends StateMachine

onready var idle: State = $Idle
onready var attack: State = $Attack

enum {
	IDLE,
	ATTACK
}

# Called when the node enters the scene tree for the first time.
func _ready():
	self.states = {
		IDLE: idle,
		ATTACK: attack,
	}
