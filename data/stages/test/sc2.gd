extends SectionScript

const JUNKO_SCENE: PackedScene = preload("res://data/enemies/bosses/junko.tscn")
const HECATIA_SCENE: PackedScene = preload("res://data/enemies/bosses/hecatia.tscn")

class BossData: 
	var enemy: Enemy
	var target_pos: Vector2
	var active: bool = true
	var move_speed: float = 2.0
	
	func _init(enemy: Enemy, target_pos: Vector2) -> void:
		self.enemy = enemy
		self.target_pos = target_pos
	
	func move(delta: float) -> void:
		if is_instance_valid(enemy):
			enemy.position = MathUtils.lerp_smooth(enemy.position, target_pos, move_speed, delta)

	func is_active() -> bool:
		return active and is_instance_valid(enemy)
	
var timer: Timer = Timer.new()
var timer_count: int = 0

var junko: BossData
var hecatia: BossData

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
	pattern_circle.base_bullet = BULLET_CIRCLE_SMALL.instantiate()
	pattern_circle.base_bullet.sprite_frame_x(BCOLOR_BLUE)
	pattern_circle.base_bullet.material = MATERIAL_ADD
	
	pattern_accel = PatternCircle.new()
	pattern_accel.amount = 40
	pattern_accel.speed = 0
	pattern_accel.acceleration = 200
	pattern_accel.base_bullet = BULLET_CIRCLE_BORDERED.instantiate()
	pattern_accel.base_bullet.sprite_frame_x(BCOLOR_RED)
	
	GameVariables.cur_spellcard_name = "「I Love Balls」"
	start_spellcard(60.0)
	
	call_deferred("spawn")

func spawn() -> void:
	junko = BossData.new(
		get_boss("junko", JUNKO_SCENE, Vector2(410, -40)),
		Vector2(210, 400)
	)
	junko.enemy.mhp = 4000
	junko.enemy.hp = 4000
	junko.enemy.damage_taken_mult = 1.0
	
	hecatia = BossData.new(
		get_boss("hecatia", HECATIA_SCENE, Vector2(410, -40)),
		Vector2(610, 400)
	)
	hecatia.enemy.mhp = 4000
	hecatia.enemy.hp = 4000
	hecatia.enemy.damage_taken_mult = 1.0
	
	puller = add_bullet_colored(BULLET_CIRCLE_BORDERED, BCOLOR_YELLOW, hecatia.enemy.global_position)
	ComponentGravityPull.add_to_entity(puller, 50000)
	
func _physics_process(delta: float) -> void:
	if not ending and not junko.is_active() and not hecatia.is_active():
		clean_up()
	
	junko.move(delta)
	hecatia.move(delta)
	
	if junko.is_active():
		if junko.enemy.hp <= 0:
			junko.active = false
			junko.enemy.modulate.a = 0.5
			junko.enemy.collision_layer = 0
	
	if hecatia.is_active():
		if hecatia.enemy.hp <= 0:
			hecatia.active = false
			hecatia.enemy.modulate.a = 0.5
			hecatia.enemy.collision_layer = 0
	
	if is_instance_valid(puller):
		puller.global_position = hecatia.enemy.global_position + Vector2.from_angle(total_time) * 200
	
	total_time += delta
	
func _on_spellcard_timeout() -> void:
	clean_up()
	
# ================ PLACEHOLDER ================
func clean_up() -> void:
	print("clean up")
	end_chapter()
	junko.target_pos = Vector2(410, -130)
	hecatia.target_pos = Vector2(410, -130)
	ending = true
	timer.start(2)
	
func _on_timer_end() -> void:
	if ending:
		print("Ending both")
		junko.enemy.despawn()
		hecatia.enemy.despawn()
		end_script()
		return
		
	if junko.active:
		pattern_circle.position = junko.enemy.global_position
		pattern_circle.rotation += PI / pattern_circle.amount
		pattern_circle.create()
	
	if hecatia.active and timer_count % 4 == 0:
		pattern_accel.position = hecatia.enemy.global_position
		pattern_accel.rotation += PI / pattern_accel.amount
		pattern_accel.create()
		
	timer_count += 1
	if timer_count % 8 == 0:
		timer.start(5)
	else:
		timer.start(0.2)
