extends Resource
class_name PlayerStatBuff

enum BuffType {
	MUILTIPLY,
	ADD,
}

@export var stat: PlayerStats.BuffableStats
@export var buff_amount: float
@export var buff_type: BuffType

func _init(_stats: PlayerStats.BuffableStats = PlayerStats.BuffableStats.MOVE_SPEED, _buff_amount: float = 1.0, _buff_type: BuffType = BuffType.MUILTIPLY) -> void:
	stat = _stats
	buff_amount = _buff_amount
	buff_type = _buff_type