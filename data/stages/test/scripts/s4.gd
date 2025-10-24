extends SectionScript

var timer: Timer = Timer.new()
var timer_count: int = 0

func _ready() -> void:
	timer.timeout.connect(_on_timer_end)
	add_child(timer)
	timer.start(3.0)

func _physics_process(delta: float) -> void:
	pass

# ================ PLACEHOLDER ================
func _on_timer_end() -> void:
	if timer_count > 2:
		end_chapter()
		end_script()
		return

	var enemy: Enemy = create_enemy_shooter()
	enemy.position.x = (timer_count % 3) * 200 + 150
	enemy.position.y = -40
	timer_count += 1
		
	timer.start(1)

func create_enemy_shooter() -> Enemy:
	var enemy: Enemy = add_enemy(ENEMY_FAIRY_SUNFLOWER_DREAM)
	ComponentAcceleration.add_to_entity(enemy, Vector2(0, 300))
	ComponentTimer.add_to_entity(enemy, shoot_circle, 2.0)
	ComponentTimer.add_to_entity(enemy, shoot_trail, 0.20)
	ComponentDrop.add_powerpoint(enemy, 40, 0)
	return enemy

static func shoot_trail(entity: Entity):
	for i in range(2):
		var base_bullet = add_bullet_colored(BULLET_CIRCLE_BORDERED, BCOLOR_GREEN, entity.global_position)
		var accel := Vector2(200, 0)
		if i == 1:
			accel.x *= -1
		ComponentAcceleration.add_to_entity(base_bullet, accel)
	
static func shoot_circle(entity: Entity):
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
