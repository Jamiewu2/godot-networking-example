extends Node

enum NETWORK_MODE {
	DETERMINISTIC_LOCKSTEP,
	SNAPSHOT_INTERPOLATION,
	STATE_SYNCHONIZATION,
	LOCAL
}

export var DEBUG: bool = false
export var DEBUG_ALWAYS_ROLLBACK: bool = true
var network_type: int = NETWORK_MODE.LOCAL
