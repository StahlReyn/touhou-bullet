extends SectionScript

const EIRIN_SCENE: PackedScene = preload("res://data/enemies/bosses/eirin.tscn")
const SCENE_BOOK: PackedScene = preload("res://data/enemies/magic_book.tscn")

var timer: Timer = Timer.new()
var timer_count: int = 0

var eirin: Enemy

var pat_circ1: PatternCircle
var pat_circ2: PatternCircle

var rng = RandomNumberGenerator.new()
var cleaning: bool = false

var books: Array[Enemy]
var bouncers: Array[Bullet]

func _ready() -> void:
	rng.seed = 1234
	
	add_child(timer)
	timer.timeout.connect(_on_timer_end)
	timer.start(2)
	
	pat_circ1 = PatternCircle.new()
	pat_circ1.amount = 32
	pat_circ1.speed = 300
	pat_circ1.bullet_scene = BULLET_ARROW
	
	eirin = get_boss("eirin", EIRIN_SCENE, Vector2(GameArea.size.x * 0.5, -40))
	eirin.hp = 1500
	eirin.damage_taken_mult = 0.2
	
	GameVariables.cur_spellcard_name = "Esoterica \"Kaguya's Disorganized Room\""
	start_spellcard(40.0)
	
	await eirin.create_tween().tween_property(
		eirin, "position", Vector2(GameArea.size.x * 0.5, 175), 1.0
	).set_trans(Tween.TRANS_SINE).finished
	
	for i in range(50):
		var book: Enemy = add_enemy(SCENE_BOOK)
		book.set_mhp(500)
		books.push_back(book)
		book.create_tween().tween_property(
			book, "position", Vector2(
				GameArea.size.x * 0.5 + rng.randfn(0, 200), 450 + rng.randfn(0, 50)
			), 1.0
		).set_trans(Tween.TRANS_SINE)
		book.create_tween().tween_property(
			book, "rotation", rng.randf_range(TAU, TAU * 10), 1.0
		).set_trans(Tween.TRANS_SINE)
		await get_tree().create_timer(0.05, false, true).timeout

func _physics_process(delta: float) -> void:
	if is_instance_valid(eirin):
		if not cleaning and eirin.hp <= 0:
			clean_up()
	
	for bouncer: Bullet in bouncers:
		if not is_instance_valid(bouncer):
			continue
		for book: Enemy in books:
			if not is_instance_valid(book):
				continue
			if book.global_position.distance_squared_to(bouncer.global_position) < 2800:
				var bul: Bullet = add_bullet(BULLET_OVAL, book.global_position)
				bul.sprite_frame_x(BCOLOR_GREEN)
				var angle: float = rng.randf_range(0, TAU)
				vel(bul, Vector2.from_angle(angle) * rng.randf_range(150, 250))
				bul.rotation = angle
	
func _on_spellcard_timeout() -> void:
	clean_up()
	
# ================ PLACEHOLDER ================
func clean_up() -> void:
	cleaning = true
	end_chapter()
	timer.stop()
	
	await eirin.create_tween().tween_property(
		eirin, "global_position", Vector2(1000, -300), 1.0
	).set_trans(Tween.TRANS_SINE).finished
	
	if is_instance_valid(eirin):
		eirin.remove()
	end_script()
	
func _on_timer_end() -> void:
	AudioManager.play_shoot1()
	pat_circ1.position = eirin.global_position
	pat_circ1.rotation = angle_to_player(eirin)
	pat_circ1.speed = 300
	for i in range(3):
		for bullet: Bullet in pat_circ1.create():
			bullet.sprite_frame_x(BCOLOR_BLUE)
			disp_rot(bullet)
		pat_circ1.speed -= 30
	
	if timer_count % 2 == 1:
		var bouncer: Bullet = add_bullet(BULLET_CIRCLE_BORDERED, eirin.global_position)
		bouncer.sprite_frame_x(BCOLOR_RED)
		bouncer.scale *= 4
		vel(bouncer, direction_to_player(bouncer) * 300)
		bouncers.push_back(bouncer)
	
	timer_count += 1
	if timer_count > 8:
		timer.start(1.0)
	else:
		timer.start(2.0)
	
