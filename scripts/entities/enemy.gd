class_name Enemy
extends Character

signal set_type

func _ready() -> void:
	super()
	add_to_group("enemy")

func kill():
	super()
