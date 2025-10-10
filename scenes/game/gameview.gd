class_name GameView
extends Node2D

signal game_start
signal start_stage
signal ending_stage

var timer: Timer = Timer.new()
var timer_count: int = 0

func _ready() -> void:
	GameVariables.game_view = self
	game_start.emit()
	timer.autostart = true;
	timer.wait_time = 1.0
	timer.timeout.connect(_on_timer_end)
	add_child(timer)

func _physics_process(delta: float) -> void:
	GameVariables.game_time += delta	

#func _on_gamemain_start_stage(stage_data : StageData) -> void:
#	start_stage.emit(stage_data)

func _on_stage_handler_ending_stage() -> void:
	ending_stage.emit()

func add_bullet(bullet: Bullet) -> void:
	add_child(bullet) # May change to specific container

func add_enemy(enemy: Enemy) -> void:
	add_child(enemy)

# ================ PLACEHOLDER ================
func _on_timer_end() -> void:
	for i in range(16):
		var enemy: Enemy = TestFactory.create_simple_enemy()
		enemy.position.x = (timer_count % 16) * 50 + 100
		enemy.position.y = -10
		#enemy.add_child(ComponentConstantVelocity.rand_dir(enemy, 200))
		#enemy.add_child(ComponentConstantAcceleration.rand_dir(enemy, 200))
		var comp: ComponentGravity = ComponentGravity.create(enemy, GameVariables.player, 500000)
		comp.velocity = Vector2(0, 50 + (timer_count % 16) * 0)
		if timer_count % 2 == 0:
			enemy.set_type.emit("red")
		enemy.add_child(comp)
		timer_count += 1
	timer.start(1)
	
