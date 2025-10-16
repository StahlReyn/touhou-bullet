class_name Enemy
extends Character

signal set_type

func _ready() -> void:
	super()
	add_to_group("enemy")

func die():
	super()
	GameVariables.shoot_down += 1
