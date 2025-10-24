class_name ComponentPlayerShooter
extends EntityComponent

@export var unfocus_bullet: PackedScene
@export var unfocus_cooldown: float = 0.05
@export var focus_bullet: PackedScene
@export var focus_cooldown: float = 0.05
@export var bullet_offset: Vector2 = Vector2.ZERO
@export_range(-180, 180, 0.001, "radians_as_degrees") var bullet_rotation: float = 0

var cooldown: float = unfocus_cooldown

func _physics_process(delta: float) -> void:
	if !entity.visible:
		return
	if cooldown < delta and Input.is_action_pressed("shoot"):
		if Input.is_action_pressed("focus"):
			process_shoot_focused()
			cooldown = focus_cooldown
		else:
			process_shoot_unfocused()
			cooldown = unfocus_cooldown
	cooldown -= delta

func process_shoot_unfocused() -> void:
	var bullet: Bullet = focus_bullet.instantiate()
	bullet.visible = true
	GameVariables.game_area.add_bullet_player(bullet, entity.global_position + bullet_offset)
	bullet.rotation = bullet_rotation

func process_shoot_focused() -> void:
	var bullet: Bullet = unfocus_bullet.instantiate()
	bullet.visible = true
	GameVariables.game_area.add_bullet_player(bullet, entity.global_position + bullet_offset)
	bullet.rotation = bullet_rotation
