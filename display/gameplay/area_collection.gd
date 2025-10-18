class_name AreaCollection
extends Sprite2D

var appear_time: float = 0

func _ready() -> void:
	appear_time = 0

func _physics_process(delta: float) -> void:
	if appear_time > 0:
		visible = true
		modulate.a = -cos(appear_time * 2) * 0.5 + 0.5
		appear_time -= delta
	else:
		visible = false

func _on_game_main_stage_started() -> void:
	appear_time = 7.0
