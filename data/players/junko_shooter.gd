extends ComponentPlayerShooter

var rotation: float = 0.0
var amount: int = 64
var speed: float = 0
var acceleration: float = 4000

func process_shoot_unfocused() -> void:
	rotation += PI/amount
	for i in range(amount):
		var bullet: Bullet = unfocus_bullet.duplicate()
		bullet.visible = true
		bullet.monitoring = true
		var direction := Vector2.from_angle(i * TAU/amount + rotation)
		if acceleration == 0:
			ComponentVelocity.add_to_entity(bullet, direction * speed)
		else:
			ComponentAcceleration.add_to_entity(bullet, direction * acceleration, direction * speed)
		GameVariables.game_area.add_bullet_player(bullet, entity.global_position)

func process_shoot_focused() -> void:
	var bullet: Bullet
	for i in range(5):
		bullet = focus_bullet.duplicate()
		bullet.visible = true
		cooldown = focus_cooldown
		GameVariables.game_area.add_bullet_player(bullet, entity.global_position)
		ComponentVelocity.add_to_entity(bullet, Vector2.UP * 5000)
		bullet.position -= Vector2.DOWN * 13 * i
