extends SectionScript

const EIRIN_SCENE: PackedScene = preload("res://data/enemies/bosses/eirin.tscn")

var timer: Timer = Timer.new()
var timer_count: int = 0

var eirin: Enemy
var eirin_lerp: ComponentLerpPosition

var pat_circ1: PatternCircle
var pat_circ2: PatternCircle

var main_bullet: Bullet
var start_spin: bool = false

var total_time: float = 0.0

func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_end)
	timer.start(2)
	
	pat_circ1 = PatternCircle.new()
	pat_circ1.amount = 4
	pat_circ1.speed = 300
	pat_circ1.bullet_scene = BULLET_OVAL
	pat_circ1.arc_angle = TAU/48
	pat_circ1.rotation = TAU/4
	
	pat_circ2 = PatternCircle.new()
	pat_circ2.amount = 24
	pat_circ2.speed = 400
	pat_circ2.bullet_scene = BULLET_OVAL
	pat_circ2.arc_angle = TAU * 5/6
	pat_circ2.rotation = 0
	
	eirin = get_boss("eirin", EIRIN_SCENE, Vector2(GameArea.size.x * 0.5, -40))
	eirin.hp = 1000
	eirin.damage_taken_mult = 0.25
	eirin_lerp = ComponentLerpPosition.add_to_entity(eirin, Vector2(GameArea.size.x * 0.5, 300), 2.0)
	
	GameVariables.cur_spellcard_name = "Mind of God \"Mind your Business\""
	start_spellcard(40.0)
	
	await get_tree().create_timer(1.0, false, true).timeout
	main_bullet = add_bullet(BULLET_CIRCLE_BORDERED, eirin.global_position)
	main_bullet.remove_from_group("clearable")
	main_bullet.damage_retention = 1.0
	main_bullet.rotation = 0
	main_bullet.sprite_frame_x(BCOLOR_BLUE)
	await main_bullet.create_tween().tween_property(
		main_bullet, "position", Vector2(GameArea.size.x * 0.5, 550), 1.0
	).set_trans(Tween.TRANS_QUAD).finished
	start_spin = true

func _physics_process(delta: float) -> void:
	if is_instance_valid(eirin):
		if eirin.hp <= 0:
			clean_up()
	if start_spin:
		main_bullet.rotation += delta * 0.5
		main_bullet.position += Vector2.from_angle(main_bullet.rotation) * 50 * delta
	total_time += delta
	
func _on_spellcard_timeout() -> void:
	clean_up()
	
# ================ PLACEHOLDER ================
func clean_up() -> void:
	end_chapter()
	# eirin_lerp.position = Vector2(420, -120)
	eirin_lerp.queue_free() # Free for next one to add back
	start_spin = false
	main_bullet.remove()
	timer.stop()
	end_script()
	
func _on_timer_end() -> void:
	pat_circ1.position = eirin.global_position
	pat_circ1.rotation += 2 * pat_circ1.arc_angle
	pat_circ1.speed = 300
	for i in range(2):
		for bullet: Bullet in pat_circ1.create():
			bullet.sprite_frame_x(BCOLOR_BLUE)
			disp_rot(bullet)
		pat_circ1.speed -= 50
	
	if start_spin:
		if timer_count % 2 == 0:
			AudioManager.play_shoot1()
			pat_circ2.position = main_bullet.global_position
			pat_circ2.rotation = main_bullet.rotation + PI*3/4
			for bullet: Bullet in pat_circ2.create():
				bullet.sprite_frame_x(BCOLOR_RED)
				disp_rot(bullet)
		
		for rot: float in [PI/4, PI/6, -PI/6, -PI/4]:
			rot += main_bullet.rotation + PI/2
			var dir = Vector2.from_angle(rot)
			var bullet: Bullet = add_bullet(BULLET_LASER_PARTIAL, main_bullet.global_position)
			bullet.sprite_frame_x(BCOLOR_BLUE)
			bullet.material = MATERIAL_ADD
			vel(bullet, dir * 1200)
			bullet.rotation = rot
	
	timer_count += 1
	timer.start(0.05)
	
