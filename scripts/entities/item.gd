class_name Item
extends Entity

func _ready() -> void:
	super()
	add_to_group("item")

func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		GameVariables.add_power()
		do_remove()
