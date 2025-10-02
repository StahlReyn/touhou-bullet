class_name BehaviorMovementConstantVelocity
extends EntityBehavior

@export var velocity: Vector2 = Vector2.ZERO

func entity_process(delta: float) -> void:
	entity.position += velocity * delta
