class_name PauseMenu
extends PanelContainer

signal retry
signal quit

@onready var selection_list: SelectionList = $MarginContainer/SelectionList

func _ready() -> void:
	modulate.a = 0.0
	visible = true

func _physics_process(delta: float) -> void:
	if get_tree().paused:		
		if Input.is_action_just_pressed("bomb") or Input.is_action_just_pressed("back"):
			option_return()
		modulate.a = MathUtils.lerp_smooth(modulate.a, 1.0, 100, delta)
	else:
		if Input.is_action_just_pressed("back"):
			selection_list.reset_display()
			get_tree().paused = true
		modulate.a = MathUtils.lerp_smooth(modulate.a, 0.0, 100, delta)

func option_return():
	print("> Option Return")
	get_tree().paused = false

func option_retry():
	print("> Option Retry")
	retry.emit()
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = false
	SceneManager.reload_current_scene()

func option_quit():
	print("> Option Quit")
	quit.emit()
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = false
	SceneManager.goto_scene(SceneManager.SCENE_MAIN_MENU)


func _on_selection_list_selected(index: int) -> void:
	match index:
		0: # RETURN
			option_return()
		1: # RETRY
			option_retry()
		2: # QUIT
			option_quit()
