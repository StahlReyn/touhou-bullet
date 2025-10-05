class_name Enemy
extends Character

signal set_type

@export var death_score: int = 10000

func _ready() -> void:
	super()
	add_to_group("enemy")

func kill():
	GameVariables.add_score(10000)
	for i in range(10):
		var item: Item = EnemyFactory.create_point_item()
		item.global_position = global_position
	super()
