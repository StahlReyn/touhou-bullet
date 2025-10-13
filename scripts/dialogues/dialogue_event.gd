@abstract 
class_name DialogueEvent
extends Resource

@warning_ignore("unused_signal")
signal finished

## Whether waiting for input, as resource cannot process
@export var wait_for_input = true

var dialogue_view: DialogueView

@abstract func run() -> void
