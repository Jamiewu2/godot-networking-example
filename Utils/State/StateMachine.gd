extends SaveableNode
class_name StateMachine

const GROUP = "StateMachineGroup"

export var states: Dictionary = {}
var current_state: State
var previous_states: Array = []
export var active: bool = true
var duration: float = 0

func _ready():
	yield(self.owner, "ready")
	
	add_to_group(GROUP)
	
	for child in get_children():
		child.state_machine = self
	
	var init_state: State = get_child(0)
	init_state.run_on_enter()
	
	previous_states.append(init_state)
	current_state = init_state

func _physics_process(delta):
	update(delta)
	
func update(delta):
	if active:
		current_state.update(delta)
	duration += delta
	
func get_state_from_key(state_key):
	return states[state_key]

func change_state(state_key, go_to_previous: bool = false):
	if state_key == null:
		push_error("State should not be null")
		
	var new_state: State = states[state_key]
	assert(new_state != null)
	
	if go_to_previous:
		var previous_state = previous_states.pop_back()
		if not previous_state:
			push_error("Previous state is null")
		self.current_state = _transition_state(current_state, previous_state)
		
	elif self.current_state == new_state:
		return
	else:
		# only 1 level of previous recorded
		previous_states[0] = current_state
		self.current_state = _transition_state(current_state, new_state)
	duration = 0
		
func _transition_state(old_state: State, new_state: State) -> State:
	old_state.run_on_exit()
	new_state.run_on_enter()
	return new_state

# not going to save states dict, assuming states will not be added dynamically
func save_game_state() -> Array:
	var game_state = [current_state, previous_states, active, duration, current_state.name]
	return game_state
	
func load_game_state(game_state: Array):
	self.current_state = game_state[0]
	self.previous_states = game_state[1]
	self.active = game_state[2]
	self.duration = game_state[3]
	
