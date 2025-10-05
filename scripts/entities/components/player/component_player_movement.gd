class_name ComponentPlayerMovement
extends EntityComponent

@export var speed: int = 400
@export var focus_speed: int = 200
@export var player_sprite: AnimatedSprite2D
@export var focus_sprite: Sprite2D
@export var graze_sprite: Sprite2D

var velocity: Vector2 = Vector2.ZERO
var graze_rotation_speed: float = 1
var focus_anim_speed: float = 20
var focused_scale: Vector2 = Vector2.ONE * 2
var unfocused_scale: Vector2 = Vector2.ONE * 3
var focused_alpha: float = 1
var unfocused_alpha: float = 0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	process_movement(delta)
	process_focus(delta)

func get_speed() -> int:
	if Input.is_action_pressed("focus"):
		return focus_speed
	return speed

func process_movement(delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x = 1
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
	if Input.is_action_pressed("move_down"):
		velocity.y = 1
	if Input.is_action_pressed("move_up"):
		velocity.y = -1
	
	entity.position += velocity * get_speed() * delta
	entity.position = entity.position.clamp(Vector2.ZERO, GameUtils.game_area)
	
	if velocity.x < 0: 
		player_sprite.play("left")
	elif velocity.x > 0:
		player_sprite.play("right")
	else:
		player_sprite.play("default")

func process_focus(delta: float) -> void:
	graze_sprite.rotate(graze_rotation_speed * delta)
	if Input.is_action_pressed("focus"):
		focus_sprite.modulate.a = MathUtils.lerp_smooth(focus_sprite.modulate.a, focused_alpha, focus_anim_speed, delta)
		focus_sprite.scale = MathUtils.lerp_smooth(focus_sprite.scale, focused_scale, focus_anim_speed, delta)
		graze_sprite.modulate.a = MathUtils.lerp_smooth(graze_sprite.modulate.a, focused_alpha, focus_anim_speed, delta)
		graze_sprite.scale = MathUtils.lerp_smooth(graze_sprite.scale, focused_scale, focus_anim_speed, delta)
	else:
		focus_sprite.modulate.a = MathUtils.lerp_smooth(focus_sprite.modulate.a, unfocused_alpha, focus_anim_speed, delta)
		focus_sprite.scale = MathUtils.lerp_smooth(focus_sprite.scale, unfocused_scale, focus_anim_speed, delta)
		graze_sprite.modulate.a = MathUtils.lerp_smooth(graze_sprite.modulate.a, unfocused_alpha, focus_anim_speed, delta)
		graze_sprite.scale = MathUtils.lerp_smooth(graze_sprite.scale, unfocused_scale, focus_anim_speed, delta)
