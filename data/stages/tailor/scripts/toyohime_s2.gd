extends SectionScript

const SCENE_TOYOHIME: PackedScene = preload("res://data/enemies/bosses/toyohime.tscn")
const SCENE_RAINBOW: PackedScene = preload("res://data/enemies/rainbow_droplet.tscn")
const SCENE_WATER: PackedScene = preload("res://data/bullets/water_droplet.tscn")

var toyohime: Enemy
var toyohime_tween: Tween

var cleaning: bool = false
var shoot_angle: float = 0
var shoot_count: int = 0

var pat_circ1: PatternCircle
var pat_circ2: PatternCircle

func _ready() -> void:
	toyohime = get_boss("toyohime", SCENE_TOYOHIME, Vector2(100, -40))
	toyohime.mhp = 7000
	toyohime.hp = 2000
	toyohime.damage_taken_mult = 0.2
	
	pat_circ1 = PatternCircle.new()
	pat_circ1.amount = 16
	pat_circ1.speed = 250
	pat_circ1.bullet_scene = SCENE_WATER
	
	pat_circ2 = PatternCircle.new()
	pat_circ2.amount = 16
	pat_circ2.speed = 350
	pat_circ2.bullet_scene = BULLET_CRYSTAL
	
	GameVariables.cur_spellcard_bonus = 8000000
	GameVariables.cur_spellcard_name = "Hurricane Sign \"Tailor's Swift\""
	start_spellcard(40.0)
	
	toyohime_tween = toyohime.create_tween()
	toyohime_tween.tween_property(
		toyohime, "global_position", Vector2(460, 300), 1.0
	).set_trans(Tween.TRANS_SINE)
	
	await toyohime_tween.finished
	
	spawn_rainbow()
	
	await get_tree().create_timer(3.0, false, true).timeout
	
	toyohime_tween = toyohime.create_tween().set_loops()
	toyohime_tween.tween_callback(shoot_circle.bind(toyohime))
	toyohime_tween.tween_interval(2.0)
	toyohime_tween.tween_callback(shoot_spiral.bind(toyohime))
	toyohime_tween.tween_interval(2.0)

func _physics_process(delta: float) -> void:
	if is_instance_valid(toyohime):
		if not cleaning and toyohime.hp <= 0:
			add_item_bulk(ITEM_POWER, 40, toyohime.global_position)
			clean_up()

func _on_spellcard_timeout() -> void:
	clean_up()

func clean_up() -> void:
	cleaning = true
	end_chapter()
	toyohime_tween.kill()
	toyohime.clear_hp_markers()
	end_script()

func spawn_rainbow() -> void:
	for i in range(24):
		AudioManager.play_shoot1()
		var enemy: Enemy = add_enemy(SCENE_RAINBOW)
		enemy.global_position = toyohime.global_position
		enemy.rotation = i * -0.77
		ComponentRotatableVelocity.add_to_entity(enemy, Vector2(300, 0))
		
		var tween: Tween = enemy.create_tween()
		tween.tween_property(enemy, "rotation", enemy.rotation - PI, 1.0)
		tween.tween_property(enemy, "rotation", enemy.rotation - TAU * 6, 30.0)
		
		await get_tree().create_timer(0.05, false, true).timeout

func shoot_circle(node: Node2D) -> void:
	if cleaning:
		return
	pat_circ1.rotation = angle_to_player(node)
	for i in range(4):
		pat_circ1.position = toyohime.global_position
		pat_circ1.rotation += PI / pat_circ1.amount
		pat_circ1.offset = i * Vector2(-20, 40)
		AudioManager.play_shoot1()
		for bullet: Bullet in pat_circ1.create():
			bullet.material = MATERIAL_ADD
			disp_rot(bullet)
		await get_tree().create_timer(0.4, false, true).timeout

func shoot_spiral(node: Node2D) -> void:
	pat_circ2.rotation = angle_to_player(node)
	for i in range(24):
		if cleaning:
			return
		AudioManager.play_shoot1()
		pat_circ2.position = node.global_position
		pat_circ2.rotation -= TAU/96
		for bullet: Bullet in pat_circ2.create():
			bullet.sprite_frame_x(BCOLOR_BLUE)
			disp_rot(bullet)
		await get_tree().create_timer(0.05, false, true).timeout
