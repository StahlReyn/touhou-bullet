class_name SelectionList
extends VBoxContainer
## Styled container, all children should be Margin Container

signal selected(index: int)
signal left_selected(index: int)
signal right_selected(index: int)

@export var margin_deselect: int = 0
@export var margin_select: int = 20
@export var margin_pressed: int = 30
@export var margin_side_pressed: int = 20
@export var modulate_select: Color = Color(1,1,0,1)
@export var modulate_deselect: Color = Color(1,1,1,0.5)
@export var modulate_pressed: Color = Color(1,1,1,1)
@export var margin_increment: float = 30
@export var margin_speed: float = 15

var cur_selection: int = 0
var selected_option: bool = false

func _ready() -> void:
	cur_selection = 0
	reset_display()

func reset_display() -> void:
	for child in get_children():
		if child is MarginContainer:
			child.modulate = modulate_deselect
			child.add_theme_constant_override("margin_left", -10)
				
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		cur_selection -= 1
		cur_selection = wrapi(cur_selection, 0, get_option_count())
		AudioManager.play_move_select()
	elif Input.is_action_just_pressed("move_down"):
		cur_selection += 1
		cur_selection = wrapi(cur_selection, 0, get_option_count())
		AudioManager.play_move_select()
	
	if Input.is_action_just_pressed("shoot"):
		var node = get_children()[cur_selection]
		node.modulate = modulate_pressed
		node.add_theme_constant_override("margin_left", margin_pressed)
		AudioManager.play_select()
		selected.emit(cur_selection)
	elif Input.is_action_just_pressed("move_left"):
		var node: MarginContainer = get_children()[cur_selection]
		node.modulate = modulate_pressed
		node.add_theme_constant_override("margin_left", node.get_theme_constant("margin_left") - margin_side_pressed)
		left_selected.emit(cur_selection)
	elif Input.is_action_just_pressed("move_right"):
		var node: MarginContainer = get_children()[cur_selection]
		node.modulate = modulate_pressed
		node.add_theme_constant_override("margin_left", node.get_theme_constant("margin_left") + margin_side_pressed)
		right_selected.emit(cur_selection)
	
	update_display(delta)

func update_display(delta: float):
	# Update Display
	var margin_index: int = 0
	var cur_margin: int = 0
	var extra_margin: int = 0
	for child in get_children():
		if child is MarginContainer:
			cur_margin = child.get_theme_constant("margin_left")
			extra_margin = margin_increment * margin_index
			if margin_index == cur_selection:
				child.modulate = MathUtils.lerp_smooth(child.modulate, modulate_select, margin_speed, delta)
				child.add_theme_constant_override("margin_left", 
					int(MathUtils.lerp_smooth(cur_margin, margin_select + extra_margin, margin_speed, delta))
				)
			else:
				child.modulate = MathUtils.lerp_smooth(child.modulate, modulate_deselect, margin_speed, delta)
				child.add_theme_constant_override("margin_left", 
					int(MathUtils.lerp_smooth(cur_margin, margin_deselect + extra_margin, margin_speed, delta))
				)
			margin_index += 1
		
func get_option_count() -> int:
	return get_children().size()
