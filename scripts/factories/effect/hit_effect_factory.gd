class_name HitEffectFactory
extends Node

static var hit_scene := preload("res://data/effects/hit_particle_effect.tscn")

@export var entity: Entity

static func add_effect_to_entity(entity: Entity) -> void:
	var effect_factory := EffectFactory.new()
	effect_factory.scene = hit_scene
	effect_factory.entity = entity
	entity.hit.connect(effect_factory.create)
	entity.add_child(effect_factory)
	
## Creates a Bullet
func create() -> TempEffect:
	var node: TempEffect = hit_scene.instantiate()
	GameVariables.game_area.add_child(node)
	node.top_level = true
	node.global_position = entity.global_position
	return node
