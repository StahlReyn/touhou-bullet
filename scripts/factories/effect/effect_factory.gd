class_name EffectFactory
extends Node

@export var scene: PackedScene
@export var entity: Entity

## Creates a Bullet
func create() -> TempEffect:
	var node: TempEffect = scene.instantiate()
	GameVariables.game_area.add_child(node)
	node.top_level = true
	node.global_position = entity.global_position
	return node
