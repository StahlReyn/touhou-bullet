class_name DialogueLine
extends DialogueEvent

@export_category("Dialogue")
@export var id: String
@export var dialogue: String
@export var deactivate_others: bool = true
@export_category("Instantiation")
@export var flip_x: bool = false
@export var portrait_scene: PackedScene
@export var portrait_position: DialogueView.PortraitPosition

func run() -> void:
	if portrait_scene != null:
		var portrait: Portrait = portrait_scene.instantiate()
		if flip_x:
			portrait.scale.x *= -1
		portrait.id = id
		dialogue_view.add_portrait(portrait, portrait_position)
	if deactivate_others:
		dialogue_view.deactivate_all_portraits()
	dialogue_view.activate_portrait(id)
	dialogue_view.input_event.connect(_on_dialogue_input)
	print(dialogue)

func _on_dialogue_input():
	# Clean up signal so it clears itself
	dialogue_view.input_event.disconnect(_on_dialogue_input)
	finished.emit()
