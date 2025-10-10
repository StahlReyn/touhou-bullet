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
	section_end.emit()
