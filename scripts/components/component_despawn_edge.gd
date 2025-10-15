class_name ComponentDespawnEdge
extends EntityComponent

@export var padding: int = 100

static func add_to_entity(
	entity_owner: Entity, 
	padding: int = 100
) -> ComponentDespawnEdge:
	var comp := ComponentDespawnEdge.new()
	comp.entity = entity_owner
	comp.padding = padding
	entity_owner.add_child(comp)
	return comp
	
func _physics_process(delta: float) -> void:
	if not GameArea.in_area(entity.position, 100):
		entity.despawn()
