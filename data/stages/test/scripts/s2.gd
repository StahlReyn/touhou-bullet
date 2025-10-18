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
	if timer_count >= 64:
		end_chapter()
		end_script()
	
	var enemy: Enemy = add_enemy(ENEMY_FAIRY)
	enemy.position.x = (timer_count % 16) * 50 + 100
	enemy.position.y = -30
	
	var comp := ComponentAcceleration.rand_dir(enemy, 500)
	comp.velocity = Vector2(0, 200)
	enemy.add_child(comp)
	
	ComponentTimer.add_to_entity(enemy, shoot_trail, 0.2)
	ComponentDrop.add_powerpoint(enemy, 0, 3)
	
	if timer_count % 2 == 0:
		enemy.set_type.emit("red")
	timer_count += 1
	timer.start(0.05)

static func shoot_trail(entity: Entity):
	var base_bullet = add_bullet_colored(BULLET_OVAL, BCOLOR_BLUE, entity.global_position)
	ComponentAcceleration.add_to_entity(base_bullet, Vector2(0, 400))
