class_name StageController
extends Node

signal stage_ended
signal section_ended

@export var stage_data: StageData
@export var section_number: int = 0

func start_next_section() -> void:
	print("+ Section Start: ", section_number)
	var section_data: StageDataSection = stage_data.data[section_number]
	section_data.controller = self
	section_data.section_end.connect(_on_section_end)
	section_data.run()
	section_number += 1

func has_next_section() -> bool:
	return section_number < stage_data.data.size()

func _on_section_end() -> void:
	print("- Section End")
	section_ended.emit()
	if has_next_section():
		start_next_section()
	else:
		print("-- Stage End")
		stage_ended.emit()

func _on_game_area_stage_started() -> void:
	print("++ Stage Start")
	start_next_section()
