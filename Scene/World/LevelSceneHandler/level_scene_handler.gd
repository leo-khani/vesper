@icon("res://Asset/UI/GodotIcons/icon_flag.png")
class_name LevelSceneHandler extends Node2D

@export_category("Scene Settings")
@export var map_name: String = "TestMap"
@export var spawn_position: Vector2 = Vector2.ZERO
@export var player_scene: PackedScene = preload("res://Scene/Characters/Player/player.tscn")

func _ready():
	start_level()

func start_level() -> void:
	GameManager.current_state = GameManager.GameState.PLAYING
	_spwan_player()



#region Player Spawning
func _spwan_player() -> void:
	var player_instance = player_scene.instantiate()
	player_instance.position = spawn_position
	add_child.call_deferred(player_instance)
#endregion