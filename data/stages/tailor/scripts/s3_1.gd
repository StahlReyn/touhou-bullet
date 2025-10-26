extends SectionScript

const SCENE_SEA: PackedScene = preload("res://scenes/maps/sea_of_tranquility.tscn")
const SCENE_SHIELD: PackedScene = preload("res://data/enemies/shield.tscn")

var timer: Timer = Timer.new()
var timer_count: int = 0

func _ready() -> void:
	timer.timeout.connect(_on_timer_end)
	add_child(timer)
	timer.start(2.0)
	transition_stage_scene(SCENE_SEA)

func _physics_process(delta: float) -> void:
	pass

func _on_timer_end() -> void:
	if timer_count >= 32:
		timer.stop()
		await get_tree().create_timer(5.0, false, true).timeout
		end_chapter()
		end_script()
		return
	
	if timer_count >= 16:
		spawn_back_fairy()
		
	if timer_count % 4 == 0:
		spawn_shielded_fairy()
	
	timer_count += 1
	timer.start(1.0)

func spawn_back_fairy():
	var enemy: Enemy = add_enemy(ENEMY_FAIRY)
	enemy.set_mhp(50)
	enemy.position = Vector2(-40, -40)
	drop(enemy, 0, 5)
	enemy.set_type("red")
	
	var sh_tween: Tween = enemy.create_tween().set_loops()
	sh_tween.tween_interval(3.0)
	sh_tween.tween_callback(shoot_trail.bind(enemy))
	
	var tween: Tween = enemy.create_tween()
	tween.tween_property(enemy, "global_position", Vector2(100, 100), 0.5).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(enemy, "global_position", Vector2(760, 100), 3.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(enemy, "global_position", Vector2(760, 850), 3.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(enemy, "global_position", Vector2(-200, 850), 10.0)
	
func spawn_shielded_fairy():
	var enemy: Enemy = add_enemy(ENEMY_FAIRY_SUNFLOWER_DREAM)
	enemy.set_mhp(500)
	enemy.position = Vector2(-40, -40)
	#accel(enemy, Vector2(200, -100), Vector2(20, 400))
	drop(enemy, 20, 0)
	
	var tween: Tween = enemy.create_tween()
	tween.tween_property(enemy, "global_position", Vector2(700, 200), 3.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(shoot_flower.bind(enemy))
	tween.tween_interval(3.0)
	tween.tween_property(enemy, "global_position", Vector2(200, 300), 3.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(shoot_flower.bind(enemy))
	tween.tween_interval(3.0)
	tween.tween_property(enemy, "global_position", Vector2(500, 400), 3.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(shoot_flower.bind(enemy))
	tween.tween_interval(3.0)
	tween.tween_property(enemy, "global_position", Vector2(100, -300), 3.0).set_trans(Tween.TRANS_QUAD)
	
	var shield: Enemy = add_enemy(SCENE_SHIELD)
	shield.position = enemy.position
	ComponentLerpFollow.add_to_entity(shield, enemy, 30.0)
	ComponentRotateFollow.add_to_entity(shield, GameVariables.player)
	enemy.died.connect(shield_owner_died.bind(shield))
	enemy.despawned.connect(shield_owner_despawned.bind(shield))

static func shield_owner_died(shield: Entity):
	if not is_instance_valid(shield):
		return
	shield.clear_components()
	ComponentDespawnEdge.add_to_entity(shield)
	var dir := Vector2.from_angle(shield.rotation)
	accel(shield, dir * 800)
	
static func shield_owner_despawned(shield: Entity):
	if not is_instance_valid(shield):
		return
	shield.despawn()
	
func shoot_trail(entity: Entity):
	AudioManager.play_shoot1()
	var rotation := angle_to_player(entity)
	
	var pat_aim := PatternFlower.new()
	pat_aim.petal_count = 1
	pat_aim.petal_size = 3
	pat_aim.speed_max = 400
	pat_aim.speed_min = 300
	pat_aim.arc_angle = PI/32
	pat_aim.bullet_scene = BULLET_ARROW
	pat_aim.rotation = rotation
	pat_aim.position = entity.global_position
	for bullet: Bullet in pat_aim.create():
		bullet.sprite_frame_x(BCOLOR_RED)
		disp_rot(bullet)
	
func shoot_flower(entity: Entity):
	AudioManager.play_shoot1()
	var rotation := angle_to_player(entity)
	
	var flower := PatternFlower.new()
	flower.position = entity.global_position
	flower.rotation = rotation - PI/6
	flower.petal_count = 6
	flower.petal_size = 8
	flower.speed_max = 200
	flower.speed_min = 100
	flower.bullet_scene = BULLET_OVAL
	
	for i in range(3):
		for bullet: Bullet in flower.create():
			if i % 2 == 0:
				bullet.sprite_frame_x(BCOLOR_YELLOW)
			else:
				bullet.sprite_frame_x(BCOLOR_BLUE)
			disp_rot(bullet)
		flower.rotation += PI/6
		await get_tree().create_timer(0.3, false, true).timeout
