extends SectionScript

const SCENE_BOSS: PackedScene = preload("res://data/enemies/fairy_sunflower_dream_boss.tscn")
const SCENE_SHIELD: PackedScene = preload("res://data/enemies/shield.tscn")

var timer: Timer = Timer.new()
var timer_count: int = 0

var pat_circ1: PatternCircle
var pat_circ2: PatternCircle

var rng := RandomNumberGenerator.new()

var boss: Enemy
var boss_tween: Tween

var cleaning: bool = false

func _ready() -> void:
	rng.seed = 12345
	
	pat_circ1 = PatternCircle.new()
	pat_circ1.amount = 16
	pat_circ1.speed = 450
	pat_circ1.bullet_scene = BULLET_CRYSTAL
	
	pat_circ2 = PatternCircle.new()
	pat_circ2.amount = 32
	pat_circ2.speed = 350
	pat_circ2.bullet_scene = BULLET_ARROW
	
	boss = get_boss("fairy", SCENE_BOSS)
	boss.set_mhp(3500)
	boss.position = Vector2(-40, -40)
	
	start_nonspellcard(30.0)
	
	boss_tween = boss.create_tween()
	boss_tween.tween_property(boss, "global_position", Vector2(480, 350), 2.0).set_trans(Tween.TRANS_QUAD)
	await boss_tween.finished
	
	boss_tween = boss.create_tween().set_loops()
	boss_tween.tween_callback(shoot_random.bind(boss))
	boss_tween.tween_interval(2.0)
	boss_tween.tween_callback(shoot_spiral.bind(boss))
	boss_tween.tween_interval(2.0)
	boss_tween.tween_callback(shoot_circle.bind(boss))
	boss_tween.tween_interval(2.0)

func _physics_process(delta: float) -> void:
	if is_instance_valid(boss):
		if not cleaning and boss.hp <= 0:
			add_item_bulk(ITEM_POWER, 40, boss.global_position)
			clean_up()

func _on_spellcard_timeout() -> void:
	clean_up()
	
func clean_up():
	cleaning = true
	end_chapter()
	if boss_tween:
		boss_tween.kill()
	boss.remove()
	end_script()

func shoot_spiral(node: Node2D) -> void:
	for i in range(20):
		if cleaning:
			return
		AudioManager.play_shoot1()
		pat_circ1.position = node.global_position
		pat_circ1.rotation += PI/48
		for bullet: Bullet in pat_circ1.create():
			bullet.sprite_frame_x(BCOLOR_BLUE)
			disp_rot(bullet)
		await get_tree().create_timer(0.1, false, true).timeout
	
func shoot_circle(node: Node2D) -> void:
	pat_circ2.position = node.global_position
	pat_circ2.rotation = angle_to_player(node)
	for i in range(10):
		if cleaning:
			return
		AudioManager.play_shoot1()
		pat_circ2.rotation += PI/pat_circ2.amount
		for bullet: Bullet in pat_circ2.create():
			bullet.sprite_frame_x(BCOLOR_YELLOW)
			disp_rot(bullet)
		await get_tree().create_timer(0.2, false, true).timeout

func shoot_random(node: Node2D) -> void:
	var pos = node.global_position
	for i in range(30):
		if cleaning:
			return
		AudioManager.play_shoot1()
		for j in range(10):
			var bullet: Bullet = add_bullet(BULLET_CIRCLE_BORDERED)
			bullet.global_position = pos
			bullet.rotation = rng.randf_range(0, TAU)
			vel(bullet, Vector2.from_angle(bullet.rotation) * 500)
			bullet.sprite_frame_x(BCOLOR_RED)
		await get_tree().create_timer(0.05, false, true).timeout
