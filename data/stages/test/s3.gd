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
	if timer_count >= 8:
		end_section()

	var enemy: Enemy = create_enemy_shooter()
	GameVariables.game_area.add_enemy(enemy)
	enemy.position.x = (timer_count % 3) * 200 + 150
	enemy.position.y = -30
	
	if timer_count % 2 == 0:
		enemy.set_type.emit("red")
	timer_count += 1
		
	timer.start(3)

func create_enemy_shooter() -> Enemy:
	var enemy: Enemy = EntityEnums.get_enemy(EntityEnums.EnemyType.FAIRY_SUNFLOWER)
	ComponentAcceleration.add_to_entity(enemy, Vector2(0, -300), Vector2(0, 500))
	ComponentTimer.add_to_entity(enemy, shoot_circle, 2.0)
	ComponentTimer.add_to_entity(enemy, shoot_trail, 0.25)
	return enemy

static func shoot_trail(entity: Entity):
	for i in range(2):
		var base_bullet = EntityEnums.get_bullet(
			EntityEnums.BulletType.CIRCLE_BORDERED,
			EntityEnums.BulletColor.GREEN
		)
		var accel := Vector2(200, 0)
		if i == 1:
			accel.x *= -1
		ComponentAcceleration.add_to_entity(base_bullet, accel)
		GameVariables.game_area.add_bullet(base_bullet, entity.global_position)
	
static func shoot_circle(entity: Entity):
	var rotation = entity.position.angle_to_point(GameVariables.player.position)
	var bullet_1 = EntityEnums.get_bullet(
		EntityEnums.BulletType.CIRCLE_BORDERED,
		EntityEnums.BulletColor.RED
	)
	
	var bullet_2 = EntityEnums.get_bullet(
		EntityEnums.BulletType.CIRCLE_BORDERED,
		EntityEnums.BulletColor.BLUE
	)
	
	var circ = PatternCircle.new()
	circ.position = entity.global_position
	circ.rotation = rotation
	circ.speed = 0
	circ.acceleration = 300
	circ.base_bullet = EntityEnums.get_bullet(
		EntityEnums.BulletType.CIRCLE_BORDERED,
		EntityEnums.BulletColor.YELLOW
	)
	circ.create()
	
	var flower = PatternFlower.new()
	flower.position = entity.global_position
	flower.rotation = rotation
	flower.petal_count = 6
	flower.petal_size = 6
	flower.speed_max = 400
	flower.speed_min = flower.speed_max * 0.5
	flower.base_bullet = bullet_1

	for i in range(2):
		flower.base_bullet = bullet_1
		if i % 2 == 1:
			flower.base_bullet = bullet_2
		flower.create()
		flower.rotation += PI/6
		#flower.petal_size -= 1
		flower.speed_max -= 50
		flower.speed_min = flower.speed_max * 0.5
