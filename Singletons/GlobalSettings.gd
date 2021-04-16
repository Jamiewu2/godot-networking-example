extends Node

enum NETWORK_MODE {
	DETERMINISTIC_LOCKSTEP,
	SNAPSHOT_INTERPOLATION,
	STATE_SYNCHONIZATION,
	LOCAL
}

export var debug: bool = true
export var always_rollback: bool = true
var network_type: int = NETWORK_MODE.LOCAL
