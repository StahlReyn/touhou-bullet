class_name StageController
extends Node

signal end_stage

@export var stage_data: StageData
@export var section_number: int = 0

func _on_game_view_start_stage() -> void:
	print("++ Stage Start")
	start_next_section()

func _on_section_end() -> void:
	print("- Section End")
	if has_next_section():
		start_next_section()
	else:
		print("-- Stage End")
		end_stage.emit()

func has_next_section() -> bool:
	return section_number < stage_data.data.size()

func start_next_section() -> void:
	print("+ Section Start: ", section_number)
	var section_data: StageDataSection = stage_data.data[section_number]
	section_data.controller = self
	section_data.section_end.connect(_on_section_end)
	section_data.run()
	section_number += 1
