class_name BehaviorPlayerShooter
extends EntityBehavior

@export_category("Bullet")
@export var unfocus_bullet : PackedScene
@export var unfocus_cooldown : float = 0.05
@export var focus_bullet : PackedScene
@export var focus_cooldown : float = 0.05
@export_category("Placement")
@export var unfocus_position : Vector2 = Vector2.ZERO
@export var focus_position : Vector2 = Vector2.ZERO

var focus_anim_speed: float = 20
var cooldown: float = unfocus_cooldown

func entity_process(delta: float) -> void:
	process_movement(delta)
	if cooldown < delta and Input.is_action_pressed("shoot"):
		process_shoot(delta)
	cooldown -= delta
	
func process_movement(delta: float) -> void:
	if Input.is_action_pressed("focus"):
		entity.position = MathUtils.lerp_smooth(entity.position, focus_position, focus_anim_speed, delta)
	else:
		entity.position = MathUtils.lerp_smooth(entity.position, unfocus_position, focus_anim_speed, delta)

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
