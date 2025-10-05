extends Node

enum Collision {
	PLAYER = 1,
	ENEMY = 2,
	BULLET_PLAYER = 4,
	BULLET_ENEMY = 8
}

const FAIRY = preload("res://data/enemies/fairy_leaf.tscn")

func create_simple_enemy() -> Enemy:
	var enemy: Enemy = FAIRY.instantiate()
	enemy.collision_layer = Collision.ENEMY # Is an Enemy
	enemy.collision_mask = Collision.PLAYER # Finding hit player
	enemy.z_index = 0
	enemy.top_level = true
	GameVariables.game_view.add_child(enemy)
	enemy.add_child(ComponentDespawnEdge.create(enemy))
	return enemy
