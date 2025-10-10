## For script in making stage.
class_name SectionScript
extends Node

signal section_end

var stage_data_script: StageDataScript

func end_section() -> void:
	section_end.emit()
	call_deferred("queue_free")
