class_name Entity
extends Area2D

signal removed

enum CollisionMask {
	TARGET_PLAYER = 4,
	TARGET_ENEMY = 8,
}

func do_remove() -> void:
	removed.emit(self)
	call_deferred("queue_free")
