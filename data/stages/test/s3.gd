extends SectionScript

var timer: Timer = Timer.new()
var timer_count: int = 0

func _ready() -> void:
	timer.timeout.connect(_on_timer_end)
	add_child(timer)
	timer.start(0.5)

func _physics_process(delta: float) -> void:
	pass

# ================ PLACEHOLDER ================
func _on_timer_end() -> void:
	if timer_count >= 16:
		end_section()
	
	for i in range(1):
		var enemy: Enemy = create_enemy_shooter()
		GameVariables.game_view.add_enemy(enemy)
		enemy.position.x = (timer_count % 4) * 200 + 100
		enemy.position.y = -30
		
		if timer_count % 2 == 0:
			enemy.set_type.emit("red")
		timer_count += 1
		
	timer.start(1)

func create_enemy_shooter() -> Enemy:
	var enemy: Enemy = EntityEnums.get_enemy(EntityEnums.EnemyType.FAIRY)
	ComponentAcceleration.add_to_entity(enemy, Vector2(0, 100))
	ComponentTimer.add_to_entity(enemy, shoot_circle, 1.0)
	return enemy

static func shoot_circle(entity: Entity):
	var amount = 16
	var mag = 100
	for i in range(amount):
		var bullet: Bullet = EntityEnums.get_bullet(
			EntityEnums.BulletType.CIRCLE_BORDERED,
			EntityEnums.BulletColor.RED
		)
		ComponentAcceleration.add_to_entity(bullet, Vector2.from_angle(i * TAU/amount) * mag)
		GameVariables.game_view.add_bullet(bullet, entity.global_position)
