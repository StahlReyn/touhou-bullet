extends Control

signal changing_scene
signal retry
signal quit

@export var selection_list : SelectionList

func _ready() -> void:
	modulate.a = 0.0
	visible = true

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("back") and not get_tree().paused:
		selection_list.reset_display()
		do_pause()
	
	if get_tree().paused:
		if Input.is_action_just_pressed("shoot"):
			match selection_list.cur_selection:
				0: # RETURN
					option_return()
				1: # RETRY
					option_retry()
				2: # QUIT
					option_quit()
					
		if Input.is_action_just_pressed("bomb"):
			option_return()
		
		modulate.a = MathUtils.lerp_smooth(modulate.a, 1.0, 100, delta)
	else:
		modulate.a = MathUtils.lerp_smooth(modulate.a, 0.0, 100, delta)

func option_return():
	print("> Option Return")
	get_tree().paused = false

func option_retry():
	print("> Option Retry")
	retry.emit()
	
func option_quit():
	print("> Option Quit")
	quit.emit()

func do_pause():
	get_tree().paused = true
