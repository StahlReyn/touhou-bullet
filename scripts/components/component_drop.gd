class_name ComponentDrop
extends EntityComponent

enum ItemType {
	POWER,
	POINT
}

@export var score: int = 10000
@export var item_drops: Dictionary[ItemType, int]

var drop_position: Vector2

static func add_powerpoint(entity_owner: Character, power: int, point: int) -> ComponentDrop:
	var comp := new()
	comp.entity = entity_owner
	comp.item_drops[ItemType.POWER] = power
	comp.item_drops[ItemType.POINT] = point
	entity_owner.died.connect(comp.drop)
	entity_owner.add_child(comp)
	return comp

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
		call_deferred("drop_deferred", get_scene(type), item_drops[type], entity.global_position)

func drop_deferred(scene: PackedScene, count: int, pos: Vector2 = Vector2.ZERO) -> void:
	SectionScript.add_item_bulk(scene, count, pos)
