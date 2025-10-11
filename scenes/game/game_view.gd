class_name GameView
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
	pass

func _physics_process(delta: float) -> void:
	GameVariables.game_time += delta

func add_bullet_player(bullet: Bullet, pos: Vector2 = Vector2.ZERO) -> void:
	bullet.collision_layer = Collision.BULLET_PLAYER # Is an Enemy
	bullet.collision_mask = Collision.ENEMY # Finding hit player
	bullet.modulate.a = 0.3
	bullet.z_index = -11
	bullet.position = pos
	ComponentDespawnEdge.add_to_entity(bullet)
	add_child(bullet)
	
func add_bullet(bullet: Bullet, pos: Vector2 = Vector2.ZERO) -> void:
	bullet.collision_layer = Collision.BULLET_ENEMY # Is an Enemy
	bullet.collision_mask = Collision.PLAYER # Finding hit player
	bullet.z_index = 0
	bullet.position = pos
	ComponentDespawnEdge.add_to_entity(bullet)
	add_child(bullet) # May change to specific container

func add_enemy(enemy: Enemy, pos: Vector2 = Vector2.ZERO) -> void:
	enemy.collision_layer = Collision.ENEMY # Is an Enemy
	enemy.collision_mask = Collision.PLAYER # Finding hit player
	enemy.z_index = 0
	enemy.position = pos
	ComponentDespawnEdge.add_to_entity(enemy)
	add_child(enemy)

func add_item(item: Item, pos: Vector2 = Vector2.ZERO) -> void:
	item.collision_layer = Collision.ITEM
	item.collision_mask = Collision.PLAYER
	item.z_index = -10
	item.position = pos
	ComponentDespawnEdge.add_to_entity(item)
	add_child(item)

func _on_gamemain_start_stage() -> void:
	start_stage.emit()
