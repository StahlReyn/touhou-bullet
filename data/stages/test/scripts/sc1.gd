extends SectionScript

const JUNKO_SCENE: PackedScene = preload("res://data/enemies/bosses/junko.tscn")

var timer: Timer = Timer.new()
var timer_count: int = 0

var junko: Enemy
var junko_lerp: ComponentLerpPosition

var pattern_circle: PatternCircle

var puller_target_pos: Vector2 = Vector2(410, 250)
var puller: Bullet

var total_time: float = 0.0

func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_end)
	timer.start(2)
	
	pattern_circle = PatternCircle.new()
	pattern_circle.amount = 60
	pattern_circle.speed = 100
	pattern_circle.bullet_scene = BULLET_CIRCLE_SMALL
	
	junko = get_boss("junko", JUNKO_SCENE, Vector2(410, -40))
	junko.mhp = 4000
	junko.hp = 1000
	junko.damage_taken_mult = 0.2
	junko_lerp = ComponentLerpPosition.add_to_entity(junko, Vector2(410, 400), 2.0)
	
	GameVariables.cur_spellcard_name = "「Collapsing Star」"
	start_spellcard(40.0)

func _physics_process(delta: float) -> void:
	if is_instance_valid(junko):
		if junko.hp <= 0:
			clean_up()
	if is_instance_valid(puller):
		puller.global_position = junko.global_position + Vector2.from_angle(total_time * 0.5) * 240
	total_time += delta
	
func _on_spellcard_timeout() -> void:
	clean_up()
	
# ================ PLACEHOLDER ================
func clean_up() -> void:
	end_chapter()
	# junko_lerp.position = Vector2(420, -120)
	junko_lerp.queue_free() # Free for next one to add back
	timer.stop()
	end_script()
	
func _on_timer_end() -> void:
	if timer_count == 0:
		print("Attractor")
		puller = add_bullet_colored(BULLET_CIRCLE_BORDERED, BCOLOR_RED, junko.global_position)
		ComponentGravityPull.add_to_entity(puller, 20000)
		timer.start(1)
		timer_count += 1
		return
	
	pattern_circle.position = junko.global_position
	pattern_circle.rotation += PI / pattern_circle.amount
	for bullet: Bullet in pattern_circle.create():
		bullet.sprite_frame_x(BCOLOR_BLUE)
		bullet.material = MATERIAL_ADD
	
	timer_count += 1
	if timer_count % 8 == 0:
		timer.start(5)
	else:
		timer.start(0.2)
	
