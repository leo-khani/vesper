class_name PlayerUI extends CanvasLayer


@onready var xpprogress_ui: Control = %XPProgressUI
@onready var xp_bar: ProgressBar = %XPBar

func _ready():
	xpprogress_ui.visible = true


func test_xp_change() -> void:
	# Test for XP changes
	xp_bar.max_xp = 150
	xp_bar.current_xp = 50

	await get_tree().create_timer(2.0).timeout

	xp_bar.max_xp = 200
	xp_bar.current_xp = 120

	await get_tree().create_timer(2.0).timeout

	xp_bar.current_xp = 199