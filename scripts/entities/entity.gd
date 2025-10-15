class_name Entity
extends Area2D

signal hit
signal despawned

func _ready() -> void:
	pass

## Despawns the entity. This is when it get removed from going out of bounds or clear.
func despawn() -> void:
	despawned.emit()
	remove()

## Actually removes the entity
func remove() -> void:
	call_deferred("queue_free")
