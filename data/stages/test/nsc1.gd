extends SectionScript

const JUNKO_SCENE: PackedScene = preload("res://data/enemies/bosses/junko.tscn")

var timer: Timer = Timer.new()
var timer_count: int = 0

var junko: Enemy
var target_pos: Vector2 = Vector2(400, 150)
var pattern_circle: PatternCircle

func _ready() -> void:
	timer.timeout.connect(_on_timer_end)
	add_child(timer)
	timer.start(3)
	
	pattern_circle = PatternCircle.new()
	pattern_circle.amount = 100
	pattern_circle.speed = 160
	pattern_circle.base_bullet = BULLET_CIRCLE_SMALL.instantiate()
	pattern_circle.base_bullet.sprite_frame_x(BCOLOR_BLUE)
	pattern_circle.base_bullet.material = MATERIAL_ADD
	
	junko = get_boss(0, JUNKO_SCENE, Vector2(410, -40))
	junko.set_mhp(4000)
	start_nonspellcard(40.0)

func _physics_process(delta: float) -> void:
	if is_instance_valid(junko):
		junko.position = MathUtils.lerp_smooth(junko.position, target_pos, 2.0, delta)
		if junko.hp < 1000:
			add_item_bulk(ITEM_POWER, 40, junko.global_position)
			end_chapter()
			end_script()

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
