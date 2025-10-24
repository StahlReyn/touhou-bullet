class_name ComponentDisplacementRotation
extends EntityComponent

var last_pos: Vector2

static func add_to_entity(
	entity_owner: Entity, 
) -> ComponentDisplacementRotation:
	var comp := ComponentDisplacementRotation.new()
	comp.entity = entity_owner
	entity_owner.add_child(comp)
	return comp

func _physics_process(delta: float) -> void:
	entity.rotation = last_pos.angle_to_point(entity.global_position)
	last_pos = entity.global_position
