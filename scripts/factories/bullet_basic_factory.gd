class_name BulletBasicFactory
extends BulletFactory

@export var bullet_type := EntityEnums.BulletType.CIRCLE
@export var bullet_color := EntityEnums.BulletColor.BLACK

func create() -> Bullet:
	var bullet := EntityEnums.get_bullet(bullet_type)
	return bullet
