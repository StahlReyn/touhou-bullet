class_name Entity
extends Area2D

enum Collision {
	PLAYER = 1,
	ENEMY = 2,
	BULLET_PLAYER = 4,
	BULLET_ENEMY = 8,
	ITEM = 16
}

signal hit
signal despawned

func _ready() -> void:
	pass

func despawn() -> void:
	despawned.emit(self)
	call_deferred("queue_free")
