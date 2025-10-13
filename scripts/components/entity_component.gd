class_name EntityComponent
extends Node

signal finished

@export var entity: Entity
	
func set_entity(entity: Entity) -> void:
	self.entity = entity
	self.entity.despawned.connect(_on_entity_despawned)

func _on_entity_component_finished(component: EntityComponent) -> void:
	pass

func _on_entity_despawned() -> void:
	pass
