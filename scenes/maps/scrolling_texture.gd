extends MeshInstance3D


@export var velocity: Vector3

func _physics_process(delta: float) -> void:
	get_active_material(0).uv1_offset += velocity * delta
