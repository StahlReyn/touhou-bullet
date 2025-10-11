class_name ComponentRotation
extends EntityComponent

@export var velocity: int = 0

func _physics_process(delta: float) -> void:
	entity.rotation += velocity * delta
