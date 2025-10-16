## Stage Data for Script-based sections.
class_name StageDataScript
extends StageDataSection

@export var section_script: GDScript ## Must be extending SectionScript

func run() -> void:
	var node: SectionScript = section_script.new()
	node.controller = controller
	controller.add_child(node)
	
