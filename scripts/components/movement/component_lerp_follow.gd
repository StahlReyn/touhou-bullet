class_name ComponentLerpFollow
extends EntityComponent

@export var follow_node: Node2D
@export var speed: float = 1.0

static func add_to_entity(entity_owner: Entity, follow_node: Node2D, speed: float = 1.0) -> ComponentLerpFollow:
	var comp := new()
	comp.entity = entity_owner
	comp.follow_node = follow_node
	comp.speed = speed
	entity_owner.add_child(comp)
	return comp

func _physics_process(delta: float) -> void:
	if is_instance_valid(follow_node):
		entity.global_position = MathUtils.lerp_smooth(
			entity.global_position, follow_node.global_position, speed, delta
		)
