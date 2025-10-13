class_name Portrait
extends Node2D

@export var id: String
@export var body_sprite: AnimatedSprite2D
@export var face_sprite: AnimatedSprite2D

var active: bool = false
var removing: bool = false
var target_pos: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if removing:
		position = MathUtils.lerp_smooth(position, target_pos, 20.0, delta)
		modulate.a = MathUtils.lerp_smooth(modulate.a, 0.0, 20.0, delta)
		if modulate.a < 0.001:
			call_deferred("queue_free")

func remove(target_pos: Vector2) -> void:
	removing = true
	self.target_pos = target_pos
