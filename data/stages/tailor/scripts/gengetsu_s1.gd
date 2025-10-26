extends SectionScript

const SCENE_GENGETSU: PackedScene = preload("res://data/enemies/bosses/gengetsu.tscn")
const SCENE_MUGETSU: PackedScene = preload("res://data/enemies/bosses/gengetsu.tscn")

var gengetsu: Enemy
var mugetsu: Enemy
var gengetsu_tween: Tween
var mugetsu_tween: Tween

var cleaning: bool = false
var pat_aim: PatternFlower

func _ready() -> void:
	GameVariables.cur_spellcard_bonus = 4000000
	pat_aim = PatternFlower.new()
	pat_aim.petal_count = 1
	pat_aim.petal_size = 4
	pat_aim.speed_max = 400
	pat_aim.speed_min = 300
	pat_aim.arc_angle = PI/24
	pat_aim.bullet_scene = BULLET_ARROW
	
	gengetsu = get_boss("gengetsu", SCENE_GENGETSU, Vector2(100, -40))
	gengetsu.hp = 2000
	gengetsu.damage_taken_mult = 0.2
	
	mugetsu = get_boss("mugetsu", SCENE_MUGETSU, Vector2(100, -40))
	mugetsu.hp = 2000
	mugetsu.damage_taken_mult = 0.2
	
	GameVariables.cur_spellcard_name = "Dreamweaver \"Hidden Backstitch\""
	start_spellcard(40.0)
	
	gengetsu_tween = gengetsu.create_tween()
	gengetsu_tween.tween_property(
		gengetsu, "global_position", Vector2(450, 220), 1.0
	).set_trans(Tween.TRANS_QUAD)
	
	mugetsu_tween = mugetsu.create_tween()
	mugetsu_tween.tween_property(
		mugetsu, "global_position", Vector2(150, 800), 1.0
	).set_trans(Tween.TRANS_QUAD)
	
	await mugetsu_tween.finished
	
	mugetsu_tween = mugetsu.create_tween().set_loops()
	mugetsu_tween.tween_callback(shoot_line.bind(mugetsu))
	mugetsu_tween.tween_property(mugetsu, "global_position", Vector2(750, 820), 2.0).set_trans(Tween.TRANS_QUAD)
	mugetsu_tween.tween_callback(shoot_aim.bind(gengetsu, 1))
	mugetsu_tween.tween_interval(1.0)
	mugetsu_tween.tween_callback(shoot_line.bind(mugetsu))
	mugetsu_tween.tween_property(mugetsu, "global_position", Vector2(150, 820), 2.0).set_trans(Tween.TRANS_QUAD)
	mugetsu_tween.tween_callback(shoot_aim.bind(gengetsu, -1))
	mugetsu_tween.tween_interval(1.0)
	
	#gengetsu_tween = gengetsu.create_tween().set_loops()
	#gengetsu_tween.tween_interval(4.0)
	#gengetsu_tween.tween_callback(shoot_aim.bind(gengetsu, 1))
	#gengetsu_tween.tween_interval(4.0)
	#gengetsu_tween.tween_callback(shoot_aim.bind(gengetsu, -1))

func _physics_process(delta: float) -> void:
	if is_instance_valid(gengetsu):
		if not cleaning and gengetsu.hp <= 0:
			add_item_bulk(ITEM_POWER, 40, gengetsu.global_position)
			clean_up()
	if is_instance_valid(mugetsu):
		if not cleaning and mugetsu.hp <= 0:
			add_item_bulk(ITEM_POWER, 40, mugetsu.global_position)
			clean_up()

func _on_spellcard_timeout() -> void:
	clean_up()

func clean_up() -> void:
	cleaning = true
	end_chapter()
	gengetsu.clear_hp_markers()
	mugetsu.clear_hp_markers()
	
	if gengetsu_tween:
		gengetsu_tween.kill()
	if mugetsu_tween:
		mugetsu_tween.kill()
			
	gengetsu_tween = gengetsu.create_tween()
	gengetsu_tween.tween_property(
		gengetsu, "global_position", Vector2(500, -250), 1.0
	).set_trans(Tween.TRANS_QUAD)
	
	mugetsu_tween = mugetsu.create_tween()
	mugetsu_tween.tween_property(
		mugetsu, "global_position", Vector2(150, -250), 1.0
	).set_trans(Tween.TRANS_QUAD)
	end_script()

func shoot_line(node: Node2D) -> void:
	for i in range(10):
		if cleaning:
			return
		AudioManager.play_shoot1()
		for j in range(8):
			var bullet: Bullet = add_bullet(BULLET_ARROW)
			bullet.sprite_frame_x(BCOLOR_BLUE)
			bullet.global_position = node.global_position
			bullet.rotation = -PI/2
			vel(bullet, Vector2(0, -100 - j*50))
			
		await get_tree().create_timer(0.2, false, true).timeout
	
func shoot_aim(node: Node2D, mult: float) -> void:
	var angle: float = PI/4
	var amount: int = 8
	pat_aim.rotation = angle_to_player(node) + angle * mult
	for i in range(amount):
		if cleaning:
			return
		AudioManager.play_shoot1()
		pat_aim.position = node.global_position
		pat_aim.rotation -= angle/amount * mult * 2
		for bullet: Bullet in pat_aim.create():
			bullet.sprite_frame_x(BCOLOR_RED)
			disp_rot(bullet)
		await get_tree().create_timer(0.1, false, true).timeout
