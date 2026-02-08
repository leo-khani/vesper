extends ProgressBar

@export var debug_prints: bool = false
var current_xp: int = 0: set = _on_xp_changed
var max_xp: int = 100: set = _on_max_xp_changed


var tween: Tween

func _on_xp_changed(new_xp: int) -> void:
	var target_value = new_xp % 100
	current_xp = target_value
	
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "value", target_value, 0.5)

	if debug_prints: print("XP changed: ", new_xp, " -> ", target_value)

func _on_max_xp_changed(new_max_xp: int) -> void:
	var target_value = new_max_xp % 100
	max_xp = target_value

	if debug_prints: print("Max XP changed: ", new_max_xp, " -> ", target_value)