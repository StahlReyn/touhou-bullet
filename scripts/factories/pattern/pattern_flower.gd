class_name PatternFlower
extends PatternFactory

@export var position: Vector2
@export var petal_count: int = 6
@export var petal_size: int = 5
@export var speed_min: float = 100.0
@export var speed_max: float = 100.0
@export var rotation: float = 0.0

func create() -> Array[Bullet]:
	var bullets: Array[Bullet] = []
	var angle_per_petal = TAU / petal_count
	for i in range(petal_count):
		petal(i * angle_per_petal + rotation)
	
	return bullets

func petal(rotation: float):
	var angle_per_petal = TAU / petal_count
	var angle_per_bullet = angle_per_petal * 0.5 / petal_size 
	for j in range(petal_size):
		for k in range(2):
			var bullet: Bullet = EntityEnums.get_bullet(
				EntityEnums.BulletType.CIRCLE_BORDERED,
				EntityEnums.BulletColor.RED
			)
			var bullet_angle = rotation
			if k == 1:
				bullet_angle += j * angle_per_bullet
			else:
				bullet_angle -= j * angle_per_bullet
			var direction := Vector2.from_angle(bullet_angle)
			var speed = speed_min + speed_max * (1 - float(j)/petal_size)

			ComponentVelocity.add_to_entity(bullet, direction * speed)
			GameVariables.game_view.add_bullet(bullet, position)
