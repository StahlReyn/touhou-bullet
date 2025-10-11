class_name ComponentGravity
extends EntityComponent

@export var gravity_subject: Entity
@export var gravity_strength: float = 1000
@export var velocity: Vector2 = Vector2.ZERO

static func create(entity_owner: Entity, gravity_subject: Entity, gravity_strength: float) -> ComponentGravity:
	var comp := new()
	comp.entity = entity_owner
	comp.gravity_subject = gravity_subject
	comp.gravity_strength = gravity_strength
	return comp

func _physics_process(delta: float) -> void:
	velocity += (
		gravity_strength 
		/ entity.position.distance_squared_to(gravity_subject.position)
		* entity.position.direction_to(gravity_subject.position)
	)
	entity.position += velocity * delta
