class_name Enemy
extends Character

signal setted_type(key: String)

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

func set_type(key: String):
	setted_type.emit(key)
