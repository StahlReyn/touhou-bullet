class_name Portrait
extends Node2D

@export var id: String
@export var body_sprite: AnimatedSprite2D
@export var face_sprite: AnimatedSprite2D
@export var speech_node: Node2D

var active: bool = false
var removing: bool = false
var target_pos: Vector2 = Vector2.ZERO
var lerp_speed = 20.0

func _physics_process(delta: float) -> void:
	if removing:
		position = MathUtils.lerp_smooth(position, target_pos, lerp_speed, delta)
		modulate.a = MathUtils.lerp_smooth(modulate.a, 0.0, lerp_speed, delta)
		if modulate.a < 0.001:
			call_deferred("queue_free")

func remove(target_pos: Vector2) -> void:
	removing = true
	self.target_pos = target_pos
