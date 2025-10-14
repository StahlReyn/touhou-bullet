class_name DialogueBubble
extends PanelContainer

signal finished

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
