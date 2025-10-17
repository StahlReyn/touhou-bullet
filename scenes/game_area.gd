class_name GameArea
extends Node2D

static var size: Vector2 = Vector2(768,896) # Half is Vector2(384,448)

enum Collision {
	PLAYER = 1,
	ENEMY = 2,
	BULLET_PLAYER = 4,
	BULLET_ENEMY = 8,
	ITEM = 16
}

static func in_area(pos: Vector2, padding: float = 0) -> bool:
	return (
		pos.x > -padding and pos.x < GameArea.size.x + padding and
		pos.y > -padding and pos.y < GameArea.size.y + padding
	)
			
func add_bullet_player(bullet: Bullet, pos: Vector2 = Vector2.ZERO) -> void:
	add_child(bullet)
	bullet.collision_layer = Collision.BULLET_PLAYER # Is an Enemy
	bullet.collision_mask = Collision.ENEMY # Finding hit player
	bullet.modulate.a = 0.3
	bullet.z_index = -11
	bullet.global_position = pos
	ComponentDespawnEdge.add_to_entity(bullet)
	HitEffectFactory.add_effect_to_entity(bullet)
	
func add_bullet(bullet: Bullet, pos: Vector2 = Vector2.ZERO) -> void:
	add_child(bullet) # May change to specific container
	bullet.collision_layer = Collision.BULLET_ENEMY # Is an Enemy
	bullet.collision_mask = Collision.PLAYER # Finding hit player
	bullet.z_index = 0
	bullet.global_position = pos
	ComponentDespawnEdge.add_to_entity(bullet)
	RemoveEffectFactory.add_effect_to_entity(bullet)

func add_enemy(enemy: Enemy, pos: Vector2 = Vector2.ZERO) -> void:
	add_child(enemy)
	enemy.collision_layer = Collision.ENEMY # Izzs an Enemy
	enemy.collision_mask = Collision.PLAYER # Finding hit player
	enemy.z_index = 0
	enemy.global_position = pos
	ComponentDespawnEdge.add_to_entity(enemy)
	RemoveEffectFactory.add_effect_to_entity(enemy)
	GameVariables.enemy_spawned += 1

func add_enemy_boss(enemy: Enemy, id: String, pos: Vector2 = Vector2.ZERO) -> void:
	add_child(enemy)
	enemy.add_to_group("boss")
	enemy.collision_layer = Collision.ENEMY # Is an Enemy
	enemy.collision_mask = Collision.PLAYER # Finding hit player
	enemy.z_index = 0
	enemy.global_position = pos
	GameVariables.enemy_spawned += 1
	GameVariables.boss_list[id] = enemy

func add_item(item: Item, pos: Vector2 = Vector2.ZERO) -> void:
	add_child(item)
	item.collision_layer = Collision.ITEM
	item.collision_mask = Collision.PLAYER
	item.z_index = -10
	item.modulate.a = 0.75
	item.global_position = pos
	ComponentDespawnEdge.add_to_entity(item)
	CollectEffectFactory.add_effect_to_item(item)

func remove_enemy_bullets() -> void:
	for bullet: Bullet in GameUtils.get_bullet_list():
		if bullet.collision_mask & Collision.PLAYER: # Collision looking for player
			bullet.remove()

func remove_bullets() -> void:
	for bullet: Bullet in GameUtils.get_bullet_list():
		bullet.remove()

func remove_enemies() -> void:
	for enemy: Enemy in GameUtils.get_enemy_list():
		enemy.remove()

func remove_non_boss_enemies() -> void:
	for enemy: Enemy in GameUtils.get_enemy_list():
		if not enemy.is_in_group("boss"):
			enemy.remove()
