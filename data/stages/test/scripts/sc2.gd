extends SectionScript

const JUNKO_SCENE: PackedScene = preload("res://data/enemies/bosses/junko.tscn")
const HECATIA_SCENE: PackedScene = preload("res://data/enemies/bosses/hecatia.tscn")
	
var timer: Timer = Timer.new()
var timer_count: int = 0

var junko: Enemy
var junko_lerp: ComponentLerpPosition
var junko_active: bool = true

var hecatia: Enemy
var hecatia_lerp: ComponentLerpPosition
var hecatia_active: bool = true

var pattern_circle: PatternCircle
var pattern_accel: PatternCircle

var puller_target_pos: Vector2 = Vector2(410, 250)
var puller: Bullet

var total_time: float = 0.0
var ending: bool = false

func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_end)
	timer.start(2)
	
	pattern_circle = PatternCircle.new()
	pattern_circle.amount = 60
	pattern_circle.speed = 100
	pattern_circle.bullet_scene = BULLET_CIRCLE_SMALL
	
	pattern_accel = PatternCircle.new()
	pattern_accel.amount = 40
	pattern_accel.speed = 0
	pattern_accel.acceleration = 200
	pattern_accel.bullet_scene = BULLET_CIRCLE_BORDERED
	
	GameVariables.cur_spellcard_name = "「I Love Balls」"
	start_spellcard(60.0)
	
	call_deferred("spawn")

func spawn() -> void:
	junko = get_boss("junko", JUNKO_SCENE, Vector2(410, -40))
	junko.mhp = 4000
	junko.hp = 4000
	junko.damage_taken_mult = 1.0
	junko_lerp = ComponentLerpPosition.add_to_entity(junko, Vector2(210, 400), 2.0)
	
	hecatia = get_boss("hecatia", HECATIA_SCENE, Vector2(410, -40))
	hecatia.mhp = 4000
	hecatia.hp = 4000
	hecatia.damage_taken_mult = 1.0
	hecatia_lerp = ComponentLerpPosition.add_to_entity(hecatia, Vector2(610, 400), 2.0)
	
	puller = add_bullet_colored(BULLET_CIRCLE_BORDERED, BCOLOR_YELLOW, hecatia.global_position)
	ComponentGravityPull.add_to_entity(puller, 50000)
	
func _physics_process(delta: float) -> void:
	if not ending and not junko_active and not hecatia_active:
		clean_up()
	
	if junko_active:
		if junko.hp <= 0:
			junko.modulate.a = 0.5
			junko.collision_layer = 0
			junko_active = false
	
	if hecatia_active:
		if hecatia.hp <= 0:
			hecatia.modulate.a = 0.5
			hecatia.collision_layer = 0
			hecatia_active = false
	
	if is_instance_valid(puller):
		puller.global_position = hecatia.global_position + Vector2.from_angle(total_time) * 200
	
	total_time += delta
	
func _on_spellcard_timeout() -> void:
	clean_up()
	
# ================ PLACEHOLDER ================
func clean_up() -> void:
	print("clean up")
	end_chapter()
	junko_lerp.position = Vector2(410, -300)
	hecatia_lerp.position = Vector2(410, -300)
	ending = true
	timer.start(2)
	
func _on_timer_end() -> void:
	if ending:
		print("Ending both")
		junko.despawn()
		hecatia.despawn()
		end_script()
		return
		
	if junko_active:
		pattern_circle.position = junko.global_position
		pattern_circle.rotation += PI / pattern_circle.amount
		for bullet: Bullet in pattern_circle.create():
			bullet.sprite_frame_x(BCOLOR_BLUE)
			bullet.material = MATERIAL_ADD
	
	if hecatia_active and timer_count % 2 == 0:
		pattern_accel.position = hecatia.global_position
		pattern_accel.rotation += PI / pattern_accel.amount
		for bullet: Bullet in pattern_accel.create():
			bullet.sprite_frame_x(BCOLOR_RED)
		
	timer_count += 1
	if timer_count % 8 == 0:
		timer.start(5)
	else:
		timer.start(0.2)
