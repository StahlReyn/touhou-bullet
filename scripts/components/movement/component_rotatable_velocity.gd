class_name ComponentRotatableVelocity
extends EntityComponent

@export var velocity: Vector2 = Vector2.ZERO

static func add_to_entity(
	entity_owner: Entity, 
	velocity: Vector2 = Vector2.ZERO
) -> ComponentRotatableVelocity:
	var comp := new()
	comp.entity = entity_owner
	comp.velocity = velocity
	entity_owner.add_child(comp)
	return comp

func _physics_process(delta: float) -> void:
	entity.position += velocity.rotated(entity.rotation) * delta
