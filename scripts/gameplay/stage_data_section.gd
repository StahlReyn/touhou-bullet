@abstract
## Abstraction for all type of stage data. Has a run command.
class_name StageDataSection
extends Resource

@warning_ignore("unused_signal")
signal section_end

var controller: StageController

@abstract func run() -> void
