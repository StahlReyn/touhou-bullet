extends SectionScript

const SCENE_MUGETSU: PackedScene = preload("res://data/enemies/bosses/mugetsu.tscn")
const SCENE_SHIELD: PackedScene = preload("res://data/enemies/shield.tscn")

var timer: Timer = Timer.new()
var timer_count: int = 0

var pat_circ1: PatternCircle
var pat_circ2: PatternCircle

var boss: Enemy
var boss_tween: Tween

var cleaning: bool = false

func _ready() -> void:
	pat_circ1 = PatternCircle.new()
	pat_circ1.amount = 24
	pat_circ1.speed = 450
	pat_circ1.bullet_scene = BULLET_ARROW
	
	pat_circ2 = PatternCircle.new()
	pat_circ2.amount = 64
	pat_circ2.speed = 350
	pat_circ2.bullet_scene = BULLET_CIRCLE_BORDERED
	
	boss = get_boss("mugetsu", SCENE_MUGETSU)
	boss.set_mhp(2500)
	boss.position = Vector2(-40, -40)
	
	start_nonspellcard(30.0)
	
	boss_tween = boss.create_tween().set_loops()
	boss_tween.tween_property(boss, "global_position", Vector2(300, 300), 2.0).set_trans(Tween.TRANS_QUAD)
	boss_tween.tween_callback(shoot_spiral.bind(boss))
	boss_tween.tween_property(boss, "global_position", Vector2(700, 300), 1.0).set_trans(Tween.TRANS_QUAD).set_delay(2.0)
	boss_tween.tween_callback(shoot_circle.bind(boss))

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
	boss_tween = boss.create_tween()
	await boss_tween.tween_property(
		boss, "global_position", Vector2(-200, -200), 2.0
	).set_trans(Tween.TRANS_QUAD).finished
	end_script()

func shoot_spiral(node: Node2D) -> void:
	for i in range(16):
		if cleaning:
			return
		AudioManager.play_shoot1()
		pat_circ1.position = node.global_position
		pat_circ1.rotation += TAU/64
		for bullet: Bullet in pat_circ1.create():
			bullet.sprite_frame_x(BCOLOR_BLUE)
		await get_tree().create_timer(0.1, false, true).timeout
	
func shoot_circle(node: Node2D) -> void:
	for i in range(5):
		if cleaning:
			return
		AudioManager.play_shoot1()
		pat_circ2.position = node.global_position
		pat_circ2.rotation = angle_to_player(node)
		for bullet: Bullet in pat_circ2.create():
			bullet.sprite_frame_x(BCOLOR_BLUE)
		await get_tree().create_timer(0.1, false, true).timeout
