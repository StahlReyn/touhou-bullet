class_name ComponentGravityPull
extends EntityComponent

@export var gravity_strength: float = 1000
@export var despawn_radius: float = 16.0

static func add_to_entity(entity_owner: Entity, gravity_strength: float) -> ComponentGravityPull:
	var comp := new()
	comp.entity = entity_owner
	comp.gravity_strength = gravity_strength
	entity_owner.add_child(comp)
	return comp

func _physics_process(delta: float) -> void:
	for target: Entity in GameUtils.get_bullet_list():
		if target == entity:
			continue
		if target.global_position.distance_squared_to(entity.global_position) < despawn_radius ** 2:
			target.despawn()
		if not target.has_meta(&"g_vel"):
			target.set_meta(&"g_vel", Vector2.ZERO)
		var new_vel: Vector2 = (
			gravity_strength 
			/ target.position.distance_squared_to(entity.position)
			* target.position.direction_to(entity.position)
			+ target.get_meta(&"g_vel")
		)
		target.set_meta(&"g_vel", new_vel)
		target.position += new_vel * delta
