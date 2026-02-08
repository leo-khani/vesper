class_name Player extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite

@export_category("Player Settings")
@export var stats: PlayerStats = PlayerStats.new()
@export_subgroup("Animation Settings")
@export var has_tilt_animation: bool = true
@export var tilt_amount: float = 10.0

enum PlayerState {
	IDLE,
	MOVING,
}

@export var current_state: PlayerState = PlayerState.IDLE: set = _on_state_changed

# Private variables
var facing_direction: Vector2 = Vector2.RIGHT
var previous_facing_direction: Vector2 = Vector2.UP
var is_moving: bool = false

# Tweens
var tilt_tween: Tween


func _ready():
	NodeManager.player_node = self

#region MovementSystem
func _physics_process(delta):
	_handle_movement(delta)
	_handle_facing_direction()
	_update_animation_state() 
	_update_tilt_animation() 
	move_and_slide()


func _handle_movement(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	velocity = input_vector * stats.current_move_speed
#endregion


#region StateSystem
func _on_state_changed(new_state: PlayerState) -> void:
	current_state = new_state
	
	match current_state:
		PlayerState.IDLE:
			sprite.play("idle")
			_reset_tilt_animation()
		PlayerState.MOVING:
			sprite.play("run")


func _handle_facing_direction() -> void:
	if velocity.x > 0:
		facing_direction = Vector2.RIGHT
	elif velocity.x < 0:
		facing_direction = Vector2.LEFT

	sprite.flip_h = facing_direction == Vector2.LEFT
	
#endregion


#region AnimationSystem

func _update_animation_state() -> void:
	is_moving = velocity.length() > 0.2
	var target_state = PlayerState.MOVING if is_moving else PlayerState.IDLE
	
	if current_state != target_state:
		current_state = target_state

# This func tilts the sprite to the left or right based on the movement direction using tilt_tween.
func _update_tilt_animation() -> void:
	if not has_tilt_animation:
		return
	
	# Only tilt if moving, reset if not
	if not is_moving:
		return
	
	# Only retween if direction actually changed
	if facing_direction != previous_facing_direction:
		var target_tilt = tilt_amount if facing_direction == Vector2.RIGHT else -tilt_amount
		
		_reset_tweens(tilt_tween)
		tilt_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tilt_tween.tween_property(sprite, "rotation_degrees", target_tilt, 1.0)
		
		previous_facing_direction = facing_direction

func _reset_tilt_animation() -> void:
	if not has_tilt_animation:
		return
	
	_reset_tweens(tilt_tween)
	tilt_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tilt_tween.tween_property(sprite, "rotation_degrees", 0, 0.5)


func _reset_tweens(tween: Tween) -> void: if tween:	tween.kill()

#endregion

#region InputSystem
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("execute_spell"):
		GameManager.toggle_execute_spell_state()