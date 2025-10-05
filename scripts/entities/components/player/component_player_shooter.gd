class_name ComponentPlayerShooter
extends EntityComponent

@export var unfocus_bullet : PackedScene
@export var unfocus_cooldown : float = 0.05
@export var focus_bullet : PackedScene
@export var focus_cooldown : float = 0.05
@export var bullet_offset : Vector2 = Vector2.ZERO

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
		bullet = focus_bullet.instantiate()
		cooldown = focus_cooldown
	else:
		bullet = unfocus_bullet.instantiate()
		cooldown = unfocus_cooldown
	
	GameVariables.game_view.add_child(bullet)
	bullet.collision_layer = Entity.CollisionMask.TARGET_ENEMY
	bullet.modulate.a = 0.3
	bullet.z_index = -10
	bullet.top_level = true
	bullet.global_position = entity.global_position
	bullet.position += bullet_offset
