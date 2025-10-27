extends Node

enum Difficulty {
	EASY,
	NORMAL,
	HARD,
	LUNATIC
}

static var power_max: int = 400
static var point_value_max: int = 300000
static var lives_max: int = 8
static var bombs_max: int = 8
static var life_pieces_max: int = 3
static var bomb_pieces_max: int = 5

var game_area: GameArea
var player: Player
var difficulty: Difficulty = Difficulty.NORMAL
var boss_list: Dictionary[String, Enemy] = {}

var game_time: float = 0.0
var score: int = 0
var graze: int = 0
var point_value: int = 10000
## Powers are in integer for simplicity, display divides by 100
var power: int = 0

var lives: int = 3
var bombs: int = 3
var life_pieces: int = 0
var bomb_pieces: int = 0

var deaths: int = 0
var enemy_spawned: int = 0
var shoot_down: int = 0

# For use in counting chapter
var prev_deaths: int = 0
var prev_graze: int = 0
var prev_enemy_spawned: int = 0
var prev_shoot_down: int = 0
var prev_game_time: float = 0
var prev_time_msec: int = 0

# Might change when proper spellcard database comes
var is_spellcard_section: bool = false
var cur_spellcard_bonus: int = 1000000
var cur_spellcard_name: String = ""
var cur_chapter_stats: ChapterStats

func reset_variables() -> void:
	print("==== RESET GAME VARIABLES ====")
	game_time = 0.0
	score = 0
	graze = 0
	lives = 3
	bombs = 3
	power = 0
	point_value = 10000
	
	deaths = 0
	enemy_spawned = 0
	shoot_down = 0
	
	cur_spellcard_bonus = 1000000
	cur_spellcard_name = ""
	cur_chapter_stats = ChapterStats.new()
	
	boss_list.clear()
	update_chapter_stats()

# ================================================================
#                       GETTER / SETTERS
# ================================================================
func add_score(value: int) -> void:
	score += value

func add_point_value(value: int) -> void:
	point_value += value
	point_value = clamp(point_value, 0, point_value_max)

func add_graze_count(value: int = 1) -> void:
	graze += value

func add_lives(value: int = 1) -> void:
	if value > 0:
		AudioManager.play_item_get()
	lives += value
	lives = clamp(lives, 0, lives_max)

func lose_lives(value: int = 1) -> void: ## Remove counterpart for clarity and debugging purposes
	lives -= value
	lives = clamp(lives, 0, lives_max)

func add_bombs(value: int = 1) -> void:
	if value > 0:
		AudioManager.play_item_get()
	bombs += value
	bombs = clamp(bombs, 0, bombs_max)

func lose_bombs(value: int = 1) -> void:
	bombs -= value
	bombs = clamp(bombs, 0, bombs_max)

func add_life_pieces(value: int = 1) -> void:
	life_pieces += value
	if life_pieces >= life_pieces_max:
		add_lives(life_pieces / life_pieces_max) # Integer does floor division
		life_pieces = life_pieces % life_pieces_max # Remainder pieces

func add_bomb_pieces(value: int = 1) -> void:
	bomb_pieces += value
	if bomb_pieces >= bomb_pieces_max:
		add_bombs(bomb_pieces / bomb_pieces_max) # Integer does floor division
		bomb_pieces = bomb_pieces % bomb_pieces_max # Remainder pieces

func add_power(value: int = 1) -> void:
	power += value
	power = clamp(power, 0, power_max)

func lose_power(value: int = 1) -> void:
	power -= value
	power = clamp(power, 0, power_max)

# ================================================================
#                          CHAPTER
# ================================================================
func update_chapter_stats() -> void:
	cur_chapter_stats.graze = graze - prev_graze
	cur_chapter_stats.retries = deaths - prev_deaths
	if (enemy_spawned - prev_enemy_spawned) == 0:
		cur_chapter_stats.shoot_ratio = 1.0
	else:
		cur_chapter_stats.shoot_ratio = float(shoot_down - prev_shoot_down) / float(enemy_spawned - prev_enemy_spawned)
	
	var cur_msec := Time.get_ticks_msec()
	cur_chapter_stats.is_spellcard_section = is_spellcard_section
	cur_chapter_stats.spellcard_bonus = cur_spellcard_bonus
	cur_chapter_stats.game_time = game_time - prev_game_time
	cur_chapter_stats.actual_time = float(cur_msec - prev_time_msec) / 1000

func reset_chapter_stats() -> void:
	var cur_msec := Time.get_ticks_msec()
	is_spellcard_section = false
	prev_deaths = deaths
	prev_graze = graze
	prev_enemy_spawned = enemy_spawned
	prev_shoot_down = shoot_down
	prev_time_msec = cur_msec
	prev_game_time = game_time
	
# ================================================================
#                            DISPLAY
# ================================================================
func get_score_display():
	return MathUtils.thousands_sep(score)

func get_power_display():
	return MathUtils.two_decimal_int(power) + "/" + MathUtils.two_decimal_int(power_max)

func get_point_value_display():
	return MathUtils.thousands_sep(point_value)

func get_graze_display():
	return MathUtils.thousands_sep(graze)

func get_life_piece_display():
	return "(" + str(life_pieces) + "/" + str(life_pieces_max) + ")"

func get_bomb_piece_display():
	return "(" + str(bomb_pieces) + "/" + str(bomb_pieces_max) + ")"
