## Stage Data for Script-based sections.
class_name StageDataScript
extends StageDataSection

@export var section_script: Array[GDScript] ## Must be extending SectionScript
var script_queue: Array[SectionScript]

func run() -> void:
	for script: GDScript in section_script:
		script_queue.push_back(script.new() as SectionScript)
	run_next_script()

func run_next_script():
	print("Run Next Script")
	if script_queue.size() <= 0:
		print("No more Script; Ending Section")
		controller.end_section()
		return
	# Trying to assign value of type '' Error means Wrong script type
	var node: SectionScript = script_queue.pop_front()
	node.stage_data_script = self
	node.controller = controller
	controller.add_child(node)
