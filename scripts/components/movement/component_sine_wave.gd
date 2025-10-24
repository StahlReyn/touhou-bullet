class_name ComponentSineWave
extends EntityComponent

@export var velocity: Vector2 = Vector2.ZERO
@export var wave_velocity: Vector2 = Vector2.ZERO
@export var wave_frequency: float = 1.0
	
var time: float = 0.0

static func add_to_entity(
	entity_owner: Entity, 
	wave_velocity: Vector2 = Vector2.ZERO,
	wave_frequency: float = 1.0,
	velocity: Vector2 = Vector2.ZERO
) -> ComponentSineWave:
	var comp := ComponentSineWave.new()
	comp.entity = entity_owner
	comp.wave_velocity = wave_velocity
	comp.wave_frequency = wave_frequency
	comp.velocity = velocity
	entity_owner.add_child(comp)
	return comp

func _physics_process(delta: float) -> void:
	velocity += cos(time * wave_frequency) * wave_velocity
	entity.position += velocity * delta
	time += delta
