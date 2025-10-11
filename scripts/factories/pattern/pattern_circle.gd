class_name PatternCircle
extends PatternFactory

@export var position: Vector2
@export var amount = 16
@export var speed = 100
@export var acceleration = 100

func create() -> Array[Bullet]:
	var bullets: Array[Bullet] = []
	for i in range(amount):
		var bullet: Bullet = EntityEnums.get_bullet(
			EntityEnums.BulletType.CIRCLE_BORDERED,
			EntityEnums.BulletColor.RED
		)
		var direction := Vector2.from_angle(i * TAU/amount)
		if acceleration != 0:
			ComponentAcceleration.add_to_entity(bullet, direction * acceleration, direction * speed)
		else:
			ComponentVelocity.add_to_entity(bullet, direction * speed)
		GameVariables.game_view.add_bullet(bullet, position)
	return bullets
