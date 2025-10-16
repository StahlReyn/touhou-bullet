class_name ComponentDrop
extends EntityComponent

enum ItemType {
	POWER,
	POINT
}

@export var score: int = 10000
@export var item_drops: Dictionary[ItemType, int]

var drop_position: Vector2

func _on_enemy_died() -> void:
	drop_position = entity.global_position
	call_deferred("drop") # Call deferred due to how this is called after signal

func get_scene(type: ItemType) -> PackedScene:
	match type:
		ItemType.POWER:
			return SectionScript.ITEM_POWER
		ItemType.POINT:
			return SectionScript.ITEM_POINT
	return SectionScript.ITEM_POINT
	
func drop() -> void:
	GameVariables.add_score(score)
	for type in item_drops:
		SectionScript.add_item_bulk(get_scene(type), item_drops[type], entity.global_position)
