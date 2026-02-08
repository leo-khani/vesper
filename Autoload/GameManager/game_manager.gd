extends Node

@onready var execute_spell_timer: Timer = $ExecuteSpellTimer 

enum GameState {
	MAIN_MENU,
	LEVELING_UP,
	PLAYING,
	SHOP,
	PAUSED,
	GAME_OVER,
}

enum GamePlayState {
	NORMAL,
	EXECUTE_SPELL,
}


@export var current_state: GameState = GameState.PLAYING: set = _on_state_changed
@export var current_gameplay_state: GamePlayState = GamePlayState.NORMAL : set = _on_current_gameplay_state_changed

var is_paused: bool = false

@export var execute_spell_timer_time: float = 1.0

signal game_state_changed(new_state: GameState)
signal gameplay_state_changed(new_gameplay_state: GamePlayState)


func _on_current_gameplay_state_changed(new_gameplay_state: GamePlayState) -> void:
	if current_state != GameState.PLAYING:
		return

	current_gameplay_state = new_gameplay_state
	gameplay_state_changed.emit(current_gameplay_state)

	print("[GameManager.gd] - Gameplay state changed to: ", current_gameplay_state)


func change_time_scale(new_time_scale: float) -> void:
	Engine.time_scale = new_time_scale

#region SpellSystem
func toggle_execute_spell_state() -> void:
	if current_gameplay_state == GamePlayState.EXECUTE_SPELL:
		current_gameplay_state = GamePlayState.NORMAL	
		change_time_scale(1.0)
	else:
		current_gameplay_state = GamePlayState.EXECUTE_SPELL
		change_time_scale(0.2)
		
	gameplay_state_changed.emit(current_gameplay_state)
	print("[GameManager.gd] - Gameplay state changed to: ", current_gameplay_state)

	
#endregion

func _on_state_changed(new_state: GameState) -> void:
	current_state = new_state
	game_state_changed.emit(current_state)

	print("[GameManager.gd] - Game state changed to: ", current_state)
