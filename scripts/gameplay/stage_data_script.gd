## Stage Data for Script-based sections.
class_name StageDataScript
extends StageDataSection

@export var section_script: GDScript ## Must be extending SectionScript

func run() -> void:
	var node: SectionScript = section_script.new()
	node.stage_data_script = self
	node.section_end.connect(end_section)
	controller.add_child(node)

func end_section():
	call_deferred("despawn_all")
	section_end.emit()
	controller.chapter_ended.emit()

func despawn_all():
	controller.game_area.despawn_enemy_bullets()
	controller.game_area.despawn_enemies()
