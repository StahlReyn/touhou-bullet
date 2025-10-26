class_name ComponentRotateFollow
extends EntityComponent

@export var follow_node: Node2D

static func add_to_entity(entity_owner: Entity, follow_node: Node2D) -> ComponentRotateFollow:
	var comp := new()
	comp.entity = entity_owner
	comp.follow_node = follow_node
	entity_owner.add_child(comp)
	return comp

func _physics_process(delta: float) -> void:
	if is_instance_valid(follow_node):
		entity.rotation = entity.global_position.angle_to_point(follow_node.global_position)
