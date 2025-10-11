## Timer that also has entity to refer to
class_name ComponentTimer
extends EntityComponent

@export var timer: Timer
@export var callable: Callable

static func add_to_entity(
	entity_owner: Entity, 
	callable: Callable,
	wait_time: float
) -> ComponentTimer:
	var comp := ComponentTimer.new()
	var new_timer := Timer.new()
	new_timer.autostart = true
	new_timer.wait_time = wait_time
	comp.add_child(new_timer)
	
	comp.entity = entity_owner
	comp.timer = new_timer
	comp.callable = callable
	entity_owner.add_child(comp)
	return comp

func _ready() -> void:
	timer.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	callable.call(entity)
