class_name Player
extends Character

signal respawn_finish

var collection_range_squared: float = 150 ** 2
var state: PlayerState = PlayerState.NORMAL

var invincible: bool = false
var invincible_time: float = 3.0
var invincible_time_length: float = 3.0
var respawn_speed: float = 800
var respawn_y: float = GameUtils.game_area.y - 150
var respawn_pos: Vector2 = Vector2(
	GameUtils.game_area.x * 0.5,
	GameUtils.game_area.y + 40
)

enum PlayerState {
	NORMAL,
	RESPAWNING
}

func _ready() -> void:
	GameVariables.player = self

func _physics_process(delta: float) -> void:
	if invincible:
		modulate.a = cos(invincible_time * 20) * 0.3 + 0.7
		invincible_time -= delta
		if invincible_time < 0:
			invincible_time = 0
			invincible = false
			modulate.a = 1
		
	if state == PlayerState.RESPAWNING:
		position.y -= respawn_speed * delta
		if position.y <= respawn_y:
			position.y = respawn_y
			state = PlayerState.NORMAL
			respawn_finish.emit()

func in_collection_range(entity: Entity):
	return entity.global_position.distance_squared_to(self.global_position) <= collection_range_squared

func kill():
	if not invincible:
		died.emit()
		respawn()

func respawn():
	invincible = true
	position = respawn_pos
	state = PlayerState.RESPAWNING
	invincible_time = invincible_time_length
	
