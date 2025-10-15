class_name ComponentDrop
extends EntityComponent

@export var score: int = 10000
@export var item_drops: Dictionary[SectionScript.ItemType, int]

var drop_position: Vector2

func _on_enemy_died() -> void:
	drop_position = entity.global_position
	call_deferred("drop") # Call deferred due to how this is called after signal

func drop() -> void:
	GameVariables.add_score(score)
	for type in item_drops:
		for i in range(item_drops[type]):
			SectionScript.add_item(type, entity.global_position)
