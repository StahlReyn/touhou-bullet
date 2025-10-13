class_name StageController
extends Node

signal stage_ended
signal section_ended

@export_category("Managers")
@export var game_area: GameArea
@export var dialogue_view: DialogueView
@export_category("Data")
@export var stage_data: StageData
@export var section_number: int = 0

var section_queue: Array[StageDataSection]
var cur_section: StageDataSection

func _ready() -> void:
	GameVariables.game_area = game_area

func _physics_process(delta: float) -> void:
	GameVariables.game_time += delta

func run() -> void:
	section_queue = stage_data.sections.duplicate_deep()
	start_next_section()
	
func start_next_section() -> void:
	print("+ Section Start: ", section_number)
	var section_data: StageDataSection = section_queue.pop_front()
	cur_section = section_data
	section_data.controller = self
	section_data.section_end.connect(_on_section_end)
	section_data.run()
	section_number += 1

func has_next_section() -> bool:
	return section_queue.size() > 0

func _on_section_end() -> void:
	print("- Section End")
	section_ended.emit()
	# Clean up signal so it clears itself
	cur_section.section_end.disconnect(_on_section_end)
	if has_next_section():
		start_next_section()
	else:
		stage_ended.emit()

func _on_game_main_stage_started() -> void:
	run()
