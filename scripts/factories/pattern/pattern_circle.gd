class_name PatternCircle
extends PatternFactory

@export var position: Vector2
@export var rotation: float = 0.0
@export var amount: int = 16
@export var speed: float = 100
@export var acceleration: float = 100
@export var base_bullet: Bullet

func create() -> Array[Bullet]:
	var bullets: Array[Bullet] = []
	for i in range(amount):
		var bullet: Bullet = base_bullet.duplicate()
		var direction := Vector2.from_angle(i * TAU/amount + rotation)
		if acceleration != 0:
			ComponentAcceleration.add_to_entity(bullet, direction * acceleration, direction * speed)
		else:
			ComponentVelocity.add_to_entity(bullet, direction * speed)
		GameVariables.game_area.add_bullet(bullet, position)
	return bullets
