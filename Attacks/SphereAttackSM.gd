extends StateMachine

onready var idle: State = $Idle
onready var attack: State = $Attack

enum {
	IDLE,
	ATTACK
}

func _ready():
	self.states = {
		IDLE: idle,
		ATTACK: attack
	}
