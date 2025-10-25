class_name SceneGame
extends Node2D

signal stage_started

@onready var screen_wipe: ScreenWipe = $GameOverlay/ScreenWipe

func _ready() -> void:
	print("GAME MAIN READY")
	# Scene Handler need to update if it's reloaded 
	# as previous is considered freed, breaking stuff
	SceneManager.current_scene = self
	start_game()
	# Engine.time_scale = 20.0
	
func _physics_process(delta: float) -> void:
	pass

func start_game() -> void:
	# PLACEHOLDER - there's no continuous stage yet so it's fine to reset
	GameVariables.reset_variables()
	stage_started.emit()

func _on_stage_controller_stage_ended() -> void:
	screen_wipe.transition_scene(SceneManager.SCENE_ENDING)
