class_name ComponentDrop
extends EntityComponent

@export var score: int = 10000
@export var item_drops: Dictionary[EntityEnums.ItemType, int]

func _on_enemy_died() -> void:
	GameVariables.add_score(score)
	for type in item_drops:
		for i in range(item_drops[type]):
			var item: Item = EntityEnums.get_item(type)
			GameVariables.game_view.call_deferred("add_item", item, entity.position)
