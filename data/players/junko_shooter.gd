extends ComponentPlayerShooter

var rotation: float = 0.0
var amount: int = 48
var speed: float = 0
var acceleration: float = 5000

const UNFOCUS_SCENE := preload("res://data/bullets/player/junko_small_circle.tscn")
const FOCUS_SCENE := preload("res://data/bullets/player/junko_partial_laser.tscn")
const LEFT_SCENE := preload("res://data/bullets/player/junko_left_laser.tscn")

func process_shoot_unfocused() -> void:
	rotation += PI/amount
	for i in range(amount):
		var bullet: Bullet = UNFOCUS_SCENE.instantiate()
		bullet.do_spawn_effect = false
		var direction := Vector2.from_angle(i * TAU/amount + rotation)
		ComponentAcceleration.add_to_entity(bullet, direction * acceleration, direction * speed)
		GameVariables.game_area.add_bullet_player(bullet, entity.global_position)

func process_shoot_focused() -> void:
	var bullet: Bullet
	for i in range(3):
		bullet = FOCUS_SCENE.instantiate()
		bullet.do_spawn_effect = false
		cooldown = focus_cooldown
		ComponentVelocity.add_to_entity(bullet, Vector2.UP * 5000)
		GameVariables.game_area.add_bullet_player(bullet, entity.global_position)
		bullet.position -= Vector2.DOWN * 20 * i
	
	spawn_side_laser(Vector2(-120, 0), Vector2(200, -1500))
	spawn_side_laser(Vector2(120, 0), Vector2(-200, -1500))
	
	spawn_side_laser(Vector2(-120, 0), Vector2(-160, -1500))
	spawn_side_laser(Vector2(120, 0), Vector2(160, -1500))

func spawn_side_laser(wave_vel: Vector2, vel: Vector2) -> void:
	var bullet: Bullet = LEFT_SCENE.instantiate()
	bullet.do_spawn_effect = false
	ComponentSineWave.add_to_entity(bullet, wave_vel, 15.0, vel)
	ComponentDisplacementRotation.add_to_entity(bullet)
	GameVariables.game_area.add_bullet_player(bullet, entity.global_position)
