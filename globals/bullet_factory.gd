extends Node

enum Collision {
	PLAYER = 1,
	ENEMY = 2,
	BULLET_PLAYER = 4,
	BULLET_ENEMY = 8
}

func create_player_bullet(scene: PackedScene) -> Bullet:
	var bullet : Bullet = scene.instantiate()
	bullet.collision_layer = Collision.BULLET_PLAYER # Is in bullet player
	bullet.collision_mask = Collision.ENEMY # Finding Enemy
	bullet.modulate.a = 0.3
	bullet.z_index = -10
	bullet.top_level = true
	GameVariables.game_view.add_child(bullet)
	return bullet
