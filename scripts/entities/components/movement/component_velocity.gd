class_name ComponentVelocity
extends EntityComponent

@export var velocity: Vector2 = Vector2.ZERO

static func add_to_entity(
	entity_owner: Entity, 
	velocity: Vector2 = Vector2.ZERO
) -> ComponentVelocity:
	var comp := ComponentVelocity.new()
	comp.entity = entity_owner
	comp.velocity = velocity
	entity_owner.add_child(comp)
	return comp

static func rand_dir(entity_owner: Entity, magnitude: float) -> ComponentVelocity:
	var comp := new()
	comp.velocity = MathUtils.randv2_angle() * magnitude
	comp.entity = entity_owner
	return comp

func _physics_process(delta: float) -> void:
	entity.position += velocity * delta
