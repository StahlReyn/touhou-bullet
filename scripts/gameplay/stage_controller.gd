class_name StageController
extends Node

signal stage_ended
signal section_ended
signal chapter_ended ## Specific type of section that displays LOLK style chapter
signal spellcard_started

@export_category("Managers")
@export var game_area: GameArea
@export var dialogue_view: DialogueView
@export var spellcard_displayer: SpellcardDisplayer
@export var game_background: GameBackground
@export_category("Data")
@export var stage_data: StageData
@export var section_number: int = 0

var section_queue: Array[StageDataSection]
var cur_section: StageDataSection

func _ready() -> void:
	GameVariables.game_area = game_area
	print(game_area)

func _physics_process(delta: float) -> void:
	GameVariables.game_time += delta

func run() -> void:
	section_queue = stage_data.sections.duplicate_deep()
	for i in range(stage_data.start_index):
		section_queue.pop_front()
	start_next_section()
	
func start_next_section() -> void:
	print("+ Section Start: ", section_number)
	var section_data: StageDataSection = section_queue.pop_front()
	cur_section = section_data
	section_data.controller = self
	section_data.run()
	section_number += 1

func has_next_section() -> bool:
	return section_queue.size() > 0

# Function below are used by stage data
func end_section() -> void:
	print("- Section Ended")
	section_ended.emit()
	if has_next_section():
		start_next_section()
	else:
		stage_ended.emit()

func end_chapter() -> void:
	chapter_ended.emit()

func start_spellcard(time: float) -> void:
	spellcard_displayer.start_spellcard(time)
	spellcard_started.emit()

func start_nonspellcard(time: float) -> void:
	spellcard_displayer.start_nonspellcard(time)
	spellcard_started.emit()

func transition_stage_scene(scene: PackedScene) -> void:
	game_background.transition_stage_scene(scene)

func _on_game_main_stage_started() -> void:
	run()
