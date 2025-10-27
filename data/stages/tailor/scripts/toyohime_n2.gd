extends SectionScript

const SCENE_TOYOHIME: PackedScene = preload("res://data/enemies/bosses/toyohime.tscn")
const SCENE_WATER: PackedScene = preload("res://data/bullets/water_droplet.tscn")

var toyohime: Enemy
var toyohime_tween: Tween

var cleaning: bool = false
var shoot_angle: float = 0
var shoot_count: int = 0

var pat_circ1: PatternCircle

func _ready() -> void:
	GameVariables.reset_chapter_stats()
	
	pat_circ1 = PatternCircle.new()
	pat_circ1.amount = 30
	pat_circ1.speed = 350
	pat_circ1.bullet_scene = SCENE_WATER
	
	toyohime = get_boss("toyohime", SCENE_TOYOHIME, Vector2(100, -40))
	toyohime.set_mhp(7000)
	toyohime.add_hp_marker(2000)
	toyohime.damage_taken_mult = 1.0
	
	start_nonspellcard(40.0)
	
	toyohime_tween = toyohime.create_tween()
	toyohime_tween.tween_property(
		toyohime, "global_position", Vector2(460, 250), 1.0
	).set_trans(Tween.TRANS_SINE)
	
	#await mugetsu_tween.finished
	
	toyohime_tween = toyohime.create_tween().set_loops()
	toyohime_tween.tween_property(toyohime, "global_position", Vector2(350, 300), 2.0).set_trans(Tween.TRANS_QUAD)
	toyohime_tween.tween_callback(shoot_spiral.bind(toyohime))
	toyohime_tween.tween_interval(1.0)
	toyohime_tween.tween_callback(shoot_circle.bind(toyohime))
	toyohime_tween.tween_interval(1.0)
	toyohime_tween.tween_property(toyohime, "global_position", Vector2(600, 300), 2.0).set_trans(Tween.TRANS_QUAD)
	toyohime_tween.tween_callback(shoot_spiral.bind(toyohime))
	toyohime_tween.tween_interval(1.0)
	toyohime_tween.tween_callback(shoot_circle.bind(toyohime))
	toyohime_tween.tween_interval(1.0)

func _physics_process(delta: float) -> void:
	if is_instance_valid(toyohime):
		if not cleaning and toyohime.hp <= 2000:
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

func shoot_circle(node: Node2D) -> void:
	if cleaning:
		return
	AudioManager.play_shoot1()
	pat_circ1.position = node.global_position
	pat_circ1.rotation = angle_to_player(node)
	for bullet: Bullet in pat_circ1.create():
		bullet.material = MATERIAL_ADD
	
func shoot_spiral(node: Node2D) -> void:
	var bullet: Bullet
	var target: Entity = GameVariables.player
	var center_pos: Vector2 = target.global_position
	shoot_count += 1
	for i in range(24):
		if cleaning:
			return
		AudioManager.play_shoot1()
		center_pos = target.global_position
		for j in range(3):
			shoot_angle += 0.77
			bullet = add_bullet(BULLET_CIRCLE_BORDERED)
			if shoot_count % 2 == 0:
				bullet.sprite_frame_x(BCOLOR_RED)
			else:
				bullet.sprite_frame_x(BCOLOR_MAGENTA)
			bullet.global_position = center_pos + Vector2.from_angle(shoot_angle) * (250 + j * 40)
			
			var tween: Tween = bullet.create_tween().set_loops()
			tween.tween_callback(accel_target.bind(bullet, target))
			tween.tween_interval(5.0)
		
		await get_tree().create_timer(0.05, false, true).timeout

func accel_target(en: Entity, target: Node2D) -> void:
	var direction: Vector2 = en.global_position.direction_to(target.position)
	var final_pos: Vector2 = en.global_position + direction * 600
	var tween: Tween = en.create_tween()
	tween.tween_property(en, "global_position", final_pos, 4.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(3.0)
	
