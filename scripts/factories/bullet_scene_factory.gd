class_name BulletSceneFactory
extends BulletFactory

@export var bullet_scene: PackedScene

func create() -> Bullet:
	return bullet_scene.instantiate()
