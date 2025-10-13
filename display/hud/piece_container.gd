class_name PieceContainer
extends VBoxContainer

@export var label_text: String = "SYS_SPELLCARD"
@export var label_color: Color = Color.WHITE
@export var icon_count: int = 8
@export var icon_scene: PackedScene

@onready var main_label: Label = $MainContainer/Label
@onready var value_label: Label = $PieceContainer/Value
@onready var pieces_box: HBoxContainer = $MainContainer/Pieces
@onready var divider: Control = $Divider

func _ready() -> void:
	main_label.text = label_text
	main_label.modulate = label_color
	divider.modulate = label_color
	for i in range(icon_count):
		var new_icon: PieceIcon = icon_scene.instantiate()
		pieces_box.add_child(new_icon)

func update_icons(full: int, pieces: int):
	var cur_num: int = 1
	for node: PieceIcon in pieces_box.get_children():
		if cur_num <= full:
			node.main_sprite.frame = 0
		elif cur_num == full + 1:
			node.main_sprite.frame = node.main_sprite.hframes - pieces - 2
		else:
			node.main_sprite.frame = node.main_sprite.hframes - 2
		cur_num += 1
