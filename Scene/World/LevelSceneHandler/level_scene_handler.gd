@icon("res://Asset/UI/GodotIcons/icon_flag.png")
class_name LevelSceneHandler extends Node2D

@export_category("Scene Settings")
@export var map_name: String = "TestMap"

func _ready():
	start_level()

func start_level() -> void:
	GameManager.current_state = GameManager.GameState.PLAYING