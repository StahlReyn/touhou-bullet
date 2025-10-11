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
		enemy.position.x = (timer_count % 4) * 180 + 150
		enemy.position.y = -30
		
		if timer_count % 2 == 0:
			enemy.set_type.emit("red")
		timer_count += 1
		
	timer.start(2)

func create_enemy_shooter() -> Enemy:
	var enemy: Enemy = EntityEnums.get_enemy(EntityEnums.EnemyType.FAIRY)
	ComponentAcceleration.add_to_entity(enemy, Vector2(0, 100))
	ComponentTimer.add_to_entity(enemy, shoot_circle, 2.0)
	return enemy

static func shoot_circle(entity: Entity):
	#var pattern = PatternCircle.new()
	#pattern.speed = 200
	#pattern.acceleration = -100
	var pattern = PatternFlower.new()
	pattern.petal_count = 6
	pattern.petal_size = 5
	pattern.speed_min = 200
	pattern.speed_max = 300
	pattern.position = entity.position
	pattern.rotation = entity.position.angle_to_point(GameVariables.player.position)
	pattern.create()
