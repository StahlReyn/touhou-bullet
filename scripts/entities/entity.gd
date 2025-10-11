class_name Entity
extends Area2D

signal hit
signal despawned

func _ready() -> void:
	pass

func despawn() -> void:
	despawned.emit(self)
	call_deferred("queue_free")
