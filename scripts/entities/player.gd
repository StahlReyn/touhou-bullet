class_name Player
extends Character

var collection_range_squared: float = 150 ** 2

func _ready() -> void:
	GameVariables.player = self
	pass

func _physics_process(delta: float) -> void:
	pass

func in_collection_range(entity: Entity):
	return entity.global_position.distance_squared_to(self.global_position) <= collection_range_squared

func kill():
	pass
