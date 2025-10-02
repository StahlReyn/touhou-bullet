class_name BehaviorItemDrop
extends EntityBehavior

enum State {
	SPREADING,
	FALLING,
	COLLECTING
}

var cur_state: State = State.SPREADING
var spread_time: float = randf_range(0.1, 0.2)
var spread_velocity: Vector2 = MathUtils.get_random_direction_vector() * 400
var fall_velocity: Vector2 = Vector2(0, 400)
var collection_speed: float = 400
var collection_range_squared: float = 150 ^ 2
var player: Player

func on_start(en: Entity) -> void:
	super(en)
	player = GameVariables.player

func entity_process(delta: float) -> void:
	# This is simple enough to do if else statement rather than proper state
	if cur_state == State.SPREADING:
		entity.position += spread_velocity
		if spread_time <= 0:
			cur_state = State.FALLING
		spread_time -= delta
	elif cur_state == State.FALLING:
		entity.position += fall_velocity
		if player.in_collection_range(entity):
			cur_state = State.COLLECTING
	elif cur_state == State.COLLECTING:
		entity.position += entity.position.direction_to(player.position) * collection_speed
	
