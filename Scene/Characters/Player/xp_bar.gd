extends ProgressBar

@onready var level_up_effect: ColorRect = %LevelUpEffect


@export var debug_prints: bool = false
var current_xp: int = 0: set = _on_xp_changed
var max_xp: int = 100: set = _on_max_xp_changed
var is_leveling_up: bool = false: set = _on_level_up_changed

var tween: Tween

func _ready():
	GameManager.game_state_changed.connect(_on_game_state_changed)


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


func _on_level_up_changed(is_leveling: bool) -> void:
	is_leveling_up = is_leveling
	level_up_effect.visible = is_leveling_up

	if debug_prints: print("Leveling up state changed: ", is_leveling_up)


func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	if new_state == GameManager.GameState.LEVELING_UP:
		is_leveling_up = true
	else:
		is_leveling_up = false