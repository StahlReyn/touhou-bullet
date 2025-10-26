extends SectionScript

var timer: Timer = Timer.new()
var timer_count: int = 0
var ending: bool = false

var path: Path2D = Path2D.new()

func _ready() -> void:
	
	timer.timeout.connect(_on_timer_end)
	add_child(timer)
	timer.start(1.0)

func _physics_process(delta: float) -> void:
	pass

func _on_timer_end() -> void:
	if ending:
		end_chapter()
		end_script()
		return
		
	if timer_count >= 32:
		ending = true
		timer.start(2.0)
		return
	
	var enemy: Enemy
	
	var i = timer_count % 8
	if i == 0:
		enemy = add_enemy(ENEMY_FAIRY_SUNFLOWER)
		enemy.set_mhp(300)
		enemy.set_type("green")
		timer_once(enemy, flower.bind(enemy), 4.0)
		drop(enemy, 20, 0)
	else:
		enemy = add_enemy(ENEMY_FAIRY)
		enemy.set_mhp(30)
		enemy.set_type("blue")
		timer_loop(enemy, trail.bind(enemy, BCOLOR_GREEN), 1.5)
		drop(enemy, 0, 5)
	
	enemy.position = Vector2(50, -40)
	var a := Vector2(-75, -75 + i * 5)
	
	if timer_count % 16 >= 8:
		a.x *= -1
		enemy.position.x = GameArea.size.x - 50
		
	accel(enemy, a, a * -4)
	
	timer_count += 1
	if timer_count % 8 == 0:
		timer.start(2.5)
	else:
		timer.start(0.25)

static func trail(entity: Entity, color: int):
	AudioManager.play_shoot1()
	var rot := angle_to_player(entity)
	
	var flower = PatternFlower.new()
	flower.position = entity.global_position
	flower.rotation = rot
	flower.petal_count = 1
	flower.petal_size = 4
	flower.speed_max = 400
	flower.speed_min = 300
	flower.arc_angle = TAU/16
	flower.bullet_scene = BULLET_ARROW
	for bullet: Bullet in flower.create():
		disp_rot(bullet)
		bullet.sprite_frame_x(BCOLOR_GREEN)

static func flower(entity: Entity):
	AudioManager.play_shoot1()
	var rotation = entity.position.angle_to_point(GameVariables.player.position)
	
	var circ = PatternCircle.new()
	circ.position = entity.global_position
	circ.rotation = rotation
	circ.speed = 0
	circ.acceleration = 300
	circ.bullet_scene = BULLET_CIRCLE_BORDERED
	for bullet: Bullet in circ.create():
		bullet.sprite_frame_x(BCOLOR_YELLOW)
	
	var flower = PatternFlower.new()
	flower.position = entity.global_position
	flower.rotation = rotation
	flower.petal_count = 6
	flower.petal_size = 6
	flower.speed_max = 400
	flower.speed_min = flower.speed_max * 0.5
	flower.bullet_scene = BULLET_CIRCLE_BORDERED

	for i in range(2):
		flower.create()
		if i % 2 == 0:
			for bullet: Bullet in flower.create():
				bullet.sprite_frame_x(BCOLOR_RED)
		else:
			for bullet: Bullet in flower.create():
				bullet.sprite_frame_x(BCOLOR_BLUE)
		flower.rotation += PI/6
		#flower.petal_size -= 1
		flower.speed_max -= 50
		flower.speed_min = flower.speed_max * 0.5
