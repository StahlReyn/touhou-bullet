extends SectionScript

const SCENE_GENGETSU: PackedScene = preload("res://data/enemies/bosses/gengetsu.tscn")
const SCENE_MUGETSU: PackedScene = preload("res://data/enemies/bosses/gengetsu.tscn")

var gengetsu: Enemy
var mugetsu: Enemy
var gengetsu_tween: Tween
var mugetsu_tween: Tween

var cleaning: bool = false
var pat_circ1: PatternCircle
var pat_circ2: PatternCircle

func _ready() -> void:
	GameVariables.reset_chapter_stats()
	pat_circ1 = PatternCircle.new()
	pat_circ1.amount = 16
	pat_circ1.speed = 400
	pat_circ1.bullet_scene = BULLET_ARROW
	
	pat_circ2 = PatternCircle.new()
	pat_circ2.amount = 90
	pat_circ2.speed = 250
	pat_circ2.bullet_scene = BULLET_CIRCLE_BORDERED
	
	gengetsu = get_boss("gengetsu", SCENE_GENGETSU, Vector2(100, -40))
	gengetsu.set_mhp(6000)
	gengetsu.add_hp_marker(2000)
	gengetsu.damage_taken_mult = 1.0
	
	mugetsu = get_boss("mugetsu", SCENE_MUGETSU, Vector2(100, -40))
	mugetsu.set_mhp(6000)
	mugetsu.add_hp_marker(2000)
	mugetsu.damage_taken_mult = 1.0
	
	start_nonspellcard(40.0)
	
	gengetsu_tween = gengetsu.create_tween()
	gengetsu_tween.tween_property(
		gengetsu, "position", Vector2(250, 220), 1.0
	).set_trans(Tween.TRANS_SINE)
	
	mugetsu_tween = mugetsu.create_tween()
	mugetsu_tween.tween_property(
		mugetsu, "position", Vector2(700, 300), 1.0
	).set_trans(Tween.TRANS_SINE)
	
	#await mugetsu_tween.finished
	
	mugetsu_tween = mugetsu.create_tween().set_loops()
	mugetsu_tween.tween_property(mugetsu, "global_position", Vector2(250, 300), 2.0).set_trans(Tween.TRANS_QUAD)
	mugetsu_tween.tween_callback(shoot_spiral.bind(mugetsu))
	mugetsu_tween.tween_interval(2.0)
	mugetsu_tween.tween_property(mugetsu, "global_position", Vector2(700, 300), 2.0).set_trans(Tween.TRANS_QUAD)
	mugetsu_tween.tween_callback(shoot_spiral.bind(mugetsu))
	mugetsu_tween.tween_interval(2.0)
	
	gengetsu_tween = gengetsu.create_tween().set_loops()
	gengetsu_tween.tween_property(gengetsu, "global_position", Vector2(700, 220), 2.0).set_trans(Tween.TRANS_QUAD)
	gengetsu_tween.tween_callback(shoot_circle.bind(gengetsu))
	gengetsu_tween.tween_interval(2.0)
	gengetsu_tween.tween_property(gengetsu, "global_position", Vector2(250, 220), 2.0).set_trans(Tween.TRANS_QUAD)
	gengetsu_tween.tween_callback(shoot_circle.bind(gengetsu))
	gengetsu_tween.tween_interval(2.0)

func _physics_process(delta: float) -> void:
	if is_instance_valid(gengetsu):
		if not cleaning and gengetsu.hp <= 2000:
			add_item_bulk(ITEM_POWER, 40, gengetsu.global_position)
			clean_up()
	if is_instance_valid(mugetsu):
		if not cleaning and mugetsu.hp <= 2000:
			add_item_bulk(ITEM_POWER, 40, mugetsu.global_position)
			clean_up()

func _on_spellcard_timeout() -> void:
	clean_up()

func clean_up() -> void:
	cleaning = true
	end_chapter()
	gengetsu_tween.kill()
	mugetsu_tween.kill()
	gengetsu.clear_hp_markers()
	mugetsu.clear_hp_markers()
	end_script()

func shoot_spiral(node: Node2D) -> void:
	pat_circ1.rotation = angle_to_player(node)
	for i in range(16):
		if cleaning:
			return
		AudioManager.play_shoot1()
		pat_circ1.position = node.global_position
		pat_circ1.rotation += TAU/64
		for bullet: Bullet in pat_circ1.create():
			bullet.sprite_frame_x(BCOLOR_BLUE)
		await get_tree().create_timer(0.05, false, true).timeout
	
func shoot_circle(node: Node2D) -> void:
	for i in range(2):
		if cleaning:
			return
		AudioManager.play_shoot1()
		pat_circ2.position = node.global_position
		pat_circ2.rotation = angle_to_player(node)
		for bullet: Bullet in pat_circ2.create():
			bullet.sprite_frame_x(BCOLOR_RED)
		await get_tree().create_timer(0.8, false, true).timeout
