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
	if timer_count >= 64:
		timer.stop()
		await get_tree().create_timer(5.0, false, true).timeout
		end_chapter()
		end_script()
		return
	
	if timer_count >= 32:
		var enemy: Enemy = add_enemy(ENEMY_FAIRY)
		enemy.set_mhp(30)
		enemy.position = Vector2(800, -40)
		drop(enemy, 0, 5)
		timer_loop(enemy, shoot_trail.bind(enemy), 2.0)
		
		var tween: Tween = enemy.create_tween()
		tween.tween_property(enemy, "global_position", Vector2(750, 70), 1.0).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(enemy, "global_position", Vector2(750, 850), 2.0).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(enemy, "global_position", Vector2(-250, 850), 10.0)
		
	if timer_count % 8 == 0:
		spawn_shielded_fairy()
	
	timer_count += 1
	timer.start(0.5)

static func spawn_shielded_fairy():
	var enemy: Enemy = add_enemy(ENEMY_FAIRY_SUNFLOWER_DREAM)
	enemy.set_mhp(400)
	enemy.position = Vector2(-40, -40)
	#accel(enemy, Vector2(200, -100), Vector2(20, 400))
	drop(enemy, 25, 0)
	timer_loop(enemy, shoot_flower.bind(enemy), 3.0)
	
	var tween: Tween = enemy.create_tween()
	tween.tween_property(enemy, "global_position", Vector2(200, 200), 3.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(enemy, "global_position", Vector2(700, 200), 3.0).set_trans(Tween.TRANS_QUAD)
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
	
static func shoot_trail(entity: Entity):
	AudioManager.play_shoot1()
	var dir := direction_to_player(entity)
	for i in range(4):
		var bullet := add_bullet_colored(BULLET_ARROW, BCOLOR_BLUE, entity.global_position)
		var a := dir * (25 * i + 250)
		accel(bullet, a, a)
		rotate_to_player(bullet)

static func shoot_flower(entity: Entity):
	AudioManager.play_shoot1()
	var rotation = entity.position.angle_to_point(GameVariables.player.position)
	
	var flower = PatternFlower.new()
	flower.position = entity.global_position
	flower.rotation = rotation
	flower.petal_count = 6
	flower.petal_size = 8
	flower.speed_max = 450
	flower.speed_min = 300
	flower.bullet_scene = BULLET_CIRCLE_BORDERED
	
	for bullet: Bullet in flower.create():
		bullet.sprite_frame_x(BCOLOR_RED)
