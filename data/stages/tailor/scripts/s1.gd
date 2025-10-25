extends SectionScript

var timer: Timer = Timer.new()
var timer_count: int = 0
var ending: bool = false

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
		
	if timer_count >= 64:
		ending = true
		timer.start(2.0)
		return
	
	var enemy: Enemy = add_enemy(ENEMY_FAIRY)
	enemy.set_mhp(20)
	if timer_count % 32 < 8:
		enemy.position = Vector2((timer_count % 8) * 50, -30)
		accel(enemy, Vector2(150, -100), Vector2(50, (timer_count % 8) * 40 + 150))
		drop(enemy, 5, 0)
		timer_loop(enemy, shoot_trail.bind(enemy, BCOLOR_RED), 1.0)
		enemy.set_type("red")
	elif timer_count % 32 < 16:
		enemy.position = Vector2(GameArea.size.x - 200 + (timer_count % 8) * 25, -30)
		accel(enemy, Vector2(-250, -150), Vector2(-50, (timer_count % 8) * 40 + 600))
		drop(enemy, 0, 5)
		timer_loop(enemy, shoot_trail.bind(enemy, BCOLOR_BLUE), 1.0)
		enemy.set_type("blue")
	elif timer_count % 32 < 24:
		enemy.position = Vector2(200 - (timer_count % 8) * 25, -30)
		accel(enemy, Vector2(250, -150), Vector2(50, (timer_count % 8) * 40 + 600))
		drop(enemy, 0, 5)
		timer_loop(enemy, shoot_trail.bind(enemy, BCOLOR_YELLOW), 1.0)
		enemy.set_type("yellow")
	else:
		enemy.position = Vector2(GameArea.size.x - (timer_count % 8) * 50, -30)
		accel(enemy, Vector2(-150, -100), Vector2(-50, (timer_count % 8) * 40 + 150))
		drop(enemy, 5, 0)
		timer_loop(enemy, shoot_trail.bind(enemy, BCOLOR_GREEN), 1.0)
		enemy.set_type("green")
	
	
	timer_count += 1
	timer.start(0.2)

static func shoot_trail(entity: Entity, color: int):
	AudioManager.play_shoot1()
	var dir := direction_to_player(entity)
	for i in range(5):
		var bullet := add_bullet_colored(BULLET_SPIKE, color, entity.global_position)
		var a := dir * 50 * (i + 10)
		accel(bullet, a, a)
		rotate_to_player(bullet)
