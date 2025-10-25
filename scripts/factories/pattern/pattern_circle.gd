class_name PatternCircle
extends PatternFactory

@export var position: Vector2
@export var rotation: float = 0.0
@export var amount: int = 16

@export var speed: float = 100
@export var acceleration: float = 0

@export var arc_angle: float = TAU
@export var offset: Vector2
@export var bullet_scene: PackedScene

func create() -> Array[Bullet]:
	spawned_bullets.clear()
	for i in range(amount):
		var bullet: Bullet = bullet_scene.instantiate()
		var angle: float = i * arc_angle/amount + rotation
		var direction := Vector2.from_angle(angle)
		if acceleration == 0:
			ComponentVelocity.add_to_entity(bullet, direction * speed)
		else:
			ComponentAcceleration.add_to_entity(bullet, direction * acceleration, direction * speed)
		GameVariables.game_area.add_bullet(bullet, position)
		if offset:
			bullet.position += offset.rotated(angle)
		spawned_bullets.push_back(bullet)
	return spawned_bullets
