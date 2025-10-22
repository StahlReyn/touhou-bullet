class_name Enemy
extends Character

signal set_type

@export var health_bar: HealthBar

func _ready() -> void:
	super()
	add_to_group("enemy")

func die() -> void:
	super()
	GameVariables.shoot_down += 1

func add_hp_marker(target_hp: float) -> void:
	if health_bar != null:
		health_bar.add_marker(target_hp)

func clear_hp_markers() -> void:
	if health_bar != null:
		health_bar.clear_markers()
