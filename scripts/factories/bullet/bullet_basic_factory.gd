class_name BulletBasicFactory
extends BulletFactory

@export var bullet_type := SectionScript.BulletType.CIRCLE
@export var bullet_color := SectionScript.BulletColor.BLACK

func create() -> Bullet:
	var bullet := SectionScript.get_bullet(bullet_type)
	return bullet
