class_name SpellStats extends Resource

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export_group("Spell Info")
@export var spell_name: String = "Unnamed Spell"
@export var spell_icon: Texture2D
@export_multiline var description: String = ""

@export_group("Combo Sequence")
## The sequence of directions to activate this spell (e.g., UP, UP, DOWN, LEFT)
@export var combo_sequence: Array[Direction] = []

@export_group("Spell Properties")
@export var cooldown_time: float = 5.0
@export var mana_cost: int = 10
@export var damage: int = 50
@export var cast_time: float = 0.5

## Optional: Scene to spawn (projectile, effect, etc.)
@export var spell_scene: PackedScene


## Check if the input sequence matches this combo
func matches_sequence(input_sequence: Array) -> bool:
	if input_sequence.size() != combo_sequence.size():
		return false
	
	for i in range(combo_sequence.size()):
		if input_sequence[i] != combo_sequence[i]:
			return false
	
	return true


## Get combo as a string for UI display (e.g., "↑↑↓←")
func get_combo_string() -> String:
	var result = ""
	for dir in combo_sequence:
		match dir:
			Direction.UP:
				result += "↑"
			Direction.DOWN:
				result += "↓"
			Direction.LEFT:
				result += "←"
			Direction.RIGHT:
				result += "→"
	return result


## Get combo as text (e.g., "UP UP DOWN LEFT")
func get_combo_text() -> String:
	var result = ""
	for i in range(combo_sequence.size()):
		match combo_sequence[i]:
			Direction.UP:
				result += "UP"
			Direction.DOWN:
				result += "DOWN"
			Direction.LEFT:
				result += "LEFT"
			Direction.RIGHT:
				result += "RIGHT"
		
		if i < combo_sequence.size() - 1:
			result += " "
	
	return result
