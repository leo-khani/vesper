class_name SpellPerformer extends Node

## Emitted when a valid combo is completed
signal combo_completed(spell: SpellStats)
signal combo_failed()
signal input_added(direction: SpellStats.Direction)
signal combo_progress_changed(current_sequence: String)

@export_group("Spell System")
@export var available_spells: Array[SpellStats] = []
@export var max_sequence_length: int = 8
@export var input_timeout: float = 2.0  ## Time before combo resets
@export var allow_input_when_inactive: bool = false

var is_active: bool = false
var current_input_sequence: Array[SpellStats.Direction] = []
var timeout_timer: float = 0.0
var cooldown_timers: Dictionary = {}  ## spell_name: time_remaining


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	# Countdown timeout timer
	if timeout_timer > 0:
		timeout_timer -= delta
		if timeout_timer <= 0:
			_reset_combo()
	
	# Update cooldown timers
	_update_cooldowns(delta)


func _input(event: InputEvent) -> void:
	if not is_active and not allow_input_when_inactive:
		return
	
	var direction: SpellStats.Direction = -1
	
	if event.is_action_pressed("move_up"):
		direction = SpellStats.Direction.UP
	elif event.is_action_pressed("move_down"):
		direction = SpellStats.Direction.DOWN
	elif event.is_action_pressed("move_left"):
		direction = SpellStats.Direction.LEFT
	elif event.is_action_pressed("move_right"):
		direction = SpellStats.Direction.RIGHT
	
	if direction != -1:
		_add_input(direction)


func _add_input(direction: SpellStats.Direction) -> void:
	current_input_sequence.append(direction)
	input_added.emit(direction)
	combo_progress_changed.emit(get_current_input_string())
	
	# Reset timeout
	timeout_timer = input_timeout
	set_process(true)
	
	# Check if sequence is too long
	if current_input_sequence.size() > max_sequence_length:
		_reset_combo()
		combo_failed.emit()
		return
	
	# Check if current sequence is a valid prefix for any spell (Helldivers-style)
	if not _is_valid_prefix():
		combo_failed.emit()
		_reset_combo()
		return
	
	# Check for matching combos
	_check_for_combo()


func _check_for_combo() -> void:
	for spell in available_spells:
		if spell.matches_sequence(current_input_sequence):
			# Check if spell is on cooldown
			if is_spell_on_cooldown(spell.spell_name):
				combo_failed.emit()
				_reset_combo()
				return
			
			combo_completed.emit(spell)
			_start_cooldown(spell)
			_reset_combo()
			return


func _is_valid_prefix() -> bool:
	"""Check if current input sequence could lead to any valid spell (Helldivers-style)"""
	for spell in available_spells:
		# Skip spells shorter than current sequence
		if spell.combo_sequence.size() < current_input_sequence.size():
			continue
		
		# Check if spell's combo starts with current sequence
		var matches = true
		for i in range(current_input_sequence.size()):
			if spell.combo_sequence[i] != current_input_sequence[i]:
				matches = false
				break
		
		if matches:
			return true
	
	return false


func _reset_combo() -> void:
	current_input_sequence.clear()
	timeout_timer = 0.0
	combo_progress_changed.emit("")
	set_process(false)


func _update_cooldowns(delta: float) -> void:
	var keys_to_remove = []
	
	for spell_name in cooldown_timers.keys():
		cooldown_timers[spell_name] -= delta
		if cooldown_timers[spell_name] <= 0:
			keys_to_remove.append(spell_name)
	
	for key in keys_to_remove:
		cooldown_timers.erase(key)


func _start_cooldown(spell: SpellStats) -> void:
	cooldown_timers[spell.spell_name] = spell.cooldown_time


## Get current input as string for UI (e.g., "↑↓←")
func get_current_input_string() -> String:
	var result = ""
	for dir in current_input_sequence:
		match dir:
			SpellStats.Direction.UP:
				result += "↑"
			SpellStats.Direction.DOWN:
				result += "↓"
			SpellStats.Direction.LEFT:
				result += "←"
			SpellStats.Direction.RIGHT:
				result += "→"
	return result


## Check if a spell is currently on cooldown
func is_spell_on_cooldown(spell_name: String) -> bool:
	return cooldown_timers.has(spell_name)


## Get remaining cooldown time for a spell
func get_cooldown_remaining(spell_name: String) -> float:
	if cooldown_timers.has(spell_name):
		return cooldown_timers[spell_name]
	return 0.0


## Activate spell input system
func activate() -> void:
	is_active = true


## Deactivate spell input system
func deactivate() -> void:
	is_active = false
	_reset_combo()


## Manually cancel current combo
func cancel_combo() -> void:
	_reset_combo()
	combo_failed.emit()