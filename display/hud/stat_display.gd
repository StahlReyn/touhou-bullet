class_name StatDisplay
extends VBoxContainer

@onready var difficulty_label: Label = $Difficulty
@onready var hiscore_label: Label = $HiScoreContainer/Value
@onready var score_label: Label = $ScoreContainer/Value
@onready var power_label: Label = $PowerContainer/Value
@onready var value_label: Label = $ValueContainer/Value
@onready var graze_label: Label = $GrazeContainer/Value
@onready var lives_container: PieceContainer = $Lives
@onready var bombs_container: PieceContainer = $Bombs

func _physics_process(delta: float) -> void:
	#hiscore_label.text = GameVariables.get_score_display()
	score_label.text = GameVariables.get_score_display()
	power_label.text = GameVariables.get_power_display()
	value_label.text = GameVariables.get_point_value_display()
	graze_label.text = GameVariables.get_graze_display()
	
	lives_container.update_icons(GameVariables.lives, GameVariables.life_pieces)
	lives_container.value_label.text = GameVariables.get_life_piece_display()
	
	bombs_container.update_icons(GameVariables.bombs, GameVariables.bomb_pieces)
	bombs_container.value_label.text = GameVariables.get_bomb_piece_display()
