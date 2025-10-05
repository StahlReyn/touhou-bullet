class_name Entity
extends Area2D

signal hit
signal removed

func do_remove() -> void:
	removed.emit(self)
	call_deferred("queue_free")
