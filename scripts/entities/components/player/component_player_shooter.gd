class_name ComponentPlayerShooter
extends EntityComponent

@export var unfocus_bullet_factory: BulletFactory
@export var unfocus_cooldown: float = 0.05
@export var focus_bullet_factory: BulletFactory
@export var focus_cooldown: float = 0.05
@export var bullet_offset: Vector2 = Vector2.ZERO
@export_range(-180, 180, 0.001, "radians_as_degrees") var bullet_rotation: float = 0

var cooldown: float = unfocus_cooldown

func _physics_process(delta: float) -> void:
	if !entity.visible:
		return
	if cooldown < delta and Input.is_action_pressed("shoot"):
		process_shoot(delta)
	cooldown -= delta

func process_shoot(delta: float) -> void:
	var bullet : Bullet
	if Input.is_action_pressed("focus"):
		bullet = focus_bullet_factory.create()
		cooldown = focus_cooldown
	else:
		bullet = unfocus_bullet_factory.create()
		cooldown = unfocus_cooldown
	GameVariables.game_view.add_bullet_player(bullet, entity.position + bullet_offset)
	bullet.rotation = bullet_rotation
