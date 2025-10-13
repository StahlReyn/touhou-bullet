## Stage Data for Dialogue sections
class_name StageDataDialogue
extends StageDataSection

@export var dialogue_events: Array[DialogueEvent]

var cur_event: DialogueEvent
var event_queue: Array[DialogueEvent]
var cur_line: int = 0

func run() -> void:
	event_queue = dialogue_events.duplicate_deep()
	run_next_event()
	
func run_next_event() -> void:
	var event: DialogueEvent = event_queue.pop_front()
	cur_event = event
	cur_event.dialogue_view = controller.dialogue_view
	cur_event.finished.connect(_on_event_finished)
	cur_event.run()
	cur_line += 1

func _on_event_finished() -> void:
	if cur_line < dialogue_events.size():
		run_next_event()
	else:
		controller.dialogue_view.clear_all_portraits()
		section_end.emit()
