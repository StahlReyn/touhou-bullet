extends Node

enum Collision {
	PLAYER = 1,
	ENEMY = 2,
	BULLET_PLAYER = 4,
	BULLET_ENEMY = 8,
	ITEM = 16
}

const FAIRY = preload("res://data/enemies/fairy_leaf.tscn")
const POINT = preload("res://data/items/item_point.tscn")

func create_simple_enemy() -> Enemy:
	var enemy: Enemy = FAIRY.instantiate()
	enemy.collision_layer = Collision.ENEMY # Is an Enemy
	enemy.collision_mask = Collision.PLAYER # Finding hit player
	enemy.z_index = 0
	enemy.top_level = true
	GameVariables.game_view.add_child(enemy)
	enemy.add_child(ComponentDespawnEdge.create(enemy))
	return enemy

func create_point_item() -> Item:
	var item: Item = POINT.instantiate()
	item.collision_layer = Collision.ITEM
	item.collision_mask = Collision.PLAYER
	item.z_index = -1
	item.top_level = true
	GameVariables.game_view.add_child(item)
	item.add_child(ComponentDespawnEdge.create(item))
	return item
