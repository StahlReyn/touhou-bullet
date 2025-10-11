class_name GameArea
extends Node2D

enum Collision {
	PLAYER = 1,
	ENEMY = 2,
	BULLET_PLAYER = 4,
	BULLET_ENEMY = 8,
	ITEM = 16
}

signal start_stage

func _ready() -> void:
	GameVariables.game_area = self
	pass

func _physics_process(delta: float) -> void:
	GameVariables.game_time += delta

func add_bullet_player(bullet: Bullet, pos: Vector2 = Vector2.ZERO) -> void:
	add_child(bullet)
	bullet.collision_layer = Collision.BULLET_PLAYER # Is an Enemy
	bullet.collision_mask = Collision.ENEMY # Finding hit player
	bullet.modulate.a = 0.3
	bullet.z_index = -11
	bullet.global_position = pos
	ComponentDespawnEdge.add_to_entity(bullet)
	
func add_bullet(bullet: Bullet, pos: Vector2 = Vector2.ZERO) -> void:
	add_child(bullet) # May change to specific container
	bullet.collision_layer = Collision.BULLET_ENEMY # Is an Enemy
	bullet.collision_mask = Collision.PLAYER # Finding hit player
	bullet.z_index = 0
	bullet.global_position = pos
	ComponentDespawnEdge.add_to_entity(bullet)

func add_enemy(enemy: Enemy, pos: Vector2 = Vector2.ZERO) -> void:
	add_child(enemy)
	enemy.collision_layer = Collision.ENEMY # Is an Enemy
	enemy.collision_mask = Collision.PLAYER # Finding hit player
	enemy.z_index = 0
	enemy.global_position = pos
	ComponentDespawnEdge.add_to_entity(enemy)

func add_item(item: Item, pos: Vector2 = Vector2.ZERO) -> void:
	add_child(item)
	item.collision_layer = Collision.ITEM
	item.collision_mask = Collision.PLAYER
	item.z_index = -10
	item.global_position = pos
	item.modulate.a = 0.75
	ComponentDespawnEdge.add_to_entity(item)

func _on_game_main_start_stage() -> void:
	start_stage.emit()
