class_name BulletSceneFactory
extends BulletFactory

@export var bullet_scene: PackedScene

func create() -> Bullet:
	var bullet: Bullet = bullet_scene.instantiate()
	return bullet
