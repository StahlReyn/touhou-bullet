class_name ComponentConstantAcceleration
extends EntityComponent

@export var acceleration: Vector2 = Vector2.ZERO
@export var velocity: Vector2 = Vector2.ZERO

static func rand_dir(entity_owner: Entity, magnitude: float) -> ComponentConstantAcceleration:
	var comp := new()
	comp.acceleration = MathUtils.randv2_angle() * magnitude
	comp.entity = entity_owner
	return comp

func _physics_process(delta: float) -> void:
	velocity += acceleration * delta
	entity.position += velocity * delta
