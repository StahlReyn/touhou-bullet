class_name ComponentConstantVelocity
extends EntityComponent

@export var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	entity.position += velocity * delta
