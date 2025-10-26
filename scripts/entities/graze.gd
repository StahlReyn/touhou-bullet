class_name Graze
extends Entity

func add_graze() -> void:
	GameVariables.add_score(10000)
	GameVariables.add_graze_count()
	AudioManager.play_graze()
