class_name Entity
extends Area2D

signal hitted
signal despawned
signal removed

func _ready() -> void:
	pass

## Remove bullets, indicate it's force removed like board clear.
func remove() -> void:
	removed.emit()
	despawn()

## Despawns the entity, does queue free. For example on out of bound.
func despawn() -> void:
	despawned.emit()
	call_deferred("queue_free")
