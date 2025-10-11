class_name ComponentDespawnEdge
extends EntityComponent

@export var padding: int = 100

static func create(entity_owner: Entity, padding: int = 100) -> ComponentDespawnEdge:
	var comp := new()
	comp.entity = entity_owner
	comp.padding = padding
	return comp
	
func _physics_process(delta: float) -> void:
	if (entity.position.x < -padding or entity.position.x > GameUtils.game_area.x + padding or
		entity.position.y < -padding or entity.position.y > GameUtils.game_area.y + padding):
		entity.despawn()
