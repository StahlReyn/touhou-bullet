class_name EntityBehavior
extends Node

signal finished

@export var entity: Entity

func _ready() -> void:
	# entity.removed.connect(_on_entity_removed)
	pass

func on_start(entity: Entity) -> void:
	pass

func entity_process(delta: float) -> void:
	pass

func _on_entity_removed() -> void:
	pass
