class_name DialogueLine
extends DialogueEvent

@export_group("Dialogue")
@export var id: String
@export var dialogue: String
@export_group("Extra")
@export var face_anim: String
@export var body_anim: String
@export var deactivate_others: bool = true
@export var bubble_offset: Vector2 = Vector2.ZERO
@export_group("Instantiation")
@export var flip_x: bool = false
@export var portrait_scene: PackedScene
@export var portrait_position: DialogueView.PortraitPosition

static var bubble_scene = preload("res://scripts/dialogues/dialogue_bubble.tscn")

func run() -> void:
	var portrait: Portrait
	if portrait_scene != null:
		portrait = portrait_scene.instantiate()
		if flip_x:
			portrait.scale.x *= -1
		portrait.id = id
		dialogue_view.add_portrait(portrait, portrait_position)
	else:
		portrait = dialogue_view.activate_portrait(id)
	
	if deactivate_others:
		dialogue_view.deactivate_all_portraits()
	
	if wait_for_input:
		dialogue_view.input_event.connect(_on_dialogue_input)
	
	if dialogue.length() > 0:
		var bubble: DialogueBubble = bubble_scene.instantiate()
		dialogue_view.start_dialogue(id, dialogue, bubble, bubble_offset)
		print("Dialogue: ", dialogue)
	
	if face_anim.length() > 0:
		portrait.face_sprite.play(face_anim)
	
	if body_anim.length() > 0:
		portrait.body_sprite.play(body_anim)
	
	if !wait_for_input:
		finished.emit()

func _on_dialogue_input():
	# Clean up signal so it clears itself
	dialogue_view.input_event.disconnect(_on_dialogue_input)
	finished.emit()
