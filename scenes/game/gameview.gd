class_name GameView
extends Node2D

signal game_start
signal start_stage
signal ending_stage

func _ready() -> void:
	game_start.emit()

func _physics_process(delta: float) -> void:
	GameVariables.game_time += delta	

func _on_gamemain_start_stage(stage_data : StageData) -> void:
	start_stage.emit(stage_data)

func _on_stage_handler_ending_stage() -> void:
	ending_stage.emit()
