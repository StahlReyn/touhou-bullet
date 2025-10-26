class_name ChapterStats

var graze: int
var shoot_ratio: float
var retries: int

func _init() -> void:
	graze = 0
	shoot_ratio = 0.0
	retries = 0

func get_chapter_bonus() -> int:
	return ceil(graze * shoot_ratio * 5000)

func get_value_bonus() -> int:
	# Floor division then multiply by 10
	return (get_chapter_bonus() / 50000) * 10

func get_lives_bonus() -> int:
	if get_chapter_bonus() >= 5000000:
		return 1
	return 0
