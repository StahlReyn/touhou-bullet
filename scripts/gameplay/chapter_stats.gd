class_name ChapterStats

var graze: int = 0
var shoot_ratio: float = 0.0
var retries: int = 0

var is_spellcard_section: bool = false
var spellcard_bonus: int = 0
var game_time: float = 0.0
var actual_time: float = 0.0

func get_chapter_bonus() -> int:
	return ceil(graze * shoot_ratio * 5000)

func get_value_bonus() -> int:
	# Floor division then multiply by 10
	return (get_chapter_bonus() / 50000) * 10

func get_lives_bonus() -> int:
	if get_chapter_bonus() >= 5000000:
		return 1
	return 0

func is_spellcard_bonus() -> bool:
	return retries <= 0
