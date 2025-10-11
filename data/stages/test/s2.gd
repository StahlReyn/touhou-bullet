extends SectionScript

var timer: Timer = Timer.new()
var timer_count: int = 0

func _ready() -> void:
	timer.timeout.connect(_on_timer_end)
	add_child(timer)
	timer.start(1)

func _physics_process(delta: float) -> void:
	pass

# ================ PLACEHOLDER ================
func _on_timer_end() -> void:
	if timer_count >= 64:
		end_section()
	
	for i in range(4):
		var enemy: Enemy = EntityEnums.get_enemy(EntityEnums.EnemyType.FAIRY)
		GameVariables.game_view.add_enemy(enemy)
		enemy.position.x = (timer_count % 16) * 50 + 100
		enemy.position.y = -30
		
		var comp := ComponentAcceleration.rand_dir(enemy, 500)
		comp.velocity = Vector2(0, 200)
		enemy.add_child(comp)
		
		if timer_count % 2 == 0:
			enemy.set_type.emit("red")
		timer_count += 1
	timer.start(0.05)
