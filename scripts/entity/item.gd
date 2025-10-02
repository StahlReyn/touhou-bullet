class_name Item
extends Entity

func _ready() -> void:
	add_behavior(BehaviorItemDrop.new())
