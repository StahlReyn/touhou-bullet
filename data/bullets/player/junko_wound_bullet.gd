class_name JunkoWoundBullet
extends Bullet

@onready var comp_accel: ComponentAcceleration = $ComponentAcceleration
@onready var timer: Timer = $Timer

var target_entity: Node2D

func _on_timer_timeout() -> void:
	comp_accel.acceleration = global_position.direction_to(target_entity.global_position) * 400
