class_name ComponentAcceleration
extends EntityComponent

@export var acceleration: Vector2 = Vector2.ZERO
@export var velocity: Vector2 = Vector2.ZERO

static func add_to_entity(
	entity_owner: Entity, 
	acceleration: Vector2, 
	velocity: Vector2 = Vector2.ZERO
) -> ComponentAcceleration:
	var comp := ComponentAcceleration.new()
	comp.entity = entity_owner
	comp.acceleration = acceleration
	comp.velocity = velocity
	entity_owner.add_child(comp)
	return comp
	
static func rand_dir(entity_owner: Entity, magnitude: float) -> ComponentAcceleration:
	var comp := new()
	comp.acceleration = MathUtils.randv2_angle() * magnitude
	comp.entity = entity_owner
	return comp

func _physics_process(delta: float) -> void:
	velocity += acceleration * delta
	entity.position += velocity * delta
