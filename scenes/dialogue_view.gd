class_name DialogueView
extends Node2D

enum PortraitPosition {
	LEFT,
	RIGHT
}

signal input_event

static var lerp_speed: float = 30.0

static var modulate_spawn: Color = Color(0, 0, 0, 0)
static var modulate_remove: Color = Color(0, 0, 0, 0)
static var modulate_active: Color = Color(1, 1, 1, 1)
static var modulate_inactive: Color = Color(0.5, 0.5, 0.5, 1)

static var left_pos: Vector2 = Vector2(0, 0)
static var left_gap: Vector2 = Vector2(-150, 50)
static var right_pos: Vector2 = Vector2(1000, 0)
static var right_gap: Vector2 = Vector2(150, 50)

var portraits_left: Array[Portrait]
var portraits_right: Array[Portrait]
var bubbles: Array[DialogueBubble]

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	move_all_portraits(delta)
	if Input.is_action_just_pressed("dialogue"):
		clear_dialogue()
		input_event.emit()

func move_all_portraits(delta: float):
	var target_pos := left_pos
	for portrait in portraits_left:
		move_portrait(portrait, target_pos, delta)
		target_pos += left_gap

	target_pos = right_pos
	for portrait in portraits_right:
		move_portrait(portrait, target_pos, delta)
		target_pos += right_gap
		
func move_portrait(portrait: Portrait, target_pos: Vector2, delta: float) -> void:
	portrait.position = MathUtils.lerp_smooth(portrait.position, target_pos, lerp_speed, delta)
	portrait.modulate = MathUtils.lerp_smooth(portrait.modulate, get_portrait_modulate(portrait), lerp_speed, delta)

func get_portrait_modulate(portrait: Portrait) -> Color:
	if portrait.active:
		return modulate_active
	return modulate_inactive

func add_portrait(portrait: Portrait, pos_type: PortraitPosition) -> void:
	if pos_type == PortraitPosition.RIGHT:
		portraits_right.append(portrait)
		add_child(portrait)
		portrait.position = right_pos + right_gap
		portrait.set_meta("pos_type", PortraitPosition.RIGHT)
	else:
		portraits_left.append(portrait)
		add_child(portrait)
		portrait.position = left_pos + left_gap
		portrait.set_meta("pos_type", PortraitPosition.LEFT)
	portrait.modulate = modulate_spawn
	portrait.active = true

func activate_portrait(id: String) -> Portrait:
	var target_portrait: Portrait = get_portrait_from_id(id)
	if target_portrait == null:
		return null
	target_portrait.active = true
	return target_portrait

func deactivate_all_portraits() -> void:
	for portrait in portraits_left:
		portrait.active = false
	for portrait in portraits_right:
		portrait.active = false

func clear_all_portraits() -> void:
	var target_pos := left_pos + left_gap # move back 1 position while fading
	for portrait in portraits_left:
		portrait.remove(target_pos)
		target_pos += left_gap

	target_pos = right_pos + right_gap
	for portrait in portraits_right:
		portrait.remove(target_pos)
		target_pos += right_gap
	
	# Clear so this view no longer controls it while it frees
	portraits_left.clear()
	portraits_right.clear()

# This should be fine as portrait list are very small, likely only 2 at most
func get_portrait_from_id(id: String) -> Portrait:
	for portrait in portraits_left:
		if portrait.id == id:
			return portrait
	for portrait in portraits_right:
		if portrait.id == id:
			return portrait
	return null

func start_dialogue(id: String, text: String, bubble: DialogueBubble, offset: Vector2 = Vector2.ZERO) -> void:
	var portrait: Portrait = get_portrait_from_id(id)
	if portrait == null:
		return
	portrait.active = true
	bubble.set_text(text)
	add_child(bubble)
	
	var pos_type = portrait.get_meta("pos_type")
	if pos_type == PortraitPosition.LEFT:
		bubble.set_type(DialogueBubble.PosType.LEFT)
		bubble.global_position = portrait.speech_node.global_position + offset
	else:
		bubble.set_type(DialogueBubble.PosType.RIGHT)
		bubble.global_position = portrait.speech_node.global_position + offset
		bubble.global_position.x -= bubble.size.x
	bubbles.append(bubble)

func clear_dialogue():
	for bubble in bubbles:
		bubble.queue_free()
	bubbles.clear()
