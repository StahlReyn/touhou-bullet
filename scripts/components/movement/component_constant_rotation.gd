class_name ComponentRotation
extends EntityComponent

@export var velocity: float = 0

func _physics_process(delta: float) -> void:
	entity.rotation += velocity * delta
