class_name SceneMainMenu
extends Node2D

signal start_game

@onready var label_bgm: Label = $StartMenu/SelectionList/BGM/Label
@onready var label_sfx: Label = $StartMenu/SelectionList/SFX/Label
@onready var screen_wipe: ScreenWipe = $ScreenWipe

func _ready() -> void:
	modulate.a = 1.0
	update_labels()

func _physics_process(delta: float) -> void:
	pass

func add_volume(bus: String, num: float) -> void:
	var cur_bus = AudioServer.get_bus_index(bus)
	var cur_volume = AudioServer.get_bus_volume_linear(cur_bus)
	var new_volume = clamp(cur_volume + num, 0, 1)
	AudioServer.set_bus_volume_linear(cur_bus, new_volume)
	update_labels()

func get_volume_percent(bus: String) -> int:
	var cur_bus = AudioServer.get_bus_index(bus)
	var cur_volume = AudioServer.get_bus_volume_linear(cur_bus)
	return round(cur_volume * 100)

func update_labels() -> void:
	label_bgm.text = "BGM: " + str(get_volume_percent("BGM")) + " %"
	label_sfx.text = "SFX: " + str(get_volume_percent("SFX")) + " %"

func option_start():
	print("> Option Start")
	start_game.emit()
	screen_wipe.transition_scene(SceneManager.SCENE_GAME)

func option_options():
	#print("> Option Options")
	print("> Option VOLUME")

func option_quit():
	print("> Option Quit")
	get_tree().quit()

func _on_selection_list_selected(index: int) -> void:
	match index:
		0: # START
			option_start()
		3: # QUIT
			option_quit()

func _on_selection_list_right_selected(index: int) -> void:
	var increment: float = 0.05
	if Input.is_action_pressed("focus") or Input.is_key_pressed(KEY_SHIFT):
		increment = 0.2
	match index:
		1:
			add_volume("BGM", increment)
		2:
			add_volume("SFX", increment)

func _on_selection_list_left_selected(index: int) -> void:
	var increment: float = 0.05
	if Input.is_action_pressed("focus") or Input.is_key_pressed(KEY_SHIFT):
		increment = 0.2
	match index:
		1:
			add_volume("BGM", -increment)
		2:
			add_volume("SFX", -increment)
