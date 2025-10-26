extends SectionScript

const EIRIN_SCENE: PackedScene = preload("res://data/enemies/bosses/eirin.tscn")

var timer: Timer = Timer.new()
var timer_count: int = 0

var eirin: Enemy
var cleaning: bool = false

var pattern_circle: PatternCircle

func _ready() -> void:
	timer.timeout.connect(_on_timer_end)
	add_child(timer)
	timer.start(1)
	
	pattern_circle = PatternCircle.new()
	pattern_circle.amount = 48
	pattern_circle.speed = 300
	pattern_circle.bullet_scene = BULLET_OVAL
	pattern_circle.offset = Vector2(-150, 200)
	
	eirin = get_boss("eirin", EIRIN_SCENE, Vector2(100, -40))
	eirin.set_mhp(5000)
	eirin.add_hp_marker(1500)
	eirin.damage_taken_mult = 1.0
	
	start_nonspellcard(40.0)
	
	await eirin.create_tween().tween_property(
		eirin, "position", Vector2(GameArea.size.x * 0.5, 250), 1.0
	).set_trans(Tween.TRANS_SINE).finished

func _physics_process(delta: float) -> void:
	if is_instance_valid(eirin):
		if not cleaning and eirin.hp < 1500:
			add_item_bulk(ITEM_POWER, 40, eirin.global_position)
			clean_up()

func _on_spellcard_timeout() -> void:
	clean_up()

func clean_up() -> void:
	cleaning = true
	end_chapter()
	eirin.clear_hp_markers()
	timer.stop()
	end_script()
	
# ================ PLACEHOLDER ================
func _on_timer_end() -> void:
	pattern_circle.position = eirin.global_position
	pattern_circle.rotation += PI / pattern_circle.amount
	AudioManager.play_shoot1()
	for bullet: Bullet in pattern_circle.create():
		bullet.sprite_frame_x(BCOLOR_BLUE)
		disp_rot(bullet)
	
	timer_count += 1
	if timer_count % 8 == 0:
		timer.start(1)
		pattern_circle.speed = 300
		pattern_circle.offset = Vector2(-150, 200)
		if timer_count % 16 == 8:
			pattern_circle.speed *= -1
			pattern_circle.offset.x *= -1
	else:
		timer.start(0.2)
		pattern_circle.offset -= Vector2(20, 20)
