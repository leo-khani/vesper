class_name Player extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite

@export_category("Player Settings")
@export var stats: PlayerStats = PlayerStats.new()

enum PlayerState {
	IDLE,
	MOVING,
}

@export var current_state: PlayerState = PlayerState.IDLE: set = _on_state_changed

# Private variables
var facing_direction: Vector2 = Vector2.RIGHT

#region MovementSystem
func _physics_process(delta):
	# Check if the player is moving
	if velocity.length() > 0:
		if current_state != PlayerState.MOVING:
			current_state = PlayerState.MOVING

	_handle_movement(delta)
	_handle_facing_direction()


func _handle_movement(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	velocity = input_vector * stats.speed
	move_and_slide()
#endregion


#region StateSystem
func _on_state_changed(new_state: PlayerState) -> void:
	current_state = new_state   

	match current_state:
		PlayerState.IDLE:
			sprite.play("idle")
		PlayerState.MOVING:
			sprite.play("run")


func _handle_facing_direction():
	if velocity.x > 0:
		facing_direction = Vector2.RIGHT
	elif velocity.x < 0:
		facing_direction = Vector2.LEFT

	sprite.flip_h = facing_direction == Vector2.LEFT
#endregion