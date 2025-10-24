extends ComponentPlayerShooter

var rotation: float = 0.0
var amount: int = 64
var speed: float = 0
var acceleration: float = 4000

const UNFOCUS_SCENE := preload("res://data/bullets/player/junko_small_circle.tscn")
const FOCUS_SCENE := preload("res://data/bullets/player/junko_partial_laser.tscn")

func process_shoot_unfocused() -> void:
	rotation += PI/amount
	for i in range(amount):
		var bullet: Bullet = UNFOCUS_SCENE.instantiate()
		bullet.visible = true
		bullet.monitoring = true
		bullet.do_spawn_effect = false
		var direction := Vector2.from_angle(i * TAU/amount + rotation)
		if acceleration == 0:
			ComponentVelocity.add_to_entity(bullet, direction * speed)
		else:
			ComponentAcceleration.add_to_entity(bullet, direction * acceleration, direction * speed)
		GameVariables.game_area.add_bullet_player(bullet, entity.global_position)

func process_shoot_focused() -> void:
	var bullet: Bullet
	for i in range(3):
		bullet = FOCUS_SCENE.instantiate()
		bullet.visible = true
		bullet.monitoring = true
		bullet.do_spawn_effect = false
		cooldown = focus_cooldown
		GameVariables.game_area.add_bullet_player(bullet, entity.global_position)
		ComponentVelocity.add_to_entity(bullet, Vector2.UP * 5000)
		bullet.position -= Vector2.DOWN * 20 * i
