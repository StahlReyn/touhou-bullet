class_name Enemy
extends Character

signal set_type

const BASE_ENEMY = preload("res://data/enemies/fairy_leaf.tscn")

static func create_test() -> Enemy:
	var enemy: Enemy = BASE_ENEMY.instantiate()
	enemy.collision_layer = Collision.ENEMY # Is an Enemy
	enemy.collision_mask = Collision.PLAYER # Finding hit player
	enemy.z_index = 0
	enemy.top_level = true
	GameVariables.game_view.add_child(enemy)
	enemy.add_child(ComponentDespawnEdge.create(enemy))
	return enemy

func _ready() -> void:
	super()
	add_to_group("enemy")

func kill():
	super()
