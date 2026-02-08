extends Node


enum GameState {
	MAIN_MENU,
	PLAYING,
	SHOP,
	PAUSED,
	GAME_OVER,
}

@export var current_state: GameState = GameState.MAIN_MENU: set = _on_state_changed

signal game_state_changed(new_state: GameState)


func _on_state_changed(new_state: GameState) -> void:
	current_state = new_state
	game_state_changed.emit(current_state)

	print("[GameManager.gd] - Game state changed to: ", current_state)