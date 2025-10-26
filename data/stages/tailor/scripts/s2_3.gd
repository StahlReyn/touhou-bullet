extends SectionScript

const SCENE_SHIELD: PackedScene = preload("res://data/enemies/shield.tscn")

var timer: Timer = Timer.new()
var timer_count: int = 0

func _ready() -> void:
	timer.timeout.connect(_on_timer_end)
	add_child(timer)
	timer.start(1.0)

func _physics_process(delta: float) -> void:
	pass

func _on_timer_end() -> void:
	if timer_count >= 96:
		timer.stop()
		await get_tree().create_timer(5.0, false, true).timeout
		end_chapter()
		end_script()
		return
	
	if timer_count >= 32:
		spawn_lower_fairy()
		
	if timer_count % 8 == 0:
		spawn_shielded_fairy()
	
	timer_count += 1
	timer.start(0.35)

static func spawn_lower_fairy():
	var enemy: Enemy = add_enemy(ENEMY_FAIRY)
	enemy.set_mhp(30)
	enemy.position = Vector2(-40, -40)
	drop(enemy, 0, 5)
	timer_loop(enemy, shoot_small.bind(enemy), 0.3)
	
	var tween: Tween = enemy.create_tween()
	tween.tween_property(enemy, "global_position", Vector2(150, 70), 1.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(enemy, "global_position", Vector2(150, 850), 2.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(enemy, "global_position", Vector2(1000, 850), 10.0)

static func spawn_shielded_fairy():
	var enemy: Enemy = add_enemy(ENEMY_FAIRY_SUNFLOWER_DREAM)
	enemy.set_mhp(400)
	enemy.position = Vector2(800, -40)
	#accel(enemy, Vector2(200, -100), Vector2(20, 400))
	drop(enemy, 25, 0)
	
	var shield: Enemy = add_enemy(SCENE_SHIELD)
	shield.position = enemy.position
	ComponentLerpFollow.add_to_entity(shield, enemy, 30.0)
	ComponentRotateFollow.add_to_entity(shield, GameVariables.player)
	enemy.died.connect(shield_owner_died.bind(shield))
	enemy.despawned.connect(shield_owner_despawned.bind(shield))
	
	var tween: Tween = enemy.create_tween()
	tween.tween_property(enemy, "global_position", Vector2(700, 200), 3.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(enemy, "global_position", Vector2(200, 200), 3.0).set_trans(Tween.TRANS_QUAD)
	
	await tween.finished
	tween = enemy.create_tween().set_loops()
	tween.tween_callback(shoot_trail.bind(enemy, angle_to_player(enemy))).set_delay(0.1)
	accel(enemy, direction_to_player(enemy) * 600)

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
static func shoot_trail(entity: Entity, angle: float):
	AudioManager.play_shoot1()
	var pat := PatternFlower.new()
	pat.position = entity.global_position
	pat.rotation = angle + PI
	pat.petal_count = 1
	pat.petal_size = 4
	pat.speed_max = 400
	pat.speed_min = 300
	pat.arc_angle = PI/2
	pat.bullet_scene = BULLET_ARROW
	
	for bullet: Bullet in pat.create():
		bullet.sprite_frame_x(BCOLOR_RED)
		disp_rot(bullet)

static func shoot_small(entity: Entity):
	var dir := direction_to_player(entity)
	var bullet := add_bullet_colored(BULLET_CIRCLE_BORDERED, BCOLOR_BLUE, entity.global_position)
	accel(bullet, Vector2(0, 500), dir * 150 + Vector2(0, -250))
