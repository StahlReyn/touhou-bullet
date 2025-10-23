class_name SceneEnding
extends Node2D

@onready var input_delay: Timer = $Timer
@onready var screen_wipe: ScreenWipe = $ScreenWipe
@onready var image_container: Node2D = $ImageContainer
@onready var text_label: Label = $TextPanel/MarginContainer/Text

@export_multiline var texts: Array[String]

var can_input: bool = false
var image_index: int = 0
var tween: Tween

func _ready() -> void:
	get_tree().paused = false
	print(image_container.get_child_count())
	
	for node: Node2D in image_container.get_children():
		node.modulate.a = 0
	
	input_delay.start()

func _physics_process(delta: float) -> void:
	if tween and text_label.visible_ratio >= 1:
		tween.kill() # Finished tween
	if can_input:
		if Input.is_action_just_pressed("shoot") or Input.is_action_just_pressed("bomb"):
			if tween and tween.is_valid(): # Force finish animation first
				tween.custom_step(100.0)
				tween.kill() # Abort the previous animation.
			elif has_next_image():
				next_image()
			else:
				screen_wipe.transition_scene(SceneManager.SCENE_MAIN_MENU)

func has_next_image() -> bool:
	return image_container.get_child_count() > image_index

func next_image() -> void:
	print("Next Image")
	tween = create_tween()
	var node: Node2D = image_container.get_child(image_index)
	text_label.visible_characters = 0
	text_label.text = texts[image_index]
	tween.tween_property(node, "modulate", Color.WHITE, 0.4)
	tween.tween_property(text_label, "visible_characters", 1000, 8.0)
	image_index += 1

func _on_timer_timeout() -> void:
	can_input = true
