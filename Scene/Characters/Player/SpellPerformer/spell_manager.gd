class_name SpellManager extends Node
# Example: How to integrate SpellPerformer into your Player scene

@onready var spell_performer: SpellPerformer = $SpellPerformer
@onready var player: Player = get_parent()  # Assuming this script is a child of Player


func _ready() -> void:
	await get_tree().process_frame  # Ensure everything is ready before connecting signals
	await get_tree().process_frame  
	await get_tree().process_frame  
	await get_tree().process_frame  
	await get_tree().process_frame  
	GameManager.gameplay_state_changed.connect(_on_gameplay_state_changed)

	# Connect spell performer signals
	spell_performer.combo_completed.connect(_on_spell_cast)
	spell_performer.combo_failed.connect(_on_combo_failed)
	spell_performer.input_added.connect(_on_input_added)
	spell_performer.combo_progress_changed.connect(_on_combo_progress)
	
	# Activate the spell system
	disable_spell_casting()


func _on_spell_cast(spell: SpellStats) -> void:
	print("✨ Casting spell: ", spell.spell_name)
	print("Combo was: ", spell.get_combo_string())
	print("Cooldown: ", spell.cooldown_time, " seconds")
	
	# Check if player has enough mana (if you have a mana system)
	# if player.stats.current_mana < spell.mana_cost:
	#     print("Not enough mana!")
	#     return
	
	# Deduct mana
	# player.stats.current_mana -= spell.mana_cost
	
	# Spawn spell effect/projectile
	if spell.spell_scene:
		var spell_instance = spell.spell_scene.instantiate()
		get_tree().current_scene.add_child(spell_instance)
		
		# Position at player
		if spell_instance is Node2D:
			spell_instance.global_position = player.global_position
	
	# Play cast animation (if you have one)
	# player.sprite.play("cast")
	
	# Apply damage or effects
	_apply_spell_effects(spell)


func _on_combo_failed() -> void:
	print("❌ Invalid combo - sequence reset")
	# Play error sound
	# Show UI feedback


func _on_input_added(direction: SpellStats.Direction) -> void:
	print("Input: ", SpellStats.Direction.keys()[direction])
	# Play UI sound
	# Show visual feedback


func _on_combo_progress(current_sequence: String) -> void:
	print("Current combo: ", current_sequence)
	# Update UI label to show current combo
	# Example: combo_label.text = current_sequence


func _apply_spell_effects(spell: SpellStats) -> void:
	# Apply spell-specific logic here
	match spell.spell_name:
		"Fireball":
			print("🔥 Fireball deals ", spell.damage, " damage!")
		"Ice Shard":
			print("❄️ Ice Shard deals ", spell.damage, " damage and slows!")
		"Lightning":
			print("⚡ Lightning deals ", spell.damage, " damage!")
		"Heal":
			print("💚 Healed for ", abs(spell.damage), " HP!")
			# player.stats.current_health += abs(spell.damage)


# Example: Toggle spell system based on game state
func enable_spell_casting() -> void:
	spell_performer.activate()


func disable_spell_casting() -> void:
	spell_performer.deactivate()


# Example: Check if a specific spell is ready
func is_spell_ready(spell_name: String) -> bool:
	return not spell_performer.is_spell_on_cooldown(spell_name)

func _on_gameplay_state_changed(new_state: GameManager.GamePlayState) -> void:
	match new_state:
		GameManager.GamePlayState.EXECUTE_SPELL:
			enable_spell_casting()
			print("Spell casting enabled!")
		_:
			disable_spell_casting()
			print("Spell casting disabled!")
