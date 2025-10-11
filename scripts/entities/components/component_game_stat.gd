class_name ComponentGameStat
extends EntityComponent

@export_category("Score")
@export var score: int = 0 ## Direct flat amount of score.
@export var score_point: int = 0 ## Score added in terms of times of point value. Point items use this
@export var point_value: int = 0 ## Increase in Point Value itself.
@export_category("Gameplay")
@export var power: int = 0
@export var lives: int = 0
@export var life_pieces: int = 0
@export var bombs: int = 0
@export var bomb_pieces: int = 0

func add() -> void:
	GameVariables.add_score(score + score_point * GameVariables.point_value)
	GameVariables.add_point_value(point_value)
	GameVariables.add_power(power)
	GameVariables.add_lives(lives)
	GameVariables.add_life_pieces(life_pieces)
	GameVariables.add_bombs(bombs)
	GameVariables.add_bomb_pieces(bomb_pieces)
