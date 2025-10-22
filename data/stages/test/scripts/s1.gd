extends SectionScript

const SCENE_DREAMWORLD: PackedScene = preload("res://scenes/maps/dreamworld.tscn")

var timer: Timer = Timer.new()
var timer_count: int = 0

func _ready() -> void:
	timer.autostart = true;
	timer.wait_time = 1.0
	timer.timeout.connect(_on_timer_end)
	add_child(timer)
	transition_stage_scene(SCENE_DREAMWORLD)

func _physics_process(delta: float) -> void:
	pass

# ================ PLACEHOLDER ================
func _on_timer_end() -> void:
	if timer_count >= 48:
		end_chapter()
		end_script()
	
	for i in range(16):
		var enemy: Enemy = add_enemy(ENEMY_FAIRY)
		enemy.position.x = (timer_count % 16) * 50 + 100
		enemy.position.y = -30
		
		var comp: ComponentGravity = ComponentGravity.create(enemy, GameVariables.player, 500000)
		comp.velocity = Vector2(0, 50 + (timer_count % 16) * 0)
		enemy.add_child(comp)
		
		ComponentDrop.add_powerpoint(enemy, 3, 0)
		
		if timer_count % 2 == 0:
			enemy.set_type.emit("red")
		timer_count += 1
	timer.start(1)
