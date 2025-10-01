class_name EntityBehavior
extends Node

signal finished

var entity: Entity

func set_entity(entity: Entity) -> void:
	self.entity = entity
	entity.removed.connect(_on_entity_removed)
	
func entity_process(delta: float) -> void:
	pass

func _on_entity_removed() -> void:
	pass
