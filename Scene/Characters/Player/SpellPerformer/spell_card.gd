class_name SpellCard extends Control


@onready var icon: TextureRect = %Icon
@onready var name_label: Label = %NameLabel
@onready var inputs_hbox: HBoxContainer = %InputsHBox

@export var texture_up: Texture2D # Facing UP
@export var texture_down: Texture2D # Facing DOWN
@export var texture_left: Texture2D # Facing LEFT
@export var texture_right: Texture2D # Facing RIGHT

@export var example_spell: SpellStats


func _ready() -> void:
	if example_spell:
		setup(example_spell)

func setup(spell: SpellStats) -> void:
	name_label.text = spell.spell_name
	icon.texture = spell.spell_icon
	
	# Clear previous inputs
	for child in inputs_hbox.get_children():
		child.queue_free()
	
	# Add input icons
	for direction in spell.combo_sequence:
		var dir_icon = TextureRect.new()
		dir_icon.texture = _get_direction_icon(direction)
		inputs_hbox.add_child(dir_icon)


func _get_direction_icon(direction: SpellStats.Direction) -> Texture2D:
	match direction:
		SpellStats.Direction.UP:
			return texture_up
		SpellStats.Direction.DOWN:
			return texture_down
		SpellStats.Direction.LEFT:
			return texture_left
		SpellStats.Direction.RIGHT:
			return texture_right
	return null
