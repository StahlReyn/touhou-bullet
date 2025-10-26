class_name ComponentLerpPosition
extends EntityComponent

@export var position: Vector2 = Vector2.ZERO
@export var speed: float = 1.0

static func add_to_entity(entity_owner: Entity, position: Vector2 = Vector2.ZERO, speed: float = 1.0) -> ComponentLerpPosition:
	var comp := new()
	comp.entity = entity_owner
	comp.position = position
	comp.speed = speed
	entity_owner.add_child(comp)
	return comp

func _physics_process(delta: float) -> void:
	entity.position = MathUtils.lerp_smooth(entity.position, position, speed, delta)
