class_name ComponentItemDropMovement
extends EntityComponent

enum State {
	SPREADING,
	FALLING,
	COLLECTING
}

var cur_state: State = State.SPREADING
var spread_time: float = 0.1
var spread_velocity: Vector2 = MathUtils.randv2_angle() * randf_range(200, 600)
var rotation_velocity: float = 10
var fall_velocity: Vector2 = Vector2(0, 500)
var collection_speed: float = 500
var player: Player

func _ready() -> void:
	player = GameVariables.player

func _physics_process(delta: float) -> void:
	# This is simple enough to do if else statement rather than proper state
	if cur_state == State.SPREADING:
		entity.rotation += rotation_velocity * delta
		entity.global_position += spread_velocity * delta
		if spread_time <= 0:
			cur_state = State.FALLING
			entity.rotation = 0
		spread_time -= delta
	elif cur_state == State.FALLING:
		entity.global_position += fall_velocity * delta
		if player.in_collection_range(entity):
			cur_state = State.COLLECTING
	elif cur_state == State.COLLECTING:
		entity.global_position += entity.global_position.direction_to(player.global_position) * collection_speed * delta
	
