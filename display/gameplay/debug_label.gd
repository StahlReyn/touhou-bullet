class_name DebugLabel
extends Label

func _process(_delta: float) -> void:
	if visible:
		detailed()

func simple():
	text = (
		"FPS: " + str(Engine.get_frames_per_second()) +
		"\nTime: " + ("%.2f" % GameVariables.game_time) +
		"\nBullets: " + str(GameUtils.get_bullet_count()) +
		"\nEnemies: " + str(GameUtils.get_enemy_count()) +
		"\nItems: " + str(GameUtils.get_item_count())
	)

func detailed():
	text = (
		"FPS: " + str(Engine.get_frames_per_second()) +
		"\nTime: " + ("%.3f" % GameVariables.game_time) +
		"\nBullets: " + str(GameUtils.get_bullet_count()) +
		"\nEnemies: " + str(GameUtils.get_enemy_count()) +
		"\nItems: " + str(GameUtils.get_item_count()) +
		"\nNodes: " + str(GameUtils.get_node_count()) +
		"\n\nScore: " + str(GameVariables.score) +
		"\nPoint Value: " + str(GameVariables.point_value) +
		"\nGraze: " + str(GameVariables.graze) +
		"\nPower: " + str(GameVariables.power) +
		"\nLives: " + str(GameVariables.lives) +
		"\nLife Pieces: " + str(GameVariables.life_pieces) +
		"\nBombs: " + str(GameVariables.bombs) +
		"\nBomb Pieces: " + str(GameVariables.bomb_pieces) +
		"\n\nEnemy Spawned: " + str(GameVariables.enemy_spawned) +
		"\nEnemy Spawned (Prev): " + str(GameVariables.prev_enemy_spawned) +
		"\nShoot Down: " + str(GameVariables.shoot_down) +
		"\nShoot Down (Prev): " + str(GameVariables.prev_shoot_down)
	)
