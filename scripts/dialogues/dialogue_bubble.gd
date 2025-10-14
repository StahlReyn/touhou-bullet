class_name DialogueBubble
extends PanelContainer

enum PosType {
	LEFT,
	RIGHT
}

@export var left_control: Control
@export var right_control: Control
@export var arrow: TextureRect
@export var text_label: Label

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func set_type(pos_type: PosType):
	if pos_type == PosType.LEFT:
		left_control.size_flags_stretch_ratio = 0.0
		right_control.size_flags_stretch_ratio = 1.0
		arrow.flip_h = true
		pivot_offset.x = 0
	else:
		left_control.size_flags_stretch_ratio = 1.0
		right_control.size_flags_stretch_ratio = 0.0
		arrow.flip_h = false
		pivot_offset.x = size.x

func set_text(text: String):
	text_label.text = text
	var string_size: Vector2 = text_label.label_settings.font.get_string_size(text_label.text)
	text_label.custom_minimum_size.x = min(string_size.x + 24, text_label.custom_minimum_size.x)
	size.x = string_size.x
