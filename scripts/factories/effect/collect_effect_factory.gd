class_name CollectEffectFactory
extends EffectFactory

static var scene := preload("res://data/effects/collect_effect.tscn")

@export var item: Item

static func add_effect_to_item(item: Item) -> void:
	var effect_factory := new()
	effect_factory.item = item
	item.collected.connect(effect_factory.create)
	item.add_child(effect_factory)
	
## Creates a Bullet
func create() -> TempEffect:
	var node: TempEffect = scene.instantiate()
	GameVariables.game_area.add_child(node)
	node.top_level = true
	node.global_position = item.global_position
	return node
