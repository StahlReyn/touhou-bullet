extends SectionScript

var timer: Timer = Timer.new()
var timer_count: int = 0

func _ready() -> void:
	timer.timeout.connect(_on_timer_end)
	add_child(timer)
	timer.start(3)

func _physics_process(delta: float) -> void:
	pass

# ================ PLACEHOLDER ================
func _on_timer_end() -> void:
	if timer_count >= 128:
		end_section()
	
	var enemy: Enemy = EntityEnums.get_enemy(EntityEnums.EnemyType.FAIRY)
	GameVariables.game_area.add_enemy(enemy)
	enemy.position.x = (timer_count % 16) * 50 + 100
	enemy.position.y = -30
	
	var comp := ComponentAcceleration.rand_dir(enemy, 500)
	comp.velocity = Vector2(0, 200)
	enemy.add_child(comp)
	
	ComponentTimer.add_to_entity(enemy, shoot_trail, 0.2)
	
	if timer_count % 2 == 0:
		enemy.set_type.emit("red")
	timer_count += 1
	timer.start(0.05)

static func shoot_trail(entity: Entity):
	var base_bullet = EntityEnums.get_bullet(
		EntityEnums.BulletType.OVAL,
		EntityEnums.BulletColor.BLUE
	)
	var accel := Vector2(0, 400)
	ComponentAcceleration.add_to_entity(base_bullet, accel)
	GameVariables.game_area.add_bullet(base_bullet, entity.global_position)
	
