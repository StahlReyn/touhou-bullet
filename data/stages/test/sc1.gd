extends SectionScript

var timer: Timer = Timer.new()
var timer_count: int = 0

static var junko_scene: PackedScene = preload("res://data/enemies/bosses/junko.tscn")
var junko: Enemy
var target_pos: Vector2 = Vector2(420, 200)
var pattern_circle: PatternCircle

func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_end)
	timer.start(3)
	
	pattern_circle = PatternCircle.new()
	pattern_circle.amount = 100
	pattern_circle.speed = 160
	var bullet: Bullet = get_bullet(BulletType.CIRCLE_SMALL, BulletColor.BLUE)
	bullet.material = MATERIAL_ADD
	pattern_circle.base_bullet = bullet
	
	if get_bosses().size() > 0:
		junko = get_bosses()[0]
	else:
		junko = add_boss_scene(junko_scene, Vector2(420, -40))
	junko.mhp = 4000
	junko.hp = 1000
	junko.damage_taken_mult = 0.5
	
	GameVariables.cur_spellcard_name = "「Balls」"
	start_spellcard(40.0)

func _physics_process(delta: float) -> void:
	if is_instance_valid(junko):
		junko.position = MathUtils.lerp_smooth(junko.position, target_pos, 2.0, delta)
		if junko.is_dead:
			end_chapter()
			target_pos = Vector2(420, -120)
			timer.stop()
		if junko.position.y < -110:
			print("Despawned Boss")
			junko.remove()
			end_section()

# ================ PLACEHOLDER ================
func _on_timer_end() -> void:
	pattern_circle.position = junko.global_position
	pattern_circle.rotation += PI / pattern_circle.amount
	pattern_circle.create()
	timer_count += 1
	if timer_count % 8 == 0:
		timer.start(3)
	else:
		timer.start(0.2)
	
