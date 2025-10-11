class_name TempEffect
extends Node2D

func remove() -> void:
	call_deferred("queue_free")
