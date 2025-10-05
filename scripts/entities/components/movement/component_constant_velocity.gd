class_name ComponentConstantVelocity
extends EntityComponent

@export var velocity: Vector2 = Vector2.ZERO

static func rand_dir(entity_owner: Entity, magnitude: float) -> ComponentConstantVelocity:
	var comp := new()
	comp.velocity = MathUtils.randv2_angle() * magnitude
	comp.entity = entity_owner
	return comp

func _physics_process(delta: float) -> void:
	entity.position += velocity * delta
