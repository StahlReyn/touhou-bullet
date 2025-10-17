class_name HitEffectFactory
extends EffectFactory

static var scene := preload("res://data/effects/hit_particle_effect.tscn")

@export var entity: Entity

static func add_effect_to_entity(entity: Entity) -> void:
	var effect_factory := new()
	effect_factory.entity = entity
	entity.hitted.connect(effect_factory.create)
	entity.add_child(effect_factory)
	
func create() -> TempEffect:
	var node: TempEffect = scene.instantiate()
	GameVariables.game_area.add_child(node)
	node.top_level = true
	node.global_position = entity.global_position
	return node
