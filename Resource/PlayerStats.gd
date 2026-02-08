extends Resource
class_name PlayerStats

enum BuffableStats {
	MOVE_SPEED,
}

const STATS_CURVES: Dictionary[BuffableStats, Curve] = {
	#BuffableStats.MOVE_SPEED: preload("uid://b8cgfad42ov5p"),
}

@export var base_max_health: float = 3
@export var base_move_speed: float = 150.0
@export var base_experience_multiplier: float = 1
@export var experience: float = 0.0: set = _on_experience_set

var level: int:
	get(): return floor(max(1.0, sqrt(experience / 100) + 0.5))
var current_max_health: float
var current_move_speed: float
var current_experience_multiplier: float

var health: float = 0: set = _on_health_set

var stats_buffs: Array[PlayerStatBuff]

func _init():
	setup_stats.call_deferred()

func setup_stats() -> void:
	recalculate_stats()
	health = current_max_health

func add_buff(buff: PlayerStatBuff) -> void:
	stats_buffs.append(buff)
	recalculate_stats.call_deferred()

	print("Added buff: ", buff.buff_amount, " - ", buff.buff_type, " - ", BuffableStats.keys()[buff.stat])

func remove_buff(buff: PlayerStatBuff) -> void:
	stats_buffs.erase(buff)
	recalculate_stats.call_deferred()


func recalculate_stats() -> void:
	var stats_multipliers: Dictionary = {}
	for buff in stats_buffs:
		var stats_name: String = BuffableStats.keys()[buff.stat].to_lower()
		match buff.buff_type:
			PlayerStatBuff.BuffType.MUILTIPLY:
				if not stats_multipliers.has(stats_name):
					stats_multipliers[stats_name] = 1.0
				stats_multipliers[stats_name] *= buff.buff_amount

				if stats_multipliers[stats_name] < 0.0:
					stats_multipliers[stats_name] = 0.0

	var stats_sample_pos: float = (float(level) / 100.0) - 0.01
	#current_move_speed = base_move_speed * STATS_CURVES[BuffableStats.MOVE_SPEED].sample(stats_sample_pos)

	# Initialize experience multiplier
	current_experience_multiplier = base_experience_multiplier
	current_max_health = base_max_health
	
	for stats_name in stats_multipliers:
		var cur_property_name: String = str("current_" + stats_name)
		set(cur_property_name, get(cur_property_name) * stats_multipliers[stats_name])





func _on_health_set(new_value: float) -> void:
	health = clampf(new_value, 0, current_max_health)
	# Round the health to be an integer
	health = round(health)


func _on_experience_set(new_value: float) -> void:
	var old_level = level
	experience = new_value

	if old_level != level:
		recalculate_stats()

func add_xp(amount: float) -> void:
	var final_xp = amount * current_experience_multiplier
	experience += final_xp
