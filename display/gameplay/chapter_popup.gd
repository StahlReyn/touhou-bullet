class_name ChapterPopup
extends PanelContainer
## Does Popups
## Chapter and Spellcard fastest, then timer and effects

@onready var control_bonus: Control = $Center/VBox/SpellBonus
@onready var control_timer: Control = $Center/VBox/FullList/Timer
@onready var control_chapter: Control = $Center/VBox/FullList/Chapter

@onready var label_sc_bonus: Label = $Center/VBox/SpellBonus/Score
@onready var label_clear_time: Label = $Center/VBox/FullList/Timer/Timer/ClearTime/Num
@onready var label_actual_time: Label = $Center/VBox/FullList/Timer/Timer/ActualTime/Num

@onready var label_graze: Label = $Center/VBox/FullList/Chapter/Graze/Num
@onready var label_shoot: Label = $Center/VBox/FullList/Chapter/Shoot/Num
@onready var label_retry: Label = $Center/VBox/FullList/Chapter/Retry/Num
@onready var label_bonus: Label = $Center/VBox/FullList/Chapter/Bonus/Num
@onready var label_value: Label = $Center/VBox/FullList/Chapter/ValueAdd/Num
@onready var label_lives: Label = $Center/VBox/FullList/Chapter/PieceGet/Label

func _ready() -> void:
	control_bonus.modulate.a = 0
	control_timer.modulate.a = 0
	control_chapter.modulate.a = 0

func _physics_process(delta: float) -> void:
	pass
	
func display_chapter() -> void:
	GameVariables.update_chapter_stats()
	var stats := GameVariables.cur_chapter_stats
	var bonus := stats.get_chapter_bonus()
	var value := stats.get_value_bonus()
	var lives := stats.get_lives_bonus()
	
	label_graze.text = str(stats.graze)
	label_shoot.text = MathUtils.percentage_display(stats.shoot_ratio)
	label_retry.text = str(stats.retries)
	label_bonus.text = str(bonus)
	label_value.text = "+" + str(value)
	
	GameVariables.add_score(bonus)
	GameVariables.add_point_value(value)
	if lives > 0:
		GameVariables.add_life_pieces(lives)
		label_lives.modulate.a = 1.0
	else:
		label_lives.modulate.a = 0.0
	
	
	var tween: Tween = create_tween()
	tween.tween_property(control_chapter, "modulate", Color.WHITE, 0.5)
	tween.tween_interval(3.0)
	tween.tween_property(control_chapter, "modulate", Color.TRANSPARENT, 0.5)

	if stats.is_spellcard_section:
		label_sc_bonus.text = MathUtils.thousands_sep(stats.spellcard_bonus)
		label_clear_time.text = "%.2f" % stats.game_time + "s"
		label_actual_time.text =  "%.2f" % stats.actual_time + "s"
		GameVariables.add_score(stats.spellcard_bonus)
		
		var bonus_tween: Tween = create_tween()
		bonus_tween.tween_property(control_bonus, "modulate", Color.WHITE, 0.5)
		bonus_tween.tween_property(control_timer, "modulate", Color.WHITE, 0.5)
		bonus_tween.tween_interval(3.0)
		bonus_tween.tween_property(control_bonus, "modulate", Color.TRANSPARENT, 0.5)
		bonus_tween.tween_property(control_timer, "modulate", Color.TRANSPARENT, 0.5)
	
	GameVariables.reset_chapter_stats()

func _on_stage_controller_chapter_ended() -> void:
	call_deferred("display_chapter")
