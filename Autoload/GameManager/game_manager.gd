extends Node

@onready var execute_spell_timer: Timer = $ExecuteSpellTimer 

enum GameState {
	MAIN_MENU,
	LEVELING_UP,
	SHOP,
	PAUSED,
	GAME_OVER,
}

enum GamePlayState {
	NORMAL,
	EXECUTE_SPELL,
}


@export var current_state: GameState = GameState.MAIN_MENU: set = _on_state_changed
@export var current_gameplay_state: GamePlayState = GamePlayState.NORMAL

var is_paused: bool = false

@export var execute_spell_timer_time: float = 1.0

signal game_state_changed(new_state: GameState)
signal gameplay_state_changed(new_gameplay_state: GamePlayState)



#region SpellSystem
func toggle_execute_spell_state() -> void:
	if current_gameplay_state == GamePlayState.EXECUTE_SPELL:
		current_gameplay_state = GamePlayState.NORMAL
	else:
		current_gameplay_state = GamePlayState.EXECUTE_SPELL
	
	gameplay_state_changed.emit(current_gameplay_state)
	print("[GameManager.gd] - Gameplay state changed to: ", current_gameplay_state)

	
#endregion

func _on_state_changed(new_state: GameState) -> void:
	current_state = new_state
	game_state_changed.emit(current_state)

	print("[GameManager.gd] - Game state changed to: ", current_state)
