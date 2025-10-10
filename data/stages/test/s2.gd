extends SectionScript

var timer: Timer = Timer.new()
var timer_count: int = 0

func _ready() -> void:
	timer.timeout.connect(_on_timer_end)
	add_child(timer)
	timer.start(0.1)

func _physics_process(delta: float) -> void:
	pass

# ================ PLACEHOLDER ================
func _on_timer_end() -> void:
	if timer_count >= 2048:
		end_section()
	
	for i in range(4):
		var enemy: Enemy = TestFactory.create_simple_enemy()
		enemy.position.x = (timer_count % 16) * 50 + 100
		enemy.position.y = -10
		var comp := ComponentConstantAcceleration.rand_dir(enemy, 500)
		comp.velocity = Vector2(0, 200)
		if timer_count % 2 == 0:
			enemy.set_type.emit("red")
		enemy.add_child(comp)
		timer_count += 1
	timer.start(0.05)
