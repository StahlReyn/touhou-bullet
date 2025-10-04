extends Label

func _process(_delta: float) -> void:
	if visible:
		detailed()

func simple():
	text = (
		"FPS: " + str(Engine.get_frames_per_second()) + "\n" +
		"Time: " + ("%.2f" % GameVariables.game_time) + "\n" +
		"Bullet Count: " + str(GameUtils.get_bullet_count()) + "\n" +
		"Enemy Count: " + str(GameUtils.get_enemy_count()) + "\n" +
		"Item Count: " + str(GameUtils.get_item_count())
	)

func detailed():
	text = (
		"FPS: " + str(Engine.get_frames_per_second()  ) + "\n" +
		"Time: " + ("%.3f" % GameVariables.game_time) + "\n" +
		"Bullet Count: " + str(GameUtils.get_bullet_count()) + "\n" +
		"Enemy Count: " + str(GameUtils.get_enemy_count()) + "\n" +
		"Item Count: " + str(GameUtils.get_item_count()) + "\n" +
		"Power: " + str(GameVariables.power) + "\n" +
		"Score: " + str(GameVariables.score) + "\n" +
		"Lives: " + str(GameVariables.lives) + "\n" +
		"Life Pieces: " + str(GameVariables.life_pieces) + "\n" +
		"Graze Count: " + str(GameVariables.graze) + "\n" 
	)
