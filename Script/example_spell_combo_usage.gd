# Example usage in your Player or Game scene
extends Node2D

@onready var combo_handler: SpellComboHandler = $SpellComboHandler


func _ready() -> void:
	# Connect signals
	combo_handler.combo_completed.connect(_on_combo_completed)
	combo_handler.combo_failed.connect(_on_combo_failed)
	combo_handler.input_added.connect(_on_input_added)


func _on_combo_completed(spell: SpellCombo) -> void:
	print("Spell activated: ", spell.spell_name)
	print("Combo was: ", spell.get_combo_string())
	
	# Cast the spell
	_cast_spell(spell)


func _on_combo_failed() -> void:
	print("Invalid combo - resetting")


func _on_input_added(direction: SpellCombo.Direction) -> void:
	print("Input: ", direction)
	print("Current sequence: ", combo_handler.get_current_input_string())


func _cast_spell(spell: SpellCombo) -> void:
	# Check mana cost
	# Check cooldown
	# Spawn spell scene
	# Apply effects
	
	if spell.spell_scene:
		var spell_instance = spell.spell_scene.instantiate()
		add_child(spell_instance)
